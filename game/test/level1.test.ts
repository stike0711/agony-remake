// Level 1 bis „PRESS FIRE TO START“ gegen den Emulator (Schnappschuss snap_f13100_level1_enter, Level beginnt mit
// Bild 13112 = Takt 0):
//   level1_enter_*.rgb + level1_enter.trace.json – ohne Eingabe, Bild 13102–13311
//   level1_joy_*.rgb + level1_joy.trace.json     – Joystick rechts, runter, oben-links, links, unten-rechts
//   level1_edge_*.rgb + level1_edge.trace.json   – Eule an den unteren Rand (Sprite-Ende läuft über Zeile 255 hinaus),
//                                                  dann nach oben links in die Ecke
//   level1_fire.trace.json                       – Feuer in Bild 13161/13162: Begin_To_Start endet, das Spiel beginnt
//   level1_go_*.rgb + level1_go.trace.json       – Feuer in Bild 13161/13162, danach keine Eingabe: Scrollen,
//                                                  Fischwellen, Full_7c, drei Tode der Eule (13586, 13887, 14461) mit
//                                                  Schild beim Wiedereinstieg, R_Sol_Crache und R_Araignee, „GAME OVER“
//                                                  und Levelende in Bild 14647 (Bilder bis 14801, Spur bis 14902;
//                                                  Variablen ab a5 + $7B68, Rout_Struct, AWO-Bänke); Zeitprofil
//                                                  level1_go.profile mit Haltepunkten in Teil 1b
// Bilder: ganzer aufgenommener Ausschnitt (Statuszeile und Spielfeld, Hires) pixelgenau. Variablen: Speicherwörter
// an denselben Adressen wie im Original (25-Hz-Takt, Back_Phase, Eule, Äxte, Text, Begin_To_Start).

import { describe, expect, it } from "vitest";
import { Game, type Screen } from "../src/core/game.ts";
import { InputFrame, JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP } from "../src/core/input.ts";
import type { LevelEngine } from "../src/core/level/engine.ts";
import { SEA, SHARED } from "../src/core/level/layout.ts";
import { type LoopTiming, ModelTiming, type Placement, shortPhaseTime, STEP, vposOf } from "../src/core/level/timing.ts";
import { LevelScreen } from "../src/core/screens/level.ts";
import { HiresCapture } from "./load-capture.ts";
import { hasAssets, loadAssets } from "./load-assets.ts";
import { hasProfile, Profile } from "./load-profile.ts";
import { measuredTiming, measuredVpos } from "./measured-timing.ts";
import { hasTrace, Trace } from "./load-trace.ts";
import { buttonsAt, FIRE_RUN, SHOOT_RUN } from "./runs.ts";

/** Level-Bildschirm, der am Ende nirgendwohin führt (Tests prüfen nur die Engine) */
function levelScreen(): LevelScreen {
  const end: Screen = { enter: () => {}, tick: () => {} };
  return new LevelScreen(SEA, { gameOver: () => end, levelDone: () => end, unported: () => end });
}

/** Emulator-Bild, in dem die Copperliste des Levels zum ersten Mal läuft (Takt 0) */
const LEVEL_FIRST = 13112;
/** Hires-Texel der Emulatorzeile für Pixel 0 des Kernbilds (wie in title-pixels.test.ts) */
const DX = 154;
/** Bild 13112 und 13113 zeigen im Original Speicher ab Adresse 0 als Bitplanes (O-008); verglichen wird dort nur bis Zeile $40 */
const GARBAGE_UNTIL = LEVEL_FIRST + 2;

/** Joystick wie im Emulator: Aktion bei Bild F wirkt ab Bild F + 1 */
const JOY_RUN: [number, number][] = [
  [13125, JOY_RIGHT], [13150, JOY_DOWN], [13170, JOY_UP | JOY_LEFT], [13200, 0], [13210, JOY_LEFT], [13240, 0],
  [13250, JOY_DOWN | JOY_RIGHT], [13275, 0],
];

const EDGE_RUN: [number, number][] = [[13120, JOY_DOWN], [13180, JOY_DOWN | JOY_RIGHT], [13200, 0], [13210, JOY_UP | JOY_LEFT], [13290, 0]];


