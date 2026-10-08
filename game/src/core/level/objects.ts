// Ag_Object_.s (sea $149C–$29D2) und Ag_Pre_comp.s ($674–$7C2): Gegner als Blitter-Objekte im vorderen Playfield.
//
// Jede Angriffswelle belegt eine AWO-Bank (32 Bänke à 196 Byte ab AWO_Struct): Wort Anzahl (0 = leer, −1 = frei),
// Wort Versatz zum ersten lebenden Gegner, dann 16 Gegner à 12 Byte (AWO_Alien_X/Y, Obj_Off, Energy, Status,
// F_Rt_S, F_Rt_D). Ein Objekt (Objects_Struct + Obj_Off) besteht aus Teilbildern (dx, dy, Sprite-Nummer); jedes
// Teilbild ist ein Eintrag der Sprites_Struct (26 Byte: Breite, Höhe, Zeiger auf Masken-, Clipping- und
// Blit-Routine, Bitmap, Maske). Typ 0–3: 3 Farben mit Palette 0 (Farben 1–3), 4–7: 3 Farben mit Palette 1
// (Farben 5–7), 8–11: 7 Farben mit Maske; innerhalb der Gruppe 32 × 32, 64 × 32, 32 × 64, 64 × 64 Pixel.
// Die Routinen sind wie im Original Folgen von Blits; die Zeiger in der Sprites_Struct stehen wie im Original im
// Speicher und werden hier über die Routinentabellen aufgelöst.

import type { LevelEngine } from "./engine.ts";
import { WORK } from "./timing.ts";

/** Abstand der Planes im vorderen Playfield (44 Byte × 192 Zeilen) */
const PLANE = 44 * 192;
/** Eintrag der Sprites_Struct */
const SPR_LEN = 26;
/** Bank: 2 Wörter + 16 Gegner à 12 Byte */
const AWO_LEN = 12;
const BANK_ALIENS = 16 * AWO_LEN;

const s16 = (v: number): number => (v << 16) >> 16;
const s8 = (v: number): number => (v << 24) >> 24;

// ---- Vorberechnung ($674) ----------------------------------------------------------------------

/**
 * BUILD 8 COL. SPR. MASK und TRANSFORM SPRITES STRUCT: Masken der 7-Farben-Teilbilder (A ∨ B ∨ C der drei Planes)
 * nach Sprites_Mask, dann Routinenzeiger und absolute Bitmap-Adressen in die Sprites_Struct.
 */
export function precompute(e: LevelEngine): void {
  const { L, ram, blitter: bl } = e;
  bl.cmod = 0;
  bl.bmod = 0;
  bl.amod = 0;
  bl.dmod = 0;
  bl.setMasks(0xffffffff);
  bl.setCon(0x0ffe0000);
  let mask = L.spritesMask;
  for (let i = 0, a0 = L.spritesStruct; i < L.spritesCount; i++, a0 += SPR_LEN) {
    const type = ram.word(a0 + 16) - 8; // Typ steht vor der Umwandlung in allen vier Zeigern
    if (type < 0) continue;
    const plane = type === 0 ? 0x80 : type === 3 ? 0x200 : 0x100;
    const size = type === 0 ? 0x802 : type === 1 ? 0x804 : type === 2 ? 0x1002 : 0x1004;
    const src = (ram.long(a0 + 18) + L.spritesBitmap) >>> 0;
    bl.apt = src;
    bl.bpt = src + plane;
    bl.cpt = src + 2 * plane;
    bl.dpt = mask;
    ram.setLong(a0 + 22, mask);
    mask += plane;
    bl.start(size);
  }
  if (ram.long(L.spritesStruct + 2) > 0x400) return; // schon umgewandelt (Neustart)
  for (let i = 0, a0 = L.spritesStruct; i < L.spritesCount; i++, a0 += SPR_LEN) {
    const t = 4 * ram.word(a0 + 4);
    ram.setLong(a0 + 2, ram.long(L.maskRoutines + t));
    ram.setLong(a0 + 6, ram.long(L.hcRoutines + t));
    ram.setLong(a0 + 10, ram.long(L.vcRoutines + t));
    ram.setLong(a0 + 14, ram.long(L.blitRoutines + t));
    ram.setLong(a0 + 18, (ram.long(a0 + 18) + L.spritesBitmap) >>> 0);
  }
}

