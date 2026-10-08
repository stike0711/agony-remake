// Bildaufbau des Amiga (OCS) für die Level-Engine (E-032): Copper, Bitplanes, Sprites und Prioritäten, ausgegeben ins
// indizierte Bild des Kerns (E-026). Nachgebildet ist, was Agony nutzt:
//   - Copper: MOVE, WAIT mit voller Maske, Sprünge über COPJMP1/2, Copper-Interrupt über INTREQ
//   - Bitplanes: Lowres und Hires, bis 6 Planes, Dual-Playfield, Verzögerung (BPLCON1), Modulos, Darstellungsfenster
//   - Sprites: DMA-Listen mit Mehrfachnutzung, angehängte Paare (16 Farben), Prioritäten (BPLCON2)
// Zeitmodell je Rasterzeile: Copper-Befehle vor CUT_PIXELS gelten für die ganze Zeile (Zeiger, Farben, Modi), Befehle bis
// CUT_MODULO noch für den Modulo am Zeilenende, alles danach ab der nächsten Zeile. Farbwechsel mitten im Fenster
// gelten für die ganze Zeile (in Agony nur Farbe 7 an den Bandgrenzen, W-015); außerhalb des Fensters zeigt das Bild
// die Farbe 0 vom Zeilenanfang (Rand). Das Bild entsteht zeilenweise (beginFrame, renderLines), damit die Level-Engine
// dazwischen Programmteile an ihrer Rasterzeile ausführen kann; je Zeile zählt es die belegten Buszyklen.
// Horizontale Positionen in Lowres-Pixeln wie DIWSTRT (Fenster des Kerns ab WINDOW_HSTART).

import { COLORS, type Display, WINDOW_HEIGHT, WINDOW_HSTART, WINDOW_VSTART, WINDOW_WIDTH } from "../display.ts";
import type { Ram } from "./ram.ts";

/** Farbtakte je Rasterzeile (PAL) */
const LINE_CC = 227;
/** Rasterzeilen eines Bilds ohne Interlace (PAL, langes Halbbild) */
export const FRAME_LINES = 313;
/** Copper-Befehle vor dieser Position (Farbtakte) wirken schon auf den Bitplane-Abruf der Zeile (DDFSTRT $38) */
const CUT_FETCH = 0x38;
/** Copper-Befehle vor dieser Position gelten für die Farben der ganzen Zeile: vor dem Fenster (DIW $90 = $48) */
const CUT_PIXELS = 0x48;
/** Bis hierhin geschriebene Modulos gelten noch für das Ende dieser Zeile (letzter Abruf bei DDFSTOP $C8 + 8) */
const CUT_MODULO = 0xd0;
/** Erste Zeile mit Sprite-DMA (Ende der vertikalen Austastlücke) */
const SPRITE_DMA_START = 0x19;
/** Feste DMA-Zugriffe je Zeile: Speicher-Refresh und vier Audiokanäle */
const BUS_FIXED = 4 + 4;
/** Ein Sprite mit HSTART h erscheint ab Lowres-Position h + SPRITE_DELAY */
export const SPRITE_DELAY = 1;
/** Erstes Pixel der Bitplane-Daten bei DDFSTRT d: Lowres 2d + 17, Hires 2d + 9 (Lowres-Einheiten) */
const FIRST_PIXEL_LORES = 17;
const FIRST_PIXEL_HIRES = 9;
/** Index im Bild für den Rand außerhalb des Fensters: Sprite-Farbe 16 ist immer durchsichtig, also frei */
export const BORDER_INDEX = 16;

// Register (Versatz zu $DFF000)
export const INTREQ = 0x09c;
export const DMACON = 0x096;
const COP1LCH = 0x080;
const COP1LCL = 0x082;
const COP2LCH = 0x084;
const COP2LCL = 0x086;
const COPJMP1 = 0x088;
const COPJMP2 = 0x08a;
const DIWSTRT = 0x08e;
const DIWSTOP = 0x090;
const DDFSTRT = 0x092;
const DDFSTOP = 0x094;
const BPL1PTH = 0x0e0;
const BPLCON0 = 0x100;
const BPLCON1 = 0x102;
const BPLCON2 = 0x104;
const BPL1MOD = 0x108;
const BPL2MOD = 0x10a;
const SPR0PTH = 0x120;
const COLOR00 = 0x180;

