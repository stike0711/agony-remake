// Zaubermenü, Zauber, Tastatur und Pause im Level (Quelle: Ag_Sprites.s „ICONES SPRITES“, „SPELL ROUTINES“ (0)–(7),
// Agony_Parent_.s „KEY TEST“; übertragen nach der Disassembly des Abbilds, sea $49C2–$4C04, $4C38–$54EA, $5CCC–$5EE2,
// die beim Tastaturteil vom Quelltext abweicht: Leertaste öffnet das Zaubermenü, M schaltet Menu_Mode).
// Gegen das Original noch ungeprüft (W-024). Der Schild (6) steht in interrupt.ts.

import type { LevelEngine } from "./engine.ts";
import { SHARED } from "./layout.ts";

const COLOR16 = 0x1a0;
const COLOR29 = 0x1ba;
const COLOR30 = 0x1bc;
const COLOR31 = 0x1be;

const s8 = (v: number): number => (v << 24) >> 24;
const s16 = (v: number): number => (v << 16) >> 16;

/** Tastencodes des Amiga, die das Level auswertet: P (Pause), Leertaste (Zaubermenü), M (Menu_Mode), Esc (Abbruch) */
export const KEY_P = 0x19;
export const KEY_SPACE = 0x40;
export const KEY_M = 0x37;
export const KEY_ESC = 0x45;

/** Farben 29–31 der Zauber-Sprites (move.l #c29c30,Color+58 / move #c31,Color+62) */
function spellColors(e: LevelEngine, c29: number, c30: number, c31: number): void {
  e.video.write(COLOR29, c29);
  e.video.write(COLOR30, c30);
  e.video.write(COLOR31, c31);
}

/** Sprite-Zeiger i (Spr0ptB …) */
function setSpr(e: LevelEngine, i: number, a: number): void {
  e.setL(e.V.sprPtrB + 4 * i, a);
}

// ---- Tastatur und Pause ------------------------------------------------------------------------

/** Tastatur-Interrupt: Taste gedrückt (Key+1 = Code), dann KEY TEST */
export function keyDown(e: LevelEngine, code: number): void {
  e.setB(e.V.key + 1, code);
  keyTest(e);
}

/** Tastatur-Interrupt: Taste losgelassen (Key_Up_Flag), dann KEY TEST mit dem alten Key */
export function keyUp(e: LevelEngine): void {
  e.setB(e.V.keyUpFlag + 1, 0xff);
  keyTest(e);
}

/**
 * KEY TEST ($5CCC): P Pause an/aus, Leertaste Zaubermenü (im Menü: schließen), M Menu_Mode (Zaubermenü auch mit
 * gehaltenem Feuer), Esc Abbruch des Spiels. Eine ausgewertete Taste wird verbraucht (st Key+1); jede andere neue
 * Taste beendet eine Pause. Die Tasten des Cheat-Blatts (Sheet_Flag $1D8: F1–F4, Levelsprung) fehlen noch.
 */
function keyTest(e: LevelEngine): void {
  const { V, ram } = e;
  const key = e.w(V.key);
  if (key === KEY_P) {
    if (e.w(V.beginToStart) !== 0 || e.w(V.die) !== 0) return;
    e.setB(V.key + 1, 0xff);
    if (e.w(V.pause) !== 0) pauseOff(e);
    else activePause(e);
    return;
  }
  if (key === KEY_SPACE) {
    e.setB(V.key + 1, 0xff);
    if (e.w(V.die) !== 0 || e.w(V.beginToStart) !== 0) return;
    if (e.w(V.iconesMode) !== 0) {
      pauseOff(e);
      return;
    }
    if (e.w(V.curentSpell) === 2 || e.w(V.quitDelay) !== 0) return;
    openIconsMenu(e);
    return;
  }
  if (key === KEY_ESC) {
    // Abort: Spielende
    if (e.w(V.quitDelay) !== 0) return;
    e.setW(V.quitDelay, 0x14);
    ram.setWord(SHARED.life, 0);
    e.setB(V.cleanUp, 0xff);
    return;
  }
  if (key === KEY_M) {
    e.setB(V.key + 1, 0xff);
    ram.setWord(SHARED.menuMode, ram.word(SHARED.menuMode) ^ 1);
    return;
  }
  if (e.b(V.key + 1) === 0xff || e.w(V.pause) === 0) return;
  pauseOff(e);
}

