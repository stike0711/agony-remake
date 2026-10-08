// Ag_Playability_.s (sea $29D2–$3194): Startliste, Bahnen der Angriffswellen, Paletten des vorderen Playfields,
// Kollisionen der Gegner mit Eule und Schuss. Die Objekt-Routinen (START_C, ROUTINE MANAGER) stehen in routines.ts.
// Die Engine ruft die Teile einzeln auf (playability, colisionTest, routineManager), weil das Original sie je nach
// Last vor oder nach dem Copper-Interrupt erreicht (Zeitmodell, timing.ts).
//
// Strukturen (Adressen in layout.ts):
//   Track_Table  16 Zeiger auf TS-Strukturen, Bit 31 gesetzt = frei
//   TS           +0 AWO-Bank, +4 Wellenbeschreibung (AWS, Bit 30 = absolute Bahn), +8 Anzahl Gegner, +$A erster
//                lebender Gegner (×4), +$B eigener Index in Track_Table (×4), +$C/+$E Startpunkt, ab +$10 je Gegner
//                ein Langwort: Position auf der Bahn (oberes Wort, +1 je Durchlauf) und Animationsschritt (+2)
//   AWS          +0/+2 Versatz der x-/y-Bahn, +4 Animation (Anim_Base), +6 Abstand, +7 Anzahl, +8 Energie,
//                +$A Schussrate, +$B jeder wievielte schießt, +$C 6 Zeilen-Schalter, +$12 7 Farben
//   Bahnen       Startwort (nur relative Bahnen), dann Nibbles mit Vorzeichen: x- und y-Schritt je Durchlauf, −8 = Ende

import type { LevelEngine } from "./engine.ts";
import { soundStart } from "./sounds.ts";
import { WORK } from "./timing.ts";

const TRACKS = 16;
const TS_AWO_PTR = 0;
const TS_AWS_PTR = 4;
const TS_ALIEN_NUM = 8;
const TS_FIRST_ALIEN = 0x0a;
const TS_NUM = 0x0b;
const TS_X_START = 0x0c;
const TS_Y_START = 0x0e;
const TS_ALIENS = 0x10;
const AWS_TABLE_X_OFF = 0;
const AWS_TABLE_Y_OFF = 2;
const AWS_TABLE_OBJ_OFF = 4;
const AWS_ALIEN_RATE = 6;
const AWS_ALIEN_NUM = 7;
const AWS_ALIEN_ENERGY = 8;
const AWS_ALIEN_BAD_F = 0x0a;
const AWS_ALIEN_F_RATE = 0x0b;
const AWS_PAL_MOD_LIN0 = 0x0c;
const AWS_PAL_MOD_COL1 = 0x12;
const AWO_LEN = 12;
const AWO_X = 0;
const AWO_Y = 2;
const AWO_OBJ_OFF = 4;
const AWO_ENERGY = 6;
const AWO_STATUS = 8;
const AWO_F_RT_S = 9;
const AWO_F_RT_D = 0x0a;
const BANK_LEN = 2 + 2 + 16 * AWO_LEN;
/** Rout_Struct: 32 Einträge à 28 Byte (Code, Parameter, AWO-Bank, 16 Byte Variablen), −1 = frei */
const ROUT_LEN = 28;
/** Fw_F_Off: Schuss der Eule aus */
const FW_F_OFF = 0xf0;

const s16 = (v: number): number => (v << 16) >> 16;
const s8 = (v: number): number => (v << 24) >> 24;

/**
 * Startliste und Bahnen ($29DA–$2DC4); ohne Wirkung bei Pause2 (die Engine prüft das). Die Paletten folgen als eigener
 * Schritt (paletteCtrl), weil das Original sie oft erst Zeilen später in die Copperliste schreibt.
 */
