// Level 4 (Berge) ohne Aufnahme: Layout aus MARSHES übertragen (tools/analysis/derive_layout.py), Start mit den
// gemeinsamen Variablen aus Level 3, mit Dauerfeuer bis zur ersten noch nicht übertragenen Gegner-Routine. Gegen das
// Original noch ungeprüft.

import { describe, expect, it } from "vitest";
import { Display } from "../src/core/display.ts";
import { JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP } from "../src/core/input.ts";
import { LevelEngine } from "../src/core/level/engine.ts";
import { MOUNTAINS, SHARED, SHARED_LENGTH, SHARED_START } from "../src/core/level/layout.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const L = MOUNTAINS;
const V = L.vars;

describe.skipIf(!hasAssets)("Level 4 (ohne Aufnahme)", () => {
  it("hat Copperliste, Muster und Startliste an den abgeleiteten Adressen", () => {
    const e = new LevelEngine(L, loadAssets().memory);
    // Main_Cl beginnt mit SPR0PTH, Cl_Flip_Phase1 mit $0192, Back_Pattern mit $0020, Startliste mit WAIT $40
    expect([L.mainCl, L.clFlipPhase1, L.backPattern, L.startList].map((a) => e.ram.word(a))).toEqual([0x120, 0x192, 0x20, 0x40]);
    // erster Eintrag: START_A DGDP_Boulle ($4BB88), 256 + 300, 256 + 100 (Quelle: AG_GAME_LMONTAGNES.S, Label
    // Start_List)
    expect([e.ram.long(L.startList + 2), e.ram.word(L.startList + 6), e.ram.word(L.startList + 8)])
      .toEqual([0x4004bb88, 556, 356]);
    // zweiter Eintrag (WAIT $80): START_C R_Bomber ($4C412), PAR_END
    expect([e.ram.word(L.startList + 10), e.ram.long(L.startList + 12), e.ram.word(L.startList + 16)])
      .toEqual([0x80, 0x8004c412, 0xffff]);
  });

  it("übernimmt die gemeinsamen Variablen und läuft mit Dauerfeuer bis zur ersten Gegner-Routine", () => {
    const shared = new Uint8Array(SHARED_LENGTH);
    const put = (a: number, v: number, n: number): void => { for (let i = 0; i < n; i++) shared[a - SHARED_START + i] = (v >>> (8 * (n - 1 - i))) & 0xff; };
    put(SHARED.score, 0x54321, 4);
    put(SHARED.life, 0b111, 2);
    put(SHARED.fwFireWeapon, 1, 2);
    const e = new LevelEngine(L, loadAssets().memory);
    e.start(shared);
    expect([e.ram.long(SHARED.score), e.ram.word(SHARED.life), e.ram.word(SHARED.fwFireWeapon)]).toEqual([0x54321, 7, 1]);
    expect(e.w(V.rainOn)).toBe(0);
    const display = new Display();
    display.setMode(true, false);
    // ab Bild 58 Dauerfeuer mit dem Bewegungsmuster von explore-level.ts (dort ab Bild 13170)
    let k = 0, n = 0, f = 0;
    for (; f < 2000 && !e.unported && !e.result; f++) {
      let input = f === 49 || f === 50 ? JOY_FIRE : 0;
      if (f >= 58) {
        if (n === 0) { [n] = PATTERN[k % PATTERN.length]!; k++; }
        input = JOY_FIRE | PATTERN[(k - 1) % PATTERN.length]![1];
        n--;
      }
      e.setInput(input);
      if (e.ram.word(SHARED.life) < 3) e.ram.setWord(SHARED.life, 7);
      e.tick(display);
      // ohne Regen und Zauber zeigen Sprite 6 und 7 die leere Liste
      if (f === 40) expect([e.ram.long(L.d + V.sprPtrB + 24), e.ram.long(L.d + V.sprPtrB + 28)]).toEqual([L.emptySpr, L.emptySpr]);
    }
    // R_Bomber (WAIT $80) läuft (übertragen wie Level 1), die Engine hält am ersten R_Colonne_Flamme (WAIT $140); Bildnummer aus
    // dem Nachbau (Regression, gegen das Original ungeprüft)
    expect(e.result).toBeNull();
    expect(e.unported).toContain("$4C276");
    expect(e.w(V.levelX)).toBeGreaterThanOrEqual(0x140);
    expect(e.w(V.levelX)).toBeLessThan(0x150);
    expect(f).toBe(UNPORTED_AT);
  }, 60_000);
});

/** Bewegungsmuster des Planungs-Bots (wie explore-level.ts): Dauer in Bildern, Richtung */
const PATTERN: [number, number][] = [
  [25, JOY_UP], [30, 0], [25, JOY_DOWN], [20, 0], [15, JOY_RIGHT], [30, JOY_DOWN], [20, 0], [15, JOY_LEFT], [40, JOY_UP],
  [25, 0],
];
const UNPORTED_AT = 403;
