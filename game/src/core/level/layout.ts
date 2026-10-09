// Adressen eines Level-Abbilds (E-032). Jedes Level ist für sich assembliert (ORG $600), deshalb liegen Daten,
// Copperliste und Variablen in jedem Level an anderen Stellen. Werte für Level 1 aus der Disassembly von sea
// (work/disasm/sea_code.txt), abgeglichen mit Agony_Parent_.s, Ag_Back_Scroll.s, Ag_Copper_List.s und Ag_Sprites.s.
// Wiki: dateiformate.md „Adressen im Abbild sea“.

import { MUSIC_TIMING_SEA } from "../../data/timing/music-sea.ts";
import type { RoutineDef } from "./routines.ts";
import type { MusicTiming } from "./timing.ts";

/** Versätze der Variablen zum Register a5 (D = Rel_Start + 32768) */
export interface LevelVars {
  genPhase: number; // Gen_25hz_Phase
  curBackBuild: number; // Cur_Back_Build (L)
  curBackShow: number; // Cur_Back_Show (L)
  curFrontBuild: number; // Cur_Front_Build (L)
  curFrontShow: number; // Cur_Front_Show (L)
  restScreenPtr: number; // Rest_Screen_Ptr (L)
  backPhase: number; // Back_Phase
  backConfig: number; // Back_Config
  patPtr: number; // Pat_Ptr (L)
  /** Pat0: Ptr_Stat (L), Ptr_Dyn (L), Dly_Count (W), Frm_Ptr (L); Pat1 und Pat2 folgen im Abstand von 14 Byte */
  pat0: number;
  backShift: number; // Back_Shift
  frontShift: number; // Front_Shift
  frontShiftPhase: number; // Front_Shift_Phase
  refreshFrame: number; // Refresh_Frame
  skyCount: number; // Sky_Count
  backOldOff: number; // Back_Old_Off
  frontPhase: number; // Front_Phase
  frontReadPtr: number; // Front_Read_Ptr (L)
  frontPalPtr: number; // Front_Pal_Ptr (L)
  frontPalCount: number; // Front_Pal_Count
  safeDestOff: number; // Safe_Dest_Off
  safeDestPtr: number; // Safe_Dest_Ptr (L)
  safeSrcPtr: number; // Safe_Src_Ptr (L)
  sorcererX: number; // Sorcerer_X
  sorcererY: number; // Sorcerer_Y
  sorcererShape: number; // Sorcerer_Shape
  sorcererDelay: number; // Sorcerer_Delay
  axeUpX: number; // Axe_Up_X
  axeUpY: number; // Axe_Up_Y
  axeDownX: number; // Axe_Down_X
  axeDownY: number; // Axe_Down_Y
  axeDelay: number; // Axe_Delay
  axeMove: number; // Axe_Move
  oldScore: number; // Old_Score (L)
  point: number; // Point (L)
  spellTime: number; // Spell_Time (BCD, Sekunden)
  oldSpellTime: number; // Old_Spell_Time
  oldLife: number; // Old_Life
  fwFireStep: number; // Fw_Fire_Step
  fwFirePhase: number; // Fw_Fire_Phase
  fwFireOff: number; // Fw_Fire_Off
  key: number; // Key
  keyUpFlag: number; // Key_Up_Flag
  pause: number; // Pause
  pause2: number; // Pause2
  prgPause: number; // Prg_Pause
  stop: number; // Stop
  stop2: number; // Stop2
  textNum: number; // Text_Num
  oldTextNum: number; // Old_Text_Num
  textDelay: number; // Text_Delay
  refreshStatus: number; // Refresh_Status
  statusDelay: number; // Status_Delay
  iconesMode: number; // Icones_Mode
  fireCount: number; // Fire_Count
  iconesOff: number; // Icones_Off
  curentSpell: number; // Curent_Spell (Wort; unteres Byte $FF = kein Zauber)
  spellTimeDelay: number; // Spell_Time_Delay: Bilder bis zur nächsten Sekunde
  rainXOff0: number; // Rain_X_Off0
  rainXOff1: number; // Rain_X_Off1
  dmTa: number; // Dm_Ta: Bytes, die beim Clipping rechts/links im Ziel übersprungen werden
  apTa: number; // Ap_Ta (L): Versatz in der Quelle beim Clipping
  mbl: number; // Mbl: oben abgeschnittene Zeilen
  bmTa: number; // Bm_Ta: Modulo-Zuschlag der Quelle
  sTs: number; // S_Ts: Abzug von BLTSIZE (Zeilen · 64 + Wörter)
  curentAwoPtr: number; // Curent_AWO_Ptr (L)
  alienAwoCount: number; // Alien_AWO_Count
  curentAlienNum: number; // Curent_Alien_Num
  curentBankPtr: number; // Curent_Bank_Ptr (L)
  startListPtr: number; // Start_List_Ptr (L)
  levelX: number; // Level_X
  slWaiting: number; // Sl_Waiting
  refreshPal: number; // Refresh_Pal
  vdoSInc: number; // Vdo_S_Inc
  flashPhase: number; // Flash_Phase
  curExploState: number; // Cur_Explo_State
  oldVpos: number; // Old_Vpos
  shortPhase: number; // Short_Phase
  rainOn: number; // Rain_On
  sorcerer2Shape: number; // Sorcerer2_Shape
  sorcererOn: number; // Sorcerer_On
  die: number; // Die
  dieMode: number; // Die_Mode: 0 = Explosion vorbereiten, 1 = Teile fliegen
  dieX: number; // Die_X: Ursprung der Teile (Sprite-Koordinaten)
  dieY: number; // Die_Y
  routPalPtr: number; // Rout_Pal_Ptr (L)
  routModPalCounter: number; // Rout_Mod_Pal_Counter
  bonusMode: number; // Bonus_Mode
  bonusDelay: number; // Bonus_Delay
  bonusX: number; // Bonus_X
  bonusY: number; // Bonus_Y
  /** Spr0ptB … Spr7ptB (je L) */
  sprPtrB: number;
  sound0: number; // Sound0: angeforderter Effekt (−1 = keiner)
  sound0b: number; // Sound0_b: zu startender Effekt
  sound0Req: number; // Sound0_Req
  sound0Vol: number; // Sound0_Vol
  sound0VolReq: number; // Sound0_Vol_Req
  sound0IntStep: number; // Sound0_Int_Step
  sound0LastPri: number; // Sound0_Last_Pri (Byte)
  quitDelay: number; // Quit_Delay
  /** $7CCC: wird beim Aufräumen gesetzt ($39CA), im Quelltext-Stand ohne Namen an dieser Stelle */
  afOff: number;
  beginToStart: number; // Begin_To_Start
  btsDelay: number; // BTS_Delay
  cleanUp: number; // Clean_Up
  /** R_F_AWO_Ptr1–3: AWO-Bänke der Wellen des Endgegners (R_Final) */
  rFAwoPtr1: number;
  rFAwoPtr2: number;
  rFAwoPtr3: number;
  /** Bonus_Anim, Bonus_Num (Bonus_Mode/_Delay/_X/_Y stehen oben) */
  bonusAnim: number;
  bonusNum: number;
  /** Spell_Pri (8 Wörter), Bonus_Shape (4 Wörter, Versatz in Bonus_Spr), Bonus_Image (4 Wörter) */
  spellPri: number;
  bonusShape: number;
  bonusImage: number;
  /**
   * „Spr6pt(D)“/„Spr7pt(D)“: Im Quelltext Versätze der Custom-Register SPR6PT/SPR7PT ($DFF138/$13C), beim Schließen
   * des Bonus aber relativ zu a5 geschrieben – das Original schreibt dort in den Speicher (Eigenheit, nachgebildet)
   */
  spr6pt: number;
  spr7pt: number;
  /**
   * Zaubermenü (ICONES SPRITES $49C2): Pfeil (y, runter, hoch), gemerkter Zauber, Feuer losgelassen, Auswahl auf einem
   * Zauber; Tabellen: Icones_Pal (16 Farben), Icones_Spr (4 Sprites à 768 Byte), Arow_Spr, Mask_Spr, Time_Table
   */
  arowY: number;
  arowDown: number;
  arowUp: number;
  safeCurSpell: number;
  iconesFireUp: number;
  selectionOn: number;
  iconesPal: number;
  iconesSpr: number;
  arowSpr: number;
  maskSpr: number;
  timeTable: number;
  /** Sorcerer2_X/Y: Position der zweiten Eule (Zauber 3 SEEKER) */
  sorcerer2X: number;
  sorcerer2Y: number;
  /** Zauber 0 BACK FIRE BALL: Back_FB_X0/X1, Back_FB_Spr0/1 */
  backFbX0: number;
  backFbX1: number;
  backFbSpr0: number;
  backFbSpr1: number;
  /** Zauber 1 ROTATIVE FIRE BALL: Rot_Step, Rot_Table, FBall_3spr0/1 (auch Zauber 7: FW_FB_Spr0/1) */
  rotStep: number;
  rotTable: number;
  fball3Spr0: number;
  fball3Spr1: number;
  /** Zauber 2 STOP TIME: Time_Y, Time_Step, Time_Y_Table, Time_Spr */
  timeY: number;
  timeStep: number;
  timeYTable: number;
  timeSpr: number;
  /** Zauber 4 SMART BOMB: Smart_B_X, Smart_B_Step, Smart_B_StepH, Smart_B_StepHC, Smart_B_Spr */
  smartBX: number;
  smartBStep: number;
  smartBStepH: number;
  smartBStepHC: number;
  smartBSpr: number;
  /** Zauber 5 MEGA BLAST: Mega_B_X, Mega_B_Spr (4 Sprites à $25C Byte) */
  megaBX: number;
  megaBSpr: number;
  /** Zauber 7 FORWARD FIRE BALL: Fw_FB_X0/X1, Sin_Table (Bytes) */
  fwFbX0: number;
  fwFbX1: number;
  sinTable: number;
  /** Wert von BPLCON0 in der Copperliste (Pause setzt Bit 2, LACE) */
  clBplCon0: number;
}

