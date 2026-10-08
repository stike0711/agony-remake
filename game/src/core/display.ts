// Bildausgabe des Kerns: ein indiziertes Bild (wie die Bitplanes nach Denise) plus eine Palette pro Zeile
// (wie der Copper). Der Kern setzt Ebenen, Sprites und Text selbst in dieses Bild zusammen; der Renderer der
// Plattform schlägt nur noch die Farben nach und skaliert (E-026).
//
// Koordinaten: Das Bild deckt immer denselben Ausschnitt des PAL-Bilds ab (WINDOW_*). Lowres ohne Interlace hat
// 352 × 280 Pixel, Hires verdoppelt die Breite, Interlace die Zeilenzahl; der Renderer zeigt alle Modi gleich groß.

/** Linker Rand des Ausschnitts als horizontale DIW-Position (Lowres): Menü und Ladebilder beginnen hier (Overscan). */
export const WINDOW_HSTART = 0x71;
/** Erste Rasterzeile des Ausschnitts (Menü und Ladebilder beginnen hier, DIWSTRT $2071). */
export const WINDOW_VSTART = 0x20;
/** Breite in Lowres-Pixeln (Menübild: 352). */
export const WINDOW_WIDTH = 352;
/** Höhe in Rasterzeilen: Zeile 32 bis 311. Die letzten Zeilen des 290 Zeilen hohen Menübilds liegen darunter. */
export const WINDOW_HEIGHT = 280;

/** Farbregister je Zeile (COLOR00–COLOR31); bei Extra-Halfbrite ergeben sich 32–63 aus 0–31. */
export const COLORS = 32;

export const MAX_WIDTH = WINDOW_WIDTH * 2;
export const MAX_HEIGHT = WINDOW_HEIGHT * 2;

/** Rechteck in Lowres-Pixeln/Rasterzeilen relativ zum Ausschnitt. */
export interface Rect {
  x: number;
  y: number;
  width: number;
  height: number;
}

/** Indiziertes Bild mit fester Palette, z. B. aus den Spieldaten. */
export interface IndexedImage {
  readonly width: number;
  readonly height: number;
  readonly pixels: Uint8Array;
  /** 12-Bit-Farben ($0RGB), höchstens 32 */
  readonly palette: Uint16Array;
  readonly ehb: boolean;
}

/** Ziel für Zeichenfunktionen (Display oder Overlay). */
export interface PixelTarget {
  readonly pixels: Uint8Array;
  readonly width: number;
  readonly height: number;
}

export class Display implements PixelTarget {
  hires = false;
  lace = false;
  /** Extra-Halfbrite: Index 32–63 = Farbe (Index − 32) mit halber Helligkeit */
  ehb = false;
  width = WINDOW_WIDTH;
  height = WINDOW_HEIGHT;
  readonly pixels = new Uint8Array(MAX_WIDTH * MAX_HEIGHT);
  /** Palette pro Zeile: Zeile y belegt palette[y * COLORS … y * COLORS + 31] */
  readonly palette = new Uint16Array(MAX_HEIGHT * COLORS);
  /** Bereich, den der Renderer bildschirmfüllend einpasst; rundherum ist, soweit Platz ist, der Rest zu sehen. */
  readonly view: Rect = { x: 0, y: 0, width: WINDOW_WIDTH, height: WINDOW_HEIGHT };
  /** Ebene über dem Bild für Remake-Elemente (Optionsmenü, Hinweise) */
  readonly overlay = new Overlay();
  /** Zähler, der bei jedem fertigen Bild steigt; der Renderer lädt nur bei Änderung neu hoch. */
  frame = 0;

  /** Bildschirm-Modus setzen und das Bild mit Index 0 löschen. */
  setMode(hires: boolean, lace: boolean, ehb = false): void {
    this.hires = hires;
    this.lace = lace;
    this.ehb = ehb;
    this.width = hires ? WINDOW_WIDTH * 2 : WINDOW_WIDTH;
    this.height = lace ? WINDOW_HEIGHT * 2 : WINDOW_HEIGHT;
    this.clear(0);
  }

  setView(x: number, y: number, width: number, height: number): void {
    this.view.x = x;
    this.view.y = y;
    this.view.width = width;
    this.view.height = height;
  }

