// Lädt die gebaute Fassung von vAmigaWeb (https://github.com/vAmigaWeb/vAmigaWeb.github.io, GPL-3.0)
// nach tools/emulator/vamigaweb/ – ohne den Dokumentationsordner doc/.
// Aufruf: node tools/emulator/fetch-vamigaweb.ts [git-ref]   (Standard: main)
// Der aufgelöste Commit wird in vamigaweb/VERSION.txt festgehalten, damit sich der Stand reproduzieren lässt.

import { mkdir, rm, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const REPO = "vAmigaWeb/vAmigaWeb.github.io";
const EXCLUDE = ["doc/"];
const PARALLEL = 6;

const ref = process.argv[2] ?? "main";
const here = dirname(fileURLToPath(import.meta.url));
const target = join(here, "vamigaweb");

async function getJson(url: string): Promise<any> {
  const res = await fetch(url, { headers: { Accept: "application/vnd.github+json" } });
  if (!res.ok) throw new Error(`${url}: HTTP ${res.status}`);
  return res.json();
}

const commit = await getJson(`https://api.github.com/repos/${REPO}/commits/${ref}`);
const sha: string = commit.sha;
const tree = await getJson(`https://api.github.com/repos/${REPO}/git/trees/${sha}?recursive=1`);
if (tree.truncated) throw new Error("Dateibaum unvollständig (truncated) – Download abgebrochen");

const files: { path: string; size: number }[] = tree.tree.filter(
  (e: any) => e.type === "blob" && !EXCLUDE.some((x) => e.path.startsWith(x)),
);
const total = files.reduce((n, f) => n + f.size, 0);
console.log(`vAmigaWeb ${sha.slice(0, 10)}: ${files.length} Dateien, ${(total / 1e6).toFixed(1)} MB`);

await rm(target, { recursive: true, force: true });

let next = 0;
async function worker(): Promise<void> {
  while (next < files.length) {
    const f = files[next++]!;
    const res = await fetch(`https://raw.githubusercontent.com/${REPO}/${sha}/${f.path}`);
    if (!res.ok) throw new Error(`${f.path}: HTTP ${res.status}`);
    const data = Buffer.from(await res.arrayBuffer());
    if (data.length !== f.size) throw new Error(`${f.path}: ${data.length} statt ${f.size} Bytes`);
    const dst = join(target, f.path);
    await mkdir(dirname(dst), { recursive: true });
    await writeFile(dst, data);
  }
}
await Promise.all(Array.from({ length: PARALLEL }, worker));

await writeFile(
  join(target, "VERSION.txt"),
  `${REPO}@${sha}\nCommit-Datum: ${commit.commit.committer.date}\nGeladen: ${new Date().toISOString()}\n` +
    `Ohne: ${EXCLUDE.join(", ")}\nLizenz: GPL-3.0 (https://github.com/vAmigaWeb/vAmigaWeb)\n`,
);
console.log(`fertig → ${target}`);
