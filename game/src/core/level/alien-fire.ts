// Ag_Alien_Fire.s (sea $3514–$3916): Gegnerschüsse. Bis zu 32 Schüsse (AF_Struct, 8 Byte: AF_X, AF_Y,
// Y_Count_Stat, Y_Count_Dyn, Closer_Num, Closer_Offset; AF_X < 0 = frei) fliegen 3 Pixel je Durchlauf nach links und
// alle |Y_Count_Stat| Durchläufe ein Pixel auf oder ab, gezielt auf die Eule. Angezeigt werden sie mit Sprite 5 aus
// einer Liste, nach y sortiert; liegen Schüsse weniger als 11 Zeilen untereinander, wechseln sie sich ab (AF_Lfo).

import type { LevelEngine } from "./engine.ts";

const AF_COUNT = 32;
const AF_LEN = 8;
const AF_X = 0;
const AF_Y = 2;
const AF_Y_COUNT_STAT = 4;
const AF_Y_COUNT_DYN = 5;
const AF_CLOSER_NUM = 6;
const AF_CLOSER_OFFSET = 7;
const AWO_LEN = 12;
const BANK_LEN = 2 + 2 + 16 * AWO_LEN;
/** Sprite-Liste: Steuerwörter + 8 Zeilen à 4 Byte je Schuss */
const SPR_ENTRY = 4 + 32;
/** Sprite-Position = Spielkoordinate − 256 + Fensteranfang ($90 bzw. SPR_Y_OFF $40) */
const SPR_X = 0x100 - 0x90;
const SPR_Y = 0x100 - 0x40;

const s8 = (v: number): number => (v << 24) >> 24;
const s16 = (v: number): number => (v << 16) >> 16;

export function alienFire(e: LevelEngine): void {
  const { V } = e;
  const spell = e.w(V.curentSpell);
  if (spell !== 2 && spell !== 5 && e.w(V.pause) === 0 && e.w(V.die) === 0 && e.w(V.iconesMode) === 0) {
    if (e.w(V.shortPhase) !== 0) launch(e);
    display(e);
    colision(e);
  }
  // Schüsse abschalten ($38E8), z. B. nach einer Smart Bomb
  if (e.w(V.afOff) !== 0) {
    e.setW(V.afOff, 0);
    const { L, ram } = e;
    for (let i = 0, a0 = L.afStruct; i < AF_COUNT; i++, a0 += AF_LEN) ram.setLong(a0, 0xffffffff);
    e.setL(V.sprPtrB + 5 * 4, L.emptySpr);
    ram.setLong(L.alienFireSpr, 0);
  }
}

/** LAUNCH ALIEN FIRE ($3540): jeder Gegner schießt alle F_Rt_S Durchläufe, wenn die Eule weit genug links ist */
function launch(e: LevelEngine): void {
  const { V, L, ram } = e;
  let a0 = L.awoStruct;
  for (;;) {
    const num = ram.word(a0);
    a0 += 2;
    if (num === 0 || num === 0xffff) {
      a0 += BANK_LEN - 2;
      if (a0 >= L.awoStructEnd) return;
      continue;
    }
    const off = ram.sword(a0);
    a0 += 2;
    e.setL(V.curentBankPtr, a0);
    let awo = a0 + off;
    for (let i = 0; i < num; i++, awo += AWO_LEN) {
      if ((ram.byte(awo + 8) & 0xf) !== 0) continue;
      const count = (ram.byte(awo + 10) + 1) & 0xff;
      ram.setByte(awo + 10, count);
      if (count !== ram.byte(awo + 9)) continue;
      ram.setByte(awo + 10, 0);
      let af = L.afStruct;
      while (ram.word(af) !== 0xffff) af += AF_LEN;
      const origin = L.objectsStruct + 2 + ram.sword(awo + 4);
      let d1 = s16(s8(ram.byte(origin)) + ram.word(awo));
      let d2 = s16(s8(ram.byte(origin + 1)) + ram.word(awo + 2));
      ram.setWord(af + AF_X, d1);
      ram.setWord(af + AF_Y, d2);
      ram.setByte(af + AF_Y_COUNT_DYN, 0);
      d1 = s16(d1 - e.w(V.sorcererX));
      if (d1 < 0 || d1 <= 64) {
        ram.setLong(af, 0xffffffff); // zu nah an der Eule oder hinter ihr: kein Schuss
        continue;
      }
      d2 = s16(d2 - e.w(V.sorcererY) - 45);
      let negate = 1;
      if (d2 < 0) {
        d2 = -d2;
        negate = 0;
      }
      if (d2 === 0) {
        ram.setByte(af + AF_Y_COUNT_STAT, 0);
        continue;
      }
      // i = Dx / (Dy · 3): so viele Durchläufe je Pixel in y (divu: Quotient im unteren Wort)
      let q = Math.floor(d1 / ((d2 * 3) & 0xffff)) & 0xffff;
      if (q === 0) q = 1;
      if (s16(q) > 255) {
        ram.setByte(af + AF_Y_COUNT_STAT, 0);
        continue;
      }
      if (negate) q = -q;
      ram.setByte(af + AF_Y_COUNT_STAT, q & 0xff);
    }
    a0 = e.l(V.curentBankPtr) + BANK_LEN - 4;
    if (a0 === L.awoStructEnd) return;
  }
}

