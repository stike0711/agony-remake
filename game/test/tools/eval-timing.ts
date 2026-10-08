// Abgleich des Zeitmodells für Teil 1b (ModelTiming) mit dem Zeitprofil: Der Nachbau folgt dem aufgenommenen Lauf
// (gemessene Strahlposition und Zeitlage), daneben läuft das Modell mit und sagt je Schritt die Uhrzeit voraus.
// Ausgabe je Schritt: mittlere Abweichung, Streuung und größter Fehler in Zeilen; dazu die Dauer des Objekt-Schritts
// getrennt danach, ob Messung und Modell einen Interrupt (I) oder den Bildwechsel (V) kreuzen. Große Fehler entstehen
// fast nur, wenn beide auf verschiedenen Seiten einer Unterbrechung landen.
// Aufruf aus game/: node test/tools/eval-timing.ts
import { Game, type Screen } from "../../src/core/game.ts";
import { InputFrame, JOY_FIRE } from "../../src/core/input.ts";
import { SEA } from "../../src/core/level/layout.ts";
import { type LoopTiming, ModelTiming, type Placement } from "../../src/core/level/timing.ts";
import { LevelScreen } from "../../src/core/screens/level.ts";
import { loadAssets } from "../load-assets.ts";
import { FRAME, hitTime, LINE, Profile } from "../load-profile.ts";
import { Trace } from "../load-trace.ts";
import { measuredTiming, measuredVpos } from "../measured-timing.ts";

const STEP_PCS = [0x153c, 0x29d2, 0x2e82, 0x302c, 0x316e, 0x3194, 0x342e, 0x348c];
const NAMES = ["Objekte", "Spielmechanik", "Palette", "Kollision", "Routinen", "Status", "Text", "Sounds"];
/** Beginn des Copper-Interrupts im Folgebild (gemessen 256/129–136) */
const IRQ_AT = FRAME + 256 * LINE + 132;

const profile = new Profile("level1_go");
// gemessene Zeitpunkte je Durchlauf (letzter Treffer je Haltepunkt), relativ zum Bild des Schleifenstarts
const loops: Map<number, number>[] = [];
const starts: number[] = [];
for (const h of profile.all) {
  if (h.pc === 0xad8) {
    loops.push(new Map());
    starts.push(Math.floor(hitTime(h) / FRAME) * FRAME);
  } else if (loops.length) loops[loops.length - 1]!.set(h.pc, hitTime(h));
}

const end: Screen = { enter: () => {}, tick: () => {} };
const level = new LevelScreen(SEA, { gameOver: () => end, levelDone: () => end, unported: () => end });
const game = new Game(loadAssets(), { lang: "en" }, level);
const e = level.engine;
e.vposSource = measuredVpos(profile, new Trace("level1_go"));
const real = measuredTiming(profile);
const model = new ModelTiming();
const pm: Placement = { at: 0, line: 0, h: 0 };
const errors: number[][] = NAMES.map(() => []);
const objDur: Record<string, number[]> = {};
let bankModel = 0;
let k = -1;
const crossing = (a: number, b: number): string =>
  (a < IRQ_AT && b >= IRQ_AT ? "I" : "") + (Math.floor(a / FRAME) !== Math.floor(b / FRAME) ? "V" : "") || "-";

const timing: LoopTiming = {
  begin: (en) => {
    real.begin(en);
    model.begin(en);
    k++;
  },
  place: (en, step, out) => {
    real.place(en, step, out);
    model.place(en, step, pm);
    const t = loops[k]?.get(STEP_PCS[step]!);
    if (step === 0) bankModel = model.t;
    if (t === undefined) return;
    const measured = t - starts[k]!;
    errors[step]!.push((model.t - measured) / LINE);
    if (step === 1) {
      const bank = loops[k]!.get(0x153c)! - starts[k]!;
      const key = `gemessen ${crossing(bank, measured)}, Modell ${crossing(bankModel, model.t)}`;
      (objDur[key] ??= []).push((model.t - bankModel - (measured - bank)) / LINE);
    }
  },
  part2: (en, out) => real.part2(en, out),
  part2End: (en, out) => real.part2End(en, out),
};
e.timing = timing;
const input = new InputFrame();
for (let f = 13112; f <= 14647; f++) {
  input.buttons = f === 13161 || f === 13162 ? JOY_FIRE : 0;
  game.tick(input);
}

const stats = (v: number[]): string => {
  const mean = v.reduce((a, b) => a + b, 0) / v.length;
  const rms = Math.sqrt(v.reduce((a, b) => a + b * b, 0) / v.length);
  const max = v.reduce((a, b) => Math.max(a, Math.abs(b)), 0);
  return `n ${String(v.length).padStart(3)}  Mittel ${mean.toFixed(2)}  rms ${rms.toFixed(2)}  max ${max.toFixed(1)} Zeilen`;
};
for (let s = 0; s < NAMES.length; s++) if (errors[s]!.length) console.log(`${NAMES[s]!.padEnd(14)} ${stats(errors[s]!)}`);
console.log("Dauer des Objekt-Schritts (Modell minus gemessen):");
for (const [key, v] of Object.entries(objDur)) console.log(`  ${key.padEnd(24)} ${stats(v)}`);
