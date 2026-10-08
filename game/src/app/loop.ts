// Hauptschleife: Spiellogik in festen Takten wie das Original (Länge je Takt in Farbtakten, ≈ 50 Hz), Darstellung
// mit der Bildrate des Geräts per requestAnimationFrame. Nach Aussetzern wird nur begrenzt aufgeholt.

import type { Game } from "../core/game.ts";
import { InputFrame } from "../core/input.ts";
import { PAULA_CLOCK_PAL } from "../core/timing.ts";
import type { Platform } from "../platform/types.ts";

/** Höchstens so viele Takte pro Bild nachholen; danach wird die Rückstandszeit verworfen. */
const MAX_CATCH_UP = 4;
/** Längere Pausen (z. B. Debugger, Hintergrund) zählen nur bis hierhin */
const MAX_FRAME_MS = 250;
const CC_PER_MS = PAULA_CLOCK_PAL / 1000;

export class MainLoop {
  private readonly game: Game;
  private readonly platform: Platform;
  private readonly input = new InputFrame();
  private accumulator = 0;
  private last = -1;
  private active = true;
  /** optional: jede Eingabe mitschreiben (Replays) */
  onInput: ((input: InputFrame) => void) | null = null;

  constructor(game: Game, platform: Platform) {
    this.game = game;
    this.platform = platform;
  }

  start(): void {
    const frame = (now: number): void => {
      this.frame(now);
      requestAnimationFrame(frame);
    };
    requestAnimationFrame(frame);
  }

  setActive(active: boolean): void {
    this.active = active;
    this.last = -1;
    this.accumulator = 0;
  }

  private frame(now: number): void {
    if (!this.active) return;
    const dt = this.last < 0 ? 0 : Math.max(0, Math.min(now - this.last, MAX_FRAME_MS));
    this.last = now;
    this.accumulator += dt * CC_PER_MS;

    const { game, platform } = this;
    let n = 0;
    while (this.accumulator >= game.tickCc && n < MAX_CATCH_UP) {
      platform.input.poll(this.input);
      this.onInput?.(this.input);
      game.tick(this.input);
      platform.audio.submit(game.paula.log, game.paula.logCount, game.tickCc, game.frozen);
      this.accumulator -= game.tickCc;
      n++;
    }
    if (n === MAX_CATCH_UP) this.accumulator = 0;
    platform.renderer.draw(game.display);
  }
}
