// Fehlersuche: Bilder des Nachbaus und des Originals (Hires-Aufnahme level1_go) für einzelne Bilder als PPM nach
// work/debug/: <bild>_port.ppm, <bild>_emu.ppm und <bild>_diff.ppm (abweichende Pixel rot, sonst abgedunkelt). Der
// Lauf folgt dem Original wie der Test (gemessene Strahlposition und Zeitlage von Teil 1b); mit --model rechnet er mit
// dem Zeitmodell. Mit --shoot nimmt es den Lauf level1_shoot (Eingaben aus test/runs.ts, immer Zeitmodell, falls
// kein Zeitprofil level1_shoot.profile.json vorliegt).
// Aufruf aus game/: node test/tools/debug-frames.ts [--model] [--shoot] <bild> [<bild> …]
import { mkdirSync, writeFileSync } from "node:fs";
import { Game, type Screen } from "../../src/core/game.ts";
import { InputFrame } from "../../src/core/input.ts";
import { SEA } from "../../src/core/level/layout.ts";
import { LevelScreen } from "../../src/core/screens/level.ts";
import { HiresCapture } from "../load-capture.ts";
import { loadAssets } from "../load-assets.ts";
import { FIRE_RUN, SHOOT_RUN } from "../runs.ts";
import { hasProfile, Profile } from "../load-profile.ts";
import { Trace } from "../load-trace.ts";
import { measuredTiming, measuredVpos } from "../measured-timing.ts";

const args = process.argv.slice(2);
const shoot = args.includes("--shoot");
const name = shoot ? "level1_shoot" : "level1_go";
const model = args.includes("--model") || !hasProfile(name);
const run = shoot ? SHOOT_RUN : FIRE_RUN;
const frames = new Set(args.filter((a) => !a.startsWith("--")).map(Number));
const last = Math.max(...frames);
const OUT = "../work/debug";
mkdirSync(OUT, { recursive: true });

const end: Screen = { enter: () => {}, tick: () => {} };
const level = new LevelScreen(SEA, { gameOver: () => end, unported: () => end });
const game = new Game(loadAssets(), { lang: "en" }, level);
const capture = new HiresCapture(name);
const input = new InputFrame();
if (!model) {
  const profile = new Profile(name);
  level.engine.vposSource = measuredVpos(profile, new Trace(name));
  level.engine.timing = measuredTiming(profile);
}

const ppm = (w: number, h: number, rgb: Uint8Array): Buffer =>
  Buffer.concat([Buffer.from(`P6\n${w} ${h}\n255\n`), Buffer.from(rgb)]);
const DX = 154;
for (let f = 13112; f <= last; f++) {
  input.buttons = 0;
  for (const [g, v] of run) if (f > g) input.buttons = v;
  game.tick(input);
  if (!frames.has(f) || !capture.load(f)) continue;
  const d = game.display;
  const w = capture.width, h = capture.height;
  const port = new Uint8Array(w * h * 3), emu = new Uint8Array(w * h * 3), diff = new Uint8Array(w * h * 3);
  let wrong = 0;
  for (let y = 0; y < h; y++) {
    const v = capture.y + y, row = v - 0x20;
    for (let x = 0; x < w; x++) {
      const tx = capture.x + x;
      const a = d.palette[row * 32 + d.pixels[row * d.width + tx - DX]!]!;
      const b = capture.color(tx, v);
      const i = (y * w + x) * 3;
      for (let c = 0; c < 3; c++) {
        port[i + c] = ((a >> (8 - 4 * c)) & 15) * 17;
        emu[i + c] = ((b >> (8 - 4 * c)) & 15) * 17;
        diff[i + c] = a === b ? emu[i + c]! >> 2 : c === 0 ? 255 : 0;
      }
      if (a !== b) wrong++;
    }
  }
  writeFileSync(`${OUT}/${f}_port.ppm`, ppm(w, h, port));
  writeFileSync(`${OUT}/${f}_emu.ppm`, ppm(w, h, emu));
  writeFileSync(`${OUT}/${f}_diff.ppm`, ppm(w, h, diff));
  console.log(`${f}: ${wrong} Pixel abweichend`);
}
