// Sprachtabellen (E-021): Englisch = Originaltexte samt Positionen aus der Asset-Pipeline, Deutsch = Übersetzung,
// automatisch zentriert. Kein Spielertext steht im Code; alles läuft über Schlüssel.

import type { TextLine } from "../data/manifest.ts";
import { DE_STATUS } from "../data/lang/de.ts";
import { UI_TEXTS, type UiKey } from "../data/lang/ui.ts";
import type { Font } from "./text.ts";

export type Lang = "en" | "de";
export const LANGS: readonly Lang[] = ["en", "de"];

/** Voreinstellung nach Gerätesprache: de* → Deutsch, sonst Englisch (E-022). */
export function languageFromLocale(locale: string | undefined): Lang {
  return locale?.toLowerCase().startsWith("de") ? "de" : "en";
}

/** Zeilenraster der Menüseiten: 40 Pixel, höchstens 6 Zeilen ab y = 8. */
const LINE_PITCH = 40;
const MAX_LINES = 6;
const FIRST_Y = 8;

export class Texts {
  lang: Lang = "en";
  private readonly cache = new Map<string, readonly TextLine[]>();
  private readonly en: ReadonlyMap<string, readonly TextLine[]>;
  private readonly de: Readonly<Record<string, readonly string[]>>;
  private readonly font: Font;

  constructor(en: ReadonlyMap<string, readonly TextLine[]>, de: Readonly<Record<string, readonly string[]>>, font: Font) {
    this.en = en;
    this.de = de;
    this.font = font;
  }

  /** Seite in der aktuellen Sprache, fertig positioniert (Koordinaten wie im Original, vor dem Versatz um 16/16). */
  page(key: string): readonly TextLine[] {
    const id = `${this.lang}:${key}`;
    let lines = this.cache.get(id);
    if (!lines) {
      lines = this.layout(key);
      this.cache.set(id, lines);
    }
    return lines;
  }

  /** Text der Oberfläche in der aktuellen Sprache; "|" trennt Zeilen. */
  ui(key: UiKey): string {
    return UI_TEXTS[this.lang][key];
  }

  /**
   * Texte der Statuszeile eines Levels (Spieldatei `file`) in der aktuellen Sprache; null = Originaltexte aus dem
   * Level-Abbild (Englisch).
   */
  status(file: string): readonly string[] | null {
    return this.lang === "de" ? (DE_STATUS[file] ?? null) : null;
  }

  private layout(key: string): readonly TextLine[] {
    const en = this.en.get(key);
    const de = this.lang === "de" ? this.de[key] : undefined;
    if (!de) {
      if (!en) throw new Error(`Text fehlt: ${key}`);
      return en;
    }
    // Gleiche Zeilenzahl wie das Original → dessen y-Werte; sonst im Raster vertikal mittig
    const sameRows = en !== undefined && en.length === de.length;
    const top = FIRST_Y + ((MAX_LINES - de.length) * LINE_PITCH) / 2;
    return de.map((text, i) => ({
      x: this.font.centerX(text),
      y: sameRows ? en[i]!.y : Math.max(FIRST_Y, Math.round(top) + i * LINE_PITCH),
      text,
    }));
  }
}

/** Zeilen eines UI-Texts ("|" trennt) zentriert um `centerX` ab `y` mit Abstand `pitch`. */
export function layoutLines(font: Font, text: string, centerX: number, y: number, pitch: number): TextLine[] {
  return text.split("|").map((t, i) => ({ x: centerX - (font.textWidth(t) >> 1), y: y + i * pitch, text: t }));
}
