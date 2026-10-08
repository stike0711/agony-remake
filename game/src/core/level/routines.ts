// Objekt-Routinen der Level-Module (Ag_Game_L*.s, Abschnitt „ROUTINES“): Gegner mit eigener Steuerung, gestartet
// über START_C in der Startliste. Jede laufende Routine belegt einen Eintrag der Rout_Struct (28 Byte: Code-Zeiger,
// −1 = frei; Parameter-Zeiger in die Startliste; AWO-Bank; 16 Byte Variablen) und eine eigene AWO-Bank. Der
// Code-Zeiger ist die Adresse der Routine im Level-Abbild; die Engine ordnet ihn über LevelLayout.routines der
// Umsetzung hier zu. Was im Code des Levels fest steht (Paletten, Animationen, Objektnummern), steht dort mit.
// Stand: R_Sol_Crache und R_Araignee (Level 1); unbekannte Routinen halten die Engine an (LevelEngine.unported).

import type { LevelEngine } from "./engine.ts";
import { WORK } from "./timing.ts";

/** Pflanze am Boden, spuckt Feuerbälle (R_Sol_Crache) */
export interface SolCracheDef {
  kind: "solCrache";
  /** R_SC_Pal (6 Zeilen-Schalter, 7 Farben), R_Sol_Crache_Shape (11 Objektnummern), Sin_Table2 (Bytes) */
  pal: number;
  shape: number;
  sin: number;
  /** Obj_Sol_Crache_1, Obj_Fire_Ball */
  obj: number;
  fireBall: number;
}

/** Spinne, die an ihrem Faden auf und ab läuft (R_Araignee) */
export interface AraigneeDef {
  kind: "araignee";
  /** R_A_Pal, Obj_Araignee */
  pal: number;
  obj: number;
}

export type RoutineDef = SolCracheDef | AraigneeDef;

const ROUTS = 32;
const ROUT_LEN = 28;
const ROUT_PARAM_PTR = 4;
const ROUT_AWO_PTR = 8;
const ROUT_VARIABLES = 12;
const AWO_LEN = 12;
const AWO_X = 0;
const AWO_Y = 2;
const AWO_OBJ_OFF = 4;
const AWO_ENERGY = 6;
const AWO_STATUS = 8;

const s16 = (v: number): number => (v << 16) >> 16;

/** ROUTINE MANAGER ($316E): alle laufenden Routinen der Reihe nach aufrufen (a0 = Eintrag der Rout_Struct) */
export function routineManager(e: LevelEngine): void {
  const { V, L, ram } = e;
  if (e.w(V.curentSpell) === 2) return;
  for (let i = 0, a0 = L.routStruct; i < ROUTS; i++, a0 += ROUT_LEN) {
    const code = ram.long(a0);
    if (code === 0xffffffff) continue;
    const def = L.routines.get(code);
    if (!def) {
      e.halt(`Gegner mit eigener Routine $${code.toString(16).toUpperCase()}`);
      return;
    }
    e.stepWork[WORK.routines]!++;
    if (def.kind === "solCrache") solCrache(e, a0, def);
    else araignee(e, a0, def);
  }
}

/** Gemeinsamer Anfang (MODE 0): eigene Farben anmelden, ein Gegner in der Bank */
function open(e: LevelEngine, pal: number): void {
  const { V } = e;
  e.setL(V.routPalPtr, pal);
  e.setB(V.refreshPal + 1, 0xff);
  e.setW(V.routModPalCounter, e.w(V.routModPalCounter) + 1);
}

/** CLOSE: Eintrag und Bank frei, Farben abmelden; die letzte Routine stellt die Palette des Levels wieder her */
function close(e: LevelEngine, a0: number, bank: number): void {
  const { V, ram } = e;
  ram.setLong(a0, 0xffffffff);
  ram.setWord(bank, 0xffff);
  const n = (e.w(V.routModPalCounter) - 1) & 0xffff;
  e.setW(V.routModPalCounter, n);
  if (n === 0) {
    e.setL(V.routPalPtr, 0xffffffff);
    e.setB(V.refreshPal + 1, 0xff);
  }
}

/**
 * R_Sol_Crache: wandert mit dem Boden nach links (2 Pixel je Durchlauf, Ende bei x 200), Animation jedes zweite Mal.
 * Alle P_SC_Fire_Rate Durchläufe spuckt sie einen Feuerball (zweiter Gegner der Bank, Energie 2), der 38 Durchläufe
 * lang einem Bogen aus Sin_Table2 folgt. Variablen: +0 Modus (0 Start, 1 Pflanze, 2 mit Feuerball), +2 Animationsschritt,
 * +4 Animationstakt, +6 Schusstakt, +8 Schritt des Feuerballs. Parameter: Feuerrate.
 */
