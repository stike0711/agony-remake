// Level 2 (Wald) ohne Aufnahme: Layout aus der ausgerichteten Disassembly (tools/analysis/align_levels.py), Start
// mit den gemeinsamen Variablen aus Level 1. Gegen das Original noch ungeprüft.

import { describe, expect, it } from "vitest";
import { Display } from "../src/core/display.ts";
import { JOY_FIRE } from "../src/core/input.ts";
import { LevelEngine } from "../src/core/level/engine.ts";
import { FOREST, SHARED, SHARED_LENGTH, SHARED_START } from "../src/core/level/layout.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const L = FOREST;
const V = L.vars;

describe.skipIf(!hasAssets)("Level 2 (ohne Aufnahme)", () => {
  it("hat Copperliste, Muster und Startliste an den abgeleiteten Adressen", () => {
    const e = new LevelEngine(L, loadAssets().memory);
    // Main_Cl beginnt mit SPR0PTH, Cl_Flip_Phase1 mit $0192, Back_Pattern mit $0020, Startliste mit WAIT $10
    expect([L.mainCl, L.clFlipPhase1, L.backPattern, L.startList].map((a) => e.ram.word(a))).toEqual([0x120, 0x192, 0x20, 0x10]);
    // erster Eintrag: START_A DGDP_Full_7c ($4B56E), 256 + 240, 198 (Quelle: Ag_Game_LFORET.s, Label Start_List)
    expect([e.ram.long(L.startList + 2), e.ram.word(L.startList + 6), e.ram.word(L.startList + 8)])
      .toEqual([0x4004b56e, 496, 198]);
  });

  it("übernimmt die gemeinsamen Variablen und läuft ohne Regen bis zur ersten Gegner-Routine", () => {
    const shared = new Uint8Array(SHARED_LENGTH);
    const put = (a: number, v: number, n: number): void => { for (let i = 0; i < n; i++) shared[a - SHARED_START + i] = (v >>> (8 * (n - 1 - i))) & 0xff; };
    put(SHARED.score, 0x12345, 4);
    put(SHARED.life, 0b11, 2);
    put(SHARED.fwFireWeapon, 2, 2);
    const e = new LevelEngine(L, loadAssets().memory);
    e.start(shared);
    expect([e.ram.long(SHARED.score), e.ram.word(SHARED.life), e.ram.word(SHARED.fwFireWeapon)]).toEqual([0x12345, 3, 2]);
    expect(e.w(V.rainOn)).toBe(0);
    const display = new Display();
    display.setMode(true, false);
    for (let f = 0; f < 2000 && !e.unported && !e.result; f++) {
      e.setInput(f === 49 || f === 50 ? JOY_FIRE : 0);
      if (e.ram.word(SHARED.life) < 3) e.ram.setWord(SHARED.life, 7);
      e.tick(display);
      // ohne Regen und Zauber zeigen Sprite 6 und 7 die leere Liste (SPELL OFF, $54CC in sea)
      if (f === 40) expect([e.ram.long(L.d + V.sprPtrB + 24), e.ram.long(L.d + V.sprPtrB + 28)]).toEqual([L.emptySpr, L.emptySpr]);
    }
    // erste nicht übertragene Stelle: START_C R_Kamikaze bei WAIT $170
    expect(e.result).toBeNull();
    expect(e.unported).toContain("$4C048");
    expect(e.w(V.levelX)).toBeGreaterThanOrEqual(0x170);
  });
});
