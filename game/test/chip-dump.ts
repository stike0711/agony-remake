// Speicherabzüge des Referenz-Emulators (AG.dump): Chip-RAM als Datei in work/captures/ (nicht verteilt).

import { existsSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

export const CAPTURES = join(dirname(fileURLToPath(import.meta.url)), "../../work/captures");

export function hasDump(name: string): boolean {
  return existsSync(join(CAPTURES, name));
}

export function loadDump(name: string): Uint8Array {
  return new Uint8Array(readFileSync(join(CAPTURES, name)));
}

/** Bitplanes nacheinander (je `rowBytes` × `height` Byte) → ein Farbindex je Pixel. */
export function decodePlanes(chip: Uint8Array, addr: number, rowBytes: number, height: number, planes: number): Uint8Array {
  const out = new Uint8Array(rowBytes * 8 * height);
  for (let p = 0; p < planes; p++) {
    const base = addr + p * rowBytes * height;
    for (let i = 0; i < rowBytes * height; i++) {
      const b = chip[base + i]!;
      for (let bit = 0; bit < 8; bit++) if (b & (0x80 >> bit)) out[i * 8 + bit]! |= 1 << p;
    }
  }
  return out;
}
