// Ag_Status.s (sea $3194–$348C): Statuszeile. Hires, 2 Bitplanes à 76 Byte je Zeile; Plane 1 ist fest gefüllt
// (Status_Screen_Disp), gezeichnet wird in Plane 2 (Status_Screen). Zeichen sind 8 × 16 Pixel (Status_Digit, 16 Byte
// je Zeichen). Punkte und Zauberdauer sind BCD-Zahlen; Texte (Text_Dat) überdecken die Anzeige, solange
// Text_Delay läuft (−1 = für immer, z. B. „PRESS FIRE TO START“).

import type { LevelEngine } from "./engine.ts";
import { SHARED } from "./layout.ts";
import { WORK } from "./timing.ts";

/**
 * Zeichen der Statusschrift in Code-Reihenfolge (Code = Position, ✔ aus Status_Digit gelesen). „•“ ist das
 * Leben-Symbol (Code 10); ab Code 44 die per Skript ergänzten Zeichen (Pipeline, Tabelle „status.extra“).
 */
export const STATUS_CHARS = "0123456789•ABCDEFGHIJKLMNOPQRSTUVWXYZ!?.,() ÄÖÜ";
/** Anzahl der Originalzeichen in Status_Digit */
export const STATUS_GLYPHS = 44;
/** Endmarke eines Texts in Text_Dat (Bit 7 gesetzt) */
const TEXT_END = 0xff;

/**
 * Texte der Statuszeile (Nummer 1 … n, wie Text_Num) in Zeichen-Codes umsetzen, im Format von Text_Dat
 * (Codes, dann $FF). Wirft bei Zeichen, die die Schrift nicht hat.
 */
export function encodeStatusTexts(texts: readonly string[]): Uint8Array[] {
  return texts.map((text) => {
    const codes = [...text].map((ch) => {
      const code = STATUS_CHARS.indexOf(ch);
      if (code < 0 || ch === "•") throw new Error(`Statuszeile: Zeichen „${ch}“ fehlt in der Schrift („${text}“)`);
      return code;
    });
    return Uint8Array.of(...codes, TEXT_END);
  });
}

const ROW = 76;
/** Ganze Statuszeile löschen: 76 × 18 / 4 + 1 Langwörter (dbra mit $156) */
const CLEAR_BYTES = 343 * 4;
/** Zeichen-Codes für ein volles und ein leeres Leben-Symbol (×16 = Versatz im Zeichensatz) */
const LIFE_ON = 0xa0;
const LIFE_OFF = 0x2b0;

export function status(e: LevelEngine): void {
  const { V, L, ram } = e;
  if (e.w(V.textDelay) === 0) {
    // SCORE ($319C): Punkte dieses Takts (BCD) zu Score und Extra_Life addieren
    if (e.l(V.point) !== 0) {
      addBcd3(e, SHARED.score + 4, L.d + V.point + 4);
      addBcd3(e, SHARED.extraLife + 4, L.d + V.point + 4);
      e.setL(V.point, 0);
      if (ram.long(SHARED.extraLife) >= 0x80000) {
        // Extraleben ab 80.000 Punkten
        ram.setWord(SHARED.life, (((ram.word(SHARED.life) << 1) | 1) & 0x1f));
        e.setW(V.textNum, 12);
        e.setW(V.textDelay, 50);
        ram.setLong(SHARED.extraLife, 0);
      }
      e.setB(V.refreshStatus + 1, 0xff);
    }
    let refresh = e.w(V.refreshStatus) !== 0;
    if (!refresh && e.w(V.textDelay) === 0) {
      e.setW(V.statusDelay, e.w(V.statusDelay) + 1);
      if (e.w(V.statusDelay) === 20) {
        e.setW(V.statusDelay, 0);
        refresh = true;
      }
    }
    if (refresh) {
      e.setW(V.refreshStatus, 0);
      drawScore(e);
      drawSpellTime(e);
      drawLife(e);
    }
  }

  // TEXT DISPLAY ($33FC): Zeile löschen ($3420, 343 Langwörter); die Zeichen folgen erst danach ($342E), im Original oft
  // erst nach den Rasterzeilen der Statuszeile – deshalb als eigener Schritt (LevelEngine.pendingText)
  if (e.w(V.textDelay) !== 0) {
    e.setW(V.textDelay, e.w(V.textDelay) - 1);
    const num = e.w(V.textNum);
    if (num !== 0 && num !== e.w(V.oldTextNum)) {
      e.setW(V.oldTextNum, num);
      e.setW(V.textNum, 0);
      ram.clear(L.statusScreen, L.statusScreen + CLEAR_BYTES);
      e.stepWork[WORK.clears]!++;
      e.pendingText = num;
    }
  }
  // Ende eines befristeten Texts: Statuszeile leeren und alles neu zeichnen lassen
  if (e.w(V.textDelay) === 1) {
    ram.clear(L.statusScreen, L.statusScreen + CLEAR_BYTES);
    e.stepWork[WORK.clears]!++;
    e.setB(V.oldScore, 0xff);
    e.setB(V.oldSpellTime, 0xff);
    e.setB(V.oldLife, 0xff);
    e.setB(V.refreshStatus, 0xff);
    e.setB(V.oldTextNum, 0xff);
  }
}

