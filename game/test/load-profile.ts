// Zeitprofile aus dem Referenz-Emulator (Haltepunkte im Level-Code, Wiki setup.md „Zeitprofil“): je Treffer
// Emulator-Bild (wie AG.frameNr() während des Bilds, also Spurzeile − 1), Programmzähler und Strahlposition.
// Liegen in work/captures/<name>.profile.json; fehlen sie, überspringen die Tests, die sie brauchen.

import { existsSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const CAPTURES = join(dirname(fileURLToPath(import.meta.url)), "../../work/captures");

export function hasProfile(name: string): boolean {
  return existsSync(join(CAPTURES, `${name}.profile.json`));
}

/** Farbtakte je Zeile und Zeilen je Bild (PAL) */
export const LINE = 227;
export const LINES = 313;
export const FRAME = LINE * LINES;

export interface Hit {
  frame: number;
  pc: number;
  /** Rasterzeile 0–312 */
  v: number;
  /** Farbtakt in der Zeile */
  h: number;
}

export class Profile {
  readonly all: Hit[];

  /**
   * Treffer in Aufnahmereihenfolge, bereinigt (W-016): Bei Farbtakt 0 und 1 meldet vAmiga noch die vorige Zeile, und
   * an der Bildgrenze kann die Bildnummer noch die alte sein (dann läge der Treffer vor seinem Vorgänger).
   */
  constructor(name: string) {
    const data = JSON.parse(readFileSync(join(CAPTURES, `${name}.profile.json`), "utf8")) as { hits: number[][] };
    let prev = -1;
    this.all = data.hits.map(([frame, pc, v, h]) => {
      let f = frame!, line = v!;
      if (h! <= 1) line++;
      if (line >= LINES) {
        line -= LINES;
        f++;
      }
      let t = (f * LINES + line) * LINE + h!;
      if (t < prev) {
        f++;
        t += FRAME;
      }
      prev = t;
      return { frame: f, pc: pc!, v: line, h: h! };
    });
  }

  hits(pc: number): Hit[] {
    return this.all.filter((h) => h.pc === pc);
  }
}


/** Zeitpunkt eines Treffers in Farbtakten seit Bild 0 */
export function hitTime(h: Hit): number {
  return (h.frame * LINES + h.v) * LINE + h.h;
}

/**
 * Haltepunkte, die die Lage der Schritte von Teil 1b bestimmen (Reihenfolge wie STEP in timing.ts); je Schritt der
 * erste vorhandene, sonst gilt der nächste Schritt: Objekte (ALIEN BANK CTRL), Startliste und Bahnen, Paletten (Kopie
 * in die Copperliste), Kollisionstest, Routinen, Statuszeile, Zeichen eines neuen Statustexts, Sounds
 */
const STEP_PCS: readonly (readonly number[])[] = [[0x153c], [0x29d2], [0x2e82], [0x302c], [0x316e], [0x3194], [0x342e], [0x348c]];
/** Teil 2: Aufbau der Sprite-Liste der Gegnerschüsse, sonst Beginn */
const PART2_PCS = [0x3800, 0x3514];

/** Lage eines Abschnitts wie Placement in timing.ts: at = 2 · Bilder seit dem Startbild + Seite des Interrupts */
export interface MeasuredPlacement {
  at: number;
  line: number;
  h: number;
}

/** Ein Durchlauf der Hauptschleife, wie im Emulator gemessen */
export interface MeasuredLoop {
  /** je Schritt von Teil 1b */
  steps: MeasuredPlacement[];
  /** Teil 2: Aufbau der Sprite-Liste der Gegnerschüsse (sonst Beginn) */
  part2: MeasuredPlacement;
  /** Ende von Teil 2 = Beginn des nächsten Durchlaufs, falls er nicht auf den Interrupt warten musste */
  part2End: MeasuredPlacement;
}

/**
 * Alle Durchläufe der Hauptschleife im Zeitprofil (ab Haltepunkt $AD8). Fehlt der Haltepunkt eines Schritts
 * (übersprungener Teil), gilt der nächste vorhandene. Die Lage zählt ab dem Bild des Schleifenstarts; die Seite
 * entscheidet der Copper-Interrupt ($43C6) des jeweiligen Bilds.
 */
export function measuredLoops(profile: Profile): MeasuredLoop[] {
  const hits = profile.all;
  /** Beginn des Copper-Interrupts je Bild */
  const irqs = new Map<number, number>();
  for (const h of hits) if (h.pc === 0x43c6 && !irqs.has(h.frame)) irqs.set(h.frame, hitTime(h));
  const starts: number[] = [];
  const passes: Map<number, number>[] = [];
  let first: Map<number, number> | null = null;
  for (const h of hits) {
    if (h.pc === 0xad8) {
      first = new Map();
      passes.push(first);
      starts.push(hitTime(h));
    } else if (first && h.pc !== 0x43c6) {
      // je Haltepunkt der letzte Treffer: Kommt genau dort ein Interrupt, meldet vAmiga den Haltepunkt davor und danach
      first.set(h.pc, hitTime(h));
    }
  }
  const place = (s: number, t: number): MeasuredPlacement => {
    if (!Number.isFinite(t)) return { at: 1 << 20, line: 0, h: 0 };
    const frame = Math.floor(t / FRAME);
    const irq = irqs.get(frame);
    const side = irq !== undefined && t > irq ? 1 : 0;
    const rest = t - frame * FRAME;
    return { at: 2 * (frame - Math.floor(s / FRAME)) + side, line: Math.floor(rest / LINE), h: rest % LINE };
  };
  return passes.map((f, k) => {
    const s = starts[k]!;
    const pick = (pcs: readonly number[]): number | undefined => pcs.map((pc) => f.get(pc)).find((t) => t !== undefined);
    const times: number[] = new Array(STEP_PCS.length);
    let next = Infinity;
    for (let i = STEP_PCS.length - 1; i >= 0; i--) times[i] = next = pick(STEP_PCS[i]!) ?? next;
    return {
      steps: times.map((t) => place(s, t)),
      part2: place(s, pick(PART2_PCS) ?? Infinity),
      part2End: place(s, starts[k + 1] ?? Infinity),
    };
  });
}