/**
 * Variablen (Adresse = a5 + Versatz) für den Vergleich mit den Ablaufspuren. Back_Phase nur, wenn Teil 1 der
 * Hauptschleife sicher fertig ist (engine.mainLoopRunning): Im Original kippt sie je nach Blitter-Last noch im selben
 * Bild (Phase 0, zwei Himmelsblöcke) oder erst im nächsten (Phase 1, vier Blöcke, und die ersten Schleifen).
 */
const V = SEA.vars;
const BACK_PHASE = "Back_Phase";
const VARS: [string, number][] = [
  ["Gen_25hz_Phase", V.genPhase], [BACK_PHASE, V.backPhase], ["Sorcerer_Shape", V.sorcererShape],
  ["Sorcerer_Delay", V.sorcererDelay], ["Text_Num", V.textNum], ["Begin_To_Start", V.beginToStart],
];
const JOY_VARS: [string, number][] = [
  ...VARS,
  ["Sorcerer_X", V.sorcererX], ["Sorcerer_Y", V.sorcererY], ["Axe_Up_X", V.axeUpX], ["Axe_Up_Y", V.axeUpY],
  ["Axe_Down_X", V.axeDownX], ["Axe_Down_Y", V.axeDownY], ["Axe_Delay", V.axeDelay], ["Axe_Move", V.axeMove],
  ["Old_Text_Num", V.oldTextNum], ["Text_Delay", V.textDelay], ["BTS_Delay", V.btsDelay],
];


const GO_VARS: [string, number][] = [
  ...VARS,
  ["Stop", V.stop], ["Stop2", V.stop2], ["Front_Phase", V.frontPhase], ["Front_Shift", V.frontShift],
  ["Front_Read_Ptr", V.frontReadPtr + 2], ["Front_Pal_Ptr", V.frontPalPtr + 2], ["Front_Pal_Count", V.frontPalCount],
  ["Cur_Front_Build", V.curFrontBuild + 2], ["Cur_Front_Show", V.curFrontShow + 2], ["Rest_Screen_Ptr", V.restScreenPtr + 2],
  ["Level_X", V.levelX], ["Sl_Waiting", V.slWaiting], ["Refresh_Pal", V.refreshPal], ["Back_Shift", V.backShift],
  ["Back_Config", V.backConfig], ["Safe_Dest_Off", V.safeDestOff],
  ["Die", V.die], ["Die_Mode", V.dieMode], ["Sorcerer_On", V.sorcererOn], ["Curent_Spell", V.curentSpell],
  ["Spell_Time", V.spellTime], ["Text_Delay", V.textDelay], ["Quit_Delay", V.quitDelay], ["Clean_Up", V.cleanUp],
  ["Rout_Mod_Pal_Counter", V.routModPalCounter], ["Rout_Pal_Ptr", V.routPalPtr + 2],
  ["Life", SHARED.life - SEA.d], ["Score", SHARED.score - SEA.d], ["Score_Lo", SHARED.score + 2 - SEA.d],
];

/**
 * Variablen, die Teil 1b der Hauptschleife schreibt (Spielmechanik nach den Objekten). Läuft ein Schritt im Original
 * erst im übernächsten Bild, aber vor der Zeile, ab der er dort sichtbar würde, legt ihn die Engine ans Ende des
 * Folgebilds (Lage 1); die Spur zeigt seine Werte dann ein Bild später. Verglichen wird deshalb mit dem Wert im selben
 * oder im nächsten Bild.
 */
const PART1B_VARS = new Set(["Level_X", "Sl_Waiting", "Refresh_Pal", "Die", "Die_Mode", "Score", "Score_Lo",
  "Text_Delay", "Text_Num", "Rout_Mod_Pal_Counter", "Rout_Pal_Ptr"]);
/**
 * Kurzlebige Merker zwischen zwei Schritten: Refresh_Pal setzt die Bahnverfolgung, gelöscht wird er am Anfang von
 * PALETTE CTRL ($2DF6), in der Engine erst mit der Kopie in die Copperliste ($2E82). Liegt ein Bildwechsel dazwischen
 * oder geschieht beides im Original im selben Bild, weicht die Spur um ein Bild ab; die Farben selbst prüft der
 * Bildvergleich.
 */
const TRANSIENT_VARS = new Set(["Refresh_Pal"]);
const FW_FIRE_STEP = "Fw_Fire_Step";
/** Variablen von Teil 1a (vorderes und hinteres Scrollen), siehe run() */
const PART1A_VARS = new Set(["Front_Phase", "Front_Shift", "Back_Shift", "Front_Read_Ptr", "Front_Pal_Ptr", "Front_Pal_Count", "Back_Config"]);

