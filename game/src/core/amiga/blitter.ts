// Blitter des Amiga (OCS) für die Level-Engine (E-032): Kanäle A–D, Minterm, Verschiebung von A und B, Masken für
// das erste und letzte Wort von A, Modulos, auf- und absteigender Modus. Ein Blit läuft beim Setzen der Größe sofort
// vollständig durch (der Zeitbedarf wird im Ablauf der Engine berücksichtigt, nicht hier).
// Linien- und Füllmodus nutzt Agony nicht; sie lösen einen Fehler aus.
// Register und Bedeutung: Amiga Hardware Reference Manual, Kapitel 6.

import type { Ram } from "./ram.ts";

export class Blitter {
  /** BLTCON0: Bits 15–12 Verschiebung A, 11–8 Kanäle A/B/C/D, 7–0 Minterm */
  con0 = 0;
  /** BLTCON1: Bits 15–12 Verschiebung B, Bit 1 absteigend */
  con1 = 0;
  afwm = 0xffff;
  alwm = 0xffff;
  apt = 0;
  bpt = 0;
  cpt = 0;
  dpt = 0;
  /** Modulos in Byte (mit Vorzeichen) */
  amod = 0;
  bmod = 0;
  cmod = 0;
  dmod = 0;
  /** Datenregister, wenn ein Kanal nicht eingeschaltet ist */
  adat = 0;
  bdat = 0;
  cdat = 0;

  /**
   * Zeitbedarf für das Zeitmodell (E-034): Summe der Blitter-Takte aller Blits (Wörter × Takte je Wort nach den
   * benutzten Kanälen, HRM Kapitel 6: A+D bzw. D 2, A+B+C+D 4, sonst 3) und Anzahl der Blits. Ohne DMA-Konkurrenz.
   */
  cycles = 0;
  blits = 0;

  private readonly ram: Ram;

  constructor(ram: Ram) {
    this.ram = ram;
  }

  /** BLTCON0 und BLTCON1 zusammen setzen (wie `move.l #…,Bltcon0`) */
  setCon(value: number): void {
    this.con0 = value >>> 16;
    this.con1 = value & 0xffff;
  }

  /** Masken setzen (wie `move.l #…,Bltafwm`) */
  setMasks(value: number): void {
    this.afwm = value >>> 16;
    this.alwm = value & 0xffff;
  }

  /** BLTSIZE schreiben: Bits 15–6 Zeilen (0 = 1024), 5–0 Wörter (0 = 64); startet den Blit */
  start(size: number): void {
    const width = size & 63 || 64;
    const height = size >>> 6 || 1024;
    if (this.con1 & 1) throw new Error("Blitter: Linienmodus wird nicht unterstützt");
    if (this.con1 & 0x18) throw new Error("Blitter: Füllmodus wird nicht unterstützt");
    const useA = (this.con0 & 0x800) !== 0;
    const useB = (this.con0 & 0x400) !== 0;
    const useC = (this.con0 & 0x200) !== 0;
    const useD = (this.con0 & 0x100) !== 0;
    const ash = this.con0 >>> 12;
    const bsh = this.con1 >>> 12;
    const minterm = this.con0 & 0xff;
    const sources = (useA ? 1 : 0) + (useB ? 1 : 0) + (useC ? 1 : 0);
    this.cycles += width * height * (sources <= 1 ? 2 : sources === 3 ? 4 : 3);
    this.blits++;
    const desc = (this.con1 & 2) !== 0;
    const step = desc ? -2 : 2;
    const sign = desc ? -1 : 1;
    const ram = this.ram;
    let aOld = 0;
    let bOld = 0;
    let a = this.adat;
    let b = this.bdat;
    let c = this.cdat;

    for (let y = 0; y < height; y++) {
      for (let x = 0; x < width; x++) {
        if (useA) {
          a = ram.word(this.apt);
          this.apt += step;
        }
        if (useB) {
          b = ram.word(this.bpt);
          this.bpt += step;
        }
        if (useC) {
          c = ram.word(this.cpt);
          this.cpt += step;
        }
        let am = a;
        if (x === 0) am &= this.afwm;
        if (x === width - 1) am &= this.alwm;
        // Aufsteigend: Bits des vorigen Worts rücken von links nach; absteigend von rechts
        const as = desc ? ((am << ash) | (aOld >>> (16 - ash))) & 0xffff : (((aOld << 16) | am) >>> ash) & 0xffff;
        const bs = desc ? ((b << bsh) | (bOld >>> (16 - bsh))) & 0xffff : (((bOld << 16) | b) >>> bsh) & 0xffff;
        aOld = am;
        bOld = b;
        if (useD) {
          ram.setWord(this.dpt, applyMinterm(minterm, as, bs, c));
          this.dpt += step;
        }
      }
      if (useA) this.apt += sign * this.amod;
      if (useB) this.bpt += sign * this.bmod;
      if (useC) this.cpt += sign * this.cmod;
      if (useD) this.dpt += sign * this.dmod;
    }
    this.adat = a;
    this.bdat = b;
    this.cdat = c;
  }
}

/** Minterm: Bit 7 = ABC, 6 = ABc, 5 = AbC, 4 = Abc, 3 = aBC, 2 = aBc, 1 = abC, 0 = abc (Kleinbuchstabe = negiert) */
export function applyMinterm(minterm: number, a: number, b: number, c: number): number {
  let d = 0;
  if (minterm & 0x80) d |= a & b & c;
  if (minterm & 0x40) d |= a & b & ~c;
  if (minterm & 0x20) d |= a & ~b & c;
  if (minterm & 0x10) d |= a & ~b & ~c;
  if (minterm & 0x08) d |= ~a & b & c;
  if (minterm & 0x04) d |= ~a & b & ~c;
  if (minterm & 0x02) d |= ~a & ~b & c;
  if (minterm & 0x01) d |= ~a & ~b & ~c;
  return d & 0xffff;
}
