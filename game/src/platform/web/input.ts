// Eingabe im Browser: Tastatur, Gamepad und Touch werden auf den virtuellen Amiga-Joystick abgebildet.
// Kurze Drücke zwischen zwei Takten gehen nicht verloren (gemerkt bis zur nächsten Abfrage).
//
// Touch (erste Fassung, Varianten werden später verglichen): linke Bildschirmhälfte = Joystick, der dort entsteht,
// wo der Finger aufsetzt; rechte Hälfte = Feuer; Zahnrad oben rechts = Optionsmenü.

import {
  BTN_OPTIONS, BTN_SPELL, InputFrame, JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP, NO_TAP,
} from "../../core/input.ts";
import type { InputSource, Renderer } from "../types.ts";

const KEYS: Record<string, number> = {
  ArrowUp: JOY_UP, KeyW: JOY_UP, Numpad8: JOY_UP,
  ArrowDown: JOY_DOWN, KeyS: JOY_DOWN, Numpad2: JOY_DOWN,
  ArrowLeft: JOY_LEFT, KeyA: JOY_LEFT, Numpad4: JOY_LEFT,
  ArrowRight: JOY_RIGHT, KeyD: JOY_RIGHT, Numpad6: JOY_RIGHT,
  Numpad7: JOY_UP | JOY_LEFT, Numpad9: JOY_UP | JOY_RIGHT, Numpad1: JOY_DOWN | JOY_LEFT, Numpad3: JOY_DOWN | JOY_RIGHT,
  Space: JOY_FIRE, ControlLeft: JOY_FIRE, ControlRight: JOY_FIRE, KeyX: JOY_FIRE, Numpad0: JOY_FIRE,
  ShiftLeft: BTN_SPELL, KeyM: BTN_SPELL,
  Escape: BTN_OPTIONS, KeyO: BTN_OPTIONS,
};

/** Gamepad mit Standard-Belegung: Steuerkreuz 12–15, A/B = Feuer, X/Y = Zauber, Start/Select = Optionen */
const PAD_BUTTONS: readonly [number, number][] = [
  [12, JOY_UP], [13, JOY_DOWN], [14, JOY_LEFT], [15, JOY_RIGHT],
  [0, JOY_FIRE], [1, JOY_FIRE], [2, BTN_SPELL], [3, BTN_SPELL], [9, BTN_OPTIONS], [8, BTN_OPTIONS],
];
const PAD_DEADZONE = 0.5;

/** Joystick-Totzone und Radius der Anzeige in CSS-Pixeln */
const STICK_DEADZONE = 14;
const STICK_RADIUS = 56;
/** Anteil der Bildschirmbreite, der links als Joystick-Zone gilt */
const STICK_ZONE = 0.5;

export class WebInput implements InputSource {
  private keys = 0;
  private latched = 0;
  private touchStick = 0;
  private touchFire = 0;
  private tap: { x: number; y: number } | null = null;
  private stickPointer = -1;
  private stickX = 0;
  private stickY = 0;
  private readonly firePointers = new Set<number>();
  private readonly renderer: Renderer;
  private readonly stickEl: HTMLElement;
  private readonly knobEl: HTMLElement;
  private readonly optionsEl: HTMLElement;

  constructor(surface: HTMLElement, renderer: Renderer, ui: { stick: HTMLElement; knob: HTMLElement; options: HTMLElement }) {
    this.renderer = renderer;
    this.stickEl = ui.stick;
    this.knobEl = ui.knob;
    this.optionsEl = ui.options;

    window.addEventListener("keydown", (e) => {
      const bit = KEYS[e.code];
      if (bit === undefined || e.metaKey || e.altKey) return;
      e.preventDefault();
      this.keys |= bit;
      this.latched |= bit;
    });
    window.addEventListener("keyup", (e) => {
      const bit = KEYS[e.code];
      if (bit !== undefined) this.keys &= ~bit;
    });
    window.addEventListener("blur", () => this.releaseAll());

    surface.addEventListener("pointerdown", (e) => this.pointerDown(e));
    surface.addEventListener("pointermove", (e) => this.pointerMove(e));
    for (const type of ["pointerup", "pointercancel"] as const) surface.addEventListener(type, (e) => this.pointerUp(e));
    surface.addEventListener("contextmenu", (e) => e.preventDefault());

    this.optionsEl.addEventListener("pointerdown", (e) => {
      e.stopPropagation();
      e.preventDefault();
      this.latched |= BTN_OPTIONS;
    });
  }

