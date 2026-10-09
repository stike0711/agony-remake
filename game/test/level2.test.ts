// Level 2 (Wald) ohne Aufnahme: Layout aus der ausgerichteten Disassembly (tools/analysis/align_levels.py), Start
// mit den gemeinsamen Variablen aus Level 1, mit Dauerfeuer bis zum Levelende. Gegen das Original noch ungeprüft.

import { describe, expect, it } from "vitest";
import { Display } from "../src/core/display.ts";
import { JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP } from "../src/core/input.ts";
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

  it("übernimmt die gemeinsamen Variablen, läuft ohne Regen bis zum Endgegner und mit Dauerfeuer bis zum Levelende", () => {
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
    const started = new Set<number>();
    // ab Bild 58 Dauerfeuer mit dem Bewegungsmuster von explore-level.ts (dort ab Bild 13170)
    let finalAt = -1, quitAt = -1, k = 0, n = 0, f = 0;
    for (; f < 16000 && !e.unported && !e.result; f++) {
      let input = f === 49 || f === 50 ? JOY_FIRE : 0;
      if (f >= 58) {
        if (n === 0) { [n] = PATTERN[k % PATTERN.length]!; k++; }
        input = JOY_FIRE | PATTERN[(k - 1) % PATTERN.length]![1];
        n--;
      }
      e.setInput(input);
      if (e.ram.word(SHARED.life) < 3) e.ram.setWord(SHARED.life, 7);
      e.tick(display);
      // ohne Regen und Zauber zeigen Sprite 6 und 7 die leere Liste (SPELL OFF, $54CC in sea)
      if (f === 40) expect([e.ram.long(L.d + V.sprPtrB + 24), e.ram.long(L.d + V.sprPtrB + 28)]).toEqual([L.emptySpr, L.emptySpr]);
      for (let i = 0; i < 32; i++) {
        const c = e.ram.long(L.routStruct + 28 * i);
        if (c !== 0xffffffff) started.add(c);
        if (c === 0x4c39e && finalAt < 0) finalAt = f;
      }
      if (quitAt < 0 && e.w(V.quitDelay) !== 0) quitAt = f;
    }
    // alle Routinen des Levels sind gestartet, darunter R_Kamikaze ($4C048) und R_Sol_Etoile ($4C160), zuletzt R_Final
    expect([...started].sort((a, b) => a - b))
      .toEqual([0x4b76c, 0x4b964, 0x4bb60, 0x4bee4, 0x4bfa2, 0x4c048, 0x4c160, 0x4c39e]);
    expect(e.unported).toBeNull();
    expect(e.result).toBe("levelDone");
    // START_C R_Final bei WAIT $22F0; Bildnummern aus dem Nachbau (Regression, gegen das Original ungeprüft)
    expect([finalAt, quitAt, f]).toEqual([FINAL_AT, QUIT_AT, END_AT]);
  }, 180_000);
});

/** Bewegungsmuster des Planungs-Bots (wie explore-level.ts): Dauer in Bildern, Richtung */
const PATTERN: [number, number][] = [
  [25, JOY_UP], [30, 0], [25, JOY_DOWN], [20, 0], [15, JOY_RIGHT], [30, JOY_DOWN], [20, 0], [15, JOY_LEFT], [40, JOY_UP],
  [25, 0],
];
const FINAL_AT = 9068;
const QUIT_AT = 12113;
const END_AT = 12317;
