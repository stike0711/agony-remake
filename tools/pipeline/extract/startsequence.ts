// Assets der Startsequenz: Titelsequenz (present), Menü (igt), Ladebilder (load_sea, load_forest, load_marshes),
// Highscores (Agony.00).
// Adressen und Formate: Wiki dateiformate.md; Abläufe: Wiki original/startsequenz.md.

import type { FontAsset, HighscoreEntry, ImageAsset, ModuleAsset, SampleAsset, TextLine } from "../../../game/src/data/manifest.ts";
import type { GameDisks, GameFile } from "../lib/gamefiles.ts";
import { decodePlanar, readPalette } from "../lib/planar.ts";
import { applyMtInit, moduleInfo } from "../lib/protracker.ts";

/** Wohin die Pipeline Binärdateien schreibt; liefert den Dateinamen relativ zu data/. */
export interface Sink {
  write(path: string, data: Uint8Array): string;
}

export interface Extracted {
  images: Record<string, ImageAsset>;
  fonts: Record<string, FontAsset>;
  texts: Record<string, TextLine[]>;
  samples: Record<string, SampleAsset>;
  modules: Record<string, ModuleAsset>;
  highscores: HighscoreEntry[];
  tables: Record<string, number[]>;
  /** Indizes und Paletten für Vorschaubilder */
  previews: { key: string; width: number; height: number; indices: Uint8Array; palette: number[]; ehb: boolean }[];
}

const hex = (n: number): string => "$" + n.toString(16).toUpperCase().padStart(5, "0");

function word(data: Uint8Array, offset: number): number {
  return (data[offset]! << 8) | data[offset + 1]!;
}

function image(
  out: Extracted, sink: Sink, key: string, file: GameFile, mem: Uint8Array,
  address: number, width: number, height: number, planes: number, paletteAddress: number, colors: number, ehb: boolean,
): void {
  const indices = decodePlanar(mem, file.offset(address), { width, height, planes });
  const palette = readPalette(mem, file.offset(paletteAddress), colors);
  const name = sink.write(`img/${key}.idx`, indices);
  out.images[key] = { file: name, width, height, palette, ...(ehb ? { ehb } : {}), source: `${file.name} ${hex(address)}` };
  out.previews.push({ key, width, height, indices, palette, ehb });
}

function sample(out: Extracted, sink: Sink, key: string, file: GameFile, address: number, words: number): void {
  const data = file.at(address, words * 2);
  out.samples[key] = { file: sink.write(`snd/${key}.s8`, data), length: data.length, source: `${file.name} ${hex(address)}` };
}

function module(out: Extracted, sink: Sink, key: string, file: GameFile, address: number): void {
  const off = file.offset(address);
  const info = moduleInfo(file.data, off);
  const data = file.data.subarray(off, off + info.length);
  out.modules[key] = { file: sink.write(`mod/${key}.mod`, data), name: info.name, length: info.length, source: `${file.name} ${hex(address)}` };
}

// ---- Titelsequenz (present, Basis $600) --------------------------------------------------------------

function extractPresent(out: Extracted, sink: Sink, disks: GameDisks): void {
  const f = disks.get("present");
  // Bilder: Hires-Interlace, 640 Pixel breit, 4 Planes nacheinander, direkt dahinter 16 Farben.
  // Quelle: Bitplane-Zeiger und Paletten im Code von present ($6C0–$B7E), Wiki dateiformate.md „Präsentation“
  const titles: [string, number, number][] = [
    ["title.psygnosis", 0x01548, 240],
    ["title.stereo", 0x14168, 58],
    ["title.artmagic", 0x18a08, 160],
    ["title.agony", 0x25228, 256],
    ["title.texts", 0x39248, 70],
  ];
  for (const [key, address, height] of titles) {
    image(out, sink, key, f, f.data, address, 640, height, 4, address + 4 * 80 * height, 16, false);
  }

  // Feuerband: Farben aus der Copperliste $10EA (MOVE COLOR01 zwischen den WAITs), Startzähler bei $14D6
  const band: number[] = [];
  for (let p = f.offset(0x1112); ; p += 4) {
    const a = word(f.data, p);
    const b = word(f.data, p + 2);
    if (a === 0xffff && b === 0xfffe) break;
    if (a === 0x0182) band.push(b & 0xfff);
  }
  if (band.length !== 54) throw new Error(`Feuerband: ${band.length} statt 54 Farben`);
  out.tables["title.bandColors"] = band;
  out.tables["title.bandCounters"] = Array.from({ length: 53 }, (_, i) => word(f.data, f.offset(0x14d6) + 2 * i));

  // Samples. Quelle: Audio-Registerzugriffe in present ($730–$CDE)
  sample(out, sink, "title.a", f, 0x3eef8, 0x5799);
  sample(out, sink, "title.b", f, 0x49e3a, 0x5799);
  sample(out, sink, "title.c", f, 0x54d90, 0x4301);
  sample(out, sink, "title.d", f, 0x60a96, 0x2c5e);
  sample(out, sink, "title.e", f, 0x5d3d6, 0x1b4d);
}