/** DISPLAY ALIEN FIRE ($364C): bewegen, sortieren, Abwechseln naher Schüsse, Sprite-Liste für Sprite 5 */
function display(e: LevelEngine): void {
  const { V, L, ram } = e;
  const frozen = e.w(V.curentSpell) === 2; // Time Freeze
  for (let i = 0, a0 = L.afStruct; i < AF_COUNT; i++, a0 += AF_LEN) {
    if (ram.word(a0 + AF_X) & 0x8000) continue;
    if (!frozen) {
      ram.setWord(a0 + AF_X, ram.word(a0 + AF_X) - 3);
      ram.setByte(a0 + AF_Y_COUNT_DYN, ram.byte(a0 + AF_Y_COUNT_DYN) + 1);
    }
    let step = 1;
    let d1 = s8(ram.byte(a0 + AF_Y_COUNT_STAT));
    if (d1 < 0) {
      d1 = -d1;
      step = -1;
    }
    if ((d1 & 0xff) === ram.byte(a0 + AF_Y_COUNT_DYN)) {
      ram.setByte(a0 + AF_Y_COUNT_DYN, 0);
      if (!frozen) ram.setWord(a0 + AF_Y, ram.word(a0 + AF_Y) + step);
    }
    const x = ram.sword(a0 + AF_X);
    const y = ram.sword(a0 + AF_Y);
    if (x <= 0xfa || x >= 0x210 || y <= 0x100 || y >= 0x1c0) {
      ram.setLong(a0, 0xffffffff);
      ram.setLong(a0 + 4, 0);
    }
  }

  // Byte_Sort nach AF_Y: Zählen, Aufsummieren, Einordnen (BS_Order = Indizes von oben nach unten)
  const count = L.bsCount;
  ram.clear(count, count + 200);
  for (let i = 0, a0 = L.afStruct; i < AF_COUNT; i++, a0 += AF_LEN) {
    if (ram.word(a0 + AF_X) & 0x8000) continue;
    const at = count + s16(ram.word(a0 + AF_Y) - 0xfc);
    ram.setByte(at, ram.byte(at) + 1);
  }
  ram.setWord(L.bsOffset, 0);
  let sum = 0;
  for (let i = 0; i <= 200; i++) {
    sum = (sum + ram.byte(count + i)) & 0xff;
    ram.setByte(L.bsOffset + 1 + i, sum);
  }
  for (let i = 0; i < 32; i += 4) ram.setLong(L.bsOrder + i, 0xffffffff);
  for (let i = 0, a2 = L.afStruct; i < AF_COUNT; i++, a2 += AF_LEN) {
    if (ram.word(a2 + AF_X) & 0x8000) continue;
    const at = L.bsOffset + s16(ram.word(a2 + AF_Y) - 0xfc);
    const slot = ram.byte(at);
    ram.setByte(at, slot + 1);
    ram.setByte(L.bsOrder + slot, i);
  }

  // Compute Closer Situation ($3766): Gruppen von Schüssen mit weniger als 11 Zeilen Abstand
  const af = L.afStruct;
  let a0 = L.bsOrder;
  let d0 = 0;
  for (;;) {
    d0++;
    if (d0 >= 32) break;
    const b = ram.byte(a0++);
    if (b & 0x80) continue;
    const d1 = b << 3;
    const d2 = ram.word(af + d1 + AF_Y);
    ram.setWord(af + d1 + AF_CLOSER_NUM, 0x0100);
    let d5 = 0;
    let a2 = a0;
    for (;;) {
      const n = ram.byte(a0);
      let close = false;
      let d3 = 0;
      if (n & 0x80) {
        a0++;
        d0++;
        if (d0 < 31) continue;
      } else {
        d3 = n << 3;
        close = s16(ram.word(af + d3 + AF_Y) - d2) <= 10;
      }
      if (close) {
        a0++;
        ram.setByte(af + d1 + AF_CLOSER_NUM, ram.byte(af + d1 + AF_CLOSER_NUM) + 1);
        d5++;
        ram.setByte(af + d3 + AF_CLOSER_OFFSET, d5);
        d0++;
        if (d0 < 31) continue;
      }
      // .searsh_end: Anzahl der Gruppe in alle Mitglieder
      const num = ram.byte(af + d1 + AF_CLOSER_NUM);
      for (let k = 0; k < d5; k++) ram.setByte(af + (ram.byte(a2++) << 3) + AF_CLOSER_NUM, num);
      break;
    }
  }

  // AF LFOs: Zähler modulo 2 … 9 für Gruppen dieser Größe
  for (let k = 0; k < 8; k++) {
    const at = L.afLfo + 2 * k;
    ram.setWord(at, ram.word(at) + 1);
    if (ram.word(at) === k + 2) ram.setWord(at, 0);
  }

  // Refresh Y sprites datas: je Gruppe nur der Schuss, der gerade an der Reihe ist
  let spr = L.alienFireSpr;
  e.setL(V.sprPtrB + 5 * 4, spr);
  for (let i = 0; i < 32; i++) {
    const b = ram.byte(L.bsOrder + i);
    if (b & 0x80) continue;
    const d1 = b << 3;
    const closer = ram.byte(af + d1 + AF_CLOSER_NUM);
    if (closer !== 1) {
      const lfo = ram.word(L.afLfo + 2 * (closer - 2)) + ram.byte(af + d1 + AF_CLOSER_OFFSET);
      if ((lfo & 0xffff) !== closer - 1) continue;
    }
    const x = (ram.word(af + d1 + AF_X) - SPR_X) & 0xffff;
    const y = ((ram.word(af + d1 + AF_Y) - SPR_Y) << 8) & 0xffff;
    ram.setWord(spr, y | (x >>> 1));
    ram.setWord(spr + 2, ((y + 0x800) & 0xffff) | (x & 1));
    spr += SPR_ENTRY;
  }
  ram.setLong(spr, 0);
}

/** ALIEN FIRE COLISION TEST ($3882): Schuss (8 × 7) gegen das Rechteck der Eule */
function colision(e: LevelEngine): void {
  const { V, L, ram } = e;
  if (e.w(V.shortPhase) === 0 || e.w(V.sorcererOn) === 0) return;
  const g = L.goodColList;
  const x1 = ram.sword(g);
  const y1 = ram.sword(g + 2);
  const x2 = ram.sword(g + 4);
  const y2 = ram.sword(g + 6);
  for (let i = 0, a1 = L.afStruct; i < AF_COUNT; i++, a1 += AF_LEN) {
    const ax = ram.sword(a1 + AF_X);
    if (ax < 0 || x2 < ax) continue;
    const ay = ram.sword(a1 + AF_Y);
    if (y2 < ay || s16(ax + 8) < x1 || s16(ay + 7) < y1) continue;
    if (e.w(V.die) !== 0) continue;
    e.setB(V.die, 0xff);
    e.setW(V.dieMode, 0);
  }
}