/** Active_Pause ($5E04): Pause und Stop, Statustext 10 („PAUSE“), Bit 2 (LACE) in BPLCON0 der Copperliste */
function activePause(e: LevelEngine): void {
  const { V } = e;
  e.setB(V.pause + 1, 0xff);
  e.setB(V.stop + 1, 0xff);
  e.setW(V.textNum, 10);
  e.setW(V.textDelay, 0xffff);
  e.setW(V.clBplCon0, e.w(V.clBplCon0) | 4);
}

/**
 * Pause_Off ($5DB2): Pause und Stop aus, Statustext zurück; war das Zaubermenü offen, schließt es ohne Zauber
 * (Icones_Off, alter Zauber, alle Sprites leer)
 */
export function pauseOff(e: LevelEngine): void {
  const { V, L } = e;
  e.setW(V.pause, 0);
  e.setW(V.stop, 0);
  e.setW(V.textDelay, 2);
  if (e.w(V.iconesMode) !== 0) {
    e.setB(V.iconesOff + 1, 0xff);
    e.setW(V.curentSpell, e.w(V.safeCurSpell));
    for (let i = 0; i < 8; i++) setSpr(e, i, L.emptySpr);
    e.setB(V.oldTextNum, 0xff);
  }
  e.setW(V.clBplCon0, e.w(V.clBplCon0) & 0x7ffb);
}

/** Zaubermenü öffnen (Feuer 30 Bilder gehalten, $46EA, oder Leertaste, $5D66): Spiel angehalten, Pfeil auf Zeile 2 */
export function openIconsMenu(e: LevelEngine): void {
  const { V } = e;
  e.setW(V.safeCurSpell, e.w(V.curentSpell));
  e.setB(V.pause + 1, 0xff);
  e.setB(V.stop + 1, 0xff);
  e.setB(V.iconesMode + 1, 0xff);
  e.setW(V.arowY, 0x30);
  e.setW(V.iconesFireUp, 0);
}

// ---- ICONES SPRITES ($49C2) ----------------------------------------------------------------------

/**
 * Zaubermenü: Joystick hoch/runter bewegt den Pfeil um 24 Zeilen (2 je Bild) zum nächsten Zauber; steht er auf
 * einem, wird er Curent_Spell und sein Name erscheint in der Statuszeile. Sprites 4–7 zeigen die Symbole, 0/1 den
 * Pfeil, 2/3 verdecken nicht verfügbare Zauber. Feuer (nach einmal Loslassen) wählt: verfügbar → Zauber startet
 * (Dauer aus Time_Table), sonst Menü zu ohne Zauber.
 */
