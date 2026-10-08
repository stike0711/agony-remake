// Die Spieldateien von den drei Original-Disketten (Crack-Fassung „Crystal“) lesen und entpacken.
// Zuordnung Dateinummer → Originalname aus DISK/load_label.s, Ladeadressen aus der Disassembly
// (Wiki dateiformate.md, Abschnitte „Ladeadressen“ und „Original-Diskformat“).

import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { Adf } from "./adf.ts";
import { isPowerPacked, unpackPP20 } from "./powerpacker.ts";

export type GameFileName =
  | "present" | "fire" | "ending" | "igt" | "load_sea" | "sea" | "load_forest" | "forest" | "load_marshes"
  | "marshes" | "load_mountains" | "mountains" | "load_highlands" | "highlands" | "load_fire";

// Quelle: DISK/load_label.s (Dateinummer = Endung von Agony.xx), Diskette laut Crack-Fassung
const FILES: { name: GameFileName; number: number; disk: 1 | 2 | 3 }[] = [
  { name: "present", number: 0x01, disk: 1 },
  { name: "fire", number: 0x02, disk: 1 },
  { name: "ending", number: 0x03, disk: 1 },
  { name: "igt", number: 0x07, disk: 2 },
  { name: "load_sea", number: 0x08, disk: 2 },
  { name: "sea", number: 0x09, disk: 2 },
  { name: "load_forest", number: 0x0a, disk: 2 },
  { name: "forest", number: 0x0b, disk: 2 },
  { name: "load_marshes", number: 0x0c, disk: 2 },
  { name: "marshes", number: 0x0f, disk: 3 },
  { name: "load_mountains", number: 0x10, disk: 3 },
  { name: "mountains", number: 0x11, disk: 3 },
  { name: "load_highlands", number: 0x12, disk: 3 },
  { name: "highlands", number: 0x13, disk: 3 },
  { name: "load_fire", number: 0x14, disk: 3 },
];

/** Lade- und Startadresse: Ladebilder bei $61500, alles andere bei $600 (Quelle: igt $D00–$D48, Speicherabzüge). */
export function loadAddress(name: GameFileName): number {
  return name.startsWith("load_") ? 0x61500 : 0x600;
}

export interface GameFile {
  name: GameFileName;
  /** entpackter Inhalt */
  data: Uint8Array;
  base: number;
  /** Bytes ab einer Amiga-Adresse */
  at(address: number, length: number): Uint8Array;
  /** Datei-Offset einer Amiga-Adresse */
  offset(address: number): number;
}

export interface SourceInfo {
  file: string;
  sha1: string;
}

export class GameDisks {
  readonly sources: SourceInfo[] = [];
  private readonly disks: Adf[] = [];
  private readonly cache = new Map<GameFileName, GameFile>();
  /** Inhalt von Agony.00 (Highscore-Tabelle, ungepackt) */
  readonly highscores: Uint8Array;

  constructor(adfDir: string) {
    for (const n of [1, 2, 3]) {
      const file = join(adfDir, `agony-${n}.adf`);
      const bytes = new Uint8Array(readFileSync(file));
      this.sources.push({ file: `agony-${n}.adf`, sha1: createHash("sha1").update(bytes).digest("hex") });
      this.disks.push(new Adf(bytes));
    }
    this.highscores = this.disks[1]!.readFile("Agony.00");
  }

  get(name: GameFileName): GameFile {
    const cached = this.cache.get(name);
    if (cached) return cached;
    const info = FILES.find((f) => f.name === name);
    if (!info) throw new Error(`unbekannte Spieldatei ${name}`);
    const fileName = `Agony.${info.number.toString(16).toUpperCase().padStart(2, "0")}`;
    const packed = this.disks[info.disk - 1]!.readFile(fileName);
    if (!isPowerPacked(packed)) throw new Error(`${fileName} ist nicht PowerPacker-gepackt`);
    const data = unpackPP20(packed);
    const base = loadAddress(name);
    const file: GameFile = {
      name,
      data,
      base,
      offset: (address) => {
        const off = address - base;
        if (off < 0 || off > data.length) throw new Error(`${name}: Adresse $${address.toString(16)} liegt außerhalb`);
        return off;
      },
      at: (address, length) => {
        const off = file.offset(address);
        if (off + length > data.length) throw new Error(`${name}: $${address.toString(16)} + ${length} liegt außerhalb`);
        return data.subarray(off, off + length);
      },
    };
    this.cache.set(name, file);
    return file;
  }

  static fileNames(): GameFileName[] {
    return FILES.map((f) => f.name);
  }
}
