// Optionsmenü des Remakes (Enhanced-Stufe E0): im Spiel mit der Originalschrift gezeichnet, nicht als HTML,
// damit es in Browser und App gleich aussieht. Bedienung per Joystick (hoch/runter wählen, links/rechts/Feuer
// ändern) oder durch Antippen einer Zeile. Während das Menü offen ist, steht das Spiel.
// Einträge: Sprache, „Feuermenü“ (Zaubermenü mit gehaltenem Feuer, E-043), im Level „Spiel beenden“ mit Rückfrage
// (zweites Auswählen bestätigt; wirkt wie Esc im Original), Zurück.

import type { TextLine } from "../data/manifest.ts";
import { WINDOW_WIDTH } from "./display.ts";
import type { Game } from "./game.ts";
import { LANGS } from "./i18n.ts";
import { BTN_OPTIONS, InputFrame, JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP, NO_TAP } from "./input.ts";
import { OVERLAY_HIGHLIGHT, OVERLAY_PLANES, OVERLAY_TEXT, prepareOverlay } from "./notice.ts";

const ITEM_LANGUAGE = 0;
const ITEM_SPELL_FIRE = 1;
const ITEM_QUIT = 2;
const ITEM_BACK = 3;

const TITLE_Y = 24;
const FIRST_ITEM_Y = 104;
const ITEM_PITCH = 40;
/** Höhe einer Textzeile der Menüschrift (für Hervorhebung und Antippen) */
const ROW_HEIGHT = 22;
/** Abdunkelung des Spielbilds hinter dem Menü */
const DIM = 14;

export class OptionsMenu {
  isOpen = false;
  /** Index in `items` */
  private selected = 0;
  /** Einträge dieses Öffnens (ITEM_*; „Spiel beenden“ nur, wo der Bildschirm es anbietet) */
  private readonly items: number[] = [];
  /** „Spiel beenden“ einmal gewählt: Rückfrage steht */
  private confirmQuit = false;
  private readonly lines: TextLine[] = [];

  open(game: Game): void {
    this.isOpen = true;
    this.items.length = 0;
    this.items.push(ITEM_LANGUAGE, ITEM_SPELL_FIRE);
    if (game.canQuit) this.items.push(ITEM_QUIT);
    this.items.push(ITEM_BACK);
    this.selected = 0;
    this.confirmQuit = false;
    this.draw(game);
  }

  close(game: Game): void {
    this.isOpen = false;
    game.display.overlay.visible = false;
  }

  tick(game: Game, input: InputFrame): void {
    const pressed = game.edges.pressed;
    if (pressed & BTN_OPTIONS) {
      this.close(game);
      return;
    }
    const count = this.items.length;
    let index = this.selected;
    if (pressed & JOY_UP) index = (index + count - 1) % count;
    if (pressed & JOY_DOWN) index = (index + 1) % count;
    let activate = (pressed & JOY_FIRE) !== 0;
    let direction = pressed & JOY_LEFT ? -1 : pressed & JOY_RIGHT ? 1 : 0;

    if (input.tapY !== NO_TAP) {
      const hit = this.itemAt(input.tapY);
      if (hit >= 0) {
        index = hit;
        activate = true;
      }
    }
    if (index !== this.selected) {
      this.selected = index;
      this.confirmQuit = false;
      this.draw(game);
    }

    const item = this.items[this.selected];
    if (item === ITEM_LANGUAGE && (activate || direction !== 0)) {
      if (direction === 0) direction = 1;
      const i = LANGS.indexOf(game.settings.lang);
      game.setLanguage(LANGS[(i + direction + LANGS.length) % LANGS.length]!);
    } else if (item === ITEM_SPELL_FIRE && (activate || direction !== 0)) {
      game.setSpellFire(!(game.settings.spellFire ?? false));
      this.draw(game);
    } else if (item === ITEM_QUIT && activate) {
      if (this.confirmQuit) {
        this.close(game);
        game.quit();
      } else {
        this.confirmQuit = true;
        this.draw(game);
      }
    } else if (item === ITEM_BACK && activate) {
      this.close(game);
    }
  }

  draw(game: Game): void {
    const t = game.texts, font = game.font;
    prepareOverlay(game, DIM);
    const center = WINDOW_WIDTH >> 1;
    const line = (text: string, y: number): TextLine => ({ x: center - (font.textWidth(text) >> 1), y, text });
    this.lines.length = 0;
    this.lines.push(line(t.ui("ui.options"), TITLE_Y));
    for (let i = 0; i < this.items.length; i++) this.lines.push(line(this.itemText(game, this.items[i]!), this.itemY(i)));
    const overlay = game.display.overlay;
    font.drawPage(overlay, this.lines, 0, 0, OVERLAY_PLANES);
    // Gewählte Zeile hervorheben: Schriftfarbe umfärben
    const y0 = this.itemY(this.selected) - 1;
    for (let i = y0 * overlay.width, end = Math.min(overlay.height, y0 + ROW_HEIGHT) * overlay.width; i < end; i++) {
      if (overlay.pixels[i] === OVERLAY_TEXT) overlay.pixels[i] = OVERLAY_HIGHLIGHT;
    }
  }

  private itemText(game: Game, item: number): string {
    const t = game.texts;
    switch (item) {
      case ITEM_LANGUAGE:
        return `${t.ui("ui.language")}: ${t.ui(game.settings.lang === "de" ? "ui.language.de" : "ui.language.en")}`;
      case ITEM_SPELL_FIRE:
        return `${t.ui("ui.spellFire")}: ${t.ui(game.settings.spellFire ? "ui.on" : "ui.off")}`;
      case ITEM_QUIT:
        return t.ui(this.confirmQuit ? "ui.quitConfirm" : "ui.quit");
      default:
        return t.ui("ui.back");
    }
  }

  private itemY(index: number): number {
    return FIRST_ITEM_Y + index * ITEM_PITCH;
  }

  private itemAt(y: number): number {
    for (let i = 0; i < this.items.length; i++) {
      const top = this.itemY(i) - ITEM_PITCH / 4;
      if (y >= top && y < top + ITEM_PITCH) return i;
    }
    return -1;
  }
}