interface Run {
  wrongFrames: string[];
  exactFrames: number;
  varErrors: string[];
}

function run(
  capture: HiresCapture, trace: Trace, input: [number, number][], vars: [string, number][], last: number,
  vpos?: (e: LevelEngine) => number, timing?: LoopTiming,
): Run & { halted: number; exit: number } {
  const level = levelScreen();
  const game = new Game(loadAssets(), { lang: "en" }, level);
  const d = game.display;
  const frame = new InputFrame();
  const result = { wrongFrames: [] as string[], exactFrames: 0, varErrors: [] as string[], halted: -1, exit: -1 };
  for (let f = LEVEL_FIRST; f <= last; f++) {
    frame.buttons = buttonsAt(input, f);
    if (f === LEVEL_FIRST) {
      if (vpos) level.engine.vposSource = vpos;
      if (timing) level.engine.timing = timing;
    }
    game.tick(frame);
    if (level.engine.unported) {
      result.halted = f;
      break;
    }
    if (level.engine.result && result.exit < 0) result.exit = f;
    for (const [name, off] of vars) {
      if (name === BACK_PHASE && level.engine.mainLoopRunning) continue;
      const mine = level.engine.w(off);
      const original = trace.word(f, SEA.d + off);
      // Teil 1a eines Durchlaufs, der im Original erst am Bildende beginnt (Zeile 311): Scrollen erst im nächsten Bild.
      // Front_Shift zählen Copper-Interrupt und Teil 1a herunter, der Nachbau steht dann auf dem Zwischenwert.
      if (PART1A_VARS.has(name) && level.engine.mainLoopRunning && trace.rows.has(f + 1)) {
        const next = trace.word(f + 1, SEA.d + off);
        if (mine === next || (name === "Front_Shift" && mine <= original && mine >= next)) continue;
      }
      if (PART1B_VARS.has(name) && trace.rows.has(f + 1) && mine === trace.word(f + 1, SEA.d + off)) continue;
      // Treffer des Schusses im Kollisionstest (Fw_Fire_Step = $F0): wie PART1B_VARS, nur setzt der Copper-Interrupt
      // des Folgebilds schon den nächsten Schuss (Feuer gehalten: $14) oder lässt ihn aus ($F0)
      if (name === FW_FIRE_STEP && mine === 0xf0 && trace.rows.has(f + 1) && [0x14, 0xf0].includes(trace.word(f + 1, SEA.d + off))) continue;
      if (TRANSIENT_VARS.has(name) && (original === 0 || (trace.rows.has(f - 1) && mine === trace.word(f - 1, SEA.d + off)))) continue;
      if (mine !== original && result.varErrors.length < 30) result.varErrors.push(`Bild ${f}: ${name} $${mine.toString(16)} statt $${original.toString(16)}`);
    }
    if (!capture.load(f)) continue;
    const lastLine = f < GARBAGE_UNTIL ? 0x40 : capture.y + capture.height;
    let wrong = 0;
    for (let v = capture.y; v < lastLine; v++) {
      const row = v - 0x20;
      for (let tx = capture.x; tx < capture.x + capture.width; tx++) {
        const x = tx - DX;
        if (d.palette[row * 32 + d.pixels[row * d.width + x]!] !== capture.color(tx, v)) wrong++;
      }
    }
    if (wrong) result.wrongFrames.push(`${f}: ${wrong}`);
    else result.exactFrames++;
  }
  return result;
}

describe.skipIf(!hasAssets || !HiresCapture.exists("level1_enter") || !hasTrace("level1_enter"))("Level 1 ohne Eingabe gegen den Emulator", () => {
  it("zeigt jedes Bild pixelgenau und hält die Variablen wie das Original", () => {
    const r = run(new HiresCapture("level1_enter"), new Trace("level1_enter"), [], VARS, 13311);
    expect(r.varErrors).toEqual([]);
    expect(r.wrongFrames).toEqual([]);
    expect(r.exactFrames).toBe(13301 - LEVEL_FIRST + 1);
  }, 60_000);
});