// ---- Zurücksetzen und Gegner zeichnen ($149C) ----------------------------------------------------

/**
 * Die Engine ruft das vor oder nach dem Copper-Interrupt des Folgebilds auf, je nachdem, wo ALIEN BANK CTRL im
 * Original liegt (Zeitmodell): Kam der Interrupt dem Zurücksetzen zuvor, hat er Front_Shift schon verringert, und die
 * Gegner stehen 1 Pixel weiter (O-010).
 */
export function objects(e: LevelEngine): void {
  const { V, L, ram, blitter: bl } = e;
  // RESTORE CURENT BUILD SCREEN: Arbeitsbild aus dem Restaurierungsbild (ohne Gegner) zurücksetzen
  bl.apt = e.l(V.restScreenPtr);
  bl.dpt = e.l(V.curFrontBuild);
  bl.setMasks(0xffffffff);
  bl.amod = 4;
  bl.dmod = 4;
  bl.setCon(0x09f00000);
  for (let i = 0; i < 8; i++) bl.start(64 * (192 / 4) + 20);
  bl.start(64 * 192 + 20);

  // ALIEN BANK CTRL ($153C)
  e.setW(V.flashPhase, e.w(V.flashPhase) ^ 1);
  e.setW(V.frontShiftPhase, e.w(V.frontShift));
  let a0 = L.awoStruct;
  for (;;) {
    const num = ram.word(a0);
    a0 += 2;
    if (num === 0 || num === 0xffff) {
      a0 += BANK_ALIENS + 2;
      if (a0 >= L.awoStructEnd) return;
      continue;
    }
    const off = ram.sword(a0);
    a0 += 2;
    e.setL(V.curentBankPtr, a0);
    let awo = a0 + off;
    e.setW(V.curentAlienNum, num);
    e.setW(V.alienAwoCount, 0);
    for (;;) {
      e.setL(V.curentAwoPtr, awo);
      e.stepWork[WORK.aliens]!++;
      drawAlien(e, awo);
      e.setW(V.alienAwoCount, e.w(V.alienAwoCount) + 1);
      if (e.w(V.alienAwoCount) === e.w(V.curentAlienNum)) break;
      awo += AWO_LEN;
    }
    a0 = e.l(V.curentBankPtr) + BANK_ALIENS;
    if (a0 === L.awoStructEnd) return;
  }
}