export interface LevelLayout {
  /** Spieldatei des Levels (Schlüssel für Speicherblöcke und Sprachtabellen), z. B. "sea" */
  file: string;
  /** Schlüssel der Speicherblöcke im Manifest */
  blocks: readonly string[];
  /** Laufzeit des Musiktreibers je Bild für das Zeitmodell (E-035) */
  musicTiming?: MusicTiming;
  /** Register a5 (D) */
  d: number;
  vars: LevelVars;

  // Daten
  sorcererDat: number;
  /** Eule mit Schild (Zauber 6): Kopf je Phase (y1, Höhe, Versätze der Listen für Sprite 6 und 7) */
  sorcerer2Dat: number;
  sorcererPal: number;
  emptySpr: number;
  /** Bonus_Spr: Sprites der Bonusse (Bonusses.bin), je Bild zwei Sprites à 200 Byte, zweites Animationsbild +400 */
  bonusSpr: number;
  /** Tod der Eule: 8 Wortversätze auf Bahnen (Bytepaare dx, dy, Ende $80), Zeiger je Teil, 8 Sprites à 33 Langwörter */
  dieTable: number;
  dieDynPtr: number;
  dieSpr: number;
  axeTraj: number;
  alienFireSpr: number;
  afStruct: number;
  awoStruct: number;
  awoStructEnd: number;
  routStruct: number;
  goodColList: number;
  skyDat: number;
  backCharset: number;
  backFrame: number;
  backPattern: number;
  backCharInfo: number;
  readTable: number;
  backOldChar: number;
  x60: number;
  writeTable: number;
  skyAnimTable: number;
  /** Anzahl der Himmelsphasen (Level 5: 10, sonst 1; Quelle: Ag_Back_Scroll.s „TRANSFER 1/2 OF SKY“) */
  skyPhases: number;
  frontMap: number;
  frontPal: number;
  frontCharset: number;
  /** Front_Pal_Buffer: 6 Bänder × 7 Farben des vorderen Playfields */
  frontPalBuffer: number;
  /** Front_Table: Versatz der 6 Kachelzeilen (32 Zeilen) im Bild */
  frontTable: number;
  /** X384: Versatz jeder Kachel im Front_Charset (3 Planes à 128 Byte) */
  x384: number;
  frontMask: number;
  trackTable: number;
  /**
   * Objekt-Routinen des Level-Moduls (START_C): Adresse der Routine im Abbild → Umsetzung mit den Werten, die im
   * Code des Levels stehen (Paletten, Animationen, Objektnummern)
   */
  routines: ReadonlyMap<number, RoutineDef>;
  /** Bahntabellen (TX_…/TY_…) der relativen und absoluten Bahnen, Animationstabelle (Anim_Base) */
  relativeTracks: number;
  absoluteTracks: number;
  animBase: number;
  /** Objects_Struct: je Objekt Wort Versatz der Trefferrechtecke, Schussursprung (2 Byte), Teilbilder */
  objectsStruct: number;
  /** Sprites_Struct (26 Byte je Eintrag), Anzahl der Einträge, Bitmaps und Masken der Teilbilder */
  spritesStruct: number;
  spritesCount: number;
  spritesBitmap: number;
  spritesMask: number;
  /** Routinentabellen (12 Typen): Blit, Maske, vertikales und horizontales Clipping */
  blitRoutines: number;
  maskRoutines: number;
  vcRoutines: number;
  hcRoutines: number;
  /** Maske eines 3-Farben-Teilbilds beim horizontalen Clipping */
  cBlitMaskBuff: number;
  /** X44: Zeilenversätze (44 Byte), Masken für das erste/letzte Wort, Teilbilder der Explosion */
  x44: number;
  fwmConv: number;
  lwmConv: number;
  exploSprList: number;
  /** Byte_Sort der Gegnerschüsse: Zähler (200), Versätze (201), Reihenfolge (32), AF_Lfo (8 Wörter) */
  bsCount: number;
  bsOffset: number;
  bsOrder: number;
  afLfo: number;
  /** Priorität je Soundeffekt */
  soundPri: number;
  startList: number;
  /** Regen (Sprite 6/7) vorhanden: nur Level 1 setzt Rain_On ($A56) und hat RAIN im Copper-Interrupt */
  rain: boolean;
  rainXTable: number;
  rainSpr0: number;
  rainSpr1: number;
  statusScreenDisp: number;
  statusScreen: number;
  statusDigit: number;
  textDat: number;

