// Kalibrierung des Zeitmodells (E-034, timing.ts): Arbeit je Durchlauf der Hauptschleife (Copperliste, vorderes und
// hinteres Scrollen) und die Bus-Belegung je Rasterzeile des Bilds, in dem der Durchlauf beginnt, nach
// work/captures/<lauf>.work.json. Strahlposition und Lage von Teil 1b kommen dabei aus dem Zeitprofil, damit der
// Nachbau dem Original folgt. Auswertung mit tools/analysis/fit_loop_timing.py. Aufruf aus game/:
// node test/tools/collect-loop-work.ts [<lauf>]   (Läufe: test/runs.ts, Standard level1_go)
import { writeFileSync } from "node:fs";
import { Game, type Screen } from "../../src/core/game.ts";
import { InputFrame } from "../../src/core/input.ts";
import { SEA } from "../../src/core/level/layout.ts";
import { LevelScreen } from "../../src/core/screens/level.ts";
import { loadAssets } from "../load-assets.ts";
import { Profile } from "../load-profile.ts";
import { measuredTiming } from "../measured-timing.ts";
import { buttonsAt, runOf } from "../runs.ts";

const run = runOf(process.argv[2]);
const profile = new Profile(run.name);
const checks = profile.hits(0x147c);
const end: Screen = { enter: () => {}, tick: () => {} };
const level = new LevelScreen(SEA, { gameOver: () => end, unported: () => end });
const game = new Game(loadAssets(), { lang: "en" }, level);
const input = new InputFrame();
const loops: object[] = [];
let k = 0;
level.engine.timing = measuredTiming(profile);
level.engine.vposSource = (e) => {
  loops.push({ ...e.loopWork, k, bus: Array.from(e.video.busUsed), busEven: Array.from(e.video.busEven) });
  return (checks[k++]?.v ?? 0) & 0xff;
};
for (let f = 13112; f <= run.last; f++) {
  input.buttons = buttonsAt(run.input, f);
  game.tick(input);
  if (level.engine.unported) break;
}
writeFileSync(`../work/captures/${run.name}.work.json`, JSON.stringify({ loops }));
console.log(`${loops.length} Durchläufe`);