export function icons(e: LevelEngine): void {
  const { V, L, ram } = e;
  if (e.w(V.iconesOff) !== 0) {
    // Quit_Icones: Farben 16–31 wieder Sorcerer_Pal
    e.setW(V.iconesOff, 0);
    e.setW(V.iconesMode, 0);
    for (let i = 0; i < 16; i++) e.video.write(COLOR16 + 2 * i, ram.word(L.sorcererPal + 2 * i));
  }
  if (e.w(V.iconesMode) === 0) return;
  if ((e.w(V.arowDown) | e.w(V.arowUp)) === 0) {
    // JOYSTICK TEST: runter = Bit 1 XOR Bit 0, hoch = Bit 9 XOR Bit 8
    const d0 = (e.joy1dat >> 8) & 0xff;
    const d5 = e.joy1dat & 0xff;
    if (((d5 >> 1) ^ d5) & 1) {
      if (e.w(V.curentSpell) !== 7) e.setB(V.arowDown + 1, 0xff);
    } else if (((d0 >> 1) ^ d0) & 1) {
      if (e.w(V.curentSpell) !== 0) e.setB(V.arowUp + 1, 0xff);
    }
  }
  if (e.w(V.arowDown) !== 0) e.setW(V.arowY, e.w(V.arowY) + 2);
  if (e.w(V.arowUp) !== 0) e.setW(V.arowY, e.w(V.arowY) - 2);
  e.setW(V.selectionOn, 0);
  const y = e.w(V.arowY);
  if (y % 24 === 0) {
    const n = (y / 24) | 0;
    e.setW(V.curentSpell, n);
    e.setW(V.textNum, n + 1);
    e.setW(V.textDelay, 0xffff);
    e.setW(V.arowUp, 0);
    e.setW(V.arowDown, 0);
    e.setB(V.selectionOn + 1, 0xff);
  }
  for (let i = 0; i < 16; i++) e.video.write(COLOR16 + 2 * i, e.w(V.iconesPal + 2 * i));
  // Symbole: Sprites 4–7 à 768 Byte
  const icons = L.d + V.iconesSpr;
  for (let i = 0; i < 4; i++) setSpr(e, 4 + i, icons + 0x300 * i);
  // Pfeil: Sprite 0 und 1 (VSTART = Arow_Y + $46, HSTART $7C, 15 Zeilen)
  const v = (y + 0x46) & 0xffff;
  const ctl = ((((v << 8) | 0x7c) & 0xffff) << 16 | ((((v + 15) << 8) | 0x80) & 0xffff)) >>> 0;
  const arow = L.d + V.arowSpr;
  ram.setLong(arow, ctl);
  setSpr(e, 0, arow);
  ram.setLong(arow + 0x44, ctl);
  setSpr(e, 1, arow + 0x44);
  // Maske: Sprite 2 und 3; je Zauber 24 Zeilen, nicht verfügbare mit 15 Zeilen aus Arow_Spr + 140 verdeckt
  let a0 = L.d + V.maskSpr;
  let a1 = a0 + 0x308;
  setSpr(e, 3, a1);
  setSpr(e, 2, a0);
  a0 += 4;
  a1 += 4;
  for (let i = 0; i < 8; i++) {
    if (ram.word(SHARED.spellAdvailable + 2 * i) !== 0) {
      for (let k = 0; k < 24; k++, a0 += 4, a1 += 4) {
        ram.setLong(a0, 0);
        ram.setLong(a1, 0);
      }
    } else {
      let a2 = L.d + V.arowSpr + 140;
      let a4 = a2 + 0x44;
      a0 += 16;
      a1 += 16;
      for (let k = 0; k < 15; k++, a0 += 4, a1 += 4, a2 += 4, a4 += 4) {
        ram.setLong(a0, ram.long(a2));
        ram.setLong(a1, ram.long(a4));
      }
      a0 += 20;
      a1 += 20;
    }
  }
  // FIRE TEST: erst nach einmal Loslassen, nur auf einem Zauber
  if (!e.fire) e.setB(V.iconesFireUp + 1, 0xff);
  if (!e.fire || e.w(V.iconesFireUp) === 0 || e.w(V.selectionOn) === 0) return;
  for (let i = 0; i < 8; i++) setSpr(e, i, L.emptySpr);
  e.setB(V.oldTextNum, 0xff);
  const spell = e.w(V.curentSpell);
  const adv = SHARED.spellAdvailable + s16((spell * 2) & 0xffff);
  if (ram.word(adv) === 0) {
    e.setW(V.curentSpell, e.w(V.safeCurSpell));
    e.setW(V.textDelay, 2);
    e.setW(V.pause, 0);
    e.setW(V.stop, 0);
    e.setW(V.fireCount, 0);
    e.setB(V.iconesOff, 0xff);
    return;
  }
  // START A SPELL
  ram.setWord(adv, 0);
  e.setW(V.pause, 0);
  e.setW(V.stop, 0);
  e.setW(V.fireCount, 0);
  e.setW(V.textDelay, 2);
  e.setW(V.spellTimeDelay, 50);
  e.setW(V.spellTime, e.w(V.timeTable + s16((spell * 2) & 0xffff)));
  e.setB(V.iconesOff, 0xff);
  e.setW(V.sorcerer2X, e.w(V.sorcererX));
  e.setW(V.sorcerer2Y, e.w(V.sorcererY));
}

