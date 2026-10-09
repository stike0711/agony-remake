// Spielschleife: Bildschirmwechsel, Optionsmenü, Sprache, Determinismus per Replay.

import { describe, expect, it } from "vitest";
import { Game } from "../src/core/game.ts";
import { BTN_OPTIONS, InputFrame, JOY_FIRE, JOY_RIGHT } from "../src/core/input.ts";
import { displayChecksum, Replay } from "../src/core/replay.ts";
import { titleSequence } from "../src/core/flow.ts";
import { StartGate } from "../src/core/screens/start-gate.ts";
import { MenuScreen, STORY_FRAMES, STORY_MIN_FRAMES } from "../src/core/screens/menu.ts";
import { LOAD_FOREST, LOAD_MARSHES, LOAD_SEA, LOADING_MIN_FRAMES, LoadingScreen } from "../src/core/screens/loading.ts";
import type { Screen } from "../src/core/game.ts";
import { PROMPT_ON_FRAMES } from "../src/core/prompt.ts";
import { CC_PER_LINE } from "../src/core/timing.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";
import { COLORS } from "../src/core/display.ts";

describe.skipIf(!hasAssets)("Game", () => {
  const assets = hasAssets ? loadAssets() : null!;
  const newGame = (lang: "en" | "de" = "en") => new Game(assets, { lang }, new StartGate(titleSequence));

  function run(game: Game, replay: Replay): number {
    const input = new InputFrame();
    for (let t = 0; t < replay.length; t++) {
      replay.read(t, input);
      game.tick(input);
    }
    const d = game.display;
    return displayChecksum(d.pixels, d.palette, d.width * d.height, d.height * COLORS);
  }

  it("ist deterministisch: dasselbe Replay ergibt dasselbe Bild", () => {
    const replay = Replay.fromChanges(600, [[10, JOY_FIRE], [12, 0], [100, JOY_RIGHT], [101, 0], [300, JOY_FIRE], [302, 0]]);
    const a = run(newGame(), replay);
    const b = run(newGame(), replay);
    expect(a).toBe(b);
  });

  it("startet nach Feuer die Titelsequenz mit dem Klangteppich auf Kanal 0 und 1", () => {
    const game = newGame();
    const input = new InputFrame();
    game.tick(input);
    input.buttons = JOY_FIRE;
    game.tick(input); // StartGate → Titelsequenz
    input.buttons = 0;
    game.tick(input);
    expect(game.paula.dmacon).toBe(0b0011);
    expect(game.display.hires && game.display.lace).toBe(true);
  });

  it("Optionsmenü friert ein und schaltet die Sprache um", () => {
    const changed: string[] = [];
    const game = newGame("en");
    game.onSettingsChanged = (s) => changed.push(s.lang);
    const input = new InputFrame();
    input.buttons = BTN_OPTIONS;
    game.tick(input);
    expect(game.frozen).toBe(true);
    expect(game.display.overlay.visible).toBe(true);
    const ticks = game.ticks;
    input.buttons = 0;
    game.tick(input);
    input.buttons = JOY_RIGHT; // Sprache weiter
    game.tick(input);
    expect(game.settings.lang).toBe("de");
    expect(changed).toEqual(["de"]);
    expect(game.ticks).toBe(ticks);
    input.buttons = BTN_OPTIONS;
    game.tick(input);
    expect(game.frozen).toBe(false);
    expect(game.display.overlay.visible).toBe(false);
  });

  it("wechselt bei Interlace zwischen langen und kurzen Halbbildern", () => {
    const game = newGame();
    game.display.setMode(true, true);
    const input = new InputFrame();
    const lengths = new Set<number>();
    for (let i = 0; i < 4; i++) {
      game.tick(input);
      lengths.add(game.tickCc / CC_PER_LINE);
    }
    expect([...lengths].sort()).toEqual([312, 313]);
  });
  it("Story-Seite: Hinweis „Feuer drücken“ blinkt nach der Mindestdauer, gehaltenes Feuer zählt nicht, Tippen schon (E-039)", () => {
    const menu = new MenuScreen(() => new LoadingScreen(LOAD_SEA, () => menu));
    const game = new Game(assets, { lang: "de" }, menu);
    const input = new InputFrame();
    input.buttons = JOY_FIRE; // Feuer starten und gedrückt halten
    for (let t = 0; t < 6 + STORY_FRAMES + STORY_MIN_FRAMES - 1; t++) game.tick(input);
    expect(game.display.overlay.visible).toBe(false);
    game.tick(input); // Mindestdauer vorbei: Hinweis erscheint
    const shown: boolean[] = [];
    for (let t = 0; t < 60; t++) {
      game.tick(input);
      shown.push(game.display.overlay.visible);
    }
    expect(shown.slice(0, PROMPT_ON_FRAMES - 1).every((v) => v)).toBe(true);
    expect(shown.includes(false)).toBe(true);
    input.buttons = 0;
    input.tapX = 100;
    input.tapY = 100;
    game.tick(input); // Tippen: weiter, Hinweis aus
    expect(game.display.overlay.visible).toBe(false);
  });
  it.each([["Level 2", LOAD_FOREST], ["Level 3", LOAD_MARSHES]])("Ladebild %s: Bild, Palette eingeblendet, Lademusik, nach Feuer weiter (gegen das Original noch ungeprüft)", (_, level) => {
    let entered = 0;
    const next: Screen = { enter: () => { entered++; }, tick: () => {} } as unknown as Screen;
    const loading = new LoadingScreen(level, () => next);
    const game = new Game(assets, { lang: "de" }, loading);
    const input = new InputFrame();
    for (let t = 0; t < 2 + LOADING_MIN_FRAMES; t++) game.tick(input);
    expect(game.display.overlay.visible).toBe(false);
    for (let t = 0; t < 100 && !game.display.overlay.visible; t++) game.tick(input); // Einblenden + Mindestdauer
    expect(game.display.overlay.visible).toBe(true);
    const img = assets.images.get(level.asset)!;
    expect(Array.from(loading.copper.palette.subarray(0, 32))).toEqual(Array.from(img.palette.subarray(0, 32)));
    expect(loading.copper.buffer?.pixels).toEqual(img.pixels.subarray(0, 352 * 290));
    expect(game.music.master).toBe(0x40);
    input.tapX = 100;
    input.tapY = 100;
    game.tick(input);
    input.clear();
    for (let t = 0; t < 200 && entered === 0; t++) game.tick(input);
    expect(entered).toBe(1);
    expect(game.music.master).toBe(0);
  });
});
