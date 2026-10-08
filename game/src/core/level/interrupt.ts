// Copper-Interrupt am Ende der Copperliste (sea $43C6–$5BC4; Quelle: Agony_Parent_.s „Copper_Int3“, Ag_Sprites.s).
// Läuft in jedem Bild: 25-Hz-Takt der Hauptschleife, Eule (Joystick, Flügelschlag, Sprite-Listen), Äxte, Schüsse,
// Zauber, Tod der Eule, Bonus, Sprite-Zeiger in der Copperliste, Verzögerung des vorderen Playfields und Regen
// (Level 1). Übertragen sind der Weg ohne Zauber, der Schild nach dem Wiedereinstieg (Zauber 6), der Tod und der Bonus
// (gegen das Original noch ungeprüft); Zaubermenü, übrige Zauber, Äxte und Pause lösen einen Fehler aus.

import { DMACON } from "../amiga/video.ts";
import type { LevelEngine } from "./engine.ts";
import { SHARED } from "./layout.ts";
import { soundStart } from "./sounds.ts";
import { IRQ } from "./timing.ts";

/** SPR_Y_OFF (PAL) und horizontaler Versatz: Sprite-Position = Spielkoordinate − 256 + Fensteranfang */
const SPR_Y = 256 - 0x40;
const SPR_X = 256 - 0x90;
/** Fw_F_Off: Schuss aus */
const FW_F_OFF = 20 * 12;
const COLOR16 = 0x1a0;
const COLOR29 = 0x1ba;
const COLOR31 = 0x1be;
/** Sprite-Liste eines Teils der explodierenden Eule: Steuerwörter + 32 Zeilen */
const DIE_SPR_LEN = 33 * 4;

const s8 = (v: number): number => (v << 24) >> 24;
const s16 = (v: number): number => (v << 16) >> 16;

export function copperInterrupt(e: LevelEngine): void {
  const { V } = e;
  // Für das Zeitmodell zählt der Interrupt mit, welche Teile er ausführt (Dauer, Beginn der Hauptschleife)
  e.irqWork.fill(0);
  e.video.write(DMACON, 0x8020); // Sprite-DMA an (Diskwechsel)
  e.setW(V.genPhase, e.w(V.genPhase) + 1);
  // Hinkt die Hauptschleife hinterher, fällt alles Weitere in diesem Bild aus ($43D0)
  if (e.w(V.quitDelay) === 0 && e.w(V.genPhase) >= 3) return;
  e.irqWork[IRQ.sprites] = 1;
  sprites(e);
  frontShift(e);
  rain(e);
}

// ---- Ag_Sprites.s ------------------------------------------------------------------------------

function sprites(e: LevelEngine): void {
  // Ohne Leben, beim Tod und im Zaubermenü springt SORCERER direkt hinter die Äxte (No_Axe_Anim)
  if (sorcerer(e) && e.w(e.V.pause2) === 0) {
    forwardFire(e);
    axes(e);
  }
  icons(e);
  spellTime(e);
  spells(e);
  die(e);
  bonus(e);
  alienFireXDec(e);
  // UPDATE SPRITES PTR IN CL ($5A4A)
  for (let s = 0; s < 8; s++) e.copperPtr(e.L.sprPtr + 8 * s, e.l(e.V.sprPtrB + 4 * s));
}

/**
 * SORCERER ($43E2): Joystick, Kollisionsrechteck, Flügelschlag, Sprite-Listen der Eule und der Äxte.
 * Liefert false, wenn das Original danach Schuss und Äxte überspringt.
 */
