// Hinweise des Remakes über dem Bild (z. B. „Gerät drehen“), gezeichnet mit der Menüschrift ins Overlay.

import type { UiKey } from "../data/lang/ui.ts";
import { WINDOW_HEIGHT, WINDOW_WIDTH } from "./display.ts";
import type { Game } from "./game.ts";
import { layoutLines } from "./i18n.ts";
import type { Font } from "./text.ts";

/** Farben des Overlays: 1 = Schrift, 2 = Hervorhebung, 31 = Rand der Schrift (5 Planes) */
export const OVERLAY_TEXT = 1;
export const OVERLAY_HIGHLIGHT = 2;
export const OVERLAY_PLANES = 5;
const OVERLAY_PALETTE = [0x000, 0xfff, 0xfc4];
const OVERLAY_OUTLINE = 0x000;
const LINE_PITCH = 40;

export function prepareOverlay(game: Game, dim: number): void {
  const o = game.display.overlay;
  o.clear();
  o.palette.fill(0);
  o.palette.set(OVERLAY_PALETTE);
  o.palette[(1 << OVERLAY_PLANES) - 1] = OVERLAY_OUTLINE;
  o.dim = dim;
  o.visible = true;
}

export function drawNotice(game: Game, key: UiKey): void {
  prepareOverlay(game, 15);
  const text = game.texts.ui(key);
  const rows = text.split("|").length;
  const top = (WINDOW_HEIGHT - rows * LINE_PITCH) >> 1;
  const lines = layoutLines(game.font, text, WINDOW_WIDTH >> 1, top, LINE_PITCH);
  game.font.drawPage(game.display.overlay, lines, 0, 0, OVERLAY_PLANES);
}

/** Bedienhinweis in verkleinerter Menüschrift (Faktor), damit er nicht mit dem Bild konkurriert */
export const PROMPT_FONT_SCALE = 2;
/** Abstand der Zeichenunterkante zum unteren Rand des Ausschnitts */
const PROMPT_MARGIN = 4;
let promptFont: { source: Font; font: Font } | null = null;

/** Bedienhinweis (E-039) einzeilig am unteren Rand des Ausschnitts, Spielbild nicht abgedunkelt */
export function drawPrompt(game: Game, key: UiKey): void {
  if (promptFont?.source !== game.font) promptFont = { source: game.font, font: game.font.downscaled(PROMPT_FONT_SCALE) };
  const font = promptFont.font;
  prepareOverlay(game, 0);
  const v = game.display.view;
  // Zeichen reichen von y − 1 bis y + drawRows (Umriss)
  const y = v.y + v.height - PROMPT_MARGIN - font.drawRows - 1;
  const lines = layoutLines(font, game.texts.ui(key), v.x + (v.width >> 1), y, LINE_PITCH);
  font.drawPage(game.display.overlay, lines, 0, 0, OVERLAY_PLANES);
}
