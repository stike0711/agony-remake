// Bedienhinweis „Feuer drücken“ (E-039): Wo der Nachbau eine Ladezeit des Originals durch Warten ersetzt, blinkt am
// unteren Rand ein Hinweis, sobald Feuer angenommen wird. Gezählt wird nur ein neuer Feuerdruck oder ein Antippen,
// kein gehaltener Knopf. Kein Teil des Originals; die Stellen warten dort nicht auf Feuer (Wiki original/startsequenz.md).

import type { Game } from "./game.ts";
import { JOY_FIRE } from "./input.ts";
import type { Waiter } from "./script.ts";

/** Blinktakt wie „PRESS FIRE TO START“ in der Statuszeile von Level 1 (≈ 19 Bilder an, 21 aus): 20 an, 20 aus */
export const PROMPT_ON_FRAMES = 20;
export const PROMPT_PERIOD = 40;

/** Neuer Feuerdruck oder Antippen in diesem Takt */
export function firePressed(game: Game): boolean {
  return (game.edges.pressed & JOY_FIRE) !== 0 || game.tapped;
}

/** Script-Wartebedingung: Hinweis zeigen, auf Feuer warten, Hinweis wieder aus. */
export class FirePrompt<C extends { game: Game }> implements Waiter<C> {
  poll(ctx: C, immediate: boolean): boolean {
    if (immediate) {
      ctx.game.setPrompt("ui.pressFire");
      return false;
    }
    if (!firePressed(ctx.game)) return false;
    ctx.game.setPrompt(null);
    return true;
  }
}