/** Ein Gegner: Treffer-Blinkzähler, Explosionsphase, dann alle Teilbilder des Objekts */
function drawAlien(e: LevelEngine, awo: number): void {
  const { V, L, ram, blitter: bl } = e;
  // Treffer: oberes Nibble des Status zählt in 16er-Schritten bis $F0, dann zurück (sichtbar ist das nicht)
  let status = ram.byte(awo + 8);
  const flash = status & 0xf0;
  if (flash !== 0) {
    status = flash === 0xf0 ? status & 0x0f : (status + 0x10) & 0xff;
    ram.setByte(awo + 8, status);
  }
  // DRAW OBJECT ($15A2)
  const d4 = e.l(V.curFrontBuild);
  let d5 = s16(31 - ((e.w(V.frontShiftPhase) + 1) & 31) + ram.word(awo));
  let d6 = ram.sword(awo + 2);
  e.setW(V.curExploState, 0);
  const explo = status & 0xf;
  if (explo !== 0) {
    if (explo === 0xf) return; // Explosion vorbei: nicht mehr zeichnen
    if (e.w(V.bonusMode) === 1) {
      e.setW(V.bonusX, d5);
      e.setW(V.bonusY, d6);
      e.setW(V.bonusMode, 2);
    }
    ram.setByte(awo + 8, status + 1);
    e.setW(V.curExploState, ram.word(L.exploSprList + 2 * explo));
  }
  d5 = s16(d5 - 256);
  d6 = s16(d6 - 256);
  let obj = L.objectsStruct + 4 + ram.sword(awo + 4);
  for (;;) {
    const d0 = s16(s8(ram.byte(obj++)) + d5);
    const dy = ram.byte(obj++);
    if (dy === 0x80) return;
    e.stepWork[WORK.subs]!++;
    const d1 = s16(s8(dy) + d6);
    let spr = ram.byte(obj++);
    const explo = e.w(V.curExploState);
    if (explo !== 0) spr = explo;
    const a1 = L.spritesStruct + SPR_LEN * spr;
    const d3 = s16(ram.byte(a1) + d0); // rechter Rand
    const d7 = s16(ram.byte(a1 + 1) + d1); // unterer Rand
    if (d0 < 0) {
      clipLeft(e, a1, d0, d1, d3, d7, d4);
      continue;
    }
    if (d3 >= 320) {
      clipRight(e, a1, d0, d1, d3, d7, d4);
      continue;
    }
    if (d1 < 0) {
      clipUp(e, a1, d0, d1, d7, d4);
      continue;
    }
    if (d7 >= 192) {
      clipDown(e, a1, d0, d1, d7, d4);
      continue;
    }
    // NO CLIPING PRE-COMPUTE ($1670)
    bl.amod = -2;
    bl.setMasks(0xffff0000);
    const a4 = (d4 + row(e, d1) + ((d0 >>> 3) & 0x1ffe)) >>> 0;
    bl.cpt = a4;
    bl.dpt = a4;
    normalBlit(e, ram.long(a1 + 14), a1 + 18, d0, a4);
  }
}

/** X44: Versatz der Zeile im Bild (44 Byte je Zeile) */
function row(e: LevelEngine, y: number): number {
  return e.ram.sword(e.L.x44 + 2 * y);
}

/** Linker Rand ($16A2) und die Ecken links oben/unten */
function clipLeft(e: LevelEngine, a1: number, d0: number, d1: number, d3: number, d7: number, d4: number): void {
  const { V, L, ram, blitter: bl } = e;
  if (d3 <= 0) return;
  if (d1 < 0) {
    // Clip_LU ($1836)
    if (d7 <= 0) return;
    buildClipMask(e, a1 + 2);
    bl.afwm = ram.word(L.fwmConv + 2 * (d3 & 15));
    const skip = ((~d0 & 0xffff) >>> 3) & 0xfffe;
    e.setW(V.dmTa, skip);
    e.setW(V.apTa + 2, skip);
    e.setW(V.bmTa, skip);
    bl.amod = s16(-2 + skip);
    bl.alwm = 0;
    const a4 = (d4 - 2) >>> 0;
    bl.cpt = a4;
    bl.dpt = a4;
    const hidden = -d1 & 0xffff;
    e.setW(V.mbl, hidden);
    e.setW(V.sTs, (skip >>> 1) | ((hidden << 6) & 0xffff));
    clipBlit(e, ram.long(a1 + 6), a1 + 18, d0, a4);
    return;
  }
  if (d7 >= 192) {
    // Clip_LD ($189C)
    if (d1 >= 192) return;
    const below = ((d7 - 192) << 6) & 0xffff;
    buildClipMask(e, a1 + 2);
    bl.afwm = ram.word(L.fwmConv + 2 * (d3 & 15));
    const skip = ((~d0 & 0xffff) >>> 3) & 0xfffe;
    e.setW(V.dmTa, skip);
    e.setW(V.apTa + 2, skip);
    e.setW(V.bmTa, skip);
    bl.amod = s16(-2 + skip);
    bl.alwm = 0;
    const a4 = (d4 + row(e, d1) - 2) >>> 0;
    bl.cpt = a4;
    bl.dpt = a4;
    e.setW(V.mbl, 0);
    e.setW(V.sTs, (skip >>> 1) | below);
    clipBlit(e, ram.long(a1 + 6), a1 + 18, d0, a4);
    return;
  }
  // Clip_L
  buildClipMask(e, a1 + 2);
  bl.afwm = ram.word(L.fwmConv + 2 * (d3 & 15));
  const skip = ((~d0 & 0xffff) >>> 3) & 0xfffe;
  e.setW(V.dmTa, skip);
  e.setW(V.apTa + 2, skip);
  e.setW(V.bmTa, skip);
  e.setW(V.mbl, 0);
  bl.amod = s16(-2 + skip);
  bl.alwm = 0;
  const a4 = (d4 + row(e, d1) - 2) >>> 0;
  bl.cpt = a4;
  bl.dpt = a4;
  e.setW(V.sTs, skip >>> 1);
  clipBlit(e, ram.long(a1 + 6), a1 + 18, d0, a4);
}

