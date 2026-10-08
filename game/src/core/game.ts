// Spielzustand und Takt: ein Aufruf von `tick` = ein Bild des Originals (PAL, ≈ 50 Hz).
// Der Kern kennt weder Zeit noch Plattform: Die App ruft `tick` im festen Takt auf, übergibt die Eingabe und reicht
// danach Bild (display) und Paula-Protokoll an Renderer und Audio weiter.

import { DE_PAGES } from "../data/lang/de.ts";
import type { GameAssets } from "./assets.ts";
import { Display } from "./display.ts";
import { type Lang, Texts } from "./i18n.ts";
import { BTN_OPTIONS, ButtonEdges, InputFrame, NO_TAP } from "./input.ts";
import { OptionsMenu } from "./options.ts";
import { Paula } from "./paula.ts";
import { ProtrackerPlayer } from "./protracker.ts";
import type { Font } from "./text.ts";
import { CC_PER_LINE, LINES_LONG_FIELD, LINES_SHORT_FIELD } from "./timing.ts";
import type { UiKey } from "../data/lang/ui.ts";
import { drawNotice, drawPrompt } from "./notice.ts";
import { PROMPT_ON_FRAMES, PROMPT_PERIOD } from "./prompt.ts";

export interface Screen {
  /** Bildschirm wird aktiv: Modus setzen, zeichnen, Ton starten */
  enter(game: Game): void;
  tick(game: Game, input: InputFrame): void;
  /** Sprache wurde gewechselt: sichtbaren Text neu zeichnen */
  languageChanged?(game: Game): void;
}

export interface Settings {
  lang: Lang;
}

export class Game {
  readonly display = new Display();
  readonly paula = new Paula();
  /** ProTracker-Abspieler für Menü- und Lademusik (spielt über `paula`) */
  readonly music: ProtrackerPlayer;
  readonly assets: GameAssets;
  readonly texts: Texts;
  /** Menüschrift (für Remake-Texte und Menüseiten) */
  readonly font: Font;
  readonly settings: Settings;
  /** Tastenflanken des aktuellen Takts (gerade gedrückt) */
  readonly edges = new ButtonEdges();
  /** In diesem Takt wurde das Bild angetippt bzw. angeklickt */
  tapped = false;
  /** Anzahl der ausgeführten Takte */
  ticks = 0;
  /** Länge des laufenden (bzw. zuletzt ausgeführten) Takts in Farbtakten (Interlace: lange und kurze Halbbilder im Wechsel) */
  tickCc = LINES_LONG_FIELD * CC_PER_LINE;
  /** true, solange das Spiel steht (Optionsmenü, Hinweis): Paula steht, der Mixer schweigt */
  frozen = false;
  /** wird nach jeder Änderung der Einstellungen aufgerufen (die App speichert sie) */
  onSettingsChanged: ((settings: Settings) => void) | null = null;

  private screen: Screen;
  private pending: Screen | null = null;
  private readonly options = new OptionsMenu();
  private notice: UiKey | null = null;
  /** Bedienhinweis (E-039), blinkt im Overlay, solange weder Hinweis noch Optionsmenü es belegen */
  private prompt: UiKey | null = null;
  private promptFrames = 0;
  private promptDrawn = false;
  private longField = true;

  constructor(assets: GameAssets, settings: Settings, first: Screen) {
    this.assets = assets;
    this.paula.memory = assets.chip.bytes;
    const table = (key: string): readonly number[] => {
      const t = assets.tables.get(key);
      if (!t) throw new Error(`Tabelle „${key}“ fehlt: Asset-Pipeline neu ausführen`);
      return t;
    };
    this.music = new ProtrackerPlayer(this.paula, { periods: table("pt.periods"), sine: table("pt.sine"), funk: table("pt.funk") });
    this.settings = { ...settings };
    const font = assets.fonts.get("menu");
    if (!font) throw new Error("Schrift „menu“ fehlt");
    this.font = font;
    this.texts = new Texts(assets.texts, DE_PAGES, font);
    this.texts.lang = settings.lang;
    this.screen = first;
    this.paula.reset();
    first.enter(this);
  }

  /** Nächsten Bildschirm setzen; der Wechsel passiert am Ende des laufenden Takts. */
  setScreen(screen: Screen): void {
    this.pending = screen;
  }

  setLanguage(lang: Lang): void {
    if (lang === this.settings.lang) return;
    this.settings.lang = lang;
    this.texts.lang = lang;
    this.screen.languageChanged?.(this);
    if (this.options.isOpen) this.options.draw(this);
    if (this.notice) drawNotice(this, this.notice);
    this.promptDrawn = false;
    this.onSettingsChanged?.(this.settings);
  }

  /** Hinweis über dem Bild anzeigen und das Spiel anhalten (z. B. „Gerät drehen“); null = weiter. */
  setNotice(key: UiKey | null): void {
    if (key === this.notice) return;
    this.notice = key;
    if (key) drawNotice(this, key);
    else if (this.options.isOpen) this.options.draw(this);
    else this.display.overlay.visible = false;
  }

  /** Bedienhinweis am unteren Rand blinken lassen (E-039); null = aus. Endet mit jedem Bildschirmwechsel. */
  setPrompt(key: UiKey | null): void {
    if (key === this.prompt) return;
    this.prompt = key;
    this.promptFrames = 0;
    this.promptDrawn = false;
    if (!key && !this.notice && !this.options.isOpen) this.display.overlay.visible = false;
  }

  tick(input: InputFrame): void {
    this.edges.update(input.buttons);
    this.tapped = input.tapX !== NO_TAP;
    this.paula.clearLog();
    // Länge dieses Takts steht vorher fest: Bildschirme rechnen damit (z. B. „endet das Sample noch in diesem Bild?“)
    const lines = this.display.lace ? (this.longField ? LINES_LONG_FIELD : LINES_SHORT_FIELD) : LINES_LONG_FIELD;
    this.tickCc = lines * CC_PER_LINE;

    if (this.notice) {
      // nichts weiter: Bild und Ton stehen
    } else if (this.options.isOpen) {
      this.options.tick(this, input);
    } else if (this.edges.pressed & BTN_OPTIONS) {
      this.options.open(this);
    } else {
      this.screen.tick(this, input);
      if (this.pending) {
        this.screen = this.pending;
        this.pending = null;
        this.setPrompt(null);
        this.edges.hold(input.buttons);
        this.screen.enter(this);
      }
    }

    this.frozen = this.notice !== null || this.options.isOpen;
    if (this.frozen) this.promptDrawn = false;
    else if (this.prompt) this.showPrompt(this.prompt);
    if (!this.frozen) {
      this.paula.endFrame(this.tickCc);
      this.longField = this.display.lace ? !this.longField : true;
      this.ticks++;
    }
    this.display.frame++;
  }

  private showPrompt(key: UiKey): void {
    if (!this.promptDrawn) {
      drawPrompt(this, key);
      this.promptDrawn = true;
    }
    this.display.overlay.visible = this.promptFrames % PROMPT_PERIOD < PROMPT_ON_FRAMES;
    this.promptFrames++;
  }
}
