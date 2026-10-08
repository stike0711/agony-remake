// Ablaufspuren aus dem Referenz-Emulator (AG.traceRun, Wiki setup.md): je Emulator-Bild ausgewählte Speicherwörter
// und die Farbe eines Bildpunkts. Liegen in work/captures/ (nicht im Projekt verteilt); fehlen sie, überspringen die
// Tests, die sie brauchen.

import { existsSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const CAPTURES = join(dirname(fileURLToPath(import.meta.url)), "../../work/captures");

export function hasTrace(name: string): boolean {
  return existsSync(join(CAPTURES, `${name}.trace.json`));
}

export class Trace {
  readonly rows = new Map<number, number[]>();
  /** Spalte des ersten Worts jeder Adresse */
  private readonly columns = new Map<number, number>();

  constructor(name: string) {
    const data = JSON.parse(readFileSync(join(CAPTURES, `${name}.trace.json`), "utf8")) as {
      words: [number, number][];
      rows: number[][];
    };
    let col = 2;
    for (const [address, count] of data.words) {
      for (let k = 0; k < count; k++) if (!this.columns.has(address + 2 * k)) this.columns.set(address + 2 * k, col + k);
      col += count;
    }
    // Bei Sprüngen der Bildnummer (Emulator-Neustart) gilt der erste Lauf
    for (const row of data.rows) if (!this.rows.has(row[0]!)) this.rows.set(row[0]!, row);
  }

  /** Wort an `address` im Bild `frame` (nach dessen Ende) */
  word(frame: number, address: number): number {
    const row = this.rows.get(frame), col = this.columns.get(address);
    if (!row || col === undefined) throw new Error(`Spur: Bild ${frame} / Adresse $${address.toString(16)} fehlt`);
    return row[col]!;
  }

  long(frame: number, hi: number, lo: number): number {
    return ((this.word(frame, hi) << 16) | this.word(frame, lo)) >>> 0;
  }

  /** Byte an `address` (gerade = oberes Byte des Worts) */
  byte(frame: number, address: number): number {
    const w = this.word(frame, address & ~1);
    return address & 1 ? w & 0xff : w >> 8;
  }

  /** Farbe des Bildpunkts als 12-Bit-Amiga-Farbe (gerundet: der Emulator liefert z. B. $2F statt $30, W-005) */
  pixel(frame: number): number {
    const row = this.rows.get(frame);
    if (!row) throw new Error(`Spur: Bild ${frame} fehlt`);
    const rgb = row[1]!;
    const c = (shift: number): number => Math.min(15, (((rgb >> shift) & 0xff) + 8) >> 4);
    return (c(16) << 8) | (c(8) << 4) | c(0);
  }
}
