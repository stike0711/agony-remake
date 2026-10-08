// Levelende (Quit_Delay, Exit) ohne Aufnahme: Werte aus dem Quelltext (Ag_Sprites.s JOYSTICK TEST,
// Agony_Parent_.s QUIT DELAY und Exit). Gegen das Original noch ungeprüft.

import { describe, expect, it } from "vitest";
import { Display } from "../src/core/display.ts";
import { JOY_RIGHT } from "../src/core/input.ts";
import { LevelEngine } from "../src/core/level/engine.ts";
import { copperInterrupt } from "../src/core/level/interrupt.ts";
import { SEA, SHARED } from "../src/core/level/layout.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const V = SEA.vars;

describe.skipIf(!hasAssets)("Levelende (ohne Aufnahme)", () => {
  it("hält die Eule an, schreibt aber weiter ihr Kollisionsrechteck", () => {
    const e = new LevelEngine(SEA, loadAssets().memory);
    e.start();
    e.setW(V.sorcererX, 300);
    e.setW(V.sorcererY, 300);
    e.setW(V.axeDelay, 5);
    e.setW(V.quitDelay, 50);
    e.setInput(JOY_RIGHT);
    e.setW(V.genPhase, 0);
    copperInterrupt(e);
    // keine Bewegung; Rechteck x … x + 32, y + 37 … y + 53; Axe_Delay bleibt (d6 des Hauptprogramms, nicht nachgebildet)
    expect([e.w(V.sorcererX), e.w(V.sorcererY), e.w(V.axeDelay)]).toEqual([300, 300, 5]);
    expect([0, 2, 4, 6].map((o) => e.ram.word(SEA.goodColList + o))).toEqual([300, 337, 332, 353]);
    // ohne Quit_Delay bewegt der Joystick die Eule um 3 Pixel
    e.setW(V.quitDelay, 0);
    e.setW(V.genPhase, 0);
    copperInterrupt(e);
    expect(e.w(V.sorcererX)).toBe(303);
  });

  for (const [life, result] of [[3, "levelDone"], [0, "gameOver"]] as const) {
    it(`Exit bei Quit_Delay 1 führt mit Leben ${life} zu ${result}`, () => {
      const e = new LevelEngine(SEA, loadAssets().memory);
      e.start();
      e.ram.setWord(SHARED.life, life);
      e.setW(V.quitDelay, 3);
      const display = new Display();
      display.setMode(true, false);
      for (let i = 0; i < 20 && !e.result; i++) e.tick(display);
      expect(e.unported).toBeNull();
      expect([e.result, e.w(V.quitDelay)]).toEqual([result, 1]);
    });
  }
});
