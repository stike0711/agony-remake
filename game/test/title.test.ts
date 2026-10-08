// Titelsequenz Bild für Bild gegen die Ablaufspur des Emulators (work/captures/title.trace.json, aufgenommen ab dem
// Schnappschuss snap_f2999_present_loading): Farbpuffer $14AA, Hintergrundfarbe, sichtbares Bild, Feuerband,
// Klangteppich, Lautstärken und Audio-DMA.

import { describe, expect, it } from "vitest";
import { Game, type Screen } from "../src/core/game.ts";
import { InputFrame } from "../src/core/input.ts";
import { type Picture, TitleSequence, TITLE_GRAY } from "../src/core/screens/title.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";
import { hasTrace, Trace } from "./load-trace.ts";

/** Takt 0 der Titelsequenz entspricht diesem Emulator-Bild (erster Einblendschritt bei 3004 = Takt 5) */
const FRAME0 = 2999;
const FIRST = 3002;
const LAST = 4482;

/** Bitplane-Zeiger in der Copperliste → Bild */
const POINTERS: Record<number, string> = {
  0x14168: "title.stereo:0",
  0x01548: "title.psygnosis:0",
  0x39248: "title.texts:0",
  0x18a08: "title.artmagic:0",
  0x399c8: "title.texts:24",
  0x25228: "title.agony:0",
};

const key = (p: Picture | null): string => (p ? `${p.image}:${p.row}` : "-");

describe.skipIf(!hasAssets || !hasTrace("title"))("Titelsequenz gegen den Emulator", () => {
  it("stimmt in jedem Bild mit dem Original überein", () => {
    const trace = new Trace("title");
    const end: Screen = { enter: () => {}, tick: () => {} };
    const seq = new TitleSequence(() => end);
    const game = new Game(loadAssets(), { lang: "en" }, seq);
    const input = new InputFrame();
    const errors: string[] = [];
    const check = (frame: number, what: string, mine: number | string, original: number | string): void => {
      if (mine !== original && errors.length < 20) errors.push(`Bild ${frame}: ${what} ${String(mine)} statt ${String(original)}`);
    };

    for (let frame = FRAME0; frame <= LAST; frame++) {
      game.tick(input);
      if (frame < FIRST) continue;
      for (let i = 0; i < 16; i++) check(frame, `Farbe ${i}`, seq.colors[i]!, trace.word(frame, 0x14aa + 2 * i));
      check(frame, "Hintergrund", seq.background >= 0 ? seq.background : seq.colors[0]!, trace.pixel(frame));
      // Bild: Zeiger der Copperliste gelten ab dem nächsten Bild; geprüft wird, sobald etwas sichtbar ist
      if ([...seq.colors].some((c) => c !== TITLE_GRAY)) {
        check(frame, "Bild", key(seq.picture), POINTERS[trace.long(frame - 1, 0x1094, 0x1098)] ?? "?");
      }
      check(frame, "Feuerband", seq.band[0]!, (trace.word(frame, 0x14d6) << 16) >> 16);
      check(frame, "Periode 0/1", seq.period, trace.word(frame, 0x14cc));
      check(frame, "Lautstärke 0/1", seq.vol01, trace.word(frame, 0x14d0));
      check(frame, "Lautstärke 2/3", seq.vol23, trace.word(frame, 0x1546));
      if (frame < LAST) check(frame, "Audio-DMA", game.paula.dmacon, trace.word(frame, 0xdff002) & 0xf);
    }
    expect(errors).toEqual([]);
    expect(seq.background).toBe(0x000);
  });
});