// ---- Äxte ($496C–$49C0) -------------------------------------------------------------------------

/** Kollisionsrechtecke der eingeschalteten Äxte (Good_Col_List + 16 bzw. + 24): 32 × 8 Pixel */
export function axeRects(e: LevelEngine): void {
  const { V, L, ram } = e;
  if (ram.word(SHARED.axeUpOn) !== 0) rect(e, L.goodColList + 16, e.w(V.axeUpX), e.w(V.axeUpY), 0x20, 8);
  if (ram.word(SHARED.axeDownOn) !== 0) rect(e, L.goodColList + 24, e.w(V.axeDownX), e.w(V.axeDownY), 0x20, 8);
}

function rect(e: LevelEngine, a: number, x: number, y: number, w: number, h: number): void {
  const ram = e.ram;
  ram.setWord(a, x);
  ram.setWord(a + 2, y);
  ram.setWord(a + 4, x + w);
  ram.setWord(a + 6, y + h);
}

// ---- (0) BACK FIRE BALL ($4C62) -----------------------------------------------------------------

/** Zwei Feuerbälle fliegen hinter der Eule nach links (10 Pixel je Bild), jeder als Säule aus drei Kugeln */
export function backFireBall(e: LevelEngine): void {
  const { V, L } = e;
  // st Color+62(C): Bytezugriff auf ein Farbregister, der 68000 legt das Byte auf beide Hälften → $FFFF
  spellColors(e, 0x058f, 0x08cf, 0xffff);
  e.setW(V.backFbX0, e.w(V.backFbX0) - 10);
  const d0 = e.w(V.backFbX0);
  if (d0 === 0xff9c) e.setW(V.backFbX1, 0);
  e.setW(V.backFbX1, e.w(V.backFbX1) - 10);
  const d1 = e.w(V.backFbX1);
  if (d1 === 0xff9c) e.setW(V.backFbX0, 0);
  const d3 = (e.w(V.sorcererY) - 0x92) & 0xffff;
  const d2 = e.w(V.sorcererX);
  let a1 = L.goodColList + 32;
  a1 = backBall(e, a1, d0, d3, d2, L.d + V.backFbSpr0, 6);
  backBall(e, a1, d1, d3, d2, L.d + V.backFbSpr1, 7);
}

function backBall(e: LevelEngine, a1: number, dx: number, d3: number, d2: number, spr: number, sprite: number): number {
  const ram = e.ram;
  let d4 = (d3 + dx - 14) & 0xffff;
  if (s16(d4) <= 0x30) d4 = 0x30;
  const d5 = d3;
  const d6 = (d3 - dx) & 0xffff;
  let d0 = (dx + d2) & 0xffff;
  ram.setWord(a1, d0);
  ram.setWord(a1 + 2, d4 + 0x92);
  ram.setWord(a1 + 4, d0 + 0x20);
  ram.setWord(a1 + 6, d6 + 0xa0);
  d0 = ((d0 - 0x66) & 0xffff) >>> 1;
  setSpr(e, sprite, spr);
  let a0 = spr;
  ram.setWord(a0, ((d4 << 8) & 0xffff) | d0);
  ram.setWord(a0 + 2, ((d4 + 13) << 8) & 0xffff);
  a0 += 4 + 0x34;
  ram.setWord(a0, ((d5 << 8) & 0xffff) | d0);
  ram.setWord(a0 + 2, ((d5 + 5) << 8) & 0xffff);
  a0 += 4 + 0x14;
  ram.setWord(a0, ((d6 << 8) & 0xffff) | d0);
  ram.setWord(a0 + 2, ((d6 + 13) << 8) & 0xffff);
  return a1 + 8;
}