  // Copperliste (Adresse des Werts im MOVE-Befehl, bei Zeigern des High-Worts; Low-Wort 4 Byte dahinter)
  mainCl: number;
  clFlipPhase0: number;
  clFlipPhase1: number;
  clFlipJump0: number;
  clFlipJump1: number;
  sprPtr: number;
  backPtr: number;
  statusPtr: number;
  frontPtr: number;
  videoShift: number;
  skyPtr0: number;
  /** Sky_Ptr1–5 je für beide Flacker-Hälften [f0, f1] */
  skyPtr: readonly (readonly [number, number])[];
  backColor0: number;
  /** Back_Color1–5 je [f0, f1] */
  backColor: readonly (readonly [number, number])[];
  /** Fr_Color0a_f0 (6 Farben im Abstand 4) und Fr_Color0b_f0 (7. Farbe) für Band 0 */
  frontColor0: readonly [number, number];
  /** Bänder 1–5: [6 Farben f0, 6 Farben f1, 7. Farbe f0, 7. Farbe f1] */
  frontColor: readonly (readonly [number, number, number, number])[];

  // Laufzeitpuffer
  frontScreens: number;
  backScreen0: number;
  backScreen1: number;
  clearEnd: number;
}

/** Block der gemeinsamen Variablen: $1B0 (Mem_Config) bis einschließlich Menu_Mode ($1E2, L) */
export const SHARED_START = 0x1b0;
export const SHARED_LENGTH = 0x1e6 - 0x1b0;

/** Gemeinsame Variablen ab $1B0 (Quelle: DISK/load.s „RESIDENT LABEL“, Wiki dateiformate.md) */
export const SHARED = {
  score: 0x1b4,
  life: 0x1b8,
  axeUpOn: 0x1ba,
  axeDownOn: 0x1bc,
  fwFireWeapon: 0x1be,
  extraLife: 0x1c0,
  /** Spell_Advailable: 8 Wörter, ≠ 0 = Zauber vorhanden (Bonus, Zaubermenü) */
  spellAdvailable: 0x1c4,
  /** Spell_Next_Bonus: nächster Eintrag von Spell_Pri, den ein Bonus prüft (0–7) */
  spellNextBonus: 0x1d4,
  curentCl: 0x1da,
  menuMode: 0x1e2,
} as const;

