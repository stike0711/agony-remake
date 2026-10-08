// Planung einer Aufnahme mit Schießen und Ausweichen (Ablauf C): spielt eine Eingabefolge im Nachbau (Zeitmodell) ab
// und meldet Tode der Eule, Punkte, Abschüsse und wo die Engine anhält. Eingaben: Liste [Bild, Knöpfe] wie in
// level1.test.ts (Aktion bei Bild F wirkt ab Bild F + 1).
// Aufruf aus game/: node test/tools/plan-shoot.ts <eingaben.json> [<letztes Bild>]
import { readFileSync } from "node:fs";
import { Game, type Screen } from "../../src/core/game.ts";
import { InputFrame } from "../../src/core/input.ts";
import { SEA, SHARED } from "../../src/core/level/layout.ts";
import { LevelScreen } from "../../src/core/screens/level.ts";
import { loadAssets } from "../load-assets.ts";

export interface PlanResult {
  deaths: number[];
  halted: string | null;
  haltedAt: number;
  last: number;
  score: number;
  log: string[];
}

export function plan(input: [number, number][], lastFrame: number, verbose = false): PlanResult {
  const end: Screen = { enter: () => {}, tick: () => {} };
  const level = new LevelScreen(SEA, { gameOver: () => end, levelDone: () => end, unported: () => end });
  const game = new Game(loadAssets(), { lang: "en" }, level);
  const frame = new InputFrame();
  const e = level.engine;
  const V = SEA.vars;
  const r: PlanResult = { deaths: [], halted: null, haltedAt: -1, last: lastFrame, score: 0, log: [] };
  let oldDie = 0, oldScore = 0;
  for (let f = 13112; f <= lastFrame; f++) {
    let b = 0;
    for (const [g, v] of input) if (f > g) b = v;
    frame.buttons = b;
    try {
      game.tick(frame);
    } catch (err) {
      r.halted = (err as Error).message;
      r.haltedAt = f;
      r.last = f - 1;
      break;
    }
    if (e.unported) {
      r.halted = e.unported;
      r.haltedAt = f;
      r.last = f - 1;
      break;
    }
    const die = e.w(V.die);
    if (die !== 0 && oldDie === 0) r.deaths.push(f);
    oldDie = die;
    const score = e.ram.long(SHARED.score);
    if (score !== oldScore && verbose) r.log.push(`${f}: Score ${score.toString(16)} Level_X ${e.w(V.levelX)}`);
    oldScore = score;
    if (e.result) {
      r.last = f;
      break;
    }
  }
  r.score = oldScore;
  return r;
}

if (process.argv[1]?.endsWith("plan-shoot.ts")) {
  const input = JSON.parse(readFileSync(process.argv[2]!, "utf8")) as [number, number][];
  const last = Number(process.argv[3] ?? 16000);
  const r = plan(input, last, true);
  console.log(r.log.join("\n"));
  console.log(JSON.stringify({ deaths: r.deaths, halted: r.halted, haltedAt: r.haltedAt, last: r.last, score: r.score.toString(16) }));
}