function sorcerer(e: LevelEngine): boolean {
  const { V, L, ram } = e;
  if (e.w(V.iconesMode) !== 0) return false;
  if (ram.word(SHARED.life) === 0 || e.w(V.die) !== 0) {
    ram.setLong(L.goodColList, 0xffffffff);
    ram.setLong(L.goodColList + 4, 0xffffffff);
    return false;
  }
  e.irqWork[IRQ.sorcerer] = 1;
  if (e.w(V.pause2) === 0) {
    if (e.w(V.quitDelay) === 0) {
      // JOYSTICK TEST ($441A)
      const d0 = e.joy1dat >> 8;
      const d5 = e.joy1dat & 0xff;
      let d2 = d5 >> 1;
      let d4 = d0 >> 1;
      let moved = false;
      if (d2 & 1) {
        if (e.sw(V.sorcererX) < 280 - 32 + 256) {
          e.setW(V.sorcererX, e.w(V.sorcererX) + 3); // rechts
          moved = true;
        }
      } else if (d4 & 1) {
        if (e.sw(V.sorcererX) > 256) {
          moved = true;
          e.setW(V.sorcererX, e.w(V.sorcererX) - 3); // links
        }
      }
      d2 ^= d5;
      if (d2 & 1) {
        if (e.sw(V.sorcererY) < 192 - 60 + 256) e.setW(V.sorcererY, e.w(V.sorcererY) + 3); // unten
      } else {
        d4 ^= d0;
        if ((d4 & 1) && e.sw(V.sorcererY) > 256 - 20) e.setW(V.sorcererY, e.w(V.sorcererY) - 3); // oben
      }
      // Kollisionsrechteck ($449A)
      const x = e.w(V.sorcererX);
      const y = e.w(V.sorcererY) + 37;
      ram.setWord(L.goodColList, x);
      ram.setWord(L.goodColList + 2, y);
      ram.setWord(L.goodColList + 4, x + 32);
      ram.setWord(L.goodColList + 6, y + 16);
      if (moved) {
        if (e.w(V.axeDelay) !== 10) e.setW(V.axeDelay, e.w(V.axeDelay) + 1);
      } else {
        e.setW(V.axeDelay, 0);
        e.setW(V.axeMove, 0);
      }
    } else {
      throw new Error("Level: Levelende (Quit_Delay) ist noch nicht übertragen");
    }
    // SHAPE ANIM ($44DA): jedes zweite Bild die nächste Phase
    e.setW(V.sorcererDelay, e.w(V.sorcererDelay) ^ 1);
    if (e.w(V.sorcererDelay) !== 0) {
      e.setW(V.sorcererShape, e.w(V.sorcererShape) + 12);
      e.setW(V.sorcerer2Shape, e.w(V.sorcerer2Shape) + 8);
      if (e.w(V.sorcererShape) === 16 * 12) {
        e.setW(V.sorcererShape, 0);
        e.setW(V.sorcerer2Shape, 0);
      }
    }
  }

  // UPDATE SPR 0,1,2 & 3 ($4500): Kopf der Phase = y1, Höhe, Versätze der vier Sprite-Listen
  const head = L.sorcererDat + e.w(V.sorcererShape);
  const y1 = ram.word(head);
  const height = ram.word(head + 2);
  // Sprite 0/1 bilden das linke, 2/3 das rechte angehängte Paar; ihre Listen liegen getrennt
  const left = L.sorcererDat + ram.word(head + 4);
  const left2 = L.sorcererDat + ram.word(head + 6);
  const right = L.sorcererDat + ram.word(head + 8);
  const right2 = L.sorcererDat + ram.word(head + 10);
  e.setL(V.sprPtrB, left);
  e.setL(V.sprPtrB + 4, left2);
  e.setL(V.sprPtrB + 8, right);
  e.setL(V.sprPtrB + 12, right2);

  // Jede Liste: obere Axt (7 Zeilen), Eule (Höhe aus dem Kopf), untere Axt (7 Zeilen); ausgeschaltet = x 0
  let off = 0;
  writeControls(e, left, left2, right, right2, off, e.w(V.axeUpY), 7, ram.word(SHARED.axeUpOn) !== 0 ? e.w(V.axeUpX) - SPR_X : 0);
  off += 4 + 7 * 4;
  writeControls(e, left, left2, right, right2, off, e.w(V.sorcererY) + y1, height, e.w(V.sorcererOn) !== 0 ? e.w(V.sorcererX) - SPR_X : 0);
  off += 4 + 4 * height;
  writeControls(e, left, left2, right, right2, off, e.w(V.axeDownY), 7, ram.word(SHARED.axeDownOn) !== 0 ? e.w(V.axeDownX) - SPR_X : 0);

  // FIRE TEST ($4656): Feuer startet einen Schuss; im Pausenmodus beendet es die Pause
  if (e.fire) {
    if (e.w(V.pause2) !== 0) throw new Error("Level: Pause ist noch nicht übertragen");
    e.setW(V.fireCount, e.w(V.fireCount) + 1);
    if (e.w(V.fwFireStep) === FW_F_OFF && e.w(V.fwFireOff) === 0) {
      // neuer Schuss mit Schussgeräusch ($469C–$46B0: Sound_Start mit Nummer 2, Lautstärke $32)
      e.irqWork[IRQ.fireStart] = 1;
      e.setW(V.fwFireStep, 0);
      soundStart(e, 2, 0x32);
      e.setW(V.fwFirePhase, 0);
    }
  } else {
    e.setW(V.fireCount, 0);
  }
  if (ram.word(SHARED.menuMode) !== 0 && e.w(V.curentSpell) !== 2 && e.w(V.fireCount) === 30 && e.w(V.quitDelay) === 0) {
    throw new Error("Level: Zaubermenü ist noch nicht übertragen");
  }
  return true;
}