// ---- (1) ROTATIVE FIRE BALL ($4D9A) -------------------------------------------------------------

/** Acht Feuerbälle kreisen um die Eule (Rot_Table, 9 Schritte); vier feste Rechtecke um die Eule treffen */
export function rotativeFireBall(e: LevelEngine): void {
  const { V, L } = e;
  spellColors(e, 0x0ff9, 0x0f85, 0x0d40);
  const spr0 = L.d + V.fball3Spr0;
  const spr1 = L.d + V.fball3Spr1;
  setSpr(e, 6, spr0);
  setSpr(e, 7, spr1);
  const step = e.w(V.rotStep);
  e.setW(V.rotStep, step + 1);
  if (step === 8) e.setW(V.rotStep, 0);
  const a2 = L.d + V.rotTable + s16((step << 4) & 0xffff);
  const d3 = (e.w(V.sorcererX) - 0x64) & 0xffff;
  const d4 = (e.w(V.sorcererY) - 0x9b) & 0xffff;
  rotBalls(e, a2, d3, d4, spr0, 6);
  rotBalls(e, a2 + 8, d3, d4, spr1, 7);
  const x = e.w(V.sorcererX);
  const y = e.w(V.sorcererY);
  const a0 = L.goodColList + 32;
  rect(e, a0, x - 0x28, y - 0x3c, 0x78, 0x14);
  rect(e, a0 + 8, x + 0x64, y - 0x28, 0x14, 0x78);
  rect(e, a0 + 16, x - 0x28, y + 0x64, 0x78, 0x14);
  rect(e, a0 + 24, x - 0x3c, y - 0x28, 0x14, 0x78);
}

/** Vier Kugeln eines Sprites aus Rot_Table (Bytepaare dx, dy); über dem Fenster rückt der Zeiger um eine Kugel weiter */
function rotBalls(e: LevelEngine, a2: number, d3: number, d4: number, spr: number, sprite: number): void {
  const { V, ram } = e;
  let a0 = spr;
  for (let i = 0; i < 4; i++, a2 += 2, a0 += 4 + 0x3c) {
    const x = ((s8(ram.byte(a2)) + d3) & 0xffff) >>> 1;
    const y = (s8(ram.byte(a2 + 1)) + d4) & 0xffff;
    if (s16(y) <= 0x30) setSpr(e, sprite, e.l(V.sprPtrB + 4 * sprite) + 0x40);
    ram.setWord(a0, ((y << 8) & 0xffff) | x);
    ram.setWord(a0 + 2, ((y + 15) << 8) & 0xffff);
  }
}

// ---- (2) STOP TIME ($4ED6) ----------------------------------------------------------------------

/** Die Zeit steht (Stop, Gegnerschüsse aus); eine Uhr (Sprites 6/7) läuft Time_Y_Table ab, nach 240 Bildern Ende */
export function stopTime(e: LevelEngine): void {
  const { V, L, ram } = e;
  e.setB(V.stop + 1, 0xff);
  e.setB(V.refreshStatus + 1, 0xff);
  e.setB(V.afOff + 1, 0xff);
  spellColors(e, 0x0000, 0x0222, 0x0333);
  e.setW(V.timeY, e.w(V.timeY) + 1);
  const d0 = e.w(V.timeY);
  if (s16(d0) >= 0xf0) {
    if (e.w(V.prgPause) === 0) {
      e.setW(V.stop2, 0);
      e.setW(V.stop, 0);
    }
    e.setW(V.timeY, 0);
    e.setB(V.curentSpell + 1, 0xff);
  }
  let d1 = (ram.byte(L.d + V.timeYTable + s16(d0)) + 0xe) & 0xffff;
  e.setW(V.timeStep, (e.w(V.timeStep) + 0x100) & 0xf00);
  const a0 = L.d + V.timeSpr + s16(e.w(V.timeStep));
  const a1 = a0 + 0x80;
  ram.setLong(a1 + 0x80, 0);
  setSpr(e, 6, a0);
  setSpr(e, 7, a1);
  d1 = (d1 << 8) & 0xffff;
  const d2 = (d1 + 0x1f00) & 0xffff;
  d1 |= 0xc0;
  ram.setWord(a0, d1);
  ram.setWord(a0 + 2, d2);
  ram.setWord(a1, (d1 + 8) & 0xffff);
  ram.setWord(a1 + 2, d2);
}

