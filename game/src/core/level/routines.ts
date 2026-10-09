// Objekt-Routinen der Level-Module (Ag_Game_L*.s, Abschnitt „ROUTINES“): Gegner mit eigener Steuerung, gestartet
// über START_C in der Startliste. Jede laufende Routine belegt einen Eintrag der Rout_Struct (28 Byte: Code-Zeiger,
// −1 = frei; Parameter-Zeiger in die Startliste; AWO-Bank; 16 Byte Variablen) und eine eigene AWO-Bank. Der
// Code-Zeiger ist die Adresse der Routine im Level-Abbild; die Engine ordnet ihn über LevelLayout.routines der
// Umsetzung hier zu. Was im Code des Levels fest steht (Paletten, Animationen, Objektnummern), steht dort mit.
// Stand: alle Routinen von Level 1. R_Sol_Crache und R_Araignee sind gegen das Original geprüft, die übrigen
// übertragen, aber noch ungeprüft (Aufnahme über Bild 14792 hinaus fehlt). Level 2 nutzt dieselben Routinen mit kleinen
// Unterschieden (meist ohne eigene Palette), die in den …Def-Feldern stehen, dazu R_Kamikaze und R_Sol_Etoile; gegen
// das Original ungeprüft; der Endgegner von Level 2 (R_Final in Ag_Game_LFORET.s) hat eigenen Code (finalForet).
// Level 3 nutzt die bekannten Routinen ganz ohne eigene Paletten (auch ohne Rout_Mod_Pal_Counter bei R_Rapide,
// R_Transporteur und R_Sol_Crache), hat einen eigenen R_Jumper (jumperMarais), R_Sol_Kamikaze und einen eigenen
// Endgegner mit Zunge (finalMarais); gegen das Original ungeprüft. Level 4 nutzt R_Bomber, R_Volant_Missile,
// R_Sol_Kamikaze und R_Araignee wie Level 1–3 und hat eine Feuersäule (colonneFlamme); gegen das Original ungeprüft.
// Unbekannte Routinen halten die Engine an (LevelEngine.unported).

import type { LevelEngine } from "./engine.ts";
import { soundStart } from "./sounds.ts";
import { WORK } from "./timing.ts";

/** Pflanze am Boden, spuckt Feuerbälle (R_Sol_Crache) */
export interface SolCracheDef {
  kind: "solCrache";
  /**
   * R_SC_Pal (6 Zeilen-Schalter, 7 Farben; null: keine eigene Palette, CLOSE ohne Zählerabzug wie in Level 3),
   * R_Sol_Crache_Shape (11 Objektnummern), Sin_Table2 (Bytes)
   */
  pal: number | null;
  shape: number;
  sin: number;
  /** Obj_Sol_Crache_1, Obj_Fire_Ball */
  obj: number;
  fireBall: number;
}

/** Spinne, die an ihrem Faden auf und ab läuft (R_Araignee) */
export interface AraigneeDef {
  kind: "araignee";
  /** R_A_Pal (null: keine eigene Palette, CLOSE ohne Zählerabzug wie in Level 2), Obj_Araignee */
  pal: number | null;
  obj: number;
  /** Versatz von R_A_Y_Mode in den Variablen: 4 in Level 1 (davor R_A_Anim_Step), 2 in Level 2 */
  yMode: number;
}

/** Großer Gegner, der zwei Wellen kleiner Gegner absetzt (R_Transporteur) */
export interface TransporteurDef {
  kind: "transporteur";
  /**
   * R_T_Pal (null: keine eigene Palette, CLOSE ohne Zählerabzug wie in Level 3), R_Transporteur_Shape (4 Objektnummern),
   * R_T_Transporteur1/2 (Wellen, AWS), Obj_Transporteur_1
   */
  pal: number | null;
  shape: number;
  wave1: number;
  wave2: number;
  obj: number;
}

/** Monster, das acht Schüsse sternförmig auseinanderfliegen lässt (R_Tir_Etoile) */
export interface TirEtoileDef {
  kind: "tirEtoile";
  /**
   * R_TE_Pal (null: keine eigene Palette, CLOSE ohne Zählerabzug wie in Level 2), R_Tir_Etoile_Shape (9 Objektnummern),
   * Obj_Tir_Etoile_1, Obj_Tir_1–8
   */
  pal: number | null;
  shape: number;
  obj: number;
  shots: readonly number[];
}

/** Gespenst, das aus einer Phiole steigt und der Eule folgt (R_Spectre) */
export interface SpectreDef {
  kind: "spectre";
  /**
   * R_S_Pal (null: keine eigene Palette, CLOSE ohne Zählerabzug wie in Level 2), R_Spectre_Shape (5 Objektnummern),
   * Obj_Spectre_Pot, Obj_Spectre_4/5 (Flattern in MODE 3)
   */
  pal: number | null;
  shape: number;
  pot: number;
  obj4: number;
  obj5: number;
}

/** Schneller Gegner von rechts nach links; Animation, Tempo, Palette und Höhe aus den Parametern (R_Rapide) */
export interface RapideDef {
  kind: "rapide";
  /** MODE 0 setzt Rout_Pal_Ptr aus P_R_Pal_Ptr (Level 1); in Level 2 zählt er nur Rout_Mod_Pal_Counter hoch */
  pal: boolean;
  /** Rout_Mod_Pal_Counter in MODE 0 hoch und beim CLOSE herunter (Level 1 und 2); in Level 3 beides nicht */
  count: boolean;
  /** Energie: 3 in Level 1, 2 in Level 2 und 3 */
  energy: number;
}

/** Sack, der bis zu vier Kugeln fallen lässt (R_Bomber, „gros monstre largueur de bombe“) */
export interface BomberDef {
  kind: "bomber";
  /** Obj_Sac, Obj_Boulle, Sin_Table1 (Bytes, negativ = Ende) */
  obj: number;
  bomb: number;
  sin: number;
}

/**
 * Fliegender Gegner, dessen Bild mit sinkender Energie wechselt (R_Volant_Grossi), und seine Kopie am Boden
 * (R_Jumper, in Level 1 nicht gestartet)
 */
export interface GrossiDef {
  kind: "volantGrossi" | "jumper";
  /** R_VG_Pal bzw. R_J_Pal; Obj_Grossi_1–3 (Energie ≥ 7, ≥ 3, darunter) */
  pal: number;
  obj1: number;
  obj2: number;
  obj3: number;
}

/** Fliegendes Monster, das der Eule folgt und einen gelenkten Schuss abfeuert (R_Volant_Missile) */
export interface VolantMissileDef {
  kind: "volantMissile";
  /**
   * R_VM_Pal (null: in Level 2 auskommentiert), Obj_Volant_Missile_1/2, Obj_Tir_1–8 (Richtungen wie bei R_Tir_Etoile:
   * oben, oben rechts … oben links)
   */
  pal: number | null;
  obj1: number;
  obj2: number;
  shots: readonly number[];
  /** Pixel je Durchlauf des Schusses: 3 in Level 1, 1 in Level 2, 2 in Level 3 */
  shotSpeed: number;
}

/** Endgegner von Level 1 (R_Final) */
export interface FinalDef {
  kind: "final";
  /** R_F_Pal_Flash/_Normal/_Explo, R_T_Final_1–3 (Wellen der Kugeln) */
  palFlash: number;
  palNormal: number;
  palExplo: number;
  wave1: number;
  wave2: number;
  wave3: number;
  /** Obj_Final, Obj_Big_Explo_1–3 */
  obj: number;
  explo1: number;
  explo2: number;
  explo3: number;
  /** Front_Screens bis Front_Screens_E (wird beim Tod gelöscht) */
  frontScreens: number;
  frontScreensEnd: number;
}

/** Fliegendes Monster, das sich auf die Eule stürzt und dann nach links davonfliegt (R_Kamikaze, Level 2) */
export interface KamikazeDef {
  kind: "kamikaze";
  /** Obj_Kamikaze */
  obj: number;
}

/** Monster am Boden, das drei Schüsse nach oben, oben rechts und oben links abgibt (R_Sol_Etoile, Level 2) */
export interface SolEtoileDef {
  kind: "solEtoile";
  /** R_SE_Shape (20 Objektnummern), Obj_Sol_Etoile_1, Obj_Tir_1/_2/_8 (Schüsse nach oben, oben rechts, oben links) */
  shape: number;
  obj: number;
  shots: readonly number[];
}

/** Endgegner von Level 2 (R_Final in Ag_Game_LFORET.s): Oberteil und Unterteil, wirft Bumerangwellen */
export interface FinalForetDef {
  kind: "finalForet";
  /** R_T_Table (6 Zeiger auf R_T_Final_1–6), R_F_Anim_Up (8 Objektnummern des Oberteils) */
  waves: number;
  animUp: number;
  /** Obj_Final_1, Obj_Final_Bas_1/_2, Obj_Big_Explo_1–3 */
  obj: number;
  bas1: number;
  bas2: number;
  explo1: number;
  explo2: number;
  explo3: number;
}

/** Monster am Boden, das auf die Eule zuläuft und dann schräg nach oben springt (R_Jumper in AG_GAME_LMARAIS.S) */
export interface JumperMaraisDef {
  kind: "jumperMarais";
  /** Obj_Jumper_1 (Laufen), _2 (Absprung), _3 (Sprung) */
  obj1: number;
  obj2: number;
  obj3: number;
}

/** Monster am Boden, das nach links läuft und losstürmt, sobald die Eule tief fliegt (R_Sol_Kamikaze, Level 3) */
export interface SolKamikazeDef {
  kind: "solKamikaze";
  /** R_SK_Shape (6 Objektnummern), Obj_Sol_Kamikaze_1 */
  shape: number;
  obj: number;
}

/** Endgegner von Level 3 (R_Final in AG_GAME_LMARAIS.S): folgt der Eule und streckt alle 50 Durchläufe die Zunge aus */
export interface FinalMaraisDef {
  kind: "finalMarais";
  /** Final_Shape (10 Objektnummern), Langue_Shape (26 Objektnummern), Obj_Final_1, Obj_Langue_1 */
  shape: number;
  langue: number;
  obj: number;
  objLangue: number;
}

/** Feuersäule aus 4 großen Flammen, die mit dem Boden nach links wandert und wächst und schrumpft (R_Colonne_Flamme, Level 4) */
export interface ColonneFlammeDef {
  kind: "colonneFlamme";
  /** R_CF_Shape (8 Objektnummern), R_CF_Hight (16 Wörter: Zahl der sichtbaren Flammen), Obj_Grande_Flamme_1 */
  shape: number;
  hight: number;
  obj: number;
}