/** Rechter Rand ($1716) und die Ecken rechts oben/unten */
function clipRight(e: LevelEngine, a1: number, d0: number, d1: number, d3: number, d7: number, d4: number): void {
  const { V, L, ram, blitter: bl } = e;
  if (d0 >= 320) return;
  if (d1 < 0) {
    // Clip_RU ($190C)
    if (d7 <= 0) return;
    buildClipMask(e, a1 + 2);
    const skip = (((d3 - 0x130) & 0xffff) >>> 3) & 0xfffe;
    bl.alwm = ram.word(L.lwmConv + 2 * (d3 & 15));
    e.setW(V.dmTa, skip);
    e.setW(V.bmTa, skip);
    e.setW(V.apTa + 2, 0);
    bl.afwm = 0xffff;
    const a4 = (d4 + ((d0 >>> 3) & 0x1ffe)) >>> 0;
    bl.cpt = a4;
    bl.dpt = a4;
    bl.amod = s16(-2 + skip);
    const hidden = -d1 & 0xffff;
    e.setW(V.mbl, hidden);
    e.setW(V.sTs, (skip >>> 1) | ((hidden << 6) & 0xffff));
    clipBlit(e, ram.long(a1 + 6), a1 + 18, d0, a4);
    return;
  }
  if (d7 >= 192) {
    // Clip_RD ($197A)
    if (d1 >= 192) return;
    const below = ((d7 - 192) << 6) & 0xffff;
    buildClipMask(e, a1 + 2);
    bl.alwm = ram.word(L.lwmConv + 2 * (d3 & 15));
    const skip = (((d3 - 0x130) & 0xffff) >>> 3) & 0xfffe;
    e.setW(V.dmTa, skip);
    e.setW(V.bmTa, skip);
    bl.afwm = 0xffff;
    const a4 = (d4 + row(e, d1) + ((d0 >>> 3) & 0x1ffe)) >>> 0;
    bl.cpt = a4;
    bl.dpt = a4;
    bl.amod = s16(-2 + skip);
    e.setW(V.apTa + 2, 0);
    e.setW(V.mbl, 0);
    e.setW(V.sTs, (skip >>> 1) | below);
    clipBlit(e, ram.long(a1 + 6), a1 + 18, d0, a4);
    return;
  }
  // Clip_R
  buildClipMask(e, a1 + 2);
  const skip = (((d3 - 0x130) & 0xffff) >>> 3) & 0xfffe;
  bl.alwm = ram.word(L.lwmConv + 2 * (d3 & 15));
  e.setW(V.dmTa, skip);
  e.setW(V.bmTa, skip);
  e.setW(V.apTa + 2, 0);
  e.setW(V.mbl, 0);
  bl.afwm = 0xffff;
  const a4 = (d4 + row(e, d1) + ((d0 >>> 3) & 0x1ffe)) >>> 0;
  bl.cpt = a4;
  bl.dpt = a4;
  bl.amod = s16(-2 + skip);
  e.setW(V.sTs, skip >>> 1);
  clipBlit(e, ram.long(a1 + 6), a1 + 18, d0, a4);
}

