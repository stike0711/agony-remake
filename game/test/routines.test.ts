// Gegner-Routinen von Level 1 ohne Aufnahme (Ablauf B): Jede Routine läuft allein auf dem Speicher des Levels
// (LevelEngine nach start(), nur ROUTINE MANAGER). Die erwarteten Werte sind von Hand aus Ag_Game_LMER.s abgeleitet
// (Abbild-Fassung, work/disasm bzw. disasm68k.py aus sea.game.bin), nicht aus der Umsetzung. Parameter wie in der
// Startliste des Levels (START_C … PAR … PAR_END), Fundstellen im Kommentar.

import { describe, expect, it } from "vitest";
import { LevelEngine } from "../src/core/level/engine.ts";
import { FOREST, type LevelLayout, SEA } from "../src/core/level/layout.ts";
import { routineManager } from "../src/core/level/routines.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const V = SEA.vars;
const AWO_LEN = 12;
const BANK_LEN = 4 + 16 * AWO_LEN;
const X = 0;
const Y = 2;
const OBJ = 4;
const ENERGY = 6;
const STATUS = 8;
const F_RT_S = 9;
/** Parameter der Testroutine: ungenutzter Speicher am Ende des Chip-RAM */
const PARAMS = 0x7ff00;

interface Rout {
  e: LevelEngine;
  /** Eintrag der Rout_Struct, AWO-Bank, erster Gegner der Bank, Variablen */
  a0: number;
  bank: number;
  a2: number;
  a3: number;
  /** n Durchläufe des ROUTINE MANAGER */
  run(n: number): void;
  w(a: number): number;
}

/** Routine `code` mit Parametern wie ROUTINE START ($2AA0) in den ersten Eintrag und die erste freie Bank setzen */
function start(code: number, params: number[], L: LevelLayout = SEA): Rout {
  const e = new LevelEngine(L, loadAssets().memory);
  e.start();
  const { ram } = e;
  const a0 = L.routStruct;
  params.forEach((p, i) => ram.setWord(PARAMS + 2 * i, p));
  ram.setLong(a0, code);
  ram.setLong(a0 + 4, PARAMS);
  let bank = L.awoStruct;
  while ((ram.word(bank) & 0x8000) === 0) bank += BANK_LEN;
  ram.setLong(a0 + 8, bank);
  ram.setLong(bank, 0);
  for (let i = 12; i < 28; i += 4) ram.setLong(a0 + i, 0);
  return {
    e, a0, bank, a2: bank + 4, a3: a0 + 12,
    run: (n) => { for (let i = 0; i < n; i++) routineManager(e); },
    w: (a) => ram.word(a),
  };
}

/** Belegte Einträge der Track_Table (Bit 31 gelöscht): TS-Zeiger */
function usedTracks(e: LevelEngine): number[] {
  const out: number[] = [];
  for (let i = 0; i < 16; i++) {
    const v = e.ram.long(SEA.trackTable + 4 * i);
    if ((v & 0x80000000) === 0) out.push(v);
  }
  return out;
}

