// Spieldaten im Speicher: aus manifest.json und den Binärdateien der Asset-Pipeline aufbereitet.
// Plattformneutral: Das Laden der Dateien (fetch, Dateisystem …) übernimmt der Aufrufer.

import { MANIFEST_FORMAT, type Manifest, type TextLine } from "../data/manifest.ts";
import { ChipMemory } from "./chipmem.ts";
import type { IndexedImage } from "./display.ts";
import { Font } from "./text.ts";

export interface Sample {
  /** Adresse im Sample-Speicher (wie eine Chip-RAM-Adresse für AUDxLC) */
  readonly address: number;
  /** Länge in Byte */
  readonly length: number;
}

export interface ProtrackerModule {
  readonly name: string;
  readonly data: Uint8Array;
  /** Adresse im Sample-Speicher (wie die Ladeadresse im Chip-RAM) */
  readonly address: number;
}

/**
 * Freiraum hinter jedem Modul im Sample-Speicher: mt_init löscht das erste Langwort jedes Samples, auch der leeren
 * am Modulende – also 4 Byte hinter dem Modul (O-001). Im Original liegt dort das Bild, hier bleibt Platz.
 */
export const MODULE_PADDING = 4;

/** Speicherblock eines Levels mit seiner Originaladresse (E-032) */
export interface MemoryBlock {
  readonly address: number;
  readonly data: Uint8Array;
}

export interface GameAssets {
  readonly images: ReadonlyMap<string, IndexedImage>;
  readonly fonts: ReadonlyMap<string, Font>;
  /** Englische Originaltexte samt Positionen */
  readonly texts: ReadonlyMap<string, readonly TextLine[]>;
  readonly samples: ReadonlyMap<string, Sample>;
  readonly modules: ReadonlyMap<string, ProtrackerModule>;
  readonly tables: ReadonlyMap<string, readonly number[]>;
  readonly highscores: Manifest["highscores"];
  /** Alle Samples und Module hintereinander; Paula und der Mixer der Plattform lesen daraus */
  readonly chip: ChipMemory;
  /** Speicherblöcke der Level, Schlüssel „<level>.<block>“ */
  readonly memory: ReadonlyMap<string, MemoryBlock>;
}

/** Alle Dateinamen, die `buildAssets` braucht (relativ zum Datenordner). */
export function assetFiles(manifest: Manifest): string[] {
  return [
    ...Object.values(manifest.images).map((i) => i.file),
    ...Object.values(manifest.fonts).map((f) => f.file),
    ...Object.values(manifest.samples).map((s) => s.file),
    ...Object.values(manifest.modules).map((m) => m.file),
    ...Object.values(manifest.memory).map((m) => m.file),
  ];
}

export function buildAssets(manifest: Manifest, files: ReadonlyMap<string, Uint8Array>): GameAssets {
  if (manifest.format !== MANIFEST_FORMAT) {
    throw new Error(`Spieldaten haben Format ${String(manifest.format)}, erwartet ${MANIFEST_FORMAT}: Asset-Pipeline neu ausführen`);
  }
  const file = (name: string, size: number): Uint8Array => {
    const data = files.get(name);
    if (!data) throw new Error(`Spieldatei fehlt: ${name}`);
    if (data.length !== size) throw new Error(`Spieldatei ${name}: ${data.length} statt ${size} Byte`);
    return data;
  };

  const images = new Map<string, IndexedImage>();
  for (const [key, a] of Object.entries(manifest.images)) {
    images.set(key, {
      width: a.width,
      height: a.height,
      pixels: file(a.file, a.width * a.height),
      palette: Uint16Array.from(a.palette),
      ehb: a.ehb === true,
    });
  }

  const fonts = new Map<string, Font>();
  for (const [key, f] of Object.entries(manifest.fonts)) {
    fonts.set(key, new Font(f, file(f.file, f.count * f.cellWidth * f.cellHeight)));
  }

  const sampleBytes = Object.values(manifest.samples).reduce((n, s) => n + ((s.length + 1) & ~1), 0) +
    Object.values(manifest.modules).reduce((n, m) => n + ((m.length + MODULE_PADDING + 1) & ~1), 0);
  const chip = new ChipMemory(sampleBytes);
  const samples = new Map<string, Sample>();
  for (const [key, s] of Object.entries(manifest.samples)) {
    samples.set(key, { address: chip.store(file(s.file, s.length)), length: s.length });
  }

  const modules = new Map<string, ProtrackerModule>();
  for (const [key, m] of Object.entries(manifest.modules)) {
    const data = file(m.file, m.length);
    modules.set(key, { name: m.name, data, address: chip.store(data, MODULE_PADDING) });
  }

  const memory = new Map<string, MemoryBlock>();
  for (const [key, m] of Object.entries(manifest.memory)) {
    memory.set(key, { address: m.address, data: file(m.file, m.length) });
  }

  return {
    images,
    fonts,
    texts: new Map(Object.entries(manifest.texts)),
    samples,
    modules,
    tables: new Map(Object.entries(manifest.tables)),
    highscores: manifest.highscores,
    chip,
    memory,
  };
}
