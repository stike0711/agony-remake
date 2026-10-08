// Ablaufsteuerung für die Präsentationsbildschirme: Das Original läuft dort als gerader Programmcode mit
// Warteschleifen („warte n Bilder“, „warte auf Sample-Ende“). Ein Script bildet das nach: eine Liste von Schritten,
// die nacheinander ausgeführt werden, bis einer eine Wartebedingung zurückgibt. Die Bedingung wird ab dem nächsten
// Takt einmal je Takt geprüft (auf Wunsch auch sofort); ist sie erfüllt, geht es im selben Takt weiter.
//
// Zeitbezug: Ein Takt entspricht einem Bild; Schritte laufen direkt nach dem Bild-Interrupt, wie der Code des
// Originals nach dem Ende einer Warteschleife.

export interface Waiter<C> {
  /**
   * Prüft die Bedingung. `immediate` = Aufruf im selben Takt, in dem die Wartezeit beginnt (Rest des Bilds);
   * sonst ein neuer Takt.
   */
  poll(ctx: C, immediate: boolean): boolean;
}

export type Step<C> = (ctx: C) => Waiter<C> | void;

export class Script<C> {
  private readonly steps: readonly Step<C>[];
  private pc = 0;
  private waiter: Waiter<C> | null = null;

  constructor(steps: readonly Step<C>[]) {
    this.steps = steps;
  }

  get done(): boolean {
    return this.pc >= this.steps.length && this.waiter === null;
  }

  /** Programmzähler auf Schritt `index` setzen und laufende Wartebedingung verwerfen (wie ein Sprung im Original). */
  jump(index: number): void {
    this.pc = index;
    this.waiter = null;
  }

  tick(ctx: C): void {
    if (this.waiter) {
      if (!this.waiter.poll(ctx, false)) return;
      this.waiter = null;
    }
    while (this.pc < this.steps.length) {
      const w = this.steps[this.pc++]!(ctx);
      if (w && !w.poll(ctx, true)) {
        this.waiter = w;
        return;
      }
    }
  }
}

/** „Warte n Bilder“ (Bildzähler löschen, dann warten, bis er n erreicht). Wiederverwendbar ohne neue Objekte. */
export class FrameWait<C> implements Waiter<C> {
  private left = 0;

  frames(n: number): this {
    this.left = n;
    return this;
  }

  poll(_ctx: C, immediate: boolean): boolean {
    if (immediate) return this.left <= 0;
    return --this.left <= 0;
  }
}