// ---- Menü (igt, Basis $600) ----------------------------------------------------------------------

/** Zeichen der Menüschrift in Code-Reihenfolge ($00–$29); danach die per Skript ergänzten Zeichen (E-021, E-023). */
export const MENU_FONT_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:()◄ ";
const MENU_FONT_EXTRA = "ÄÖÜ,-";
const ORIGINAL_GLYPHS = 42;
const GLYPH_ROWS = 21; // je Zeichen 84 Byte = 21 Zeilen × 32 Pixel
const CELL_TOP = 6; // Platz über dem Original für Umlautpunkte
const CELL_HEIGHT = CELL_TOP + GLYPH_ROWS + 2; // + 2 Zeilen für den Kommaschweif

// Punkt für Umlaute, Komma und Bindestrich, gezeichnet im Stil der Schrift (Strichstärke, Punktform)
const UMLAUT_DOT = [".##.", "####", ".##."];
const COMMA = [".###.", "#####", ".####", "...##", "..##.", ".#..."]; // ab Zeile 16 (wie der Punkt)
const HYPHEN = ["#######", "#######"]; // Zeilen 11–12, Höhe des mittleren Doppelpunkt-Punkts

const TEXT_KEYS = [
  ...Array.from({ length: 12 }, (_, i) => `credits.${i}`),
  "story.start",
  "hiscore.enter",
  "hiscore.writeProtect",
];

function extractMenu(out: Extracted, sink: Sink, disks: GameDisks): void {
  const f = disks.get("igt");
  const mem = f.data.slice();
  applyMtInit(mem, f.offset(0x30e4)); // wie im Speicher nach mt_init (O-001; ändert hier nichts Sichtbares)

  // Menübild 352 × 290, EHB; Palette 32 Farben. Quelle: igt $6E2 (Bild $2EEA6), Palette $419B6 ($E1E)
  image(out, sink, "menu.background", f, mem, 0x2eea6, 352, 290, 6, 0x419b6, 32, true);
  module(out, sink, "menu", f, 0x30e4);

  // Tabellen des ProTracker-Abspielers (in igt und load_sea byte-gleich). Quelle: igt mt_music $1E70,
  // Funk-Tabelle $2AEA (16 Byte), Vibrato-Sinus $2AFA (32 Byte), Periodentabelle $2B1A (16 Finetunes × 36 Wörter)
  out.tables["pt.funk"] = Array.from(f.at(0x2aea, 16));
  out.tables["pt.sine"] = Array.from(f.at(0x2afa, 32));
  out.tables["pt.periods"] = Array.from({ length: 16 * 36 }, (_, i) => word(f.data, f.offset(0x2b1a) + 2 * i));
  if (out.tables["pt.periods"][0] !== 856 || out.tables["pt.periods"][35] !== 113) throw new Error("igt: Periodentabelle nicht gefunden");

  // Schrift: 42 Zeichen × 84 Byte ab $41BB6, Breiten ab $4297E. Quelle: igt $1030 (Blitter-Zeichenroutine)
  const fontAt = f.offset(0x41bb6);
  const widths = Array.from(f.at(0x4297e, ORIGINAL_GLYPHS));
  const count = ORIGINAL_GLYPHS + MENU_FONT_EXTRA.length;
  const cellWidth = 32;
  const sheet = new Uint8Array(count * cellWidth * CELL_HEIGHT);
  const sheetWidth = count * cellWidth;
  const set = (glyph: number, x: number, row: number): void => {
    sheet[(CELL_TOP + row) * sheetWidth + glyph * cellWidth + x] = 1;
  };
  const glyphPixel = (glyph: number, x: number, row: number): boolean =>
    ((((f.data[fontAt + glyph * 84 + row * 4]! << 24) | (f.data[fontAt + glyph * 84 + row * 4 + 1]! << 16) |
      (f.data[fontAt + glyph * 84 + row * 4 + 2]! << 8) | f.data[fontAt + glyph * 84 + row * 4 + 3]!) >>> (31 - x)) & 1) === 1;
  for (let g = 0; g < ORIGINAL_GLYPHS; g++) {
    for (let row = 0; row < GLYPH_ROWS; row++) for (let x = 0; x < 32; x++) if (glyphPixel(g, x, row)) set(g, x, row);
  }
  const draw = (glyph: number, shape: string[], x0: number, row0: number): void => {
    shape.forEach((line, r) => [...line].forEach((ch, x) => ch === "#" && set(glyph, x0 + x, row0 + r)));
  };
  // Ä, Ö, Ü: Grundbuchstabe plus zwei Punkte über der Mitte der Tinte
  for (const [i, base] of [[0, "A"], [1, "O"], [2, "U"]] as const) {
    const g = ORIGINAL_GLYPHS + i;
    const b = MENU_FONT_CHARS.indexOf(base);
    let minX = 32;
    let maxX = -1;
    for (let row = 0; row < GLYPH_ROWS; row++) {
      for (let x = 0; x < 32; x++) {
        if (glyphPixel(b, x, row)) {
          set(g, x, row);
          minX = Math.min(minX, x);
          maxX = Math.max(maxX, x);
        }
      }
    }
    const center = Math.round((minX + maxX) / 2);
    draw(g, UMLAUT_DOT, center - 6, -5);
    draw(g, UMLAUT_DOT, center + 2, -5);
    widths.push(widths[b]!);
  }
  draw(ORIGINAL_GLYPHS + 3, COMMA, 0, 16);
  widths.push(widths[MENU_FONT_CHARS.indexOf(".")]!);
  draw(ORIGINAL_GLYPHS + 4, HYPHEN, 0, 11);
  widths.push(8);

  out.fonts["menu"] = {
    file: sink.write("font/menu.idx", sheet),
    cellWidth,
    cellHeight: CELL_HEIGHT,
    count,
    chars: MENU_FONT_CHARS + MENU_FONT_EXTRA,
    widths,
    originRow: CELL_TOP,
    originalCount: ORIGINAL_GLYPHS,
    drawRows: 20, // Quelle: igt $109C, BLTSIZE $503 = 20 Zeilen
    source: `igt ${hex(0x41bb6)}`,
  };
  out.previews.push({ key: "font.menu", width: sheetWidth, height: CELL_HEIGHT, indices: sheet, palette: [0x000, 0xfff], ehb: false });

  // Texttabelle: 15 Seiten ab $429A8 (Wort-Offsets), Zeilen x, y, Zeichen …, $FE [Füllbyte $FE], Seitenende x < 0.
  // Quelle: igt $F5E–$FD8
  const table = f.offset(0x429a8);
  TEXT_KEYS.forEach((key, page) => {
    let p = table + word(f.data, table + 2 * page);
    const lines: TextLine[] = [];
    for (;;) {
      const x = word(f.data, p);
      if (x & 0x8000) break;
      const y = word(f.data, p + 2);
      p += 4;
      let text = "";
      while (f.data[p]! < 0x80) text += MENU_FONT_CHARS[f.data[p++]!] ?? "?";
      p++;
      if (f.data[p] === 0xfe) p++;
      lines.push({ x, y, text });
    }
    out.texts[key] = lines;
  });
}

