// Zeitlage wie im aufgenommenen Lauf: Damit folgt der Nachbau in Tests und Werkzeugen dem Original, und Spiellogik und
// Zeitmodell lassen sich getrennt prüfen (LevelEngine.vposSource und LevelEngine.timing).

import type { LevelEngine } from "../src/core/level/engine.ts";
import { SEA } from "../src/core/level/layout.ts";
import type { LoopTiming, Placement } from "../src/core/level/timing.ts";
import { measuredLoops, type Profile } from "./load-profile.ts";
import type { Trace } from "./load-trace.ts";

/**
 * Strahlposition bei SEARCH SHORT PHASE wie im aufgenommenen Lauf: Das Zeitprofil (Haltepunkt $147C) liefert das Bild
 * der k-ten Prüfung, die Spur desselben Laufs den dort gespeicherten Wert (Old_Vpos, untere 8 Bit der Zeile).
 */
export function measuredVpos(profile: Profile, trace: Trace): (e: LevelEngine) => number {
  const frames = profile.hits(0x147c).map((h) => h.frame);
  let k = 0;
  return () => trace.word(frames[k++]! + 1, SEA.d + SEA.vars.oldVpos);
}

/** Lage der Abschnitte der Hauptschleife wie im aufgenommenen Lauf (Zeitprofil), je Durchlauf der Reihe nach */
export function measuredTiming(profile: Profile): LoopTiming {
  const loops = measuredLoops(profile);
  let k = -1;
  const copy = (src: { at: number; line: number; h: number }, out: Placement): void => {
    out.at = src.at;
    out.line = src.line;
    out.h = src.h;
  };
  return {
    begin: () => void k++,
    place: (_e, step, out) => copy(loops[k]!.steps[step]!, out),
    part2: (_e, out) => copy(loops[k]!.part2, out),
    part2End: (_e, out) => copy(loops[k]!.part2End, out),
  };
}
