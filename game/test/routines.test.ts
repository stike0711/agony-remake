// Gegner-Routinen von Level 1 ohne Aufnahme (Ablauf B): Jede Routine läuft allein auf dem Speicher des Levels
// (LevelEngine nach start(), nur ROUTINE MANAGER). Die erwarteten Werte sind von Hand aus Ag_Game_LMER.s abgeleitet
// (Abbild-Fassung, work/disasm bzw. disasm68k.py aus sea.game.bin), nicht aus der Umsetzung. Parameter wie in der
// Startliste des Levels (START_C … PAR … PAR_END), Fundstellen im Kommentar.

import { describe, expect, it } from "vitest";
import { LevelEngine } from "../src/core/level/engine.ts";
import { FOREST, type LevelLayout, MARSHES, MOUNTAINS, SEA } from "../src/core/level/layout.ts";
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
function usedTracks(e: LevelEngine, L: LevelLayout = SEA): number[] {
  const out: number[] = [];
  for (let i = 0; i < 16; i++) {
    const v = e.ram.long(L.trackTable + 4 * i);
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

describe.skipIf(!hasAssets)("Neue Gegner-Routinen von Level 2 (ohne Aufnahme)", () => {
  // Werte von Hand aus Ag_Game_LFORET.s (Labels R_Kamikaze, R_Sol_Etoile, R_Final), Abbild work/disasm/forest_rout.txt
  const FV = FOREST.vars;
  const busy = (r: Rout): void => {
    r.e.setW(FV.routModPalCounter, 1);
    r.e.setL(FV.routPalPtr, 0x12345678);
  };

  it("R_Kamikaze: hält auf Eule + (150, 40) zu, steht, fliegt ab Launch_Time + 50 mit 8 Pixel nach links", () => {
    // Startliste: START_C R_Kamikaze, PAR 25*7, 2, 2
    const r = start(0x4c048, [175, 2, 2], FOREST);
    busy(r);
    r.e.setW(FV.sorcererX, 100);
    r.e.setW(FV.sorcererY, 150);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY), r.w(r.a3)]).toEqual([556, 200, 0x2ee, 20, 1]);
    expect(r.e.w(FV.routModPalCounter)).toBe(1);
    // Ziel (250, 190): y 200 → 192 (Abstand 2 = Schritt: stehen), x 556 − 2 · 152 = 252
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a3 + 6)]).toEqual([554, 198, 1]);
    r.run(174);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a3 + 6)]).toEqual([252, 192, 175]);
    // nach Launch_Time folgt es nicht mehr; ab Zeit 225 je 8 Pixel nach links
    r.e.setW(FV.sorcererX, 0);
    r.run(49);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y)]).toEqual([252, 192]);
    r.run(1);
    expect(r.w(r.a2 + X)).toBe(244);
    // 252 − 8 · 7 = 196 ≤ 200: Ende bei Zeit 231; CLOSE ohne Zählerabzug
    r.run(5);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect([r.e.ram.long(r.a0), r.w(r.bank)]).toEqual([0xffffffff, 0xffff]);
    expect([r.e.w(FV.routModPalCounter), r.e.l(FV.routPalPtr)]).toEqual([1, 0x12345678]);
  });

  it("R_Sol_Etoile: wandert am Boden nach links, drei Schüsse nach oben ab x < Launch_X, Ende ab x ≤ 200", () => {
    // Startliste: START_C R_Sol_Etoile, PAR 150+256
    const r = start(0x4c160, [406], FOREST);
    busy(r);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY), r.w(r.a3)]).toEqual([556, 447, 0x614, 10, 1]);
    // R_SE_Shape $4C138: jedes Bild zweimal, Schritt vor dem Lesen erhöht
    r.run(2);
    expect([r.w(r.a2 + X), r.w(r.a2 + OBJ), r.w(r.a3 + 8)]).toEqual([552, 0x626, 2]);
    r.run(17);
    expect([r.w(r.a2 + OBJ), r.w(r.a3 + 8)]).toEqual([0x6ba, 19]);
    r.run(1);
    expect([r.w(r.a2 + OBJ), r.w(r.a3 + 8)]).toEqual([0x614, 0]);
    // 556 − 2 · 75 = 406 = Launch_X: noch nicht; im 76. Durchlauf (x 404) Schüsse anlegen
    r.run(55);
    expect([r.w(r.a2 + X), r.w(r.a3)]).toEqual([406, 1]);
    r.run(1);
    const shots = [0x416, 0x428, 0x494];
    expect([r.w(r.a3), r.w(r.bank), r.w(r.a3 + 4), r.w(r.a3 + 6)]).toEqual([2, 1, 404, 447]);
    for (let i = 1; i <= 3; i++) {
      const a = r.a2 + AWO_LEN * i;
      expect([r.w(a + OBJ), r.w(a + ENERGY), r.e.ram.byte(a + STATUS), r.e.ram.byte(a + F_RT_S)]).toEqual([shots[i - 1], 10, 0, 0xff]);
    }
    // danach 4 Gegner in der Bank; Abstand 3 je Durchlauf: oben, oben rechts, oben links
    r.run(1);
    expect(r.w(r.bank)).toBe(4);
    expect([1, 2, 3].map((i) => [r.w(r.a2 + AWO_LEN * i + X), r.w(r.a2 + AWO_LEN * i + Y)])).toEqual([[404, 444], [407, 444], [401, 444]]);
    // 556 − 2 · 178 = 200: Ende im 178. Durchlauf; CLOSE ohne Zählerabzug
    r.run(100);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect([r.e.ram.long(r.a0), r.w(r.bank)]).toEqual([0xffffffff, 0xffff]);
    expect([r.e.w(FV.routModPalCounter), r.e.l(FV.routPalPtr)]).toEqual([1, 0x12345678]);
  });

  it("R_Sol_Etoile: getroffen schießt es nicht", () => {
    const r = start(0x4c160, [406], FOREST);
    r.run(70);
    r.e.ram.setByte(r.a2 + STATUS, 1);
    r.run(10);
    expect([r.w(r.a2 + X), r.w(r.a3), r.w(r.bank)]).toEqual([398, 1, 1]);
  });

  it("R_Final: Ober- und Unterteil pendeln, alle 18 Durchläufe eine Bumerangwelle, Explosion bis Clean_Up", () => {
    const r = start(0x4c39e, [], FOREST);
    const a4 = r.a2 + AWO_LEN;
    busy(r);
    r.run(1);
    expect([r.w(r.bank), r.w(r.a3), r.e.w(FV.routModPalCounter)]).toEqual([2, 1, 0]);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY), r.e.ram.byte(r.a2 + F_RT_S)])
      .toEqual([606, 386, 0x232, 150, 20]);
    expect([r.w(a4 + X), r.w(a4 + Y), r.w(a4 + OBJ), r.w(a4 + ENERGY), r.e.ram.byte(a4 + F_RT_S)])
      .toEqual([606, 386, 0x20e, 20000, 0xff]);
    // Unterteil: Bit 3 von R_F_Anim_Delay gesetzt → Bas_1, sonst Bas_2; Oberteil: R_F_Anim_Up $232 ×4, $24E ×2, $268 ×2
    r.run(1);
    expect([r.w(r.a2 + X), r.w(a4 + X), r.w(a4 + OBJ), r.w(r.a2 + OBJ)]).toEqual([604, 604, 0x220, 0x232]);
    r.run(3);
    expect(r.w(r.a2 + OBJ)).toBe(0x24e);
    r.run(2);
    expect(r.w(r.a2 + OBJ)).toBe(0x268);
    r.run(2);
    expect([r.w(a4 + OBJ), r.w(r.a2 + OBJ)]).toEqual([0x20e, 0x232]);
    // nach links bis x ≤ 256 + 160 (95. Durchlauf), dann nach rechts
    r.run(87);
    expect([r.w(r.a2 + X), r.w(r.a3 + 6)]).toEqual([416, 0xffff]);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(a4 + X)]).toEqual([418, 418]);
    // Wellen in den Durchläufen 18, 36 … 108: R_T_Final_2 … _6, dann _1, je bei (x − 20, y − 20)
    r.run(12);
    expect(usedTracks(r.e, FOREST).map((t) => [r.e.ram.long(t + 4), r.w(t + 0x0c), r.w(t + 0x0e)])).toEqual([
      [0x4004c2d6, 550, 366], [0x4004c2f6, 514, 366], [0x4004c316, 478, 366], [0x4004c336, 442, 366],
      [0x4004c356, 406, 366], [0x4004c2b6, 422, 366],
    ]);
    // rechts bis x ≥ 256 + 260 (145. Durchlauf), dann wieder nach links
    r.run(37);
    expect([r.w(r.a2 + X), r.w(r.a3 + 6)]).toEqual([516, 0]);
    r.run(1);
    expect(r.w(r.a2 + X)).toBe(514);
    // Wellen 7 und 8 in den Durchläufen 126 und 144
    expect(usedTracks(r.e, FOREST).length).toBe(8);
    // zerstört: im selben Durchlauf noch bewegt, dann Schritt 1 (Quit_Delay 100, Big_Explo_1 an beiden)
    r.e.ram.setByte(r.a2 + STATUS, 1);
    r.e.setW(FV.shortPhase, 0);
    r.run(1);
    expect([r.w(r.a3), r.w(r.a3 + 4), r.e.w(FV.quitDelay), r.w(r.a2 + X)]).toEqual([2, 1, 100, 512]);
    expect([r.w(r.a2 + OBJ), r.e.ram.byte(r.a2 + STATUS), r.w(a4 + OBJ), r.e.ram.byte(a4 + STATUS)])
      .toEqual([0x6d0, 1, 0x6d0, 1]);
    r.run(19);
    expect([r.w(r.a2 + X), r.e.w(FV.shortPhase), r.e.w(FV.sound0Req)]).toEqual([512, 0, 0]);
    r.run(1);
    expect([r.e.w(FV.shortPhase), r.e.w(FV.sound0Req), r.e.w(FV.sound0VolReq)]).toEqual([1, 1, 63]);
    r.run(14);
    expect([r.w(r.a2 + OBJ), r.w(a4 + OBJ)]).toEqual([0x706, 0x706]);
    r.run(16);
    expect(r.e.b(FV.cleanUp)).toBe(0);
    r.run(1);
    // Schritt 52: Big_Explo_3, Clean_Up; Quit_Delay bleibt (Abbild), keine weiteren Wellen
    expect([r.e.b(FV.cleanUp), r.e.w(FV.quitDelay), r.w(r.a2 + OBJ), r.w(a4 + OBJ)]).toEqual([0xff, 100, 0x73e, 0x73e]);
    r.run(50);
    expect(usedTracks(r.e, FOREST).length).toBe(8);
  });
});

