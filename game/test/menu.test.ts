// Menü, Story-Seite und Ladebild Bild für Bild gegen die Ablaufspuren des Emulators:
//   menu.trace.json  – Lauf 1: Menü ab dem Start ($600) über einen ganzen Abspann-Zyklus
//   menu2.trace.json – Lauf 2 ab Schnappschuss snap_f7100_menu: zweiter Zyklus, Feuer, Story-Seite, Ausblenden,
//                      Beginn des Ladebilds; load.trace.json setzt ihn bis zum Ende des Ladebilds fort.
// Geprüft: Bitplane-Zeiger und Palette der Copperliste, Zustand des ProTracker-Abspielers (Tempo, Zähler,
// Position, Perioden, Lautstärken) und Audio-DMA.

import { describe, expect, it } from "vitest";
import { Game, type Screen } from "../src/core/game.ts";
import { InputFrame, JOY_FIRE } from "../src/core/input.ts";
import { LOAD_SEA, LoadingScreen } from "../src/core/screens/loading.ts";
import { MenuScreen } from "../src/core/screens/menu.ts";
import type { CopperPicture } from "../src/core/screens/picture.ts";
import { decodePlanes, hasDump, loadDump } from "./chip-dump.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";
import { hasTrace, Trace } from "./load-trace.ts";

/** Erster Takt des Menüs (erster Bild-Interrupt nach dem Start) in Lauf 1 */
const MENU_FIRST = 6476;
/** Lauf 2 liegt 582 Bilder später (Seite 0 erscheint bei 7246 statt 6664) */
const RUN2 = 582;
/** Lauf 2: Feuer im Menü (Interrupt sieht es in Bild 16401), Ausblenden des Menüs ab 17724 (Ende des Ladens) */
const RUN2_FIRE = 16401;
const RUN2_MENU_FADE = 17724;
/** Ladebild: erster Takt 17757, Ausblenden ab 22197 (Level geladen) */
const LOAD_FIRST = 17757;
const LOAD_FADE = 22197;

/** Adressen des Abspielers in igt; in load_sea liegt dieselbe Routine $60158 Byte weiter */
const PT_IGT = 0;
const PT_LOAD = 0x60158;

class Checker {
  readonly errors: string[] = [];
  check(frame: number, what: string, mine: number, original: number): void {
    if (mine !== original && this.errors.length < 25) {
      this.errors.push(`Bild ${frame}: ${what} $${mine.toString(16)} statt $${original.toString(16)}`);
    }
  }
}

function checkCopper(c: Checker, trace: Trace, frame: number, copper: CopperPicture, pointer: [number, number], palette: number): void {
  c.check(frame, "Bildzeiger", copper.buffer?.address ?? 0, trace.long(frame, pointer[0], pointer[1]));
  for (let i = 0; i < 32; i++) c.check(frame, `Farbe ${i}`, copper.palette[i]!, trace.word(frame, palette + 4 * i));
}

function checkMusic(c: Checker, trace: Trace, frame: number, game: Game, base: number): void {
  const m = game.music;
  c.check(frame, "Tempo/Zähler", (m.speed << 8) | m.counter, trace.word(frame, base + 0x30ca));
  c.check(frame, "Songposition", m.songPos, trace.byte(frame, base + 0x30cc));
  c.check(frame, "Patternposition", m.patternPos, trace.word(frame, base + 0x30d4));
  for (let ch = 0; ch < 4; ch++) {
    const v = m.voices[ch]!;
    c.check(frame, `Lautstärke ${ch}`, m.stored[ch]!, trace.word(frame, base + 0x30da + 2 * ch));
    c.check(frame, `Periode ${ch}`, v.period, trace.word(frame, base + 0x2f9a + 44 * ch + 0x10));
    c.check(frame, `Finetune/Volume ${ch}`, (v.finetune << 8) | v.volume, trace.word(frame, base + 0x2f9a + 44 * ch + 0x12));
  }
}

const end: Screen = { enter: () => {}, tick: () => {} };

describe.skipIf(!hasAssets || !hasTrace("menu"))("Menü gegen den Emulator (Lauf 1)", () => {
  it("stimmt über einen ganzen Abspann-Zyklus Bild für Bild", () => {
    const trace = new Trace("menu");
    const menu = new MenuScreen(() => end);
    const game = new Game(loadAssets(), { lang: "en" }, menu);
    const input = new InputFrame();
    const c = new Checker();
    // Ab Bild 14128 hing der Emulator in diesem Lauf (danach Neustart); Lauf 2 deckt die Stelle ab
    for (let frame = MENU_FIRST; frame <= 14120; frame++) {
      game.tick(input);
      checkCopper(c, trace, frame, menu.copper, [0x41ab0, 0x41ab4], 0x41b34);
      checkMusic(c, trace, frame, game, PT_IGT);
      c.check(frame, "Audio-DMA", game.paula.dmacon, trace.word(frame, 0xdff002) & 0xf);
    }
    expect(c.errors).toEqual([]);
  });
});

