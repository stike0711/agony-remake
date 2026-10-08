// Eingabe pro Takt: ein virtueller Amiga-Joystick (8 Richtungen + Feuer) plus Remake-Tasten.
// Touch, Tastatur und Gamepad werden in der Plattform-Schicht darauf abgebildet.

export const JOY_UP = 1 << 0;
export const JOY_DOWN = 1 << 1;
export const JOY_LEFT = 1 << 2;
export const JOY_RIGHT = 1 << 3;
export const JOY_FIRE = 1 << 4;
/** Zaubermenü (im Original: Feuer halten; eigene Taste wegen Dauerfeuer, siehe Architektur) */
export const BTN_SPELL = 1 << 5;
/** Optionsmenü des Remakes öffnen/schließen */
export const BTN_OPTIONS = 1 << 6;

export const JOY_DIRECTIONS = JOY_UP | JOY_DOWN | JOY_LEFT | JOY_RIGHT;

/** Kein Antippen in diesem Takt */
export const NO_TAP = -1;

/** Eingabe für genau einen Takt; wird von der Plattform befüllt und von Replays aufgezeichnet. */
export class InputFrame {
  /** gedrückte Tasten (JOY_* / BTN_*) */
  buttons = 0;
  /** Antippen/Klicken in Lowres-Koordinaten des Bildausschnitts, sonst NO_TAP */
  tapX = NO_TAP;
  tapY = NO_TAP;

  clear(): void {
    this.buttons = 0;
    this.tapX = NO_TAP;
    this.tapY = NO_TAP;
  }

  copyFrom(o: InputFrame): void {
    this.buttons = o.buttons;
    this.tapX = o.tapX;
    this.tapY = o.tapY;
  }
}

/** Erkennt Flanken (gerade gedrückt) zwischen zwei Takten. */
export class ButtonEdges {
  private last = 0;
  pressed = 0;

  update(buttons: number): void {
    this.pressed = buttons & ~this.last;
    this.last = buttons;
  }

  /** Nach einem Bildschirmwechsel: schon gehaltene Tasten nicht als neuen Druck werten. */
  hold(buttons: number): void {
    this.last = buttons;
    this.pressed = 0;
  }
}