/**
 * Steuerwörter eines Abschnitts in alle vier Sprite-Listen schreiben (Rechnung wie $4530–$4580 mit Wortbreite):
 * POS = VSTART (8 Bit) · HSTART/2, CTL = VSTOP (8 Bit) · Bit 0 von HSTART · ATTACH; rechtes Paar 16 Pixel weiter
 */
function writeControls(e: LevelEngine, a1: number, a2: number, a3: number, a4: number, off: number, y: number, lines: number, x: number): void {
  const ram = e.ram;
  const pos = ((y - SPR_Y) << 8) & 0xffff;
  const h = (x & 0xffff) >>> 1;
  const ctl = ((((y - SPR_Y + lines) & 0xffff) << 8) & 0xffff) | (x & 1) | 0x80;
  const leftCtl = (((pos | h) << 16) | ctl) >>> 0;
  const rightCtl = (((pos | ((h + 8) & 0xffff)) << 16) | ctl) >>> 0;
  ram.setLong(a1 + off, leftCtl);
  ram.setLong(a2 + off, leftCtl);
  ram.setLong(a3 + off, rightCtl);
  ram.setLong(a4 + off, rightCtl);
}

/**
 * Vorwärtsschuss je Waffe (Fw_Fire_Weapon 0–3): Sprite-Daten, Grenzen für Y, Versatz von Y, Höhe des
 * Kollisionsrechtecks, VSTOP − VSTART. Quelle: sea $4746–$488C (Reihenfolge dort 3, 0, 1, 2).
 */
const WEAPONS: readonly (readonly [spr: number, end: number, yMin: number, yMax: number, yOff: number, colH: number, lines: number])[] = [
  [0x1efc8, 0x64, 0xf0, 0x1c8, 0xa0, 0x08, 0x17],
  [0x1f02c, 0xa0, 0x100, 0x1b8, 0xaa, 0x18, 0x27],
  [0x1f0d0, 0xf0, 0x100, 0x1a4, 0xb4, 0x2c, 0x3b],
  [0x1f1c4, -1, 0x100, 0x17c, 0xc8, 0x54, 0x63],
];

/** FORWARD FIRE ($4706): Schuss der Eule als Sprite 4, 20 Pixel je Bild, 12 Bilder lang */
function forwardFire(e: LevelEngine): void {
  const { V, L, ram } = e;
  let col = L.goodColList + 8;
  const step = e.w(V.fwFireStep);
  if (step === FW_F_OFF) {
    ram.setLong(col, 0xffffffff);
    ram.setLong(col + 4, 0xffffffff);
    e.setL(V.sprPtrB + 4 * 4, L.emptySpr);
    return;
  }
  e.irqWork[IRQ.fire] = 1;
  const w = WEAPONS[ram.word(SHARED.fwFireWeapon)];
  if (!w) throw new Error("Level: unbekannte Waffe");
  const [spr, end, yMin, yMax, yOff, colH, lines] = w;
  // Endekennzeichen hinter dem Schuss (Waffe 3 hat keins: Sprite reicht bis zum Ende der Liste)
  if (end >= 0) ram.setLong(spr + end, 0);
  const x = (e.w(V.sorcererX) - 0x50 + step) & 0xffff;
  let h = x;
  if ((h << 16 >> 16) >= 0x1bc) h = 0x1bc;
  h >>= 1;
  let y = e.sw(V.sorcererY);
  if (y <= yMin) y = yMin;
  if (y >= yMax) y = yMax;
  y -= yOff;
  const pos = (y << 8) & 0xffff;
  ram.setWord(spr, pos | h);
  ram.setWord(spr + 2, (pos + (lines << 8)) & 0xffff);
  e.setL(V.sprPtrB + 4 * 4, spr);
  e.setW(V.fwFireStep, step + 20);
  // Kollisionsrechteck nur jedes zweite Bild erneuern
  e.setW(V.fwFirePhase, e.w(V.fwFirePhase) ^ 1);
  if (e.w(V.fwFirePhase) === 0) return;
  ram.setWord(col, (x + 0x70) & 0xffff);
  col += 2;
  ram.setWord(col, (y + 0xc8) & 0xffff);
  col += 2;
  ram.setWord(col, (x + 0x70 + 0x3c) & 0xffff);
  col += 2;
  ram.setWord(col, (y + 0xc8 + colH) & 0xffff);
}

