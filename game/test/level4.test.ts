// Level 4 (Berge) ohne Aufnahme: Layout aus MARSHES übertragen (tools/analysis/derive_layout.py), Start mit den
// gemeinsamen Variablen aus Level 3, mit Dauerfeuer bis zur ersten noch nicht übertragenen Gegner-Routine. Gegen das
// Original noch ungeprüft.

import { describe, expect, it } from "vitest";
import { Display } from "../src/core/display.ts";
import { JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP } from "../src/core/input.ts";
import { LevelEngine } from "../src/core/level/engine.ts";
import { MOUNTAINS, SHARED, SHARED_LENGTH, SHARED_START } from "../src/core/level/layout.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";

const L = MOUNTAINS;
const V = L.vars;

describe.skipIf(!hasAssets)("Level 4 (ohne Aufnahme)", () => {
  it("hat Copperliste, Muster und Startliste an den abgeleiteten Adressen", () => {
    const e = new LevelEngine(L, loadAssets().memory);
    // Main_Cl beginnt mit SPR0PTH, Cl_Flip_Phase1 mit $0192, Back_Pattern mit $0020, Startliste mit WAIT $40
    expect([L.mainCl, L.clFlipPhase1, L.backPattern, L.startList].map((a) => e.ram.word(a))).toEqual([0x120, 0x192, 0x20, 0x40]);
    // erster Eintrag: START_A DGDP_Boulle ($4BB88), 256 + 300, 256 + 100 (Quelle: AG_GAME_LMONTAGNES.S, Label
    // Start_List)
    expect([e.ram.long(L.startList + 2), e.ram.word(L.startList + 6), e.ram.word(L.startList + 8)])
      .toEqual([0x4004bb88, 556, 356]);
    // zweiter Eintrag (WAIT $80): START_C R_Bomber ($4C412), PAR_END
    expect([e.ram.word(L.startList + 10), e.ram.long(L.startList + 12), e.ram.word(L.startList + 16)])
      .toEqual([0x80, 0x8004c412, 0xffff]);
  });

  it("übernimmt die gemeinsamen Variablen und läuft mit Dauerfeuer bis zur ersten Gegner-Routine", () => {
    const shared = new Uint8Array(SHARED_LENGTH);
    const put = (a: number, v: number, n: number): void => { for (let i = 0; i < n; i++) shared[a - SHARED_START + i] = (v >>> (8 * (n - 1 - i))) & 0xff; };
    put(SHARED.score, 0x54321, 4);
    put(SHARED.life, 0b111, 2);
    put(SHARED.fwFireWeapon, 1, 2);
    const e = new LevelEngine(L, loadAssets().memory);
    e.start(shared);
    expect([e.ram.long(SHARED.score), e.ram.word(SHARED.life), e.ram.word(SHARED.fwFireWeapon)]).toEqual([0x54321, 7, 1]);
    expect(e.w(V.rainOn)).toBe(0);
    const display = new Display();
    display.setMode(true, false);
    // ab Bild 58 Dauerfeuer mit dem Bewegungsmuster von explore-level.ts (dort ab Bild 13170)
    let k = 0, n = 0, f = 0;
    // R_Colonne_Flamme: Bank je Durchlauf (Kopfwort, x und Objekt der 4 Flammen)
    const cf: { f: number; count: number; x: number[]; obj: number[] }[] = [];
    let cfStart = -1, cfEnd = -1;
    // R_Sol_Guide: je Lauf Startbild, Parameter P_SG_Launch und je Durchlauf Modus, Position und Objekt
    const sg: { slot: number; open: boolean; start: number; launch: number; pos: number[][] }[] = [];
    for (; f < 6000 && !e.unported && !e.result; f++) {
      let input = f === 49 || f === 50 ? JOY_FIRE : 0;
      if (f >= 58) {
        if (n === 0) { [n] = PATTERN[k % PATTERN.length]!; k++; }
        input = JOY_FIRE | PATTERN[(k - 1) % PATTERN.length]![1];
        n--;
      }
      e.setInput(input);
      if (e.ram.word(SHARED.life) < 3) e.ram.setWord(SHARED.life, 7);
      e.tick(display);
      let slot = -1;
      for (let i = 0; i < 32; i++) {
        const a0 = L.routStruct + 28 * i;
        const code = e.ram.long(a0);
        if (code === 0x4c276) slot = a0;
        let run = sg.find((r) => r.open && r.slot === a0);
        if (run && code !== 0x4c55c) run.open = false;
        if (code !== 0x4c55c) continue;
        if (!run) sg.push(run = { slot: a0, open: true, start: f, launch: e.ram.word(e.ram.long(a0 + 4)), pos: [] });
        const bank = e.ram.long(a0 + 8);
        const p = [e.ram.word(a0 + 12), e.ram.word(bank + 4), e.ram.word(bank + 6), e.ram.word(bank + 8)];
        // Modus 0: der Eintrag ist belegt, die Routine aber noch nicht gelaufen; je Durchlauf ändert sich x oder y
        const q = run.pos[run.pos.length - 1];
        if (p[0] !== 0 && (!q || q[1] !== p[1] || q[2] !== p[2])) run.pos.push(p);
      }
      if (slot >= 0 && cfEnd < 0) {
        if (cfStart < 0) cfStart = f;
        const bank = e.ram.long(slot + 8);
        const a = [0, 1, 2, 3].map((i) => bank + 4 + 12 * i);
        cf.push({ f, count: e.ram.word(bank), x: a.map((p) => e.ram.word(p)), obj: a.map((p) => e.ram.word(p + 4)) });
      } else if (cfStart >= 0 && cfEnd < 0) cfEnd = f;
      // ohne Regen und Zauber zeigen Sprite 6 und 7 die leere Liste
      if (f === 40) expect([e.ram.long(L.d + V.sprPtrB + 24), e.ram.long(L.d + V.sprPtrB + 28)]).toEqual([L.emptySpr, L.emptySpr]);
    }
    // R_Bomber (WAIT $80), R_Colonne_Flamme (WAIT $140) und R_Sol_Guide (ab WAIT $280) laufen, die Engine hält am
    // ersten R_Dragon ($4C710, WAIT $1180); Bildnummern aus dem Nachbau (Regression, gegen das Original ungeprüft)
    expect(e.result).toBeNull();
    expect(e.unported).toContain("$4C710");
    expect(e.w(V.levelX)).toBeGreaterThanOrEqual(0x1180);
    expect(e.w(V.levelX)).toBeLessThan(0x1190);
    expect(f).toBe(UNPORTED_AT);
    // R_Colonne_Flamme (Quelle: AG_GAME_LMONTAGNES.S, Label R_Colonne_Flamme): Start-Durchlauf mit 4 Flammen bei
    // x 256 + 360, y 446, 411, 376, 341 und Obj_Grande_Flamme_1; Startphasen an den absoluten Adressen $2–$9 (O-018)
    expect(cfStart).toBe(CF_START);
    expect(cf[0]!.count).toBe(1);
    expect(cf[0]!.x).toEqual([616, 616, 616, 616]);
    expect(cf[0]!.obj).toEqual([0x198, 0x198, 0x198, 0x198]);
    expect([0, 1, 2, 3].map((i) => e.ram.word(2 + 2 * i))).toEqual([0, 2, 4, 6]);
    // R_CF_Shape und R_CF_Hight im Abbild
    expect([0, 1, 2, 3, 4, 5, 6, 7].map((i) => e.ram.word(0x4c246 + 2 * i))).toEqual([0x198, 0x1aa, 0x1bc, 0x1ce, 0x1e0, 0x1f2, 0x204, 0x216]);
    const hight = [1, 1, 1, 1, 1, 1, 1, 2, 3, 4, 4, 4, 4, 4, 3, 2];
    expect(hight.map((_, i) => e.ram.word(0x4c256 + 2 * i))).toEqual(hight);
    // je Durchlauf 2 Pixel nach links, alle 4 Flammen mit demselben Bild (Phase 2, 4, …, 14, 0), alle 3 Durchläufe
    // der nächste Wert aus R_CF_Hight als Zahl der sichtbaren Flammen
    // Die Hauptschleife braucht hier 1–3 Bilder je Durchlauf; Durchlauf j aus x = 616 − 2j. Je Durchlauf 2 Pixel nach
    // links, alle 4 Flammen mit demselben Bild (Phase 2j mod 16), nach jedem dritten Durchlauf der nächste Wert aus
    // R_CF_Hight als Zahl der sichtbaren Flammen
    const passes = new Set<number>();
    for (const r of cf) {
      const j = (616 - r.x[0]!) / 2;
      passes.add(j);
      expect(r.x).toEqual(Array(4).fill(r.x[0]));
      expect(r.obj).toEqual(Array(4).fill(0x198 + 0x12 * (j % 8)));
      expect(r.count).toBe(hight[Math.floor(j / 3) % 16]);
    }
    // Ende bei x 200: Durchläufe 0–207 sichtbar, im Durchlauf 208 CLOSE (die zweite Säule ab WAIT $4D0 zählt nicht)
    expect(passes.size).toBe(Math.max(...passes) + 1);
    expect(passes.size).toBe(208);
    expect(cfEnd).toBe(CF_END);

    // R_Sol_Guide (Quelle: AG_GAME_LMONTAGNES.S, Label R_Sol_Guide und Start_List): 9 Läufe bis zum Halt mit den
    // Parametern aus der Startliste
    expect(sg.map((r) => r.start)).toEqual(SG_START);
    expect(sg.map((r) => r.launch)).toEqual([456, 456, 436, 406, 406, 456, 436, 406, 406]);
    expect(sg.every((r) => !r.open)).toBe(true);
    const step: Record<number, number[]> = { 2: [-3, -1, 0x3bc], 3: [-3, -3, 0x3d2], 4: [0, -3, 0x3e8], 5: [3, -3, 0x3fe], 6: [3, -1, 0x414] };
    const modes: number[] = [];
    for (const r of sg) {
      // Start bei x 576, y 434 mit $3AA, dann 2 Pixel je Durchlauf bis x = Parameter; erst danach steht der Modus
      const walk = (576 - r.launch) / 2;
      for (let j = 0; j <= walk; j++) expect(r.pos[j]).toEqual([j < walk ? 1 : r.pos[walk]![0], 576 - 2 * j, 434, 0x3aa]);
      const m = r.pos[walk]![0]!;
      modes.push(m);
      const [dx, dy, obj] = step[m]!;
      for (let j = walk + 1; j < r.pos.length; j++) {
        expect(r.pos[j]).toEqual([m, r.launch + dx! * (j - walk), 434 + dy! * (j - walk), obj]);
      }
      // nicht abgeschossen: Ende, weil der nächste Schritt den Rand überschreitet (x < 200, x > 586 oder y < 200)
      const [, x, y] = r.pos[r.pos.length - 1]!;
      const nx = x! + dx!, ny = y! + dy!;
      expect(nx < 200 || nx > 586 || ny < 200).toBe(true);
    }
    // gewählte Richtung je Lauf (hängt von der Lage der Eule beim Abflug ab; Regression)
    expect(modes).toEqual([3, 3, 3, 4, 4, 4, 4, 4, 5]);
  }, 60_000);
});

/** Bewegungsmuster des Planungs-Bots (wie explore-level.ts): Dauer in Bildern, Richtung */
const PATTERN: [number, number][] = [
  [25, JOY_UP], [30, 0], [25, JOY_DOWN], [20, 0], [15, JOY_RIGHT], [30, JOY_DOWN], [20, 0], [15, JOY_LEFT], [40, JOY_UP],
  [25, 0],
];
const UNPORTED_AT = 4564;
const CF_START = 402;
const CF_END = 819;
const SG_START = [722, 1618, 1681, 1746, 2387, 3028, 3090, 3155, 4084];
