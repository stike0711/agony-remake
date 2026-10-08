// Feuerband der Titelsequenz pixelgenau gegen die Interlace-Aufnahme des Emulators
// (work/captures/ilace_build_912x626_24_every10_from3240.rgb: je Aufnahme ein langes Halbbild = gerade Zeilen und
// das folgende kurze = ungerade Zeilen, Hires). Geprüft wird das ganze 704 × 560-Bild des Nachbaus.

import { existsSync, openSync, readSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { describe, expect, it } from "vitest";
import { Game, type Screen } from "../src/core/game.ts";
import { InputFrame } from "../src/core/input.ts";
import { TitleSequence } from "../src/core/screens/title.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const CAPTURE = join(dirname(fileURLToPath(import.meta.url)), "../../work/captures/ilace_build_912x626_24_every10_from3240.rgb");
const CAP_W = 912, CAP_H = 626, FIRST = 3240, EVERY = 10;
/** Lage des Nachbau-Bilds in der Aufnahme (Hires-Pixel, Zeilen) */
const DX = 154, DY = 64;
/** Takt 0 der Titelsequenz (siehe title.test.ts) */
const FRAME0 = 2999;

describe.skipIf(!hasAssets || !existsSync(CAPTURE))("Feuerband gegen die Interlace-Aufnahme", () => {
  it("ist in beiden Halbbildern pixelgenau", () => {
    const end: Screen = { enter: () => {}, tick: () => {} };
    const seq = new TitleSequence(() => end);
    const game = new Game(loadAssets(), { lang: "en" }, seq);
    const d = game.display;
    const input = new InputFrame();
    const fd = openSync(CAPTURE, "r");
    const capture = new Uint8Array(CAP_W * CAP_H * 3);
    const results: string[] = [];

    const shots = [3330, 3400, 3470];
    let wrong = 0;
    for (let frame = FRAME0; frame <= shots[shots.length - 1]! + 1; frame++) {
      game.tick(input);
      // Bild `shot` liefert die geraden Zeilen, das nächste die ungeraden
      const shot = shots.find((s) => frame === s || frame === s + 1);
      if (shot === undefined) continue;
      if (frame === shot) readSync(fd, capture, 0, capture.length, ((shot - FIRST) / EVERY) * capture.length);
      for (let y = frame - shot; y < d.height; y += 2) {
        for (let x = 0; x < d.width; x++) {
          const c = d.palette[y * 32 + d.pixels[y * d.width + x]!]!;
          const i = ((DY + y) * CAP_W + DX + x) * 3;
          const r = (capture[i]! + 8) >> 4, g = (capture[i + 1]! + 8) >> 4, b = (capture[i + 2]! + 8) >> 4;
          if (((r << 8) | (g << 4) | b) !== c) wrong++;
        }
      }
      if (frame === shot + 1) {
        results.push(`${shot}: ${wrong}`);
        wrong = 0;
      }
    }
    expect(results).toEqual(["3330: 0", "3400: 0", "3470: 0"]);
  });
});