// ---- (3) SEEKER ($4F6E) -------------------------------------------------------------------------

/**
 * Eine zweite Eule (Sorcerer2) fliegt mit 2 Pixel je Bild zum Gegner, der waagrecht am nächsten an der Eule ist,
 * sofern er im Spielfeld liegt; ihr Kollisionsrechteck trifft
 */
export function seeker(e: LevelEngine): void {
  const { V, L, ram } = e;
  let d3 = 0x1b4;
  let d4 = 0x150;
  let d5 = 0x7fff;
  const sx = e.w(V.sorcererX);
  let a0 = L.awoStruct;
  for (;;) {
    const n = ram.word(a0);
    a0 += 2;
    if (n === 0 || n === 0xffff) {
      a0 += 0xc2;
      if (a0 >= L.awoStructEnd) break;
      continue;
    }
    const off = ram.sword(a0);
    a0 += 2;
    const a1 = a0;
    a0 += off;
    for (let i = 0; i < n; i++, a0 += 12) {
      if (ram.byte(a0 + 8) !== 0) continue;
      const x = ram.word(a0);
      let dist = s16((x - sx) & 0xffff);
      if (dist < 0) dist = s16(-dist & 0xffff);
      if (s16(d5) > dist) {
        d5 = dist;
        d3 = x;
        d4 = ram.word(a0 + 2);
      }
    }
    a0 = a1 + 0xc0;
    if (a0 === L.awoStructEnd) break;
  }
  let d1 = e.w(V.sorcerer2X);
  let d0 = e.w(V.sorcerer2Y);
  if (!(s16(d3) > 0x218 || s16(d3) < 0x100 || s16(d4) < 0x100 || s16(d4) > 0x1be)) {
    d1 = (s16(d1) > s16(d3) ? d1 - 2 : d1 + 2) & 0xffff;
    d0 = (s16(d0) > s16(d4) ? d0 - 2 : d0 + 2) & 0xffff;
    if (s16(d0) >= 0x184) d0 = 0x184;
    e.setW(V.sorcerer2X, d1);
    e.setW(V.sorcerer2Y, d0);
  }
  // nah am Ziel: Anzeige und Rechteck auf das Ziel (Sorcerer2_X/Y bleiben)
  if (abs16(d3 - d1) <= 2) d1 = d3;
  if (abs16(d4 - d0) <= 2) d0 = d4;
  d1 = (d1 - 0x10) & 0xffff;
  d0 = (d0 - 0x28) & 0xffff;
  rect(e, L.goodColList + 32, d1, (d0 + 0x25) & 0xffff, 0x40, 0x20);
  spellColors(e, 0x0ff8, 0x0fb0, 0x0f60);
  const head = L.sorcerer2Dat + e.sw(V.sorcerer2Shape);
  const a1 = L.sorcerer2Dat + ram.sword(head + 4);
  const a2 = L.sorcerer2Dat + ram.sword(head + 6);
  setSpr(e, 6, a1);
  setSpr(e, 7, a2);
  const y = (d0 - 0xc0 + ram.word(head)) & 0xffff;
  const x = (d1 - 0x70) & 0xffff;
  const pos = (y << 8) & 0xffff;
  const ctl = (((y + ram.word(head + 2)) << 8) & 0xffff) | (x & 1);
  ram.setLong(a1, ((pos | (x >>> 1)) << 16 | ctl) >>> 0);
  ram.setLong(a2, ((pos | (((x >>> 1) + 8) & 0xffff)) << 16 | ctl) >>> 0);
}