const DMA_BPL = 0x100;
const DMA_COPPER = 0x080;
const DMA_SPRITE = 0x020;
const DMA_MASTER = 0x200;

/** Höchstens 40 Wörter je Zeile und Plane (Hires-Overscan) */
const MAX_FETCH_WORDS = 48;
/** Breite der Zeilenpuffer in Lowres-Pixeln (horizontale Positionen 0–$1FF) */
const LINE_SPAN = 0x200;

interface SpriteState {
  ptr: number;
  vstart: number;
  vstop: number;
  hstart: number;
  attached: boolean;
  /** Daten der aktuellen Zeile (Plane A = Bit 0, Plane B = Bit 1); aktiv nur zwischen VSTART und VSTOP */
  active: boolean;
  /** neue Steuerwörter mit VSTART = Endzeile: das Sprite beginnt in der nächsten Zeile */
  startNext: boolean;
  dataA: number;
  dataB: number;
}

export class Video {
  readonly colors = new Uint16Array(32);
  bplcon0 = 0;
  bplcon1 = 0;
  bplcon2 = 0;
  /** Modulos in Byte (mit Vorzeichen) */
  bpl1mod = 0;
  bpl2mod = 0;
  ddfstrt = 0;
  ddfstop = 0;
  diwstrt = 0;
  diwstop = 0;
  readonly bplpt = new Uint32Array(6);
  readonly sprpt = new Uint32Array(8);
  cop1lc = 0;
  cop2lc = 0;
  dmacon = 0;
  /** Rasterzeile, in der die Copperliste im letzten Bild den Copper-Interrupt ausgelöst hat (−1 = keiner) */
  copperIrqLine = -1;
  /**
   * DMA-Zugriffe je Rasterzeile im letzten Bild (Speicher-Refresh, Audio, Bitplanes, Sprites, Copper) – Grundlage des
   * Zeitmodells der Level-Hauptschleife (E-034): Blitter und CPU bekommen nur die übrigen der 227 Buszyklen.
   */
  readonly busUsed = new Uint16Array(FRAME_LINES);
  /**
   * Davon die geraden Zyklen, die Prozessor und Blitter fehlen (113 je Zeile): Copper, Lowres-Bitplanes 5 und 6,
   * Hires-Bitplanes ab der dritten. Refresh, Audio, Sprites und Lowres-Bitplanes 1–4 nutzen nur ungerade Zyklen.
   */
  readonly busEven = new Uint16Array(FRAME_LINES);

  private pc = 0;
  private cv = 0;
  private ch = 0;
  private halted = true;
  /** nächste aufzubauende Zeile des laufenden Bilds */
  private line = FRAME_LINES;
  /** DMACON zu Beginn des laufenden Bilds (ohne Master-Bit: alles aus) */
  private frameDma = 0;
  private readonly sprites: SpriteState[] = Array.from({ length: 8 }, () => ({
    ptr: 0, vstart: 0, vstop: 0, hstart: 0, attached: false, active: false, startNext: false, dataA: 0, dataB: 0,
  }));
  /** abgerufene Bitplane-Wörter der aktuellen Zeile */
  private readonly fetched = new Uint16Array(6 * MAX_FETCH_WORDS);
  /** Sprite-Farbindex (0 = keiner) und Sprite-Paar je Lowres-Position der aktuellen Zeile */
  private readonly spriteColor = new Uint8Array(LINE_SPAN);
  private readonly spritePair = new Uint8Array(LINE_SPAN);
  /** Pixelwerte der ungeraden und geraden Planes der aktuellen Zeile */
  private readonly oddLine = new Uint8Array(MAX_FETCH_WORDS * 16);
  private readonly evenLine = new Uint8Array(MAX_FETCH_WORDS * 16);

  private readonly ram: Ram;

  constructor(ram: Ram) {
    this.ram = ram;
  }

