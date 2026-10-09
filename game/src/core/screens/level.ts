// Level-Bildschirm: verbindet die Level-Engine (E-032) mit dem Spielablauf. Das Bild ist Hires ohne Interlace
// (Statuszeile in Hires, Spielfeld in Lowres); der Renderer passt Statuszeile und Spielfeld bildschirmfüllend ein.
// Nach dem Spielende steht das Bild wie im Original während des Ladens („GAME OVER“, Regen); statt der Ladezeit
// (Crack-Fassung ≈ 65 s) eine feste Dauer (E-036), dann das Menü. Nach dem Levelende mit Leben ebenso, dann das
// Ladebild des nächsten Levels. An einer noch nicht übertragenen Stelle führt der Bildschirm zum Platzhalter.

import { WINDOW_HSTART, WINDOW_VSTART } from "../display.ts";
import type { Game, Screen } from "../game.ts";
import type { InputFrame } from "../input.ts";
import { LevelEngine } from "../level/engine.ts";
import type { LevelLayout } from "../level/layout.ts";
import { DMAF_AUDIO } from "../paula.ts";
import { firePressed } from "../prompt.ts";

/** Sichtbarer Bereich des Levels: Fenster ab DIWSTRT $2D90 bis Zeile $100, 288 Pixel breit */
const VIEW_X = 0x90 - WINDOW_HSTART;
const VIEW_Y = 0x2d - WINDOW_VSTART;
const VIEW_WIDTH = 288;
const VIEW_HEIGHT = 0x100 - 0x2d;
/**
 * Nach EXIT LEVEL (Spielende wie Levelende): 150 Bilder statt der Ladezeit (wie E-025), dann wie im Original
 * 50 Bilder (Delay_Count, die Musik blendet aus) bis zum schwarzen Bild
 */
const EXIT_WAIT_FRAMES = 150;
const EXIT_FRAMES = EXIT_WAIT_FRAMES + 50;
/** Bedienhinweis „Feuer drücken“ nach 1 s; ein neuer Feuerdruck überspringt den Rest der 150 Bilder (E-039) */
const EXIT_PROMPT_FRAMES = 50;

/** Wohin der Bildschirm am Ende führt */
export interface LevelExits {
  /** nach dem Spielende (das Original lädt das Menü `igt`) */
  gameOver: () => Screen;
  /**
   * nach dem Levelende mit Leben (das Original lädt das Ladebild des nächsten Levels); `shared` = gemeinsame Variablen
   * ab $1B0 für das nächste Level
   */
  levelDone: (shared: Uint8Array) => Screen;
  /** an der ersten nicht übertragenen Stelle (vorläufig) */
  unported: () => Screen;
}

export class LevelScreen implements Screen {
  private readonly layout: LevelLayout;
  private readonly exits: LevelExits;
  private engineInstance: LevelEngine | null = null;
  private readonly shared: Uint8Array | undefined;
  private exitFrames = 0;

  /** `shared`: gemeinsame Variablen aus dem vorigen Level (fehlt beim Spielstart aus dem Menü) */
  constructor(layout: LevelLayout, exits: LevelExits, shared?: Uint8Array) {
    this.layout = layout;
    this.exits = exits;
    this.shared = shared;
  }

  /** Die Engine (für Tests und Fehlersuche) */
  get engine(): LevelEngine {
    if (!this.engineInstance) throw new Error("Level ist noch nicht gestartet");
    return this.engineInstance;
  }

  enter(game: Game): void {
    game.paula.stop(DMAF_AUDIO);
    const d = game.display;
    d.setMode(true, false);
    d.setView(VIEW_X, VIEW_Y, VIEW_WIDTH, VIEW_HEIGHT);
    const e = new LevelEngine(this.layout, game.assets.memory, game.assets.tables.get("status.extra"));
    e.setStatusTexts(game.texts.status(this.layout.file));
    e.start(this.shared);
    this.engineInstance = e;
  }

  languageChanged(game: Game): void {
    this.engineInstance?.setStatusTexts(game.texts.status(this.layout.file));
  }

  tick(game: Game, input: InputFrame): void {
    const e = this.engine;
    e.setInput(input.buttons);
    e.tick(game.display);
    if (e.unported) game.setScreen(this.exits.unported());
    else if (e.result) this.exitTick(game);
  }

  private exitTick(game: Game): void {
    const n = ++this.exitFrames;
    if (n === EXIT_PROMPT_FRAMES) game.setPrompt("ui.pressFire");
    else if (n > EXIT_PROMPT_FRAMES && n < EXIT_WAIT_FRAMES && firePressed(game)) this.exitFrames = EXIT_WAIT_FRAMES;
    if (this.exitFrames === EXIT_WAIT_FRAMES) game.setPrompt(null);
    if (this.exitFrames === EXIT_FRAMES) {
      const e = this.engine;
      game.setScreen(e.result === "levelDone" ? this.exits.levelDone(e.sharedState()) : this.exits.gameOver());
    }
  }
}
