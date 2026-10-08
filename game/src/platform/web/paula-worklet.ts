// AudioWorklet: lässt den Paula-Mixer im Audio-Thread laufen. Nachrichten vom Hauptthread:
//   { type: "memory", bytes: Int8Array }   Sample-Speicher (beim Start und nach jedem Zurücksetzen)
//   { type: "batch", writes, count, cc, frozen }   Registerzugriffe mit Zeitpunkt und Dauer eines Takts
//   { type: "reset" }

import { type MixerBatch, PaulaMixer } from "../audio/paula-mixer.ts";

// Typen der AudioWorklet-Umgebung (nicht in den DOM-Typen von TypeScript enthalten)
declare const sampleRate: number;
declare class AudioWorkletProcessor {
  readonly port: MessagePort;
}
declare function registerProcessor(name: string, ctor: new () => AudioWorkletProcessor): void;

type Message = { type: "memory"; bytes: Int8Array } | ({ type: "batch" } & MixerBatch) | { type: "reset" };

class PaulaProcessor extends AudioWorkletProcessor {
  private readonly mixer = new PaulaMixer(sampleRate);

  constructor() {
    super();
    this.port.onmessage = (e: MessageEvent<Message>) => {
      const m = e.data;
      if (m.type === "memory") this.mixer.setMemory(m.bytes);
      else if (m.type === "batch") this.mixer.push(m);
      else this.mixer.reset();
    };
  }

  process(_inputs: Float32Array[][], outputs: Float32Array[][]): boolean {
    const out = outputs[0];
    if (out && out.length >= 2) this.mixer.render(out[0]!, out[1]!, out[0]!.length);
    return true;
  }
}

registerProcessor("paula", PaulaProcessor);