export type RoutineDef = SolCracheDef | AraigneeDef | TransporteurDef | TirEtoileDef | SpectreDef | RapideDef |
  BomberDef | GrossiDef | VolantMissileDef | FinalDef | KamikazeDef | SolEtoileDef | FinalForetDef | JumperMaraisDef |
  SolKamikazeDef | FinalMaraisDef | ColonneFlammeDef;

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
const AWO_F_RT_S = 9;
const AWO_F_RT_D = 0x0a;
/** AWO-Bank: Kopfwort (Anzahl Gegner, −1 = frei), Wort, 16 Gegner (AWO_size $C4) */
const BANK_LEN = 2 + 2 + 16 * AWO_LEN;
// Track_Table und TS/AWS wie in playability.ts
const TS_AWO_PTR = 0;
const TS_AWS_PTR = 4;
const TS_ALIEN_NUM = 8;
const TS_FIRST_ALIEN = 0x0a;
const TS_X_START = 0x0c;
const TS_Y_START = 0x0e;
const AWS_ALIEN_ENERGY = 8;
const AWS_ALIEN_BAD_F = 0x0a;
const AWS_ALIEN_F_RATE = 0x0b;

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
    switch (def.kind) {
      case "solCrache": solCrache(e, a0, def); break;
      case "araignee": araignee(e, a0, def); break;
      case "transporteur": transporteur(e, a0, def); break;
      case "tirEtoile": tirEtoile(e, a0, def); break;
      case "spectre": spectre(e, a0, def); break;
      case "rapide": rapide(e, a0, def); break;
      case "bomber": bomber(e, a0, def); break;
      case "volantGrossi":
      case "jumper": grossi(e, a0, def); break;
      case "volantMissile": volantMissile(e, a0, def); break;
      case "final": final(e, a0, def); break;
      case "kamikaze": kamikaze(e, a0, def); break;
      case "solEtoile": solEtoile(e, a0, def); break;
      case "finalForet": finalForet(e, a0, def); break;
      case "jumperMarais": jumperMarais(e, a0, def); break;
      case "solKamikaze": solKamikaze(e, a0, def); break;
      case "finalMarais": finalMarais(e, a0, def); break;
      case "colonneFlamme": colonneFlamme(e, a0, def); break;
    }
  }
}

/** Gemeinsamer Anfang (MODE 0): eigene Farben anmelden, ein Gegner in der Bank */
function open(e: LevelEngine, pal: number): void {
  const { V } = e;
  e.setL(V.routPalPtr, pal);
  e.setB(V.refreshPal + 1, 0xff);
  e.setW(V.routModPalCounter, e.w(V.routModPalCounter) + 1);
}

/**
 * CLOSE: Eintrag und Bank frei, Farben abmelden; die letzte Routine stellt die Palette des Levels wieder her. Ohne
 * `count` (Routinen ohne eigene Palette, z. B. in Level 2) bleibt Rout_Mod_Pal_Counter unverändert, nur der Test folgt.
 */
function close(e: LevelEngine, a0: number, bank: number, count = true): void {
  const { V, ram } = e;
  ram.setLong(a0, 0xffffffff);
  ram.setWord(bank, 0xffff);
  let n = e.w(V.routModPalCounter);
  if (count) {
    n = (n - 1) & 0xffff;
    e.setW(V.routModPalCounter, n);
  }
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
    if (d.pal !== null) open(e, d.pal);
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
    close(e, a0, bank, d.pal !== null);
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
 * und 340 auf und ab. Variablen: +0 Modus, +4 Richtung (0 = abwärts, sonst aufwärts; in Level 2 +2). Parameter:
 * Start-y, Schritt. Quelle: Ag_Game_LMER.s bzw. Ag_Game_LFORET.s, Label R_Araignee; Abbild $4F81C (sea), $4BEE4–$4BF8C
 * (forest).
 */
function araignee(e: LevelEngine, a0: number, d: AraigneeDef): void {
  const { ram } = e;
  const a1 = ram.long(a0 + ROUT_PARAM_PTR);
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  ram.setLong(bank, 0x00010000);
  const yMode = a3 + d.yMode;
  if (ram.word(a3) === 0) {
    if (d.pal !== null) open(e, d.pal);
    ram.setWord(a2 + AWO_X, 256 + 340);
    ram.setWord(a2 + AWO_Y, ram.word(a1));
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 10);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3, 1);
    ram.setWord(yMode, 0);
    return;
  }
  const step = ram.word(a1 + 2);
  if (ram.word(yMode) === 0) {
    const y = (ram.word(a2 + AWO_Y) + step) & 0xffff;
    ram.setWord(a2 + AWO_Y, y);
    if (s16(y) >= 340) ram.setByte(yMode + 1, 0xff);
  } else {
    const y = (ram.word(a2 + AWO_Y) - step) & 0xffff;
    ram.setWord(a2 + AWO_Y, y);
    if (s16(y) <= 150) ram.setWord(yMode, 0);
  }
  const x = (ram.word(a2 + AWO_X) - 2) & 0xffff;
  ram.setWord(a2 + AWO_X, x);
  if (s16(x) <= 200) close(e, a0, bank, d.pal !== null);
}

/**
 * R_Transporteur: erscheint rechts (x 256 + 320, y 144 + 256, unverwundbar) und schiebt sich 1 Pixel je Durchlauf
 * nach links, Animation jedes zweite Mal. Bei x = P_T_Launch_X setzt er zwei Wellen (R_T_Transporteur1/2, absolute
 * Bahnen) bei x − 4, y 138 + 256 ab und vibriert danach (Animation jeden Durchlauf); nach 150 Durchläufen explodiert
 * er, nach 175 endet die Routine. Variablen: +0 Modus (0 Start, 1 Monster, 2 Vibrieren), +2 Animationsschritt, +4
 * Animationstakt, +6 Zeit. Parameter: P_T_Launch_X.
 * Quelle: Ag_Game_LMER.s, Label R_Transporteur; Abbild $4EFC8–$4F16E.
 */
function transporteur(e: LevelEngine, a0: number, d: TransporteurDef): void {
  const { ram } = e;
  const a1 = ram.long(a0 + ROUT_PARAM_PTR);
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  const mode = ram.word(a3);
  if (mode === 0) {
    if (d.pal !== null) open(e, d.pal);
    ram.setLong(bank, 0x00010000);
    ram.setWord(a2 + AWO_X, 256 + 320);
    ram.setWord(a2 + AWO_Y, 144 + 256);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 0xffff);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3 + 6, 0);
    ram.setWord(a3, 1);
    return;
  }
  ram.setLong(bank, 0x00010000);
  if (mode === 1) {
    const delay = ram.word(a3 + 4) ^ 1;
    ram.setWord(a3 + 4, delay);
    if (delay !== 0) animate(e, a3, a2, d.shape, 3);
    const x = (ram.word(a2 + AWO_X) - 1) & 0xffff;
    ram.setWord(a2 + AWO_X, x);
    if (ram.word(a1) !== x) return;
    ram.setWord(a3, 2);
    // Launch: zuerst R_T_Transporteur1 (d4 = 1), dann R_T_Transporteur2, beide als absolute Bahn (Bit 30)
    // je Welle st Refresh_Pal+1 (R_Final setzt es beim Start seiner Wellen nicht)
    const x0 = (ram.word(a1) - 4) & 0xffff;
    e.setB(e.V.refreshPal + 1, 0xff);
    launchWave(e, (d.wave1 | 0x40000000) >>> 0, x0, 138 + 256);
    e.setB(e.V.refreshPal + 1, 0xff);
    launchWave(e, (d.wave2 | 0x40000000) >>> 0, x0, 138 + 256);
    return;
  }
  // MODE 2: vibrieren, Animation jeden Durchlauf
  animate(e, a3, a2, d.shape, 3);
  const time = (ram.word(a3 + 6) + 1) & 0xffff;
  ram.setWord(a3 + 6, time);
  if (time === 25 * 6) ram.setByte(a2 + AWO_STATUS, 1);
  if (time === 25 * 7) close(e, a0, bank, d.pal !== null);
}

/** Animationsschritt: Objektnummer aus der Tabelle, nach dem letzten von `last` + 1 Einträgen wieder von vorn */
function animate(e: LevelEngine, a3: number, a2: number, shape: number, last: number): void {
  const { ram } = e;
  const step = ram.word(a3 + 2);
  ram.setWord(a3 + 2, (step + 2) & 0xffff);
  ram.setWord(a2 + AWO_OBJ_OFF, ram.word(shape + s16(step)));
  if (step === 2 * last) ram.setWord(a3 + 2, 0);
}

/**
 * Welle aus einer Routine starten (R_Transporteur .launch_loop, R_Final Step_1–3): freie Bahn in Track_Table und
 * freie AWO-Bank wie ein Eintrag der Startliste, aber ohne SL_Ctrl und ohne Refresh_Pal (setzt der Aufrufer). Energie
 * und Schussrate setzt das Original für 32 statt 16 Gegner (moveq #31,d0) und schreibt damit über die Bank hinaus in
 * die folgende (nachgebildet). Rückgabe: die AWO-Bank.
 */
function launchWave(e: LevelEngine, d0: number, x: number, y: number): number {
  const { L, ram } = e;
  let entry = L.trackTable;
  while ((ram.byte(entry) & 0x80) === 0) entry += 4;
  ram.setByte(entry, ram.byte(entry) & 0x7f);
  const ts = ram.long(entry);
  ram.setLong(ts + TS_AWS_PTR, d0);
  ram.setWord(ts + TS_ALIEN_NUM, 0);
  ram.setByte(ts + TS_FIRST_ALIEN, 0);
  ram.setWord(ts + TS_X_START, x);
  ram.setWord(ts + TS_Y_START, y);
  // movea.l d0,a3: der 68000 nutzt nur 24 Adressbits, Bit 30 fällt weg
  const aws = d0 & 0xffffff;
  let bank = L.awoStruct;
  while ((ram.word(bank) & 0x8000) === 0) bank += BANK_LEN;
  ram.setLong(bank, 0);
  ram.setLong(ts + TS_AWO_PTR, bank);
  const energy = ram.word(aws + AWS_ALIEN_ENERGY);
  const fRate = ram.byte(aws + AWS_ALIEN_F_RATE);
  let n = 0;
  for (let i = 0, awo = bank + 4; i < 32; i++, awo += AWO_LEN) {
    ram.setWord(awo + AWO_ENERGY, energy);
    ram.setByte(awo + AWO_STATUS, 0);
    n = (n + 1) & 0xff;
    if (n === fRate) {
      ram.setByte(awo + AWO_F_RT_S, ram.byte(aws + AWS_ALIEN_BAD_F));
      n = 0;
    } else {
      ram.setByte(awo + AWO_F_RT_S, 0xff);
    }
    ram.setByte(awo + AWO_F_RT_D, 0);
  }
  return bank;
}

