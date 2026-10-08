// Abgleich zwischen dem Projektordner (NAS, ohne Git) und der Git-Arbeitskopie für Cloud-Sessions (E-041).
//   push: Projekt → Arbeitskopie. Kopiert alle Dateien außer den Ausnahmen unten; Emulator-Aufnahmen aus work/captures
//         kommen gepackt nach work/captures-gz/<datei>.gz (in der Arbeitskopie: node tools/repo/unpack-captures.ts).
//   pull: Arbeitskopie → Projekt. Übernimmt neue und geänderte Dateien; was im Projekt überschrieben wird, sichert es
//         vorher nach backup/<datum>_<uhrzeit>_repo-pull/. Löschen übernimmt es nicht, sondern listet nur auf.
// Git selbst (commit, push, pull) läuft getrennt in der Arbeitskopie.
// Aufruf aus dem Projekt: node tools/repo/sync.ts push|pull <arbeitskopie>
import { copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { dirname, join, relative, sep } from "node:path";
import { fileURLToPath } from "node:url";
import { gzipSync } from "node:zlib";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "../..");
const [mode, target] = process.argv.slice(2);
if ((mode !== "push" && mode !== "pull") || !target) {
  console.error("Aufruf: node tools/repo/sync.ts push|pull <arbeitskopie>");
  process.exit(1);
}

/** nicht abgleichen (Pfade relativ, mit /): erzeugt, lokal oder nur für einen Rechner */
const SKIP = [
  ".git", "game/node_modules", "tools/node_modules", "server", "backup", "work/debug", "work/captures",
  ".claude/settings.local.json",
];
const CAPTURES = "work/captures";
const PACKED = "work/captures-gz";

const rel = (p: string): string => relative(ROOT, p).split(sep).join("/");
const skipped = (r: string): boolean => SKIP.some((s) => r === s || r.startsWith(`${s}/`));

function* files(dir: string, base: string): Generator<string> {
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    const p = join(dir, e.name);
    const r = relative(base, p).split(sep).join("/");
    if (skipped(r)) continue;
    if (e.isDirectory()) yield* files(p, base);
    else if (e.isFile()) yield r;
  }
}

const same = (a: string, b: string): boolean => {
  if (!existsSync(b)) return false;
  const sa = statSync(a), sb = statSync(b);
  return sa.size === sb.size && readFileSync(a).equals(readFileSync(b));
};

const copy = (from: string, to: string): void => {
  mkdirSync(dirname(to), { recursive: true });
  copyFileSync(from, to);
};

let changed = 0;
if (mode === "push") {
  for (const r of files(ROOT, ROOT)) {
    const from = join(ROOT, r), to = join(target, r);
    if (same(from, to)) continue;
    copy(from, to);
    changed++;
  }
  // Aufnahmen gepackt; neu packen nur, wenn die Quelle jünger ist
  for (const f of readdirSync(join(ROOT, CAPTURES))) {
    const from = join(ROOT, CAPTURES, f), to = join(target, PACKED, `${f}.gz`);
    if (!statSync(from).isFile()) continue;
    if (existsSync(to) && statSync(to).mtimeMs >= statSync(from).mtimeMs) continue;
    mkdirSync(dirname(to), { recursive: true });
    writeFileSync(to, gzipSync(readFileSync(from), { level: 6 }));
    changed++;
  }
  console.log(`${changed} Dateien in die Arbeitskopie übernommen`);
} else {
  // Datum und Uhrzeit, damit mehrere Abgleiche am selben Tag einander nicht überschreiben
  const now = new Date();
  const pad = (n: number): string => String(n).padStart(2, "0");
  const stamp = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}_${pad(now.getHours())}${pad(now.getMinutes())}`;
  const backup = join(ROOT, "backup", `${stamp}_repo-pull`);
  for (const r of files(target, target)) {
    if (r.startsWith(`${PACKED}/`)) continue;
    const from = join(target, r), to = join(ROOT, r);
    if (same(from, to)) continue;
    if (existsSync(to)) copy(to, join(backup, r));
    copy(from, to);
    console.log(`  ${r}`);
    changed++;
  }
  const missing = [...files(ROOT, ROOT)].filter((r) => !existsSync(join(target, r)));
  console.log(`${changed} Dateien ins Projekt übernommen${changed ? ` (Sicherung: ${rel(backup)})` : ""}`);
  if (missing.length) console.log(`Nur im Projekt (in der Arbeitskopie gelöscht?):\n  ${missing.join("\n  ")}`);
}