describe.skipIf(!hasAssets)("Gegner-Routinen von Level 3, aus Level 1 und 2 bekannt (ohne Aufnahme)", () => {
  // Werte von Hand aus AG_GAME_LMARAIS.S, Abbild work/disasm/marshes_rout.txt
  const MV = MARSHES.vars;
  const busy = (r: Rout, n: number): void => {
    r.e.setW(MV.routModPalCounter, n);
    r.e.setL(MV.routPalPtr, 0x12345678);
  };

  it("R_Rapide: Energie 2, ohne Palette und ohne Rout_Mod_Pal_Counter", () => {
    // Startliste: START_C R_Rapide, PAR Anim_…, 10, PAR_L Dummy_Pal, PAR 256 + 60; Anim_Base $4EEF0: $2CE, Ende
    const r = start(0x4f6a2, [0, 10, 0x0004, 0xf68e, 316], MARSHES);
    busy(r, 1);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([596, 316, 0x2ce, 2]);
    expect([r.e.w(MV.routModPalCounter), r.e.l(MV.routPalPtr)]).toEqual([1, 0x12345678]);
    r.run(3);
    expect(r.w(r.a2 + OBJ)).toBe(0x2ce);
    // Ende im 41. Durchlauf; Zähler bleibt 1, Palette bleibt
    r.run(36);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect(r.e.ram.long(r.a0)).toBe(0xffffffff);
    expect([r.e.w(MV.routModPalCounter), r.e.l(MV.routPalPtr)]).toEqual([1, 0x12345678]);
    // mit Zähler 0: Palette des Levels, Zähler bleibt 0 (nicht $FFFF)
    const q = start(0x4f6a2, [0, 10, 0x0004, 0xf68e, 316], MARSHES);
    busy(q, 0);
    q.run(41);
    expect([q.e.w(MV.routModPalCounter), q.e.l(MV.routPalPtr)]).toEqual([0, 0xffffffff]);
  });

  it("R_Transporteur: ohne Palette und Zähler, Objekt $256, zwei Wellen bei Launch_X", () => {
    const r = start(0x4f878, [500], MARSHES);
    busy(r, 1);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([576, 400, 0x256, 0xffff]);
    expect([r.e.w(MV.routModPalCounter), r.e.l(MV.routPalPtr)]).toEqual([1, 0x12345678]);
    // 576 − 76 = 500: Wellen R_T_Transporteur1/2 ($4F838/$4F858)
    r.run(75);
    expect(usedTracks(r.e, MARSHES)).toHaveLength(0);
    r.run(1);
    const ts = usedTracks(r.e, MARSHES);
    expect(ts.map((t) => r.e.ram.long(t + 4))).toEqual([0x4004f838, 0x4004f858]);
    r.run(174);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect(r.e.ram.long(r.a0)).toBe(0xffffffff);
    expect([r.e.w(MV.routModPalCounter), r.e.l(MV.routPalPtr)]).toEqual([1, 0x12345678]);
  });

  it("R_Sol_Crache: ohne Palette und Zähler, Pflanze $1A8, Feuerball $1F6", () => {
    const r = start(0x4fa22, [30], MARSHES);
    busy(r, 1);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([576, 446, 0x1a8, 8]);
    r.run(30);
    expect([r.w(r.a3), r.w(r.a2 + AWO_LEN + OBJ), r.w(r.a2 + AWO_LEN + ENERGY)]).toEqual([2, 0x1f6, 2]);
    // 576 − 2 · 188 = 200: Ende im 188. Durchlauf nach dem Start
    r.run(157);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect(r.e.ram.long(r.a0)).toBe(0xffffffff);
    expect([r.e.w(MV.routModPalCounter), r.e.l(MV.routPalPtr)]).toEqual([1, 0x12345678]);
  });

  it("R_Volant_Missile: ohne Palette, Monster $534, Schuss 2 Pixel je Durchlauf", () => {
    const r = start(0x4f30a, [], MARSHES);
    const a4 = r.a2 + AWO_LEN;
    busy(r, 0);
    r.e.setW(MV.sorcererX, 100);
    r.e.setW(MV.sorcererY, 150);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([456, 220, 0x534, 20]);
    // wie Level 2: Schuss am Monster (382, 190) nach links (Tir_6 = $4FE), dann Tir_7 ($510) mit 2 Pixel
    r.run(75);
    expect([r.w(a4 + X), r.w(a4 + Y), r.w(r.a3 + 6), r.w(a4 + OBJ)]).toEqual([382, 190, 4, 0x4fe]);
    r.run(1);
    expect([r.w(r.bank), r.w(a4 + X), r.w(a4 + OBJ)]).toEqual([2, 380, 0x510]);
  });
});