describe.skipIf(!hasAssets || !hasTrace("menu2") || !hasTrace("load"))("Feuer, Story-Seite und Ladebild gegen den Emulator (Lauf 2)", () => {
  it("stimmt vom zweiten Abspann-Zyklus bis zum Start des Levels", () => {
    const menuTrace = new Trace("menu2");
    const loadTrace = new Trace("load");
    const trace = (frame: number): Trace => (menuTrace.rows.has(frame) ? menuTrace : loadTrace);
    let levelStarted = -1, frame = 0;
    const level: Screen = { enter: () => { levelStarted = frame; }, tick: () => {} };
    const loading = new LoadingScreen(LOAD_SEA, () => level);
    const menu = new MenuScreen(() => loading);
    const game = new Game(loadAssets(), { lang: "en" }, menu);
    const input = new InputFrame();
    const c = new Checker();
    for (frame = MENU_FIRST + RUN2; frame <= LOAD_FADE + 40; frame++) {
      // Feuer wie im Emulator: im Menü 2 Bilder lang; zum Ausblenden der Story-Seite und des Ladebilds im Bild, in
      // dem das Original mit dem Laden fertig ist (im Nachbau ersetzt Feuer das Laden, E-025)
      input.buttons = frame === RUN2_FIRE || frame === RUN2_FIRE + 1 || frame === RUN2_MENU_FADE || frame === LOAD_FADE ? JOY_FIRE : 0;
      game.tick(input);
      if (frame < 7103) continue;
      if (frame < LOAD_FIRST) {
        checkCopper(c, menuTrace, frame, menu.copper, [0x41ab0, 0x41ab4], 0x41b34);
        // Im letzten Menübild startet schon load_sea (mt_init); dessen Abspieler liegt an anderer Adresse
        if (frame < LOAD_FIRST - 1) {
          checkMusic(c, menuTrace, frame, game, PT_IGT);
          c.check(frame, "Audio-DMA", game.paula.dmacon, menuTrace.word(frame, 0xdff002) & 0xf);
        }
      } else if (frame <= LOAD_FADE + 32) {
        const t = trace(frame);
        checkCopper(c, t, frame, loading.copper, [0x7b5aa, 0x7b5ae], 0x7b62e);
        checkMusic(c, t, frame, game, PT_LOAD);
      }
    }
    expect(c.errors).toEqual([]);
    // Original: Ausblenden ab 22197, Musik in Bild 22229 stumm, dann jmp $600 (Level)
    expect(levelStarted).toBe(LOAD_FADE + 32);
    expect(game.music.master).toBe(0);
  });
});

const DUMPS = ["menu_hiscore_f14710_chip.bin", "menu_story_f16430_chip.bin"];

describe.skipIf(!hasAssets || !DUMPS.every(hasDump))("Highscore-Tabelle und Story-Seite gegen Speicherabzüge", () => {
  it("zeichnet beide pixelgenau wie das Original", () => {
    const menu = new MenuScreen(() => end);
    const game = new Game(loadAssets(), { lang: "en" }, menu);
    const input = new InputFrame();
    const results: string[] = [];
    for (let frame = MENU_FIRST + RUN2; frame <= 16430; frame++) {
      input.buttons = frame === RUN2_FIRE || frame === RUN2_FIRE + 1 ? JOY_FIRE : 0;
      game.tick(input);
      const name = DUMPS.find((d) => d.includes(`_f${frame}_`));
      if (!name) continue;
      const chip = loadDump(name);
      const buf = menu.copper.buffer!;
      const address = ((chip[0x41ab0]! << 24) | (chip[0x41ab1]! << 16) | (chip[0x41ab4]! << 8) | chip[0x41ab5]!) >>> 0;
      const original = decodePlanes(chip, address, 44, 290, 6);
      // Kopierte Puffer: die letzten 96 Pixel der letzten Zeile ausnehmen (Plane 6 wird nicht kopiert, O-002)
      const compared = buf.address === 0x2eea6 ? buf.pixels.length : buf.pixels.length - 96;
      let wrong = 0;
      for (let i = 0; i < compared; i++) if (buf.pixels[i] !== original[i]) wrong++;
      results.push(`${name}: Puffer $${buf.address.toString(16)}/$${address.toString(16)}, ${wrong} Pixel falsch`);
    }
    expect(results).toEqual([
      "menu_hiscore_f14710_chip.bin: Puffer $42dcc/$42dcc, 0 Pixel falsch",
      "menu_story_f16430_chip.bin: Puffer $2eea6/$2eea6, 0 Pixel falsch",
    ]);
  });
});
