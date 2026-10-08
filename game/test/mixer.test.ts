// Mixer der Plattform: spielt die Registerzugriffe des Kerns mit demselben Zeitverhalten wie das Paula-Modell ab.

import { describe, expect, it } from "vitest";
import { LOG_STRIDE, Paula } from "../src/core/paula.ts";
import { PaulaMixer } from "../src/platform/audio/paula-mixer.ts";

const RATE = 48000;

function batch(p: Paula, cc: number) {
  const b = { writes: p.log.slice(0, p.logCount * LOG_STRIDE), count: p.logCount, cc, frozen: false };
  p.clearLog();
  p.now = 0;
  return b;
}

describe("PaulaMixer", () => {
  const memory = new Int8Array(64).fill(100); // konstanter Pegel

  it("schweigt bis zum Vorpuffer, spielt dann Kanal 0 links und Kanal 1 rechts", () => {
    const p = new Paula();
    const m = new PaulaMixer(RATE);
    m.setMemory(memory);
    const left = new Float32Array(256), right = new Float32Array(256);
    p.play(0, 0, 64, 200, 64);
    m.push(batch(p, 71051));
    m.render(left, right, 256);
    expect(Math.max(...left)).toBe(0); // erst ein Block da
    m.push(batch(p, 71051));
    m.render(left, right, 256);
    expect(left[10]).toBeCloseTo((100 * 64) / 16384);
    expect(right[10]).toBe(0);
  });

  it("verstummt, wenn das Spiel steht, und nach DMA aus", () => {
    const p = new Paula();
    const m = new PaulaMixer(RATE);
    m.setMemory(memory);
    p.play(1, 0, 64, 200, 64);
    m.push(batch(p, 71051));
    m.push({ ...batch(p, 71051), frozen: true });
    p.stop(0b0010);
    m.push(batch(p, 71051));
    const l = new Float32Array(1500), r = new Float32Array(1500);
    m.render(l, r, 1000); // Block 1 (≈ 962 Samples) + Anfang von Block 2
    expect(r[500]).toBeGreaterThan(0);
    expect(r[990]).toBe(0); // eingefroren
    m.render(l, r, 1500); // Rest von Block 2, dann Block 3 mit DMA aus
    expect(r[1400]).toBe(0);
  });

  it("baut zu lange Warteschlangen ab", () => {
    const p = new Paula();
    const m = new PaulaMixer(RATE);
    for (let i = 0; i < 10; i++) m.push(batch(p, 71051));
    expect(m.dropped).toBe(4);
  });
});