  poll(out: InputFrame): void {
    out.buttons = this.keys | this.touchStick | this.touchFire | this.latched | this.pollGamepads();
    this.latched = 0;
    if (this.tap) {
      out.tapX = this.tap.x;
      out.tapY = this.tap.y;
      this.tap = null;
    } else {
      out.tapX = NO_TAP;
      out.tapY = NO_TAP;
    }
  }

  private pointerDown(e: PointerEvent): void {
    const pos = this.renderer.toWindow(e.clientX, e.clientY);
    if (pos) this.tap = pos;
    if (e.pointerType === "mouse") return;
    e.preventDefault();
    document.body.classList.add("touch");
    if (e.clientX < window.innerWidth * STICK_ZONE && this.stickPointer < 0) {
      this.stickPointer = e.pointerId;
      this.stickX = e.clientX;
      this.stickY = e.clientY;
      this.stickEl.style.transform = `translate(${e.clientX}px, ${e.clientY}px)`;
      this.knobEl.style.transform = "translate(0px, 0px)";
      this.stickEl.classList.add("active");
    } else {
      this.firePointers.add(e.pointerId);
      this.touchFire = JOY_FIRE;
      this.latched |= JOY_FIRE;
    }
  }

  private pointerMove(e: PointerEvent): void {
    if (e.pointerId !== this.stickPointer) return;
    const dx = e.clientX - this.stickX, dy = e.clientY - this.stickY;
    const dist = Math.hypot(dx, dy);
    let bits = 0;
    if (dist > STICK_DEADZONE) {
      // 8 Richtungen: Sektoren zu je 45°
      const sector = Math.round(Math.atan2(dy, dx) / (Math.PI / 4)) & 7;
      bits = [JOY_RIGHT, JOY_RIGHT | JOY_DOWN, JOY_DOWN, JOY_DOWN | JOY_LEFT, JOY_LEFT, JOY_LEFT | JOY_UP, JOY_UP, JOY_UP | JOY_RIGHT][sector]!;
    }
    this.touchStick = bits;
    this.latched |= bits;
    const k = Math.min(1, STICK_RADIUS / Math.max(dist, 1));
    this.knobEl.style.transform = `translate(${dx * k}px, ${dy * k}px)`;
  }

  private pointerUp(e: PointerEvent): void {
    if (e.pointerId === this.stickPointer) {
      this.stickPointer = -1;
      this.touchStick = 0;
      this.stickEl.classList.remove("active");
    }
    if (this.firePointers.delete(e.pointerId) && this.firePointers.size === 0) this.touchFire = 0;
  }

  private releaseAll(): void {
    this.keys = 0;
    this.touchStick = 0;
    this.touchFire = 0;
    this.stickPointer = -1;
    this.firePointers.clear();
    this.stickEl.classList.remove("active");
  }

  private pollGamepads(): number {
    const pads = navigator.getGamepads?.();
    if (!pads) return 0;
    let bits = 0;
    for (const pad of pads) {
      if (!pad || !pad.connected) continue;
      for (const [index, bit] of PAD_BUTTONS) if (pad.buttons[index]?.pressed) bits |= bit;
      const x = pad.axes[0] ?? 0, y = pad.axes[1] ?? 0;
      if (x < -PAD_DEADZONE) bits |= JOY_LEFT;
      if (x > PAD_DEADZONE) bits |= JOY_RIGHT;
      if (y < -PAD_DEADZONE) bits |= JOY_UP;
      if (y > PAD_DEADZONE) bits |= JOY_DOWN;
    }
    return bits;
  }
}
