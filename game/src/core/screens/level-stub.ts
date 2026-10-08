// Vorläufiger Platzhalter für Level 1 (bis das Level nachgebaut ist): schwarzes Bild mit Hinweis, Feuer → Menü.
// Kein Teil des Originals; verschwindet mit dem Nachbau von Level 1.

import { WINDOW_HEIGHT, WINDOW_WIDTH } from "../display.ts";
import type { Game, Screen } from "../game.ts";
import { layoutLines } from "../i18n.ts";
import { type InputFrame, JOY_FIRE } from "../input.ts";
import { DMAF_AUDIO } from "../paula.ts";

const PALETTE = [0x000, 0xfff];

export class LevelStub implements Screen {
  private readonly next: () => Screen;

  constructor(next: () => Screen) {
    this.next = next;
  }

  enter(game: Game): void {
    game.paula.stop(DMAF_AUDIO);
    const d = game.display;
    d.setMode(false, false, true);
    d.setView(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    d.setPalette(new Uint16Array(32));
    d.setPalette(PALETTE);
    this.draw(game);
  }

  languageChanged(game: Game): void {
    this.draw(game);
  }

  tick(game: Game, _input: InputFrame): void {
    if (game.edges.pressed & JOY_FIRE) game.setScreen(this.next());
  }

  private draw(game: Game): void {
    const d = game.display;
    d.clear(0);
    const lines = layoutLines(game.font, game.texts.ui("ui.levelStub"), WINDOW_WIDTH >> 1, (WINDOW_HEIGHT >> 1) - 40, 40);
    game.font.drawPage(d, lines, 0, 0);
  }
}