  /** Register schreiben (CPU oder Copper) */
  write(reg: number, value: number): void {
    value &= 0xffff;
    if (reg >= COLOR00 && reg < COLOR00 + 64) {
      this.colors[(reg - COLOR00) >> 1] = value & 0xfff;
    } else if (reg >= BPL1PTH && reg < BPL1PTH + 24) {
      const i = (reg - BPL1PTH) >> 2;
      this.bplpt[i] = setHalf(this.bplpt[i]!, reg & 2, value);
    } else if (reg >= SPR0PTH && reg < SPR0PTH + 32) {
      const i = (reg - SPR0PTH) >> 2;
      this.sprpt[i] = setHalf(this.sprpt[i]!, reg & 2, value);
    } else {
      switch (reg) {
        case COP1LCH: case COP1LCL: this.cop1lc = setHalf(this.cop1lc, reg & 2, value); break;
        case COP2LCH: case COP2LCL: this.cop2lc = setHalf(this.cop2lc, reg & 2, value); break;
        case COPJMP1: this.pc = this.cop1lc; break;
        case COPJMP2: this.pc = this.cop2lc; break;
        case DIWSTRT: this.diwstrt = value; break;
        case DIWSTOP: this.diwstop = value; break;
        case DDFSTRT: this.ddfstrt = value & 0xfc; break;
        case DDFSTOP: this.ddfstop = value & 0xfc; break;
        case BPLCON0: this.bplcon0 = value; break;
        case BPLCON1: this.bplcon1 = value; break;
        case BPLCON2: this.bplcon2 = value; break;
        case BPL1MOD: this.bpl1mod = (value << 16) >> 16; break;
        case BPL2MOD: this.bpl2mod = (value << 16) >> 16; break;
        case DMACON: this.dmacon = value & 0x8000 ? this.dmacon | (value & 0x7fff) : this.dmacon & ~value; break;
        case INTREQ:
          // Copper-Interrupt (Bit 4) wird vom Copper ausgelöst; die Engine fragt die Zeile ab
          if ((value & 0x8010) === 0x8010) this.copperIrqLine = this.cv;
          break;
        default:
          throw new Error(`Video: Register $${reg.toString(16)} wird nicht unterstützt`);
      }
    }
  }

  /** Ein ganzes Bild aufbauen: Copper ab COP1LC ausführen und die sichtbaren Zeilen ins Bild schreiben. */
  renderFrame(display: Display): void {
    this.beginFrame(display);
    this.renderLines(display, FRAME_LINES);
  }

  /**
   * Neues Bild beginnen (Copper ab COP1LC, Sprites aus); die Zeilen folgen mit renderLines. So kann die Engine
   * Programmteile an der Rasterzeile ausführen, an der sie im Original laufen: Was sie schreibt, wirkt ab der nächsten
   * Zeile (Copperliste, Sprite-Listen, Bitplanes).
   */
  beginFrame(display: Display): void {
    if (!display.hires || display.lace || display.width !== VIDEO_WIDTH) throw new Error("Video: Bild muss Hires ohne Interlace sein");
    this.frameDma = this.dmacon & DMA_MASTER ? this.dmacon : 0;
    this.copperIrqLine = -1;
    this.pc = this.cop1lc;
    this.cv = 0;
    this.ch = 0;
    this.halted = (this.frameDma & DMA_COPPER) === 0;
    for (const s of this.sprites) s.active = false;
    this.line = 0;
  }

  /** Zeilen bis ausschließlich `until` aufbauen (höchstens bis zum Bildende) */
  renderLines(display: Display, until: number): void {
    const dma = this.frameDma;
    const end = Math.min(until, FRAME_LINES);
    for (let v = this.line; v < end; v++) {
      // Refresh (4) und Audio (4, die Musik läuft im Original durchgehend); noch nicht aufgebaute Zeilen behalten die
      // Werte des vorigen Bilds (Zeitmodell)
      this.busUsed[v] = BUS_FIXED;
      this.busEven[v] = 0;
      // Bis zum Beginn des Bitplane-Abrufs: Zeiger, Modi; Farbe 0 hier = Randfarbe der Zeile
      this.runCopper(v, CUT_FETCH);
      const border = this.colors[0]!;
      if (dma & DMA_SPRITE) this.spriteDma(v);
      const vstart = this.diwstrt >> 8;
      const vstop = (this.diwstop >> 8) | (this.diwstop & 0x8000 ? 0 : 0x100);
      const planes = (this.bplcon0 >> 12) & 7;
      const fetching = (dma & DMA_BPL) !== 0 && planes > 0 && v >= vstart && v < vstop;
      const words = fetching ? this.fetch(planes) : 0;
      this.busUsed[v] = this.busUsed[v]! + planes * words;
      const evenPlanes = this.bplcon0 & 0x8000 ? planes - 2 : planes - 4;
      if (evenPlanes > 0) this.busEven[v] = this.busEven[v]! + evenPlanes * words;
      // Farben und Modi bis kurz vor dem Fenster gelten für die ganze Zeile
      this.runCopper(v, CUT_PIXELS);
      const row = v - WINDOW_VSTART;
      if (row >= 0 && row < WINDOW_HEIGHT) this.renderLine(display, row, v, border, fetching ? planes : 0, words);
      this.runCopper(v, CUT_MODULO);
      if (fetching) {
        for (let p = 0; p < planes; p++) this.bplpt[p] = (this.bplpt[p]! + (p & 1 ? this.bpl2mod : this.bpl1mod)) >>> 0;
      }
      this.runCopper(v, LINE_CC);
    }
    if (end > this.line) this.line = end;
  }