/** Level 1 – Meer (sea, Agony.09); Variablen ab a5 + $7B68 */
export const SEA: LevelLayout = {
  file: "sea",
  blocks: ["sea.sprites", "sea.sky", "sea.back", "sea.game", "sea.rel"],
  musicTiming: MUSIC_TIMING_SEA,
  d: 0x58ace, // $61E: lea $58ACE,a5
  vars: {
    genPhase: 0x7b68, curBackBuild: 0x7b6a, curBackShow: 0x7b6e, curFrontBuild: 0x7b72, curFrontShow: 0x7b76,
    restScreenPtr: 0x7b7a, backPhase: 0x7b7e, backConfig: 0x7b80, patPtr: 0x7b82, pat0: 0x7b86,
    backShift: 0x7bb0, frontShift: 0x7bb2, frontShiftPhase: 0x7bb4, refreshFrame: 0x7bb6, skyCount: 0x7bb8,
    backOldOff: 0x7bba, frontPhase: 0x7bbc, frontReadPtr: 0x7bbe, frontPalPtr: 0x7bc2, frontPalCount: 0x7bc6,
    safeDestOff: 0x7bca, safeDestPtr: 0x7bce, safeSrcPtr: 0x7bd2,
    sorcererX: 0x7bd6, sorcererY: 0x7bd8, sorcererShape: 0x7bda, sorcererDelay: 0x7bdc,
    axeUpX: 0x7bde, axeUpY: 0x7be0, axeDownX: 0x7be2, axeDownY: 0x7be4, axeDelay: 0x7be6, axeMove: 0x7be8,
    oldScore: 0x7bea, point: 0x7bee, spellTime: 0x7bf2, oldSpellTime: 0x7bf4, oldLife: 0x7bf6,
    fwFireStep: 0x7bfc, fwFirePhase: 0x7bfe, fwFireOff: 0x7c00, key: 0x7c02, keyUpFlag: 0x7c04,
    pause: 0x7c06, pause2: 0x7c08, prgPause: 0x7c0a, stop: 0x7c0c, stop2: 0x7c0e,
    textNum: 0x7c10, oldTextNum: 0x7c12, textDelay: 0x7c14, refreshStatus: 0x7c16, statusDelay: 0x7c18,
    iconesMode: 0x7c1a, fireCount: 0x7c1c, iconesOff: 0x7c1e, curentSpell: 0x7c26, spellTimeDelay: 0x7c2c,
    rainXOff0: 0x7c2e, rainXOff1: 0x7c30, dmTa: 0x7c32, apTa: 0x7c34, mbl: 0x7c38, bmTa: 0x7c3a, sTs: 0x7c3c,
    curentAwoPtr: 0x7c3e, alienAwoCount: 0x7c42, curentAlienNum: 0x7c44, curentBankPtr: 0x7c46, startListPtr: 0x7c4a, levelX: 0x7c4e, slWaiting: 0x7c50,
    refreshPal: 0x7c52, vdoSInc: 0x7c54, flashPhase: 0x7c56, curExploState: 0x7c58, oldVpos: 0x7c5c, shortPhase: 0x7c5e, rainOn: 0x7c60, sorcerer2Shape: 0x7c70,
    sorcererOn: 0x7c72, die: 0x7c82, dieMode: 0x7c84, dieX: 0x7c86, dieY: 0x7c88, routPalPtr: 0x7c8a, routModPalCounter: 0x7c8e, bonusMode: 0x7c92, bonusDelay: 0x7c94, bonusX: 0x7c96, bonusY: 0x7c98, sprPtrB: 0x7c9c,
    sound0: 0x7cbc, sound0b: 0x7cbe, sound0Req: 0x7cc0, sound0Vol: 0x7cc2, sound0VolReq: 0x7cc4, sound0IntStep: 0x7cc6,
    sound0LastPri: 0x7cc8,
    quitDelay: 0x7cca, afOff: 0x7ccc, beginToStart: 0x7cdc, btsDelay: 0x7cde, cleanUp: 0x7ce0,
    // $4FCAC/$4FD44/$4FDDC: move.l a2,$7CD0/$7CD4/$7CD8(a5)
    rFAwoPtr1: 0x7cd0, rFAwoPtr2: 0x7cd4, rFAwoPtr3: 0x7cd8,
    // BONUS ($56BA–$59D6): Bonus_Anim $7C90, Bonus_Num $7C9A, Spell_Pri −$1C08, Bonus_Shape −$1AE6, Bonus_Image −$1ADE,
    // Spr6pt/Spr7pt $138/$13C (relativ zu a5, siehe oben)
    bonusAnim: 0x7c90, bonusNum: 0x7c9a, spellPri: -0x1c08, bonusShape: -0x1ae6, bonusImage: -0x1ade, spr6pt: 0x138,
    spr7pt: 0x13c,
    // ICONES SPRITES ($49C2–$4C04) und Tastatur ($5CCC–$5EE2)
    arowY: 0x7c20, arowDown: 0x7c22, arowUp: 0x7c24, safeCurSpell: 0x7c28, iconesFireUp: 0x7c2a, selectionOn: 0x7cce,
    iconesPal: -0x2348, iconesSpr: -0x2f48, arowSpr: -0x2328, maskSpr: -0x2218, timeTable: -0x1bf8,
    // SPELL ROUTINES ($4C38–$54EA)
    sorcerer2X: 0x7c6c, sorcerer2Y: 0x7c6e, backFbX0: 0x7c64, backFbX1: 0x7c66, backFbSpr0: -0x180c, backFbSpr1: -0x1780,
    rotStep: 0x7c62, rotTable: -0x1ac6, fball3Spr0: -0x1a14, fball3Spr1: -0x1910, timeY: 0x7c80, timeStep: 0x7c7e,
    timeYTable: -0x1be8, timeSpr: 0xff4, smartBX: 0x7c74, smartBStep: 0x7c76, smartBStepH: 0x7c78, smartBStepHC: 0x7c7a,
    smartBSpr: -0x16f4, megaBX: 0x7c7c, megaBSpr: 0x680, fwFbX0: 0x7c68, fwFbX1: 0x7c6a, sinTable: -0x1a36,
    clBplCon0: 0x5fe2,
  },

  sorcererDat: 0x178c0, // $4500
  sorcerer2Dat: 0x1b8f0, // $52E8
  sorcererPal: 0x55afa, // $7C6: lea -$2FD4(a5)
  emptySpr: 0x55b22, // $4724: lea -$2FAC(a5)
  bonusSpr: 0x1f35c, // $5968: lea $1F35C,a0
  dieTable: 0x5aac6, // $5522: lea $1FF8(a5)
  dieDynPtr: 0x5b0b2, // $5526: lea $25E4(a5)
  dieSpr: 0x20190, // $55A8
  axeTraj: 0x55b26, // $4936: lea -$2FA8(a5)
  alienFireSpr: 0x1ffdc, // $5A02
  afStruct: 0x4dfc6, // $364C
  awoStruct: 0x5c67a, // $1548: lea $3BAC(a5)
  awoStructEnd: 0x5defa, // $155E
  routStruct: 0x5e5e2, // $3178: lea $5B14(a5)
  goodColList: 0x5e3c0, // $43FC: lea $58F2(a5)
  skyDat: 0x205b4, // $13DC
  backCharset: 0x21c34, // $1250
  backFrame: 0x50ace, // $10FC: lea -$8000(a5)
  backPattern: 0x526ee, // $F74: lea -$63E0(a5)
  backCharInfo: 0x52bae, // $11A6: lea -$5F20(a5)
  readTable: 0x52e92, // $11C0: lea -$5C3C(a5)
  backOldChar: 0x53342, // $11CC: lea -$578C(a5)
  x60: 0x53522, // $10F8: lea -$55AC(a5)
  writeTable: 0x53622, // $11C8: lea -$54AC(a5)
  skyAnimTable: 0x5369a, // $1402: lea -$5434(a5)
  skyPhases: 1,
  frontMap: 0x536a2, // $9F8
  frontPal: 0x5452a, // $A00: Front_Pal − 6·7·2 = $544D6
  frontCharset: 0x30f34, // $CCE
  frontPalBuffer: 0x54f56, // $2DEA: lea -$3B78(a5)
  frontTable: 0x54faa, // $CD8: lea -$3B24(a5)
  x384: 0x54fb6, // $CC6: lea -$3B18(a5)
  frontMask: 0x553b6, // $D6C: lea -$3718(a5)
  trackTable: 0x5e380, // $2DFA: lea $58B2(a5)
  // Quelle: Ag_Game_LMER.s „ROUTINES“, Adressen und Werte aus der Disassembly ab $4E9F0 (work/disasm/sea_rout.txt)
  routines: new Map<number, RoutineDef>([
    [0x4f19a, { kind: "solCrache", pal: 0x4f170, shape: 0x4f184, sin: 0x50a24, obj: 0x196, fireBall: 0x1f0 }],
    [0x4f81c, { kind: "araignee", pal: 0x4f808, obj: 0xea, yMode: 4 }],
    // Abbild $4EFC8 (Disassembly mit disasm68k.py aus sea.game.bin)
    [0x4efc8, { kind: "transporteur", pal: 0x4ef6c, shape: 0x4ef80, wave1: 0x4ef88, wave2: 0x4efa8, obj: 0x122 }],
    // Abbild $4ED70; Obj_Tir_1–8 aus den move.w #…,Awo_Alien_Obj_Off(a4) bei $4EE2C–$4EE56
    [0x4ed70, { kind: "tirEtoile", pal: 0x4ed4a, shape: 0x4ed5e, obj: 0x3f2,
      shots: [0x4d0, 0x4e2, 0x4f8, 0x50a, 0x520, 0x532, 0x548, 0x55a] }],
    // Abbild $4E9F0; Obj_Spectre_Pot $35A ($4EA24 im MODE 0), Obj_Spectre_4/5 aus MODE 3 ($4EB08–$4EB1C)
    [0x4e9f0, { kind: "spectre", pal: 0x4e9d2, shape: 0x4e9e6, pot: 0x35a, obj4: 0x3b6, obj5: 0x3d4 }],
    // Abbild $4F8EE
    [0x4f8ee, { kind: "rapide", pal: true, energy: 3 }],
    // Abbild $4EC00; Obj_Sac $BE ($4EC26), Obj_Boulle $32E ($4ECDC), Sin_Table1 $509C2 ($4ED10)
    [0x4ec00, { kind: "bomber", obj: 0xbe, bomb: 0x32e, sin: 0x509c2 }],
    // Abbild $4F696 (R_Volant_Grossi, nicht R_Jumper) und $4F75E (R_Jumper, in Level 1 nicht gestartet);
    // Obj_Grossi_1–3 = $5A8/$58E/$570 ($4F742/$4F738/$4F72E)
    [0x4f696, { kind: "volantGrossi", pal: 0x4f682, obj1: 0x5a8, obj2: 0x58e, obj3: 0x570 }],
    [0x4f75e, { kind: "jumper", pal: 0x4f74a, obj1: 0x5a8, obj2: 0x58e, obj3: 0x570 }],
    // Abbild $4F2F2; Obj_Volant_Missile_1/2 = $29E/$2B4 ($4F36C/$4F376), Obj_Tir_1–8 wie bei R_Tir_Etoile
    [0x4f2f2, { kind: "volantMissile", pal: 0x4f2de, obj1: 0x29e, obj2: 0x2b4,
      shots: [0x4d0, 0x4e2, 0x4f8, 0x50a, 0x520, 0x532, 0x548, 0x55a], shotSpeed: 3 }],
    // Abbild $4FA3A; Obj_Final $5C2 ($4FA66), Obj_Big_Explo_1–3 $5D8/$60A/$640, Front_Screens $607B2–$73F3A ($4FB3C)
    [0x4fa3a, { kind: "final", palFlash: 0x4f9fe, palNormal: 0x4fa12, palExplo: 0x4fa26, wave1: 0x4f99e,
      wave2: 0x4f9be, wave3: 0x4f9de, obj: 0x5c2, explo1: 0x5d8, explo2: 0x60a, explo3: 0x640, frontScreens: 0x607b2,
      frontScreensEnd: 0x73f3a }],
  ]),
  relativeTracks: 0x4fe22, // $2B5C
  absoluteTracks: 0x50036, // $2CBE
  animBase: 0x4e974, // $2C32
  objectsStruct: 0x4d054, // $160C: Objects_Struct + 4 = $4D058
  spritesStruct: 0x5bffa, // $1636: lea $352C(a5)
  spritesCount: 64, // $694: move.w #$3F,d2
  spritesBitmap: 0x40534, // $6C0
  spritesMask: 0x4a674, // $68A
  blitRoutines: 0x5e0fa, // $79A: lea $562C(a5)
  maskRoutines: 0x5e12a, // $78E: lea $565C(a5)
  vcRoutines: 0x5e15a, // $796: lea $568C(a5)
  hcRoutines: 0x5e18a, // $792: lea $56BC(a5)
  cBlitMaskBuff: 0x5defa, // $209C
  x44: 0x5e1ba, // $15A6: lea $56EC(a5)
  fwmConv: 0x5e33c, // $16BA: lea $586E(a5)
  lwmConv: 0x5e35e, // $173C: lea $5890(a5)
  exploSprList: 0x5e400, // $15F4: lea $5932(a5)
  bsCount: 0x5e41e, // $36D6: lea $5950(a5)
  bsOffset: 0x5e4e8, // $370E: $5A1A(a5)
  bsOrder: 0x5e5b2, // $371E: lea $5AE4(a5)
  afLfo: 0x5e5d2, // $37E6: lea $5B04(a5)
  soundPri: 0x55af6, // $5C26: lea -$2FD8(a5)
  startList: 0x4e0c6, // $9D2
  rain: true,
  rainXTable: 0x55436, // $5B1A: lea -$3698(a5)
  rainSpr0: 0x554f6, // $5B22: lea -$35D8(a5)
  rainSpr1: 0x557f6, // $5B7E: lea -$32D8(a5)
  statusScreenDisp: 0x5b0d2, // $9A2
  statusScreen: 0x5b676, // $3420: lea $2BA8(a5)
  statusDigit: 0x5bc1a, // $3448: lea $314C(a5)
  textDat: 0x5beda, // $3432: lea $340C(a5)

  mainCl: 0x5e962, // $A9A
  clFlipPhase0: 0x5eae6, // $7EA
  clFlipPhase1: 0x5f88a, // $7D8
  clFlipJump0: 0x5f87c, // $7D4: lea $6DAE(a5)
  clFlipJump1: 0x60628, // $7E6: lea $7B5A(a5)
  sprPtr: 0x5e964, // $5A4A: lea $5E96(a5)
  backPtr: 0x5e9a4, // $B24: lea $5ED6(a5)
  statusPtr: 0x5e9f4, // $9A8: lea $5F26(a5)
  frontPtr: 0x5eabc, // $BEC: lea $5FEE(a5)
  videoShift: 0x5eae0, // $AFE: $6012(a5)
  skyPtr0: 0x5ead4, // $B4A: lea $6006(a5)
  skyPtr: [[0x5ed30, 0x5fad0], [0x5ef80, 0x5fd20], [0x5f1d0, 0x5ff74], [0x5f420, 0x601c8], [0x5f670, 0x6041c]],
  backColor0: 0x5e9b4, // $F92: lea $5EE6(a5)
  frontColor0: [0x5ea90, 0x5eaa8], // $2E86: $5FC2(a5), $2EA0: $5FDA(a5)
  frontColor: [
    [0x5ed14, 0x5fab4, 0x5ed40, 0x5fae0], // $2EA6: $6246/$6FE6(a5), $2EE6: $6272/$7012(a5)
    [0x5ef64, 0x5fd04, 0x5ef90, 0x5fd30], // $2EF4: $6496/$7236(a5), $2F34: $64C2/$7262(a5)
    [0x5f1b4, 0x5ff58, 0x5f1e0, 0x5ff84], // $2F42: $66E6/$748A(a5), $2F82: $6712/$74B6(a5)
    [0x5f404, 0x601ac, 0x5f430, 0x601d8], // $2F90: $6936/$76DE(a5), $2FD0: $6962/$770A(a5)
    [0x5f654, 0x60400, 0x5f680, 0x6042c], // $2FDE: $6B86/$7932(a5), $301E: $6BB2/$795E(a5)
  ],
  backColor: [[0x5ecfc, 0x5fa9c], [0x5ef4c, 0x5fcec], [0x5f19c, 0x5ff40], [0x5f3ec, 0x60194], [0x5f63c, 0x603e8]],

  frontScreens: 0x607b2, // $A08 (Clear_Start)
  backScreen0: 0x73f3a, // $7FC
  backScreen1: 0x7993a, // $804
  clearEnd: 0x7f33a, // $A60
};