describe.skipIf(!hasAssets || !HiresCapture.exists("level1_joy") || !hasTrace("level1_joy"))("Level 1 mit Joystick gegen den Emulator", () => {
  it("bewegt Eule und Äxte wie das Original", () => {
    const r = run(new HiresCapture("level1_joy"), new Trace("level1_joy"), JOY_RUN, JOY_VARS, 13299);
    expect(r.varErrors).toEqual([]);
    expect(r.wrongFrames).toEqual([]);
    expect(r.exactFrames).toBe(170);
  }, 60_000);
});

describe.skipIf(!hasAssets || !HiresCapture.exists("level1_edge") || !hasTrace("level1_edge"))("Level 1 mit der Eule am Rand gegen den Emulator", () => {
  it("zeigt die Eule auch am unteren Rand und in der Ecke wie das Original", () => {
    const r = run(new HiresCapture("level1_edge"), new Trace("level1_edge"), EDGE_RUN, JOY_VARS, 13299);
    expect(r.varErrors).toEqual([]);
    expect(r.wrongFrames).toEqual([]);
    expect(r.exactFrames).toBe(160);
  }, 60_000);
});

describe.skipIf(!hasAssets || !hasTrace("level1_fire"))("Feuer bei „PRESS FIRE TO START“", () => {
  it("beendet die Startanzeige im selben Bild wie das Original", () => {
    const trace = new Trace("level1_fire");
    const level = levelScreen();
    const game = new Game(loadAssets(), { lang: "en" }, level);
    const input = new InputFrame();
    const errors: string[] = [];
    let started = -1;
    for (let f = LEVEL_FIRST; started < 0 && f < 13200; f++) {
      input.buttons = f === 13161 || f === 13162 ? JOY_FIRE : 0;
      game.tick(input);
      if (level.engine.started) started = f;
      for (const [name, off] of [["Begin_To_Start", V.beginToStart], ["BTS_Delay", V.btsDelay], ["Stop", V.stop], ["Text_Delay", V.textDelay]] as const) {
        const mine = level.engine.w(off), original = trace.word(f, SEA.d + off);
        if (mine !== original) errors.push(`Bild ${f}: ${name} $${mine.toString(16)} statt $${original.toString(16)}`);
      }
    }
    expect(errors).toEqual([]);
    expect(started).toBe(13161);
  });
});

/** Letztes aufgenommene Bild des Laufs level1_go; Levelende (EXIT LEVEL) in Bild 14647 */
const GO_LAST = 14801;
const GO_EXIT = 14647;
/**
 * Bekannte Abweichung W-015: An den Bandgrenzen setzt die Copperliste Farbe 7 erst nach WAIT h=$42; durch den
 * Bitplane-Abruf verzögert wirkt das im Original etwa 50 Pixel nach dem linken Rand, im Bildmodell (eine Palette je
 * Zeile) für die ganze Zeile. Sichtbar nur, wo links an der Grenze Farbe 7 liegt und sich die Bänder darin unterscheiden.
 */
const GO_KNOWN = ["14538: 2", "14539: 2", "14540: 4", "14541: 6", "14542: 4", "14543: 4", "14544: 2", "14545: 2", "14548: 2", "14549: 2"];

describe.skipIf(!hasAssets || !HiresCapture.exists("level1_go") || !hasTrace("level1_go") || !hasProfile("level1_go"))("Level 1 nach dem Start gegen den Emulator", () => {
  it("zeigt Wellen, Tod, Schild, Routinen-Gegner und Spielende wie das Original (Zeitlage gemessen)", () => {
    const trace = new Trace("level1_go");
    const profile = new Profile("level1_go");
    const r = run(new HiresCapture("level1_go"), trace, FIRE_RUN, GO_VARS, GO_LAST, measuredVpos(profile, trace), measuredTiming(profile));
    expect(r).toEqual({ varErrors: [], wrongFrames: GO_KNOWN, halted: -1, exit: GO_EXIT, exactFrames: GO_LAST - LEVEL_FIRST + 1 - GO_KNOWN.length });
  }, 240_000);
});

describe.skipIf(!hasAssets || !HiresCapture.exists("level1_go") || !hasTrace("level1_go"))("Level 1 nach dem Start mit dem Zeitmodell", () => {
  it("zeigt dieselben Bilder mit berechneter Zeitlage", () => {
    const r = run(new HiresCapture("level1_go"), new Trace("level1_go"), FIRE_RUN, GO_VARS, GO_LAST);
    // dazu bekannt (Zeitmodell): in 1 von 767 Durchläufen liegt der Objektteil knapp auf der anderen Seite des
    // Copper-Interrupts (dort kam der Interrupt 10–13 Zeilen verspätet, weil der lange Blit des Zurücksetzens lief);
    // die Gegner stehen dann 2 Bilder lang 1 Pixel anders (O-010)
    const known = ["14442: 2818", "14443: 2794", ...GO_KNOWN];
    expect(r).toEqual({ varErrors: [], wrongFrames: known, halted: -1, exit: GO_EXIT, exactFrames: GO_LAST - LEVEL_FIRST + 1 - known.length });
  }, 240_000);
});