/** Oberer Rand ($1794): die ersten −y Zeilen fallen weg */
function clipUp(e: LevelEngine, a1: number, d0: number, d1: number, d7: number, d4: number): void {
  const { V, ram, blitter: bl } = e;
  if (d7 <= 0) return;
  const hidden = -d1 & 0xffff;
  e.setW(V.mbl, hidden);
  bl.amod = -2;
  const a4 = (d4 + ((d0 >>> 3) & 0x1ffe)) >>> 0;
  bl.cpt = a4;
  bl.dpt = a4;
  bl.setMasks(0xffff0000);
  e.setW(V.dmTa, 0);
  e.setW(V.apTa + 2, 0);
  e.setW(V.bmTa, 0);
  e.setW(V.sTs, (hidden << 6) & 0xffff);
  clipBlit(e, ram.long(a1 + 10), a1 + 18, d0, a4);
}

/** Unterer Rand ($17E2): die Zeilen ab 192 fallen weg */
function clipDown(e: LevelEngine, a1: number, d0: number, d1: number, d7: number, d4: number): void {
  const { V, ram, blitter: bl } = e;
  if (d1 >= 192) return;
  const below = d7 - 192;
  bl.amod = -2;
  const a4 = (d4 + row(e, d1) + ((d0 >>> 3) & 0x1ffe)) >>> 0;
  bl.cpt = a4;
  bl.dpt = a4;
  bl.setMasks(0xffff0000);
  e.setW(V.dmTa, 0);
  e.setW(V.apTa + 2, 0);
  e.setW(V.mbl, 0);
  e.setW(V.bmTa, 0);
  e.setW(V.sTs, (below << 6) & 0xffff);
  clipBlit(e, ram.long(a1 + 10), a1 + 18, d0, a4);
}

// ---- Routinen ------------------------------------------------------------------------------------

/** Index (0–11) eines Routinenzeigers in einer der Routinentabellen, sonst −1 */
function indexIn(e: LevelEngine, table: number, ptr: number): number {
  for (let i = 0; i < 12; i++) if (e.ram.long(table + 4 * i) === ptr) return i;
  return -1;
}

/** Abmessungen einer Größenklasse (0: 32 × 32, 1: 64 × 32, 2: 32 × 64, 3: 64 × 64) */
function words(size: number): number {
  return size & 1 ? 5 : 3;
}
function rows(size: number): number {
  return size & 2 ? 64 : 32;
}
/** Bytes einer Plane der Bitmap (2 bzw. 4 Wörter je Zeile) */
function planeBytes(size: number): number {
  return (size & 1 ? 8 : 4) * rows(size);
}

/** NORMAL BLIT ROUTINES (N_Blit0–11, $19F4–$206A): `a1` zeigt auf Frst_Bitplane_Ptr */
function normalBlit(e: LevelEngine, ptr: number, a1: number, d0: number, a4: number): void {
  const { L, ram, blitter: bl } = e;
  const type = indexIn(e, L.blitRoutines, ptr);
  if (type < 0) throw new Error(`Objekte: unbekannte Blit-Routine $${ptr.toString(16)}`);
  const size = type & 3;
  const blitSize = (rows(size) << 6) | words(size);
  const sh = (d0 & 15) << 12;
  bl.cmod = 44 - 2 * words(size);
  bl.dmod = bl.cmod;
  if (type < 8) {
    // 3 Farben: A = Plane 0, B = Plane 1 (mit Leerwort je Zeile); Plane 2 je nach Palette löschen oder setzen
    const d1 = ram.long(a1);
    const a2 = d1 + planeBytes(size);
    bl.apt = d1;
    bl.bpt = a2;
    bl.bmod = 0;
    bl.con0 = 0x0ff2 | sh;
    bl.con1 = sh;
    bl.start(blitSize);
    bl.apt = d1;
    bl.bpt = a2;
    a4 += PLANE;
    bl.cpt = a4;
    bl.dpt = a4;
    bl.con0 = 0x0fce | sh;
    bl.start(blitSize);
    bl.apt = d1;
    bl.bpt = a2;
    a4 += PLANE;
    bl.cpt = a4;
    bl.dpt = a4;
    bl.con0 = sh | 0x0f00 | (type < 4 ? 0x02 : 0xfe);
    bl.start(blitSize);
    return;
  }
  // 7 Farben: B = Bitmap (läuft über die Planes weiter), A = Maske; D = A ? B : C
  bl.bpt = ram.long(a1);
  const d1 = ram.long(a1 + 4);
  bl.apt = d1;
  bl.bmod = -2;
  bl.con0 = 0x0fca | sh;
  bl.con1 = sh;
  bl.start(blitSize);
  for (let p = 0; p < 2; p++) {
    bl.apt = d1;
    a4 += PLANE;
    bl.cpt = a4;
    bl.dpt = a4;
    bl.start(blitSize);
  }
}

