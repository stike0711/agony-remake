// Ag_Back_Scroll.s (sea $EF4–$1476): hinteres Playfield (Bitplanes 4 und 6) und statische Ebene (Bitplane 2).
// Aufbau der Daten: Wiki dateiformate.md „Adressen im Abbild sea“. Das Arbeitsbild (Cur_Back_Build) entsteht in zwei
// Hälften: Back_Phase 0 zeichnet die Spalten 0–4, Phase 1 die Spalten 5–9; die Copperliste zeigt es nach Phase 1.

import type { LevelEngine } from "./engine.ts";

/** Kachel: 32 Pixel = 2 Wörter breit; Modus 0 = 64 Zeilen (beide Planes), sonst 32 Zeilen je Blit */
const SIZE_64 = 2 + 64 * 64;
const SIZE_32 = 2 + 64 * 32;
/** Himmelsblock: 40 Zeilen × 19 Wörter (das 19. Wort maskiert das Ende, Quelle wird um 2 Byte zurückgesetzt) */
const SIZE_SKY = 19 + 64 * 40;
const COPY_A = 0x09f00000; // D = A
const CLEAR_D = 0x01000000; // D = 0

export function backScroll(e: LevelEngine): void {
  const { V, L, ram, blitter: bl } = e;

  // ---- FRAME CONTROL (nur in Phase 0) ----
  if (e.w(V.backPhase) === 0) {
    e.setW(V.refreshFrame, 0);
    if (e.w(V.pause2) !== 0) return;
    if (e.w(V.stop2) === 0) {
      e.setW(V.backShift, (e.w(V.backShift) - 1) & 0x1f);
      if (e.w(V.backShift) === 31) {
        e.setW(V.backConfig, e.w(V.backConfig) + 240);
        if (e.w(V.backConfig) === 5 * 240) newPattern(e);
      }
    }
    // .cont ($10F8): neues Bild der drei sichtbaren Muster, wenn ihre Dauer abgelaufen ist
    for (let k = 0; k < 3; k++) {
      const p = V.pat0 + 14 * k; // Ptr_Stat, Ptr_Dyn, Dly_Count, Frm_Ptr
      if (e.w(V.refreshFrame) === 0) {
        e.setW(p + 8, e.w(p + 8) - 1);
        if (e.w(p + 8) !== 0) continue;
      }
      let a0 = e.l(p + 4);
      let frame = ram.byte(a0++);
      if (frame & 0x80) {
        a0 = e.l(p);
        frame = ram.byte(a0++);
      }
      e.setB(p + 9, ram.byte(a0++)); // move.b (a0)+,Patk_Dly_Count+1
      e.setL(p + 4, a0);
      e.setL(p + 10, L.backFrame + ram.word(L.x60 + 2 * ((frame << 24) >> 24)));
    }
  }

  // ---- TRANSFER 1/2 OF CHAR IN BIT MAP ($11A6) ----
  const modes = L.backCharInfo + 2;
  const offsets = L.backCharInfo + ram.word(L.backCharInfo);
  const frame0 = e.l(V.pat0 + 10);
  const frame1 = e.l(V.pat0 + 24);
  const frame2 = e.l(V.pat0 + 38);
  const build = e.l(V.curBackBuild);
  const phase = e.w(V.backPhase) !== 0;
  let read = L.readTable + e.w(V.backConfig) + (phase ? 120 : 0);
  let write = L.writeTable + (phase ? 60 : 0);
  let old = L.backOldChar + e.w(V.backOldOff) + (phase ? 120 : 0);
  bl.amod = 0;
  bl.dmod = 0x24;
  bl.setMasks(0xffffffff);
  for (let i = 0; i < 30; i++) {
    const select = ram.word(read);
    const frame = select === 0 ? frame0 : select === 1 ? frame1 : frame2;
    const at = frame + ram.sword(read + 2);
    read += 4;
    bl.dpt = (build + ram.sword(write)) >>> 0;
    write += 2;
    const char = ram.word(at);
    const same = char === ram.word(old);
    old += 2;
    if (same) continue;
    e.loopWork.backTiles++;
    ram.setWord(old - 2, char);
    const mode = ram.byte(modes + ((char << 16) >> 16));
    const src = L.backCharset + ram.word(offsets + 2 * char);
    bl.apt = src;
    // Modus 0: beide Planes aus dem Speicher; 1: beide gleich; 2: Plane 4 leer, Plane 6 aus dem Speicher;
    // 3: Plane 4 aus dem Speicher, Plane 6 leer
    if (mode === 0) {
      bl.setCon(COPY_A);
      bl.start(SIZE_64);
    } else if (mode === 1) {
      bl.setCon(COPY_A);
      bl.start(SIZE_32);
      bl.apt = src;
      bl.setCon(COPY_A);
      bl.start(SIZE_32);
    } else if (mode === 2) {
      bl.setCon(CLEAR_D);
      bl.start(SIZE_32);
      bl.setCon(COPY_A);
      bl.start(SIZE_32);
    } else {
      bl.setCon(COPY_A);
      bl.start(SIZE_32);
      bl.setCon(CLEAR_D);
      bl.start(SIZE_32);
    }
  }

  // ---- TRANSFER 1/2 OF SKY ($1372) ----
  // Phase 1 zeichnet die Blöcke 0 und 1 (Zeilen 0–79) und fällt dann in Phase 0, die Blöcke 2 und 3 (Zeilen 80–159)
  if (phase) {
    e.setW(V.skyCount, e.w(V.skyCount) + 1);
    if (e.w(V.skyCount) === L.skyPhases) e.setW(V.skyCount, 0);
    skyBlit(e, 0, 0);
  }
  skyBlit(e, 4, 40 * 80);

  // ---- CHANGE OF PHASE ----
  e.setW(V.backPhase, e.w(V.backPhase) ^ 1);
}