/**
 * Sichtbare Wirkung der Lage eines Schritts von Teil 1b: Objekte, Kollisionstest und Routinen wirken über den
 * Copper-Interrupt des Folgebilds (Front_Shift, Tod, Position der Eule), die Paletten je Farbband (Copperliste ab Zeile
 * $3F im Abstand von 32 Zeilen), Statuszeile und Text ab Zeile $2D. Lagen mit gleicher Wirkung gelten als gleich.
 */
function visible(step: number, p: Placement): string {
  const k = p.at >> 1;
  const before = (p.at & 1) === 0;
  if (step === STEP.palette) {
    if (!before) return `${k + 1}:0`;
    return `${k}:${Math.max(0, Math.min(6, Math.floor((p.line - 0x3f) / 32) + 1))}`;
  }
  if (step === STEP.status || step === STEP.text) return String(before && p.line < 0x2d ? k : k + 1);
  if (step === STEP.play || step === STEP.sounds) return "-";
  // Objekte, Kollisionstest, Routinen: vor welchem Copper-Interrupt
  return String(before ? k : k + 1);
}

/**
 * Höchstzahl sichtbar unterschiedlicher Lagen (von rund 6.100): Grenzfälle mit wenigen Zeilen Abstand zu Zeile $2D
 * (Statuszeile), einer Bandgrenze der Palette oder dem Copper-Interrupt. Ob sie wirklich sichtbar werden, hängt davon
 * ab, ob sich im Durchlauf etwas ändert; der Bildvergleich mit dem Zeitmodell zeigt die tatsächlichen Fälle.
 */
const STEPS_MAX_WRONG = 40;

/**
 * Lauf mit den gemessenen Werten (damit der Nachbau dem Original folgt), daneben das Zeitmodell: falsche
 * Short_Phase-Entscheidungen und sichtbar falsche Lagen der Schritte von Teil 1b.
 */
function compareTimingModel(name: string, joystick: [number, number][], last: number): { checks: number; wrong: string[]; wrongSteps: string[]; wrongPart2: string[] } {
  const trace = new Trace(name);
  const profile = new Profile(name);
  const measured = measuredVpos(profile, trace);
  const real = measuredTiming(profile);
  const model = new ModelTiming();
  const level = levelScreen();
  const game = new Game(loadAssets(), { lang: "en" }, level);
  const input = new InputFrame();
  let checks = 0;
  const wrong: string[] = [];
  const wrongSteps: string[] = [];
  const wrongPart2: string[] = [];
  let f = LEVEL_FIRST;
  level.engine.vposSource = (e) => {
    const old = e.w(V.oldVpos);
    const r = measured(e);
    const m = vposOf(shortPhaseTime(e));
    checks++;
    if ((m <= old) !== (r <= old)) wrong.push(`Bild ${f}: Modell Zeile ${m}, Original ${r}, vorher ${old}`);
    return r;
  };
  const pm: Placement = { at: 0, line: 0, h: 0 };
  level.engine.timing = {
    begin: (e) => {
      real.begin(e);
      model.begin(e);
    },
    place: (e, step, out) => {
      real.place(e, step, out);
      model.place(e, step, pm);
      if (visible(step, pm) !== visible(step, out)) {
        wrongSteps.push(`Bild ${f}: Schritt ${step} Modell ${pm.at}/${pm.line}, Original ${out.at}/${out.line}`);
      }
    },
    part2: (e, out) => {
      real.part2(e, out);
      model.part2(e, pm);
      if (pm.at !== out.at) wrongPart2.push(`Bild ${f}: Teil 2 Modell ${pm.at}/${pm.line}, Original ${out.at}/${out.line}`);
    },
    part2End: (e, out) => {
      real.part2End(e, out);
      model.part2End(e, pm);
    },
  };
  for (; f <= last; f++) {
    input.buttons = buttonsAt(joystick, f);
    game.tick(input);
  }
  return { checks, wrong, wrongSteps, wrongPart2 };
}

