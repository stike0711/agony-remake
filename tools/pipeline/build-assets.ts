// Asset-Pipeline: liest die Original-Disketten aus reference/ und erzeugt die Spieldaten für den Nachbau.
// Aufruf (vom Projektordner aus oder per npm run assets in game/):
//   node tools/pipeline/build-assets.ts [--no-preview]
// Ausgabe: game/public/data/ (manifest.json + Binärdateien, wird jedes Mal komplett neu erzeugt),
//          work/assets-preview/ (PNG/WAV/Text zum Ansehen, nicht vom Spiel benutzt).
// Format: game/src/data/manifest.ts. Die erzeugten Dateien nie von Hand bearbeiten.

import { mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { MANIFEST_FORMAT, type Manifest } from "../../game/src/data/manifest.ts";
import { extractLevel1, extractLevel2, extractLevel3 } from "./extract/levels.ts";
import { extractStartSequence, type Sink } from "./extract/startsequence.ts";
import { GameDisks } from "./lib/gamefiles.ts";
import { expandEhb, rgb12 } from "./lib/planar.ts";
import { encodeIndexedPng } from "./lib/png.ts";
import { encodeWav8, PAULA_CLOCK_PAL } from "./lib/wav.ts";

const here = dirname(fileURLToPath(import.meta.url));
const root = resolve(here, "../..");
const ADF_DIR = join(root, "reference/agony/game/Agony");
const DATA_DIR = join(root, "game/public/data");
const PREVIEW_DIR = join(root, "work/assets-preview");
const preview = !process.argv.includes("--no-preview");

// Abtastraten nur für die WAV-Vorschau: Perioden laut present-Code ($74C, $8A4, $9C6, $BA8)
const SAMPLE_PERIODS: Record<string, number> = { "title.a": 0xf4, "title.b": 0xf4, "title.c": 0xc2, "title.d": 0x98, "title.e": 0x9a };

function writeFile(path: string, data: Uint8Array | string): void {
  mkdirSync(dirname(path), { recursive: true });
  writeFileSync(path, data);
}

const t0 = performance.now();
rmSync(DATA_DIR, { recursive: true, force: true });
if (preview) rmSync(PREVIEW_DIR, { recursive: true, force: true });

let bytes = 0;
const sink: Sink = {
  write(path, data) {
    writeFile(join(DATA_DIR, path), data);
    bytes += data.length;
    return path;
  },
};

const disks = new GameDisks(ADF_DIR);
const start = extractStartSequence(disks, sink);
const level1 = extractLevel1(disks, sink);
const level2 = extractLevel2(disks, sink);
const level3 = extractLevel3(disks, sink);

const manifest: Manifest = {
  format: MANIFEST_FORMAT,
  sources: disks.sources,
  images: start.images,
  fonts: start.fonts,
  texts: start.texts,
  samples: start.samples,
  modules: start.modules,
  highscores: start.highscores,
  tables: { ...start.tables, ...level1.tables },
  memory: { ...level1.memory, ...level2.memory, ...level3.memory },
};
const json = JSON.stringify(manifest, null, 1) + "\n";
writeFile(join(DATA_DIR, "manifest.json"), json);

if (preview) {
  for (const p of start.previews) {
    const palette = (p.ehb ? expandEhb(p.palette) : p.palette).map(rgb12);
    writeFile(join(PREVIEW_DIR, `${p.key}.png`), encodeIndexedPng(p.width, p.height, p.indices, palette));
  }
  for (const p of [...level1.previews, ...level2.previews, ...level3.previews]) {
    writeFile(join(PREVIEW_DIR, `${p.key}.png`), encodeIndexedPng(p.width, p.height, p.indices, p.palette.map(rgb12)));
  }
  for (const [key, s] of Object.entries(start.samples)) {
    const data = new Uint8Array(readFileSync(join(DATA_DIR, s.file)));
    const period = SAMPLE_PERIODS[key] ?? 428;
    writeFile(join(PREVIEW_DIR, `${key}.wav`), encodeWav8(data, PAULA_CLOCK_PAL / period));
  }
  const lines = Object.entries(start.texts).map(([key, page]) =>
    `${key}\n` + page.map((l) => `  (${l.x},${l.y}) ${l.text}`).join("\n"));
  const scores = start.highscores.map((h) => `  ${h.name} ${h.score}`).join("\n");
  writeFile(join(PREVIEW_DIR, "texts_en.txt"), lines.join("\n") + "\n\nhighscores\n" + scores + "\n");
}

const count = (o: object): number => Object.keys(o).length;
console.log(
  `Assets erzeugt in ${Math.round(performance.now() - t0)} ms: ${count(manifest.images)} Bilder, ${count(manifest.fonts)} Schrift, ` +
  `${count(manifest.texts)} Textseiten, ${count(manifest.samples)} Samples, ${count(manifest.modules)} Module, ` +
  `${manifest.highscores.length} Highscores, ${count(manifest.memory)} Speicherblöcke → game/public/data/ (${(bytes / 1024).toFixed(0)} KB + manifest.json)` +
  (preview ? "; Vorschau in work/assets-preview/" : ""),
);
