// Ag_Front_Scroll_.s (sea $C2C–$EF4): vorderes Playfield (Bitplanes 1, 3, 5). Zwei Arbeitsbilder à 3 Planes
// (44 Byte × 192 Zeilen) im Wechsel plus ein Restaurierungsbild ohne Gegner (Rest_Screen). Das Bild scrollt per
// Hardware (Front_Shift, 2 Pixel je Durchlauf der Hauptschleife, dazwischen 1 Pixel im Copper-Interrupt); nach
// 16 Durchläufen rücken alle Bildzeiger um 4 Byte weiter (Teil 2, FRONT SCROLL CONTROL). Währenddessen entsteht
// rechts außen die nächste Spalte aus 6 Kacheln à 32 × 32 Pixel: je Kachel ein Durchlauf „Char Init“ (Hintergrund-
// kachel kopieren, Maske der Vordergrundkachel bilden) und ein Durchlauf „Char Copy“ (Vordergrund maskiert darüber,
// Ergebnis ins andere Arbeitsbild und ins Restaurierungsbild).

import type { LevelEngine } from "./engine.ts";

/** Kachel: 32 Zeilen × 2 Wörter */
const TILE = 32 * 64 + 2;
/** Abstand der Planes im Bild: 44 Byte × 192 Zeilen */
const PLANE = 44 * 192;
/** Abstand der Planes einer Kachel im Front_Charset */
const TILE_PLANE = 128;

export function frontScroll(e: LevelEngine): void {
  const { V, L, ram, blitter: bl } = e;

  // PAUSE2 & STOP2 CTRL: nur an Stellen übernehmen, an denen die Spalte vollständig ist
  const shift = e.w(V.frontShift);
  if (shift !== 0 && shift !== 15 && shift !== 31) {
    if (e.w(V.stop) !== 0 || (e.w(V.prgPause) === 0 && e.w(V.curentSpell) !== 2)) e.setW(V.stop2, e.w(V.stop));
    e.setW(V.pause2, e.w(V.pause));
  }
  if (e.w(V.stop2) !== 0) return;

  // PALETTE: alle 10 Spalten (Front_Pal_Count) zu Beginn einer Spalte die nächsten 6 × 7 Farben
  if (e.w(V.frontPalCount) === 0 && e.w(V.frontPhase) === 0) {
    e.setB(V.refreshPal + 1, 0xff);
    e.setL(V.frontPalPtr, e.l(V.frontPalPtr) + 6 * 7 * 2);
  }

  // TEST PHASE: Durchlauf 2–13 bauen die Spalte, gerade = Char Init, ungerade = Char Copy
  const phase = e.w(V.frontPhase) - 2;
  if (phase >= 0 && phase < 12) {
    if ((phase & 1) === 0) {
      // CHAR INIT: Hintergrundkachel (1. Byte der Karte) in das Arbeitsbild
      const map = e.l(V.frontReadPtr);
      bl.apt = L.frontCharset + ram.long(L.x384 + 4 * ram.byte(map));
      const off = ram.word(L.frontTable + phase);
      e.setW(V.safeDestOff, off);
      let dest = (off + e.l(V.curFrontBuild)) >>> 0;
      e.setL(V.safeDestPtr, dest);
      bl.amod = 0;
      bl.dmod = 0x28;
      bl.setMasks(0xffffffff);
      bl.setCon(0x09f00000);
      for (let p = 0; p < 3; p++) {
        bl.dpt = dest;
        bl.start(TILE);
        dest += PLANE;
      }
      // Maske der Vordergrundkachel (2. Byte): D = A | B | C über die drei Planes
      const src = L.frontCharset + ram.long(L.x384 + 4 * ram.byte(map + 1));
      e.setL(V.safeSrcPtr, src);
      bl.apt = src;
      bl.bpt = src + TILE_PLANE;
      bl.cpt = src + 2 * TILE_PLANE;
      bl.dpt = L.frontMask;
      bl.con0 = 0x0ffe;
      bl.amod = 0;
      bl.dmod = 0;
      bl.cmod = 0;
      bl.bmod = 0;
      bl.start(TILE);
    } else {
      // CHAR COPY: D = A | (¬Maske & C), Planes der Vordergrundkachel nacheinander (A läuft weiter)
      bl.setMasks(0xffffffff);
      bl.amod = 0;
      bl.dmod = 0x28;
      bl.cmod = 0x28;
      bl.bmod = 0;
      bl.setCon(0x0ff20000);
      const base = e.l(V.safeDestPtr);
      bl.apt = e.l(V.safeSrcPtr);
      let d4 = base;
      for (let p = 0; p < 3; p++) {
        bl.bpt = L.frontMask;
        bl.cpt = d4;
        bl.dpt = d4;
        bl.start(TILE);
        d4 += PLANE;
      }
      // fertige Kachel ins jetzige Arbeitsbild (die Bilder haben inzwischen gewechselt) und ins Restaurierungsbild
      bl.con0 = 0x09f0;
      bl.amod = 0x28;
      bl.dmod = 0x28;
      const off = e.w(V.safeDestOff);
      let d0 = (off + e.l(V.curFrontBuild)) >>> 0;
      let d1 = base;
      for (let p = 0; p < 3; p++) {
        bl.dpt = d0;
        bl.apt = d1;
        bl.start(TILE);
        d0 += PLANE;
        d1 += PLANE;
      }
      d0 = (off + e.l(V.restScreenPtr)) >>> 0;
      d1 = base;
      for (let p = 0; p < 3; p++) {
        bl.dpt = d0;
        bl.apt = d1;
        bl.start(TILE);
        d0 += PLANE;
        d1 += PLANE;
      }
      e.setL(V.frontReadPtr, e.l(V.frontReadPtr) + 2);
    }
  }

  // FRONT SCROLL CONTROL: Feinverschiebung für den nächsten Durchlauf
  const fp = e.w(V.frontPhase) + 1;
  e.setW(V.frontPhase, fp);
  e.setW(V.frontShift, (16 - fp) * 2);
  e.setW(V.vdoSInc, 0);
  if (fp !== 16) return;
  e.setW(V.frontShift, 32);
  e.setW(V.frontPalCount, e.w(V.frontPalCount) + 1);
  if (e.w(V.frontPalCount) === 10) e.setW(V.frontPalCount, 0);
}