describe.skipIf(!hasAssets)("Neue Gegner-Routinen von Level 3 (ohne Aufnahme)", () => {
  // Werte von Hand aus AG_GAME_LMARAIS.S (Label R_Jumper), Abbild $4FCD0–$4FD6E
  const MV = MARSHES.vars;

  it("R_Jumper: läuft bis 128 Pixel vor die Eule, springt dann schräg nach oben, Ende ab y ≤ 240", () => {
    const r = start(0x4fcd0, [], MARSHES);
    r.e.setW(MV.routModPalCounter, 1);
    r.e.setL(MV.routPalPtr, 0x12345678);
    r.e.setW(MV.sorcererX, 100);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([596, 446, 0x15a, 5]);
    // 596 − 2 · 184 = 228 = Sorcerer_X + 128: Absprung
    r.run(183);
    expect([r.w(r.a3), r.w(r.a2 + X), r.w(r.a2 + OBJ)]).toEqual([1, 230, 0x15a]);
    r.run(1);
    expect([r.w(r.a3), r.w(r.a2 + X), r.w(r.a2 + OBJ)]).toEqual([2, 228, 0x174]);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ)]).toEqual([222, 438, 0x18e]);
    // 446 − 8 · 26 = 238 ≤ 240: Ende im 26. Sprung
    r.run(24);
    expect(r.e.ram.long(r.a0)).not.toBe(0xffffffff);
    r.run(1);
    expect(r.e.ram.long(r.a0)).toBe(0xffffffff);
    expect([r.e.w(MV.routModPalCounter), r.e.l(MV.routPalPtr)]).toEqual([1, 0x12345678]);
  });

  // Werte von Hand aus AG_GAME_LMARAIS.S (Label R_Sol_Kamikaze), Abbild $4FD7C–$4FE2A; R_SK_Shape $4FD70
  it("R_Sol_Kamikaze: läuft mit 2 Pixeln, stürmt ab Sorcerer_Y ≥ 376 mit 10 Pixeln, Ende ab x ≤ 220", () => {
    const r = start(0x4fd7c, [], MARSHES);
    r.e.setW(MV.routModPalCounter, 1);
    r.e.setL(MV.routPalPtr, 0x12345678);
    r.e.setW(MV.sorcererY, 256 + 119);
    r.run(1);
    expect([r.w(r.a3), r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([1, 596, 446, 0x208, 3]);
    // Formen 1, 1, 2, 2, 3, 3 (Schritt 1 zuerst): nach 10 Durchläufen Schritt 4
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + OBJ)]).toEqual([594, 0x208]);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + OBJ)]).toEqual([592, 0x222]);
    r.run(8);
    expect([r.w(r.a3), r.w(r.a3 + 2), r.w(r.a2 + X), r.w(r.a2 + OBJ)]).toEqual([1, 4, 576, 0x23c]);
    // Eule tief: Modus 2 erst nach diesem Durchlauf
    r.e.setW(MV.sorcererY, 256 + 120);
    r.run(1);
    expect([r.w(r.a3), r.w(r.a2 + X), r.w(r.a2 + OBJ)]).toEqual([2, 574, 0x23c]);
    r.run(1);
    expect([r.w(r.a3 + 2), r.w(r.a2 + X), r.w(r.a2 + OBJ)]).toEqual([0, 564, 0x208]);
    // 564 − 10 · 35 = 214 ≤ 220: Ende im 35. Sturm-Durchlauf, ohne Zählerabzug
    r.run(34);
    expect([r.e.ram.long(r.a0), r.w(r.a2 + X)]).toEqual([0x4fd7c, 224]);
    r.run(1);
    expect([r.e.ram.long(r.a0), r.w(r.bank)]).toEqual([0xffffffff, 0xffff]);
    expect([r.e.w(MV.routModPalCounter), r.e.l(MV.routPalPtr)]).toEqual([1, 0x12345678]);
  });

  // Werte von Hand aus AG_GAME_LMARAIS.S (Abschnitt „MONSTRE FINAL“, Label R_Final), Abbild $4FE74–$4FFFE;
  // Final_Shape $4FE2C ($9E $BE $DE $FA $11A $13A $11A $FA $DE $BE), Langue_Shape $4FE40 ($304 ×12, $316, $3CC, $3E8,
  // $408, $42A, $450, $478, …)
  it("R_Final: folgt der Eule, alle 50 Durchläufe die Zunge (Zähler bei $2), Ende nach der Explosion", () => {
    const r = start(0x4fe74, [], MARSHES);
    const a4 = r.a2 + AWO_LEN;
    r.e.setW(MV.sorcererX, 300);
    r.e.setW(MV.sorcererY, 300);
    expect(r.w(2)).toBe(0);
    r.run(1);
    expect([r.w(r.bank), r.w(r.a3), r.e.w(MV.routModPalCounter)]).toEqual([1, 1, 0]);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY), r.e.ram.byte(r.a2 + F_RT_S)])
      .toEqual([556, 336, 0x9e, 170, 12]);
    // Ziel (Sorcerer_X + 150, Sorcerer_Y + 40) = (450, 340), 2 Pixel je Durchlauf bis auf ≤ 2 heran
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(2), r.w(r.a3 + 2)]).toEqual([554, 338, 0xbe, 1, 0]);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ)]).toEqual([552, 338, 0xde]);
    // 50. Durchlauf in Modus 1: Zunge bei (x − 140, y), zwei Gegner in der Bank
    r.run(47);
    expect([r.w(r.a3), r.w(r.bank), r.w(2)]).toEqual([1, 1, 49]);
    r.run(1);
    expect([r.w(r.a3), r.w(r.a3 + 4), r.w(r.bank), r.w(2), r.w(r.a2 + X), r.w(r.a2 + OBJ)])
      .toEqual([2, 0xfffe, 2, 0, 456, 0x9e]);
    expect([r.w(a4 + X), r.w(a4 + Y), r.w(a4 + OBJ), r.w(a4 + ENERGY), r.e.ram.long(a4 + STATUS)])
      .toEqual([316, 338, 0x304, 100, 0]);
    // Modus 2: Endgegner steht, die Zunge zeigt Langue_Shape; 19. Durchlauf Obj_Langue_8
    r.run(12);
    expect([r.w(r.a2 + X), r.w(a4 + OBJ), r.w(r.bank)]).toEqual([456, 0x304, 2]);
    r.run(1);
    expect(r.w(a4 + OBJ)).toBe(0x316);
    r.run(6);
    expect(r.w(a4 + OBJ)).toBe(0x478);
    r.run(7);
    expect([r.w(r.a3), r.w(r.a3 + 4), r.w(a4 + OBJ), r.w(r.bank)]).toEqual([2, 50, 0x304, 2]);
    // 27. Durchlauf: zurück in Modus 1, die Bank zählt noch zwei Gegner (Zunge mit $304); ab dem nächsten Durchlauf
    // nur noch der Endgegner, erst dann läuft der Zähler weiter
    r.run(1);
    expect([r.w(r.a3), r.w(r.bank), r.w(2), r.w(r.a2 + X)]).toEqual([1, 2, 0, 456]);
    r.run(1);
    expect([r.w(r.bank), r.w(2), r.w(r.a2 + X)]).toEqual([1, 1, 454]);
    // nächste Zunge, dann getroffen: Zunge weg, Modus 1; das Byte geht an Final_Shape + 8 (schon $01)
    r.run(49);
    expect([r.w(r.a3), r.w(r.bank), r.w(r.a2 + X), r.w(a4 + X)]).toEqual([2, 2, 452, 312]);
    r.e.ram.setByte(r.a2 + STATUS, 1);
    r.run(1);
    expect([r.w(r.a3), r.w(r.bank), r.e.ram.byte(a4 + STATUS), r.w(0x4fe34)]).toEqual([1, 1, 0, 0x11a]);
    // Explosion läuft: folgt der Eule weiter
    r.e.setW(MV.sorcererX, 200);
    r.run(1);
    expect([r.e.ram.long(r.a0), r.w(r.a2 + X)]).toEqual([0x4fe74, 450]);
    // Explosion vorbei (Halbbyte $F): CLOSE, Quit_Delay 25, Clean_Up
    r.e.ram.setByte(r.a2 + STATUS, 0x0f);
    r.run(1);
    expect([r.e.ram.long(r.a0), r.w(r.bank), r.e.w(MV.quitDelay), r.e.b(MV.cleanUp)]).toEqual([0xffffffff, 0xffff, 25, 0xff]);
  });
});

