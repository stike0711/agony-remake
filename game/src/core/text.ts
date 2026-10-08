// Bitmap-Schrift des Menüs und das Zeichenverfahren des Originals.
// Quelle: igt, Routinen $0F5E (Seite zeichnen), $1030 (ODER in alle Planes), $114C (Löschen in Planes 2–6).

import type { FontAsset, TextLine } from "../data/manifest.ts";
import type { PixelTarget } from "./display.ts";

/** Mitte, um die das Original jede Zeile zentriert (x = (320 − Breite) / 2). */
export const TEXT_CENTER_WIDTH = 320;

export class Font {
  readonly cellWidth: number;
  readonly cellHeight: number;
  readonly widths: Uint8Array;
  readonly originRow: number;
  readonly originalCount: number;
  readonly drawRows: number;
  /** Code des Leerzeichens (wird nicht gezeichnet) */
  readonly space: number;
  /** Zeichenmasken hintereinander: Zeichen c, Zeile r, Spalte x → glyphs[(c * cellHeight + r) * cellWidth + x] */
  private readonly glyphs: Uint8Array;
  private readonly codes = new Map<string, number>();

  constructor(asset: FontAsset, sheet: Uint8Array) {
    this.cellWidth = asset.cellWidth;
    this.cellHeight = asset.cellHeight;
    this.widths = Uint8Array.from(asset.widths);
    this.originRow = asset.originRow;
    this.originalCount = asset.originalCount;
    this.drawRows = asset.drawRows;
    // Der Bogen liegt zeilenweise mit allen Zeichen nebeneinander; umsortieren, damit jedes Zeichen am Stück liegt.
    const cw = asset.cellWidth, ch = asset.cellHeight, stride = asset.count * cw;
    this.glyphs = new Uint8Array(asset.count * cw * ch);
    for (let c = 0; c < asset.count; c++) {
      for (let r = 0; r < ch; r++) {
        const s = r * stride + c * cw;
        this.glyphs.set(sheet.subarray(s, s + cw), (c * ch + r) * cw);
      }
    }
    [...asset.chars].forEach((char, code) => this.codes.set(char, code));
    this.space = this.codes.get(" ") ?? -1;
  }

  /**
   * Verkleinerte Fassung (Remake, z. B. für den Bedienhinweis E-039): je `factor` × `factor` Pixel ein Pixel, gesetzt
   * ab der Hälfte gesetzter Pixel. Breiten und Zeilen werden mitgeteilt (aufgerundet).
   */
  downscaled(factor: number): Font {
    const cw = this.cellWidth, ch = this.cellHeight;
    const count = this.widths.length;
    const sw = Math.ceil(cw / factor), sh = Math.ceil(ch / factor);
    const chars = [...this.codes.keys()].join("");
    const sheet = new Uint8Array(count * sw * sh);
    const half = (factor * factor) >> 1;
    for (let c = 0; c < count; c++) {
      for (let r = 0; r < sh; r++) {
        for (let x = 0; x < sw; x++) {
          let n = 0;
          for (let dy = 0; dy < factor; dy++) {
            const gr = r * factor + dy;
            if (gr >= ch) continue;
            for (let dx = 0; dx < factor; dx++) {
              const gx = x * factor + dx;
              if (gx < cw && this.glyphs[(c * ch + gr) * cw + gx]) n++;
            }
          }
          if (n >= half) sheet[r * count * sw + c * sw + x] = 1;
        }
      }
    }
    return new Font({
      file: "",
      cellWidth: sw,
      cellHeight: sh,
      count,
      chars,
      widths: Array.from(this.widths, (w) => Math.ceil(w / factor)),
      originRow: Math.floor(this.originRow / factor),
      originalCount: this.originalCount,
      drawRows: Math.ceil(this.drawRows / factor),
      source: "",
    }, sheet);
  }

  /** Code eines Zeichens; unbekannte Zeichen gelten als Leerzeichen. */
  code(char: string): number {
    return this.codes.get(char) ?? this.space;
  }

  has(char: string): boolean {
    return this.codes.has(char);
  }