/** Betrag in 16 Bit wie sub/bpl/neg ($8000 bleibt negativ) */
function abs16(v: number): number {
  const d = s16(v & 0xffff);
  return d < 0 ? s16(-d & 0xffff) : d;
}

// ---- (4) SMART BOMB ($50F4) ---------------------------------------------------------------------

/** Zwei Druckwellen laufen von der Eule nach links und rechts auseinander (bis 128, dann von vorn) */
export function smartBomb(e: LevelEngine): void {
  const { V, L, ram } = e;
  spellColors(e, 0x0ff8, 0x0fb0, 0x0f60);
  e.setW(V.smartBStep, e.w(V.smartBStep) + 0x274);
  let d0 = e.w(V.smartBStep);
  if (d0 === 0xeb8) {
    d0 = 0;
    e.setW(V.smartBStep, 0);
  }
  const base = L.d + V.smartBSpr;
  const a0 = base + s16(d0);
  const a1 = base + 0xeb8 + s16(d0);
  e.setW(V.smartBStepHC, e.w(V.smartBStepHC) + 1);
  if (e.w(V.smartBStepHC) === 5) {
    e.setW(V.smartBStepH, e.w(V.smartBStepH) + 1);
    e.setW(V.smartBStepHC, 0);
  }
  d0 = (e.w(V.smartBX) + e.w(V.smartBStepH)) & 0xffff;
  if (s16(d0) > 0x80) {
    d0 = 0;
    e.setW(V.smartBStepH, 0);
  }
  e.setW(V.smartBX, d0);
  let d1 = ((e.w(V.sorcererX) - 0x70) & 0xffff) >>> 1;
  let d2 = (d1 + d0) & 0xffff;
  d1 = (d1 - d0) & 0xffff;
  if (s16(d2) >= 0xde) d2 = 0xde;
  d2 = (d2 + 0x10) & 0xffff;
  d1 = (d1 - 8) & 0xffff;
  let y = e.w(V.sorcererY);
  if (s16(y) <= 0x120) y = 0x120;
  if (s16(y) >= 0x144) y = 0x144;
  const pos = ((y - 0xde) << 8) & 0xffff;
  const ctl = (pos + 0x9c00) & 0xffff;
  ram.setWord(a0, pos | d1);
  ram.setWord(a0 + 2, ctl);
  ram.setWord(a1, pos | d2);
  ram.setWord(a1 + 2, ctl);
  setSpr(e, 6, a0);
  setSpr(e, 7, a1);
  const x = e.w(V.sorcererX);
  const d6 = y - 0x1e;
  const r = e.w(V.smartBX);
  rect(e, L.goodColList + 32, x - r, d6, 0x32, 0x9c);
  rect(e, L.goodColList + 40, x + r, d6, 0x32, 0x9c);
}

// ---- (5) MEGA BLAST ($51FE) ---------------------------------------------------------------------

/** Ein Strahl (Sprites 4–7) schießt nach rechts; Schuss der Eule und Gegnerschüsse aus */
export function megaBlast(e: LevelEngine): void {
  const { V, L, ram } = e;
  spellColors(e, 0x0fff, 0x0ffc, 0x0ff8);
  e.setB(V.fwFireOff + 1, 0xff);
  e.setB(V.afOff + 1, 0xff);
  const a0 = L.d + V.megaBSpr;
  e.setW(V.megaBX, (e.w(V.megaBX) + 0xa) & 0x7f);
  const d5 = e.w(V.megaBX);
  const d3 = e.w(V.sorcererX);
  let d1 = ((((d3 - 0x50) & 0xffff) >>> 1) + d5) & 0xffff;
  if (s16(d1) >= 0xde) d1 = 0xde;
  const d4 = e.w(V.sorcererY);
  let y = d4;
  if (s16(y) <= 0x120) y = 0x120;
  if (s16(y) >= 0x14a) y = 0x14a;
  const pos = ((y - 0xde) << 8) & 0xffff;
  const ctl = (pos + 0x9600) & 0xffff;
  let d0 = pos | d1;
  for (let i = 0; i < 4; i++, d0 = (d0 + 8) & 0xffff) {
    ram.setWord(a0 + 0x25c * i, d0);
    ram.setWord(a0 + 0x25c * i + 2, ctl);
  }
  setSpr(e, 6, a0);
  setSpr(e, 7, a0 + 0x25c);
  setSpr(e, 4, a0 + 0x25c * 2);
  setSpr(e, 5, a0 + 0x25c * 3);
  rect(e, L.goodColList + 32, (d3 + 2 * d5) & 0xffff, d4, 0x40, 0x96);
}

