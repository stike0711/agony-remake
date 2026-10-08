// Schrift und Sprachtabellen: Zentrier-Schema, deutsche Texte, Zeichenverfahren gegen einen Speicherabzug des
// Originals (Emulator-Aufnahme des Menüs).

import { describe, expect, it } from "vitest";
import { DE_PAGES } from "../src/data/lang/de.ts";
import { UI_TEXTS } from "../src/data/lang/ui.ts";
import { Texts } from "../src/core/i18n.ts";
import { decodePlanes, hasDump, loadDump } from "./chip-dump.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

describe.skipIf(!hasAssets)("Menüschrift", () => {
  const assets = hasAssets ? loadAssets() : null!;
  const font = assets?.fonts.get("menu")!;

  it("zentriert wie das Original: x = (320 − Breite) / 2 für alle englischen Zeilen", () => {
    for (const [key, lines] of assets.texts) {
      for (const l of lines) {
        if (l.text === "") continue;
        expect(font.centerX(l.text), `${key}: ${l.text}`).toBe(l.x);
      }
    }
  });

  it("deutsche Seiten: nur Zeichen der Schrift, höchstens 320 Pixel, Zeilenzahl wie im Original", () => {
    for (const [key, lines] of Object.entries(DE_PAGES)) {
      const en = assets.texts.get(key);
      expect(en, key).toBeDefined();
      expect(lines.length, key).toBe(en!.length);
      for (const text of lines) {
        for (const ch of text) expect(font.has(ch), `${key}: „${ch}“ in ${text}`).toBe(true);
        expect(font.textWidth(text), `${key}: ${text}`).toBeLessThanOrEqual(320);
      }
    }
  });

  it("Remake-Texte: nur Zeichen der Schrift, jede Zeile passt in den Bildausschnitt", () => {
    for (const lang of ["en", "de"] as const) {
      for (const [key, text] of Object.entries(UI_TEXTS[lang])) {
        for (const line of text.split("|")) {
          for (const ch of line) expect(font.has(ch), `${lang} ${key}: „${ch}“`).toBe(true);
          expect(font.textWidth(line), `${lang} ${key}: ${line}`).toBeLessThanOrEqual(336);
        }
      }
    }
  });

  it("deutsche Seiten übernehmen die y-Werte und zentrieren neu", () => {
    const texts = new Texts(assets.texts, DE_PAGES, font);
    texts.lang = "de";
    const page = texts.page("credits.0");
    expect(page.map((l) => l.y)).toEqual(assets.texts.get("credits.0")!.map((l) => l.y));
    expect(page[1]!.text).toBe("PRÄSENTIERT");
    expect(page[1]!.x).toBe(font.centerX("PRÄSENTIERT"));
  });

  const dumps = ["menu_text_f7450_chip.bin", "menu_text_f7700_chip.bin"].filter(hasDump);
  it.skipIf(dumps.length === 0)("zeichnet pixelgenau wie das Original (Chip-RAM-Abzug)", () => {
    const bg = assets.images.get("menu.background")!;
    for (const name of dumps) {
      const chip = loadDump(name);
      const view = new DataView(chip.buffer);
      // Bildpuffer-Zeiger des Menüs ($419F6/$419FA, Quelle: igt $0F5E/$100E); 6 Planes à 44 × 290 Byte
      const candidates = [view.getUint32(0x419f6), view.getUint32(0x419fa)];
      const shown = candidates.map((addr) => decodePlanes(chip, addr, 44, 290, 6));
      let matched = false;
      for (let page = 0; page < 12 && !matched; page++) {
        const pixels = bg.pixels.slice();
        font.drawPage({ pixels, width: bg.width, height: bg.height }, assets.texts.get(`credits.${page}`)!, 16, 16);
        // Die letzten 96 Pixel der letzten Zeile ausnehmen: Die Kopierschleife lässt dort Plane 6 aus (O-002);
        // die Zeile liegt außerhalb des sichtbaren Bilds.
        const compared = pixels.length - 96;
        matched = shown.some((s) => s.subarray(0, compared).every((v, i) => v === pixels[i]));
      }
      expect(matched, name).toBe(true);
    }
  });
});
