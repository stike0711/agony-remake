// Zusammenstellung der Web-Plattform: Renderer, Ton, Eingabe, Speicher, Lebenszyklus, Anzeige.

import type { Platform } from "../types.ts";
import { WebAudio } from "./audio.ts";
import { WebInput } from "./input.ts";
import { WebGLRenderer } from "./renderer.ts";
import { WebLifecycle, WebStorage } from "./services.ts";

export interface WebElements {
  canvas: HTMLCanvasElement;
  /** Element, dessen Fläche dem sicheren Bereich entspricht (CSS env(safe-area-inset-*)) */
  safeArea: HTMLElement;
  stick: HTMLElement;
  knob: HTMLElement;
  options: HTMLElement;
}

export function createWebPlatform(el: WebElements): Platform {
  const renderer = new WebGLRenderer(el.canvas, el.safeArea);
  const coarse = window.matchMedia("(pointer: coarse)");
  return {
    renderer,
    audio: new WebAudio(),
    input: new WebInput(document.body, renderer, el),
    storage: new WebStorage(),
    lifecycle: new WebLifecycle(),
    locale: navigator.language,
    isPortraitTouch: () => coarse.matches && window.innerHeight > window.innerWidth,
    onLayoutChange: (cb) => {
      window.addEventListener("resize", cb);
      window.addEventListener("orientationchange", cb);
    },
  };
}
