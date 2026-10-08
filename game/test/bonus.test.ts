// BONUS (sea $56BA, Ag_Sprites.s) ohne Aufnahme: Werte von Hand aus dem Quelltext abgeleitet. Der Copper-Interrupt
// läuft allein auf dem Speicher des Levels (LevelEngine nach start()).

import { describe, expect, it } from "vitest";
import { LevelEngine } from "../src/core/level/engine.ts";
import { copperInterrupt } from "../src/core/level/interrupt.ts";
import { SEA, SHARED } from "../src/core/level/layout.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const V = SEA.vars;

describe.skipIf(!hasAssets)("Bonus (ohne Aufnahme)", () => {
  it("startet nach 2000 Bildern, fällt, rollt und bringt der Eule eine Waffenstufe", () => {
    const e = new LevelEngine(SEA, loadAssets().memory);
    e.start();
    const irq = (): void => {
      e.setW(V.genPhase, 0);
      copperInterrupt(e);
    };
    e.ram.setWord(SHARED.fwFireWeapon, 1);
    e.setW(V.rainOn, 1);
    e.setW(V.bonusDelay, 2000);
    e.setW(V.sorcererX, 300);
    e.setW(V.sorcererY, 300);
    irq();
    // Fw_Fire_Weapon ≤ 1: Bonus_Num 2 (Waffe); Regen aus, Bonus_Delay von vorn
    expect([e.w(V.bonusMode), e.w(V.bonusNum), e.w(V.rainOn), e.w(V.bonusDelay)]).toEqual([1, 2, 0, 0]);
    // ein Gegner explodiert bei (500, 300): Modus 2, fällt mit x − 1, y + 2 je Bild
    e.setW(V.bonusX, 500);
    e.setW(V.bonusY, 300);
    e.setW(V.bonusMode, 2);
    irq();
    expect([e.w(V.bonusX), e.w(V.bonusY), e.w(V.bonusMode)]).toEqual([499, 302, 2]);
    // ab y 256 + 166 rollt er (Modus 3): 61 Bilder bis y 422
    for (let i = 0; i < 60; i++) irq();
    expect([e.w(V.bonusY), e.w(V.bonusMode), e.w(V.bonusX)]).toEqual([422, 3, 439]);
    // Eule bei (430, 400): Rechteck x 414 … 480, y 390 … 470 – Bonus wird eingesammelt
    e.setW(V.sorcererX, 430);
    e.setW(V.sorcererY, 400);
    irq();
    expect([e.w(V.bonusMode), e.ram.word(SHARED.fwFireWeapon), e.l(V.point), e.l(V.sprPtrB + 24)]).toEqual([0, 2, 0x258, SEA.emptySpr]);
  });
});
