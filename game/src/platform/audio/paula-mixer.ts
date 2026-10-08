// Klangerzeugung für das Paula-Modell des Kerns: bildet die Audio-DMA der vier Kanäle nach und mischt sie in
// Stereo (Kanal 0 + 3 links, 1 + 2 rechts, wie beim Amiga). Keine Browser-APIs: läuft im AudioWorklet, notfalls
// im Hauptthread (ScriptProcessor) und später auch in der nativen App.
//
// Der Kern liefert pro Takt einen Block („Batch“): alle Registerzugriffe dieses Takts mit ihrem Zeitpunkt plus die
// Dauer des Takts in Farbtakten. Der Mixer spielt den Block ab und wendet jeden Zugriff zu seinem Zeitpunkt an.
// Damit stimmen die Abstände der Ereignisse auf den Farbtakt; die Gesamtverzögerung hält eine kleine Warteschlange
// klein.

import {
  AUD_LC, AUD_LEN, AUD_PER, AUD_VOL, blockBytes, DMAF_AUDIO, DMAF_SETCLR, effectivePeriod, LOG_STRIDE, REG_DMACON,
  REG_POKE,
} from "../../core/paula.ts";
import { PAULA_CLOCK_PAL } from "../../core/timing.ts";

export interface MixerBatch {
  /** [Register, Kanal, Wert, Zeitpunkt] × count (Format von Paula.log) */
  writes: Int32Array;
  count: number;
  /** Dauer des Takts in Farbtakten */
  cc: number;
  /** Spiel steht (Optionsmenü, Hinweis): Stille, Kanäle bleiben stehen */
  frozen: boolean;
}

/** Ab so vielen wartenden Blöcken werden die ältesten ohne Wartezeit übernommen (Verzögerung abbauen). */
const MAX_QUEUE = 6;
/** So viele Blöcke sammeln, bevor nach einem Leerlauf wieder abgespielt wird (Puffer gegen Ruckler). */
const PREBUFFER = 2;

class Channel {
  lc = 0;
  len = 0;
  per = 0;
  vol = 0;
  on = false;
  ptr = 0;
  bytesLeft = 0;
  phase = 0;
  value = 0;
}

export class PaulaMixer {
  private memory: Int8Array = new Int8Array(2);
  private readonly ch = [new Channel(), new Channel(), new Channel(), new Channel()];
  private readonly queue: MixerBatch[] = [];
  private readonly ccPerSample: number;
  /** laufender Block, nächster noch nicht angewandter Zugriff darin und seit Blockbeginn vergangene Farbtakte */
  private current: MixerBatch | null = null;
  private writeIndex = 0;
  private elapsed = 0;
  /** restliche Farbtakte des laufenden Blocks */
  private remaining = 0;
  private frozen = false;
  private waiting = true;
  /** Zähler für die Diagnose */
  underruns = 0;
  dropped = 0;

  constructor(sampleRate: number) {
    this.ccPerSample = PAULA_CLOCK_PAL / sampleRate;
  }

  setMemory(bytes: Int8Array): void {
    this.memory = bytes;
  }

  push(batch: MixerBatch): void {
    this.queue.push(batch);
    while (this.queue.length > MAX_QUEUE) {
      this.finishCurrent();
      this.applyFrom(this.queue.shift()!, 0, Infinity);
      this.dropped++;
    }
  }

  reset(): void {
    this.queue.length = 0;
    this.current = null;
    this.remaining = 0;
    this.waiting = true;
    for (const c of this.ch) c.on = false;
  }

