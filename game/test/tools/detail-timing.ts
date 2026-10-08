// Zeitmodell gegen Messung je Durchlauf im Detail: Der Nachbau folgt dem aufgenommenen Lauf (gemessene Zeitlage), das
// Modell läuft mit. Ausgabe je Durchlauf im Bereich: Schleifenstart, SEARCH SHORT PHASE und je Schritt von Teil 1b die
// Uhrzeit von Modell und Messung (Bild/Zeile ab dem Startbild), Teil 2 und das Ende.
// Aufruf aus game/: node test/tools/detail-timing.ts <lauf> <von Bild> <bis Bild>
import { Game, type Screen } from "../../src/core/game.ts";
import { InputFrame } from "../../src/core/input.ts";
import { SEA } from "../../src/core/level/layout.ts";
import { type LoopTiming, ModelTiming, type Placement, shortPhaseTime } from "../../src/core/level/timing.ts";
import { LevelScreen } from "../../src/core/screens/level.ts";
import { loadAssets } from "../load-assets.ts";
import { FRAME, hitTime, LINE, Profile } from "../load-profile.ts";
import { Trace } from "../load-trace.ts";
import { measuredTiming, measuredVpos } from "../measured-timing.ts";
import { buttonsAt, runOf } from "../runs.ts";

const run = runOf(process.argv[2]);
const from = Number(process.argv[3] ?? 0);
const to = Number(process.argv[4] ?? run.last);
const STEP_PCS = [0x153c, 0x29d2, 0x2e82, 0x302c, 0x316e, 0x3194, 0x342e, 0x348c];
const NAMES = ["obj", "play", "pal", "col", "rout", "stat", "text", "snd"];

const profile = new Profile(run.name);
const loops: Map<number, number>[] = [];
const starts: number[] = [];
for (const h of profile.all) {
  if (h.pc === 0xad8) {
    loops.push(new Map());
    starts.push(hitTime(h));
  } else if (loops.length) loops[loops.length - 1]!.set(h.pc, hitTime(h));
}
const end: Screen = { enter: () => {}, tick: () => {} };
const level = new LevelScreen(SEA, { gameOver: () => end, unported: () => end });
const game = new Game(loadAssets(), { lang: "en" }, level);
const e = level.engine;
e.vposSource = measuredVpos(profile, new Trace(run.name));
const real = measuredTiming(profile);
const model = new ModelTiming();
const pm: Placement = { at: 0, line: 0, h: 0 };
let k = -1;
let f = 13112;
let base = 0;
let row = "";
const fmt = (t: number | undefined): string => {
  if (t === undefined) return "    -   ";
  const fr = Math.floor(t / FRAME);
  return `${fr}/${String(Math.floor((t - fr * FRAME) / LINE)).padStart(3)}`.padStart(8);
};
const timing: LoopTiming = {
  begin: (en) => {
    real.begin(en);
    model.begin(en);
    k++;
    base = Math.floor(starts[k]! / FRAME) * FRAME;
    const L = loops[k]!;
    row = `B${f} #${k} start M${fmt(en.loopWork.loopStart)} G${fmt(starts[k]! - base)} sp M${fmt(shortPhaseTime(en))} G${fmt(L.has(0x147c) ? L.get(0x147c)! - base : undefined)}`;
  },
  place: (en, step, out) => {
    real.place(en, step, out);
    model.place(en, step, pm);
    const t = loops[k]?.get(STEP_PCS[step]!);
    row += ` | ${NAMES[step]} M${fmt(model.t)} G${fmt(t === undefined ? undefined : t - base)}`;
  },
  part2: (en, out) => {
    real.part2(en, out);
    model.part2(en, pm);
    const L = loops[k]!;
    const t = L.get(0x3800) ?? L.get(0x3514);
    row += ` | p2 M${fmt(model.t)} G${fmt(t === undefined ? undefined : t - base)}`;
  },
  part2End: (en, out) => {
    real.part2End(en, out);
    model.part2End(en, pm);
    row += ` | end M${fmt(model.t)} G${fmt(starts[k + 1] === undefined ? undefined : starts[k + 1]! - base)}`;
    if (f >= from && f <= to) console.log(row);
  },
};
e.timing = timing;
const input = new InputFrame();
for (; f <= Math.min(to + 4, run.last); f++) {
  input.buttons = buttonsAt(run.input, f);
  game.tick(input);
}
