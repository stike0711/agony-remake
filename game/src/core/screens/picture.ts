// Gemeinsame Bausteine von Menü (igt) und Ladebildern (load_<level>): ein EHB-Bild 352 × 290 in Lowres, dessen
// Palette und Bitplane-Zeiger in einer Copperliste stehen. Die CPU ändert die Copperliste nach dem Bild-Interrupt;
// der Copper hat den Anfang der Liste dann schon gelesen. Änderungen werden deshalb erst im nächsten Bild sichtbar –
// `CopperPicture.apply` überträgt den Stand zu Beginn jedes Takts in die Anzeige.

import { COLORS, type Display, type PixelTarget, WINDOW_HEIGHT, WINDOW_WIDTH } from "../display.ts";
import type { Waiter } from "../script.ts";
import type { ProtrackerPlayer } from "../protracker.ts";

export const PICTURE_WIDTH = 352;
export const PICTURE_HEIGHT = 290;

/** Bildpuffer (6 Bitplanes als Farbindex 0–63). `version` steigt bei jeder Änderung. */
export class PictureBuffer implements PixelTarget {
  readonly width = PICTURE_WIDTH;
  readonly height = PICTURE_HEIGHT;
  readonly pixels = new Uint8Array(PICTURE_WIDTH * PICTURE_HEIGHT);
  /** Adresse des Puffers im Original (zur Orientierung und für den Abgleich mit dem Emulator) */
  readonly address: number;
  version = 0;

  constructor(address: number) {
    this.address = address;
  }

  copyFrom(src: Uint8Array): void {
    this.pixels.set(src.subarray(0, this.pixels.length));
    this.version++;
  }
}

/** Farbe mit n/16 skalieren, je Anteil (c × n) >> 4 (igt $E34–$E6C, load_sea $61616). */
export function scaleColor(color: number, n: number): number {
  return ((((color >> 8) & 15) * n >> 4) << 8) | ((((color >> 4) & 15) * n >> 4) << 4) | ((color & 15) * n >> 4);
}

export class CopperPicture {
  /** Farben in der Copperliste (COLOR00–31; 32–63 ergeben sich per EHB) */
  readonly palette = new Uint16Array(COLORS);
  /** Puffer, auf den die Bitplane-Zeiger der Copperliste zeigen */
  buffer: PictureBuffer | null = null;
  private shown: PictureBuffer | null = null;
  private shownVersion = -1;

  /** Copperliste in die Anzeige übernehmen (zu Beginn des Takts). */
  apply(display: Display): void {
    display.setPalette(this.palette);
    const b = this.buffer;
    if (b && (b !== this.shown || b.version !== this.shownVersion)) {
      display.pixels.set(b.pixels.subarray(0, WINDOW_WIDTH * WINDOW_HEIGHT));
      this.shown = b;
      this.shownVersion = b.version;
    }
  }

  setFaded(source: ArrayLike<number>, n: number): void {
    for (let i = 0; i < COLORS; i++) this.palette[i] = scaleColor(source[i] ?? 0, n);
  }

  /** Nach einem Moduswechsel neu übertragen */
  invalidate(): void {
    this.shown = null;
  }
}

/** Einblenden in 17 Bildern: vor jedem Schritt 1 Bild warten, Farben × n/16 mit n = 0 … 16 (igt $E1E). */
export class FadeIn<C> implements Waiter<C> {
  private n = 0;
  private copper!: CopperPicture;
  private source: ArrayLike<number> = [];

  start(copper: CopperPicture, source: ArrayLike<number>): this {
    this.copper = copper;
    this.source = source;
    this.n = 0;
    return this;
  }

  poll(_ctx: C, immediate: boolean): boolean {
    if (immediate) return false;
    this.copper.setFaded(this.source, this.n);
    return ++this.n > 16;
  }
}

/**
 * Ausblenden von Bild und Musik (igt $E80, load_sea $61662): je Schritt Gesamtlautstärke −2, 1 Bild warten, Farben
 * × n/16 mit n = 16 … 0. Danach (igt $D38) je Bild weiter −2, bis die Musik stumm ist.
 */
export class FadeOut<C> implements Waiter<C> {
  private n = 0;
  private copper!: CopperPicture;
  private music!: ProtrackerPlayer;
  private source: ArrayLike<number> = [];

  start(copper: CopperPicture, source: ArrayLike<number>, music: ProtrackerPlayer): this {
    this.copper = copper;
    this.source = source;
    this.music = music;
    this.n = 16;
    music.master -= 2;
    return this;
  }

  poll(_ctx: C, immediate: boolean): boolean {
    if (immediate) return false;
    if (this.n >= 0) {
      this.copper.setFaded(this.source, this.n);
      if (--this.n >= 0) this.music.master -= 2;
      return false;
    }
    this.music.master -= 2;
    return this.music.master === 0;
  }
}
