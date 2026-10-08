// Schnittstellen der Plattformdienste. Der Kern kennt sie nicht; die App verbindet Kern und Plattform.
// Web-Umsetzung: platform/web/, später die native App (Capacitor): platform/native/.

import type { Display } from "../core/display.ts";
import type { InputFrame } from "../core/input.ts";

export interface Renderer {
  /** Bild darstellen (lädt nur neu hoch, wenn sich `display.frame` oder die Fenstergröße geändert hat). */
  draw(display: Display): void;
  /** Bildschirmpunkt (CSS-Pixel relativ zum Fenster) → Lowres-Koordinaten des Bildausschnitts, außerhalb null. */
  toWindow(clientX: number, clientY: number): { x: number; y: number } | null;
}

export interface AudioOutput {
  /** Ton freischalten – muss innerhalb einer Nutzeraktion (Berührung, Taste) aufgerufen werden. */
  unlock(): void;
  /** Sample-Speicher des Kerns übergeben (einmal beim Start). */
  setMemory(bytes: Int8Array): void;
  /** Registerzugriffe (mit Zeitpunkt) und Dauer eines Takts weitergeben (Format von Paula.log, LOG_STRIDE Werte je Eintrag). */
  submit(writes: Int32Array, count: number, cc: number, frozen: boolean): void;
  /** Pause bei App-Wechsel bzw. Fortsetzen. */
  setActive(active: boolean): void;
}

export interface InputSource {
  /** Eingabe für den nächsten Takt in `out` schreiben. */
  poll(out: InputFrame): void;
}

export interface KeyValueStore {
  get(key: string): string | null;
  set(key: string, value: string): void;
}

export interface Lifecycle {
  /** Rückruf bei Wechsel in den Hintergrund (false) bzw. zurück (true). */
  onActiveChange(callback: (active: boolean) => void): void;
}

export interface Platform {
  readonly renderer: Renderer;
  readonly audio: AudioOutput;
  readonly input: InputSource;
  readonly storage: KeyValueStore;
  readonly lifecycle: Lifecycle;
  /** Sprache des Geräts, z. B. "de-DE" */
  readonly locale: string;
  /** Hochformat auf einem Touch-Gerät (dann Hinweis „Gerät drehen“) */
  isPortraitTouch(): boolean;
  onLayoutChange(callback: () => void): void;
}