/**
 * R_Tir_Etoile: erscheint rechts (x 256 + 300, y = P_TE_Pos_Y, Energie 50) und wandert 2 Pixel je Durchlauf nach
 * links, Animation jedes zweite Mal (9 Bilder). Bei x = P_TE_Launch_X belegt es die nächsten 8 Gegner der Bank mit den
 * Schüssen Obj_Tir_1–8 (Energie 10) und merkt sich den Startpunkt. Danach (9 Gegner in der Bank) wächst der Abstand
 * um 3 je Durchlauf; die Schüsse stehen in 8 Richtungen um den Startpunkt (oben, oben rechts, rechts, unten rechts,
 * unten, unten links, links, oben links). Das Monster zieht bis Abstand 100 mit 1 Pixel je Durchlauf nach links, dann
 * mit 4 Pixel nach links und 2 nach oben; ab x ≤ 224 endet die Routine. Variablen: +0 Modus (0 Start, 1 Monster,
 * 2 mit Schüssen), +2 Animationsschritt, +4 Animationstakt, +6 Abstand, +8/+10 Startpunkt der Schüsse.
 * Parameter: P_TE_Launch_X, P_TE_Pos_Y. Quelle: Ag_Game_LMER.s, Label R_Tir_Etoile; Abbild $4ED70–$4EF6A (sea),
 * $4B964–$4BB4A (forest, Ag_Game_LFORET.s: ohne eigene Palette).
 */
function tirEtoile(e: LevelEngine, a0: number, d: TirEtoileDef): void {
  const { ram } = e;
  const a1 = ram.long(a0 + ROUT_PARAM_PTR);
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  const mode = ram.word(a3);
  ram.setLong(bank, 0x00010000);
  if (mode === 0) {
    if (d.pal !== null) open(e, d.pal);
    ram.setWord(a2 + AWO_X, 256 + 300);
    ram.setWord(a2 + AWO_Y, ram.word(a1 + 2));
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 50);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3, 1);
    return;
  }
  let a4 = a2 + AWO_LEN;
  const delay = ram.word(a3 + 4) ^ 1;
  ram.setWord(a3 + 4, delay);
  if (delay !== 0) animate(e, a3, a2, d.shape, 8);
  if (mode === 1) {
    const x = (ram.word(a2 + AWO_X) - 2) & 0xffff;
    ram.setWord(a2 + AWO_X, x);
    if (ram.word(a1) !== x) return;
    ram.setWord(a3, 2);
    for (let i = 0, awo = a4; i < 8; i++, awo += AWO_LEN) {
      ram.setWord(awo + AWO_ENERGY, 10);
      ram.setLong(awo + AWO_STATUS, 0);
      ram.setByte(awo + AWO_F_RT_S, 0xff);
    }
    for (let i = 0; i < 8; i++) ram.setWord(a4 + i * AWO_LEN + AWO_OBJ_OFF, d.shots[i]!);
    ram.setWord(a3 + 6, 0);
    ram.setWord(a3 + 8, x);
    ram.setWord(a3 + 10, ram.word(a2 + AWO_Y));
    return;
  }
  if (mode !== 2) return;
  ram.setWord(bank, 9);
  const r = (ram.word(a3 + 6) + 3) & 0xffff;
  ram.setWord(a3 + 6, r);
  if (s16(r) > 25 * 4) {
    ram.setWord(a2 + AWO_Y, (ram.word(a2 + AWO_Y) - 2) & 0xffff);
    ram.setWord(a2 + AWO_X, (ram.word(a2 + AWO_X) - 4) & 0xffff);
  } else {
    ram.setWord(a2 + AWO_X, (ram.word(a2 + AWO_X) - 1) & 0xffff);
  }
  const fx = ram.word(a3 + 8);
  const fy = ram.word(a3 + 10);
  // Reihenfolge der Richtungen wie im Original: (0,−), (+,−), (+,0), (+,+), (0,+), (−,+), (−,0), (−,−)
  for (let i = 0; i < 8; i++, a4 += AWO_LEN) {
    ram.setWord(a4 + AWO_X, (fx + STAR_DX[i]! * r) & 0xffff);
    ram.setWord(a4 + AWO_Y, (fy + STAR_DY[i]! * r) & 0xffff);
  }
  if (s16(ram.word(a2 + AWO_X)) <= 256 - 32) close(e, a0, bank, d.pal !== null);
}

/** Richtungen der 8 Schüsse von R_Tir_Etoile (Vorzeichen des Abstands für x und y) */
const STAR_DX = [0, 1, 1, 1, 0, -1, -1, -1];
const STAR_DY = [-1, -1, 0, 1, 1, 1, 0, -1];

/**
 * R_Spectre: Eine Phiole (Obj_Spectre_Pot, Energie 5) erscheint rechts (x 256 + 300, y 256 + 160) und wandert in allen
 * Modi 2 Pixel je Durchlauf nach links. Wird sie getroffen (Status gesetzt) und ist x < 200, endet die Routine. Bei
 * x = P_S_Launch_X steigt aus der unversehrten Phiole das Gespenst (zweiter Gegner der Bank, Energie 2, Schussrate
 * P_S_Fire_Rate): MODE 2 zieht es mit der Phiole nach links und spielt jedes zweite Mal die 5 Bilder ab, MODE 3 lässt
 * es flattern (Spectre_4/5 jedes zweite Mal) und der Eule folgen: Ziel = Eule + (16, 40), neu gewählt alle 18
 * Durchläufe oder sobald es in x oder y bis auf die Geschwindigkeit herangekommen ist; Schritt P_S_X_Speed bzw.
 * P_S_Y_Speed. Nach 200 Durchläufen in MODE 3 endet die Routine. Beim Ende bekommt das Gespenst Status 1 (Explosion),
 * auch wenn es noch nicht aufgestiegen war. Variablen: +0 Modus, +2 Animationsschritt, +4 Animationstakt, +6/+8 Ziel,
 * +10 Takt bis zum neuen Ziel, +12 Zeit. Parameter: Launch_X, Fire_Rate, X_Speed, Y_Speed.
 * Quelle: Ag_Game_LMER.s, Label R_Spectre; Abbild $4E9F0–$4EBE8 (sea), $4B76C–$4B950 (forest, Ag_Game_LFORET.s: ohne
 * eigene Palette).
 */
function spectre(e: LevelEngine, a0: number, d: SpectreDef): void {
  const { V, ram } = e;
  const a1 = ram.long(a0 + ROUT_PARAM_PTR);
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  const a4 = a2 + AWO_LEN;
  const mode = ram.word(a3);
  ram.setLong(bank, 0x00010000);
  if (mode === 0) {
    if (d.pal !== null) open(e, d.pal);
    ram.setWord(a2 + AWO_X, 256 + 300);
    ram.setWord(a2 + AWO_Y, 256 + 160);
    ram.setWord(a2 + AWO_OBJ_OFF, d.pot);
    ram.setWord(a2 + AWO_ENERGY, 5);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3, 1);
    return;
  }
  // MODE 1 (immer): Phiole nach links; getroffen und x < 200: Ende
  const x = (ram.word(a2 + AWO_X) - 2) & 0xffff;
  ram.setWord(a2 + AWO_X, x);
  if ((ram.byte(a2 + AWO_STATUS) & 0xf) !== 0 && s16(x) < 200) {
    spectreClose(e, a0, bank, a4, d);
    return;
  }
  if (ram.word(a1) === x && (ram.byte(a2 + AWO_STATUS) & 0xf) === 0) {
    ram.setWord(a3, 2);
    ram.setWord(bank, 2);
    ram.setWord(a4 + AWO_X, x);
    ram.setWord(a4 + AWO_Y, ram.word(a2 + AWO_Y));
    ram.setWord(a4 + AWO_OBJ_OFF, ram.word(d.shape));
    ram.setWord(a4 + AWO_ENERGY, 2);
    ram.setLong(a4 + AWO_STATUS, 0);
    ram.setByte(a4 + AWO_F_RT_S, ram.byte(a1 + 3));
    ram.setWord(a3 + 2, 0);
    ram.setWord(a3 + 4, 0);
    return;
  }
  if (mode === 2) {
    ram.setWord(bank, 2);
    ram.setWord(a4 + AWO_X, (ram.word(a4 + AWO_X) - 2) & 0xffff);
    const delay = ram.word(a3 + 4) ^ 1;
    ram.setWord(a3 + 4, delay);
    if (delay !== 0) return;
    const step = ram.word(a3 + 2);
    ram.setWord(a3 + 2, (step + 2) & 0xffff);
    ram.setWord(a4 + AWO_OBJ_OFF, ram.word(d.shape + s16(step)));
    if (step === 2 * 4) {
      ram.setWord(a3, 3);
      ram.setWord(a3 + 10, 1);
      ram.setWord(a3 + 12, 0);
    }
    return;
  }
  if (mode !== 3) return;
  ram.setWord(bank, 2);
  const delay = ram.word(a3 + 4) ^ 1;
  ram.setWord(a3 + 4, delay);
  if (delay !== 0) ram.setWord(a4 + AWO_OBJ_OFF, ram.word(a4 + AWO_OBJ_OFF) === d.obj5 ? d.obj4 : d.obj5);
  const wait = (ram.word(a3 + 10) - 1) & 0xffff;
  ram.setWord(a3 + 10, wait);
  if (wait === 0) {
    ram.setWord(a3 + 10, 18);
    ram.setWord(a3 + 6, (e.w(V.sorcererX) + 16) & 0xffff);
    ram.setWord(a3 + 8, (e.w(V.sorcererY) + 40) & 0xffff);
  }
  follow(e, a3, a4 + AWO_X, a3 + 6, ram.word(a1 + 4));
  follow(e, a3, a4 + AWO_Y, a3 + 8, ram.word(a1 + 6));
  const time = (ram.word(a3 + 12) + 1) & 0xffff;
  ram.setWord(a3 + 12, time);
  if (time === 25 * 8) spectreClose(e, a0, bank, a4, d);
}

/**
 * Eine Koordinate des Gespensts um `speed` auf das Ziel zu (bei Gleichstand weg vom Ziel: cmp d4,d1 / blt);
 * ist der Abstand höchstens `speed`, wird im nächsten Durchlauf ein neues Ziel gewählt (R_S_Target_Delay = 1)
 */
function follow(e: LevelEngine, a3: number, pos: number, target: number, speed: number): void {
  const { ram } = e;
  const p = ram.word(pos);
  const t = ram.word(target);
  // sub/bpl/neg in 16 Bit ($8000 bleibt negativ)
  let dist = s16((t - p) & 0xffff);
  if (dist < 0) dist = s16(-dist & 0xffff);
  if (dist <= s16(speed)) ram.setWord(a3 + 10, 1);
  ram.setWord(pos, (s16(p) < s16(t) ? p + speed : p - speed) & 0xffff);
}

/** CLOSE von R_Spectre: wie close, danach Status 1 für das Gespenst */
function spectreClose(e: LevelEngine, a0: number, bank: number, a4: number, d: SpectreDef): void {
  close(e, a0, bank, d.pal !== null);
  e.ram.setByte(a4 + AWO_STATUS, 1);
}

/**
 * R_Rapide: erscheint rechts (x 256 + 340, y = P_R_Y, Energie 3) mit der Palette P_R_Pal_Ptr und rast P_R_Speed Pixel
 * je Durchlauf nach links; jeden Durchlauf das nächste Bild der Animation P_R_Anim_Ptr (Versatz zu Anim_Base, Ende
 * = negatives Wort, dann von vorn). Ab x ≤ 200 endet die Routine. Variablen: +0 Modus, +2 Zeiger in die Animation
 * (Langwort). Parameter: Anim_Ptr, Speed, Pal_Ptr (Langwort), Y. Quelle: Ag_Game_LMER.s, Label R_Rapide; Abbild
 * $4F8EE–$4F99C. In Level 2 (Ag_Game_LFORET.s, Abbild $4BFA2–$4C046) Energie 2 und keine Palette: MODE 0 erhöht nur
 * Rout_Mod_Pal_Counter, P_R_Pal_Ptr (Dummy_Pal) bleibt ungelesen; CLOSE wie in Level 1.
 */
