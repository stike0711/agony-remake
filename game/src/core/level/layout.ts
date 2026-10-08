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
    [0x4f81c, { kind: "araignee", pal: 0x4f808, obj: 0xea }],
    // Abbild $4EFC8 (Disassembly mit disasm68k.py aus sea.game.bin)
    [0x4efc8, { kind: "transporteur", pal: 0x4ef6c, shape: 0x4ef80, wave1: 0x4ef88, wave2: 0x4efa8, obj: 0x122 }],
    // Abbild $4ED70; Obj_Tir_1–8 aus den move.w #…,Awo_Alien_Obj_Off(a4) bei $4EE2C–$4EE56
    [0x4ed70, { kind: "tirEtoile", pal: 0x4ed4a, shape: 0x4ed5e, obj: 0x3f2,
      shots: [0x4d0, 0x4e2, 0x4f8, 0x50a, 0x520, 0x532, 0x548, 0x55a] }],
    // Abbild $4E9F0; Obj_Spectre_Pot $35A ($4EA24 im MODE 0), Obj_Spectre_4/5 aus MODE 3 ($4EB08–$4EB1C)
    [0x4e9f0, { kind: "spectre", pal: 0x4e9d2, shape: 0x4e9e6, pot: 0x35a, obj4: 0x3b6, obj5: 0x3d4 }],
    // Abbild $4F8EE
    [0x4f8ee, { kind: "rapide" }],
    // Abbild $4EC00; Obj_Sac $BE ($4EC26), Obj_Boulle $32E ($4ECDC), Sin_Table1 $509C2 ($4ED10)
    [0x4ec00, { kind: "bomber", obj: 0xbe, bomb: 0x32e, sin: 0x509c2 }],
    // Abbild $4F696 (R_Volant_Grossi, nicht R_Jumper) und $4F75E (R_Jumper, in Level 1 nicht gestartet);
    // Obj_Grossi_1–3 = $5A8/$58E/$570 ($4F742/$4F738/$4F72E)
    [0x4f696, { kind: "volantGrossi", pal: 0x4f682, obj1: 0x5a8, obj2: 0x58e, obj3: 0x570 }],
    [0x4f75e, { kind: "jumper", pal: 0x4f74a, obj1: 0x5a8, obj2: 0x58e, obj3: 0x570 }],
    // Abbild $4F2F2; Obj_Volant_Missile_1/2 = $29E/$2B4 ($4F36C/$4F376), Obj_Tir_1–8 wie bei R_Tir_Etoile
    [0x4f2f2, { kind: "volantMissile", pal: 0x4f2de, obj1: 0x29e, obj2: 0x2b4,
      shots: [0x4d0, 0x4e2, 0x4f8, 0x50a, 0x520, 0x532, 0x548, 0x55a] }],
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