describe.skipIf(!hasAssets || !hasTrace("level1_go") || !hasProfile("level1_go"))("Zeitmodell der Hauptschleife", () => {
  it("trifft die Entscheidungen des Originals (Short_Phase, Lage von Teil 1b)", () => {
    const { checks, wrong, wrongSteps, wrongPart2 } = compareTimingModel("level1_go", FIRE_RUN, GO_EXIT);
    expect(wrongPart2, wrongPart2.join(" | ")).toEqual([]);
    expect(checks).toBeGreaterThan(760);
    // bekannter Fall: Bild 13286, Modell und Original in Zeile 25 bzw. 24/25 (32 Farbtakte an der Zeilengrenze)
    expect(wrong.length).toBeLessThanOrEqual(1);
    expect(wrongSteps.length, wrongSteps.join("\n")).toBeLessThanOrEqual(STEPS_MAX_WRONG);
  }, 240_000);
});

describe.skipIf(!hasAssets)("Level 1: Spielende mit Bedienhinweis (E-039)", () => {
  it("zeigt nach 1 s „Feuer drücken“; gehaltenes Feuer zählt nicht, ein neuer Druck überspringt die Wartezeit", () => {
    let left = -1;
    const end: Screen = { enter: () => {}, tick: () => {} };
    const level = new LevelScreen(SEA, { gameOver: () => { left = f; return end; }, levelDone: () => end, unported: () => end });
    const game = new Game(loadAssets(), { lang: "en" }, level);
    const frame = new InputFrame();
    let f = LEVEL_FIRST, exit = -1, promptAt = -1;
    for (; f < GO_EXIT + 400 && left < 0; f++) {
      // ohne Eingabe bis zum Spielende; ab 10 Bilder vorher Feuer gehalten, losgelassen nach 70, neu gedrückt nach 80
      const k = exit < 0 ? -1 : f - exit;
      frame.buttons = buttonsAt(FIRE_RUN, f) | ((f >= GO_EXIT - 10 && k < 70) || k === 80 ? JOY_FIRE : 0);
      game.tick(frame);
      if (exit < 0 && level.engine.result) exit = f;
      if (promptAt < 0 && game.display.overlay.visible) promptAt = f;
    }
    expect(exit).toBe(GO_EXIT);
    expect(promptAt - exit).toBe(49);
    expect(left - exit).toBe(130);
  }, 120_000);
});

/**
 * Letztes verglichene Bild (Ende der Aufnahme). Ab Bild 14566 wird die Hauptschleife im Original so voll, dass ein
 * Durchlauf von Bild 14568 Zeile 311 bis 14571 Zeile 38 dauert; danach beginnen die Durchläufe mitten im Bild. Die Engine
 * bildet solche Durchläufe über beliebig viele Bilder nach (Lage at = 2·k + Seite, E-037).
 */
const SHOOT_LAST = 14792;
/**
 * Statuszeile: Beginnt der Schritt in Zeile 39/40, kurz vor dem Statusfenster (Zeile $2D), überholt der Strahl das
 * Zeichnen der Punkte; die obersten 2–3 Zeilen einer Ziffer erscheinen im Original erst im nächsten Bild. Der Nachbau
 * führt den Schritt als Ganzes aus (Grenze des Bildmodells, W-017). Dazu W-015 wie im Lauf level1_go.
 */
const SHOOT_KNOWN = ["13295: 11", "13779: 11", "13787: 7", ...GO_KNOWN];
/**
 * Dazu mit gemessener Zeitlage in den überlangen Durchläufen: W-017 (Statusziffern, 14582/14586/14590), W-019 (Spinne
 * mit versetzten Bitplanes, 14598) und je 1 Pixel in 14578 und 14792.
 */
const SHOOT_MEASURED_KNOWN = [...SHOOT_KNOWN, "14578: 2", "14582: 19", "14586: 31", "14590: 19", "14598: 4116", "14792: 2"].sort();
/**
 * Letztes Bild der Vergleiche mit dem Zeitmodell: Ab 14567 sagt das Modell den überlangen Durchlauf eine Runde zu früh
 * voraus. Ursache: Mit der Spinne ganz im Bild (über 19.000 Blitter-Takte im Objekt-Schritt) und Regen ist der
 * Objekt-Schritt im Original rund 500 Arbeitseinheiten (≈ 10 Zeilen) kürzer als gerechnet; Teil 2 rutscht so hinter den
 * Copper-Interrupt. Short_Phase stimmt mit gemessener Zeitlage bis 14792 (Befund 08.10.2026, W-021).
 */