function rapide(e: LevelEngine, a0: number, d: RapideDef): void {
  const { V, L, ram } = e;
  const a1 = ram.long(a0 + ROUT_PARAM_PTR);
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  ram.setLong(bank, 0x00010000);
  if (ram.word(a3) === 0) {
    if (d.pal) {
      e.setL(V.routPalPtr, ram.long(a1 + 4));
      e.setB(V.refreshPal + 1, 0xff);
    }
    if (d.count) e.setW(V.routModPalCounter, e.w(V.routModPalCounter) + 1);
    ram.setWord(a2 + AWO_X, 256 + 340);
    ram.setWord(a2 + AWO_Y, ram.word(a1 + 8));
    const a4 = (L.animBase + ram.sword(a1)) >>> 0;
    ram.setLong(a3 + 2, a4);
    ram.setWord(a2 + AWO_OBJ_OFF, ram.word(a4));
    ram.setWord(a2 + AWO_ENERGY, d.energy);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3, 1);
    return;
  }
  ram.setWord(a2 + AWO_X, (ram.word(a2 + AWO_X) - ram.word(a1 + 2)) & 0xffff);
  // .reread: Zeiger weiter, Wort am alten Zeiger lesen; negativ = Ende, dann ab Anim_Base + Anim_Ptr (der Zeiger steht
  // danach schon auf dem zweiten Bild). Beginnt die Animation mit einem negativen Wort, hängt das Original hier.
  let a4 = ram.long(a3 + 2);
  for (let tries = 0; ; tries++) {
    ram.setLong(a3 + 2, (ram.long(a3 + 2) + 2) >>> 0);
    const d1 = ram.word(a4);
    if ((d1 & 0x8000) === 0) {
      ram.setWord(a2 + AWO_OBJ_OFF, d1);
      break;
    }
    if (tries > 0) {
      e.halt("R_Rapide: Animation ohne Bild (Endlosschleife im Original)");
      return;
    }
    a4 = (L.animBase + ram.sword(a1)) >>> 0;
    ram.setLong(a3 + 2, a4);
  }
  if (s16(ram.word(a2 + AWO_X)) <= 200) close(e, a0, bank, d.count);
}

/** Variablen von R_Kamikaze: +0 R_VK_Mode, +2/+4 R_VK_Target_X/Y (ungenutzt), +6 R_VK_Time */
const VK_TIME = 6;

/**
 * R_Kamikaze: erscheint rechts oberhalb des Bilds (x 256 + 300, y 200, Energie 20, ohne eigene Palette) und hält bis
 * zur Zeit P_VK_Launch_Time je Durchlauf auf die Eule zu: Ziel = Eule + (150, 40), Schritt P_VK_X_Speed bzw.
 * P_VK_Y_Speed, nur solange der Abstand größer als der Schritt ist. Danach steht es; ab Zeit Launch_Time + 50 fliegt
 * es 8 Pixel je Durchlauf nach links, ab x ≤ 200 endet die Routine (CLOSE ohne Zählerabzug). Parameter: Launch_Time,
 * X_Speed, Y_Speed. Quelle: Ag_Game_LFORET.s, Label R_Kamikaze; Abbild $4C048–$4C136.
 */
function kamikaze(e: LevelEngine, a0: number, d: KamikazeDef): void {
  const { V, ram } = e;
  const a1 = ram.long(a0 + ROUT_PARAM_PTR);
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  ram.setLong(bank, 0x00010000);
  if (ram.word(a3) === 0) {
    ram.setWord(a2 + AWO_X, 256 + 300);
    ram.setWord(a2 + AWO_Y, 200);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 20);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3 + VK_TIME, 0);
    ram.setWord(a3, 1);
    return;
  }
  const launch = ram.word(a1);
  const time = (ram.word(a3 + VK_TIME) + 1) & 0xffff;
  ram.setWord(a3 + VK_TIME, time);
  // cmp (a4),d5 / blt: nur bis einschließlich Launch_Time
  if (s16(launch) >= s16(time)) {
    approach(e, a2 + AWO_X, (e.w(V.sorcererX) + 150) & 0xffff, ram.word(a1 + 2));
    approach(e, a2 + AWO_Y, (e.w(V.sorcererY) + 40) & 0xffff, ram.word(a1 + 4));
  }
  // cmp (a4),d6 / bgt: ab Launch_Time + 50 (add.w)
  if (s16((launch + 50) & 0xffff) > s16(time)) return;
  const x = (ram.word(a2 + AWO_X) - 8) & 0xffff;
  ram.setWord(a2 + AWO_X, x);
  if (s16(x) <= 200) close(e, a0, bank, false);
}

/** Eine Koordinate um `speed` auf das Ziel zu, wenn der Abstand (sub/bpl/neg in 16 Bit) größer als `speed` ist */
function approach(e: LevelEngine, pos: number, target: number, speed: number): void {
  const { ram } = e;
  const p = ram.word(pos);
  let dist = s16((target - p) & 0xffff);
  if (dist < 0) dist = s16(-dist & 0xffff);
  if (dist <= s16(speed)) return;
  ram.setWord(pos, (s16(p) < s16(target) ? p + speed : p - speed) & 0xffff);
}

/** Variablen von R_Sol_Etoile: +0 R_SE_Mode, +2 R_SE_Fire_Step, +4/+6 R_SE_Fire_X/Y, +8 R_SE_Anim_Step */
const SE_FIRE_STEP = 2;
const SE_FIRE_X = 4;
const SE_FIRE_Y = 6;
const SE_ANIM = 8;

/**
 * R_Sol_Etoile: erscheint rechts am Boden (x 256 + 300, y 256 + 191, Energie 10, ohne eigene Palette) und wandert
 * 2 Pixel je Durchlauf nach links, Animation jeden Durchlauf (20 Schritte, je Bild zweimal). Ab x ≤ 200 endet die
 * Routine (CLOSE ohne Zählerabzug). Ist es unversehrt und x < P_SE_Launch_X, belegt es die nächsten 3 Gegner der Bank
 * mit den Schüssen Obj_Tir_1/_2/_8 (Energie 10, ohne eigene Schüsse) und merkt sich den Startpunkt; ab dem nächsten
 * Durchlauf (4 Gegner in der Bank) wächst der Abstand um 3 je Durchlauf, die Schüsse stehen oben, oben rechts und oben
 * links vom Startpunkt. Parameter: Launch_X. Quelle: Ag_Game_LFORET.s, Label R_Sol_Etoile; Abbild $4C160–$4C2B4,
 * R_SE_Shape $4C138.
 */
function solEtoile(e: LevelEngine, a0: number, d: SolEtoileDef): void {
  const { ram } = e;
  const a1 = ram.long(a0 + ROUT_PARAM_PTR);
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  const mode = ram.word(a3);
  ram.setLong(bank, 0x00010000);
  if (mode === 0) {
    ram.setWord(a2 + AWO_X, 256 + 300);
    ram.setWord(a2 + AWO_Y, 256 + 191);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 10);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3, 1);
    return;
  }
  let step = (ram.word(a3 + SE_ANIM) + 1) & 0xffff;
  if (step === 20) step = 0;
  ram.setWord(a3 + SE_ANIM, step);
  ram.setWord(a2 + AWO_OBJ_OFF, ram.word(d.shape + 2 * step));
  let a4 = a2 + AWO_LEN;
  const x = (ram.word(a2 + AWO_X) - 2) & 0xffff;
  ram.setWord(a2 + AWO_X, x);
  if (s16(x) <= 200) {
    close(e, a0, bank, false);
    return;
  }
  if (mode === 1) {
    if ((ram.byte(a2 + AWO_STATUS) & 0xf) !== 0 || s16(ram.word(a1)) <= s16(x)) return;
    ram.setWord(a3, 2);
    for (let i = 0, awo = a4; i < 3; i++, awo += AWO_LEN) {
      ram.setWord(awo + AWO_ENERGY, 10);
      ram.setLong(awo + AWO_STATUS, 0);
      ram.setByte(awo + AWO_F_RT_S, 0xff);
      ram.setWord(awo + AWO_OBJ_OFF, d.shots[i]!);
    }
    ram.setWord(a3 + SE_FIRE_STEP, 0);
    ram.setWord(a3 + SE_FIRE_X, x);
    ram.setWord(a3 + SE_FIRE_Y, ram.word(a2 + AWO_Y));
    return;
  }
  if (mode !== 2) return;
  ram.setWord(bank, 4);
  const r = (ram.word(a3 + SE_FIRE_STEP) + 3) & 0xffff;
  ram.setWord(a3 + SE_FIRE_STEP, r);
  const fx = ram.word(a3 + SE_FIRE_X);
  const fy = ram.word(a3 + SE_FIRE_Y);
  // Reihenfolge wie im Original: (0,−), (+,−), (−,−)
  for (let i = 0; i < 3; i++, a4 += AWO_LEN) {
    ram.setWord(a4 + AWO_X, (fx + SE_DX[i]! * r) & 0xffff);
    ram.setWord(a4 + AWO_Y, (fy - r) & 0xffff);
  }
}

/** Richtungen der 3 Schüsse von R_Sol_Etoile in x (Vorzeichen des Abstands) */
const SE_DX = [0, 1, -1];

/**
 * R_Bomber: Ein Sack (Obj_Sac, Energie 15) erscheint rechts (x 256 + 340, y 256 + 32) und wandert 2 Pixel je
 * Durchlauf nach links; die Bank zeigt immer 5 Gegner (Sack und 4 Kugeln, anfangs Status $0F). Solange der Sack nicht
 * zerstört ist (Status $F), lässt er alle 24 Durchläufe eine Kugel fallen (Obj_Boulle, Energie 3), höchstens vier.
 * Jede Kugel folgt Sin_Table1: y = 428 − Tabellenwert, x = Sack − Schritt − 30, bis die Tabelle endet. Eigenheiten des
 * Originals (nachgebildet): Eine eigene Palette meldet die Routine nicht an (auskommentiert), CLOSE verringert daher
 * Rout_Mod_Pal_Counter nicht und läuft im selben Durchlauf weiter; die Schleife über die Kugeln läuft einmal mehr als
 * Kugeln da sind (dbra) und rückt dabei die Tabellenposition der nächsten Kugel bzw. bei 4 Kugeln das obere Byte von
 * R_B_Mode vor. Variablen: +0–3 Tabellenposition je Kugel (Bytes, negativ = fertig), +4 Modus, +6/+8 Animation
 * (unbenutzt), +10 Takt bis zur nächsten Kugel, +12 Anzahl Kugeln, +14 Versatz der letzten Kugel in der Bank.
 * Quelle: Ag_Game_LMER.s, Label R_Bomber; Abbild $4EC00–$4ED48.
 */