  /** Zeilenbreite wie im Original: Summe aus (1 + Zeichenbreite). */
  textWidth(text: string): number {
    let w = 0;
    for (const char of text) w += 1 + this.widths[this.code(char)]!;
    return w;
  }

  /** x-Position einer zentrierten Zeile (Schema des Originals). */
  centerX(text: string, width = TEXT_CENTER_WIDTH): number {
    return (width - this.textWidth(text)) >> 1;
  }

  /**
   * Eine Seite zeichnen wie das Original: erst jedes Zeichen aller Zeilen an fünf Stellen (Mitte, oben, unten,
   * links, rechts) in alle Planes ODER-verknüpfen, danach die Zeichen an ihrer Stelle in den Planes 2 … n löschen.
   * Ergebnis: Zeichen = Index 1, Rand = höchster Index (bei 6 Planes 63).
   * `ox`/`oy`: Versatz der Textkoordinaten im Ziel (Menü: 16/16).
   */
  drawPage(target: PixelTarget, lines: readonly TextLine[], ox: number, oy: number, planes = 6): void {
    const all = (1 << planes) - 1;
    for (const line of lines) {
      let x = ox + line.x;
      const y = oy + line.y;
      for (const char of line.text) {
        const c = this.code(char);
        if (c !== this.space) {
          // Reihenfolge wie $0FA2–$0FBC
          this.stamp(target, c, x, y, all, 0);
          this.stamp(target, c, x, y - 1, all, 0);
          this.stamp(target, c, x, y + 1, all, 0);
          this.stamp(target, c, x - 1, y, all, 0);
          this.stamp(target, c, x + 1, y, all, 0);
        }
        x += 1 + this.widths[c]!;
      }
    }
    for (const line of lines) {
      let x = ox + line.x;
      const y = oy + line.y;
      for (const char of line.text) {
        const c = this.code(char);
        if (c !== this.space) this.stamp(target, c, x, y, 0, all & ~1);
        x += 1 + this.widths[c]!;
      }
    }
  }

  /**
   * Text Zeichen für Zeichen zeichnen wie die Highscore-Tabelle (igt $A42): je Zeichen erst die fünf Umrisse, dann
   * gleich die Mitte löschen. Das Leerzeichen wird hier nicht übersprungen (seine Maske ist leer).
   * Liefert die x-Position hinter dem letzten Zeichen.
   */
  drawWord(target: PixelTarget, text: string, x: number, y: number, ox: number, oy: number, planes = 6): number {
    const all = (1 << planes) - 1;
    for (const char of text) {
      const c = this.code(char);
      const px = ox + x, py = oy + y;
      this.stamp(target, c, px, py, all, 0);
      this.stamp(target, c, px, py - 1, all, 0);
      this.stamp(target, c, px, py + 1, all, 0);
      this.stamp(target, c, px - 1, py, all, 0);
      this.stamp(target, c, px + 1, py, all, 0);
      this.stamp(target, c, px, py, 0, all & ~1);
      x += 1 + this.widths[c]!;
    }
    return x;
  }

  /** Zeichen `c` an (x, y) setzen: Index = (Index | or) & ~clear für alle gesetzten Pixel der Maske. */
  private stamp(target: PixelTarget, c: number, x: number, y: number, or: number, clear: number): void {
    const cw = this.cellWidth;
    // Originalzeichen: nur die Zeilen, die der Blitter zeichnet (O-003); ergänzte Zeichen: ganze Zelle
    const r0 = c < this.originalCount ? this.originRow : 0;
    const r1 = c < this.originalCount ? this.originRow + this.drawRows : this.cellHeight;
    const keep = ~clear;
    for (let r = r0; r < r1; r++) {
      const ty = y + r - this.originRow;
      if (ty < 0 || ty >= target.height) continue;
      const g = (c * this.cellHeight + r) * cw;
      const row = ty * target.width;
      for (let cx = 0; cx < cw; cx++) {
        const tx = x + cx;
        if (this.glyphs[g + cx] === 0 || tx < 0 || tx >= target.width) continue;
        target.pixels[row + tx] = (target.pixels[row + tx]! | or) & keep;
      }
    }
  }
}