describe.skipIf(!hasAssets)("Gegner-Routinen von Level 4, aus Level 1–3 bekannt (ohne Aufnahme)", () => {
  // Werte von Hand aus AG_GAME_LMONTAGNES.S, Abbild work/disasm/mountains_rout.txt; keine meldet eine Palette an
  const MV = MOUNTAINS.vars;
  const busy = (r: Rout): void => {
    r.e.setW(MV.routModPalCounter, 1);
    r.e.setL(MV.routPalPtr, 0x12345678);
  };
  const untouched = (r: Rout): number[] => [r.e.w(MV.routModPalCounter), r.e.l(MV.routPalPtr)];

  it("R_Bomber: Sack $DC, alle 24 Durchläufe eine Kugel $F6 auf Sin_Table1 ($4D43C)", () => {
    const r = start(0x4c412, [], MOUNTAINS);
    busy(r);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([596, 288, 0xdc, 15]);
    r.run(24);
    const b1 = r.a2 + AWO_LEN;
    expect([r.w(b1 + OBJ), r.w(b1 + ENERGY)]).toEqual([0xf6, 3]);
    r.run(1);
    expect([r.w(b1 + X), r.w(b1 + Y)]).toEqual([596 - 2 * 25 - 30, 428 - r.e.ram.byte(0x4d43c)]);
    expect(untouched(r)).toEqual([1, 0x12345678]);
  });

  it("R_Araignee: Spinne $9C ohne Palette, Richtung in Variable +4", () => {
    const r = start(0x4c368, [200, 3], MOUNTAINS);
    busy(r);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([596, 200, 0x9c, 10]);
    r.run(47);
    // abwärts 3 je Durchlauf bis y ≥ 340 (200 + 3 · 47 = 341), dann st.b +5
    expect([r.w(r.a2 + Y), r.w(r.a3 + 4)]).toEqual([341, 0xff]);
    expect(untouched(r)).toEqual([1, 0x12345678]);
  });

  it("R_Volant_Missile: Monster $244 ohne Palette; R_Sol_Kamikaze: $4CA", () => {
    const r = start(0x4bd54, [], MOUNTAINS);
    busy(r);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)]).toEqual([456, 220, 0x244, 20]);
    expect(untouched(r)).toEqual([1, 0x12345678]);
    const k = start(0x4c196, [], MOUNTAINS);
    busy(k);
    k.e.setW(MV.sorcererY, 256 + 119);
    k.run(1);
    expect([k.w(k.a2 + X), k.w(k.a2 + Y), k.w(k.a2 + OBJ), k.w(k.a2 + ENERGY)]).toEqual([596, 446, 0x4ca, 3]);
    expect(untouched(k)).toEqual([1, 0x12345678]);
  });

  it("R_Colonne_Flamme: 4 Flammen im Gleichtakt (O-018), Höhe aus R_CF_Hight alle 3 Durchläufe, Ende bei x 200", () => {
    const r = start(0x4c276, [], MOUNTAINS);
    busy(r);
    const flames = (o: number): number[] => [0, 1, 2, 3].map((i) => r.w(r.a2 + AWO_LEN * i + o));
    r.run(1);
    // Start: x 256 + 360, y ab 256 + 190 je 35 höher, Obj_Grande_Flamme_1 $198, Energie 32767, Status 0, 1 Flamme
    expect(r.w(r.bank)).toBe(1);
    expect(flames(X)).toEqual([616, 616, 616, 616]);
    expect(flames(Y)).toEqual([446, 411, 376, 341]);
    expect(flames(OBJ)).toEqual([0x198, 0x198, 0x198, 0x198]);
    expect(flames(ENERGY)).toEqual([32767, 32767, 32767, 32767]);
    expect([0, 1, 2, 3].map((i) => r.e.ram.long(r.a2 + AWO_LEN * i + STATUS))).toEqual([0, 0, 0, 0]);
    // move.l #$2,$2.l / move.l #$40006,$6.l statt in die Variablen +2–+8
    expect([2, 4, 6, 8].map((a) => r.w(a))).toEqual([0, 2, 4, 6]);
    expect([2, 4, 6, 8].map((o) => r.w(r.a3 + o))).toEqual([0, 0, 0, 0]);
    // 1. Durchlauf: alle Phasen 2 → Obj_Grande_Flamme_2 $1AA ($4C248)
    r.run(1);
    expect(flames(X)).toEqual([614, 614, 614, 614]);
    expect(flames(OBJ)).toEqual([0x1aa, 0x1aa, 0x1aa, 0x1aa]);
    // 8. Durchlauf: Phase 16 & $F = 0 → wieder $198; Höhe nach dem 6. Durchlauf R_CF_Hight[2] = 1
    r.run(7);
    expect(flames(OBJ)).toEqual([0x198, 0x198, 0x198, 0x198]);
    expect(r.w(r.bank)).toBe(1);
    // nach dem 21., 24., 27. Durchlauf R_CF_Hight[7], [8], [9] = 2, 3, 4; nach dem 42. [14] = 3
    r.run(13);
    expect(r.w(r.bank)).toBe(2);
    r.run(3);
    expect(r.w(r.bank)).toBe(3);
    r.run(3);
    expect(r.w(r.bank)).toBe(4);
    r.run(15);
    expect(r.w(r.bank)).toBe(3);
    // 207 Durchläufe: x 202, läuft noch; im 208. x 200 → CLOSE ohne Zählerabzug
    r.run(207 - 42);
    expect([r.w(r.a2 + X), r.e.ram.long(r.a0)]).toEqual([202, 0x4c276]);
    r.run(1);
    expect([r.w(r.a2 + X), r.e.ram.long(r.a0), r.w(r.bank)]).toEqual([200, 0xffffffff, 0xffff]);
    expect(untouched(r)).toEqual([1, 0x12345678]);
  });

  // Werte von Hand aus AG_GAME_LMONTAGNES.S (Label R_Sol_Guide), Abbild $4C55C–$4C6CE
  it("R_Sol_Guide: läuft bis P_SG_Launch, fliegt je nach Lage der Eule in eine von 5 Richtungen, Ende am Rand", () => {
    /** Start, 60 Durchläufe Laufen bis x = 456 (Parameter 256 + 200) mit der Eule bei (sx, sy): gewählter Modus */
    const launch = (sx: number, sy: number): Rout => {
      const r = start(0x4c55c, [456], MOUNTAINS);
      busy(r);
      r.e.setW(MV.sorcererX, sx);
      r.e.setW(MV.sorcererY, sy);
      r.run(1);
      return r;
    };
    const r = launch(400, 300);
    // Start: x 256 + 320, y 256 + 178, Obj_Sol_Guide_0 $3AA, Energie 5, Status 0
    expect([r.w(r.a3), r.w(r.bank), r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)])
      .toEqual([1, 1, 576, 434, 0x3aa, 5]);
    expect(r.e.ram.long(r.a2 + STATUS)).toBe(0);
    r.run(59);
    expect([r.w(r.a3), r.w(r.a2 + X), r.w(r.a2 + Y)]).toEqual([1, 458, 434]);
    // x 456 = Parameter: dx = 456 − (400 + 20) = 36 ≤ 40 → Modus 4, Bewegung erst im nächsten Durchlauf
    r.run(1);
    expect([r.w(r.a3), r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ)]).toEqual([4, 456, 434, 0x3aa]);
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ)]).toEqual([456, 431, 0x3e8]);
    // senkrecht 3 Pixel je Durchlauf: y 200 nach 78 Flug-Durchläufen läuft noch, bei 197 CLOSE ohne Zählerabzug
    r.run(77);
    expect([r.w(r.a2 + Y), r.e.ram.long(r.a0)]).toEqual([200, 0x4c55c]);
    r.run(1);
    expect([r.w(r.a2 + Y), r.e.ram.long(r.a0), r.w(r.bank)]).toEqual([197, 0xffffffff, 0xffff]);
    expect(untouched(r)).toEqual([1, 0x12345678]);

    /** Modus nach dem Abflugpunkt und der erste Flug-Durchlauf: [Modus, x, y, Objekt] */
    const fly = (sx: number, sy: number): number[] => {
      const g = launch(sx, sy);
      g.run(60);
      const m = g.w(g.a3);
      g.run(1);
      return [m, g.w(g.a2 + X), g.w(g.a2 + Y), g.w(g.a2 + OBJ)];
    };
    // Eule links (dx ≥ 0): ||dx| − (310 − Sorcerer_Y)| ≤ 70 → Modus 3 ($3D2, −3/−3), sonst Modus 2 ($3BC, −3/−1)
    expect(fly(300, 244)).toEqual([3, 453, 431, 0x3d2]); // |136 − 66| = 70
    expect(fly(300, 250)).toEqual([2, 453, 433, 0x3bc]); // |136 − 60| = 76
    // dx = 41 ist schon zu weit für Modus 4
    expect(fly(395, 300)).toEqual([3, 453, 431, 0x3d2]); // |41 − 10| = 31
    // Eule rechts (dx < 0): Modus 5 ($3FE, +3/−3) bzw. Modus 6 ($414, +3/−1)
    expect(fly(500, 300)).toEqual([5, 459, 431, 0x3fe]); // |64 − 10| = 54
    expect(fly(600, 300)).toEqual([6, 459, 433, 0x414]); // |164 − 10| = 154
    // dx = −40 → Modus 4
    expect(fly(476, 300)).toEqual([4, 456, 431, 0x3e8]);

    // Modus 6: Ende, sobald x > 256 + 330 (456 + 3 · 44 = 588)
    const g = launch(600, 300);
    g.run(60 + 43);
    expect([g.w(g.a2 + X), g.e.ram.long(g.a0)]).toEqual([585, 0x4c55c]);
    g.run(1);
    expect([g.w(g.a2 + X), g.e.ram.long(g.a0)]).toEqual([588, 0xffffffff]);

    // ungerader Parameter: x trifft ihn nie, das Monster läuft bis x < 200 (576 − 2 · 189 = 198)
    const o = start(0x4c55c, [457], MOUNTAINS);
    busy(o);
    o.run(1 + 188);
    expect([o.w(o.a3), o.w(o.a2 + X), o.e.ram.long(o.a0)]).toEqual([1, 200, 0x4c55c]);
    o.run(1);
    expect([o.w(o.a2 + X), o.e.ram.long(o.a0)]).toEqual([198, 0xffffffff]);

    // CLOSE bei Rout_Mod_Pal_Counter = 0: Palette des Levels zurück
    const z = start(0x4c55c, [457], MOUNTAINS);
    z.e.setW(MV.routModPalCounter, 0);
    z.e.setL(MV.routPalPtr, 0x12345678);
    z.run(190);
    expect([z.e.w(MV.routModPalCounter), z.e.l(MV.routPalPtr)]).toEqual([0, 0xffffffff]);
  });

  // Werte von Hand aus AG_GAME_LMONTAGNES.S (Label R_Dragon), Abbild $4C710–$4C85E
  it("R_Dragon: fliegt 2 Pixel je Durchlauf, alle 30 Durchläufe eine Feuerzunge, Ende bei x 180", () => {
    const r = start(0x4c710, [256 + 60], MOUNTAINS);
    busy(r);
    const a4 = r.a2 + AWO_LEN;
    // Dragon_Shape: 7 × Obj_Dragon_1 $54E, 3 × Obj_Dragon_2 $56E; Langue_Shape: 12 × Obj_Fire_1 $58E, dann Obj_Fire_2–8
    const langue = [...Array(12).fill(0x58e), 0x5a0, 0x5b6, 0x5ce, 0x5ea, 0x608, 0x62a, 0x64e];
    expect([...Array(10).keys()].map((i) => r.w(0x4c6d6 + 2 * i))).toEqual([...Array(7).fill(0x54e), 0x56e, 0x56e, 0x56e]);
    expect(langue.map((_, i) => r.w(0x4c6ea + 2 * i))).toEqual(langue);
    // Start: x 256 + 350, y = P_D_Y, Obj_Dragon_1, Energie 8, Schussrate 10
    r.run(1);
    expect([r.w(r.a3), r.w(r.bank), r.w(r.a2 + X), r.w(r.a2 + Y), r.w(r.a2 + OBJ), r.w(r.a2 + ENERGY)])
      .toEqual([1, 1, 606, 316, 0x54e, 8]);
    expect(r.e.ram.long(r.a2 + STATUS)).toBe(0x000a0000);
    // Durchlauf k: x = 606 − 2k, Bild Dragon_Shape[k mod 10], R_D_Langue_Delay = k
    r.run(1);
    expect([r.w(r.a2 + X), r.w(r.a2 + OBJ), r.w(r.a3 + 2), r.w(r.a3 + 6)]).toEqual([604, 0x54e, 1, 2]);
    r.run(6);
    expect([r.w(r.a2 + X), r.w(r.a2 + OBJ)]).toEqual([592, 0x56e]);
    r.run(3);
    expect([r.w(r.a2 + X), r.w(r.a2 + OBJ), r.w(r.a3 + 6)]).toEqual([586, 0x54e, 0]);
    // Durchlauf 30: Zunge bei (x − 190, y), Obj_Fire_1, Energie 100, Status 0; Modus 2, R_D_Langue_Step −2
    r.run(19);
    expect([r.w(r.a3), r.w(r.bank), r.w(r.a3 + 2)]).toEqual([1, 1, 29]);
    r.run(1);
    expect([r.w(r.a3), r.w(r.bank), r.w(r.a3 + 2), r.w(r.a3 + 4), r.w(r.a2 + X)]).toEqual([2, 2, 0, 0xfffe, 546]);
    expect([r.w(a4 + X), r.w(a4 + Y), r.w(a4 + OBJ), r.w(a4 + ENERGY), r.e.ram.long(a4 + STATUS)])
      .toEqual([356, 316, 0x58e, 100, 0]);
    // Modus 2, Zug m: Zunge x 356 − 2m mit Langue_Shape[m − 1]; ab Obj_Fire_8 (Zug 19, x 318) 14 Pixel je Zug
    const tongue: number[][] = [];
    for (let m = 1; m <= 21; m++) {
      r.run(1);
      tongue.push([r.w(r.a3), r.w(r.bank), r.w(a4 + X), r.w(a4 + OBJ)]);
    }
    expect(tongue.slice(0, 19)).toEqual(langue.map((o, i) => [2, 2, 354 - 2 * i, o]));
    expect(tongue.slice(19)).toEqual([[2, 2, 304, 0x64e], [2, 2, 290, 0x64e]]);
    // Zug 33: x 122 ≤ 130 → Modus 1, die Bank zählt in diesem Zug noch 2 Gegner; R_D_Langue_Delay zählt erst danach
    r.run(11);
    expect([r.w(r.a3), r.w(r.bank), r.w(a4 + X)]).toEqual([2, 2, 136]);
    r.run(1);
    expect([r.w(r.a3), r.w(r.bank), r.w(a4 + X), r.w(r.a3 + 2), r.w(r.a2 + X)]).toEqual([1, 2, 122, 0, 480]);
    r.run(1);
    expect([r.w(r.a3), r.w(r.bank), r.w(r.a3 + 2)]).toEqual([1, 1, 1]);
    // nächste Zunge 30 Durchläufe später; Drache getroffen (Halbbyte ≠ 0): Zunge sofort weg, Modus 1
    r.run(29);
    expect([r.w(r.a3), r.w(r.bank), r.w(r.a2 + X), r.w(a4 + X)]).toEqual([2, 2, 420, 230]);
    r.run(1);
    r.e.ram.setByte(r.a2 + STATUS, 0x01);
    r.run(1);
    expect([r.w(r.a3), r.w(r.bank), r.w(a4 + X), r.w(r.a3 + 2)]).toEqual([1, 1, 228, 0]);
    // Explosion beendet (Halbbyte $F): keine Zunge mehr, R_D_Langue_Delay zählt über 30 hinaus
    r.e.ram.setByte(r.a2 + STATUS, 0x0f);
    r.run(31);
    expect([r.w(r.a3), r.w(r.bank), r.w(r.a3 + 2), r.w(r.a2 + X), r.e.ram.long(r.a0)]).toEqual([1, 1, 31, 354, 0x4c710]);
    // weiter 2 Pixel je Durchlauf: x 182 läuft noch, bei x 180 CLOSE ohne Zählerabzug
    r.run(86);
    expect([r.w(r.a2 + X), r.e.ram.long(r.a0)]).toEqual([182, 0x4c710]);
    r.run(1);
    expect([r.w(r.a2 + X), r.e.ram.long(r.a0), r.w(r.bank)]).toEqual([180, 0xffffffff, 0xffff]);
    expect(untouched(r)).toEqual([1, 0x12345678]);

    // tief geflogene Zunge: Start bei Drachen-x ≤ 320 → x ≤ 130 schon im ersten Zug
    const t = start(0x4c710, [256 + 140], MOUNTAINS);
    t.run(1);
    t.e.ram.setWord(t.a2 + X, 352);
    t.run(30);
    expect([t.w(t.a3), t.w(t.bank), t.w(t.a2 + X), t.w(t.a2 + AWO_LEN + X)]).toEqual([2, 2, 292, 102]);
    t.run(1);
    expect([t.w(t.a3), t.w(t.bank), t.w(t.a2 + AWO_LEN + X), t.w(t.a2 + AWO_LEN + OBJ)]).toEqual([1, 2, 100, 0x58e]);
  });
});
