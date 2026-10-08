// Blitter-Modell (E-032): Verschiebung, Masken, Modulos und absteigender Modus an kleinen Beispielen, deren Ergebnis
// sich von Hand nachrechnen lässt (Amiga Hardware Reference Manual, Kapitel 6). Die Kachel-Blits ohne Verschiebung
// prüft level1.test.ts gegen den Emulator.

import { describe, expect, it } from "vitest";
import { applyMinterm, Blitter } from "../src/core/amiga/blitter.ts";
import { Ram } from "../src/core/amiga/ram.ts";

function words(ram: Ram, address: number, count: number): number[] {
  return Array.from({ length: count }, (_, i) => ram.word(address + 2 * i));
}

describe("Blitter", () => {
  it("kopiert A nach D mit Verschiebung, Maske für das letzte Wort und Modulos", () => {
    const ram = new Ram();
    // 2 Zeilen à 2 Wörter Quelle, gelesen werden je 3 Wörter (Modulo −2 wie beim Himmel), das 3. maskiert
    [0xf00f, 0x1234, 0xaaaa, 0x5555].forEach((w, i) => ram.setWord(0x1000 + 2 * i, w));
    const bl = new Blitter(ram);
    bl.setCon(0x49f00000); // Verschiebung 4, D = A
    bl.setMasks(0xffff0000);
    bl.apt = 0x1000;
    bl.amod = -2;
    bl.dpt = 0x2000;
    bl.dmod = 0;
    bl.start(3 + 64 * 2);
    // Zeile 0: f00f 1234 [aaaa maskiert] → 0f00 f123 4000; Zeile 1 liest ab $1004: aaaa 5555 [Folgewort maskiert]
    expect(words(ram, 0x2000, 6).map((w) => w.toString(16))).toEqual(["f00", "f123", "4000", "aaa", "a555", "5000"]);
    expect(bl.apt).toBe(0x1000 + 2 * 3 * 2 - 2 * 2);
    expect(bl.dpt).toBe(0x2000 + 12);
  });

  it("löscht mit Minterm 0 nur über D und lässt A unberührt", () => {
    const ram = new Ram();
    ram.setLong(0x3000, 0xffffffff);
    const bl = new Blitter(ram);
    bl.setCon(0x01000000);
    bl.apt = 0x1234;
    bl.dpt = 0x3000;
    bl.dmod = 0;
    bl.start(2 + 64);
    expect(ram.long(0x3000)).toBe(0);
    expect(bl.apt).toBe(0x1234);
  });

  it("schiebt im absteigenden Modus nach links", () => {
    const ram = new Ram();
    ram.setWord(0x1000, 0x8001);
    ram.setWord(0x1002, 0x8001);
    const bl = new Blitter(ram);
    bl.setCon(0x19f00002); // Verschiebung 1, absteigend
    bl.setMasks(0xffffffff);
    bl.apt = 0x1002;
    bl.dpt = 0x2002;
    bl.start(2 + 64);
    // von rechts: 8001 → 0002; dann 8001 mit dem Übertrag (Bit 15 des rechten Worts) → 0003
    expect(words(ram, 0x2000, 2).map((w) => w.toString(16))).toEqual(["3", "2"]);
  });

  it("verknüpft A, B und C über den Minterm", () => {
    // D = A·B + ¬A·C (Ausschneiden mit Maske, Minterm $CA)
    expect(applyMinterm(0xca, 0xff00, 0x1234, 0xabcd)).toBe(0x12cd);
  });
});
