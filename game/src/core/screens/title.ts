// Titelsequenz: Stereo-Symbol, Psygnosis mit Feuerband, „and“, Art & Magic, „Present“, Agony-Logo.
// Nachbildung des Programms present (Disassembly work/disasm/present_code.txt, Wiki original/startsequenz.md):
// Hauptprogramm ab $600 als Script, Bild-Interrupt $EF0 als `interrupt()`. Alle Bilder Hires-Interlace, 16 Farben.
//
// Zeitbezug: Takt 0 = das Bild, in dem present den Klangteppich startet und das erste Einblenden beginnt. Der
// Bild-Interrupt ist da schon eingeschaltet (er wird ein Bild vorher aktiviert; die beiden Abfragen der Zeile $10
// bei $602 und $708 liegen in verschiedenen Bildern) und läuft deshalb schon in Takt 0.
// Abgleich Bild für Bild mit dem Emulator: test/title.test.ts.

import { type IndexedImage, WINDOW_HEIGHT, WINDOW_VSTART, WINDOW_WIDTH } from "../display.ts";
import type { Game, Screen } from "../game.ts";
import type { InputFrame } from "../input.ts";
import { AUD_LC, AUD_LEN, AUD_PER, AUD_VOL, DMAF_SETCLR, REG_DMACON } from "../paula.ts";
import { FrameWait, Script, type Step, type Waiter } from "../script.ts";
import { CC_PER_LINE } from "../timing.ts";

/** Hintergrund der Titelsequenz: alle Farben beginnen und enden bei $666 (Quelle: present $DAA, $E6A). */
export const TITLE_GRAY = 0x666;
const COLORS = 16;
/** Rasterzeile, auf die present an mehreren Stellen wartet ($602 …: VPOS = $10) */
const SYNC_LINE = 0x10;
/** Feuerband: Zahl der WAIT-Zeilen in der Copperliste $10EA/$12C2 */
const BAND_WAITS = 53;
/** Nach dem Umstellen der Copperlisten läuft das Band noch 2 Bilder (die Listen springen erst dann um). */
const BAND_OFF_DELAY = 2;

/** Ein Bild der Titelsequenz: Ausschnitt eines Bild-Assets und seine Lage (DIWSTRT/DIWSTOP vertikal). */
export interface Picture {
  image: string;
  /** erste Bildzeile im Asset (beide Halbbilder gezählt) */
  row: number;
  /** DIWSTRT/DIWSTOP vertikal (Rasterzeilen eines Halbbilds) */
  vstart: number;
  vstop: number;
}

// Quelle: present, Werte für $8E/$90 (DIWSTRT/DIWSTOP) und Bitplane-Zeiger; horizontal immer $81–$1C1 (640 Pixel)
const STEREO: Picture = { image: "title.stereo", row: 0, vstart: 0xff, vstop: 0x11a }; // $6B8: $FF81/$1AC1
const PSYGNOSIS: Picture = { image: "title.psygnosis", row: 0, vstart: 0x54, vstop: 0xcc }; // $792
const AND: Picture = { image: "title.texts", row: 0, vstart: 0x8a, vstop: 0x96 }; // $940
const ARTMAGIC: Picture = { image: "title.artmagic", row: 0, vstart: 0x68, vstop: 0xb8 }; // $A24
const PRESENT: Picture = { image: "title.texts", row: 24, vstart: 0x8a, vstop: 0x93 }; // $A92, Zeiger $399C8
const AGONY: Picture = { image: "title.agony", row: 0, vstart: 0x50, vstop: 0xd0 }; // $B16
const DIW_HSTART = 0x81;

// Samples (Quelle: Audio-Registerzugriffe in present)
const SAMPLE_A = "title.a", SAMPLE_B = "title.b", SAMPLE_C = "title.c", SAMPLE_D = "title.d", SAMPLE_E = "title.e";

/** Ein- und Ausblenden (present $D9E / $E42): 17 Schritte, je Schritt jeder Farbanteil ±1 zum Ziel. */
class Fade implements Waiter<TitleSequence> {
  private target: Uint16Array | null = null;
  private delay = 0;
  private count = 0;
  private steps = 0;

  /** Einblenden: alle Farben auf $666, dann alle 5 Bilder ein Schritt zur Palette. */
  in(seq: TitleSequence, palette: Uint16Array): this {
    seq.colors.fill(TITLE_GRAY);
    return this.start(palette, 5);
  }

  /** Ausblenden: alle 3 Bilder ein Schritt zu $666. */
  out(): this {
    return this.start(null, 3);
  }

  poll(seq: TitleSequence, immediate: boolean): boolean {
    if (immediate || ++this.count < this.delay) return false;
    this.count = 0;
    const c = seq.colors;
    for (let i = 0; i < COLORS; i++) c[i] = stepToward(c[i]!, this.target ? this.target[i]! : TITLE_GRAY);
    return --this.steps === 0;
  }