/** AXES ($48C2): Äxte folgen der Eule (auch ausgeschaltet; ihre Position steht in den Sprite-Listen) */
function axes(e: LevelEngine): void {
  const { V, L, ram } = e;
  if (e.w(V.quitDelay) !== 0) return;
  e.irqWork[IRQ.axes] = 1;
  let step = 3;
  const delay = e.w(V.axeDelay);
  if (delay !== 0 && delay !== 10 && e.w(V.axeMove) !== 0) step = -3;
  const x = e.w(V.sorcererX);
  const upX = e.w(V.axeUpX);
  if (x !== upX) {
    const dir = x > upX ? step : -step;
    e.setW(V.axeUpX, upX + dir);
    e.setW(V.axeDownX, e.w(V.axeDownX) + dir);
  }
  const dx = ((x - e.w(V.axeUpX)) << 16) >> 16;
  if (dx < 6 && dx > -6) {
    e.setB(V.axeMove + 1, 0xff);
    e.setW(V.axeDelay, 1);
  }
  const index = (((e.w(V.axeUpX) - x + 48 - 2) << 16) >> 16);
  const traj = ram.byte(L.axeTraj + index);
  const y = e.w(V.sorcererY);
  e.setW(V.axeUpY, y - traj - 18);
  e.setW(V.axeDownY, y + traj + 98);
  if (e.sw(V.axeUpY) < 256 - 32) e.setW(V.axeUpY, 256 - 32);
  for (let i = 0; i < 4; i++) ram.setLong(L.goodColList + 16 + 4 * i, 0xffffffff);
  if (ram.word(SHARED.axeUpOn) !== 0 || ram.word(SHARED.axeDownOn) !== 0) throw new Error("Level: Äxte sind noch nicht übertragen");
}

/** ICONES SPRITES ($49C2): Zaubermenü – vor dem Start aus */
function icons(e: LevelEngine): void {
  if (e.w(e.V.iconesOff) !== 0 || e.w(e.V.iconesMode) !== 0) throw new Error("Level: Zaubermenü ist noch nicht übertragen");
}

/**
 * SPELL TIME ($4C04): Zauberdauer (BCD, Sekunden) alle 50 Bilder um 1 herunter; bei 0 ist der Zauber aus
 * (unteres Byte von Curent_Spell = $FF). sbcd rechnet nur im unteren Byte; X ist hier immer 0 (subq davor ohne Übertrag).
 */
function spellTime(e: LevelEngine): void {
  const { V } = e;
  if (e.w(V.pause2) !== 0 || e.w(V.spellTime) === 0) return;
  const delay = (e.w(V.spellTimeDelay) - 1) & 0xffff;
  e.setW(V.spellTimeDelay, delay);
  if (delay !== 0) return;
  e.setW(V.spellTimeDelay, 50);
  const t = e.w(V.spellTime);
  let lo = (t & 15) - 1;
  let hi = (t >> 4) & 15;
  if (lo < 0) {
    lo += 10;
    hi = (hi + 9) % 10;
  }
  const time = (t & 0xff00) | (hi << 4) | lo;
  e.setW(V.spellTime, time);
  if (time === 0) e.setB(V.curentSpell + 1, 0xff);
}

/**
 * SPELL ROUTINES ($4C38): Eule sichtbar (Sorcerer_On), Kollisionsrechtecke der Zauber aus, dann der laufende Zauber.
 * Ohne Zauber und ohne Regen leere Sprites 6 und 7.
 */
function spells(e: LevelEngine): void {
  const { V, L, ram } = e;
  if ((e.w(V.iconesMode) | e.w(V.pause2)) !== 0) return;
  e.irqWork[IRQ.spells] = 1;
  e.setB(V.sorcererOn, 0xff); // st.b Sorcerer_On
  e.setW(V.fwFireOff, 0);
  for (let i = 0; i < 8; i++) ram.setLong(L.goodColList + 32 + 4 * i, 0xffffffff);
  const spell = e.w(V.curentSpell);
  if (spell === 6) shield(e);
  else if (spell <= 7) throw new Error(`Level: Zauber ${spell} ist noch nicht übertragen`);
  // (-1) SPELL OFF ($54CC)
  if (e.b(V.curentSpell + 1) === 0xff && e.w(V.rainOn) === 0) {
    e.setL(V.sprPtrB + 6 * 4, L.emptySpr);
    e.setL(V.sprPtrB + 7 * 4, L.emptySpr);
  }
}