const SHOOT_MODEL_LAST = 14566;
const SHOOT_VARS: [string, number][] = [
  ...GO_VARS,
  ["Sorcerer_X", V.sorcererX], ["Sorcerer_Y", V.sorcererY], ["Fw_Fire_Step", V.fwFireStep], ["Fire_Count", V.fireCount],
  ["Bonus_Delay", V.bonusDelay],
];

describe.skipIf(!hasAssets || !HiresCapture.exists("level1_shoot") || !hasTrace("level1_shoot") || !hasProfile("level1_shoot"))("Level 1 mit Schießen und Ausweichen (Zeitlage gemessen)", () => {
  it("zeigt Abschüsse, Punkte, Explosionen und einen Tod wie das Original", () => {
    const trace = new Trace("level1_shoot");
    const profile = new Profile("level1_shoot");
    const r = run(new HiresCapture("level1_shoot"), trace, SHOOT_RUN, SHOOT_VARS, SHOOT_LAST, measuredVpos(profile, trace), measuredTiming(profile));
    expect({ ...r, wrongFrames: r.wrongFrames.sort() }).toEqual({ varErrors: [], wrongFrames: SHOOT_MEASURED_KNOWN, halted: -1, exit: -1, exactFrames: SHOOT_LAST - LEVEL_FIRST + 1 - SHOOT_MEASURED_KNOWN.length });
  }, 240_000);
});

describe.skipIf(!hasAssets || !HiresCapture.exists("level1_shoot") || !hasTrace("level1_shoot"))("Level 1 mit Schießen und Ausweichen mit dem Zeitmodell", () => {
  it("zeigt dieselben Bilder mit berechneter Zeitlage", () => {
    const r = run(new HiresCapture("level1_shoot"), new Trace("level1_shoot"), SHOOT_RUN, SHOOT_VARS, SHOOT_MODEL_LAST);
    // dazu bekannt (Zeitmodell, W-018): in 9 von 727 Durchläufen liegt der Objektteil auf der anderen Seite des
    // Copper-Interrupts; die Gegner stehen 2 Bilder lang 1 Pixel anders (O-010), der Spielzustand stimmt
    const known = ["13306: 2980", "13307: 2986", "13402: 3368", "13403: 3376", "13416: 1544", "13417: 1568", "13510: 1006",
      "13511: 996", "13690: 4350", "13691: 4364", "13702: 4004", "13703: 3958", "13750: 3776", "13751: 3782", "14182: 3846",
      "14183: 3828", "14316: 2782", "14317: 2782", ...SHOOT_KNOWN].sort();
    expect({ ...r, wrongFrames: r.wrongFrames.sort() }).toEqual({ varErrors: [], wrongFrames: known, halted: -1, exit: -1, exactFrames: SHOOT_MODEL_LAST - LEVEL_FIRST + 1 - known.length });
  }, 240_000);
});

describe.skipIf(!hasAssets || !hasTrace("level1_shoot") || !hasProfile("level1_shoot"))("Zeitmodell im Lauf mit Schießen", () => {
  it("trifft die Entscheidungen des Originals (Short_Phase, Lage von Teil 1b)", () => {
    const { checks, wrong, wrongSteps, wrongPart2 } = compareTimingModel("level1_shoot", SHOOT_RUN, SHOOT_MODEL_LAST);
    expect(checks).toBeGreaterThan(600);
    expect(wrong, wrong.join("\n")).toEqual([]);
    // mehr Last als in level1_go, deshalb mehr Grenzfälle (Paletten 2–12 Zeilen an Bandgrenzen, Statuszeile an Zeile
    // $2D, Objektteil W-018); sichtbar werden davon nur die im Bildvergleich bekannten
    expect(wrongSteps.length, wrongSteps.join("\n")).toBeLessThanOrEqual(60);
    // Teil 2 (Gegnerschüsse) auf der richtigen Seite des Copper-Interrupts; Grenzfälle kurz vor Zeile 255
    expect(wrongPart2.length, wrongPart2.join("\n")).toBeLessThanOrEqual(3);
  }, 240_000);
});