  // ---- Copper ----------------------------------------------------------------------------------

  /** Copper-Befehle ausführen, deren Zeitpunkt vor (v, h) liegt */
  private runCopper(v: number, h: number): void {
    const limit = v * LINE_CC + h;
    const ram = this.ram;
    while (!this.halted && this.cv * LINE_CC + this.ch < limit) {
      const w1 = ram.word(this.pc);
      const w2 = ram.word(this.pc + 2);
      this.pc += 4;
      if (this.cv < FRAME_LINES) {
        this.busUsed[this.cv] = this.busUsed[this.cv]! + 2;
        this.busEven[this.cv] = this.busEven[this.cv]! + 2;
      }
      if ((w1 & 1) === 0) {
        this.write(w1 & 0x1fe, w2);
        this.advance(4);
        continue;
      }
      if (w2 & 1) throw new Error("Copper: SKIP wird nicht unterstützt");
      if ((w2 & 0x7ffe) !== 0x7ffe) throw new Error(`Copper: WAIT mit Maske $${w2.toString(16)} wird nicht unterstützt`);
      // WAIT: Strahlposition (V nur 8 Bit, H in Farbtakten) mit der Zielposition vergleichen
      const tv = w1 >> 8;
      const th = w1 & 0xfe;
      const cur = ((this.cv & 0xff) << 8) | this.ch;
      if (cur >= ((tv << 8) | th)) continue;
      let line = this.cv - (this.cv & 0xff) + tv;
      let hh = th;
      if (hh >= LINE_CC) {
        // Position gibt es in der Zeile nicht: erfüllt erst ab der Folgezeile, außer V läuft dort auf 0 über ($FFDF …)
        if (((line + 1) & 0xff) === 0) {
          this.halted = true;
          return;
        }
        line++;
        hh = 0;
      }
      if (line >= FRAME_LINES) {
        this.halted = true;
        return;
      }
      this.cv = line;
      this.ch = hh;
    }
  }

  private advance(cc: number): void {
    this.ch += cc;
    if (this.ch >= LINE_CC) {
      this.ch -= LINE_CC;
      this.cv++;
    }
  }

  // ---- Bitplanes -------------------------------------------------------------------------------

  /** Wörter einer Zeile für alle Planes abrufen; liefert die Anzahl Wörter je Plane */
  private fetch(planes: number): number {
    const hires = (this.bplcon0 & 0x8000) !== 0;
    const span = this.ddfstop - this.ddfstrt;
    const words = Math.min(MAX_FETCH_WORDS, hires ? (span >> 2) + 2 : (span >> 3) + 1);
    for (let p = 0; p < planes; p++) {
      let a = this.bplpt[p]!;
      for (let i = 0; i < words; i++, a += 2) this.fetched[p * MAX_FETCH_WORDS + i] = this.ram.word(a);
      this.bplpt[p] = a >>> 0;
    }
    return words;
  }

  // ---- Sprites ---------------------------------------------------------------------------------