/**
 * (6) SHIELD ($52CC): Nach dem Wiedereinstieg ist die Eule 3 Sekunden lang unverwundbar (Sorcerer_On = 0, damit
 * prüfen weder AWO- noch Schusskollision die Eule). Statt der Sprites 0–3 zeigen Sprite 6 und 7 die Eule mit Schild
 * (Sorcerer2_Dat, Phase Sorcerer2_Shape) in den Farben 29–31.
 */
function shield(e: LevelEngine): void {
  const { V, L, ram } = e;
  e.irqWork[IRQ.shield] = 1;
  e.video.write(COLOR29, 0x0fff);
  e.video.write(COLOR29 + 2, 0x07df);
  e.video.write(COLOR31, 0x008f);
  e.setW(V.sorcererOn, 0);
  const head = L.sorcerer2Dat + e.w(V.sorcerer2Shape);
  const y1 = ram.word(head);
  const height = ram.word(head + 2);
  const a1 = L.sorcerer2Dat + ram.word(head + 4);
  const a2 = L.sorcerer2Dat + ram.word(head + 6);
  // Rechnung wie $5302–$5344 (Wortbreite): VSTART = y − ($100 − $40 + 10) + y1, VSTOP höchstens 255
  const vstart = (e.w(V.sorcererY) - 0xca + y1) & 0xffff;
  const pos = (vstart << 8) & 0xffff;
  const x = (e.w(V.sorcererX) - SPR_X) & 0xffff;
  const h = x >>> 1;
  let vstop = (vstart + height) & 0xffff;
  if (s16(vstop) > 0xff) vstop = 0xff;
  const ctl = ((vstop << 8) & 0xffff) | (x & 1);
  ram.setLong(a1, (((pos | h) << 16) | ctl) >>> 0);
  ram.setLong(a2, (((pos | ((h + 8) & 0xffff)) << 16) | ctl) >>> 0);
  e.setL(V.sprPtrB + 6 * 4, a1);
  e.setL(V.sprPtrB + 7 * 4, a2);
}

/**
 * MAIN CHAR DIE ($54EA): Die = $FF00 kommt aus einer Kollision der Hauptschleife. Modus 0 nimmt ein Leben (Life
 * ist eine Bitreihe, lsr), zeigt bei 0 „GAME OVER“ und bereitet die Explosion vor; ab Modus 1 fliegen 8 Teile der Eule
 * als Sprites 0–7 auf ihren Bahnen (Die_Table: Bytepaare dx, dy, Ende $80; unter Zeile 256 ist ein Teil fertig).
 * Sind alle 8 fertig: ohne Leben Spielende (Quit_Delay 50, Clean_Up), sonst Wiedereinstieg mit Schild (Zauber 6,
 * 3 Sekunden), eine Waffenstufe weniger und ohne untere Axt.
 */
function die(e: LevelEngine): void {
  const { V } = e;
  if (e.w(V.die) === 0 || e.w(V.quitDelay) !== 0) return;
  if (e.w(V.dieMode) === 1) dieParts(e);
  else dieStart(e);
}

/** Die_mode0 ($5508): INIT EXPLO */
function dieStart(e: LevelEngine): void {
  const { V, L, ram } = e;
  e.irqWork[IRQ.dieStart] = 1;
  const life = ram.word(SHARED.life) >>> 1;
  ram.setWord(SHARED.life, life);
  if (life === 0) {
    e.setW(V.textNum, 11);
    e.setW(V.textDelay, 0xffff);
  }
  e.setW(V.bonusMode, 0);
  for (let i = 0; i < 8; i++) ram.setLong(L.dieDynPtr + 4 * i, (L.dieTable + s16(ram.word(L.dieTable + 2 * i))) >>> 0);
  e.setW(V.sorcererOn, 0);
  e.setB(V.curentSpell + 1, 0xff);
  e.setB(V.fwFireOff, 0xff);
  e.setB(V.afOff + 1, 0xff);
  e.setW(V.stop, 0);
  // Farben der Teile (Sprites 0–7, je drei Farben ab 17)
  const colors = [0x0fff, 0x0cbe, 0x087a, -1, 0x0fff, 0x0db9, 0x0975, -1, 0x0cbe, 0x087a, 0x0547, -1, 0x0db9, 0x0975, 0x0755];
  for (let i = 0; i < colors.length; i++) if (colors[i]! >= 0) e.video.write(COLOR16 + 2 + 2 * i, colors[i]!);
  e.setW(V.dieX, (e.w(V.sorcererX) - (256 - 0x90 - 16)) & 0xffff);
  e.setW(V.dieY, (e.w(V.sorcererY) - (256 - 0x40 - 42)) & 0xffff);
  e.setW(V.dieMode, e.w(V.dieMode) + 1);
}

