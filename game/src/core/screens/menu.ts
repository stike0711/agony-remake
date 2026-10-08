// Menü mit dem brennenden Baum: Abspann-Seiten, Highscore-Tabelle, Menümusik; Feuer → Story-Seite → Ladebild.
// Nachbildung des Programms igt (Disassembly work/disasm/igt_code.txt, Wiki original/startsequenz.md):
// Hauptschleife ab $600 als Script, Bild-Interrupt $1246 als `interrupt()` (Musik, Feuerknopf).
//
// Doppelpufferung wie im Original: Eine Seite wird in den hinteren Puffer gezeichnet, dann zeigen die
// Bitplane-Zeiger der Copperliste darauf. Kopieren und Zeichnen kosten im Original sichtbar Zeit; die gemessenen
// Dauern stehen unten. Takt 0 = erster Bild-Interrupt nach dem Start (mt_init läuft schon in `enter`).
// Abgleich Bild für Bild mit dem Emulator: test/menu.test.ts.

import type { ProtrackerModule } from "../assets.ts";
import type { Game, Screen } from "../game.ts";
import { type InputFrame, JOY_FIRE } from "../input.ts";
import { FirePrompt } from "../prompt.ts";
import { FrameWait, Script, type Step } from "../script.ts";
import { CopperPicture, FadeIn, FadeOut, PictureBuffer } from "./picture.ts";

/** Lage des Texts im Bild: Zieladresse Puffer + $2C2 = 16 Zeilen und 16 Pixel (igt $1048) */
const TEXT_OFFSET = 16;

// Zeiten der Hauptschleife in Bildern (Quelle: igt $718–$870)
const WAIT_START = 150;
const WAIT_TEXT = 400;
const WAIT_PICTURE = 200;
const WAIT_HIGHSCORE_TEXT = 500;
const WAIT_HIGHSCORE_PICTURE = 400;
const CREDIT_PAGES = 12;

/**
 * Wie lange das Original zum Kopieren und Zeichnen braucht (Bilder vom Ende der Wartezeit bis zum Umschalten der
 * Zeiger). Gemessen im Emulator am 06.10.2026, in zwei Läufen und zwei Zyklen gleich (Spuren menu/menu2.trace.json).
 * Gelten auch für die deutschen Seiten, damit der Ablauf in beiden Sprachen gleich bleibt.
 */
export const COPY_FRAMES = 6; // $F06: sauberes Bild in den hinteren Puffer kopieren („Text aus“)
export const PAGE_FRAMES = [15, 14, 12, 11, 12, 14, 14, 19, 15, 13, 20, 17] as const; // $F5E: Seiten 0–11
export const HIGHSCORE_FRAMES = 21; // $AE8
export const STORY_FRAMES = 14; // $F74 mit Seite 12, direkt ins Originalbild

/**
 * Story-Seite: Im Original steht sie, solange load_sea geladen wird (Crack-Fassung ≈ 26 s). Im Nachbau entfällt die
 * Ladezeit: Mindestdauer, danach weiter mit Feuer (E-025).
 */
export const STORY_MIN_FRAMES = 150;

/** Highscore-Tabelle (igt $AE8): Kürzel bei x = 30, Punkte bei x = 150, Zeilen ab y = 16 im Abstand 40 */
const HIGHSCORE_NAME_X = 30;
const HIGHSCORE_SCORE_X = 150;
const HIGHSCORE_Y = 16;
const HIGHSCORE_PITCH = 40;

/** Inhalt eines Puffers: Schlüssel einer Textseite, "highscores" oder null (nur Bild) */
type Content = string | null;

export class MenuScreen implements Screen {
  readonly copper = new CopperPicture();
  game!: Game;
  /** Feuer wurde gedrückt (igt $41A08) – danach reagiert der Interrupt nicht mehr */
  fired = false;

  /** Originalbild (igt $2EEA6, wird von der Story-Seite überschrieben) und die beiden Puffer $42DCC/$558DC */
  private readonly original = new PictureBuffer(0x2eea6);
  private readonly front = new PictureBuffer(0x42dcc);
  private readonly back = new PictureBuffer(0x558dc);
  /** igt $419F6/$419FA: Zeiger auf hinteren und vorderen Puffer (anfangs $558DC bzw. $42DCC) */
  private backBuf: PictureBuffer;
  private frontBuf: PictureBuffer;
  private readonly content = new Map<PictureBuffer, Content>();
  private readonly next: () => Screen;
  private readonly script: Script<MenuScreen>;
  private readonly frames = new FrameWait<MenuScreen>();
  private readonly fadeIn = new FadeIn<MenuScreen>();
  private readonly fadeOut = new FadeOut<MenuScreen>();
  /** danach Hinweis „Feuer drücken“ und Warten auf Feuer (E-039) */
  private readonly waitFire = new FirePrompt<MenuScreen>();
  private loopStart = 0;
  private storyStart = 0;

  constructor(next: () => Screen) {
    this.next = next;
    this.backBuf = this.back;
    this.frontBuf = this.front;
    this.script = new Script(this.program());
  }

  enter(game: Game): void {
    this.game = game;
    const d = game.display;
    d.setMode(false, false, true);
    this.copper.palette.fill(0);
    this.copper.invalidate();
    this.copper.apply(d);
    this.original.copyFrom(this.picture().pixels);
    this.content.set(this.original, null);
    // $694: mt_init, Gesamtlautstärke $40
    game.music.init(this.module());
    game.music.master = 0x40;
  }