/**
 * Level 2 – Wald (forest, Agony.0B). Der gemeinsame Code ist bis auf den fehlenden Regen ($A56, $5AF8–$5BC0 in sea)
 * Befehl für Befehl derselbe wie in sea; alle Werte stammen aus der ausgerichteten Disassembly
 * (tools/analysis/align_levels.py, work/disasm/forest_code.txt): je Wert derselbe Befehl wie bei SEA, Adressen in den
 * Kommentaren dort. Variablen ab a5 + $6BAC, D = $54DB4 ($61E).
 */
export const FOREST: LevelLayout = {
  file: "forest",
  blocks: ["forest.sprites", "forest.sky", "forest.back", "forest.game", "forest.rel"],
  d: 0x54db4,
  vars: {
    genPhase: 0x6bac, curBackBuild: 0x6bae, curBackShow: 0x6bb2, curFrontBuild: 0x6bb6, curFrontShow: 0x6bba,
    restScreenPtr: 0x6bbe, backPhase: 0x6bc2, backConfig: 0x6bc4, patPtr: 0x6bc6, pat0: 0x6bca,
    backShift: 0x6bf4, frontShift: 0x6bf6, frontShiftPhase: 0x6bf8, refreshFrame: 0x6bfa, skyCount: 0x6bfc,
    backOldOff: 0x6bfe, frontPhase: 0x6c00, frontReadPtr: 0x6c02, frontPalPtr: 0x6c06, frontPalCount: 0x6c0a,
    safeDestOff: 0x6c0e, safeDestPtr: 0x6c12, safeSrcPtr: 0x6c16,
    sorcererX: 0x6c1a, sorcererY: 0x6c1c, sorcererShape: 0x6c1e, sorcererDelay: 0x6c20,
    axeUpX: 0x6c22, axeUpY: 0x6c24, axeDownX: 0x6c26, axeDownY: 0x6c28, axeDelay: 0x6c2a, axeMove: 0x6c2c,
    oldScore: 0x6c2e, point: 0x6c32, spellTime: 0x6c36, oldSpellTime: 0x6c38, oldLife: 0x6c3a,
    fwFireStep: 0x6c40, fwFirePhase: 0x6c42, fwFireOff: 0x6c44, key: 0x6c46, keyUpFlag: 0x6c48,
    pause: 0x6c4a, pause2: 0x6c4c, prgPause: 0x6c4e, stop: 0x6c50, stop2: 0x6c52,
    textNum: 0x6c54, oldTextNum: 0x6c56, textDelay: 0x6c58, refreshStatus: 0x6c5a, statusDelay: 0x6c5c,
    iconesMode: 0x6c5e, fireCount: 0x6c60, iconesOff: 0x6c62, curentSpell: 0x6c6a, spellTimeDelay: 0x6c70,
    rainXOff0: 0x6c72, rainXOff1: 0x6c74, dmTa: 0x6c76, apTa: 0x6c78, mbl: 0x6c7c, bmTa: 0x6c7e, sTs: 0x6c80,
    curentAwoPtr: 0x6c82, alienAwoCount: 0x6c86, curentAlienNum: 0x6c88, curentBankPtr: 0x6c8a, startListPtr: 0x6c8e, levelX: 0x6c92, slWaiting: 0x6c94,
    refreshPal: 0x6c96, vdoSInc: 0x6c98, flashPhase: 0x6c9a, curExploState: 0x6c9c, oldVpos: 0x6ca0, shortPhase: 0x6ca2, rainOn: 0x6ca4, sorcerer2Shape: 0x6cb4,
    sorcererOn: 0x6cb6, die: 0x6cc6, dieMode: 0x6cc8, dieX: 0x6cca, dieY: 0x6ccc, routPalPtr: 0x6cce, routModPalCounter: 0x6cd2, bonusMode: 0x6cd6, bonusDelay: 0x6cd8, bonusX: 0x6cda, bonusY: 0x6cdc, sprPtrB: 0x6ce0,
    sound0: 0x6d00, sound0b: 0x6d02, sound0Req: 0x6d04, sound0Vol: 0x6d06, sound0VolReq: 0x6d08, sound0IntStep: 0x6d0a,
    sound0LastPri: 0x6d0c,
    quitDelay: 0x6d0e, afOff: 0x6d10, beginToStart: 0x6d20, btsDelay: 0x6d22, cleanUp: 0x6d24,

    rFAwoPtr1: 0x6d14, rFAwoPtr2: 0x6d18, rFAwoPtr3: 0x6d1c,


    bonusAnim: 0x6cd4, bonusNum: 0x6cde, spellPri: -0x30a8, bonusShape: -0x2f86, bonusImage: -0x2f7e, spr6pt: 0x138,
    spr7pt: 0x13c,

    arowY: 0x6c64, arowDown: 0x6c66, arowUp: 0x6c68, safeCurSpell: 0x6c6c, iconesFireUp: 0x6c6e, selectionOn: 0x6d12,
    iconesPal: -0x37e8, iconesSpr: -0x43e8, arowSpr: -0x37c8, maskSpr: -0x36b8, timeTable: -0x3098,

    sorcerer2X: 0x6cb0, sorcerer2Y: 0x6cb2, backFbX0: 0x6ca8, backFbX1: 0x6caa, backFbSpr0: -0x2cac, backFbSpr1: -0x2c20,
    rotStep: 0x6ca6, rotTable: -0x2f66, fball3Spr0: -0x2eb4, fball3Spr1: -0x2db0, timeY: 0x6cc4, timeStep: 0x6cc2,
    timeYTable: -0x3088, timeSpr: -0x4ac, smartBX: 0x6cb8, smartBStep: 0x6cba, smartBStepH: 0x6cbc, smartBStepHC: 0x6cbe,
    smartBSpr: -0x2b94, megaBX: 0x6cc0, megaBSpr: -0xe20, fwFbX0: 0x6cac, fwFbX1: 0x6cae, sinTable: -0x2ed6,
    clBplCon0: 0x4d7e,
  },

  sorcererDat: 0x15396,
  sorcerer2Dat: 0x193c6,
  sorcererPal: 0x50940,
  emptySpr: 0x50968,
  bonusSpr: 0x1ce32,
  dieTable: 0x5590c,
  dieDynPtr: 0x55ef8,
  dieSpr: 0x1dc66,
  axeTraj: 0x5096c,
  alienFireSpr: 0x1dab2,
  afStruct: 0x4ae44,
  awoStruct: 0x576fc,
  awoStructEnd: 0x58f7c,
  routStruct: 0x59664,
  goodColList: 0x59442,
  skyDat: 0x1e08a,
  backCharset: 0x1f70a,
  backFrame: 0x4cdb4,
  backPattern: 0x4d660,
  backCharInfo: 0x4d9fc,
  readTable: 0x4dcd8,
  backOldChar: 0x4e188,
  x60: 0x4e368,
  writeTable: 0x4e468,
  skyAnimTable: 0x4e4e0,
  skyPhases: 1,
  frontMap: 0x4e4e8,
  frontPal: 0x4f370, // $A00: Front_Pal − 6·7·2 = $4F31C
  frontCharset: 0x2c68a,
  frontPalBuffer: 0x4fd9c,
  frontTable: 0x4fdf0,
  x384: 0x4fdfc,
  frontMask: 0x501fc,
  trackTable: 0x59402,

  // Quelle: Ag_Game_LFORET.s „ROUTINES“; Startliste ab $4AF44 startet $4B76C, $4B964, $4BB60, $4BEE4, $4BFA2, $4C048,
  // $4C160 und $4C39E (Disassembly work/disasm/forest_rout.txt). Die aus Level 1 bekannten Routinen melden hier keine
  // eigene Palette an (pal: null bzw. false); Unterschiede siehe die …Def-Typen in routines.ts.
  routines: new Map<number, RoutineDef>([
    // Abbild $4B76C; R_Spectre_Shape $4B762 ($4B832), Obj_Spectre_Pot $300 ($4B790), Obj_Spectre_4/5 $348/$35E ($4B874)
    [0x4b76c, { kind: "spectre", pal: null, shape: 0x4b762, pot: 0x300, obj4: 0x348, obj5: 0x35e }],
    // Abbild $4B964; R_Tir_Etoile_Shape $4B952 ($4B9BA), Obj_Tir_Etoile_1 $54E ($4B988), Obj_Tir_1–8 $416–$494
    // ($4BA10–$4BA3A)
    [0x4b964, { kind: "tirEtoile", pal: null, shape: 0x4b952, obj: 0x54e,
      shots: [0x416, 0x428, 0x43a, 0x44c, 0x45e, 0x470, 0x482, 0x494] }],
    // Abbild $4BB60; Obj_Volant_Missile_1/2 $4A6/$4BC ($4BBCE/$4BBD8), Schuss 1 Pixel je Durchlauf ($4BC28–$4BC76)
    [0x4bb60, { kind: "volantMissile", pal: null, obj1: 0x4a6, obj2: 0x4bc,
      shots: [0x416, 0x428, 0x43a, 0x44c, 0x45e, 0x470, 0x482, 0x494], shotSpeed: 1 }],
    // Abbild $4BEE4; Obj_Araignee $3F4 ($4BF06), R_A_Y_Mode bei +2 ($4BF26)
    [0x4bee4, { kind: "araignee", pal: null, obj: 0x3f4, yMode: 2 }],
    // Abbild $4BFA2; Energie 2 ($4BFDA), ohne Rout_Pal_Ptr ($4BFB4)
    [0x4bfa2, { kind: "rapide", pal: false, energy: 2 }],
  ]),
  relativeTracks: 0x4c658,
  absoluteTracks: 0x4c658,
  animBase: 0x4b70e,
  objectsStruct: 0x49de2,
  spritesStruct: 0x56e40,
  spritesCount: 86, // $694: move.w #$55,d2
  spritesBitmap: 0x3c70a,
  spritesMask: 0x4838a,
  blitRoutines: 0x5917c,
  maskRoutines: 0x591ac,
  vcRoutines: 0x591dc,
  hcRoutines: 0x5920c,
  cBlitMaskBuff: 0x58f7c,
  x44: 0x5923c,
  fwmConv: 0x593be,
  lwmConv: 0x593e0,
  exploSprList: 0x59482,
  bsCount: 0x594a0,
  bsOffset: 0x5956a,
  bsOrder: 0x59634,
  afLfo: 0x59654,
  soundPri: 0x5093c,
  startList: 0x4af44,
  rain: false,
  rainXTable: 0,
  rainSpr0: 0,
  rainSpr1: 0,
  statusScreenDisp: 0x55f18,
  statusScreen: 0x564bc,
  statusDigit: 0x56a60,
  textDat: 0x56d20,

  mainCl: 0x599e4,
  clFlipPhase0: 0x59b68,
  clFlipPhase1: 0x5aa70,
  clFlipJump0: 0x5aa62,
  clFlipJump1: 0x5b952,
  sprPtr: 0x599e6,
  backPtr: 0x59a26,
  statusPtr: 0x59a76,
  frontPtr: 0x59b3e,
  videoShift: 0x59b62,
  skyPtr0: 0x59b56,
  skyPtr: [[0x59db2, 0x5acb6], [0x5a002, 0x5af06], [0x5a252, 0x5b15a], [0x5a57a, 0x5b46a], [0x5a856, 0x5b746]],
  backColor0: 0x59a36,
  frontColor0: [0x59b12, 0x59b2a],
  frontColor: [
    [0x59d96, 0x5ac9a, 0x59dc2, 0x5acc6],
    [0x59fe6, 0x5aeea, 0x5a012, 0x5af16],
    [0x5a236, 0x5b13e, 0x5a262, 0x5b16a],
    [0x5a55e, 0x5b44e, 0x5a58a, 0x5b47a],
    [0x5a83a, 0x5b72a, 0x5a866, 0x5b756],
  ],
  backColor: [[0x59d7e, 0x5ac82], [0x59fce, 0x5aed2], [0x5a21e, 0x5b126], [0x5a546, 0x5b436], [0x5a822, 0x5b712]],

  frontScreens: 0x5badc,
  backScreen0: 0x6f264,
  backScreen1: 0x74c64,
  clearEnd: 0x7a664,
};
