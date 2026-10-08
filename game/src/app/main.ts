// Einstieg der Web-Fassung: Plattform aufbauen, Spieldaten laden, Kern starten.
// Die Plattform wird nur hier gewählt (später: Capacitor.isNativePlatform() → native Dienste).

import "./style.css";
import { Game, type Settings } from "../core/game.ts";
import { LANGS, languageFromLocale } from "../core/i18n.ts";
import { titleSequence } from "../core/flow.ts";
import { StartGate } from "../core/screens/start-gate.ts";
import { loadGameAssets } from "../platform/web/services.ts";
import { createWebPlatform } from "../platform/web/platform.ts";
import type { KeyValueStore } from "../platform/types.ts";
import { MainLoop } from "./loop.ts";

const SETTINGS_KEY = "settings";

function loadSettings(storage: KeyValueStore, locale: string): Settings {
  const fallback: Settings = { lang: languageFromLocale(locale) };
  try {
    const saved = JSON.parse(storage.get(SETTINGS_KEY) ?? "null") as Partial<Settings> | null;
    if (saved && LANGS.includes(saved.lang as never)) return { ...fallback, lang: saved.lang! };
  } catch {
    // beschädigte Einstellungen ignorieren
  }
  return fallback;
}

function element<T extends HTMLElement>(id: string): T {
  const el = document.getElementById(id);
  if (!el) throw new Error(`#${id} fehlt in index.html`);
  return el as T;
}

async function main(): Promise<void> {
  const platform = createWebPlatform({
    canvas: element<HTMLCanvasElement>("screen"),
    safeArea: element("safe-area"),
    stick: element("stick"),
    knob: element("stick-knob"),
    options: element("options-button"),
  });

  // Ton bei der ersten (und jeder weiteren) Nutzeraktion freischalten; iOS verlangt das innerhalb des Ereignisses
  const unlock = (): void => platform.audio.unlock();
  for (const type of ["pointerdown", "pointerup", "touchend", "keydown", "click"]) {
    window.addEventListener(type, unlock, { capture: true, passive: true });
  }

  const assets = await loadGameAssets(new URL("data/", document.baseURI).href);
  const settings = loadSettings(platform.storage, platform.locale);
  const game = new Game(assets, settings, new StartGate(titleSequence));
  game.onSettingsChanged = (s) => platform.storage.set(SETTINGS_KEY, JSON.stringify(s));
  platform.audio.setMemory(assets.chip.bytes);

  const loop = new MainLoop(game, platform);
  platform.lifecycle.onActiveChange((active) => {
    loop.setActive(active);
    platform.audio.setActive(active);
  });
  const checkOrientation = (): void => game.setNotice(platform.isPortraitTouch() ? "ui.rotate" : null);
  platform.onLayoutChange(checkOrientation);
  checkOrientation();
  loop.start();

  if (import.meta.env.DEV) Object.assign(window, { agony: { game, loop, platform } });
}

main().catch((e: unknown) => {
  console.error(e);
  // Technische Fehlermeldung (kein Spieltext): nur Symbol und Ursache
  document.body.dataset.error = `⚠ ${e instanceof Error ? e.message : String(e)}`;
});