function bomber(e: LevelEngine, a0: number, d: BomberDef): void {
  const { V, ram } = e;
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  let a2 = bank + 4;
  if (ram.word(a3 + 4) === 0) {
    ram.setLong(bank, 0x00010000);
    ram.setWord(a2 + AWO_X, 256 + 340);
    ram.setWord(a2 + AWO_Y, 256 + 32);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 15);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3 + 4, 1);
    ram.setWord(a3 + 10, 0);
    ram.setWord(a3 + 14, 0);
    for (let i = 1; i <= 5; i++) ram.setByte(a2 + AWO_LEN * i + AWO_STATUS, 0x0f);
    return;
  }
  ram.setLong(bank, 0x00050000);
  const x = (ram.word(a2 + AWO_X) - 2) & 0xffff;
  ram.setWord(a2 + AWO_X, x);
  if (s16(x) <= 200) {
    // CLOSE ohne subq #1,Rout_Mod_Pal_Counter (im Original auskommentiert); danach weiter wie sonst
    ram.setLong(a0, 0xffffffff);
    ram.setWord(bank, 0xffff);
    if (e.w(V.routModPalCounter) === 0) {
      e.setL(V.routPalPtr, 0xffffffff);
      e.setB(V.refreshPal + 1, 0xff);
    }
  }
  const d4 = ram.word(a2 + AWO_X);
  const d1 = ram.word(a3 + 12);
  if (d1 !== 4 && (ram.byte(a2 + AWO_STATUS) & 0xf) !== 0xf) {
    const delay = (ram.word(a3 + 10) + 1) & 0xffff;
    ram.setWord(a3 + 10, delay);
    if (delay === 24) {
      // New Bomb
      ram.setWord(a3 + 10, 0);
      ram.setWord(a3 + 12, (d1 + 1) & 0xffff);
      const index = (ram.word(a3 + 14) + AWO_LEN) & 0xffff;
      ram.setWord(a3 + 14, index);
      const a4 = a2 + s16(index);
      ram.setWord(a4 + AWO_OBJ_OFF, d.bomb);
      ram.setWord(a4 + AWO_ENERGY, 3);
      ram.setWord(a4 + AWO_STATUS, 0x00ff);
      ram.setLong(a4 + AWO_X, 0);
      ram.setByte(a3 + s16(d1), 0);
    }
  }
  if (d1 === 0) return;
  a2 += AWO_LEN;
  // dbra d1: d1 + 1 Durchläufe (d1 = Anzahl Kugeln vor dem Abwurf)
  for (let d2 = 0; d2 <= d1; d2++, a2 += AWO_LEN) {
    const d3 = ram.byte(a3 + d2);
    if (d3 & 0x80) continue;
    ram.setByte(a3 + d2, (d3 + 1) & 0xff);
    const d5 = ram.byte(d.sin + d3);
    if (d5 & 0x80) {
      ram.setByte(a3 + d2, 0xff);
      continue;
    }
    ram.setWord(a2 + AWO_Y, (256 + 172 - d5) & 0xffff);
    ram.setWord(a2 + AWO_X, (d4 - d3 - 30) & 0xffff);
  }
}

/**
 * R_Volant_Grossi: erscheint rechts (x 256 + 340, y = P_VG_Y, Energie 10) und fliegt P_VG_Speed Pixel je Durchlauf nach
 * links; das Bild zeigt die Energie (Obj_Grossi_1 ab 7, Obj_Grossi_2 ab 3, sonst Obj_Grossi_3). Ab x ≤ 200 endet die
 * Routine (im selben Durchlauf wird das Bild noch gesetzt). Parameter: Y, Speed. Quelle: Ag_Game_LMER.s, Label
 * R_Volant_Grossi; Abbild $4F696–$4F748.
 * R_Jumper ist im Original eine Kopie mit fester Höhe (y 256 + 190) und 2 Pixel je Durchlauf, die
 * Rout_Mod_Pal_Counter weder erhöht noch verringert („rebondit sur le sol“, ein Springen fehlt). Quelle: Label
 * R_Jumper; Abbild $4F75E–$4F806.
 */
function grossi(e: LevelEngine, a0: number, d: GrossiDef): void {
  const { V, ram } = e;
  const jumper = d.kind === "jumper";
  const a1 = ram.long(a0 + ROUT_PARAM_PTR);
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  ram.setLong(bank, 0x00010000);
  if (ram.word(a3) === 0) {
    e.setL(V.routPalPtr, d.pal);
    e.setB(V.refreshPal + 1, 0xff);
    if (!jumper) e.setW(V.routModPalCounter, e.w(V.routModPalCounter) + 1);
    ram.setWord(a2 + AWO_X, 256 + 340);
    ram.setWord(a2 + AWO_Y, jumper ? 256 + 190 : ram.word(a1));
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj1);
    ram.setWord(a2 + AWO_ENERGY, 10);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3, 1);
    return;
  }
  const x = (ram.word(a2 + AWO_X) - (jumper ? 2 : ram.word(a1 + 2))) & 0xffff;
  ram.setWord(a2 + AWO_X, x);
  if (s16(x) <= 200) {
    ram.setLong(a0, 0xffffffff);
    ram.setWord(bank, 0xffff);
    let n = e.w(V.routModPalCounter);
    if (!jumper) {
      n = (n - 1) & 0xffff;
      e.setW(V.routModPalCounter, n);
    }
    if (n === 0) {
      e.setL(V.routPalPtr, 0xffffffff);
      e.setB(V.refreshPal + 1, 0xff);
    }
  }
  const energy = s16(ram.word(a2 + AWO_ENERGY));
  ram.setWord(a2 + AWO_OBJ_OFF, energy >= 7 ? d.obj1 : energy >= 3 ? d.obj2 : d.obj3);
}

// R_Volant_Missile: Variablen +0 Modus, +2 Animationstakt, +4 Takt bis zum Schuss, +6 Richtung des Schusses (0 keiner,
// 1 hoch, 2 rechts, 3 runter, 4 links), +8/+10 Ziel, +12 Zeit
const VM_ANIM = 2;
const VM_LAUNCH = 4;
const VM_FIRE_MODE = 6;
const VM_TARGET_X = 8;
const VM_TARGET_Y = 10;
const VM_TIME = 12;

/**
 * R_Volant_Missile: erscheint bei x 256 + 200, y 220 (Energie 20; Palette ohne Rout_Mod_Pal_Counter) und folgt der
 * Eule mit 1 Pixel je Durchlauf auf den Punkt Eule + (100, 40), solange Zeit ≤ 875 (35 s); ab 875 steigt es 1 Pixel je
 * Durchlauf, nach 1.125 Durchläufen endet die Routine (CLOSE ohne Zählerabzug). Flügelschlag: Bit 2 des
 * Animationstakts. Der Schuss (zweiter Gegner der Bank, Energie 10) startet alle 200 Durchläufe (zuerst nach 75) am
 * Monster, sofern dieses nicht zerstört ist, und fliegt mit 3 Pixel je Durchlauf waagrecht oder senkrecht auf das Ziel
 * Eule + (16, 40) zu; erreicht er dessen Zeile bzw. Spalte, wählt er eine neue Richtung (Bild der Diagonale als Kurve).
 * Nach 175 Durchläufen oder wenn die Eule tot ist, explodiert er (Status 1). Parameter: keine.
 * Quelle: Ag_Game_LMER.s, Label R_Volant_Missile; Abbild $4F2F2–$4F680 (sea). In Level 2 (Ag_Game_LFORET.s, Abbild
 * $4BB60–$4BEE0) ohne Palette (auskommentiert) und mit 1 statt 3 Pixel je Durchlauf für den Schuss.
 */
function volantMissile(e: LevelEngine, a0: number, d: VolantMissileDef): void {
  const { V, ram } = e;
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  const a4 = a2 + AWO_LEN;
  const mode = ram.word(a3);
  ram.setLong(bank, 0x00010000);
  if (mode === 0) {
    if (d.pal !== null) {
      e.setL(V.routPalPtr, d.pal);
      e.setB(V.refreshPal + 1, 0xff);
    }
    ram.setWord(a2 + AWO_X, 256 + 200);
    ram.setWord(a2 + AWO_Y, 220);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj1);
    ram.setWord(a2 + AWO_ENERGY, 20);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3 + VM_FIRE_MODE, 0);
    ram.setWord(a3 + VM_TIME, 0);
    ram.setWord(a3 + VM_LAUNCH, 25 * 5);
    ram.setWord(a3, 1);
  } else if (mode === 1) {
    volantMissileMode1(e, a3, a2, a4, d);
  }
  // .end
  const time = (ram.word(a3 + VM_TIME) + 1) & 0xffff;
  ram.setWord(a3 + VM_TIME, time);
  if (s16(time) >= 25 * 45) {
    ram.setLong(a0, 0xffffffff);
    ram.setWord(bank, 0xffff);
    if (e.w(V.routModPalCounter) === 0) {
      e.setL(V.routPalPtr, 0xffffffff);
      e.setB(V.refreshPal + 1, 0xff);
    }
  }
  if (s16(time) >= 25 * 35) ram.setWord(a2 + AWO_Y, (ram.word(a2 + AWO_Y) - 1) & 0xffff);
}

