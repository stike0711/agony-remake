// Fehlersuche im Lauf level1_shoot: für die angegebenen Bilder Kollisionsliste (Eule, Schuss) und lebende Gegner
// (AWO-Bänke: x, y, Energie, Status) im Nachbau (Zeitmodell) und in der Spur des Originals.
// Aufruf aus game/: node test/tools/debug-shoot.ts <von> <bis>
import { Game, type Screen } from "../../src/core/game.ts";
import { InputFrame } from "../../src/core/input.ts";
import { SEA } from "../../src/core/level/layout.ts";
import { LevelScreen } from "../../src/core/screens/level.ts";
import { loadAssets } from "../load-assets.ts";
import { SHOOT_RUN } from "../runs.ts";
import { Trace } from "../load-trace.ts";

const [from, to] = process.argv.slice(2).map(Number) as [number, number];
const input = SHOOT_RUN;
const trace = new Trace(process.env.TRACE ?? "level1_shoot");
const end: Screen = { enter: () => {}, tick: () => {} };
const level = new LevelScreen(SEA, { gameOver: () => end, unported: () => end });
const game = new Game(loadAssets(), { lang: "en" }, level);
const frame = new InputFrame();
const e = level.engine, L = SEA;
const hex = (v: number) => v.toString(16);
function dump(word: (a: number) => number): string {
  const col = [0, 1].map((k) => [0, 2, 4, 6].map((o) => (word(L.goodColList + 8 * k + o) << 16 >> 16)).join(",")).join(" | ");
  const aliens: string[] = [];
  for (let b = 0; b < 32; b++) {
    const bank = L.awoStruct + b * 196, num = word(bank);
    if (num === 0 || num === 0xffff) continue;
    for (let i = 0; i < num; i++) {
      const a = bank + 4 + 12 * i;
      aliens.push(`${b}.${i}:${word(a) << 16 >> 16},${word(a + 2) << 16 >> 16} e${word(a + 6)} s${hex(word(a + 8))}`);
    }
  }
  return `col ${col}\n    ${aliens.join("  ")}`;
}
for (let f = 13112; f <= to; f++) {
  let b = 0;
  for (const [g, v] of input) if (f > g) b = v;
  frame.buttons = b;
  game.tick(frame);
  if (f < from) continue;
  console.log(`Bild ${f} Nachbau  ${dump((a) => e.ram.word(a))}`);
  console.log(`Bild ${f} Original ${dump((a) => trace.word(f, a))}`);
}
