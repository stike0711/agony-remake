// Statuszeile auf Deutsch (E-021): übersetzte Texte in der Statusschrift mit den per Skript ergänzten Zeichen Ä, Ö, Ü,
// Sprachwechsel mitten im Level. Englisch bleibt byte-gleich mit dem Original (level1.test.ts vergleicht die Bilder).

import { describe, expect, it } from "vitest";
import { DE_STATUS } from "../src/data/lang/de.ts";
import { Game, type Screen } from "../src/core/game.ts";
import { InputFrame } from "../src/core/input.ts";
import type { LevelEngine } from "../src/core/level/engine.ts";
import { SEA } from "../src/core/level/layout.ts";
import { encodeStatusTexts, STATUS_CHARS, STATUS_GLYPHS } from "../src/core/level/status.ts";
import { LevelScreen } from "../src/core/screens/level.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

/** Bytes je Zeile der Statuszeile; Texte beginnen bei Byte 10, ab Byte 68 stehen die Leben-Symbole */
const ROW = 76;
const TEXT_START = 10;
const LIFE_START = 68;

/**
 * Text, der ab Byte 10 in Zeile 0–15 der Statuszeile steht (aus der Schrift zurückerkannt). Gesucht wird von hinten,
 * weil Ziffer 0 und Buchstabe O im Original dieselbe Glyphe haben.
 */
function shownText(e: LevelEngine, length: number): string {
  let text = "";
  for (let i = 0; i < length; i++) {
    const at = e.L.statusScreen + TEXT_START + i;
    let found = "?";
    for (let code = STATUS_CHARS.length - 1; code >= 0 && found === "?"; code--) {
      let same = true;
      for (let y = 0; y < 16 && same; y++) {
        const glyph = code < STATUS_GLYPHS ? e.ram.byte(e.L.statusDigit + code * 16 + y) : e.extraGlyphs[(code - STATUS_GLYPHS) * 16 + y]!;
        same = e.ram.byte(at + y * ROW) === glyph;
      }
      if (same) found = STATUS_CHARS[code]!;
    }
    text += found;
  }
  return text;
}

describe("Deutsche Texte der Statuszeile", () => {
  it("haben nur Zeichen der Statusschrift und passen vor die Leben-Symbole", () => {
    for (const [file, texts] of Object.entries(DE_STATUS)) {
      expect(texts.length, file).toBe(13);
      expect(() => encodeStatusTexts(texts)).not.toThrow();
      for (const t of texts) expect(TEXT_START + t.length, t).toBeLessThanOrEqual(LIFE_START);
    }
  });
});

describe.skipIf(!hasAssets)("Statuszeile im Level", () => {
  const assets = hasAssets ? loadAssets() : null!;

  function start(lang: "en" | "de"): { game: Game; level: LevelScreen } {
    const end: Screen = { enter: () => {}, tick: () => {} };
    const level = new LevelScreen(SEA, { gameOver: () => end, levelDone: () => end, unported: () => end });
    const game = new Game(assets, { lang }, level);
    const input = new InputFrame();
    for (let t = 0; t < 10; t++) game.tick(input);
    return { game, level };
  }

  it("hat Ä, Ö, Ü aus der Pipeline", () => {
    expect(assets.tables.get("status.extra")?.length).toBe(3 * 16);
  });

  it("zeigt „PRESS FIRE TO START“ auf Englisch aus dem Level-Abbild", () => {
    const { level } = start("en");
    expect(shownText(level.engine, 22)).toBe("   PRESS FIRE TO START");
  });

  it("zeigt den deutschen Text mit Umlaut und wechselt die Sprache sofort", () => {
    const { game, level } = start("de");
    const de = DE_STATUS["sea"]![12]!;
    expect(shownText(level.engine, de.length)).toBe(de);
    game.setLanguage("en");
    expect(shownText(level.engine, de.length)).toBe("   PRESS FIRE TO START      ");
    game.setLanguage("de");
    expect(shownText(level.engine, de.length)).toBe(de);
  });
});