  private start(target: Uint16Array | null, delay: number): this {
    this.target = target;
    this.delay = delay;
    this.count = 0;
    this.steps = 17;
    return this;
  }
}

/** Jeden Farbanteil um 1 auf den Zielwert zu (present $DCA–$E36). */
export function stepToward(color: number, target: number): number {
  let out = 0;
  for (let shift = 0; shift <= 8; shift += 4) {
    let c = (color >> shift) & 15;
    const t = (target >> shift) & 15;
    if (c < t) c++;
    else if (c > t) c--;
    out |= c << shift;
  }
  return out;
}

/** Warten auf eine Rasterzeile (VPOS-Abfrage): liegt sie im laufenden Bild schon zurück, erst im nächsten. */
class LineWait implements Waiter<TitleSequence> {
  private cc = 0;

  line(n: number): this {
    this.cc = n * CC_PER_LINE;
    return this;
  }

  poll(seq: TitleSequence, immediate: boolean): boolean {
    const paula = seq.game.paula;
    // Der Code nach einer Abfrage braucht länger als den Rest der Zeile: eine zweite Abfrage im selben Bild
    // (present $B66 nach $AF8) trifft die Zeile erst im nächsten
    if (immediate && (paula.now > this.cc || seq.lineWaited)) return false;
    paula.seek(this.cc);
    seq.lineWaited = true;
    return true;
  }
}

/** Warten auf den Audio-Interrupt eines Kanals (INTREQR abfragen, present $8EE …). */
class AudioWait implements Waiter<TitleSequence> {
  private bit = 0;
  private ch = 0;

  channel(ch: number): this {
    this.ch = ch;
    this.bit = 1 << ch;
    return this;
  }

  poll(seq: TitleSequence): boolean {
    const paula = seq.game.paula;
    if (paula.intreq & this.bit) return true;
    const t = paula.ccUntilReload(this.ch);
    if (t < 0 || paula.now + t >= seq.game.tickCc) return false;
    paula.seek(paula.now + t); // Interrupt mitten im Bild: der Code reagiert sofort
    return true;
  }
}

export class TitleSequence implements Screen {
  /** Farbpuffer = Farbregister COLOR00–COLOR15 (present $14AA) */
  readonly colors = new Uint16Array(COLORS);
  /** Farbe 0 der Hardware, wenn sie ohne Puffer gesetzt wird (Schlussblende $D2A); sonst −1 */
  background = -1;
  game!: Game;
  /** true, sobald im laufenden Takt schon auf die Sync-Zeile gewartet wurde */
  lineWaited = false;

  // Zustand des Bild-Interrupts $EF0 (Variablen bei $14CA–$1546; lesbar für den Abgleich mit dem Emulator)
  perCount = 0; // $14CE
  period = 0; // $14CC: Periode Kanal 0/1
  vol01 = 0; // $14D0
  volCount = 0; // $14D2
  fade01 = 0; // $14D4: 0 = einblenden bis 15, $FF = ausblenden, 1 = fertig
  rise23 = 0; // $1540
  fall23 = 0; // $1542
  count23 = 0; // $1544
  vol23 = 0; // $1546

  /** Feuerband: Zähler der WAIT-Zeilen (Copperliste $10EA/$12C2, Startwerte $14D6) */
  readonly band = new Int32Array(BAND_WAITS);
  private bandOn = false;
  private bandOff = 0;

  /** Angezeigtes Bild (Asset-Schlüssel und erste Zeile), null = keins */
  picture: Picture | null = null;
  private drawn: Picture | null = null;
  private readonly next: () => Screen;
  private readonly script: Script<TitleSequence>;
  private readonly frames = new FrameWait<TitleSequence>();
  private readonly fade = new Fade();
  private readonly lineWait = new LineWait();
  private readonly audioWait = new AudioWait();
  private readonly bandWait: Waiter<TitleSequence>;
  private grayLevel = 0;

  constructor(next: () => Screen) {
    this.next = next;
    this.bandWait = { poll: (_s, immediate) => !immediate && this.bandStep() };
    this.script = new Script(this.program());
  }