  clear(index: number): void {
    this.pixels.fill(index, 0, this.width * this.height);
  }

  /** Bildspalte zu einer horizontalen DIW-Position (Lowres-Takt). */
  xFromDiw(hpos: number): number {
    return (hpos - WINDOW_HSTART) * (this.hires ? 2 : 1);
  }

  /** Bildzeile zu einer Rasterzeile (bei Interlace die Zeile des langen Halbbilds). */
  yFromRaster(vpos: number): number {
    return (vpos - WINDOW_VSTART) * (this.lace ? 2 : 1);
  }

  /** Farbe `index` in allen Zeilen setzen (wie ein Farbregister ohne Copper). */
  setColor(index: number, rgb12: number): void {
    const p = this.palette;
    for (let i = index, end = this.height * COLORS; i < end; i += COLORS) p[i] = rgb12;
  }

  /** Farbe `index` ab Zeile `line` bis zum Bildende setzen (wie ein Copper-MOVE nach WAIT). */
  setColorFrom(line: number, index: number, rgb12: number): void {
    const p = this.palette;
    for (let i = Math.max(0, line) * COLORS + index, end = this.height * COLORS; i < end; i += COLORS) p[i] = rgb12;
  }

  /** Farbe `index` nur in Zeile `line` setzen. */
  setLineColor(line: number, index: number, rgb12: number): void {
    this.palette[line * COLORS + index] = rgb12;
  }

  /** Farben 0 … count−1 in allen Zeilen setzen. */
  setPalette(colors: ArrayLike<number>, count = colors.length): void {
    const n = Math.min(count, COLORS);
    for (let y = 0; y < this.height; y++) {
      const o = y * COLORS;
      for (let i = 0; i < n; i++) this.palette[o + i] = colors[i]!;
    }
  }

  /** Bild 1:1 an (dx, dy) kopieren, abgeschnitten am Rand. Kein Skalieren: Modus und Bild müssen zusammenpassen. */
  drawImage(img: IndexedImage, dx: number, dy: number): void {
    blit(img.pixels, img.width, img.height, this, dx, dy);
  }

  /** Rechteck füllen, abgeschnitten am Rand. */
  fillRect(x: number, y: number, w: number, h: number, index: number): void {
    fillRect(this, x, y, w, h, index);
  }
}

/** Ebene über dem Spielbild: Lowres, eine feste Palette, Index 0 durchsichtig. */
export class Overlay implements PixelTarget {
  readonly width = WINDOW_WIDTH;
  readonly height = WINDOW_HEIGHT;
  readonly pixels = new Uint8Array(WINDOW_WIDTH * WINDOW_HEIGHT);
  readonly palette = new Uint16Array(COLORS);
  visible = false;
  /** Spielbild darunter abdunkeln (0 = gar nicht, 15 = schwarz) */
  dim = 0;

  clear(): void {
    this.pixels.fill(0);
  }
}

export function blit(src: Uint8Array, sw: number, sh: number, dst: PixelTarget, dx: number, dy: number): void {
  const x0 = Math.max(0, dx), y0 = Math.max(0, dy);
  const x1 = Math.min(dst.width, dx + sw), y1 = Math.min(dst.height, dy + sh);
  if (x1 <= x0 || y1 <= y0) return;
  for (let y = y0; y < y1; y++) {
    const s = (y - dy) * sw + (x0 - dx);
    dst.pixels.set(src.subarray(s, s + (x1 - x0)), y * dst.width + x0);
  }
}

export function fillRect(dst: PixelTarget, x: number, y: number, w: number, h: number, index: number): void {
  const x0 = Math.max(0, x), y0 = Math.max(0, y);
  const x1 = Math.min(dst.width, x + w), y1 = Math.min(dst.height, y + h);
  for (let yy = y0; yy < y1; yy++) dst.pixels.fill(index, yy * dst.width + x0, yy * dst.width + x1);
}

/** Halbe Helligkeit wie bei Extra-Halfbrite: jeder 4-Bit-Anteil um ein Bit nach rechts. */
export function halfBright(rgb12: number): number {
  return (rgb12 >> 1) & 0x777;
}
