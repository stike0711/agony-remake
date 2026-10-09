// Level 5 (Hochland) ohne Aufnahme: Layout aus MOUNTAINS übertragen (tools/analysis/derive_layout.py), Start mit den
// gemeinsamen Variablen aus Level 4, nur mit Feuer zum Start bis zur ersten nicht übertragenen Gegner-Routine. Gegen das Original
// noch ungeprüft.

import { describe, expect, it } from "vitest";
import { Display } from "../src/core/display.ts";
import { JOY_FIRE } from "../src/core/input.ts";
import { LevelEngine } from "../src/core/level/engine.ts";
import { HIGHLANDS, SHARED, SHARED_LENGTH, SHARED_START } from "../src/core/level/layout.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const L = HIGHLANDS;

describe.skipIf(!hasAssets)("Level 5 (ohne Aufnahme)", () => {
  it("hat Copperliste, Muster und Startliste an den abgeleiteten Adressen", () => {
    const e = new LevelEngine(L, loadAssets().memory);
    // Main_Cl beginnt mit SPR0PTH, Cl_Flip_Phase1 mit $0192, Back_Pattern mit $0020, Startliste mit WAIT $10
    expect([L.mainCl, L.clFlipPhase1, L.backPattern, L.startList].map((a) => e.ram.word(a))).toEqual([0x120, 0x192, 0x20, 0x10]);
    // erster Eintrag: START_A DGDP_Full_7c, 320 + 256, 256 (Quelle: Ag_Game_LPLATEAUX.s, Label Start_List)
    expect([e.ram.word(L.startList + 6), e.ram.word(L.startList + 8)]).toEqual([576, 256]);
    // zweiter Eintrag: WAIT $20, START_C R_Rapide
    expect([e.ram.word(L.startList + 10), e.ram.long(L.startList + 12) & 0xffffff]).toEqual([0x20, 0x4fd50]);
  });

  it("übernimmt die gemeinsamen Variablen und läuft bis zur ersten Gegner-Routine", () => {
    const shared = new Uint8Array(SHARED_LENGTH);
    shared[SHARED.life - SHARED_START + 1] = 0b111;
    const e = new LevelEngine(L, loadAssets().memory);
    e.start(shared);
    expect(e.ram.word(SHARED.life)).toBe(7);
    const display = new Display();
    display.setMode(true, false);
    let f = 0;
    // Feuer in Bild 49/50 startet das Level (wie level4.test.ts), danach keine Eingabe
    for (; f < 2000 && !e.unported && !e.result; f++) {
      e.setInput(f === 49 || f === 50 ? JOY_FIRE : 0);
      e.tick(display);
    }
    // R_Rapide ($4FD50, zweiter Eintrag der Startliste) ist noch nicht übertragen
    expect([f, String(e.unported)]).toEqual([115, "Gegner mit eigener Routine $4FD50"]);
  });
});
