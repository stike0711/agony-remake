// Lädt die Spieldaten der Asset-Pipeline aus game/public/data für Tests in Node.
// Fehlen sie (Pipeline noch nicht gelaufen), überspringen die Tests, die sie brauchen.

import { existsSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import type { Manifest } from "../src/data/manifest.ts";
import { assetFiles, buildAssets, type GameAssets } from "../src/core/assets.ts";

const DATA_DIR = join(dirname(fileURLToPath(import.meta.url)), "../public/data");

export const hasAssets = existsSync(join(DATA_DIR, "manifest.json"));

export function loadAssets(): GameAssets {
  const manifest = JSON.parse(readFileSync(join(DATA_DIR, "manifest.json"), "utf8")) as Manifest;
  const files = new Map<string, Uint8Array>();
  for (const f of assetFiles(manifest)) files.set(f, new Uint8Array(readFileSync(join(DATA_DIR, f))));
  return buildAssets(manifest, files);
}
