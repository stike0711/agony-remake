// Hires-Aufnahmen aus dem Referenz-Emulator (AG.recordHires, Wiki setup.md): rohe RGB-Bilder eines Ausschnitts,
// Dateiname <name>_<b>x<h>_<anzahl>_every<abstand>_from<bild>_at<x>x<y>.rgb in work/captures/. Fehlen sie,
// überspringen die Tests, die sie brauchen.

import { closeSync, existsSync, openSync, readdirSync, readSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const CAPTURES = join(dirname(fileURLToPath(import.meta.url)), "../../work/captures");
const PATTERN = /^(.+)_(\d+)x(\d+)_(\d+)_every(\d+)_from(\d+)_at(\d+)x(\d+)\.rgb$/;

interface Part {
  file: string;
  from: number;
  count: number;
  every: number;
}

/** Alle Teile einer Hires-Aufnahme (mehrere Dateien mit demselben Namen setzen sich fort) */
export class HiresCapture {
  readonly width: number;
  readonly height: number;
  /** Ausschnitt: x in Hires-Texeln der 912 Texel breiten Emulatorzeile, y = Rasterzeile */
  readonly x: number;
  readonly y: number;
  private readonly parts: Part[] = [];
  private readonly buffer: Uint8Array;
  private loaded = -1;

  static exists(name: string): boolean {
    return existsSync(CAPTURES) && readdirSync(CAPTURES).some((f) => PATTERN.exec(f)?.[1] === name);
  }

  constructor(name: string) {
    let size: number[] | null = null;
    for (const f of readdirSync(CAPTURES)) {
      const m = PATTERN.exec(f);
      if (!m || m[1] !== name) continue;
      const [w, h, count, every, from, x, y] = m.slice(2).map(Number) as [number, number, number, number, number, number, number];
      size ??= [w, h, x, y];
      this.parts.push({ file: join(CAPTURES, f), from, count, every });
    }
    if (!size) throw new Error(`Aufnahme ${name} fehlt`);
    [this.width, this.height, this.x, this.y] = size as [number, number, number, number];
    this.buffer = new Uint8Array(this.width * this.height * 3);
  }

  /** Bild `frame` (Emulator-Bildnummer) laden; false, wenn es nicht aufgenommen ist */
  load(frame: number): boolean {
    if (frame === this.loaded) return true;
    for (const p of this.parts) {
      const i = frame - p.from;
      if (i < 0 || i % p.every !== 0 || i / p.every >= p.count) continue;
      const fd = openSync(p.file, "r");
      readSync(fd, this.buffer, 0, this.buffer.length, (i / p.every) * this.buffer.length);
      closeSync(fd);
      this.loaded = frame;
      return true;
    }
    return false;
  }

  /** 12-Bit-Farbe an Hires-Texel `tx` der Emulatorzeile und Rasterzeile `v` (gerundet wie Trace.pixel) */
  color(tx: number, v: number): number {
    const i = ((v - this.y) * this.width + tx - this.x) * 3;
    const b = this.buffer;
    return (Math.min(15, (b[i]! + 8) >> 4) << 8) | (Math.min(15, (b[i + 1]! + 8) >> 4) << 4) | Math.min(15, (b[i + 2]! + 8) >> 4);
  }
}
