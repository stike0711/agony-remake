// Replays: Eingaben pro Takt aufzeichnen und wieder abspielen. Weil der Kern deterministisch ist, ergibt dieselbe
// Eingabefolge immer denselben Zustand; Replays dienen deshalb als Regressionstests und später zum Prüfen jeder
// Portierung.

import { InputFrame, NO_TAP } from "./input.ts";

export class ReplayRecorder {
  private buttons = new Uint8Array(4096);
  private taps = new Int16Array(8192);
  length = 0;

  record(input: InputFrame): void {
    if (this.length === this.buttons.length) this.grow();
    this.buttons[this.length] = input.buttons;
    this.taps[this.length * 2] = input.tapX;
    this.taps[this.length * 2 + 1] = input.tapY;
    this.length++;
  }

  finish(): Replay {
    return new Replay(this.buttons.slice(0, this.length), this.taps.slice(0, this.length * 2));
  }

  private grow(): void {
    const b = new Uint8Array(this.buttons.length * 2);
    b.set(this.buttons);
    const t = new Int16Array(this.taps.length * 2);
    t.set(this.taps);
    this.buttons = b;
    this.taps = t;
  }
}

export class Replay {
  readonly buttons: Uint8Array;
  readonly taps: Int16Array;

  constructor(buttons: Uint8Array, taps: Int16Array) {
    this.buttons = buttons;
    this.taps = taps;
  }

  get length(): number {
    return this.buttons.length;
  }

  /** Eingabe von Takt `tick` in `out` schreiben (nach dem Ende: keine Eingabe). */
  read(tick: number, out: InputFrame): void {
    if (tick >= this.buttons.length) {
      out.clear();
      return;
    }
    out.buttons = this.buttons[tick]!;
    out.tapX = this.taps[tick * 2]!;
    out.tapY = this.taps[tick * 2 + 1]!;
  }

  /** Kurzform für Tests: Liste von [Takt, Tasten] – die Tasten gelten ab diesem Takt. */
  static fromChanges(length: number, changes: readonly (readonly [number, number])[]): Replay {
    const buttons = new Uint8Array(length);
    for (const [tick, value] of changes) buttons.fill(value, tick);
    return new Replay(buttons, new Int16Array(length * 2).fill(NO_TAP));
  }
}

/** Prüfsumme (FNV-1a, 32 Bit) über Bild und Paletten – für Replay-Tests. */
export function displayChecksum(pixels: Uint8Array, palette: Uint16Array, pixelCount: number, paletteCount: number): number {
  let h = 0x811c9dc5;
  for (let i = 0; i < pixelCount; i++) h = Math.imul(h ^ pixels[i]!, 0x01000193);
  for (let i = 0; i < paletteCount; i++) h = Math.imul(h ^ palette[i]!, 0x01000193);
  return h >>> 0;
}