describe.skipIf(!hasAssets)("Gegner-Routinen von Level 1 (ohne Aufnahme)", () => {
  it("R_Transporteur: schiebt sich nach links, setzt bei Launch_X zwei Wellen ab, explodiert nach 150, endet nach 175", () => {
    const r = start(0x4efc8, [500]);
    const counter = r.e.w(V.routModPalCounter);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([576, 400, 0x122, 0xffff]);
    expect(r.e.l(V.routPalPtr)).toBe(0x4ef6c);
    expect(r.e.w(V.routModPalCounter)).toBe(counter + 1);
    // 1 Pixel je Durchlauf: 576 − 76 = 500 im 77. Durchlauf
    r.run(75);
    expect([r.w(r.a3), usedTracks(r.e).length]).toEqual([1, 0]);
    r.run(1);
    expect(r.w(r.a3)).toBe(2);
    const ts = usedTracks(r.e);
    expect(ts.map((t) => r.e.ram.long(t + 4))).toEqual([0x4004ef88, 0x4004efa8]);
    expect(ts.map((t) => [r.w(t + 0x0c), r.w(t + 0x0e)])).toEqual([[496, 394], [496, 394]]);
    const [b1, b2] = ts.map((t) => r.e.ram.long(t));
    expect(b2).toBe(b1! + BANK_LEN);
    // AWS: Energie 2, jeder zweite Gegner mit Schussrate 80 (Transporteur1)
    expect([r.w(b1! + 4 + ENERGY), r.e.ram.byte(b1! + 4 + F_RT_S), r.e.ram.byte(b1! + 4 + AWO_LEN + F_RT_S)]).toEqual([2, 0xff, 80]);
    // moveq #31,d0: 32 Gegner – Gegner 16 der zweiten Welle liegt auf dem Kopf der Bank dahinter (bleibt frei, nur
    // Energie und Status ab +6 werden geschrieben)
    expect([r.w(b2! + BANK_LEN), r.w(b2! + BANK_LEN + ENERGY)]).toEqual([0xffff, 2]);
    r.run(149);
    expect(r.e.ram.byte(r.a2 + STATUS)).toBe(0);
    r.run(1);
    expect(r.e.ram.byte(r.a2 + STATUS)).toBe(1);
    r.run(24);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect([r.e.ram.long(r.a0), r.w(r.bank), r.e.w(V.routModPalCounter)]).toEqual([0xffffffff, 0xffff, counter]);
  });

  it("R_Tir_Etoile: acht Schüsse fliegen sternförmig auseinander, Ende ab x ≤ 224", () => {
    // Startliste $4E2CE: START_C R_Tir_Etoile, PAR 456, PAR 336
    const r = start(0x4ed70, [456, 336]);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([556, 336, 0x3f2, 50]);
    // 2 Pixel je Durchlauf: 556 − 2 · 50 = 456 im 51. Durchlauf
    r.run(50);
    expect(r.w(r.a3)).toBe(2);
    const shots = [0x4d0, 0x4e2, 0x4f8, 0x50a, 0x520, 0x532, 0x548, 0x55a];
    expect(shots.map((_, i) => r.w(r.a2 + AWO_LEN * (i + 1) + OBJ))).toEqual(shots);
    expect([r.w(r.a2 + AWO_LEN + ENERGY), r.e.ram.byte(r.a2 + AWO_LEN + F_RT_S)]).toEqual([10, 0xff]);
    r.run(1);
    expect(r.w(r.bank)).toBe(9);
    const pos = (i: number): number[] => [r.w(r.a2 + AWO_LEN * (i + 1) + X), r.w(r.a2 + AWO_LEN * (i + 1) + Y)];
    expect([0, 1, 2, 3, 4, 5, 6, 7].map(pos)).toEqual([
      [456, 333], [459, 333], [459, 336], [459, 339], [456, 339], [453, 339], [453, 336], [453, 333],
    ]);
    expect(r.w(r.a2 + X)).toBe(455);
    // Abstand 3 je Durchlauf; bis 99 (33 Durchläufe) 1 Pixel nach links, ab 102 4 nach links und 2 nach oben
    r.run(32);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y)]).toEqual([423, 336]);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), pos(2)[0]]).toEqual([419, 334, 456 + 102]);
    // x = 423 − 4 · 50 = 223 ≤ 224 im 83. Durchlauf nach dem Abschuss
    r.run(48);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect([r.e.ram.long(r.a0), r.w(r.a2 + X), r.w(r.a2 + Y)]).toEqual([0xffffffff, 223, 236]);
  });

  it("R_Spectre: Gespenst steigt bei Launch_X aus der Phiole, flattert dann zur Eule", () => {
    // Startliste $4E2DA: START_C R_Spectre, PAR 456, 25, 2, 2
    const r = start(0x4e9f0, [456, 25, 2, 2]);
    const a4 = r.a2 + AWO_LEN;
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([556, 416, 0x35a, 5]);
    r.run(50);
    expect([r.w(r.a3), r.w(r.bank), r.w(a4 + X), r.w(a4 + Y), r.w(a4 + OBJ), r.w(a4 + ENERGY)])
      .toEqual([2, 2, 456, 416, 0x370, 2]);
    expect(r.e.ram.byte(a4 + F_RT_S)).toBe(25);
    // MODE 2: Bild jedes zweite Mal (eor/bne), nach dem fünften (Spectre_5) MODE 3; 2 Pixel je Durchlauf
    r.run(10);
    expect([r.w(r.a3), r.w(a4 + OBJ), r.w(a4 + X)]).toEqual([3, 0x3d4, 436]);
    // MODE 3: Flattern (Spectre_5 → _4), Ziel = Eule + (16, 40), Schritt 2
    r.e.setW(V.sorcererX, 100);
    r.e.setW(V.sorcererY, 300);
    r.run(1);
    expect([r.w(a4 + OBJ), r.w(r.a3 + 6), r.w(r.a3 + 8), r.w(a4 + X), r.w(a4 + Y)]).toEqual([0x3b6, 116, 340, 434, 414]);
    // nach 200 Durchläufen in MODE 3: Ende, Gespenst explodiert
    r.run(198);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect([r.e.ram.long(r.a0), r.e.ram.byte(a4 + STATUS)]).toEqual([0xffffffff, 1]);
  });

  it("R_Rapide: rast mit Tempo und Animation aus den Parametern nach links, Ende ab x ≤ 200", () => {
    // Startliste $4E2FE: START_C R_Rapide, PAR $44, 8, PAR.L $4F8DA, PAR $182
    const r = start(0x4f8ee, [0x44, 8, 0x0004, 0xf8da, 0x182]);
    const anim = SEA.animBase + 0x44;
    const frames: number[] = [];
    for (let a = anim; (r.w(a) & 0x8000) === 0; a += 2) frames.push(r.w(a));
    expect(frames.length).toBeGreaterThan(0);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([596, 0x182, frames[0], 3]);
    expect(r.e.l(V.routPalPtr)).toBe(0x4f8da);
    // je Durchlauf das Bild am alten Zeiger; am Ende (negatives Wort) von vorn
    const seen: number[] = [];
    for (let i = 0; i < frames.length + 2; i++) {
      r.run(1);
      seen.push(r.w(r.a2 + OBJ));
    }
    expect(seen).toEqual([...frames, frames[0], frames[1] ?? frames[0]]);
    // 596 − 8 · 49 = 204, dann 196 ≤ 200: Ende im 51. Durchlauf
    r.run(49 - (frames.length + 2));
    expect([r.w(r.a2 + X), r.e.ram.long(r.a0) === 0xffffffff]).toEqual([204, false]);
    r.run(1);
    expect(r.e.ram.long(r.a0)).toBe(0xffffffff);
  });

  it("R_Bomber: lässt alle 24 Durchläufe eine Kugel fallen; dbra läuft eine Kugel weiter (bis ins Byte von R_B_Mode)", () => {
    const r = start(0x4ec00, []);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([596, 288, 0xbe, 15]);
    expect([1, 2, 3, 4, 5].map((i) => r.e.ram.byte(r.a2 + AWO_LEN * i + STATUS))).toEqual([15, 15, 15, 15, 15]);
    r.run(24);
    const b1 = r.a2 + AWO_LEN;
    expect([r.w(r.bank), r.w(r.a3 + 12), r.w(b1 + OBJ), r.w(b1 + ENERGY), r.w(b1 + STATUS)]).toEqual([5, 1, 0x32e, 3, 0x00ff]);
    r.run(1);
    // Sin_Table1[0] = $7F: y = 428 − 127, x = Sack (596 − 2 · 25) − 0 − 30
    expect(r.e.ram.byte(0x509c2)).toBe(0x7f);
    expect([r.w(b1 + X), r.w(b1 + Y)]).toEqual([516, 301]);
    // Eigenheit: auch die zweite (noch nicht abgeworfene) Kugel rückt vor
    expect([r.e.ram.byte(r.a3), r.e.ram.byte(r.a3 + 1), r.w(b1 + AWO_LEN + Y)]).toEqual([1, 1, 301]);
    // Kugeln 2–4 in den Durchläufen 49, 73, 97; danach rückt die Schleife das obere Byte von R_B_Mode vor
    r.run(71);
    expect([r.w(r.a3 + 12), r.w(r.a3 + 4)]).toEqual([4, 1]);
    r.run(1);
    expect(r.w(r.a3 + 4)).toBe(0x0101);
  });

  it("R_Volant_Grossi: Bild nach Energie, Tempo aus den Parametern; R_Jumper ohne Palettenzähler", () => {
    // Startliste $4E51E: START_C R_Volant_Grossi, PAR 256 + 150, PAR 3
    const r = start(0x4f696, [0x196, 3]);
    const counter = r.e.w(V.routModPalCounter);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([596, 0x196, 0x5a8, 10]);
    expect([r.e.l(V.routPalPtr), r.e.w(V.routModPalCounter)]).toEqual([0x4f682, counter + 1]);
    r.e.ram.setWord(r.a2 + ENERGY, 6);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + OBJ)]).toEqual([593, 0x58e]);
    r.e.ram.setWord(r.a2 + ENERGY, 2);
    r.run(1);
    expect(r.w(r.a2 + OBJ)).toBe(0x570);
    // 596 − 3 · 132 = 200: Ende im 133. Durchlauf
    r.run(129);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect([r.e.ram.long(r.a0), r.e.w(V.routModPalCounter)]).toEqual([0xffffffff, counter]);

    const j = start(0x4f75e, []);
    const c2 = j.e.w(V.routModPalCounter);
    j.run(2);
    expect([j.w(j.a2 + X), j.w(j.a2 + Y), j.e.l(V.routPalPtr), j.e.w(V.routModPalCounter)]).toEqual([594, 446, 0x4f74a, c2]);
  });

  it("R_Volant_Missile: folgt der Eule, feuert nach 75 Durchläufen einen gelenkten Schuss", () => {
    const r = start(0x4f2f2, []);
    const a4 = r.a2 + AWO_LEN;
    r.e.setW(V.sorcererX, 100);
    r.e.setW(V.sorcererY, 150);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY), r.w(r.a3 + 4), r.w(r.a3 + 12)])
      .toEqual([456, 220, 0x29e, 20, 125, 1]);
    // MODE 1: Ziel Eule + (100, 40) = (200, 190), 1 Pixel je Durchlauf
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y)]).toEqual([455, 219]);
    // Takt 175 (Durchlauf 51): Schuss explodiert, auch ohne Abschuss
    r.run(48);
    expect(r.e.ram.byte(a4 + STATUS)).toBe(0);
    r.run(1);
    expect(r.e.ram.byte(a4 + STATUS)).toBe(1);
    // Takt 200 (Durchlauf 76): Schuss am Monster (382, 190); Ziel (116, 190) auf gleicher Höhe, links davon: Tir_6
    r.run(25);
    expect([r.w(a4 + X), r.w(a4 + Y), r.w(a4 + ENERGY), r.e.ram.byte(a4 + STATUS)]).toEqual([382, 190, 10, 0]);
    expect([r.w(r.a3 + 6), r.w(a4 + OBJ), r.w(r.a3 + 8), r.w(r.a3 + 10), r.w(r.bank)]).toEqual([4, 0x532, 116, 190, 1]);
    r.run(1);
    expect([r.w(r.bank), r.w(a4 + X), r.w(a4 + OBJ)]).toEqual([2, 379, 0x548]);
  });

  it("R_Final: drei Kugelwellen im Wechsel, Explosion in Schritten bis Clean_Up", () => {
    const r = start(0x4fa3a, []);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY), r.e.ram.byte(r.a2 + F_RT_S)])
      .toEqual([416, 346, 0x5c2, 130, 30]);
    expect(r.e.w(V.routModPalCounter)).toBe(0);
    r.run(69);
    expect(usedTracks(r.e).length).toBe(0);
    r.run(1);
    r.run(70);
    r.run(70);
    const ts = usedTracks(r.e);
    expect(ts.map((t) => [r.e.ram.long(t + 4), r.w(t + 0x0c), r.w(t + 0x0e)])).toEqual([
      [0x4004f99e, 516, 364], [0x4004f9be, 524, 364], [0x4004f9de, 524, 356],
    ]);
    expect([r.e.l(V.rFAwoPtr3), r.e.l(V.rFAwoPtr2), r.e.l(V.rFAwoPtr1)]).toEqual(ts.map((t) => r.e.ram.long(t)));
    // zerstört: unteres Halbbyte des Status
    r.e.ram.setByte(r.a2 + STATUS, 1);
    r.run(1);
    expect([r.e.w(V.quitDelay), r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a3 + 6)]).toEqual([100, 476, 356, 0x5d8, 1]);
    r.run(16);
    expect([r.e.l(V.routPalPtr), r.e.w(V.shortPhase), r.e.w(V.sound0Req), r.e.w(V.sound0VolReq)]).toEqual([0x4f9fe, 1, 1, 63]);
    r.e.ram.setWord(SEA.frontScreens + 0x100, 0x1234);
    r.run(2);
    expect(r.w(SEA.frontScreens + 0x100)).toBe(0);
    expect(usedTracks(r.e).length).toBe(0);
    expect(ts.map((t) => r.w(r.e.ram.long(t)))).toEqual([0xffff, 0xffff, 0xffff]);
    r.run(32);
    expect(r.e.b(V.cleanUp)).toBe(0);
    r.run(1);
    expect([r.e.b(V.cleanUp), r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ)]).toEqual([0xff, 506, 376, 0x640]);
  });
});