/** Die_mode1 ($55A4): Teile bewegen; Sprite i = 33 Langwörter ab Die_Spr, 32 Zeilen hoch, ohne Attach */
function dieParts(e: LevelEngine): void {
  const { V, L, ram } = e;
  e.setW(V.sorcererOn, 0);
  const x0 = e.w(V.dieX);
  const y0 = e.w(V.dieY);
  let done = 0;
  for (let i = 0, spr = L.dieSpr; i < 8; i++, spr += DIE_SPR_LEN) {
    const at = L.dieDynPtr + 4 * i;
    const p = ram.long(at);
    if (p & 0x80000000) {
      done++;
      continue;
    }
    ram.setLong(at, p + 2);
    e.irqWork[IRQ.dieParts]!++;
    const dx = ram.byte(p);
    if (dx === 0x80) {
      // Bahn zu Ende: das Sprite bleibt, wo es zuletzt stand
      ram.setLong(at, 0xffffffff);
      continue;
    }
    const x = (s8(dx) + x0) & 0xffff;
    const y = (s8(ram.byte(p + 1)) + y0) & 0xffff;
    if (s16(y) >= 256) ram.setLong(at, 0xffffffff);
    const pos = (y << 8) & 0xffff;
    e.setL(V.sprPtrB + 4 * i, spr);
    ram.setWord(spr, pos | (x >>> 1));
    ram.setWord(spr + 2, (pos + 0x2000) & 0xffff);
  }
  if (done !== 8) return;
  if (ram.word(SHARED.life) === 0) {
    e.setW(V.quitDelay, 50);
    for (let i = 0; i < 8; i++) e.setL(V.sprPtrB + 4 * i, L.emptySpr);
    e.setW(V.die, 0);
    e.setB(V.cleanUp, 0xff);
  } else {
    const weapon = (ram.word(SHARED.fwFireWeapon) - 1) & 0xffff;
    ram.setWord(SHARED.fwFireWeapon, s16(weapon) < 0 ? 0 : weapon);
    if (ram.word(SHARED.axeDownOn) === 0) ram.setWord(SHARED.axeUpOn, 0);
    ram.setWord(SHARED.axeDownOn, 0);
    e.setW(V.die, 0);
    e.setW(V.fwFireOff, 0);
    e.setW(V.curentSpell, 6);
    e.setW(V.spellTime, 3);
    e.setW(V.spellTimeDelay, 50);
  }
  // Farben 16–31 wieder aus Sorcerer_Pal
  for (let i = 0; i < 16; i++) e.video.write(COLOR16 + 2 * i, ram.word(L.sorcererPal + 2 * i));
}

/**
 * BONUS ($56BA–$59D6; Quelle: Ag_Sprites.s „BONUS“). Bonus_Mode 0: zählt im Spiel (nicht bei Stop2) bis über 2000
 * Bilder; dann (nicht beim Tod, nicht während eines Zaubers) wählt er, was der nächste Bonus bringt (Bonus_Num) und
 * schaltet den Regen ab. Modus 1 wartet, bis ein Gegner explodiert (DRAW OBJECT setzt dort Modus 2 und die Position,
 * objects.ts). Modus 2: der Bonus fällt (x − 1, y + 2 je Bild) bis y 256 + 166, Modus 3 rollt am Boden nach links;
 * ab x ≤ 240 verschwindet er. Berührt ihn die Eule, gibt es 600 Punkte und je nach Bonus_Num: 0 obere Axt, 11 untere
 * Axt, 1 Geld (Point $20000), 2 eine Waffenstufe (höchstens 3), sonst den Zauber Bonus_Num − 3. Angezeigt wird er mit
 * Sprite 6 und 7 (Farben 29–31), alle 8 Bilder im Wechsel zweier Bilder.
 */