function solCrache(e: LevelEngine, a0: number, d: SolCracheDef): void {
  const { ram } = e;
  const a1 = ram.long(a0 + ROUT_PARAM_PTR);
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  const mode = ram.word(a3);
  ram.setLong(bank, 0x00010000);
  if (mode === 0) {
    open(e, d.pal);
    ram.setWord(a2 + AWO_X, 256 + 320);
    ram.setWord(a2 + AWO_Y, 256 + 190);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 8);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3, 1);
    ram.setWord(a3 + 6, 0);
    return;
  }
  const x = (ram.word(a2 + AWO_X) - 2) & 0xffff;
  ram.setWord(a2 + AWO_X, x);
  if (s16(x) <= 200) {
    close(e, a0, bank);
    return;
  }
  const delay = ram.word(a3 + 4) ^ 1;
  ram.setWord(a3 + 4, delay);
  if (delay !== 0) {
    const step = ram.word(a3 + 2);
    ram.setWord(a3 + 2, (step + 2) & 0xffff);
    ram.setWord(a2 + AWO_OBJ_OFF, ram.word(d.shape + s16(step)));
    if (step === 2 * 10) ram.setWord(a3 + 2, 0);
  }
  const launch = (ram.word(a3 + 6) + 1) & 0xffff;
  ram.setWord(a3 + 6, launch);
  if (launch === ram.word(a1) && (ram.byte(a2 + AWO_STATUS) & 0xf) === 0) {
    // Feuerball starten; seine Position setzt erst der nächste Durchlauf
    ram.setWord(a3 + 6, 0);
    ram.setWord(a3, 2);
    ram.setWord(a3 + 8, 0);
    const ball = a2 + AWO_LEN;
    ram.setWord(ball + AWO_OBJ_OFF, d.fireBall);
    ram.setWord(ball + AWO_ENERGY, 2);
    ram.setLong(ball + AWO_STATUS, 0);
    return;
  }
  if (mode !== 2) return;
  ram.setWord(bank, 2);
  const step = ram.word(a3 + 8);
  ram.setWord(a3 + 8, (step + 1) & 0xffff);
  if (step === 38) {
    ram.setWord(a3, 1);
    return;
  }
  // y = 256 + (150 − Sinus) als Byte (sub.b), x = Pflanze − 8 · Schritt − 16
  const ball = a2 + AWO_LEN;
  ram.setWord(ball + AWO_Y, ((0x96 - ram.byte(d.sin + s16(step))) & 0xff) + 0x100);
  ram.setWord(ball + AWO_X, (x - 8 * step - 16) & 0xffff);
}

/**
 * R_Araignee: kommt von rechts (x 256 + 340) und läuft mit dem Boden nach links, dabei an ihrem Faden zwischen y 150
 * und 340 auf und ab. Variablen: +0 Modus, +4 Richtung (0 = abwärts, sonst aufwärts). Parameter: Start-y, Schritt.
 */
function araignee(e: LevelEngine, a0: number, d: AraigneeDef): void {
  const { ram } = e;
  const a1 = ram.long(a0 + ROUT_PARAM_PTR);
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  ram.setLong(bank, 0x00010000);
  if (ram.word(a3) === 0) {
    open(e, d.pal);
    ram.setWord(a2 + AWO_X, 256 + 340);
    ram.setWord(a2 + AWO_Y, ram.word(a1));
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 10);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3, 1);
    ram.setWord(a3 + 4, 0);
    return;
  }
  const step = ram.word(a1 + 2);
  if (ram.word(a3 + 4) === 0) {
    const y = (ram.word(a2 + AWO_Y) + step) & 0xffff;
    ram.setWord(a2 + AWO_Y, y);
    if (s16(y) >= 340) ram.setByte(a3 + 5, 0xff);
  } else {
    const y = (ram.word(a2 + AWO_Y) - step) & 0xffff;
    ram.setWord(a2 + AWO_Y, y);
    if (s16(y) <= 150) ram.setWord(a3 + 4, 0);
  }
  const x = (ram.word(a2 + AWO_X) - 2) & 0xffff;
  ram.setWord(a2 + AWO_X, x);
  if (s16(x) <= 200) close(e, a0, bank);
}
