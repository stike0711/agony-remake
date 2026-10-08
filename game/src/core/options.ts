// Optionsmenü des Remakes (Enhanced-Stufe E0): im Spiel mit der Originalschrift gezeichnet, nicht als HTML,
// damit es in Browser und App gleich aussieht. Bedienung per Joystick (hoch/runter wählen, links/rechts/Feuer
// ändern) oder durch Antippen einer Zeile. Während das Menü offen ist, steht das Spiel.

import type { TextLine } from "../data/manifest.ts";
import { WINDOW_WIDTH } from "./display.ts";
import type { Game } from "./game.ts";
import { LANGS } from "./i18n.ts";
import { BTN_OPTIONS, InputFrame, JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP, NO_TAP } from "./input.ts";
import { OVERLAY_HIGHLIGHT, OVERLAY_PLANES, OVERLAY_TEXT, prepareOverlay } from "./notice.ts";

const ITEM_LANGUAGE = 0;
const ITEM_BACK = 1;
const ITEM_COUNT = 2;

const TITLE_Y = 24;
const FIRST_ITEM_Y = 104;
const ITEM_PITCH = 40;
/** Höhe einer Textzeile der Menüschrift (für Hervorhebung und Antippen) */
const ROW_HEIGHT = 22;
/** Abdunkelung des Spielbilds hinter dem Menü */
const DIM = 14;

export class OptionsMenu {
  isOpen = false;
  private selected = ITEM_LANGUAGE;
  private readonly lines: TextLine[] = [];

  open(game: Game): void {
    this.isOpen = true;
    this.selected = ITEM_LANGUAGE;
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
    let item = this.selected;
    if (pressed & JOY_UP) item = (item + ITEM_COUNT - 1) % ITEM_COUNT;
    if (pressed & JOY_DOWN) item = (item + 1) % ITEM_COUNT;
    let activate = (pressed & JOY_FIRE) !== 0;
    let direction = pressed & JOY_LEFT ? -1 : pressed & JOY_RIGHT ? 1 : 0;

    if (input.tapY !== NO_TAP) {
      const hit = this.itemAt(input.tapY);
      if (hit >= 0) {
        item = hit;
        activate = true;
      }
    }
    if (item !== this.selected) {
      this.selected = item;
      this.draw(game);
    }

    if (this.selected === ITEM_LANGUAGE && (activate || direction !== 0)) {
      if (direction === 0) direction = 1;
      const i = LANGS.indexOf(game.settings.lang);
      game.setLanguage(LANGS[(i + direction + LANGS.length) % LANGS.length]!);
    } else if (this.selected === ITEM_BACK && activate) {
      this.close(game);
    }
  }

  draw(game: Game): void {
    const t = game.texts, font = game.font;
    prepareOverlay(game, DIM);
    const center = WINDOW_WIDTH >> 1;
    const line = (text: string, y: number): TextLine => ({ x: center - (font.textWidth(text) >> 1), y, text });
    this.lines.length = 0;
    this.lines.push(
      line(t.ui("ui.options"), TITLE_Y),
      line(`${t.ui("ui.language")}: ${t.ui(game.settings.lang === "de" ? "ui.language.de" : "ui.language.en")}`, this.itemY(ITEM_LANGUAGE)),
      line(t.ui("ui.back"), this.itemY(ITEM_BACK)),
    );
    const overlay = game.display.overlay;
    font.drawPage(overlay, this.lines, 0, 0, OVERLAY_PLANES);
    // Gewählte Zeile hervorheben: Schriftfarbe umfärben
    const y0 = this.itemY(this.selected) - 1;
    for (let i = y0 * overlay.width, end = Math.min(overlay.height, y0 + ROW_HEIGHT) * overlay.width; i < end; i++) {
      if (overlay.pixels[i] === OVERLAY_TEXT) overlay.pixels[i] = OVERLAY_HIGHLIGHT;
    }
  }

  private itemY(item: number): number {
    return FIRST_ITEM_Y + item * ITEM_PITCH;
  }

  private itemAt(y: number): number {
    for (let i = 0; i < ITEM_COUNT; i++) {
      const top = this.itemY(i) - ITEM_PITCH / 4;
      if (y >= top && y < top + ITEM_PITCH) return i;
    }
    return -1;
  }
}