// Level 2: dieselben Routinen mit den Unterschieden aus Ag_Game_LFORET.s (Abbild-Fassung work/disasm/forest_rout.txt).
// Startliste ab $4AF44; Parameter wie dort.
describe.skipIf(!hasAssets)("Gegner-Routinen von Level 2, aus Level 1 bekannt (ohne Aufnahme)", () => {
  const FV = FOREST.vars;
  /** Rout_Mod_Pal_Counter und Rout_Pal_Ptr auf einen Testwert setzen (andere Routine mit eigener Palette läuft) */
  const busy = (r: Rout, n: number): void => {
    r.e.setW(FV.routModPalCounter, n);
    r.e.setL(FV.routPalPtr, 0x12345678);
  };

  it("R_Spectre: ohne eigene Palette, Objekte des Levels; CLOSE ohne Zählerabzug", () => {
    // Startliste: START_C R_Spectre, PAR 200 + 256, 25, 2, 1
    const r = start(0x4b76c, [456, 25, 2, 1], FOREST);
    const a4 = r.a2 + AWO_LEN;
    busy(r, 1);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([556, 416, 0x300, 5]);
    expect([r.e.w(FV.routModPalCounter), r.e.l(FV.routPalPtr)]).toEqual([1, 0x12345678]);
    r.run(50);
    expect([r.w(r.a3), r.w(a4 + OBJ), r.e.ram.byte(a4 + F_RT_S)]).toEqual([2, 0x312, 25]);
    // R_Spectre_Shape $4B762: $312 $324 $336 $348 $35E, dann MODE 3 mit Flattern $35E → $348
    r.run(10);
    expect([r.w(r.a3), r.w(a4 + OBJ)]).toEqual([3, 0x35e]);
    r.run(1);
    expect(r.w(a4 + OBJ)).toBe(0x348);
    r.run(198);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    // Zähler bleibt 1: Rout_Pal_Ptr unverändert; mit Zähler 0 wird die Palette des Levels wiederhergestellt
    expect([r.e.ram.long(r.a0), r.e.ram.byte(a4 + STATUS), r.e.w(FV.routModPalCounter), r.e.l(FV.routPalPtr)])
      .toEqual([0xffffffff, 1, 1, 0x12345678]);
    const z = start(0x4b76c, [456, 25, 2, 1], FOREST);
    busy(z, 0);
    z.e.ram.setByte(z.a2 + STATUS, 1);
    z.run(1);
    z.e.ram.setWord(z.a2 + X, 200);
    z.e.ram.setByte(z.a2 + STATUS, 1);
    z.run(1);
    expect([z.e.ram.long(z.a0), z.e.w(FV.routModPalCounter), z.e.l(FV.routPalPtr)]).toEqual([0xffffffff, 0, 0xffffffff]);
  });

  it("R_Tir_Etoile: ohne eigene Palette, Monster $54E, Schüsse $416–$494", () => {
    // Startliste: START_C R_Tir_Etoile, PAR 200 + 256, 80 + 256
    const r = start(0x4b964, [456, 336], FOREST);
    busy(r, 2);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([556, 336, 0x54e, 50]);
    expect(r.e.w(FV.routModPalCounter)).toBe(2);
    // Animation R_Tir_Etoile_Shape $4B952 (jedes zweite Mal): erstes Bild im zweiten Durchlauf
    r.run(1);
    expect(r.w(r.a2 + OBJ)).toBe(0x54e);
    r.run(2);
    expect(r.w(r.a2 + OBJ)).toBe(0x564);
    r.run(47);
    expect(r.w(r.a3)).toBe(2);
    const shots = [0x416, 0x428, 0x43a, 0x44c, 0x45e, 0x470, 0x482, 0x494];
    expect(shots.map((_, i) => r.w(r.a2 + AWO_LEN * (i + 1) + OBJ))).toEqual(shots);
    // wie in Level 1: 33 Durchläufe 1 Pixel, dann 4 Pixel nach links; 423 − 4 · 50 = 223 ≤ 224 im 83. Durchlauf
    r.run(82);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect(r.e.ram.long(r.a0)).toBe(0xffffffff);
    expect([r.e.w(FV.routModPalCounter), r.e.l(FV.routPalPtr)]).toEqual([2, 0x12345678]);
  });

  it("R_Volant_Missile: ohne Palette, Schuss 1 Pixel je Durchlauf", () => {
    const r = start(0x4bb60, [], FOREST);
    const a4 = r.a2 + AWO_LEN;
    busy(r, 0);
    r.e.setW(FV.sorcererX, 100);
    r.e.setW(FV.sorcererY, 150);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([456, 220, 0x4a6, 20]);
    expect(r.e.l(FV.routPalPtr)).toBe(0x12345678);
    // Takt 200 (Durchlauf 76): Schuss am Monster (382, 190), Ziel (116, 190) links davon: Tir_6 ($470)
    r.run(75);
    expect([r.w(a4 + X), r.w(a4 + Y), r.w(r.a3 + 6), r.w(a4 + OBJ)]).toEqual([382, 190, 4, 0x470]);
    r.run(1);
    expect([r.w(r.bank), r.w(a4 + X), r.w(a4 + OBJ)]).toEqual([2, 381, 0x482]);
    // nach 1.125 Durchläufen Ende; Zähler 0 → Palette des Levels
    r.run(1125 - 77);
    expect(r.e.ram.long(r.a0)).toBe(0xffffffff);
    expect([r.e.w(FV.routModPalCounter), r.e.l(FV.routPalPtr)]).toEqual([0, 0xffffffff]);
  });

  it("R_Araignee: ohne Palette, Richtung bei +2", () => {
    // Startliste: START_C R_Araignee, PAR 50, 2
    const r = start(0x4bee4, [50, 2], FOREST);
    busy(r, 1);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([596, 50, 0x3f4, 10]);
    // abwärts 2 je Durchlauf bis 340 (146 Durchläufe), dann aufwärts
    r.run(145);
    expect([r.w(r.a2 + Y), r.w(r.a3 + 2)]).toEqual([340, 0x00ff]);
    r.run(1);
    expect(r.w(r.a2 + Y)).toBe(338);
    // 596 − 2 · 198 = 200: Ende im 198. Durchlauf nach dem Start
    r.run(51);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect(r.e.ram.long(r.a0)).toBe(0xffffffff);
    expect([r.e.w(FV.routModPalCounter), r.e.l(FV.routPalPtr)]).toEqual([1, 0x12345678]);
  });

  it("R_Rapide: Energie 2, zählt Rout_Mod_Pal_Counter ohne Palette", () => {
    // Startliste: START_C R_Rapide, PAR Anim_Speedy, 10, PAR_L Dummy_Pal, PAR 256 + 60
    const r = start(0x4bfa2, [0, 10, 0x0004, 0xbf8e, 316], FOREST);
    busy(r, 0);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([596, 316, 0x4ce, 2]);
    expect([r.e.w(FV.routModPalCounter), r.e.l(FV.routPalPtr)]).toEqual([1, 0x12345678]);
    // Anim_Speedy $4B70E: $4CE, $4EA, Ende
    r.run(3);
    expect(r.w(r.a2 + OBJ)).toBe(0x4ce);
    // 596 − 10 · 40 = 196 ≤ 200: Ende im 41. Durchlauf; Zähler zurück auf 0 → Palette des Levels
    r.run(36);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect(r.e.ram.long(r.a0)).toBe(0xffffffff);
    expect([r.e.w(FV.routModPalCounter), r.e.l(FV.routPalPtr)]).toEqual([0, 0xffffffff]);
  });
});
