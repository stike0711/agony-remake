// Eingaben der aufgenommenen Läufe von Level 1 (Emulator ab Schnappschuss snap_f13100_level1_enter, Wiki setup.md):
// Liste [Bild, Knöpfe], die Aktion bei Bild F wirkt ab Bild F + 1. Gemeinsam für level1.test.ts und die Werkzeuge in
// test/tools/ (Fehlersuche, Kalibrierung des Zeitmodells).

import { JOY_FIRE } from "../src/core/input.ts";

export type JoyRun = [number, number][];

/** Feuer bei „PRESS FIRE TO START“ in Bild 13161/13162, danach keine Eingabe (level1_go, level1_fire) */
export const FIRE_RUN: JoyRun = [[13160, JOY_FIRE], [13162, 0]];

/**
 * level1_shoot (Eingaben vom Planungs-Bot test/tools/plan-bot.ts): Feuer bei 13161/13162, ab 13170 Dauerfeuer, Eule hoch
 * und runter, ab und zu nach rechts/links, kurze Ausweichbewegungen. Abschüsse mit Punkten und Explosionen, ein Tod
 * (Bild 14311); Gegnerschüsse gibt es bis hier nicht. Ab Bild 14793 startet R_Transporteur.
 */
export const SHOOT_RUN: JoyRun = [[13160,16],[13162,0],[13169,17],[13194,16],[13224,18],[13249,16],[13269,24],
  [13284,18],[13298,25],[13312,18],[13314,16],[13334,20],[13349,17],[13389,16],[13414,17],[13439,16],[13469,18],[13494,16],
  [13514,24],[13529,18],[13559,16],[13579,20],[13594,17],[13612,26],[13626,17],[13634,16],[13659,17],[13672,26],[13686,16],
  [13714,18],[13739,16],[13759,24],[13774,18],[13804,16],[13824,20],[13839,17],[13879,16],[13904,17],[13929,16],[13959,18],
  [13984,16],[14004,24],[14019,18],[14049,16],[14069,20],[14084,17],[14114,26],[14128,16],[14149,17],[14174,16],[14204,18],
  [14229,16],[14249,24],[14264,18],[14294,16],[14314,20],[14329,17],[14369,16],[14394,17],[14419,16],[14449,18],[14474,16],
  [14494,24],[14509,18],[14539,16],[14542,22],[14556,16],[14559,20],[14574,17],[14584,18],[14598,17],[14614,16],[14639,17],
  [14664,16],[14694,18],[14719,16],[14739,24],[14754,18],[14784,16],[14790,0]];

/** Knöpfe in Bild `frame` */
export function buttonsAt(run: JoyRun, frame: number): number {
  let b = 0;
  for (const [f, v] of run) if (frame > f) b = v;
  return b;
}

/**
 * Läufe mit Zeitprofil für Werkzeuge: Eingaben und letztes Bild, bis zu dem der Nachbau dem Original mit gemessener
 * Zeitlage folgen kann
 */
export const RUNS: Record<string, { input: JoyRun; last: number }> = {
  level1_go: { input: FIRE_RUN, last: 14647 },
  level1_shoot: { input: SHOOT_RUN, last: 14792 },
};

/** Lauf aus der Kommandozeile (Standard level1_go) */
export function runOf(name: string | undefined): { name: string; input: JoyRun; last: number } {
  const n = name ?? "level1_go";
  const r = RUNS[n];
  if (!r) throw new Error(`Unbekannter Lauf ${n} (bekannt: ${Object.keys(RUNS).join(", ")})`);
  return { name: n, ...r };
}