  private spriteDma(v: number): void {
    if (v < SPRITE_DMA_START) return;
    for (let i = 0; i < 8; i++) {
      const s = this.sprites[i]!;
      if (v === SPRITE_DMA_START) {
        s.ptr = this.sprpt[i]!;
        this.readControl(s);
        s.active = false;
        s.startNext = false;
      } else if (v === s.vstop) {
        // In der Endzeile holt die DMA die nächsten Steuerwörter, auch wenn das Sprite nie zu sehen war (VSTART vor
        // der Sprite-DMA, 8-Bit-Überlauf am unteren Rand). Nennen sie dieselbe Zeile als VSTART, sind deren
        // DMA-Plätze schon verbraucht: Das Sprite beginnt eine Zeile später (wie vAmiga, Tod der Eule ab Bild 13648)
        this.readControl(s);
        s.active = false;
        s.startNext = s.vstart === v;
        this.busUsed[v] = this.busUsed[v]! + 2;
        continue;
      }
      // VSTART erreicht: Sprite an. Liegt VSTOP davor (8-Bit-Überlauf, z. B. Eule am unteren Rand), bleibt es bis
      // zum Bildende an; gleiche Werte (auch das Listenende 0/0) zeigen nichts
      if (!s.active && (v === s.vstart || s.startNext) && s.vstart !== s.vstop) s.active = true;
      s.startNext = false;
      if (s.active) {
        s.dataA = this.ram.word(s.ptr);
        s.dataB = this.ram.word(s.ptr + 2);
        s.ptr += 4;
        this.busUsed[v] = this.busUsed[v]! + 2;
      }
    }
  }

  private readControl(s: SpriteState): void {
    const pos = this.ram.word(s.ptr);
    const ctl = this.ram.word(s.ptr + 2);
    s.ptr += 4;
    s.vstart = (pos >> 8) | ((ctl & 4) << 6);
    s.vstop = (ctl >> 8) | ((ctl & 2) << 7);
    s.hstart = ((pos & 0xff) << 1) | (ctl & 1);
    s.attached = (ctl & 0x80) !== 0;
  }

  /** Sprite-Farben der aktuellen Zeile in spriteColor/spritePair eintragen (Paar 0 liegt vorn) */
  private spriteLine(): boolean {
    let any = false;
    for (let pair = 3; pair >= 0; pair--) {
      const even = this.sprites[pair * 2]!;
      const odd = this.sprites[pair * 2 + 1]!;
      if (!even.active && !odd.active) continue;
      if (!any) {
        this.spriteColor.fill(0);
        any = true;
      }
      const attached = odd.attached;
      // nur die Positionen, an denen eines der beiden Sprites Daten hat
      const fromE = even.active ? even.hstart : LINE_SPAN;
      const fromO = odd.active ? odd.hstart : LINE_SPAN;
      const toE = even.active ? even.hstart + 16 : 0;
      const toO = odd.active ? odd.hstart + 16 : 0;
      const from = Math.min(fromE, fromO) + SPRITE_DELAY;
      const to = Math.min(Math.max(toE, toO) + SPRITE_DELAY, LINE_SPAN);
      for (let h = from; h < to; h++) {
        const e = spritePixel(even, h);
        const o = spritePixel(odd, h);
        let color = 0;
        if (attached) {
          const v = (o << 2) | e;
          if (v) color = 16 + v;
        } else if (e) {
          color = 16 + pair * 4 + e;
        } else if (o) {
          color = 16 + pair * 4 + o;
        }
        if (color) {
          this.spriteColor[h] = color;
          this.spritePair[h] = pair;
        }
      }
    }
    return any;
  }

  // ---- Zeile zusammensetzen ----------------------------------------------------------------------

