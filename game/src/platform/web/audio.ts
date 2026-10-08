// Ton im Browser: Web Audio mit dem Paula-Mixer im AudioWorklet. Ohne AudioWorklet (z. B. unsichere Verbindung
// per http:// im Heimnetz) läuft derselbe Mixer im Hauptthread über einen ScriptProcessorNode.
// Der AudioContext entsteht erst bei der ersten Nutzeraktion (Autoplay-Regeln, vor allem iOS).

import workletUrl from "./paula-worklet.ts?worker&url";
import { PaulaMixer } from "../audio/paula-mixer.ts";
import { LOG_STRIDE } from "../../core/paula.ts";
import type { AudioOutput } from "../types.ts";

/** Puffergröße des Notbehelfs im Hauptthread (Frames, ≈ 21 ms bei 48 kHz) */
const SCRIPT_BUFFER = 1024;

export class WebAudio implements AudioOutput {
  private ctx: AudioContext | null = null;
  private worklet: AudioWorkletNode | null = null;
  private fallback: PaulaMixer | null = null;
  private memory: Int8Array | null = null;
  private ready = false;
  private active = true;

  unlock(): void {
    if (!this.ctx) {
      const Ctor = window.AudioContext ?? (window as unknown as { webkitAudioContext?: typeof AudioContext }).webkitAudioContext;
      if (!Ctor) return;
      this.ctx = new Ctor({ latencyHint: "interactive" });
      void this.connect(this.ctx);
    }
    // iOS: Kontext kann „suspended“ oder „interrupted“ sein und braucht resume() in der Nutzeraktion
    if (this.active && this.ctx.state !== "running") void this.ctx.resume();
  }

  setMemory(bytes: Int8Array): void {
    this.memory = bytes;
    this.sendMemory();
  }

  submit(writes: Int32Array, count: number, cc: number, frozen: boolean): void {
    if (!this.ready) return;
    const batch = { writes: writes.slice(0, count * LOG_STRIDE), count, cc, frozen };
    if (this.worklet) this.worklet.port.postMessage({ type: "batch", ...batch }, [batch.writes.buffer]);
    else this.fallback?.push(batch);
  }

  setActive(active: boolean): void {
    this.active = active;
    if (!this.ctx) return;
    if (active) void this.ctx.resume();
    else void this.ctx.suspend();
    // Alte Blöcke verwerfen, damit nach dem Fortsetzen keine Verzögerung bleibt
    if (this.worklet) this.worklet.port.postMessage({ type: "reset" });
    else this.fallback?.reset();
    // Verworfene Blöcke können Schreibzugriffe auf den Sample-Speicher enthalten: Speicher neu abgleichen
    this.sendMemory();
  }

  private async connect(ctx: AudioContext): Promise<void> {
    try {
      if (!ctx.audioWorklet) throw new Error("kein AudioWorklet");
      await ctx.audioWorklet.addModule(workletUrl);
      this.worklet = new AudioWorkletNode(ctx, "paula", { numberOfInputs: 0, outputChannelCount: [2] });
      this.worklet.connect(ctx.destination);
    } catch (e) {
      console.warn("AudioWorklet nicht verfügbar, Ton läuft im Hauptthread:", e);
      const mixer = new PaulaMixer(ctx.sampleRate);
      const node = ctx.createScriptProcessor(SCRIPT_BUFFER, 0, 2);
      node.onaudioprocess = (ev) => {
        const out = ev.outputBuffer;
        mixer.render(out.getChannelData(0), out.getChannelData(1), out.length);
      };
      node.connect(ctx.destination);
      this.fallback = mixer;
    }
    this.ready = true;
    this.sendMemory();
  }

  private sendMemory(): void {
    if (!this.ready || !this.memory) return;
    // Immer eine Kopie: Der Mixer ändert seinen Speicher erst zum Zeitpunkt der Schreibzugriffe im Protokoll
    if (this.worklet) this.worklet.port.postMessage({ type: "memory", bytes: this.memory.slice() });
    else this.fallback?.setMemory(this.memory.slice());
  }
}
