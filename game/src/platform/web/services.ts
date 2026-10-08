// Kleine Plattformdienste im Browser: Speicher, Lebenszyklus, Laden der Spieldaten.

import type { Manifest } from "../../data/manifest.ts";
import { assetFiles, buildAssets, type GameAssets } from "../../core/assets.ts";
import type { KeyValueStore, Lifecycle } from "../types.ts";

const STORAGE_PREFIX = "agony.";

/** Schlüssel/Wert-Speicher über localStorage; ohne Speicher (privates Fenster, gesperrt) gehen Werte verloren. */
export class WebStorage implements KeyValueStore {
  get(key: string): string | null {
    try {
      return localStorage.getItem(STORAGE_PREFIX + key);
    } catch {
      return null;
    }
  }

  set(key: string, value: string): void {
    try {
      localStorage.setItem(STORAGE_PREFIX + key, value);
    } catch {
      // Speicher nicht verfügbar – Einstellung gilt nur bis zum Neuladen
    }
  }
}

/** Tab-Wechsel, Bildschirmsperre, Seite verlassen → inaktiv. */
export class WebLifecycle implements Lifecycle {
  onActiveChange(callback: (active: boolean) => void): void {
    document.addEventListener("visibilitychange", () => callback(document.visibilityState === "visible"));
    window.addEventListener("pagehide", () => callback(false));
    window.addEventListener("pageshow", () => callback(document.visibilityState === "visible"));
  }
}

/** Spieldaten über relative Adressen laden (funktioniert im Browser und später in der App). */
export async function loadGameAssets(baseUrl: string): Promise<GameAssets> {
  const res = await fetch(new URL("manifest.json", baseUrl));
  if (!res.ok) throw new Error(`manifest.json: HTTP ${res.status}`);
  const manifest = (await res.json()) as Manifest;
  const files = new Map<string, Uint8Array>();
  await Promise.all(
    assetFiles(manifest).map(async (name) => {
      const r = await fetch(new URL(name, baseUrl));
      if (!r.ok) throw new Error(`${name}: HTTP ${r.status}`);
      files.set(name, new Uint8Array(await r.arrayBuffer()));
    }),
  );
  return buildAssets(manifest, files);
}