/**
 * BUILD MASK ROUTINES FOR H. CLIPPING ($206C): Maske eines 3-Farben-Teilbilds (Plane 0 ∨ Plane 1) nach
 * C_Blit_Mask_Buff; bei 7 Farben (M_Nop) nur die Registerwerte. `a1` zeigt auf Mask_Rout_Ptr.
 */
function buildClipMask(e: LevelEngine, a1: number): void {
  const { L, ram, blitter: bl } = e;
  bl.amod = 0;
  bl.dmod = 0;
  bl.bmod = 2;
  bl.setMasks(0xffffffff);
  bl.setCon(0x0dfc0000);
  const d2 = ram.long(a1 + 16);
  bl.apt = d2;
  const m = indexIn(e, L.maskRoutines, ram.long(a1));
  if (m < 0) throw new Error("Objekte: unbekannte Masken-Routine");
  if (m >= 8) return; // M_Nop
  const size = m & 3;
  // addi.w: nur das untere Wort von d2 wächst (wie im Original ohne Übertrag)
  bl.bpt = ((d2 & 0xffff0000) | ((d2 + planeBytes(size)) & 0xffff)) >>> 0;
  bl.dpt = L.cBlitMaskBuff;
  bl.start((rows(size) << 6) | (words(size) - 1));
}

/**
 * Clipping-Routinen: H_C_Blit0–3 (3 Farben, links/rechts) und V_C_Blit0–3 (3 Farben, oben/unten) über die
 * Maske im Puffer bzw. direkt, V_C_Blit4–7 (7 Farben, alle Ränder) über die vorberechnete Maske.
 */
function clipBlit(e: LevelEngine, ptr: number, a1: number, d0: number, a4: number): void {
  e.stepWork[WORK.clipped]!++;
  const { V, L } = e;
  const h = indexIn(e, L.hcRoutines, ptr);
  if (h >= 0 && h < 8) return hcBlit(e, h & 3, a1, d0, a4);
  const v = indexIn(e, L.vcRoutines, ptr);
  if (v < 0) throw new Error(`Objekte: unbekannte Clipping-Routine $${ptr.toString(16)}`);
  if (v < 8) return vcBlit3(e, v & 3, a1, d0, a4);
  vcBlit7(e, v & 3, a1, d0, a4, e.w(V.mbl));
}

/** H_C_Blit0–3 ($2114–$2416) */
function hcBlit(e: LevelEngine, size: number, a1: number, d0: number, a4: number): void {
  const { V, L, ram, blitter: bl } = e;
  const bmTa = e.sw(V.bmTa);
  bl.bmod = s16(-2 + bmTa);
  bl.cmod = s16(44 - 2 * words(size) + e.sw(V.dmTa));
  bl.dmod = bl.cmod;
  const apTa = e.w(V.apTa + 2);
  let a2 = L.cBlitMaskBuff + s16(apTa);
  let d1 = (ram.long(a1) + apTa) >>> 0;
  let d2 = d1;
  const mbl = e.w(V.mbl);
  if (mbl !== 0) {
    // Plane 0 und Maske: 2 bzw. 4 Wörter je Zeile; Plane 1: ein Wort mehr
    const rowA = size & 1 ? 8 : 4;
    d2 += 2 * mbl;
    d1 += rowA * mbl;
    a2 += rowA * mbl;
    d2 += rowA * mbl;
  }
  d2 += planeBytes(size);
  bl.bpt = d1;
  bl.apt = a2;
  const sh = (d0 & 15) << 12;
  bl.con0 = 0x0fca | sh;
  bl.con1 = sh;
  const blitSize = (((rows(size) << 6) | words(size)) - e.w(V.sTs)) & 0xffff;
  bl.start(blitSize);
  bl.bpt = d2;
  bl.apt = a2;
  bl.bmod = bmTa;
  a4 += PLANE;
  bl.cpt = a4;
  bl.dpt = a4;
  bl.start(blitSize);
  bl.apt = a2;
  a4 += PLANE;
  bl.cpt = a4;
  bl.dpt = a4;
  // Plane 2: Minterm aus der Sprites_Struct ($0B0A löschen bzw. $0BFA setzen, Kanäle A, C, D)
  bl.con0 = (sh & 0xf000) | ram.word(a1 + 4);
  bl.start(blitSize);
}

