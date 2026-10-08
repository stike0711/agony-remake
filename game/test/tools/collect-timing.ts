// Kalibrierung des Zeitmodells für Copper-Interrupt, Teil 1b und Teil 2 (timing.ts): Der Nachbau folgt dem
// aufgenommenen Lauf (gemessene Strahlposition und Zeitlage) und schreibt nach work/captures/<lauf>.timing.json:
//   irq   je Bild mit Copper-Interrupt: [Bild, Zeile der Copperliste, Teile (IRQ) …]
//   loops je Durchlauf: Takt von Teil 1a, Arbeit je Schritt von Teil 1b ([WORK …, Blitter-Takte, Blits])
//   bus   je Bild die belegten Buszyklen je Zeile (Video.busUsed, für den Blitter) und busEven (gerade Zyklen, für
//         den Prozessor)
// Auswertung mit tools/analysis/fit_part1b_timing.py und fit_irq_timing.py.
// Aufruf aus game/: node test/tools/collect-timing.ts [<lauf>]   (Läufe: test/runs.ts, Standard level1_go)
import { writeFileSync } from "node:fs";
import { Game, type Screen } from "../../src/core/game.ts";
import { InputFrame } from "../../src/core/input.ts";
import { SEA } from "../../src/core/level/layout.ts";
import type { LoopTiming } from "../../src/core/level/timing.ts";
import { STEPS } from "../../src/core/level/timing.ts";
import { LevelScreen } from "../../src/core/screens/level.ts";
import { loadAssets } from "../load-assets.ts";
import { Profile } from "../load-profile.ts";
import { Trace } from "../load-trace.ts";
import { measuredTiming, measuredVpos } from "../measured-timing.ts";
import { buttonsAt, runOf } from "../runs.ts";

const run = runOf(process.argv[2]);
const profile = new Profile(run.name);
const end: Screen = { enter: () => {}, tick: () => {} };
const level = new LevelScreen(SEA, { gameOver: () => end, unported: () => end });
const game = new Game(loadAssets(), { lang: "en" }, level);
const e = level.engine;
e.vposSource = measuredVpos(profile, new Trace(run.name));
const real = measuredTiming(profile);
let f = 13112;
interface LoopRecord {
  tick: number;
  frame: number;
  work: number[][];
}
const loops: LoopRecord[] = [];
let cur: LoopRecord | null = null;
let cycles = 0;
let blits = 0;
/** Arbeit des zuletzt ausgeführten Schritts festhalten (die Engine zählt je Schritt neu) */
const record = (): void => {
  const bl = e.blitter;
  cur!.work.push([...e.stepWork, bl.cycles - cycles, bl.blits - blits]);
  cycles = bl.cycles;
  blits = bl.blits;
};
const timing: LoopTiming = {
  begin: (en) => {
    real.begin(en);
    cur = { tick: f, frame: f, work: [] };
    loops.push(cur);
    cycles = e.blitter.cycles;
    blits = e.blitter.blits;
  },
  place: (en, step, out) => {
    // vor Schritt 0 die Arbeit des Zurücksetzens (Objekte) ist noch nicht gezählt; ab Schritt 1 die des vorigen
    if (step > 0) record();
    real.place(en, step, out);
  },
  part2: (en, out) => {
    if (cur && cur.work.length < STEPS) record();
    real.part2(en, out);
  },
  part2End: (en, out) => real.part2End(en, out),
};
e.timing = timing;
const input = new InputFrame();
const irq: number[][] = [];
const bus: Record<number, number[]> = {};
const busEven: Record<number, number[]> = {};
for (; f <= run.last; f++) {
  input.buttons = buttonsAt(run.input, f);
  game.tick(input);
  if (e.video.copperIrqLine >= 0) irq.push([f, e.video.copperIrqLine, ...e.irqWork]);
  bus[f] = Array.from(e.video.busUsed);
  busEven[f] = Array.from(e.video.busEven);
  if (e.unported) break;
}
writeFileSync(`../work/captures/${run.name}.timing.json`, JSON.stringify({ irq, loops, bus, busEven }));
console.log(`${irq.length} Interrupts, ${loops.length} Durchläufe`);
