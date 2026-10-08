// Level 1 (Meer, Spieldatei sea = Agony.09, Basis $600): Speicherblöcke für die Level-Engine (E-032).
// Die Engine arbeitet wie das Original auf planaren Daten, Copperlisten und Sprite-Listen an ihren Originaladressen;
// die Pipeline schneidet nur die nötigen Bereiche aus (ohne Programmcode und ohne Jeroen Tels Musik).
// Adressen: Wiki dateiformate.md „Level 1 (sea)“; belegt über die Disassembly (work/disasm/sea_code.txt).

import type { MemoryAsset } from "../../../game/src/data/manifest.ts";
import type { GameDisks, GameFile } from "../lib/gamefiles.ts";
import { decodePlanar } from "../lib/planar.ts";
import type { Sink } from "./startsequence.ts";

const hex = (n: number): string => "$" + n.toString(16).toUpperCase().padStart(5, "0");

export interface LevelPreview {
  key: string;
  width: number;
  height: number;
  indices: Uint8Array;
  palette: number[];
}

export interface ExtractedLevel {
  memory: Record<string, MemoryAsset>;
  /** "status.extra": per Skript ergänzte Zeichen der Statusschrift (Ä, Ö, Ü), 16 Byte je Zeichen wie Status_Digit */
  tables: Record<string, number[]>;
  previews: LevelPreview[];
}

/** Statusschrift Status_Digit: 44 Zeichen à 16 Byte (8 × 16 Pixel, Hires), Codes siehe core/level/status.ts */
const STATUS_DIGIT = 0x5bc1a;
const STATUS_GLYPHS = 44;
/** Grundbuchstaben der ergänzten Zeichen Ä, Ö, Ü (Codes 11 + Buchstabennummer) */
const UMLAUT_BASES = [11, 25, 31];
/** Zeilen, um die der Buchstabe gestaucht wird: 2 Zeilen Punkte + 1 Zeile Abstand */
const UMLAUT_SQUEEZE = 3;

/**
 * Ä, Ö, Ü der Statusschrift (E-021). Die Originalzeichen füllen alle 16 Zeilen, über dem Buchstaben ist kein Platz.
 * Deshalb wird er um 3 Zeilen gestaucht: Es fällt jeweils eine Zeile aus der längsten Folge gleicher Zeilen weg
 * (gerade Striche, bei Gleichstand die obere), dann stehen zwei Punkte à 2 × 2 Pixel (wie beim „!“) in Zeile 0–1
 * links und rechts der Buchstabenmitte.
 */
function statusUmlauts(rows: (code: number) => number[]): number[] {
  const out: number[] = [];
  for (const base of UMLAUT_BASES) {
    const g = rows(base);
    for (let n = 0; n < UMLAUT_SQUEEZE; n++) {
      let best = 0, bestLen = 0;
      for (let i = 0; i < g.length; ) {
        let j = i;
        while (j < g.length && g[j] === g[i]) j++;
        if (j - i > bestLen) {
          best = i;
          bestLen = j - i;
        }
        i = j;
      }
      g.splice(best + (bestLen >> 1), 1);
    }
    let ink = 0;
    for (const r of g) ink |= r;
    const left = 7 - (31 - Math.clz32(ink)); // Bit 7 = linkes Pixel
    const right = 7 - (31 - Math.clz32(ink & -ink));
    const center = (left + right) >> 1;
    const dots = (0xc0 >> (center - 2)) | (0xc0 >> (center + 1));
    out.push(dots, dots, 0, ...g);
  }
  return out;
}

/** Bereiche im Abbild: [Schlüssel, von, bis (exklusiv), Inhalt] */
const BLOCKS: [string, number, number, string][] = [
  // Quelle: sea $4500 (lea Sorcerer_Dat), Sorcerer2_Dat $1B8F0, Schüsse $1EFC8 ($4798), Alien_Fire_Spr $1FFDC ($5A02);
  // Sky_Dat folgt direkt
  ["sprites", 0x178c0, 0x205b4, "Sprites (Main_Char/*.bin): Eule, Schüsse, Bonusse, Gegnerschüsse, Tod"],
  // Quelle: sea $13DC (lea Sky_Dat), Back_Charset folgt direkt ($1250 addi.l #$21C34)
  ["sky", 0x205b4, 0x21c34, "statische Ebene (Sky.bin): 4 Blöcke à 40 Zeilen × 36 Byte"],
  // Quelle: sea $1250 (Back_Charset), Front_Charset ab $30F34 ($CCE)
  ["back", 0x21c34, 0x30f34, "Kacheln des hinteren Playfields (Back.bin), 32 × 32 Pixel, 2 Planes"],
  // Front_Charset ($CCE) bis Rel_Start: Kacheln vorn, Objektgrafik (Sprites_Bitmap $40534), Objekt- und Bahnstrukturen,
  // AF_Struct ($4DFC6), Level-Modul Ag_Game_LMER.s (Startliste $4E0C6, Wellen, Animationen, Bahntabellen; seine
  // Objekt-Routinen stehen als Bytes mit drin, werden aber nie ausgeführt, sondern übertragen)
  ["game", 0x30f34, 0x50ace, "Front.Bin, Objects.bin/.obj, Strukturen, Level-Modul"],
  // Rel_Start = a5 − $8000 ($61E: lea $58ACE,a5) bis Clear_Start ($A08: lea $607B2,a0): Tabellen, Muster,
  // Sprite-Listen, Statuszeile, Copperlisten (Main_Cl $5E962, Cl_Flip_Phase1 $5F88A) und Variablen
  ["rel", 0x50ace, 0x607b2, "relative Daten (Rel_Start … Clear_Start) inklusive Copperlisten"],
];

