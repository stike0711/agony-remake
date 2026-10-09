// Erkundung (Cloud-Aufträge, kein Vergleich mit dem Original): Level 1 mit Dauerfeuer und dem Bewegungsmuster des
// Planungs-Bots, Leben jedes Bild aufgefüllt (wie die Aufnahme level1_music_timing), bis die Engine anhält oder das
// Level endet. Meldet Tode, Starts von Gegner-Routinen, Bonusse, den Beginn des Levelendes (Quit_Delay) und den Grund
// des Anhaltens.
// Mit --forest läuft Level 2, mit --marshes Level 3 (Bild 13112 = erstes Bild des Levels wie bei Level 1, Startzustand wie aus dem Menü);
// mit --ppm <bild>,<bild>,… schreibt es diese Bilder als PPM nach work/debug/<level>_<bild>.ppm.
// Aufruf aus game/: node test/tools/explore-level.ts [--forest|--marshes] [--ppm <bilder>] [<letztes Bild>]
import { mkdirSync, writeFileSync } from "node:fs";
import { Game, type Screen } from "../../src/core/game.ts";
import { InputFrame, JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP } from "../../src/core/input.ts";
import { FOREST, MARSHES, SEA, SHARED } from "../../src/core/level/layout.ts";
import { LevelScreen } from "../../src/core/screens/level.ts";
import { loadAssets } from "../load-assets.ts";

const args = process.argv.slice(2);
const L = args.includes("--forest") ? FOREST : args.includes("--marshes") ? MARSHES : SEA;
const ppmAt = args.indexOf("--ppm");
const ppmFrames = new Set(ppmAt >= 0 ? args[ppmAt + 1]!.split(",").map(Number) : []);
const last = Number(args.filter((a, i) => !a.startsWith("--") && i !== ppmAt + 1)[0] ?? 26000);
let left = "";
const end: Screen = { enter: () => {}, tick: () => {} };
const level = new LevelScreen(L, {
  gameOver: () => { left = "Spielende"; return end; },
  levelDone: () => { left = "Levelende"; return end; },
  unported: () => { left = `nicht übertragen: ${String(level.engine.unported)}`; return end; },
});
const game = new Game(loadAssets(), { lang: "en" }, level);
const input = new InputFrame();
const PATTERN: [number, number][] = [
  [25, JOY_UP], [30, 0], [25, JOY_DOWN], [20, 0], [15, JOY_RIGHT], [30, JOY_DOWN], [20, 0], [15, JOY_LEFT], [40, JOY_UP],
  [25, 0],
];
const V = L.vars;
let k = 0, n = 0, die = 0, bonus = 0, quit = 0, routs = "";
for (let f = 13112; f <= last && !left; f++) {
  if (f === 13161 || f === 13162) input.buttons = JOY_FIRE;
  else if (f < 13170) input.buttons = 0;
  else {
    if (n === 0) { [n] = PATTERN[k % PATTERN.length]!; k++; }
    input.buttons = JOY_FIRE | PATTERN[(k - 1) % PATTERN.length]![1];
    n--;
  }
  game.tick(input);
  const e = level.engine;
  if (e.result || e.unported) { left ||= e.unported ? `nicht übertragen: ${e.unported}` : `Level verlassen (${String(e.result)})`; console.log(`${f}: ${left}`); break; }
  if (e.ram.word(SHARED.life) < 3) e.ram.setWord(SHARED.life, 7);
  const d = e.w(V.die);
  if (d && !die) console.log(`${f}: Tod`);
  die = d;
  const q = e.w(V.quitDelay);
  if (q && !quit) console.log(`${f}: Quit_Delay ${q} (Levelende beginnt)`);
  quit = q;
  const b = e.w(V.bonusMode);
  if (b !== bonus) console.log(`${f}: Bonus_Mode ${b} (Bonus_Num ${e.w(V.bonusNum)})`);
  bonus = b;
  let r = "";
  for (let i = 0; i < 32; i++) { const c = e.ram.long(L.routStruct + 28 * i); if (c !== 0xffffffff) r += c.toString(16) + " "; }
  if (r !== routs) console.log(`${f}: Routinen ${r || "-"} Level_X ${e.w(V.levelX)}`);
  routs = r;
  if (ppmFrames.has(f)) writePpm(f);
  if (f % 1000 === 0) console.log(`${f}: Level_X ${e.w(V.levelX)} Score ${e.ram.long(SHARED.score).toString(16)}`);
}
if (left) console.log(`Ende: ${left}`);

/** Spielfeld und Statuszeile (Hires-Bildpuffer der Anzeige) als PPM */
function writePpm(f: number): void {
  const d = game.display;
  const { x, y, width, height } = d.view;
  const w = width * 2, rgb = new Uint8Array(w * height * 3);
  for (let row = 0; row < height; row++) {
    for (let col = 0; col < w; col++) {
      const c = d.palette[(y + row) * 32 + d.pixels[(y + row) * d.width + x * 2 + col]!]!;
      for (let k = 0; k < 3; k++) rgb[(row * w + col) * 3 + k] = ((c >> (8 - 4 * k)) & 15) * 17;
    }
  }
  mkdirSync("../work/debug", { recursive: true });
  writeFileSync(`../work/debug/${L.file}_${f}.ppm`, Buffer.concat([Buffer.from(`P6\n${w} ${height}\n255\n`), Buffer.from(rgb)]));
}