function bonus(e: LevelEngine): void {
  const { V, L, ram } = e;
  if ((e.b(V.curentSpell + 1) & 0x80) === 0) e.setW(V.bonusMode, 0);
  const mode = e.w(V.bonusMode);
  if (mode === 0) {
    bonusStart(e);
    return;
  }
  if (mode !== 2 && mode !== 3) return;
  const paused = e.w(V.pause2) !== 0;
  if (!paused) e.setW(V.bonusX, e.w(V.bonusX) - 1);
  const x = e.sw(V.bonusX);
  if (x <= 240) {
    bonusClose(e);
    return;
  }
  let y = 256 + 166;
  if (mode === 2) {
    if (!paused) e.setW(V.bonusY, e.w(V.bonusY) + 2);
    y = e.sw(V.bonusY);
    if (y >= 256 + 166) e.setW(V.bonusMode, 3);
  }
  // Berührt die Eule den Bonus? Rechteck Sorcerer_X − 16 … + 50, Sorcerer_Y + 40 − 50 … + 30
  const sx = e.sw(V.sorcererX);
  const sy = s16(e.w(V.sorcererY) + 40);
  if (x <= s16(sx + 50) && x >= s16(sx - 16) && y <= s16(sy + 30) && y >= s16(sy - 50)) {
    // Bonus attribution
    soundStart(e, 0, 63);
    e.setL(V.point, 0x258);
    const num = e.w(V.bonusNum);
    if (num === 0 || num === 11) {
      ram.setByte(num === 0 ? SHARED.axeUpOn : SHARED.axeDownOn, 0xff);
      e.setW(V.axeDownX, e.w(V.sorcererX));
      e.setW(V.axeUpX, e.w(V.sorcererX));
    } else if (num === 1) {
      e.setL(V.point, 0x20000);
    } else if (num === 2) {
      const weapon = ram.word(SHARED.fwFireWeapon);
      if (weapon !== 3) ram.setWord(SHARED.fwFireWeapon, weapon + 1);
    } else {
      ram.setWord(SHARED.spellAdvailable + s16(((num - 3) * 2) & 0xffff), 1);
    }
    bonusClose(e);
    return;
  }
  // Anzeige: Bild nach Bonus_Image[Bonus_Num] (bei Bonus_Num > 3 liest das Original hinter der Tabelle weiter)
  const image = e.w(V.bonusImage + s16((e.w(V.bonusNum) * 2) & 0xffff));
  e.video.write(COLOR29, 0xf00);
  const c = image === 0 ? 0x0bbb0888 : image === 1 ? 0x0e920b72 : image === 2 ? 0x00500070 : 0x0a860753;
  e.video.write(COLOR29 + 2, c >>> 16);
  e.video.write(COLOR31, c & 0xffff);
  let a0 = (L.bonusSpr + e.sw(V.bonusShape + s16((image * 2) & 0xffff))) >>> 0;
  const anim = (e.w(V.bonusAnim) + 1) & 0xffff;
  e.setW(V.bonusAnim, anim);
  if (anim & 8 && !paused) a0 += 400;
  const a1 = a0 + 200;
  e.setL(V.sprPtrB + 6 * 4, a0);
  e.setL(V.sprPtrB + 7 * 4, a1);
  const d0 = (x - 0x80) & 0xffff;
  const v = ((y - 0xd6) << 8) & 0xffff;
  const ctl = ((v + 0x3080) & 0xffff) | (d0 & 1);
  const pos = v | (d0 >>> 1);
  ram.setWord(a0, pos);
  ram.setWord(a0 + 2, ctl);
  ram.setWord(a1, pos);
  ram.setWord(a1 + 2, ctl);
}

/** Bonus Start: nach 2000 Bildern wählen, was der Bonus bringt (Bonus_Num) */
function bonusStart(e: LevelEngine): void {
  const { V, ram } = e;
  if (e.w(V.stop2) !== 0) return;
  e.setW(V.bonusDelay, e.w(V.bonusDelay) + 1);
  if (e.sw(V.bonusDelay) <= 2000) return;
  // nicht während des Todes und nicht während eines Zaubers; Bonus_Delay zählt weiter
  if (e.w(V.die) !== 0 || (e.b(V.curentSpell + 1) & 0x80) === 0 || e.w(V.stop2) !== 0) return;
  e.setW(V.bonusMode, 1);
  e.setW(V.rainOn, 0);
  e.setW(V.bonusDelay, 0);
  let num: number;
  if (ram.sword(SHARED.fwFireWeapon) <= 1) num = 2;
  else if (ram.sword(SHARED.life) <= 1 && (ram.long(SHARED.extraLife) | 0) >= 0x40000) num = 1;
  else if (ram.word(SHARED.axeUpOn) === 0) num = 0;
  else if (ram.word(SHARED.fwFireWeapon) === 2) num = 2;
  else if (ram.word(SHARED.axeDownOn) === 0) num = 11;
  else {
    // nächster Zauber in der Reihenfolge Spell_Pri, den die Eule noch nicht hat; sonst Geld
    num = 1;
    for (let tries = 0; tries < 9; tries++) {
      const next = ram.word(SHARED.spellNextBonus);
      ram.setWord(SHARED.spellNextBonus, (next + 1) & 7);
      const spell = e.w(V.spellPri + s16((next * 2) & 0xffff));
      if (ram.word(SHARED.spellAdvailable + s16((spell * 2) & 0xffff)) === 0) {
        num = (spell + 3) & 0xffff;
        break;
      }
    }
  }
  e.setW(V.bonusNum, num);
}