/** MODE 1 von R_Volant_Missile bis .end */
function volantMissileMode1(e: LevelEngine, a3: number, a2: number, a4: number, d: VolantMissileDef): void {
  const { V, ram } = e;
  let stop = e.w(V.die) !== 0;
  if (!stop) {
    const anim = (ram.word(a3 + VM_ANIM) + 1) & 0xffff;
    ram.setWord(a3 + VM_ANIM, anim);
    ram.setWord(a2 + AWO_OBJ_OFF, anim & 4 ? d.obj1 : d.obj2);
    const launch = (ram.word(a3 + VM_LAUNCH) + 1) & 0xffff;
    ram.setWord(a3 + VM_LAUNCH, launch);
    stop = launch === 25 * 7;
  }
  // .stop_fire: Schuss explodiert
  if (stop && (ram.byte(a4 + AWO_STATUS) & 0xf) === 0) ram.setByte(a4 + AWO_STATUS, 1);
  if (ram.word(a3 + VM_LAUNCH) === 25 * 8) {
    // .init_fire
    if (ram.byte(a2 + AWO_STATUS) === 0x0f) return;
    ram.setWord(a3 + VM_LAUNCH, 0);
    ram.setWord(a4 + AWO_X, ram.word(a2 + AWO_X));
    ram.setWord(a4 + AWO_Y, ram.word(a2 + AWO_Y));
    ram.setWord(a4 + AWO_ENERGY, 10);
    ram.setLong(a4 + AWO_STATUS, 0);
    vmDecisionY(e, a3, a4, d);
    return;
  }
  const fireMode = ram.word(a3 + VM_FIRE_MODE);
  if (fireMode !== 0) {
    ram.setWord(a2 - 4, 2);
    const tx = s16(ram.word(a3 + VM_TARGET_X));
    const ty = s16(ram.word(a3 + VM_TARGET_Y));
    if (fireMode === 1) {
      // hoch
      const y = (ram.word(a4 + AWO_Y) - d.shotSpeed) & 0xffff;
      ram.setWord(a4 + AWO_Y, y);
      ram.setWord(a4 + AWO_OBJ_OFF, d.shots[0]!);
      if (s16(y) <= ty) return vmDecisionX(e, a3, a4, d);
    } else if (fireMode === 2) {
      // rechts
      const x = (ram.word(a4 + AWO_X) + d.shotSpeed) & 0xffff;
      ram.setWord(a4 + AWO_X, x);
      ram.setWord(a4 + AWO_OBJ_OFF, d.shots[2]!);
      if (s16(x) >= tx) return vmDecisionY(e, a3, a4, d);
    } else if (fireMode === 3) {
      // runter: neue Richtung erst, wenn die Zeile überschritten ist (bgt)
      const y = (ram.word(a4 + AWO_Y) + d.shotSpeed) & 0xffff;
      ram.setWord(a4 + AWO_Y, y);
      ram.setWord(a4 + AWO_OBJ_OFF, d.shots[4]!);
      if (s16(y) > ty) return vmDecisionX(e, a3, a4, d);
    } else {
      // links (jeder andere Wert)
      const x = (ram.word(a4 + AWO_X) - d.shotSpeed) & 0xffff;
      ram.setWord(a4 + AWO_X, x);
      ram.setWord(a4 + AWO_OBJ_OFF, d.shots[6]!);
      if (s16(x) <= tx) return vmDecisionY(e, a3, a4, d);
    }
  }
  // .no_fire: Monster folgt der Eule
  if (s16(ram.word(a3 + VM_TIME)) > 25 * 35) return;
  const dy = s16((ram.word(a2 + AWO_Y) - 40) & 0xffff);
  const sy = e.sw(V.sorcererY);
  if (dy !== sy) ram.setWord(a2 + AWO_Y, (ram.word(a2 + AWO_Y) + (dy > sy ? -1 : 1)) & 0xffff);
  const dx = s16((ram.word(a2 + AWO_X) - 100) & 0xffff);
  const sx = e.sw(V.sorcererX);
  if (dx !== sx) ram.setWord(a2 + AWO_X, (ram.word(a2 + AWO_X) + (dx > sx ? -1 : 1)) & 0xffff);
}

/** Neues Ziel des Schusses: Eule + (16, 40) */
function vmTarget(e: LevelEngine, a3: number): void {
  const { V, ram } = e;
  ram.setWord(a3 + VM_TARGET_X, (e.w(V.sorcererX) + 16) & 0xffff);
  ram.setWord(a3 + VM_TARGET_Y, (e.w(V.sorcererY) + 40) & 0xffff);
}

/** Richtung und Bild setzen; `diag` = Bild der Kurve, wenn die bisherige Richtung `from` war */
function vmTurn(e: LevelEngine, a3: number, a4: number, mode: number, from: number, diag: number,
  straight: number): void {
  const { ram } = e;
  ram.setWord(a4 + AWO_OBJ_OFF, ram.word(a3 + VM_FIRE_MODE) === from ? diag : straight);
  ram.setWord(a3 + VM_FIRE_MODE, mode);
}

/**
 * .tacke_desision_fy (nach waagrechtem Flug oder Start): zuerst senkrecht zum Ziel; liegt es auf gleicher Höhe,
 * waagrecht (bei gleicher Spalte löscht clr die Richtung, und das folgende bgt geht nach links)
 */
function vmDecisionY(e: LevelEngine, a3: number, a4: number, d: VolantMissileDef): void {
  const { ram } = e;
  const sh = d.shots;
  vmTarget(e, a3);
  const tx = s16(ram.word(a3 + VM_TARGET_X));
  const ty = s16(ram.word(a3 + VM_TARGET_Y));
  const y = s16(ram.word(a4 + AWO_Y));
  if (ty < y) return vmTurn(e, a3, a4, 1, 4, sh[7]!, sh[1]!);
  if (ty > y) return vmTurn(e, a3, a4, 3, 4, sh[5]!, sh[3]!);
  const x = s16(ram.word(a4 + AWO_X));
  if (tx === x) ram.setWord(a3 + VM_FIRE_MODE, 0);
  if (tx > x) return vmTurn(e, a3, a4, 2, 1, sh[1]!, sh[3]!);
  vmTurn(e, a3, a4, 4, 1, sh[7]!, sh[5]!);
}

/** .tacke_desision_fx (nach senkrechtem Flug): erst waagrecht zum Ziel, in gleicher Spalte senkrecht (gleich = hoch) */
function vmDecisionX(e: LevelEngine, a3: number, a4: number, d: VolantMissileDef): void {
  const { ram } = e;
  const sh = d.shots;
  vmTarget(e, a3);
  const tx = s16(ram.word(a3 + VM_TARGET_X));
  const ty = s16(ram.word(a3 + VM_TARGET_Y));
  const x = s16(ram.word(a4 + AWO_X));
  if (tx < x) return vmTurn(e, a3, a4, 4, 1, sh[7]!, sh[5]!);
  if (tx > x) return vmTurn(e, a3, a4, 2, 1, sh[1]!, sh[3]!);
  const y = s16(ram.word(a4 + AWO_Y));
  if (ty > y) return vmTurn(e, a3, a4, 3, 4, sh[5]!, sh[3]!);
  vmTurn(e, a3, a4, 1, 4, sh[7]!, sh[1]!);
}

// R_Final: Variablen +0 Modus, +2 Takt bis zur nächsten Welle, +4 nächste Welle (0–2), +6 Schritt der Explosion
const F_TIME = 2;
const F_STEP = 4;
const F_EXPLO = 6;

/**
 * R_Final: Der Endgegner (Obj_Final, Energie 130, Schussrate 30) steht bei x 256 + 160, y 256 + 90;
 * Rout_Mod_Pal_Counter wird gelöscht. Getroffen (oberes Status-Halbbyte gesetzt) blitzt er: bis $20 weiße Palette,
 * darüber die normale, jeweils mit Short_Phase = 1. Solange er lebt, startet er alle 70 Durchläufe abwechselnd eine
 * der drei Kugelwellen R_T_Final_1–3. Zerstört (unteres Halbbyte gesetzt) zählt der Modus jeden Durchlauf weiter,
 * und die Explosion läuft in Schritten ab: 1 große Explosion (Quit_Delay = 100, nur im Abbild), 17 Blitz mit
 * Geräusch, 19 vorderes Playfield gelöscht, Bahnen 0–7 frei und die drei Wellen-Bänke frei, 21/35/52 weitere
 * Explosionen mit Geräusch (21 mit der Feuer-Palette), 52 zusätzlich Clean_Up (Levelende). Abweichung des Abbilds vom
 * Quelltext: Quit_Delay = 100 schon in Schritt 1 statt 25 in Schritt 52. Quelle: Ag_Game_LMER.s, Label R_Final;
 * Abbild $4FA3A–$4FE20.
 */
function final(e: LevelEngine, a0: number, d: FinalDef): void {
  const { V, ram } = e;
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  // MODE 0 (cmp #2,d1 / beq .explo davor ist toter Code: d1 ist hier 0)
  if (ram.word(a3) === 0) {
    ram.setLong(bank, 0x00010000);
    ram.setWord(a2 + AWO_X, 256 + 160);
    ram.setWord(a2 + AWO_Y, 256 + 90);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 130);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setByte(a2 + AWO_F_RT_S, 30);
    e.setW(V.routModPalCounter, 0);
    ram.setWord(a3, 1);
    return;
  }
  ram.setLong(bank, 0x00010000);
  const hit = ram.byte(a2 + AWO_STATUS) & 0xf0;
  if (hit !== 0) {
    e.setL(V.routPalPtr, hit > 0x20 ? d.palNormal : d.palFlash);
    e.setB(V.refreshPal + 1, 0xff);
    e.setW(V.shortPhase, 1);
  }
  if ((ram.byte(a2 + AWO_STATUS) & 0xf) === 0) {
    finalWaves(e, a3, d);
    return;
  }
  ram.setWord(a3, (ram.word(a3) + 1) & 0xffff);
  // .explo
  const step = (ram.word(a3 + F_EXPLO) + 1) & 0xffff;
  ram.setWord(a3 + F_EXPLO, step);
  if (step === 1) {
    e.setW(V.quitDelay, 100);
    finalExplo(e, a2, 256 + 220, 256 + 100, d.explo1);
  }
  if (step === 17) {
    finalPal(e, d.palFlash);
    soundStart(e, 1, 63);
  }
  if (step === 19) {
    ram.clear(d.frontScreens, d.frontScreensEnd);
    for (let i = 0; i < 8; i++) ram.setByte(e.L.trackTable + 4 * i, ram.byte(e.L.trackTable + 4 * i) | 0x80);
    ram.setLong(e.l(V.rFAwoPtr1), 0xffffffff);
    ram.setLong(e.l(V.rFAwoPtr2), 0xffffffff);
    ram.setLong(e.l(V.rFAwoPtr3), 0xffffffff);
  }
  if (step === 21) {
    finalExplo(e, a2, 256 + 250, 256 + 80, d.explo1);
    finalPal(e, d.palExplo);
    soundStart(e, 1, 63);
  }
  if (step === 35) {
    finalExplo(e, a2, 256 + 200, 256 + 110, d.explo2);
    soundStart(e, 1, 63);
  }
  if (step === 52) {
    finalExplo(e, a2, 256 + 250, 256 + 120, d.explo3);
    soundStart(e, 1, 63);
    e.setB(V.cleanUp, 0xff);
  }
}

/** Explosionsbild an (x, y), Status 1 */
function finalExplo(e: LevelEngine, a2: number, x: number, y: number, obj: number): void {
  const { ram } = e;
  ram.setWord(a2 + AWO_X, x);
  ram.setWord(a2 + AWO_Y, y);
  ram.setWord(a2 + AWO_OBJ_OFF, obj);
  ram.setLong(a2 + AWO_STATUS, 0);
  ram.setByte(a2 + AWO_STATUS, 1);
}

/** Palette der Routine setzen, mit Short_Phase = 1 */
function finalPal(e: LevelEngine, pal: number): void {
  const { V } = e;
  e.setL(V.routPalPtr, pal);
  e.setB(V.refreshPal + 1, 0xff);
  e.setW(V.shortPhase, 1);
}

/**
 * .cont2: alle 70 Durchläufe eine Kugelwelle (Reihenfolge Step_1, Step_2, Step_3: R_T_Final_1 bei x 256 + 260,
 * R_T_Final_2 und _3 bei x 256 + 268; y 256 + 108 bzw. 256 + 100); die Bank landet in R_F_AWO_Ptr3, _2 bzw. _1
 */