/** V_C_Blit0–3 ($2418–$26F2): 3 Farben, Zeilen oben oder unten abgeschnitten */
function vcBlit3(e: LevelEngine, size: number, a1: number, d0: number, a4: number): void {
  const { V, ram, blitter: bl } = e;
  bl.cmod = s16(44 - 2 * words(size) + e.sw(V.dmTa));
  bl.dmod = bl.cmod;
  let d1 = (ram.long(a1) + e.l(V.apTa)) >>> 0;
  let d2 = d1;
  const mbl = e.w(V.mbl);
  if (mbl !== 0) {
    const rowA = size & 1 ? 8 : 4;
    d2 += 2 * mbl;
    d1 += rowA * mbl;
    d2 += rowA * mbl;
  }
  d2 += planeBytes(size);
  bl.apt = d1;
  bl.bpt = d2;
  bl.bmod = e.sw(V.bmTa);
  const sh = (d0 & 15) << 12;
  bl.con0 = 0x0ff2 | sh;
  bl.con1 = sh;
  const blitSize = (((rows(size) << 6) | words(size)) - e.w(V.sTs)) & 0xffff;
  bl.start(blitSize);
  bl.apt = d1;
  bl.bpt = d2;
  a4 += PLANE;
  bl.cpt = a4;
  bl.dpt = a4;
  bl.con0 = 0x0fce | sh;
  bl.start(blitSize);
  bl.apt = d1;
  bl.bpt = d2;
  a4 += PLANE;
  bl.cpt = a4;
  bl.dpt = a4;
  bl.con0 = (bl.con0 & 0xff00) | ram.byte(a1 + 7);
  bl.start(blitSize);
}

/** V_C_Blit4–7 ($26F4–$29A0): 7 Farben über die vorberechnete Maske, für alle Ränder */
function vcBlit7(e: LevelEngine, size: number, a1: number, d0: number, a4: number, mbl: number): void {
  const { V, ram, blitter: bl } = e;
  const bmTa = e.sw(V.bmTa);
  bl.bmod = s16(-2 + bmTa);
  bl.cmod = s16(44 - 2 * words(size) + e.sw(V.dmTa));
  bl.dmod = bl.cmod;
  let a2 = ram.long(a1);
  let d1 = ram.long(a1 + 4);
  const apTa = e.l(V.apTa);
  d1 = (d1 + apTa) >>> 0;
  a2 = (a2 + apTa) >>> 0;
  if (mbl !== 0) {
    const skip = (size & 1 ? 8 : 4) * mbl;
    d1 += skip;
    a2 += skip;
  }
  bl.apt = d1;
  bl.bpt = a2;
  const sh = (d0 & 15) << 12;
  bl.con0 = 0x0fca | sh;
  bl.con1 = sh;
  const blitSize = (((rows(size) << 6) | words(size)) - e.w(V.sTs)) & 0xffff;
  bl.start(blitSize);
  const plane = planeBytes(size);
  for (let p = 0; p < 2; p++) {
    bl.apt = d1;
    a2 += plane;
    bl.bpt = a2;
    a4 += PLANE;
    bl.cpt = a4;
    bl.dpt = a4;
    bl.start(blitSize);
  }
}
