// Planung einer Aufnahme mit Schießen und Ausweichen (Ablauf C): Grundmuster mit Dauerfeuer und Bewegung; stirbt die
// Eule im Nachbau, probiert der Bot kurz davor Ausweichbewegungen und nimmt die, mit der sie am längsten lebt.
// Ergebnis: Eingabeliste [Bild, Knöpfe] (Aktion bei Bild F wirkt ab Bild F + 1) als JSON auf stdout.
// Aufruf aus game/: node test/tools/plan-bot.ts <letztes Bild> [<Tode erlaubt>]
import { JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP } from "../../src/core/input.ts";
import { plan } from "./plan-shoot.ts";

const FIRST = 13112;
const last = Number(process.argv[2] ?? 14790);
const allowed = Number(process.argv[3] ?? 0);

/** Knöpfe je Bild (Index = Bild − FIRST); wirken wie die Liste: Wert bei Bild F gilt ab F + 1 */
const buttons = new Array<number>(last - FIRST + 2).fill(0);
// Feuer bei „PRESS FIRE TO START“ wie in level1_go (13161/13162), danach ab 13170 Dauerfeuer
buttons[13161 - FIRST] = JOY_FIRE;
buttons[13162 - FIRST] = JOY_FIRE;
// Grundmuster: Dauerfeuer, Eule abwechselnd hoch und runter, ab und zu nach rechts und zurück
const PATTERN: [number, number][] = [
  [25, JOY_UP], [30, 0], [25, JOY_DOWN], [20, 0], [15, JOY_RIGHT], [30, JOY_DOWN], [20, 0], [15, JOY_LEFT], [40, JOY_UP],
  [25, 0],
];
for (let f = 13170, k = 0; f <= last; k++) {
  const [n, dir] = PATTERN[k % PATTERN.length]!;
  for (let i = 0; i < n && f <= last; i++, f++) buttons[f - FIRST] = JOY_FIRE | dir;
}

function toList(b: number[]): [number, number][] {
  const list: [number, number][] = [];
  let cur = 0;
  for (let i = 0; i < b.length; i++) {
    if (b[i] !== cur) list.push([FIRST + i - 1, b[i]!]);
    cur = b[i]!;
  }
  return list;
}

const DIRS = [JOY_UP, JOY_DOWN, JOY_UP | JOY_LEFT, JOY_DOWN | JOY_LEFT, JOY_UP | JOY_RIGHT, JOY_DOWN | JOY_RIGHT, 0];
let r = plan(toList(buttons), last);
console.error(`Grundmuster: Tode ${r.deaths.join(", ")}, Halt ${r.halted ?? "-"} bei ${r.haltedAt}`);
let fixedUntil = 0;
for (let round = 0; round < 30; round++) {
  const deaths = r.deaths.filter((d) => d > fixedUntil);
  if (r.deaths.length <= allowed || !deaths.length) break;
  const d = deaths[0]!;
  let best: { b: number[]; r: typeof r; score: number } | null = null;
  for (const back of [10, 18, 28, 40, 55]) {
    for (const dir of DIRS) {
      const b = buttons.slice();
      for (let i = 0; i < 14; i++) {
        const f = d - back + i;
        if (f >= 13170) b[f - FIRST] = JOY_FIRE | dir;
      }
      const t = plan(toList(b), last);
      const next = t.deaths.find((x) => x > fixedUntil) ?? 1e9;
      // länger leben, bei Gleichstand weniger Tode
      const score = next * 10 - t.deaths.length;
      if (!best || score > best.score) best = { b, r: t, score };
      if (next === 1e9) break;
    }
    if (best && (best.r.deaths.find((x) => x > fixedUntil) ?? 1e9) > d + 60) break;
  }
  const nd = best!.r.deaths.find((x) => x > fixedUntil) ?? 1e9;
  console.error(`Tod ${d}: bester Versuch → nächster Tod ${nd === 1e9 ? "-" : nd}`);
  if (nd <= d) {
    fixedUntil = d;
    continue;
  }
  buttons.splice(0, buttons.length, ...best!.b);
  r = best!.r;
}
console.error(`Ergebnis: Tode ${r.deaths.join(", ") || "-"}, Punkte ${r.score.toString(16)}, Halt ${r.halted ?? "-"} bei ${r.haltedAt}, bis ${r.last}`);
console.log(JSON.stringify(toList(buttons)));