function word(f: GameFile, address: number): number {
  const o = f.offset(address);
  return (f.data[o]! << 8) | f.data[o + 1]!;
}

function check(f: GameFile, what: string, address: number, expected: number): void {
  const v = word(f, address);
  if (v !== expected) throw new Error(`sea: ${what} bei ${hex(address)} ist $${v.toString(16)} statt $${expected.toString(16)}`);
}

export function extractLevel1(disks: GameDisks, sink: Sink): ExtractedLevel {
  const f = disks.get("sea");
  // Stichproben gegen die Disassembly: Copperliste beginnt mit SPR0PTH, Musterkopf, Kachel-Infos, Startliste
  check(f, "Main_Cl", 0x5e962, 0x0120);
  check(f, "Cl_Flip_Phase1", 0x5f88a, 0x0192);
  check(f, "Back_Pattern", 0x526ee, 0x0020);
  check(f, "Back_Char_Info", 0x52bae, 0x00f8);
  check(f, "Start_List", 0x4e0c6, 0x0040);

  const out: ExtractedLevel = { memory: {}, tables: {}, previews: [] };
  for (const [key, from, to, what] of BLOCKS) {
    const data = f.at(from, to - from);
    out.memory[`sea.${key}`] = { file: sink.write(`level/sea.${key}.bin`, data), address: from, length: data.length, source: `sea ${hex(from)}: ${what}` };
  }

  const glyphRows = (code: number): number[] => Array.from(f.at(STATUS_DIGIT + 16 * code, 16));
  check(f, "Status_Digit (A)", STATUS_DIGIT + 16 * 11, 0x3838);
  const extra = statusUmlauts(glyphRows);
  out.tables["status.extra"] = extra;
  // Vorschau der Statusschrift: Originalzeichen, dann die ergänzten
  const glyphs = STATUS_GLYPHS + extra.length / 16;
  const font = new Uint8Array(glyphs * 8 * 16);
  for (let c = 0; c < glyphs; c++) {
    const r = c < STATUS_GLYPHS ? glyphRows(c) : extra.slice((c - STATUS_GLYPHS) * 16, (c - STATUS_GLYPHS + 1) * 16);
    for (let y = 0; y < 16; y++) for (let x = 0; x < 8; x++) font[y * glyphs * 8 + c * 8 + x] = (r[y]! >> (7 - x)) & 1;
  }
  out.previews.push({ key: "font.status", width: glyphs * 8, height: 16, indices: font, palette: [0x000, 0xfff] });

  // Vorschau: alle Kacheln des hinteren Playfields mit den Farben des ersten Musters (Band 0) und der Himmel
  const mem = f.data;
  const info = 0x52bae;
  const count = word(f, info) - 2;
  const cols = 16;
  const rows = Math.ceil(count / cols);
  const tiles = new Uint8Array(cols * 32 * rows * 32);
  const plane = (address: number, y: number, x: number): number => (mem[f.offset(address) + y * 4 + (x >> 3)]! >> (7 - (x & 7))) & 1;
  for (let c = 0; c < count; c++) {
    const mode = mem[f.offset(info + 2 + c)]!;
    const src = 0x21c34 + word(f, info + word(f, info) + 2 * c);
    for (let y = 0; y < 32; y++) {
      for (let x = 0; x < 32; x++) {
        // Modus 0: Plane 4 und 6 getrennt, 1: beide gleich, 2: nur Plane 6, 3: nur Plane 4 (Quelle: Ag_Back_Scroll.s)
        const a = mode === 2 ? 0 : plane(src, y, x);
        const b = mode === 0 ? plane(src, y + 32, x) : mode === 1 ? a : mode === 2 ? plane(src, y, x) : 0;
        tiles[((c / cols | 0) * 32 + y) * cols * 32 + (c % cols) * 32 + x] = a + 2 * b;
      }
    }
  }
  out.previews.push({ key: "sea.back", width: cols * 32, height: rows * 32, indices: tiles, palette: [0x000, 0x050, 0x554, 0x143] });
  const sky = decodePlanar(mem, f.offset(0x205b4), { width: 288, height: 160, planes: 1, rowBytes: 36 });
  out.previews.push({ key: "sea.sky", width: 288, height: 160, indices: sky, palette: [0x000, 0x166] });
  return out;
}
