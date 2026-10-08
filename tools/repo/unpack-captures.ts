// Packt die Emulator-Aufnahmen der Git-Arbeitskopie aus (work/captures-gz/*.gz → work/captures/), damit die Tests sie
// finden (E-041). Bereits ausgepackte, gleich große Dateien bleiben stehen.
// Aufruf aus dem Projekt bzw. der Arbeitskopie: node tools/repo/unpack-captures.ts
import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { gunzipSync } from "node:zlib";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "../..");
const PACKED = join(ROOT, "work/captures-gz");
const OUT = join(ROOT, "work/captures");
mkdirSync(OUT, { recursive: true });
let n = 0;
for (const f of existsSync(PACKED) ? readdirSync(PACKED) : []) {
  if (!f.endsWith(".gz")) continue;
  const to = join(OUT, f.slice(0, -3));
  if (existsSync(to)) continue;
  writeFileSync(to, gunzipSync(readFileSync(join(PACKED, f))));
  n++;
}
console.log(`${n} Aufnahmen ausgepackt nach work/captures/`);
