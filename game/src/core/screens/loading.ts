// Ladebild eines Levels mit Lademusik (bisher Level 1: load_sea, Level 2: load_forest).
// Nachbildung von load_sea (Disassembly work/disasm/load_sea_code.txt; load_forest hat denselben Code, nur mit
// verschobenen Adressen, work/disasm/load_forest_code.txt): Bild zeigen, Palette einblenden, Musik;
// im Original wird jetzt das Level geladen und entpackt (Crack-Fassung ≈ 88 s), danach Bild und Musik ausblenden
// und das Level starten. Im Nachbau entfällt die Ladezeit: Mindestdauer, danach weiter mit Feuer (E-025).
// Takt 0 = erster Bild-Interrupt nach dem Start (mt_init läuft schon in `enter`).

import type { Game, Screen } from "../game.ts";
import { type InputFrame } from "../input.ts";
import { FirePrompt } from "../prompt.ts";
import { FrameWait, Script, type Step } from "../script.ts";
import { CopperPicture, FadeIn, FadeOut, PictureBuffer } from "./picture.ts";

export const LOADING_MIN_FRAMES = 150;

export interface LevelLoad {
  /** Bild- und Modulschlüssel in den Spieldaten, z. B. "load.sea" */
  asset: string;
  /** Adresse des Ladebilds im Original (Zeiger bei $61594) */
  address: number;
}

/** Quelle: load_sea $61594 */
export const LOAD_SEA: LevelLoad = { asset: "load.sea", address: 0x68a58 };
/** Quelle: load_forest $61594 */
export const LOAD_FOREST: LevelLoad = { asset: "load.forest", address: 0x66f1a };

export class LoadingScreen implements Screen {
  readonly copper = new CopperPicture();
  game!: Game;
  private readonly level: LevelLoad;
  /** Ladebild */
  private readonly buffer: PictureBuffer;
  private readonly next: () => Screen;
  private readonly script: Script<LoadingScreen>;
  private readonly frames = new FrameWait<LoadingScreen>();
  private readonly fadeIn = new FadeIn<LoadingScreen>();
  private readonly fadeOut = new FadeOut<LoadingScreen>();
  /** danach Hinweis „Feuer drücken“ und Warten auf Feuer (E-039) */
  private readonly waitFire = new FirePrompt<LoadingScreen>();

  constructor(level: LevelLoad, next: () => Screen) {
    this.level = level;
    this.buffer = new PictureBuffer(level.address);
    this.next = next;
    this.script = new Script(this.program());
  }

  enter(game: Game): void {
    this.game = game;
    const d = game.display;
    d.setMode(false, false, true);
    this.copper.palette.fill(0);
    this.copper.invalidate();
    this.copper.apply(d);
    this.buffer.copyFrom(this.image().pixels);
    // load_sea $61564: mt_init, Gesamtlautstärke $40
    const m = game.assets.modules.get(this.level.asset);
    if (!m) throw new Error(`Modul ${this.level.asset} fehlt`);
    game.music.init(m);
    game.music.master = 0x40;
  }

  tick(game: Game, _input: InputFrame): void {
    this.copper.apply(game.display);
    game.music.music(); // Bild-Interrupt $61708
    this.script.tick(this);
  }

  private program(): Step<LoadingScreen>[] {
    return [
      () => { this.copper.buffer = this.buffer; }, // $61594
      () => this.fadeIn.start(this.copper, this.image().palette), // $6159E
      // $615A2–$615DA: Level laden und entpacken – im Nachbau Mindestdauer und Feuer
      () => this.frames.frames(LOADING_MIN_FRAMES),
      () => this.waitFire,
      () => this.fadeOut.start(this.copper, this.image().palette, this.game.music), // $615E6
      () => this.game.setScreen(this.next()), // $615FA: jmp $600
    ];
  }

  private image(): { pixels: Uint8Array; palette: Uint16Array } {
    const img = this.game.assets.images.get(this.level.asset);
    if (!img) throw new Error(`Bild ${this.level.asset} fehlt`);
    return img;
  }
}