function finalWaves(e: LevelEngine, a3: number, d: FinalDef): void {
  const { V, ram } = e;
  const time = (ram.word(a3 + F_TIME) + 1) & 0xffff;
  ram.setWord(a3 + F_TIME, time);
  if (time !== 70) return;
  ram.setWord(a3 + F_TIME, 0);
  const step = ram.word(a3 + F_STEP);
  if (step === 0) {
    ram.setWord(a3 + F_STEP, 1);
    e.setL(V.rFAwoPtr3, launchWave(e, (d.wave1 | 0x40000000) >>> 0, 256 + 260, 256 + 108));
  } else if (step === 1) {
    ram.setWord(a3 + F_STEP, 2);
    e.setL(V.rFAwoPtr2, launchWave(e, (d.wave2 | 0x40000000) >>> 0, 256 + 268, 256 + 108));
  } else {
    ram.setWord(a3 + F_STEP, 0);
    e.setL(V.rFAwoPtr1, launchWave(e, (d.wave3 | 0x40000000) >>> 0, 256 + 268, 256 + 100));
  }
}

// R_Final (Level 2): Variablen +0 R_F_Mode, +2 R_F_Step, +4 R_F_Explo_Step, +6 R_F_X_Mode, +8 R_F_Anim_Delay,
// +10 R_F_Anim_Up_Step, +12 R_F_Launch_Delay
const FF_STEP = 2;
const FF_EXPLO = 4;
const FF_X_MODE = 6;
const FF_ANIM_DELAY = 8;
const FF_ANIM_UP = 10;
const FF_LAUNCH = 12;

/**
 * R_Final von Level 2: zwei Gegner in der Bank an derselben Stelle (Start x 256 + 350, y 256 + 130), das Oberteil
 * (Obj_Final_1, Energie 150, Schussrate 20) und das Unterteil (Obj_Final_Bas_1, Energie 20000, ohne Schüsse);
 * Rout_Mod_Pal_Counter wird gelöscht, eine eigene Palette gibt es nicht. Beide pendeln mit 2 Pixeln je Durchlauf
 * zwischen x ≤ 256 + 160 und x ≥ 256 + 260 (R_F_X_Mode 0 = nach links, −1 = nach rechts); das Unterteil wechselt alle
 * 8 Durchläufe zwischen Obj_Final_Bas_1 und _2, das Oberteil zeigt reihum R_F_Anim_Up. Solange das Oberteil lebt,
 * wirft es alle 18 Durchläufe eine Bumerangwelle (reihum R_T_Final_2 … _6, _1, absolute Bahn) bei (x − 20, y − 20).
 * Zerstört (unteres Halbbyte des Status) stehen beide still und explodieren in Schritten: 1 Big_Explo_1 an beiden
 * (Quit_Delay = 100), 21 nur das Oberteil mit Short_Phase = 1 und Geräusch, 35 Big_Explo_2 und 52 Big_Explo_3 an
 * beiden mit Geräusch, 52 zusätzlich Clean_Up (Levelende). Anders als in Level 1 laufen die Wellen weiter, kein
 * Löschen des vorderen Playfields. Abweichungen des Abbilds vom Quelltext (wie in Level 1): Schussrate 20 statt 30,
 * Quit_Delay = 100 schon in Schritt 1 statt 25 in Schritt 52. Quelle: Ag_Game_LFORET.s, Label R_Final; Abbild
 * $4C39E–$4C656, R_T_Final_1–6 $4C2B6, R_T_Table $4C376, R_F_Anim_Up $4C38E.
 */
function finalForet(e: LevelEngine, a0: number, d: FinalForetDef): void {
  const { V, ram } = e;
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  const a4 = a2 + AWO_LEN;
  const mode = ram.word(a3);
  ram.setLong(bank, 0x00020000);
  if (mode === 0) {
    for (const p of [a2, a4]) {
      ram.setWord(p + AWO_X, 256 + 350);
      ram.setWord(p + AWO_Y, 256 + 130);
    }
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a4 + AWO_OBJ_OFF, d.bas1);
    ram.setWord(a2 + AWO_ENERGY, 150);
    ram.setWord(a4 + AWO_ENERGY, 20000);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setLong(a4 + AWO_STATUS, 0);
    ram.setByte(a2 + AWO_F_RT_S, 20);
    ram.setByte(a4 + AWO_F_RT_S, 0xff);
    e.setW(V.routModPalCounter, 0);
    ram.setWord(a3 + FF_X_MODE, 0);
    ram.setWord(a3, 1);
    return;
  }
  if (mode !== 2) {
    // Pendeln: R_F_X_Mode ≠ 0 nach rechts bis x ≥ 256 + 260 (dann +1 → 0), sonst nach links bis x ≤ 256 + 160
    const right = ram.word(a3 + FF_X_MODE) !== 0;
    const dx = right ? 2 : -2;
    ram.setWord(a2 + AWO_X, (ram.word(a2 + AWO_X) + dx) & 0xffff);
    ram.setWord(a4 + AWO_X, (ram.word(a4 + AWO_X) + dx) & 0xffff);
    const x = s16(ram.word(a2 + AWO_X));
    if (right ? x >= 256 + 260 : x <= 256 + 160) {
      ram.setWord(a3 + FF_X_MODE, (ram.word(a3 + FF_X_MODE) + (right ? 1 : -1)) & 0xffff);
    }
    const delay = (ram.word(a3 + FF_ANIM_DELAY) + 1) & 0xffff;
    ram.setWord(a3 + FF_ANIM_DELAY, delay);
    ram.setWord(a4 + AWO_OBJ_OFF, (delay & 8) !== 0 ? d.bas1 : d.bas2);
    const up = (ram.word(a3 + FF_ANIM_UP) + 1) & 7;
    ram.setWord(a3 + FF_ANIM_UP, up);
    ram.setWord(a2 + AWO_OBJ_OFF, ram.word(d.animUp + 2 * up));
    if ((ram.byte(a2 + AWO_STATUS) & 0xf) === 0) {
      finalForetWave(e, a3, a2, d);
      return;
    }
    ram.setWord(a3 + FF_EXPLO, 0);
    ram.setWord(a3, (mode + 1) & 0xffff);
  }
  // .explo
  const step = (ram.word(a3 + FF_EXPLO) + 1) & 0xffff;
  ram.setWord(a3 + FF_EXPLO, step);
  if (step === 1) {
    e.setW(V.quitDelay, 100);
    finalForetExplo(e, a2, d.explo1);
    finalForetExplo(e, a4, d.explo1);
  } else if (step === 21) {
    finalForetExplo(e, a2, d.explo1);
    e.setW(V.shortPhase, 1);
    soundStart(e, 1, 63);
  } else if (step === 35 || step === 52) {
    const obj = step === 35 ? d.explo2 : d.explo3;
    finalForetExplo(e, a2, obj);
    finalForetExplo(e, a4, obj);
    soundStart(e, 1, 63);
    if (step === 52) e.setB(V.cleanUp, 0xff);
  }
}

/** Explosionsbild, Status 1 (Position bleibt) */
function finalForetExplo(e: LevelEngine, p: number, obj: number): void {
  const { ram } = e;
  ram.setWord(p + AWO_OBJ_OFF, obj);
  ram.setLong(p + AWO_STATUS, 0);
  ram.setByte(p + AWO_STATUS, 1);
}

/** .cont5: alle 18 Durchläufe die nächste Bumerangwelle aus R_T_Table (R_F_Step 1–5, 0) bei (x − 20, y − 20) */
function finalForetWave(e: LevelEngine, a3: number, a2: number, d: FinalForetDef): void {
  const { ram } = e;
  const delay = (ram.word(a3 + FF_LAUNCH) + 1) & 0xffff;
  ram.setWord(a3 + FF_LAUNCH, delay);
  if (delay !== 18) return;
  ram.setWord(a3 + FF_LAUNCH, 0);
  let step = (ram.word(a3 + FF_STEP) + 1) & 0xffff;
  if (step === 6) step = 0;
  ram.setWord(a3 + FF_STEP, step);
  const aws = ram.long(d.waves + 4 * step);
  launchWave(e, (aws | 0x40000000) >>> 0, (ram.word(a2 + AWO_X) - 20) & 0xffff, (ram.word(a2 + AWO_Y) - 20) & 0xffff);
}

/**
 * R_Jumper (Level 3): erscheint rechts am Boden (x 256 + 340, y 256 + 190, Energie 5) und läuft 2 Pixel je Durchlauf
 * nach links, bis er höchstens 128 Pixel rechts der Eule steht (Sorcerer_X + 128 ≥ x). Dann springt er: je Durchlauf
 * 6 Pixel nach links und 8 nach oben, bis y ≤ 240; CLOSE ohne Zählerabzug. Variablen: +0 Modus (0 Start, 1 Laufen,
 * 2 Sprung). Quelle: AG_GAME_LMARAIS.S, Label R_Jumper; Abbild $4FCD0–$4FD6E (marshes).
 */
function jumperMarais(e: LevelEngine, a0: number, d: JumperMaraisDef): void {
  const { V, ram } = e;
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  const mode = ram.word(a3);
  ram.setLong(bank, 0x00010000);
  if (mode === 0) {
    ram.setWord(a2 + AWO_X, 256 + 340);
    ram.setWord(a2 + AWO_Y, 256 + 190);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj1);
    ram.setWord(a2 + AWO_ENERGY, 5);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3, 1);
    return;
  }
  const x = (ram.word(a2 + AWO_X) - 2) & 0xffff;
  ram.setWord(a2 + AWO_X, x);
  if (mode === 1) {
    // cmp AWO_Alien_X(a2),d1 / blt .end
    if (s16((e.w(V.sorcererX) + 128) & 0xffff) < s16(x)) return;
    ram.setWord(a3, 2);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj2);
    return;
  }
  ram.setWord(a2 + AWO_OBJ_OFF, d.obj3);
  const y = (ram.word(a2 + AWO_Y) - 8) & 0xffff;
  ram.setWord(a2 + AWO_Y, y);
  ram.setWord(a2 + AWO_X, (x - 4) & 0xffff);
  if (s16(y) <= 240) close(e, a0, bank, false);
}

/**
 * R_Sol_Kamikaze (AG_GAME_LMARAIS.S, „SOL FONSSE SUR LE PERSO“): läuft am Boden 2 Pixel je Durchlauf nach links und
 * wechselt jedes Mal die Form (R_SK_Shape, 6 Schritte). Steht die Eule tief (Sorcerer_Y ab 256+120), stürmt es los:
 * ab dem nächsten Durchlauf 10 Pixel. Ende bei x 220 (geprüft auch im Start-Durchlauf). Variablen: +0 R_SK_Mode
 * (0 Start, 1 Laufen, 2 Sturm), +2 R_SK_Shape_Num. Ohne eigene Palette und ohne Rout_Mod_Pal_Counter.
 */