  enter(game: Game): void {
    this.game = game;
    game.display.setMode(true, true);
    game.display.setView(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    this.colors.fill(TITLE_GRAY);
    const bands = game.assets.tables.get("title.bandCounters") ?? [];
    for (let i = 0; i < BAND_WAITS; i++) this.band[i] = bands[i] ?? 0;
    this.render();
  }

  tick(game: Game, _input: InputFrame): void {
    this.lineWaited = false;
    this.interrupt();
    this.script.tick(this);
    if (this.bandOff > 0 && --this.bandOff === 0) this.bandOn = false;
    this.render();
    if (this.script.done) game.setScreen(this.next());
  }

  // ---- Hauptprogramm (present $600–$D98) ----

  private program(): Step<TitleSequence>[] {
    const paula = (): Game["paula"] => this.game.paula;
    const wait = (n: number) => () => this.frames.frames(n);
    const syncLine = () => () => this.lineWait.line(SYNC_LINE);
    const fadeIn = (image: string) => () => this.fade.in(this, this.image(image).palette);
    const fadeOut = () => () => this.fade.out();
    const show = (p: Picture) => () => { this.picture = p; };
    // INTREQ für den Kanal löschen, dann auf den nächsten Interrupt warten
    const awaitEnd = (clear: number, ch: number) => () => {
      paula().takeInterrupts(1 << clear);
      return this.audioWait.channel(ch);
    };
    const off = (mask: number) => () => paula().write(REG_DMACON, 0, mask);
    const start = (ch: number, sample: string, period: number, volume: number) => () => {
      const s = this.sample(sample);
      const p = paula();
      p.write(AUD_LC, ch, s.address);
      p.write(AUD_LEN, ch, s.length >> 1);
      p.write(AUD_PER, ch, period);
      p.write(AUD_VOL, ch, volume);
      p.write(REG_DMACON, 0, DMAF_SETCLR | (1 << ch));
    };
    // Agony-Echo ($B9A–$C16): Kanal 2 und 10 Bilder später Kanal 3; Eigenheit: nach dem Ende von Kanal 2 wird auf
    // dessen (noch gesetzten) Interrupt statt auf Kanal 3 gewartet – Kanal 3 wird sofort abgeschnitten
    const echo = (v2: number, v3: number, after: number): Step<TitleSequence>[] => [
      start(2, SAMPLE_E, 0x9a, v2), wait(10),
      start(3, SAMPLE_E, 0x9a, v3), wait(2),
      awaitEnd(2, 2), off(0x0004),
      awaitEnd(3, 2), off(0x0008),
      wait(after),
    ];

    return [
      // $602–$776: Stereo-Symbol vorbereiten, Klangteppich (Sample A links, B rechts, Lautstärke 0) starten
      syncLine(),
      show(STEREO),
      () => {
        const p = paula(), a = this.sample(SAMPLE_A), b = this.sample(SAMPLE_B);
        p.write(AUD_LC, 0, a.address);
        p.write(AUD_LC, 1, b.address);
        p.write(AUD_LEN, 0, a.length >> 1);
        p.write(AUD_LEN, 1, b.length >> 1);
        this.period = 0xf4;
        p.write(AUD_PER, 0, this.period);
        p.write(AUD_PER, 1, this.period);
        this.vol01 = 0;
        p.write(AUD_VOL, 0, 0);
        p.write(AUD_VOL, 1, 0);
        p.write(REG_DMACON, 0, DMAF_SETCLR | 0x0003);
      },
      fadeIn("title.stereo"), wait(50), fadeOut(),
      // $792: Psygnosis mit Feuerband ($82A: Copperliste $12C2 ab Zeile $10)
      show(PSYGNOSIS),
      syncLine(),
      () => { this.bandOn = true; },
      () => this.bandWait,
      start(2, SAMPLE_C, 0xc2, 63),
      fadeIn("title.psygnosis"),
      () => { this.bandOff = BAND_OFF_DELAY; }, // $8C0: Copperlisten auf die Fassung ohne Band
      awaitEnd(2, 2), off(0x0004),
      wait(25),
      start(3, SAMPLE_C, 0xd9, 63),
      fadeOut(),
      awaitEnd(3, 3), off(0x0008),
      // $940: „and“, Sample D auf Kanal 2 + 3 mit steigender Lautstärke
      show(AND),
      syncLine(),
      () => {
        const p = paula(), d = this.sample(SAMPLE_D);
        for (const ch of [2, 3]) {
          p.write(AUD_LC, ch, d.address);
          p.write(AUD_LEN, ch, d.length >> 1);
          p.write(AUD_PER, ch, 0x98);
        }
        p.write(AUD_VOL, 2, 0);
        p.write(AUD_VOL, 3, 0);
        this.rise23 = 1;
        p.write(REG_DMACON, 0, DMAF_SETCLR | 0x000c);
      },
      fadeIn("title.texts"), wait(25), fadeOut(),
      // $A0C: Art & Magic; danach Kanal 2/3 aus- und Kanal 0/1 einblenden ($1542)
      syncLine(),
      show(ARTMAGIC),
      fadeIn("title.artmagic"), wait(100),
      () => { this.fall23 = 1; },
      fadeOut(),
      // $A92: „Present“
      show(PRESENT),
      fadeIn("title.texts"), wait(25), fadeOut(),
      // $AF8: Agony-Logo erscheint schlagartig; Klangteppich wird ausgeblendet
      syncLine(),
      () => { this.fade01 = 0xff; },
      syncLine(),
      show(AGONY),
      () => { this.colors.set(this.image("title.agony").palette.subarray(0, COLORS)); },
      ...echo(63, 50, 1),
      ...echo(40, 30, 1),
      ...echo(20, 10, 100),
      fadeOut(),
      // $D2A: alle Farben (nur die Register) in 3er-Schritten von $666 nach $000
      () => { this.grayLevel = TITLE_GRAY; },
      ...Array.from({ length: 7 }, (): Step<TitleSequence>[] => [
        wait(3),
        () => {
          this.background = this.grayLevel;
          this.grayLevel -= 0x111;
        },
      ]).flat(),
    ];
  }

  // ---- Bild-Interrupt (present $EF0) ----

  private interrupt(): void {
    const p = this.game.paula;
    if (++this.perCount === 10) {
      this.perCount = 0;
      this.period = (this.period - 1) & 0xffff;
      p.write(AUD_PER, 0, this.period);
      p.write(AUD_PER, 1, this.period);
    }
    if (this.fade01 !== 1) {
      if (++this.volCount === 3) {
        this.volCount = 0;
        if (this.vol01 < 15) {
          this.vol01++;
          p.write(AUD_VOL, 0, this.vol01);
          p.write(AUD_VOL, 1, this.vol01);
        }
      }
      if (this.fade01 !== 0) {
        if (this.vol01 === 0) this.fade01 = 1;
        else {
          this.vol01--;
          p.write(AUD_VOL, 0, this.vol01);
          p.write(AUD_VOL, 1, this.vol01);
        }
      }
    }
    if (this.rise23 !== 0 && this.rise23 !== 0xffff && ++this.count23 === 5) {
      this.count23 = 0;
      if (this.vol23 === 63) this.rise23 = 0xffff;
      else {
        this.vol23++;
        p.write(AUD_VOL, 2, this.vol23);
        p.write(AUD_VOL, 3, this.vol23);
      }
    }
    if (this.fall23 !== 0 && this.fall23 !== 0xffff && ++this.count23 === 2) {
      this.count23 = 0;
      if (this.vol23 === 0) {
        this.fall23 = 0xffff;
        p.write(REG_DMACON, 0, 0x000c);
      } else {
        this.vol23--;
        p.write(AUD_VOL, 2, this.vol23);
        p.write(AUD_VOL, 3, this.vol23);
        if (this.vol01 !== 63) {
          this.vol01++;
          p.write(AUD_VOL, 0, this.vol01);
          p.write(AUD_VOL, 1, this.vol01);
        }
      }
    }
  }

  /** Ein Bild des Feuerbands ($852–$894): alle Zähler −1; endet, sobald der erste negativ wird. */
  private bandStep(): boolean {
    for (let i = 0; i < BAND_WAITS; i++) if (--this.band[i]! < 0) return true;
    return false;
  }

  // ---- Darstellung ----

  private render(): void {
    const d = this.game.display;
    if (this.picture !== this.drawn) {
      this.drawn = this.picture;
      d.clear(0);
      const p = this.picture;
      if (p) {
        const img = this.image(p.image);
        const rows = Math.min(img.height - p.row, (p.vstop - p.vstart) * 2);
        d.drawImage({ ...img, height: rows, pixels: img.pixels.subarray(p.row * img.width) }, d.xFromDiw(DIW_HSTART), d.yFromRaster(p.vstart));
      }
    }
    for (let i = 0; i < COLORS; i++) d.setColor(i, this.colors[i]!);
    if (this.background >= 0) for (let i = 0; i < COLORS; i++) d.setColor(i, this.background);
    if (this.bandOn) this.renderBand();
  }

  /** Farbe 1 pro Zeile aus dem Feuerband: nach k erreichten WAIT-Zeilen gilt Farbe k der Liste. */
  private renderBand(): void {
    const d = this.game.display, colors = this.game.assets.tables.get("title.bandColors");
    if (!colors) return;
    for (let y = 0; y < d.height; y++) {
      const line = d.lace ? (y >> 1) : y;
      const raster = WINDOW_VSTART + line;
      let k = 0;
      while (k < BAND_WAITS && Math.min(this.band[k]!, 0xff) <= raster) k++;
      d.setLineColor(y, 1, colors[k]!);
    }
  }

  private image(key: string): IndexedImage {
    const img = this.game.assets.images.get(key);
    if (!img) throw new Error(`Bild ${key} fehlt`);
    return img;
  }

  private sample(key: string): { address: number; length: number } {
    const s = this.game.assets.samples.get(key);
    if (!s) throw new Error(`Sample ${key} fehlt`);
    return s;
  }
}