  /** `frames` Stereo-Samples erzeugen (Werte −1 … 1). */
  render(left: Float32Array, right: Float32Array, frames: number): void {
    const mem = this.memory, step = this.ccPerSample;
    const [c0, c1, c2, c3] = this.ch as [Channel, Channel, Channel, Channel];
    for (let i = 0; i < frames; i++) {
      // Kein neuer Block da (Leerlauf): Zustand einfach weiterspielen, ohne künftigen Blöcken Zeit abzuziehen
      if (this.remaining <= 0 && !this.next()) this.remaining = 0;
      const cur = this.current;
      if (cur && this.writeIndex < cur.count) this.writeIndex = this.applyFrom(cur, this.writeIndex, this.elapsed);
      if (this.frozen) {
        left[i] = 0;
        right[i] = 0;
        continue;
      }
      if (this.remaining > 0) {
        this.remaining -= step;
        this.elapsed += step;
      }
      const v0 = this.step(c0, mem, step), v1 = this.step(c1, mem, step);
      const v2 = this.step(c2, mem, step), v3 = this.step(c3, mem, step);
      // je Seite zwei Kanäle à höchstens 128 × 64 → auf ±1 normieren
      left[i] = (v0 + v3) / 16384;
      right[i] = (v1 + v2) / 16384;
    }
  }

  private next(): boolean {
    if (this.waiting) {
      if (this.queue.length < PREBUFFER) return false;
      this.waiting = false;
    }
    const batch = this.queue.shift();
    if (!batch) {
      this.underruns++;
      this.waiting = true;
      return false;
    }
    this.finishCurrent();
    this.current = batch;
    this.writeIndex = 0;
    // Überhang des vorigen Blocks (remaining ≤ 0) zählt schon zum neuen
    this.elapsed = -this.remaining;
    this.frozen = batch.frozen;
    this.remaining += batch.cc;
    return true;
  }

  /** Restliche Zugriffe des laufenden Blocks anwenden (Block endet). */
  private finishCurrent(): void {
    if (this.current && this.writeIndex < this.current.count) this.applyFrom(this.current, this.writeIndex, Infinity);
    this.current = null;
  }

  /** Zugriffe ab `index` anwenden, deren Zeitpunkt ≤ `until` ist; liefert den Index des nächsten. */
  private applyFrom(batch: MixerBatch, index: number, until: number): number {
    const w = batch.writes;
    for (; index < batch.count; index++) {
      const i = index * LOG_STRIDE;
      if (w[i + 3]! > until) break;
      const reg = w[i]!, n = w[i + 1]!, value = w[i + 2]!;
      if (reg === REG_POKE) {
        if (n >= 0 && n < this.memory.length) this.memory[n] = value;
        continue;
      }
      const c = this.ch[n]!;
      switch (reg) {
        case AUD_LC: c.lc = value & ~1; break;
        case AUD_LEN: c.len = value & 0xffff; break;
        case AUD_PER: c.per = value & 0xffff; break;
        case AUD_VOL: c.vol = Math.min(value & 0x7f, 64); break;
        case REG_DMACON: this.dmacon(value); break;
      }
    }
    return index;
  }

  private dmacon(value: number): void {
    for (let n = 0; n < 4; n++) {
      if ((value & DMAF_AUDIO & (1 << n)) === 0) continue;
      const c = this.ch[n]!;
      if (value & DMAF_SETCLR) {
        if (!c.on) {
          c.on = true;
          this.load(c);
        }
      } else {
        c.on = false;
        c.value = 0;
      }
    }
  }

  private load(c: Channel): void {
    c.ptr = c.lc;
    c.bytesLeft = blockBytes(c.len);
    c.phase = 0;
    c.value = this.memory[c.ptr] ?? 0;
  }

  /** Kanal um `cc` Farbtakte weiterzählen; liefert den Ausgabewert (Sample × Lautstärke). */
  private step(c: Channel, mem: Int8Array, cc: number): number {
    if (!c.on) return 0;
    const per = effectivePeriod(c.per);
    c.phase += cc;
    while (c.phase >= per) {
      c.phase -= per;
      c.ptr++;
      if (--c.bytesLeft <= 0) {
        c.ptr = c.lc;
        c.bytesLeft = blockBytes(c.len);
      }
      c.value = mem[c.ptr] ?? 0;
    }
    return c.value * c.vol;
  }
}