  private renderLine(display: Display, row: number, v: number, border: number, planes: number, words: number): void {
    const pal = row * COLORS;
    for (let i = 0; i < 32; i++) display.palette[pal + i] = this.colors[i]!;
    display.palette[pal + BORDER_INDEX] = border;

    const width = display.width; // Hires: 2 Pixel je Lowres-Position
    const pixels = display.pixels;
    const out = row * width;
    const vstart = this.diwstrt >> 8;
    const vstop = (this.diwstop >> 8) | (this.diwstop & 0x8000 ? 0 : 0x100);
    if (v < vstart || v >= vstop) {
      pixels.fill(BORDER_INDEX, out, out + width);
      return;
    }
    const hstart = this.diwstrt & 0xff;
    const hstop = (this.diwstop & 0xff) | 0x100;
    const hasSprites = this.spriteLine();

    // Bitplanes als Pixelwerte: ungerade Planes (1, 3, 5 = Index 0, 2, 4) und gerade (2, 4, 6) getrennt, je 3 Bit,
    // weil BPLCON1 sie getrennt verzögert (im Dual-Playfield sind das die beiden Playfields)
    const bits = words * 16;
    const odd = this.oddLine;
    const even = this.evenLine;
    odd.fill(0, 0, bits);
    even.fill(0, 0, bits);
    for (let p = 0; p < planes; p++) {
      const target = p & 1 ? even : odd;
      const bit = 1 << (p >> 1);
      const base = p * MAX_FETCH_WORDS;
      for (let i = 0; i < words; i++) {
        const w = this.fetched[base + i]!;
        if (w === 0) continue;
        for (let b = 0, o = i * 16; b < 16; b++, o++) if (w & (0x8000 >> b)) target[o]! |= bit;
      }
    }

    const hires = (this.bplcon0 & 0x8000) !== 0;
    const dpf = (this.bplcon0 & 0x400) !== 0;
    // Position des ersten Datenpixels je Planegruppe im Hires-Raster (halbe Lowres-Pixel)
    const first2 = 2 * (2 * this.ddfstrt + (hires ? FIRST_PIXEL_HIRES : FIRST_PIXEL_LORES));
    const start1 = first2 + 2 * (this.bplcon1 & 15);
    const start2 = first2 + 2 * ((this.bplcon1 >> 4) & 15);
    const pf1p = this.bplcon2 & 7;
    const pf2p = (this.bplcon2 >> 3) & 7;
    const pf2pri = (this.bplcon2 & 0x40) !== 0;
    // Lowres: zwei gleiche Hires-Pixel je Lowres-Position
    const step = hires ? 1 : 2;

    for (let x = 0; x < width; x += step) {
      const h2 = 2 * WINDOW_HSTART + x;
      const h = h2 >> 1;
      let color = BORDER_INDEX;
      if (h >= hstart && h < hstop) {
        const r1 = h2 - start1;
        const i1 = hires ? r1 : r1 >> 1;
        const v1 = r1 >= 0 && i1 < bits ? odd[i1]! : 0;
        const r2 = h2 - start2;
        const i2 = hires ? r2 : r2 >> 1;
        const v2 = r2 >= 0 && i2 < bits ? even[i2]! : 0;
        let pfCode = 8; // 8 = kein Playfield-Pixel
        color = 0;
        if (dpf) {
          if (v1 && (!v2 || !pf2pri)) {
            color = v1;
            pfCode = pf1p;
          } else if (v2) {
            color = 8 + v2;
            pfCode = pf2p;
          }
        } else {
          color = SPREAD[v1]! | (SPREAD[v2]! << 1);
          if (color) pfCode = pf2p;
        }
        // Sprite-Paar n liegt vor einem Playfield mit Prioritätscode > n
        if (hasSprites) {
          const sc = this.spriteColor[h]!;
          if (sc && this.spritePair[h]! < pfCode) color = sc;
        }
      }
      pixels[out + x] = color;
      if (step === 2) pixels[out + x + 1] = color;
    }
  }
}

/** 3 Bit einer Planegruppe auf die Plane-Bits 0, 2, 4 verteilen (Einzel-Playfield) */
const SPREAD = Uint8Array.of(0, 1, 4, 5, 16, 17, 20, 21);

function spritePixel(s: SpriteState, h: number): number {
  if (!s.active) return 0;
  const i = h - s.hstart - SPRITE_DELAY;
  if (i < 0 || i > 15) return 0;
  return ((s.dataA >> (15 - i)) & 1) | (((s.dataB >> (15 - i)) & 1) << 1);
}

/** Hälfte eines Adressregisters setzen (H = Bits 16–20, L = Bits 0–15, gerade) */
function setHalf(old: number, low: number, value: number): number {
  return low ? ((old & 0x1f0000) | (value & 0xfffe)) >>> 0 : (((value & 0x1f) << 16) | (old & 0xffff)) >>> 0;
}

/** Breite des Bilds in Hires-Pixeln, das die Engine verlangt */
export const VIDEO_WIDTH = WINDOW_WIDTH * 2;