// ---- Ladebilder (load_<level>, Basis $61500) ----------------------------------------------------

// Alle Ladebild-Dateien haben denselben Code, nur mit verschobenen Adressen (Disassembly work/disasm/load_sea_code.txt,
// load_forest_code.txt und load_marshes_code.txt): Modul bei $6323C (Quelle: mt_init $61F32), Bild direkt hinter dem
// Modul (Quelle: Zeiger bei $61594), Palette direkt hinter dem Bild (Quelle: Einblenden $61600).
const LOAD_SCREENS = [
  { file: "load_sea", key: "load.sea", image: 0x68a58 }, // Quelle: load_sea $61594, Palette $7B568
  { file: "load_forest", key: "load.forest", image: 0x66f1a }, // Quelle: load_forest $61594, Palette $79A2A
  { file: "load_marshes", key: "load.marshes", image: 0x686c4 }, // Quelle: load_marshes $61594, Palette $7B1D4
] as const;

function extractLoadScreens(out: Extracted, sink: Sink, disks: GameDisks): void {
  for (const l of LOAD_SCREENS) {
    const f = disks.get(l.file);
    const moduleAddress = 0x6323c; // Quelle: load_<level> $61F32 (mt_init)
    const mem = f.data.slice();
    applyMtInit(mem, f.offset(moduleAddress)); // O-001: löscht die ersten 4 Byte des Bilds (bei load_forest ohnehin 0)
    module(out, sink, l.key, f, moduleAddress);
    const imageAddress = moduleAddress + moduleInfo(f.data, f.offset(moduleAddress)).length;
    if (imageAddress !== l.image) throw new Error(`${l.file}: Bild bei ${hex(imageAddress)} statt ${hex(l.image)}`);
    image(out, sink, l.key, f, mem, imageAddress, 352, 290, 6, imageAddress + 6 * 44 * 290, 32, true);
  }
}

// ---- Highscores (Agony.00) -----------------------------------------------------------------------

function extractHighscores(out: Extracted, disks: GameDisks): void {
  // 6 Einträge à 8 Byte: 3 Zeichen (Codes der Menüschrift) + Füllbyte, Punkte als BCD-Langwort
  const h = disks.highscores;
  for (let i = 0; i < 6; i++) {
    const name = [0, 1, 2].map((k) => MENU_FONT_CHARS[h[i * 8 + k]!] ?? "?").join("");
    let score = 0;
    for (let k = 4; k < 8; k++) score = score * 100 + (h[i * 8 + k]! >> 4) * 10 + (h[i * 8 + k]! & 15);
    out.highscores.push({ name, score });
  }
}

export function extractStartSequence(disks: GameDisks, sink: Sink): Extracted {
  const out: Extracted = { images: {}, fonts: {}, texts: {}, samples: {}, modules: {}, highscores: [], tables: {}, previews: [] };
  extractPresent(out, sink, disks);
  extractMenu(out, sink, disks);
  extractLoadScreens(out, sink, disks);
  extractHighscores(out, disks);
  return out;
}