function solKamikaze(e: LevelEngine, a0: number, d: SolKamikazeDef): void {
  const { V, ram } = e;
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  const mode = ram.word(a3);
  ram.setLong(bank, 0x00010000);
  if (mode === 0) {
    // Quelle: AG_GAME_LMARAIS.S, Label R_Sol_Kamikaze (Abbild $4FD8E–$4FDB0)
    ram.setWord(a2 + AWO_X, 256 + 340);
    ram.setWord(a2 + AWO_Y, 256 + 190);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 3);
    ram.setLong(a2 + AWO_STATUS, 0);
    ram.setWord(a3, 1);
  } else {
    let n = (ram.word(a3 + 2) + 1) & 0xffff;
    if (n === 6) n = 0;
    ram.setWord(a3 + 2, n);
    ram.setWord(a2 + AWO_OBJ_OFF, ram.word(d.shape + 2 * n));
    ram.setWord(a2 + AWO_X, (ram.word(a2 + AWO_X) - 2) & 0xffff);
    if (mode === 1) {
      // cmp #256+120,d1 / blt .end
      if (s16(e.w(V.sorcererY)) >= 256 + 120) ram.setWord(a3, 2);
    } else {
      ram.setWord(a2 + AWO_X, (ram.word(a2 + AWO_X) - 8) & 0xffff);
    }
  }
  if (s16(ram.word(a2 + AWO_X)) <= 220) close(e, a0, bank, false);
}

// R_Final (Level 3): Variablen +0 R_F_Mode, +2 R_F_Langue_Delay (wird wegen eines Fehlers nicht benutzt, siehe
// FM_LANGUE_DELAY), +4 R_F_Langue_Step, +6 R_F_Shape
const FM_LANGUE_STEP = 4;
const FM_SHAPE = 6;
/**
 * `addq #1,R_F_langue_Delay` ohne `(a3)`: Der Zähler der Zunge liegt an der absoluten Adresse $2 (Wert des
 * RS-Versatzes), nicht in den Variablen der Routine (O-016). Er wird nur hier geändert und beim Levelstart nicht gelöscht
 * (Quelle: AG_GAME_LMARAIS.S, Label .cont7; Abbild $4FF50 `addq.w #$1, $2.l`). Im Nachbau beginnt er wie im ersten
 * Spiel nach dem Einschalten bei 0 (Speicherabzüge des Emulators: $0–$3 = 0).
 */
const FM_LANGUE_DELAY = 2;

/**
 * R_Final von Level 3: ein Gegner (x 256 + 300, y 256 + 80, Energie 170, Schussrate 12, keine eigene Palette, kein
 * Rout_Mod_Pal_Counter), der reihum die 10 Bilder aus Final_Shape zeigt (je Durchlauf eins). R_F_Mode 1: Er hält mit
 * 2 Pixeln je Durchlauf auf (Eule x + 150, y + 40) zu (wie R_Kamikaze); alle 50 Durchläufe (Zähler bei $2) streckt er
 * die Zunge aus: zweiter Gegner der Bank bei (x − 140, y), Obj_Langue_1, Energie 100, Status 0 (schießt nicht).
 * R_F_Mode 2: Er steht, die Zunge zeigt die 26 Bilder aus Langue_Shape, im 27. Durchlauf noch einmal das letzte (die
 * Bank zählt dann noch 2 Gegner), danach wieder Modus 1. Ist der
 * Endgegner getroffen (unteres Halbbyte des Status ≠ 0, Explosion läuft), verschwindet die Zunge sofort (eine Bank mit
 * 1 Gegner); er folgt der Eule weiter, bis die Explosion endet (Halbbyte $F): dann CLOSE, Quit_Delay = 25 und
 * Clean_Up (Levelende). Eigenheit des Originals: In Modus 2 setzt `move.b #1,Awo_Alien_Status(a4)` bei getroffenem
 * Endgegner nicht die Zunge, sondern das Byte Final_Shape + 8 (O-017) (a4 zeigt noch auf Final_Shape); dort steht schon $01
 * (Obj_Final_5 = $011A), es ändert sich also nichts. Quelle: AG_GAME_LMARAIS.S, Abschnitt „MONSTRE FINAL“, Label
 * R_Final; Abbild $4FE74–$4FFFE (gleich dem Quelltext), Final_Shape $4FE2C, Langue_Shape $4FE40.
 */
function finalMarais(e: LevelEngine, a0: number, d: FinalMaraisDef): void {
  const { V, ram } = e;
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  const mode = ram.word(a3);
  ram.setLong(bank, 0x00010000);
  if (mode === 0) {
    ram.setWord(a2 + AWO_X, 256 + 300);
    ram.setWord(a2 + AWO_Y, 256 + 80);
    ram.setWord(a2 + AWO_OBJ_OFF, d.obj);
    ram.setWord(a2 + AWO_ENERGY, 170);
    ram.setLong(a2 + AWO_STATUS, 0x000c0000);
    ram.setWord(a3, 1);
    return;
  }
  let shape = (ram.word(a3 + FM_SHAPE) + 2) & 0xffff;
  if (shape === 20) shape = 0;
  ram.setWord(a3 + FM_SHAPE, shape);
  ram.setWord(a2 + AWO_OBJ_OFF, ram.word(d.shape + shape));
  const a4 = a2 + AWO_LEN;
  if ((ram.byte(a2 + AWO_STATUS) & 0xf) === 0xf) {
    // .close
    ram.setLong(a0, 0xffffffff);
    ram.setWord(bank, 0xffff);
    e.setW(V.quitDelay, 25);
    e.setB(V.cleanUp, 0xff);
    return;
  }
  if (mode === 2) {
    if ((ram.byte(a2 + AWO_STATUS) & 0xf) !== 0) {
      ram.setByte(d.shape + AWO_STATUS, 1); // a4 = Final_Shape (siehe oben)
      ram.setWord(a3, (mode - 1) & 0xffff);
      return;
    }
    ram.setLong(bank, 0x00020000);
    const step = (ram.word(a3 + FM_LANGUE_STEP) + 2) & 0xffff;
    ram.setWord(a3 + FM_LANGUE_STEP, step);
    if (step === 52) {
      ram.setWord(a3, (mode - 1) & 0xffff);
      return;
    }
    ram.setWord(a4 + AWO_OBJ_OFF, ram.word(d.langue + step));
    return;
  }
  approach(e, a2 + AWO_X, (e.w(V.sorcererX) + 150) & 0xffff, 2);
  approach(e, a2 + AWO_Y, (e.w(V.sorcererY) + 40) & 0xffff, 2);
  const delay = (ram.word(FM_LANGUE_DELAY) + 1) & 0xffff;
  ram.setWord(FM_LANGUE_DELAY, delay);
  if (delay !== 50) return;
  ram.setWord(FM_LANGUE_DELAY, 0);
  ram.setLong(bank, 0x00020000);
  ram.setWord(a4 + AWO_X, (ram.word(a2 + AWO_X) - 140) & 0xffff);
  ram.setWord(a4 + AWO_Y, ram.word(a2 + AWO_Y));
  ram.setWord(a4 + AWO_OBJ_OFF, d.objLangue);
  ram.setWord(a4 + AWO_ENERGY, 100);
  ram.setLong(a4 + AWO_STATUS, 0);
  ram.setWord(a3, (mode + 1) & 0xffff);
  ram.setWord(a3 + FM_LANGUE_STEP, 0xfffe);
}

// R_Colonne_Flamme: Variablen +0 R_CF_Mode, +2–+8 R_CF_Shape_Num_0–3, +10 R_CF_Hight_Num, +12 R_CF_Hight_Delay
const CF_SHAPE_NUM = 2;
const CF_HIGHT_NUM = 10;
const CF_HIGHT_DELAY = 12;

/**
 * R_Colonne_Flamme (AG_GAME_LMONTAGNES.S, „COLONNE DE FLAMME“): 4 Gegner übereinander (x 256 + 360, y 256 + 190,
 * je 35 Pixel höher, Obj_Grande_Flamme_1, Energie 32767, schießen nicht), die mit dem Boden 2 Pixel je Durchlauf nach
 * links wandern und reihum die 8 Bilder aus R_CF_Shape zeigen (jeden Durchlauf das übernächste). Alle 3 Durchläufe
 * setzt der nächste Wert aus R_CF_Hight das Kopfwort der Bank, also wie viele Flammen von unten sichtbar sind
 * (1, …, 2, 3, 4, …, 3, 2). Ende, wenn die unterste Flamme x 200 erreicht (geprüft auch im Start-Durchlauf). Ohne
 * eigene Palette und ohne Rout_Mod_Pal_Counter.
 * Eigenheit des Originals (O-018): `move.l #…,R_CF_Shape_Num_0` bzw. `R_CF_Shape_Num_2` ohne `(a3)` schreibt die
 * Startphasen 0, 2, 4, 6 an die absoluten Adressen $2–$9 statt in die Variablen; diese sind beim START_C gelöscht,
 * alle 4 Flammen zeigen also stets dasselbe Bild. Quelle: AG_GAME_LMONTAGNES.S, Label R_Colonne_Flamme; Abbild
 * $4C276–$4C366 (gleich dem Quelltext: `move.l #$2, $2.l`, `move.l #$40006, $6.l`), R_CF_Shape $4C246, R_CF_Hight
 * $4C256.
 */
function colonneFlamme(e: LevelEngine, a0: number, d: ColonneFlammeDef): void {
  const { ram } = e;
  const bank = ram.long(a0 + ROUT_AWO_PTR);
  const a3 = a0 + ROUT_VARIABLES;
  const a2 = bank + 4;
  if (ram.word(a3) === 0) {
    ram.setLong(bank, 0x00010000);
    for (let i = 0, a4 = a2, y = 256 + 190; i < 4; i++, a4 += AWO_LEN, y -= 35) {
      ram.setWord(a4 + AWO_X, 256 + 360);
      ram.setWord(a4 + AWO_Y, y);
      ram.setWord(a4 + AWO_OBJ_OFF, d.obj);
      ram.setWord(a4 + AWO_ENERGY, 32767);
      ram.setLong(a4 + AWO_STATUS, 0);
    }
    // O-018: absolute Adressen statt R_CF_Shape_Num_0–3(a3)
    ram.setLong(2, 0x00000002);
    ram.setLong(6, 0x00040006);
    ram.setWord(a3, 1);
    ram.setWord(a3 + CF_HIGHT_NUM, 0);
    ram.setWord(a3 + CF_HIGHT_DELAY, 0);
  } else {
    for (let i = 0, a4 = a2; i < 4; i++, a4 += AWO_LEN) {
      const n = a3 + CF_SHAPE_NUM + 2 * i;
      const shape = (ram.word(n) + 2) & 0xf;
      ram.setWord(n, shape);
      ram.setWord(a4 + AWO_OBJ_OFF, ram.word(d.shape + shape));
      ram.setWord(a4 + AWO_X, (ram.word(a4 + AWO_X) - 2) & 0xffff);
    }
    const delay = ram.word(a3 + CF_HIGHT_DELAY) + 1;
    ram.setWord(a3 + CF_HIGHT_DELAY, delay);
    if (delay === 3) {
      ram.setWord(a3 + CF_HIGHT_DELAY, 0);
      const hight = (ram.word(a3 + CF_HIGHT_NUM) + 2) & 0x1f;
      ram.setWord(a3 + CF_HIGHT_NUM, hight);
      ram.setWord(bank, ram.word(d.hight + hight));
    }
  }
  if (s16(ram.word(a2 + AWO_X)) <= 200) close(e, a0, bank, false);
}