/** Zwei Himmelsblöcke ab Eintrag `entry` (Byte-Versatz in Sky_Anim_Table) nach Zeile `row` blitten */
function skyBlit(e: LevelEngine, entry: number, row: number): void {
  const { V, L, ram, blitter: bl } = e;
  const table = L.skyAnimTable + 8 * e.w(V.skyCount) + entry;
  bl.apt = L.skyDat + ram.word(table);
  bl.amod = -2;
  bl.dmod = 2;
  bl.alwm = 0;
  // gegenläufig zum Scrollen verschieben, damit die Ebene stillsteht
  const d0 = e.w(V.backShift) ^ 0x1f;
  let dest = e.l(V.curBackBuild) + 2 * 40 * 192 + row;
  if (d0 & 16) dest += 2;
  bl.con0 = ((d0 & 15) << 12) | 0x09f0;
  bl.dpt = dest;
  bl.start(SIZE_SKY);
  bl.apt = L.skyDat + ram.word(table + 2);
  bl.start(SIZE_SKY);
}

/** Neues Muster am rechten Rand ($F38): Muster rücken nach, Farben des neuen Musters in die Copperliste */
function newPattern(e: LevelEngine): void {
  const { V, L, ram } = e;
  e.setW(V.backConfig, 0);
  for (let k = 0; k < 2; k++) {
    const to = V.pat0 + 14 * k;
    const from = to + 14;
    e.setL(to, e.l(from));
    e.setL(to + 4, e.l(from + 4));
    e.setW(to + 8, e.w(from + 8));
    e.setL(to + 10, e.l(from + 10));
  }
  e.setL(V.patPtr, e.l(V.patPtr) + 2);
  const ptr = e.l(V.patPtr);
  let a0 = L.backPattern + ram.word(ptr);
  if (ptr > L.backPattern + 30) {
    // Ende der Musterliste: Level steht (Endgegner)
    e.setB(V.stop + 1, 0xff);
    e.setB(V.prgPause + 1, 0xff);
    a0 += 6 * 4 * 2;
  } else {
    a0 = e.setBackColors(a0 + 2);
  }
  e.setL(V.pat0 + 28, a0);
  e.setL(V.pat0 + 32, a0);
  e.setW(V.pat0 + 36, 1);
  e.setB(V.refreshFrame, 0xff);
}
