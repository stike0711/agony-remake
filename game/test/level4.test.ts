// Level 4 (Berge) ohne Aufnahme: Layout aus MARSHES übertragen (tools/analysis/derive_layout.py), Start mit den
// gemeinsamen Variablen aus Level 3, mit Dauerfeuer durch alle Gegner-Routinen bis zum Levelende. Gegen das Original
// noch ungeprüft.

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

  it("übernimmt die gemeinsamen Variablen und läuft mit Dauerfeuer bis zum Levelende", () => {
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
    // R_Dragon: je Lauf Startbild, Parameter P_D_Y und je Durchlauf [Modus, Kopfwort, x, y, Objekt, Status-Byte,
    // x und Objekt der Zunge]
    const dr: { slot: number; open: boolean; start: number; y: number; pos: number[][] }[] = [];
    // R_Final: erstes Bild, Anzahl der ausgeworfenen Massen (Wechsel von R_F_Mode 1 nach 2), Beginn des Levelendes
    let finalAt = -1, finalMode = 0, masses = 0, quitAt = -1;
    for (; f < 13000 && !e.unported && !e.result; f++) {
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
        if (code === 0x4c888) {
          if (finalAt < 0) finalAt = f;
          const mode = e.ram.word(a0 + 12);
          if (mode === 2 && finalMode === 1) masses++;
          finalMode = mode;
        }
        let drun = dr.find((r) => r.open && r.slot === a0);
        if (drun && code !== 0x4c710) drun.open = false;
        if (code === 0x4c710) {
          if (!drun) dr.push(drun = { slot: a0, open: true, start: f, y: e.ram.word(e.ram.long(a0 + 4)), pos: [] });
          const bank = e.ram.long(a0 + 8);
          const p = [e.ram.word(a0 + 12), e.ram.word(bank), e.ram.word(bank + 4), e.ram.word(bank + 6),
            e.ram.word(bank + 8), e.ram.byte(bank + 12), e.ram.word(bank + 16), e.ram.word(bank + 20)];
          // je Durchlauf 2 Pixel nach links
          const q = drun.pos[drun.pos.length - 1];
          if (p[0] !== 0 && (!q || q[2] !== p[2])) drun.pos.push(p);
        }
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
      if (quitAt < 0 && e.w(V.quitDelay) !== 0) quitAt = f;
      // ohne Regen und Zauber zeigen Sprite 6 und 7 die leere Liste
      if (f === 40) expect([e.ram.long(L.d + V.sprPtrB + 24), e.ram.long(L.d + V.sprPtrB + 28)]).toEqual([L.emptySpr, L.emptySpr]);
    }
    // R_Bomber (WAIT $80), R_Colonne_Flamme (WAIT $140), R_Sol_Guide (ab WAIT $280), R_Dragon (ab WAIT $1180) und der
    // Endgegner R_Final ($4C888, START_C bei WAIT $2300) im Bild FINAL_AT; er wirft MASSES-mal die Masse aus, nach
    // seiner Explosion Quit_Delay 25 und Levelende. Bildnummern aus dem Nachbau (Regression, gegen das Original
    // ungeprüft)
    expect(e.unported).toBeNull();
    expect(e.result).toBe("levelDone");
    expect([finalAt, masses, quitAt, f]).toEqual([FINAL_AT, MASSES, QUIT_AT, END_AT]);
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

    // R_Sol_Guide (Quelle: AG_GAME_LMONTAGNES.S, Label R_Sol_Guide und Start_List): 18 Läufe bis zum Halt mit den
    // Parametern aus der Startliste
    expect(sg.map((r) => r.start)).toEqual(SG_START);
    expect(sg.map((r) => r.launch)).toEqual([456, 456, 436, 406, 406, 456, 436, 406, 406, 456, 436, 406, 406, 406, 406,
      406, 406, 406]);
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
    expect(modes).toEqual([3, 3, 3, 4, 4, 4, 4, 4, 5, 4, 4, 5, 6, 6, 6, 6, 5, 6]);

    // R_Dragon (Quelle: AG_GAME_LMONTAGNES.S, Label R_Dragon und Start_List): 6 Läufe mit P_D_Y 256 + 60 bzw. 256 + 140
    expect(dr.map((r) => r.start)).toEqual(DR_START);
    expect(dr.map((r) => r.y)).toEqual([316, 396, 316, 396, 316, 396]);
    expect(dr.every((r) => !r.open)).toBe(true);
    const launches: number[][] = [];
    for (const r of dr) {
      // Start bei x 256 + 350, je Durchlauf 2 Pixel nach links mit Dragon_Shape (7 × $54E, 3 × $56E), CLOSE bei x 180
      // (auch abgeschossen): 213 Durchläufe von x 606 bis 182
      expect(r.pos.length).toBe(213);
      r.pos.forEach((p, j) => expect(p.slice(2, 5)).toEqual([606 - 2 * j, r.y, j % 10 < 7 ? 0x54e : 0x56e]));
      // Zunge: im Durchlauf des Wechsels in Modus 2 zwei Gegner, Zunge bei x − 190 mit Obj_Fire_1
      const l: number[] = [];
      r.pos.forEach((p, j) => {
        if (p[0] !== 2 || r.pos[j - 1]![0] !== 1) return;
        l.push(j);
        expect([p[1], p[6], p[7]]).toEqual([2, (p[2]! - 190) & 0xffff, 0x58e]);
      });
      launches.push(l);
    }
    // Die tief fliegenden Drachen überleben das Dauerfeuer (alle 30 Durchläufe eine Zunge, die letzten drei enden
    // schon im ersten Zug bei x ≤ 130), die oberen werden abgeschossen (Explosion beendet: Halbbyte $F, keine Zunge
    // mehr); Regression
    expect(dr.map((r) => r.pos[r.pos.length - 1]![5]! & 0xf)).toEqual([15, 0, 15, 0, 15, 0]);
    const low = [30, 93, 147, 178, 209];
    expect(launches).toEqual([[], low, [30], low, [30], low]);
  }, 180_000);
});

/** Bewegungsmuster des Planungs-Bots (wie explore-level.ts): Dauer in Bildern, Richtung */
const PATTERN: [number, number][] = [
  [25, JOY_UP], [30, 0], [25, JOY_DOWN], [20, 0], [15, JOY_RIGHT], [30, JOY_DOWN], [20, 0], [15, JOY_LEFT], [40, JOY_UP],
  [25, 0],
];
const FINAL_AT = 9058;
const MASSES = 32;
const QUIT_AT = 11984;
const END_AT = 12032;
const CF_START = 402;
const CF_END = 819;
const SG_START = [722, 1618, 1681, 1746, 2387, 3028, 3090, 3155, 4084, 4824, 4884, 4951, 6232, 6357, 6995, 7124, 7514,
  7643];
const DR_START = [4563, 4690, 4820, 4946, 5075, 5203];