/** .close: Sprites 6 und 7 leer, Bonus_Mode 0 */
function bonusClose(e: LevelEngine): void {
  const { V, L } = e;
  e.setL(V.sprPtrB + 6 * 4, L.emptySpr);
  e.setL(V.sprPtrB + 7 * 4, L.emptySpr);
  e.setL(V.spr6pt, L.emptySpr);
  e.setL(V.spr7pt, L.emptySpr);
  e.setW(V.bonusMode, 0);
}

/** ALIEN FIRE X DEC ($59D6): Gegnerschüsse wandern mit dem Scrollen nach links */
function alienFireXDec(e: LevelEngine): void {
  const { V, L, ram } = e;
  const spell = e.w(V.curentSpell);
  if (spell === 2 || spell === 5 || e.w(V.pause) !== 0 || e.w(V.die) !== 0 || e.w(V.iconesMode) !== 0) return;
  e.setL(V.sprPtrB + 5 * 4, L.alienFireSpr);
  e.irqWork[IRQ.alienFire] = 1;
  let a0 = L.alienFireSpr;
  for (let i = 0; i < 12; i++) {
    if (ram.long(a0) === 0) {
      a0 += 36;
      continue;
    }
    e.irqWork[IRQ.alienFireShots]!++;
    // HSTART (9 Bit über beide Steuerwörter verteilt) um 1 verringern
    let x = ((ram.word(a0) & 0xff) << 1) | (ram.word(a0 + 2) & 1);
    x = (x - 1) & 0xffff;
    ram.setByte(a0 + 1, x >> 1);
    ram.setByte(a0 + 3, x & 1);
    a0 += 36;
  }
}

// ---- FRONT SHIFT ($5ACA) -----------------------------------------------------------------------

function frontShift(e: LevelEngine): void {
  const { V, L, ram } = e;
  if (e.w(V.stop2) !== 0) return;
  ram.setWord(L.videoShift, (ram.word(L.videoShift) & 0xf0) | (e.w(V.frontShift) & 15));
  if (e.w(V.vdoSInc) !== 0) return;
  e.setB(V.vdoSInc + 1, 0xff);
  e.setW(V.frontShift, e.w(V.frontShift) - 1);
}

// ---- RAIN ($5AF8, nur Level 1) -------------------------------------------------------------------

function rain(e: LevelEngine): void {
  const { V, L } = e;
  if (e.w(V.rainOn) === 0 || e.w(V.iconesMode) !== 0 || e.w(V.die) !== 0 || e.b(V.curentSpell + 1) !== 0xff) return;
  e.irqWork[IRQ.rain] = 1;
  e.video.write(COLOR29, 0x667);
  e.video.write(COLOR29 + 2, 0x778);
  e.video.write(COLOR31, 0x889);
  rainSprite(e, 6, L.rainSpr0, V.rainXOff0, 1, 6);
  rainSprite(e, 7, L.rainSpr1, V.rainXOff1, 2, 4);
}

/** 24 Tropfen-Sprites untereinander (je 7 Zeilen, Abstand 8), schräg versetzt; die Tabelle läuft pro Bild weiter */
function rainSprite(e: LevelEngine, sprite: number, list: number, offset: number, slant: number, speed: number): void {
  const { V, L, ram } = e;
  let a0 = L.rainXTable + e.w(offset);
  let a1 = list;
  e.setL(V.sprPtrB + 4 * sprite, list);
  let d1 = 0x40004700;
  let d4 = 0;
  for (let i = 0; i < 24; i++) {
    const x = (ram.word(a0) - d4) & 0xffff;
    a0 += 2;
    ram.setLong(a1, (d1 | (x << 16)) >>> 0);
    a1 += 32;
    d1 = (d1 + 0x08000800) >>> 0;
    d4 += slant;
  }
  if (e.w(V.pause) !== 0) return;
  const next = e.sw(offset) - speed;
  e.setW(offset, next < 0 ? 96 : next);
}
