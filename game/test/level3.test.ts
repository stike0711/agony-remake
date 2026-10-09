// Level 3 (Sumpf) ohne Aufnahme: Layout aus FOREST übertragen (tools/analysis/derive_layout.py), Start mit den
// gemeinsamen Variablen aus Level 2, mit Dauerfeuer bis zur ersten noch nicht übertragenen Gegner-Routine
// (Endgegner R_Final). Gegen das Original noch ungeprüft.

import { describe, expect, it } from "vitest";
import { Display } from "../src/core/display.ts";
import { JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP } from "../src/core/input.ts";
import { LevelEngine } from "../src/core/level/engine.ts";
import { MARSHES, SHARED, SHARED_LENGTH, SHARED_START } from "../src/core/level/layout.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const L = MARSHES;
const V = L.vars;

describe.skipIf(!hasAssets)("Level 3 (ohne Aufnahme)", () => {
  it("hat Copperliste, Muster und Startliste an den abgeleiteten Adressen", () => {
    const e = new LevelEngine(L, loadAssets().memory);
    // Main_Cl beginnt mit SPR0PTH, Cl_Flip_Phase1 mit $0192, Back_Pattern mit $0020, Startliste mit WAIT $10
    expect([L.mainCl, L.clFlipPhase1, L.backPattern, L.startList].map((a) => e.ram.word(a))).toEqual([0x120, 0x192, 0x20, 0x10]);
    // erster Eintrag: START_A DGDP_Monster_3 ($4EE10), 256 + 300, 256 (Quelle: AG_GAME_LMARAIS.S, Label Start_List)
    expect([e.ram.long(L.startList + 2), e.ram.word(L.startList + 6), e.ram.word(L.startList + 8)])
      .toEqual([0x4004ee10, 556, 256]);
    // vierter Eintrag (WAIT $140): START_C R_Rapide ($4F6A2)
    expect([e.ram.word(L.startList + 30), e.ram.long(L.startList + 32)]).toEqual([0x140, 0x8004f6a2]);
  });

  it("übernimmt die gemeinsamen Variablen und läuft mit Dauerfeuer bis zum Endgegner R_Final", () => {
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
    let kamikazeAt = -1, k = 0, n = 0, f = 0;
    const started = new Set<number>();
    for (; f < 12000 && !e.unported && !e.result; f++) {
      let input = f === 49 || f === 50 ? JOY_FIRE : 0;
      if (f >= 58) {
        if (n === 0) { [n] = PATTERN[k % PATTERN.length]!; k++; }
        input = JOY_FIRE | PATTERN[(k - 1) % PATTERN.length]![1];
        n--;
      }
      e.setInput(input);
      if (e.ram.word(SHARED.life) < 3) e.ram.setWord(SHARED.life, 7);
      e.tick(display);
      for (let i = 0; i < 32; i++) {
        const code = e.ram.long(L.routStruct + 28 * i);
        if (code !== 0xffffffff) started.add(code);
        if (code === 0x4fd7c && kamikazeAt < 0) kamikazeAt = f;
      }
      // ohne Regen und Zauber zeigen Sprite 6 und 7 die leere Liste
      if (f === 40) expect([e.ram.long(L.d + V.sprPtrB + 24), e.ram.long(L.d + V.sprPtrB + 28)]).toEqual([L.emptySpr, L.emptySpr]);
    }
    // alle übrigen Routinen des Levels laufen, erster R_Sol_Kamikaze ($4FD7C) im Bild KAMIKAZE_AT; dann hält die
    // Engine am Endgegner R_Final ($4FE74). Bildnummern aus dem Nachbau (Regression, gegen das Original ungeprüft)
    expect(e.result).toBeNull();
    expect(e.unported).toContain("$4FE74");
    expect([...started].sort((a, b) => a - b)).toEqual([0x4ef2a, 0x4f122, 0x4f30a, 0x4f6a2, 0x4f740, 0x4f878, 0x4fa22,
      0x4fb7a, 0x4fcd0, 0x4fd7c, 0x4fe74]);
    expect(e.w(V.routModPalCounter)).toBe(0);
    expect([kamikazeAt, f]).toEqual([KAMIKAZE_AT, UNPORTED_AT]);
    expect(e.ram.long(SHARED.score)).toBeGreaterThan(0x54321);
  }, 180_000);
});

/** Bewegungsmuster des Planungs-Bots (wie explore-level.ts): Dauer in Bildern, Richtung */
const PATTERN: [number, number][] = [
  [25, JOY_UP], [30, 0], [25, JOY_DOWN], [20, 0], [15, JOY_RIGHT], [30, JOY_DOWN], [20, 0], [15, JOY_LEFT], [40, JOY_UP],
  [25, 0],
];
const KAMIKAZE_AT = 1363;
const UNPORTED_AT = 9046;