  tick(game: Game, input: InputFrame): void {
    this.copper.apply(game.display);
    this.interrupt(input);
    this.script.tick(this);
  }

  languageChanged(): void {
    // Sichtbare und vorbereitete Seiten in der neuen Sprache neu zeichnen (Remake: im Original gibt es nur Englisch)
    for (const [buf, page] of this.content) {
      if (typeof page !== "string") continue;
      if (buf === this.original) {
        buf.copyFrom(this.picture().pixels);
      } else {
        buf.copyFrom(this.original.pixels);
      }
      this.drawPage(buf, page);
    }
  }

  // ---- Bild-Interrupt (igt $1246) ----

  private interrupt(input: InputFrame): void {
    this.game.music.music();
    if (!this.fired && (input.buttons & JOY_FIRE) !== 0) {
      // $12AA: Rücksprungadresse auf $C9C – das Hauptprogramm bricht ab, wo es gerade ist
      this.fired = true;
      this.script.jump(this.storyStart);
    }
  }

  // ---- Hauptprogramm (igt $6E2–$D48) ----

  private program(): Step<MenuScreen>[] {
    const steps: Step<MenuScreen>[] = [];
    const wait = (n: number): Step<MenuScreen> => () => this.frames.frames(n);
    const textOff = (): Step<MenuScreen>[] => [wait(COPY_FRAMES), () => this.showBack(null)];

    steps.push(
      () => { this.copper.buffer = this.original; }, // $6E2: Zeiger auf das Originalbild
      ...textOff(), // $6EC
      () => this.fadeIn.start(this.copper, this.picture().palette), // $6F0
      // $6F4: Namenseingabe, wenn die Punktzahl einen Platz in der Tabelle erreicht – kommt mit dem Spielende
      wait(WAIT_START),
    );
    this.loopStart = steps.length;
    for (let p = 0; p < CREDIT_PAGES; p++) {
      steps.push(wait(PAGE_FRAMES[p]!), () => this.showBack(`credits.${p}`), wait(WAIT_TEXT), ...textOff(), wait(WAIT_PICTURE));
    }
    steps.push(
      wait(HIGHSCORE_FRAMES), () => this.showBack("highscores"), wait(WAIT_HIGHSCORE_TEXT),
      ...textOff(), wait(WAIT_HIGHSCORE_PICTURE),
      () => this.script.jump(this.loopStart),
    );

    // $C9C: Spielstart nach Feuer
    this.storyStart = steps.length;
    steps.push(
      ...textOff(),
      wait(STORY_FRAMES),
      () => {
        // Seite 12 direkt ins Originalbild ($CA0: hinterer Puffer = $2EEA6), dann umschalten
        this.backBuf = this.original;
        this.showBack("story.start");
      },
      // $CB0: Spielvariablen zurücksetzen (Punkte, Leben …) – kommt mit dem Spiel
      wait(STORY_MIN_FRAMES),
      () => this.waitFire,
      () => this.fadeOut.start(this.copper, this.picture().palette, this.game.music),
      () => this.game.setScreen(this.next()),
    );
    return steps;
  }

  /**
   * Hinteren Puffer neu aufbauen (Originalbild kopieren, Seite zeichnen), Copper-Zeiger darauf setzen, Puffer
   * tauschen (igt $F06/$F5E/$AE8). Der Kopierschritt entfällt, wenn direkt ins Originalbild gezeichnet wird.
   */
  private showBack(content: Content): void {
    const buf = this.backBuf;
    if (buf !== this.original) buf.copyFrom(this.original.pixels);
    if (content === "highscores") this.drawHighscores(buf);
    else if (content) this.drawPage(buf, content);
    this.content.set(buf, content);
    this.copper.buffer = buf;
    this.backBuf = this.frontBuf;
    this.frontBuf = buf;
  }

  private drawPage(buf: PictureBuffer, key: string): void {
    this.game.font.drawPage(buf, this.game.texts.page(key), TEXT_OFFSET, TEXT_OFFSET);
    buf.version++;
  }

  private drawHighscores(buf: PictureBuffer): void {
    const font = this.game.font;
    let y = HIGHSCORE_Y;
    for (const entry of this.game.assets.highscores.slice(0, 6)) {
      font.drawWord(buf, entry.name.padEnd(3).slice(0, 3), HIGHSCORE_NAME_X, y, TEXT_OFFSET, TEXT_OFFSET);
      // 6 BCD-Ziffern (das oberste Byte zeigt das Original nicht), mit führenden Nullen
      const digits = String(entry.score % 1_000_000).padStart(6, "0");
      font.drawWord(buf, digits, HIGHSCORE_SCORE_X, y, TEXT_OFFSET, TEXT_OFFSET);
      y += HIGHSCORE_PITCH;
    }
    buf.version++;
  }

  private picture(): { pixels: Uint8Array; palette: Uint16Array } {
    const img = this.game.assets.images.get("menu.background");
    if (!img) throw new Error("Bild menu.background fehlt");
    return img;
  }

  private module(): ProtrackerModule {
    const m = this.game.assets.modules.get("menu");
    if (!m) throw new Error("Modul menu fehlt");
    return m;
  }
}