export function playability(e: LevelEngine): void {
  const { V } = e;
  if (e.w(V.curentSpell) === 2 || e.w(V.beginToStart) !== 0) return;
  if (e.w(V.cleanUp) === 0) {
    // INTERPRET START LIST: Level_X zählt je Durchlauf um 2; ein neuer Eintrag nur in kurzen Durchläufen
    e.setW(V.levelX, e.w(V.levelX) + 2);
    if (e.w(V.shortPhase) !== 0 && e.sw(V.levelX) >= e.sw(V.slWaiting)) startListEntry(e);
  }
  trackFollower(e);
}

/** Ein Eintrag der Startliste ($2A0C): Welle auf eine freie Bahn und eine freie AWO-Bank setzen */
function startListEntry(e: LevelEngine): void {
  const { V, L, ram } = e;
  let a0 = e.l(V.startListPtr);
  const d0 = ram.long(a0);
  a0 += 4;
  if (d0 & 0x80000000) {
    routineStart(e, d0, a0);
    return;
  }
  e.stepWork[WORK.startEntry]!++;
  let d1 = 0;
  let d2 = 0;
  if (d0 & 0x40000000) {
    d1 = ram.word(a0);
    d2 = ram.word(a0 + 2);
    a0 += 4;
  }
  e.setB(V.refreshPal + 1, 0xff);
  let entry = L.trackTable;
  while ((ram.byte(entry) & 0x80) === 0) entry += 4;
  ram.setByte(entry, ram.byte(entry) & 0x7f);
  const ts = ram.long(entry);
  ram.setLong(ts + TS_AWS_PTR, d0);
  ram.setWord(ts + TS_ALIEN_NUM, 0);
  ram.setByte(ts + TS_FIRST_ALIEN, 0);
  ram.setWord(ts + TS_X_START, d1);
  ram.setWord(ts + TS_Y_START, d2);
  const aws = d0 & 0x3fffffff;
  let bank = L.awoStruct;
  while ((ram.word(bank) & 0x8000) === 0) bank += BANK_LEN;
  ram.setLong(bank, 0);
  ram.setLong(ts + TS_AWO_PTR, bank);
  // Energie und Schussrate der 16 Gegner: jeder F_Rate-te schießt mit Rate Bad_F, die anderen mit $FF
  const energy = ram.word(aws + AWS_ALIEN_ENERGY);
  const fRate = ram.byte(aws + AWS_ALIEN_F_RATE);
  let n = 0;
  for (let i = 0, awo = bank + 4; i < 16; i++, awo += AWO_LEN) {
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
  slCtrl(e, a0);
}

/**
 * ROUTINE START ($2AA0): freien Eintrag der Rout_Struct und freie AWO-Bank belegen, Variablen löschen; die
 * Parameter bleiben in der Startliste (bis PAR_END $FFFF). Die Routine selbst läuft erst im ROUTINE MANAGER.
 */
function routineStart(e: LevelEngine, d0: number, a0: number): void {
  const { L, ram } = e;
  e.stepWork[WORK.routineStart]!++;
  let a1 = L.routStruct;
  while ((ram.long(a1) & 0x80000000) === 0) a1 += ROUT_LEN;
  ram.setLong(a1, d0 & 0x7fffffff);
  ram.setLong(a1 + 4, a0);
  let bank = L.awoStruct;
  while ((ram.word(bank) & 0x8000) === 0) bank += BANK_LEN;
  ram.setLong(a1 + 8, bank);
  ram.setLong(bank, 0);
  for (let i = 12; i < ROUT_LEN; i += 4) ram.setLong(a1 + i, 0);
  while (ram.word(a0) !== 0xffff) a0 += 2;
  slCtrl(e, a0 + 2);
}

/** SL_Ctrl ($2AE0): nächste Wartemarke und Zeiger auf den folgenden Eintrag */
function slCtrl(e: LevelEngine, a0: number): void {
  e.setW(e.V.slWaiting, e.ram.word(a0));
  e.setL(e.V.startListPtr, a0 + 2);
}

/** TRACK FOLOWER ($2AE8): Gegner aller Wellen einen Schritt auf ihrer Bahn weiter, neue Gegner einreihen */
function trackFollower(e: LevelEngine): void {
  const { L, ram } = e;
  for (let t = 0; t < TRACKS; t++) {
    const ts = ram.long(L.trackTable + 4 * t);
    if (ts & 0x80000000) continue;
    e.stepWork[WORK.tracks]!++;
    const awsPtr = ram.long(ts + TS_AWS_PTR);
    const absolute = (awsPtr & 0x40000000) !== 0;
    const aws = awsPtr & 0x3fffffff;
    let num = ram.word(ts + TS_ALIEN_NUM);
    let first = ram.byte(ts + TS_FIRST_ALIEN);
    // Positionen aller lebenden Gegner +1, Animationsschritt +2; dem letzten folgt nach AWS_Alien_Rate ein neuer
    let addNew = num === 0;
    if (!addNew) {
      let a2 = ts + TS_ALIENS + first;
      let last = 0;
      for (let i = 0; i < num; i++, a2 += 4) {
        ram.setLong(a2, (ram.long(a2) + 0x00010002) >>> 0);
        last = ram.word(a2);
      }
      addNew = (last & 0xff) === ram.byte(aws + AWS_ALIEN_RATE);
    }
    if (addNew && (num & 0xff) !== ram.byte(aws + AWS_ALIEN_NUM) && first === 0) {
      ram.setWord(ts + TS_ALIEN_NUM, ram.word(ts + TS_ALIEN_NUM) + 1);
      ram.setLong(ts + TS_ALIENS + 4 * num, 0);
      num++;
    }
    // UPDATE ALIENS IN AWO
    let tx = (absolute ? L.absoluteTracks : L.relativeTracks) + ram.sword(aws + AWS_TABLE_X_OFF);
    let ty = (absolute ? L.absoluteTracks : L.relativeTracks) + ram.sword(aws + AWS_TABLE_Y_OFF);
    const anim = ram.sword(aws + AWS_TABLE_OBJ_OFF);
    let a2 = ts + TS_ALIENS + first;
    const bank = ram.long(ts + TS_AWO_PTR);
    ram.setWord(bank, num);
    const offPtr = bank + 2;
    let awo = bank + 4 + first + 2 * first;
    let removed = false;
    e.stepWork[WORK.trackAliens]! += num;
    for (let i = 0; i < num; i++, awo += AWO_LEN) {
      let pos = ram.word(a2);
      a2 += 2;
      if (pos === 0) {
        if (absolute) {
          ram.setWord(awo + AWO_X, ram.word(ts + TS_X_START));
          ram.setWord(awo + AWO_Y, ram.word(ts + TS_Y_START));
        } else {
          // Startpunkt aus dem Kopf der Bahn, x relativ zum Scrollen
          ram.setWord(awo + AWO_X, (ram.word(tx) - e.w(e.V.levelX) + 0x120) & 0xffff);
          ram.setWord(awo + AWO_Y, ram.word(ty));
          tx += 2;
          ty += 2;
        }
      } else {
        // relative Bahnen lesen ab Position + 1 (das Startwort wird übersprungen), absolute ab Position − 1
        pos = absolute ? pos - 1 : pos + 1;
        const index = (pos & 0xffff) >>> 1;
        let dx = ram.byte(tx + s16(index));
        let dy = ram.byte(ty + s16(index));
        if ((pos & 1) === 0) {
          dx >>= 4;
          dy >>= 4;
        }
        dx = (dx & 8 ? (dx & 0xf) | 0xfff0 : dx & 0xf) & 0xffff;
        dy = (dy & 8 ? (dy & 0xf) | 0xfff0 : dy & 0xf) & 0xffff;
        if (dx === 0xfff8) {
          // Ende der Bahn: der vorderste Gegner fällt weg
          ram.setByte(ts + TS_FIRST_ALIEN, (ram.byte(ts + TS_FIRST_ALIEN) + 4) & 0xff);
          ram.setWord(offPtr, ram.word(offPtr) + AWO_LEN);
          ram.setWord(bank, ram.word(bank) - 1);
          const left = (ram.word(ts + TS_ALIEN_NUM) - 1) & 0xffff;
          ram.setWord(ts + TS_ALIEN_NUM, left);
          if (left === 0) {
            // Welle beendet: Bahn und Bank frei, Paletten neu
            const slot = L.trackTable + ram.byte(ts + TS_NUM);
            ram.setByte(slot, ram.byte(slot) | 0x80);
            ram.setLong(bank, 0xffff0000);
            if (absolute) e.setW(e.V.refreshPal, 1);
            else e.setB(e.V.refreshPal, 0xff);
            removed = true;
            break;
          }
        } else {
          if (!absolute) dx = (dx - 2) & 0xffff;
          ram.setWord(awo + AWO_X, (ram.word(awo + AWO_X) + dx) & 0xffff);
          ram.setWord(awo + AWO_Y, (ram.word(awo + AWO_Y) + dy) & 0xffff);
        }
      }
      // Animation: Anim_Base + Animation + Schritt; −1 = von vorn
      let step = L.animBase + anim + ram.sword(a2);
      let obj = ram.word(step);
      if (obj & 0x8000) {
        ram.setWord(a2, 0);
        step = L.animBase + anim;
        obj = ram.word(step);
      }
      a2 += 2;
      ram.setWord(awo + AWO_OBJ_OFF, obj);
    }
    if (removed) continue;
  }
}

/**
 * PALETTE CTRL ($2DC4): in kurzen Durchläufen nach Refresh_Pal die nächsten 6 × 7 Farben übernehmen, Farben der
 * laufenden Wellen und einer Objekt-Routine darüberlegen und alles in die Copperliste schreiben (Band 0 im Kopf,
 * Bänder 1–5 in beide Flacker-Hälften).
 */
export function paletteCtrl(e: LevelEngine): void {
  const { V, L, ram } = e;
  if (e.w(V.curentSpell) === 2 || e.w(V.beginToStart) !== 0 || e.w(V.shortPhase) === 0) return;
  const refresh = e.w(V.refreshPal);
  if (refresh === 0) return;
  e.stepWork[WORK.palCopy]!++;
  if (refresh === 1 || e.w(V.routModPalCounter) < 2) {
    const from = e.l(V.frontPalPtr);
    for (let i = 0; i < 6 * 7 * 2; i += 4) ram.setLong(L.frontPalBuffer + i, ram.long(from + i));
  }
  e.setW(V.refreshPal, 0);
  for (let i = 0; i < TRACKS; i++) {
    const ts = ram.long(L.trackTable + 4 * i);
    if (ts & 0x80000000) continue;
    const aws = ram.long(ts + TS_AWS_PTR) & 0x3fffffff;
    overlay(e, aws + AWS_PAL_MOD_LIN0, aws + AWS_PAL_MOD_COL1);
  }
  const rout = e.l(V.routPalPtr);
  if ((rout & 0x80000000) === 0) overlay(e, rout, rout + 6);

  // COPY IN COPPER LIST
  let a0 = L.frontPalBuffer;
  for (let k = 0; k < 6; k++, a0 += 2) ram.setWord(L.frontColor0[0] + 4 * k, ram.word(a0));
  ram.setWord(L.frontColor0[1], ram.word(a0));
  a0 += 2;
  for (let band = 0; band < L.frontColor.length; band++) {
    const to = L.frontColor[band]!;
    for (let k = 0; k < 6; k++, a0 += 2) {
      const c = ram.word(a0);
      ram.setWord(to[0] + 4 * k, c);
      ram.setWord(to[1] + 4 * k, c);
    }
    const c = ram.word(a0);
    a0 += 2;
    ram.setWord(to[2], c);
    ram.setWord(to[3], c);
  }
}

/** 6 Zeilen-Schalter ab `lines`, 7 Farben ab `colors` (−1 = behalten) über Front_Pal_Buffer legen */
function overlay(e: LevelEngine, lines: number, colors: number): void {
  const { L, ram } = e;
  e.stepWork[WORK.palOverlays]!++;
  let a0 = L.frontPalBuffer;
  for (let y = 0; y < 6; y++) {
    if (ram.byte(lines + y) & 0x80) {
      a0 += 14;
      continue;
    }
    for (let k = 0; k < 7; k++, a0 += 2) {
      const c = ram.word(colors + 2 * k);
      if ((c & 0x8000) === 0) ram.setWord(a0, c);
    }
  }
}

/**
 * AWO COLISION TEST ($302C): Trefferrechtecke jedes Gegners (Objects_Struct, erstes Wort = Versatz der Liste)
 * gegen die 8 Rechtecke der Good_Col_List (0 = Eule, 1 = Schuss, dann Äxte und Zauber; −1 = aus). Ein Treffer
 * kostet den Gegner 1 Energie (13 Punkte, Explosion bei 0: 116 Punkte); trifft er die Eule (Sorcerer_On, also
 * nicht mit Schild), stirbt sie: Die = $FF00, Die_Mode 0, den Rest erledigt der Copper-Interrupt (MAIN CHAR DIE).
 */
export function colisionTest(e: LevelEngine): void {
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
      if ((ram.byte(awo + AWO_STATUS) & 0xf) !== 0) continue;
      e.stepWork[WORK.colAliens]!++;
      let rect = L.objectsStruct + ram.sword(awo + AWO_OBJ_OFF);
      rect += ram.sword(rect);
      hit: for (;;) {
        const x1b = ram.byte(rect);
        if (x1b === 0x80) break;
        e.stepWork[WORK.colRects]!++;
        const x = ram.word(awo + AWO_X);
        const y = ram.word(awo + AWO_Y);
        const x1 = s16(s8(x1b) + x);
        const y1 = s16(s8(ram.byte(rect + 1)) + y);
        const x2 = s16(s8(ram.byte(rect + 2)) + x);
        const y2 = s16(s8(ram.byte(rect + 3)) + y);
        rect += 4;
        let good = L.goodColList;
        for (let d1 = 7; d1 >= 0; d1--, good += 8) {
          const gx1 = ram.sword(good);
          if (gx1 < 0) continue;
          e.stepWork[WORK.colCompares]!++;
          if (x2 < gx1 || y2 < ram.sword(good + 2) || ram.sword(good + 4) < x1 || ram.sword(good + 6) < y1) continue;
          // COLISION FOUND
          e.stepWork[WORK.colHits]!++;
          e.setL(V.point, 0x13);
          soundStart(e, 3, 63);
          ram.setByte(awo + AWO_STATUS, 0x10);
          const energy = (ram.word(awo + AWO_ENERGY) - 1) & 0xffff;
          ram.setWord(awo + AWO_ENERGY, energy);
          if (energy === 0) {
            soundStart(e, 1, 63);
            ram.setByte(awo + AWO_STATUS, 0x01);
            e.setL(V.point, 0x116);
          }
          if (e.w(V.sorcererOn) !== 0 && d1 === 7) {
            if (e.w(V.die) !== 0) break hit;
            e.setB(V.die, 0xff);
            e.setW(V.dieMode, 0);
          }
          if (d1 === 6) {
            e.setW(V.fwFireStep, FW_F_OFF);
            ram.setLong(good, 0xffffffff);
            ram.setLong(good + 4, 0xffffffff);
          }
          break hit;
        }
      }
    }
    a0 = e.l(V.curentBankPtr) + BANK_LEN - 4;
    if (a0 === L.awoStructEnd) return;
  }
}
