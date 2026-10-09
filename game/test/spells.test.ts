// Zaubermenü, Pause, Äxte und Zauber (sea $49C2–$54EA, $5CCC; spells.ts) ohne Aufnahme: Werte von Hand aus der
// Disassembly bzw. Ag_Sprites.s abgeleitet. Der Copper-Interrupt läuft allein auf dem Speicher des Levels.

import { describe, expect, it } from "vitest";
import { BTN_PAUSE, BTN_SPELL, JOY_DOWN, JOY_FIRE } from "../src/core/input.ts";
import { LevelEngine } from "../src/core/level/engine.ts";
import { copperInterrupt } from "../src/core/level/interrupt.ts";
import { SEA, SHARED } from "../src/core/level/layout.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const V = SEA.vars;

function engine(): { e: LevelEngine; irq: (buttons?: number) => void } {
  const e = new LevelEngine(SEA, loadAssets().memory);
  e.start();
  e.setW(V.sorcererX, 300);
  e.setW(V.sorcererY, 300);
  // nach „LET'S GO“: Begin_To_Start und Stop aus (sonst ignoriert KEY TEST P und Leertaste)
  e.setW(V.beginToStart, 0);
  e.setW(V.stop, 0);
  return {
    e,
    irq: (buttons = 0) => {
      e.setInput(buttons);
      e.setW(V.genPhase, 0);
      copperInterrupt(e);
    },
  };
}

/** Kollisionsrechteck i der Good_Col_List (x1, y1, x2, y2) */
const rect = (e: LevelEngine, i: number): number[] => [0, 2, 4, 6].map((o) => e.ram.word(SEA.goodColList + 8 * i + o));

describe.skipIf(!hasAssets)("Zaubermenü, Pause, Äxte, Zauber (ohne Aufnahme)", () => {
  it("Leertaste öffnet das Menü, der Pfeil wählt, Feuer startet einen verfügbaren Zauber", () => {
    const { e, irq } = engine();
    const before = e.w(V.curentSpell);
    irq(BTN_SPELL);
    // Pause, Stop, Icones_Mode (st.b … +1), Pfeil auf Zeile 48 = Zauber 2 (Name: Statustext 3)
    expect([e.w(V.iconesMode), e.w(V.pause), e.w(V.stop), e.w(V.safeCurSpell)]).toEqual([0xff, 0xff, 0xff, before]);
    expect([e.w(V.arowY), e.w(V.curentSpell), e.w(V.textNum), e.w(V.selectionOn)]).toEqual([48, 2, 3, 0xff]);
    // runter: 2 Zeilen je Bild, nach 12 Bildern Zauber 3
    for (let i = 0; i < 12; i++) irq(i === 0 ? JOY_DOWN : 0);
    expect([e.w(V.arowY), e.w(V.curentSpell), e.w(V.textNum)]).toEqual([72, 3, 4]);
    // Zauber 3 verfügbar machen, Feuer: Zauber startet mit der Dauer aus Time_Table
    e.ram.setWord(SHARED.spellAdvailable + 6, 1);
    irq(JOY_FIRE);
    expect([e.w(V.spellTime), e.ram.word(SHARED.spellAdvailable + 6), e.w(V.pause), e.w(V.stop)])
      .toEqual([e.w(V.timeTable + 6), 0, 0, 0]);
    expect([e.w(V.sorcerer2X), e.w(V.sorcerer2Y), e.w(V.iconesOff) !== 0]).toEqual([300, 300, true]);
    irq(JOY_FIRE);
    expect([e.w(V.iconesMode), e.w(V.iconesOff), e.w(V.curentSpell)]).toEqual([0, 0, 3]);
  });

  it("nicht verfügbarer Zauber: Menü zu, alter Zauber; Leertaste im Menü schließt es ebenso", () => {
    const { e, irq } = engine();
    const before = e.w(V.curentSpell);
    irq(BTN_SPELL);
    irq(0);
    irq(JOY_FIRE);
    expect([e.w(V.curentSpell), e.w(V.pause), e.w(V.textDelay), e.w(V.iconesOff) !== 0]).toEqual([before, 0, 2, true]);
    irq(0);
    irq(BTN_SPELL);
    irq(0);
    irq(BTN_SPELL);
    // Pause_Off setzt Icones_Off, ICONES im selben Bild schließt das Menü (Icones_Off und Icones_Mode wieder 0)
    expect([e.w(V.curentSpell), e.w(V.pause), e.w(V.iconesOff), e.w(V.iconesMode)]).toEqual([before, 0, 0, 0]);
  });

  it("P schaltet die Pause (Statustext 10, LACE-Bit in der Copperliste), Feuer in der Pause beendet sie", () => {
    const { e, irq } = engine();
    const bpl = e.w(V.clBplCon0);
    irq(BTN_PAUSE);
    expect([e.w(V.pause), e.w(V.stop), e.w(V.textNum), e.w(V.textDelay), e.w(V.clBplCon0)]).toEqual([0xff, 0xff, 10, 0xffff, bpl | 4]);
    irq(0);
    irq(BTN_PAUSE);
    expect([e.w(V.pause), e.w(V.stop), e.w(V.textDelay), e.w(V.clBplCon0)]).toEqual([0, 0, 2, bpl & 0x7ffb]);
    irq(0);
    irq(BTN_PAUSE);
    e.setW(V.pause2, e.w(V.pause));
    irq(JOY_FIRE | BTN_PAUSE);
    expect([e.w(V.pause), e.w(V.fireCount)]).toEqual([0, 0]);
  });

  it("Äxte: Kollisionsrechtecke 32 × 8 an ihrer Position", () => {
    const { e, irq } = engine();
    e.ram.setWord(SHARED.axeUpOn, 1);
    e.ram.setWord(SHARED.axeDownOn, 1);
    irq();
    expect(rect(e, 2)).toEqual([e.w(V.axeUpX), e.w(V.axeUpY), e.w(V.axeUpX) + 32, e.w(V.axeUpY) + 8]);
    expect(rect(e, 3)).toEqual([e.w(V.axeDownX), e.w(V.axeDownY), e.w(V.axeDownX) + 32, e.w(V.axeDownY) + 8]);
  });

  it("Zauber 0 und 4: Rechtecke nach den Formeln des Originals", () => {
    const { e, irq } = engine();
    // (0) BACK FIRE BALL: x = X0 − 10 (Startwert −100 aus dem Level), y0 = Y − 146 + x − 14 (mindestens 48),
    // Rechteck [X + x, y0 + 146, +32, Y − 146 − x + 160]; erreicht X0 genau −100, beginnt X1 bei 0
    e.setW(V.curentSpell, 0);
    e.setW(V.backFbX0, -90);
    e.setW(V.backFbX1, -50);
    irq();
    expect([e.sw(V.backFbX0), e.sw(V.backFbX1)]).toEqual([-100, -10]);
    expect(rect(e, 4)).toEqual([200, 48 + 146, 232, 154 + 100 + 160]);
    expect(rect(e, 5)).toEqual([290, 276, 322, 324]);
    // (4) SMART BOMB im ersten Bild: Smart_B_X 0, y auf 288…324 begrenzt, Rechtecke [X ∓ 0, Y − 30, +50, +156]
    e.setW(V.curentSpell, 4);
    irq();
    expect([e.w(V.smartBStep), e.w(V.smartBStepHC), e.w(V.smartBX)]).toEqual([0x274, 1, 0]);
    expect(rect(e, 4)).toEqual([300, 270, 350, 426]);
    expect(rect(e, 5)).toEqual([300, 270, 350, 426]);
  });
});