// ---- (7) FORWARD FIRE BALL ($534E) --------------------------------------------------------------

/** Zwei Feuerbälle fliegen vor der Eule nach rechts (8 Pixel je Bild), auf und ab nach Sin_Table */
export function forwardFireBall(e: LevelEngine): void {
  const { V, L } = e;
  spellColors(e, 0x0ff9, 0x0fb7, 0x0f85);
  e.setW(V.fwFbX0, e.w(V.fwFbX0) + 8);
  const d0 = e.w(V.fwFbX0);
  if (d0 === 0x80) e.setW(V.fwFbX1, 0);
  e.setW(V.fwFbX1, e.w(V.fwFbX1) + 8);
  const d1 = e.w(V.fwFbX1);
  if (d1 === 0x80) e.setW(V.fwFbX0, 0);
  const sin = L.d + V.sinTable;
  const d3 = (e.w(V.sorcererY) - 0x92) & 0xffff;
  const d2 = (e.w(V.sorcererX) - 0x66) & 0xffff;
  const a3 = L.goodColList + 32;
  forwardBall(e, a3, sin + (d0 >>> 3), d3, d2, d0, L.d + V.fball3Spr0, 6);
  forwardBall(e, a3 + 16, sin + (d1 >>> 3), d3, d2, d1, L.d + V.fball3Spr1, 7);
}

function forwardBall(e: LevelEngine, a3: number, sinAt: number, d3: number, d2: number, dx: number, spr: number, sprite: number): void {
  const ram = e.ram;
  const dy = ram.byte(sinAt);
  let d4 = (d3 - dy) & 0xffff;
  if (s16(d4) <= 0x30) d4 = 0x30;
  const d5 = (d3 + dy) & 0xffff;
  let x = (dx + d2) & 0xffff;
  if (s16(x) >= 0x1bc) x = 0x1bc;
  setSpr(e, sprite, spr);
  // Rechtecke: obere Kugel [x+$70, d4+$C0, +$20, +$10], untere [gleiches x, d5+$C0, +$20, +$10]
  const rx = (x + 0x70) & 0xffff;
  ram.setWord(a3, rx);
  ram.setWord(a3 + 2, d4 + 0xc0);
  ram.setWord(a3 + 4, rx + 0x20);
  ram.setWord(a3 + 6, ram.word(a3 + 2) + 0x10);
  ram.setWord(a3 + 8, rx);
  ram.setWord(a3 + 10, d5 + 0xc0);
  ram.setWord(a3 + 12, rx + 0x20);
  ram.setWord(a3 + 14, ram.word(a3 + 10) + 0x10);
  const h = x >>> 1;
  let a0 = spr;
  ram.setWord(a0, ((d4 << 8) & 0xffff) | h);
  ram.setWord(a0 + 2, ((d4 + 15) << 8) & 0xffff);
  a0 += 4 + 0x3c;
  ram.setWord(a0, ((d5 << 8) & 0xffff) | h);
  ram.setWord(a0 + 2, ((d5 + 15) << 8) & 0xffff);
  a0 += 4 + 0x3c;
  ram.setLong(a0, 0);
}
