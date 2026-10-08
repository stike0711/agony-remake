// Paula-Modell: Zeitverhalten der Audio-DMA und Interrupts (Sample-Ende) in Farbtakten.

import { describe, expect, it } from "vitest";
import { AUD_LEN, AUD_PER, DMAF_SETCLR, MIN_PERIOD, Paula, REG_DMACON } from "../src/core/paula.ts";

describe("Paula", () => {
  it("meldet den Interrupt beim Start und nach jedem Block", () => {
    const p = new Paula();
    p.play(2, 0, 100, 200, 64); // 100 Byte × 200 Farbtakte = 20000 Farbtakte je Block
    expect(p.takeInterrupts()).toBe(0b0100);
    p.advance(19999);
    expect(p.takeInterrupts()).toBe(0);
    p.advance(1);
    expect(p.takeInterrupts()).toBe(0b0100);
    p.advance(20000 * 3);
    expect(p.intreq).toBe(0b0100);
  });

  it("übernimmt neue LEN erst beim nächsten Block (wie die Hardware)", () => {
    const p = new Paula();
    p.play(0, 0, 100, 200, 64);
    p.takeInterrupts();
    p.write(AUD_LEN, 0, 10); // 20 Byte
    p.advance(19999);
    expect(p.takeInterrupts()).toBe(0);
    p.advance(1 + 20 * 200 - 1);
    expect(p.takeInterrupts()).toBe(1);
    p.advance(1);
    expect(p.takeInterrupts()).toBe(1);
  });

  it("rechnet Periodenwechsel mitten im Block anteilig", () => {
    const p = new Paula();
    p.play(1, 0, 100, 200, 64);
    p.takeInterrupts();
    p.advance(50 * 200); // Hälfte
    p.write(AUD_PER, 1, 400);
    p.advance(50 * 400 - 1);
    expect(p.takeInterrupts()).toBe(0);
    p.advance(1);
    expect(p.takeInterrupts()).toBe(2);
  });

  it("stoppt bei DMA aus und begrenzt kleine Perioden", () => {
    const p = new Paula();
    p.play(3, 0, 10, 50, 64);
    p.takeInterrupts();
    p.advance(10 * MIN_PERIOD - 1);
    expect(p.takeInterrupts()).toBe(0);
    p.stop(0b1000);
    p.advance(1_000_000);
    expect(p.takeInterrupts()).toBe(0);
  });

  it("protokolliert alle Schreibzugriffe für den Mixer", () => {
    const p = new Paula();
    p.play(0, 64, 10, 300, 40);
    expect(p.logCount).toBe(5);
    expect(Array.from(p.log.subarray(16, 20))).toEqual([REG_DMACON, 0, DMAF_SETCLR | 1, 0]);
    p.clearLog();
    expect(p.logCount).toBe(0);
  });
});