/** Statuszeile löschen und Text `num` zeichnen (Sprachwechsel: sofort neu) */
export function drawText(e: LevelEngine, num: number): void {
  const { L, ram } = e;
  ram.clear(L.statusScreen, L.statusScreen + CLEAR_BYTES);
  drawTextChars(e, num);
}

/**
 * Zeichen von Text `num` ab Byte 10 der Statuszeile ($342E). Englisch: Text_Dat aus dem Level-Abbild; Deutsch: die
 * übersetzte Tabelle der Engine (E-021), gleiches Format.
 */
export function drawTextChars(e: LevelEngine, num: number): void {
  const { L, ram } = e;
  let to = L.statusScreen + 10;
  const own = e.statusTexts?.[num - 1];
  if (own) {
    for (let i = 0; own[i]! < 0x80; i++) drawChar(e, to++, own[i]! << 4);
    return;
  }
  let text = L.textDat + ram.word(L.textDat + 2 * (num - 1));
  for (;;) {
    const code = ram.byte(text++);
    if (code & 0x80) break;
    drawChar(e, to++, code << 4);
  }
}

/** Zeichen (Versatz im Zeichensatz) an Byte-Position `to` der Plane 2 zeichnen: 16 Zeilen à 1 Byte */
function drawChar(e: LevelEngine, to: number, glyph: number): void {
  const { L, ram } = e;
  e.stepWork[WORK.chars]!++;
  const extra = glyph - STATUS_GLYPHS * 16;
  if (extra >= 0) {
    for (let y = 0; y < 16; y++) ram.setByte(to + y * ROW, e.extraGlyphs[extra + y]!);
    return;
  }
  for (let y = 0; y < 16; y++) ram.setByte(to + y * ROW, ram.byte(L.statusDigit + glyph + y));
}

/** 6 Ziffern des Score ab Byte 38 ($3230) */
function drawScore(e: LevelEngine): void {
  const { V, L, ram } = e;
  const score = ram.long(SHARED.score);
  if (score === e.l(V.oldScore)) return;
  e.setL(V.oldScore, score);
  for (let i = 0; i < 6; i++) drawChar(e, L.statusScreen + 38 + i, ((score >>> (4 * (5 - i))) & 15) << 4);
}

/** 2 Ziffern der Zauberdauer ab Byte 12 ($32EA) */
function drawSpellTime(e: LevelEngine): void {
  const { V, L } = e;
  const time = e.w(V.spellTime);
  if (time === e.w(V.oldSpellTime)) return;
  e.setW(V.oldSpellTime, time);
  drawChar(e, L.statusScreen + 12, time & 0xf0);
  drawChar(e, L.statusScreen + 13, (time & 15) << 4);
}

/** 5 Leben-Symbole ab Byte 68 ($3332), Bit 4 links */
function drawLife(e: LevelEngine): void {
  const { V, L, ram } = e;
  const life = ram.word(SHARED.life);
  if (life === e.w(V.oldLife)) return;
  e.setW(V.oldLife, life);
  for (let i = 0; i < 5; i++) drawChar(e, L.statusScreen + 68 + i, life & (1 << (4 - i)) ? LIFE_ON : LIFE_OFF);
}

/** abcd über 3 Byte (wie `abcd -(a2),-(a1)` dreimal, X gelöscht): Ziel += Quelle, `to`/`from` zeigen hinter die Bytes */
function addBcd3(e: LevelEngine, to: number, from: number): void {
  const ram = e.ram;
  let carry = 0;
  for (let i = 1; i <= 3; i++) {
    const a = ram.byte(to - i);
    const b = ram.byte(from - i);
    let lo = (a & 15) + (b & 15) + carry;
    let hi = (a >> 4) + (b >> 4);
    if (lo > 9) {
      lo -= 10;
      hi++;
    }
    carry = 0;
    if (hi > 9) {
      hi -= 10;
      carry = 1;
    }
    ram.setByte(to - i, (hi << 4) | lo);
  }
}
