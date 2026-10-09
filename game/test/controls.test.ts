// Bedienung nach E-043 ohne Aufnahme: Option „Feuermenü“ (Menu_Mode), „Spiel beenden“ im Optionsmenü (wie Esc,
// sea $5E22) und Pause beim Wechsel in den Hintergrund (wie Taste P, $5D96).

import { describe, expect, it } from "vitest";
import { Game, type Screen } from "../src/core/game.ts";
import { BTN_OPTIONS, InputFrame, JOY_DOWN, JOY_FIRE } from "../src/core/input.ts";
import { SEA, SHARED } from "../src/core/level/layout.ts";
import { LevelScreen } from "../src/core/screens/level.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const V = SEA.vars;

function start(spellFire: boolean): { game: Game; level: LevelScreen; press: (buttons: number) => void } {
  const end: Screen = { enter: () => {}, tick: () => {} };
  const level = new LevelScreen(SEA, { gameOver: () => end, levelDone: () => end, unported: () => end });
  const game = new Game(loadAssets(), { lang: "en", spellFire }, level);
  const input = new InputFrame();
  return {
    game,
    level,
    // ein Takt gedrückt, einer losgelassen
    press: (buttons) => {
      input.buttons = buttons;
      game.tick(input);
      input.buttons = 0;
      game.tick(input);
    },
  };
}

describe.skipIf(!hasAssets)("Bedienung nach E-043", () => {
  it("Feuermenü setzt Menu_Mode beim Start und bei jeder Änderung", () => {
    const { game, level } = start(true);
    expect(level.engine.ram.word(SHARED.menuMode)).toBe(1);
    game.setSpellFire(false);
    expect([level.engine.ram.word(SHARED.menuMode), game.settings.spellFire]).toEqual([0, false]);
    expect(start(false).level.engine.ram.word(SHARED.menuMode)).toBe(0);
  }, 30_000);

  it("„Spiel beenden“ fragt nach und wirkt wie Esc (Quit_Delay 20, keine Leben, Clean_Up)", () => {
    const { game, level, press } = start(false);
    expect(game.canQuit).toBe(true);
    press(BTN_OPTIONS);
    // Einträge: Sprache, Feuermenü, Spiel beenden, Zurück
    press(JOY_DOWN);
    press(JOY_DOWN);
    press(JOY_FIRE);
    const e = level.engine;
    expect(e.w(V.quitDelay)).toBe(0);
    press(JOY_FIRE);
    expect([e.w(V.quitDelay), e.ram.word(SHARED.life), e.b(V.cleanUp)]).toEqual([20, 0, 0xff]);
  }, 30_000);

  it("Hintergrund pausiert das Level einmal (kein Umschalten bei erneutem Wechsel)", () => {
    const { game, level } = start(false);
    const e = level.engine;
    // während „LET'S GO“ (Begin_To_Start) ignoriert das Original die Taste P
    game.pause();
    expect(e.w(V.pause)).toBe(0);
    e.setW(V.beginToStart, 0);
    game.pause();
    expect([e.w(V.pause), e.w(V.textNum)]).toEqual([0xff, 10]);
    game.pause();
    expect(e.w(V.pause)).toBe(0xff);
  }, 30_000);
});
