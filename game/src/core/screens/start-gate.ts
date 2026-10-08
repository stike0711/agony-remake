// Startbildschirm des Remakes: „Zum Starten tippen“. Unvermeidbare Abweichung vom Original: Browser und iOS geben
// Ton erst nach einer Berührung bzw. einem Tastendruck frei; die Titelsequenz beginnt deshalb erst danach.

import { WINDOW_HEIGHT, WINDOW_WIDTH } from "../display.ts";
import type { Game, Screen } from "../game.ts";
import { layoutLines } from "../i18n.ts";
import { InputFrame, NO_TAP } from "../input.ts";

const PALETTE = [0x000, 0xfff];

export class StartGate implements Screen {
  private readonly next: () => Screen;

  constructor(next: () => Screen) {
    this.next = next;
  }

  enter(game: Game): void {
    const d = game.display;
    d.setMode(false, false, true);
    d.setView(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    d.setPalette(PALETTE);
    this.draw(game);
  }

  languageChanged(game: Game): void {
    this.draw(game);
  }

  tick(game: Game, input: InputFrame): void {
    if (game.edges.pressed !== 0 || input.tapX !== NO_TAP) game.setScreen(this.next());
  }

  private draw(game: Game): void {
    const d = game.display;
    d.clear(0);
    const text = game.texts.ui("ui.tapToStart");
    const lines = layoutLines(game.font, text, WINDOW_WIDTH >> 1, (WINDOW_HEIGHT >> 1) - 10, 40);
    game.font.drawPage(d, lines, 0, 0);
  }
}
