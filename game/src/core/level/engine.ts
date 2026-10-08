// Level-Engine (E-032): Port des Hauptmoduls Agony_Parent_.s auf das Speichermodell. Der Spielcode arbeitet wie das
// Original auf den Originaladressen (Copperliste, Bitplanes, Sprite-Listen, Variablen ab a5); Grundlage ist die
// Disassembly des jeweiligen Level-Abbilds (Adressen in den Kommentaren: sea, Level 1), der Quelltext erklärt sie.
//
// Ablauf je Takt (= ein Bild):
//   1. Bild aufbauen (Copperliste ab COP1LC, Bitplanes, Sprites); dazwischen, jeweils an ihrer Rasterzeile, die
//      Abschnitte der Hauptschleife, die vor dem Copper-Interrupt dieses Bilds liegen
//   2. Copper-Interrupt am Ende der Copperliste (Eule, Schüsse, Äxte, Tod, Regen, 25-Hz-Takt)
//   3. die Abschnitte der Hauptschleife, die nach dem Interrupt liegen (hinter dem sichtbaren Bild)
// Abschnitte eines Durchlaufs: Teil 1a (Copperliste, Scrolling, SEARCH SHORT PHASE), die Schritte von Teil 1b
// (Objekte, Spielmechanik, Statuszeile …) und Teil 2 (Gegnerschüsse, Seitenwechsel vorn, „PRESS FIRE TO START“,
// Levelende). Der nächste Durchlauf beginnt am Ende von Teil 2, sobald der 25-Hz-Takt 2 erreicht.
// Zeitverhalten laut Zeitprofil des Emulators: Teil 1 beginnt direkt nach dem Copper-Interrupt; die Zeiger der
// Copperliste stehen vor dem nächsten Bild. Der Rest (Teil 1b) zieht sich je nach Last ins Folgebild und oft bis ins
// übernächste: Allein das Zurücksetzen des vorderen Playfields blittet 11.520 Wörter, dazu kommen die Gegner. Wo jeder
// Abschnitt liegt (Bild nach dem Start des Durchlaufs, vor/nach dessen Copper-Interrupt, Rasterzeile), entscheidet das
// Zeitmodell (timing.ts); davon hängt z. B. ab, in welchem Bild der Interrupt einen Tod bemerkt. Teil 2 wartet auf den
// nächsten Copper-Interrupt und dann auf Rasterzeile $40. Unter Last dauert ein Durchlauf länger als zwei Bilder; dann
// beginnt der nächste mitten im Bild (E-037). Nach dem Levelende (Exit) läuft wie im Original während des Ladens nur
// noch der Interrupt.
//
// Stand: Level 1 mit Scrollen, Angriffswellen, allen Gegner-Routinen, Kollisionen, Gegnerschüssen, Bonus, Tod der
// Eule, Schild, Spielende und Levelende. Die Engine hält an (`unported`), wenn ein Gegner mit noch nicht übertragener
// Routine startet; unerwartete Zustände in nicht übertragenen Teilen (Zaubermenü, Pause) lösen einen Fehler aus.

import type { Display } from "../display.ts";
import { JOY_DOWN, JOY_FIRE, JOY_LEFT, JOY_RIGHT, JOY_UP } from "../input.ts";
import { Blitter } from "../amiga/blitter.ts";
import { Ram } from "../amiga/ram.ts";
import { DMACON, FRAME_LINES, Video } from "../amiga/video.ts";
import type { MemoryBlock } from "../assets.ts";
import { backScroll } from "./back-scroll.ts";
import { alienFire } from "./alien-fire.ts";
import { frontScroll } from "./front-scroll.ts";
import { copperInterrupt } from "./interrupt.ts";
import type { LevelLayout, LevelVars } from "./layout.ts";
import { SHARED } from "./layout.ts";
import { objects, precompute } from "./objects.ts";
import { colisionTest, paletteCtrl, playability } from "./playability.ts";
import { routineManager } from "./routines.ts";
import { sounds } from "./sounds.ts";
import { drawText, drawTextChars, encodeStatusTexts, status } from "./status.ts";
import {
  decodeMusicTiming, IRQ_PARTS, LINE, type LoopTiming, type LoopWork, loopStart, ModelTiming, type Placement,
  shortPhaseTime, STEP, STEPS, vposOf, WORK_SLOTS,
} from "./timing.ts";

const Stage = {
  /** Schritte von Teil 1b (nach Teil 1a) */
  Part1b: 0,
  /** Teil 1 fertig, Teil 2 folgt (AF_Wait_Phase/AF_Wait_Synch $34E8–$3512) */
  Part2: 1,
  /** Teil 2 fertig; der nächste Durchlauf beginnt, sobald Gen_25hz_Phase ≥ 2 (Wait_Synch_Loop $AD0) */
  WaitSync: 2,
  /** Level verlassen (EXIT LEVEL): die Hauptschleife steht, nur der Copper-Interrupt läuft weiter */
  Exited: 3,
} as const;
type Stage = (typeof Stage)[keyof typeof Stage];

/** Ergebnis des Levels nach EXIT LEVEL ($3A78) */
export type LevelResult = "gameOver" | "levelDone";

/** Rasterzeilen der Statuszeile (Fenster ab $2D, ab $3F das Spielfeld) */
const STATUS_FIRST = 0x2d;
const STATUS_LAST = 0x3e;

/**
 * Zeile, bis zu der das Bild vor einem Schritt aufgebaut wird. Statuszeile und Statustext schreiben Zeichen für
 * Zeichen, langsamer als der Strahl die Zeilen abholt: Beginnen sie, während die Statuszeile angezeigt wird, zeigt das
 * Original in diesem Bild noch den alten Inhalt (Ablaufspur, Bilder 13887 und 14463). Vereinfacht wirkt ihr
 * Schreiben dann erst ab dem nächsten Bild.
 */
function renderLine(step: number, line: number): number {
  if ((step === STEP.status || step === STEP.text) && line >= STATUS_FIRST && line < STATUS_LAST) return STATUS_LAST;
  return line;
}

export class LevelEngine {
  readonly ram = new Ram();
  readonly blitter: Blitter;
  readonly video: Video;
  readonly L: LevelLayout;
  readonly V: LevelVars;
  /** JOY1DAT wie vom Joystick in Port 2 (Bits 9/1 = links/rechts, Zählbits für oben/unten) */
  joy1dat = 0;
  /** Feuerknopf gedrückt (CIA-A PRA Bit 7 = 0) */
  fire = false;
  /** Ereignis: Feuer bei „PRESS FIRE TO START“ (Begin_To_Start), das Spiel läuft */
  started = false;
  /** Grund, aus dem die Engine angehalten hat: Das Original würde hier nicht übertragenen Code ausführen */
  unported: string | null = null;
  /** Level verlassen (EXIT LEVEL): Spielende ohne Leben oder Level geschafft; danach läuft nur der Interrupt */
  result: LevelResult | null = null;
  /** Anzahl der bisherigen Takte (Bilder) seit start() */
  ticks = 0;
  /**
   * Rasterzeile bei SEARCH SHORT PHASE für den laufenden Takt. Standard: Zeitmodell (timing.ts); Tests können die
   * gemessenen Werte des Emulators einsetzen, um Spiellogik und Zeitmodell getrennt zu prüfen.
   */
  vposSource: ((e: LevelEngine) => number) | null = null;
  /**
   * Zeitquelle für Teil 1b und Teil 2 (Lage der Schritte relativ zum Copper-Interrupt, Rasterzeilen). Standard:
   * Zeitmodell; Tests können die gemessenen Werte des Emulators einsetzen (wie vposSource).
   */
  timing: LoopTiming = new ModelTiming();
  /** Laufzeit des Musiktreibers je Bild (Farbtakte) für das Zeitmodell, null = Mittelwert */
  readonly musicTiming: Uint16Array | null;
  /** Neuer Statustext, dessen Zeichen nach dem Löschen der Zeile folgen (Schritt text), 0 = keiner */
  pendingText = 0;
  /** Teile, die der letzte Copper-Interrupt ausgeführt hat (IRQ in timing.ts), für das Zeitmodell */
  readonly irqWork = new Int32Array(IRQ_PARTS);
  /** Arbeit des zuletzt ausgeführten Schritts von Teil 1b (WORK in timing.ts), für das Zeitmodell */
  readonly stepWork = new Int32Array(WORK_SLOTS);
  /** Arbeit des laufenden Durchlaufs für das Zeitmodell */
  readonly loopWork: LoopWork = {
    loopStart: 0, copperFull: false, frontStopped: true, frontCycles: 0, frontBlits: 0, backCycles: 0, backBlits: 0,
    backTiles: 0, startTick: 0,
  };
  /** Per Skript ergänzte Zeichen der Statusschrift ab Code 44 (Ä, Ö, Ü), 16 Byte je Zeichen */
  readonly extraGlyphs: Uint8Array;
  /** Übersetzte Texte der Statuszeile im Format von Text_Dat; null = Originaltexte aus dem Level-Abbild */
  statusTexts: Uint8Array[] | null = null;

  private stage: Stage = Stage.WaitSync;
  /** Takt, in dem der laufende Durchlauf begann: Bezug der Lagen (Placement.at) */
  private passTick = 0;
  /** nächster Schritt von Teil 1b */
  private nextStep: number = STEPS;
  /** Lage des nächsten Abschnitts (gültig, wenn placed); vor dem ersten Durchlauf: sofort */
  private readonly placement: Placement = { at: 0, line: 0, h: 0 };
  private placed = true;
  /** Pause2 beim Erreichen der Spielmechanik ($29D2): dann überspringt das Original sie bis zur Statuszeile */
  private playSkipped = false;

  /**
   * true nach einem Takt, an dessen Ende Teil 1 der Hauptschleife begonnen hat. Im Original ist Teil 1 dann noch nicht
   * fertig: Je nach Blitter-Last kippt Back_Phase noch im selben oder erst im nächsten Bild (Ablaufspur). Tests
   * vergleichen solche Variablen nur, wenn das hier false ist.
   */
  get mainLoopRunning(): boolean {
    return this.stage === Stage.Part1b && this.passTick === this.ticks;
  }

  constructor(layout: LevelLayout, memory: ReadonlyMap<string, MemoryBlock>, extraGlyphs: readonly number[] = []) {
    this.L = layout;
    this.extraGlyphs = Uint8Array.from(extraGlyphs);
    this.V = layout.vars;
    this.blitter = new Blitter(this.ram);
    this.video = new Video(this.ram);
    this.musicTiming = layout.musicTiming ? decodeMusicTiming(layout.musicTiming) : null;
    for (const key of layout.blocks) {
      const block = memory.get(key);
      if (!block) throw new Error(`Speicherblock „${key}“ fehlt: Asset-Pipeline neu ausführen`);
      this.ram.load(block);
    }
  }

  /**
   * Sprache der Statuszeile wechseln (E-021): `texts` = übersetzte Texte 1 … n, null = Original. Steht gerade ein
   * Text, wird er sofort neu gezeichnet.
   */
  setStatusTexts(texts: readonly string[] | null): void {
    this.statusTexts = texts ? encodeStatusTexts(texts) : null;
    const num = this.w(this.V.oldTextNum);
    if (this.w(this.V.textDelay) !== 0 && num >= 1 && num <= 13) drawText(this, num);
  }

  // ---- Zugriffe auf Variablen (Versatz zu a5) ----------------------------------------------------

  w(v: number): number {
    return this.ram.word(this.L.d + v);
  }

  sw(v: number): number {
    return this.ram.sword(this.L.d + v);
  }

  setW(v: number, value: number): void {
    this.ram.setWord(this.L.d + v, value & 0xffff);
  }

  l(v: number): number {
    return this.ram.long(this.L.d + v);
  }

  setL(v: number, value: number): void {
    this.ram.setLong(this.L.d + v, value >>> 0);
  }

  b(v: number): number {
    return this.ram.byte(this.L.d + v);
  }

  setB(v: number, value: number): void {
    this.ram.setByte(this.L.d + v, value & 0xff);
  }

  /** Zeiger in die Copperliste schreiben: High-Wort bei `at`, Low-Wort 4 Byte dahinter (zwei MOVE-Befehle) */
  copperPtr(at: number, value: number): void {
    this.ram.setWord(at + 4, value & 0xffff);
    this.ram.setWord(at, value >>> 16);
  }

  // ---- Start ---------------------------------------------------------------------------------

  /**
   * Zustand wie beim Sprung nach $600: gemeinsame Variablen aus dem Menü (Spielstart), dann die Initialisierung des
   * Levels bis „LET'S GO“. Danach zeigt das nächste Bild schon die Copperliste des Levels.
   */
  start(): void {
    const { ram, L, V } = this;
    // Menü beim Spielstart: Score 0, Life %111, $1BA–$1D5 gelöscht (Wiki dateiformate.md „Gemeinsame Variablen“)
    ram.setLong(SHARED.score, 0);
    ram.setWord(SHARED.life, 0b111);
    ram.clear(SHARED.axeUpOn, 0x1d6);
    ram.setLong(SHARED.menuMode, 0);

    // $600–$66E: Interrupts und DMA aus, Copper auf Dummy-Liste, Audio-Init (Ton folgt später)
    this.video.write(DMACON, 0x7fff);
    // $66E: DMACON $8640 (Blitter an), Pre_Comp ($674–$7C2): Masken und Routinenzeiger der Objekt-Teilbilder
    this.video.write(DMACON, 0x8640);
    precompute(this);

    // Restart ($7C6): Farben 16–31 = Sorcerer_Pal
    for (let i = 0; i < 16; i++) this.video.colors[16 + i] = ram.word(L.sorcererPal + 2 * i) & 0xfff;
    // Copperlisten-Wechsel: Phase 0 springt am Ende nach Phase 1 und umgekehrt
    this.copperPtr(L.clFlipJump0, L.clFlipPhase1);
    this.video.cop2lc = L.clFlipPhase0;
    this.copperPtr(L.clFlipJump1, L.clFlipPhase0);
    this.setL(V.curBackBuild, L.backScreen0);
    this.setL(V.curBackShow, L.backScreen1);
    this.setL(V.patPtr, L.backPattern + 4);

    // Muster 0: Animation direkt hinter Kopf (16 Wörter) und Farben (6 × 4 Wörter)
    const pat0 = L.backPattern + 16 * 2 + 6 * 4 * 2;
    this.setL(V.pat0, pat0);
    this.setL(V.pat0 + 4, pat0);
    this.setW(V.pat0 + 8, 1);
    // Muster 1: Farben in die Copperliste, Animation dahinter
    let a0 = L.backPattern + ram.word(L.backPattern + 2);
    a0 = this.setBackColors(a0 + 2);
    this.setL(V.pat0 + 14, a0);
    this.setL(V.pat0 + 18, a0);
    this.setW(V.pat0 + 22, 1);
    // Muster 2: nur die Animation
    const pat2 = L.backPattern + ram.word(L.backPattern + 4) + 6 * 4 * 2;
    this.setL(V.pat0 + 28, pat2);
    this.setL(V.pat0 + 32, pat2);
    this.setW(V.pat0 + 36, 1);

    // Statuszeile: Plane 1 = Status_Screen_Disp, Plane 2 = Status_Screen (76 × 19 Byte dahinter)
    this.copperPtr(L.statusPtr, L.statusScreenDisp);
    this.copperPtr(L.statusPtr + 8, L.statusScreenDisp + 76 * 19);

    this.setW(V.backShift, 31);
    this.setW(V.frontShift, 33);
    this.setW(V.slWaiting, ram.word(L.startList));
    this.setL(V.startListPtr, L.startList + 2);
    this.setW(V.levelX, -32);
    this.setW(V.backConfig, 0);
    this.setW(V.backPhase, 0);
    this.setW(V.frontPhase, 0);
    this.setW(V.frontPalCount, 0);
    this.setL(V.frontReadPtr, L.frontMap);
    this.setL(V.frontPalPtr, L.frontPal - 6 * 7 * 2);
    this.setL(V.curFrontShow, L.frontScreens);
    this.setL(V.curFrontBuild, L.frontScreens + 44 * 192 * 3);
    this.setL(V.restScreenPtr, L.frontScreens + 44 * 192 * 3 * 2);
    this.setW(V.fwFireStep, 20 * 12); // Fw_F_Off
    this.setW(V.sorcererX, 64 + 256);
    this.setW(V.sorcererY, 50 + 256);
    this.setW(V.axeUpX, 64 + 256);
    this.setW(V.axeUpY, 4 + 256);
    this.setW(V.axeDownX, 64 + 256);
    this.setW(V.axeDownY, 160 + 256);
    this.setB(V.curentSpell + 1, 0xff); // st Curent_Spell+1
    this.setW(V.statusDelay, 18);
    this.setB(V.rainOn, 0xff); // $A56: st.b Rain_On (Level 1)
    ram.clear(L.frontScreens, L.clearEnd);
    this.setW(V.textNum, 13); // „PRESS FIRE TO START“
    this.setW(V.textDelay, 0xffff);
    this.setW(V.beginToStart, 1); // 0 = gestartet, 1 = Text an, 2 = Text aus
    this.setB(V.stop + 1, 0xff);

    // LET'S GO ($A82): Copperliste des Levels, Interrupts, DMA $87E0
    this.video.cop1lc = L.mainCl;
    ram.setLong(SHARED.curentCl, L.mainCl);
    this.video.write(DMACON, 0x87e0);
    // Wait_Synch_Loop: der erste Durchlauf beginnt, sobald der 25-Hz-Takt 2 erreicht
    this.stage = Stage.WaitSync;
    this.passTick = this.ticks;
    this.placement.at = 0;
    this.placed = true;
  }

  /** Farben eines Musters (6 Bänder × Füllwort + 3 Farben) in die Copperliste; liefert den Zeiger dahinter */
  setBackColors(a0: number): number {
    const { ram, L } = this;
    for (let band = 0; band < 6; band++) {
      if (band > 0) a0 += 2;
      for (let k = 0; k < 3; k++) {
        const color = ram.word(a0);
        a0 += 2;
        // Farben 10/11, 12/13, 14/15 paarweise gleich (dritte Ebene, Wiki grafik.md); Band 0 steht im Kopf der
        // Copperliste, die Bänder 1–5 in beiden Flacker-Hälften
        const f0 = band === 0 ? L.backColor0 : L.backColor[band - 1]![0];
        ram.setWord(f0 + 8 * k, color);
        ram.setWord(f0 + 8 * k + 4, color);
        if (band > 0) {
          const f1 = L.backColor[band - 1]![1];
          ram.setWord(f1 + 8 * k, color);
          ram.setWord(f1 + 8 * k + 4, color);
        }
      }
    }
    return a0;
  }

  // ---- Takt ----------------------------------------------------------------------------------

  /** Joystick und Feuer für diesen Takt (Bits aus input.ts) */
  setInput(buttons: number): void {
    // JOY1DAT: rechts = Bit 1, links = Bit 9; unten = Bit 1 XOR Bit 0, oben = Bit 9 XOR Bit 8
    const right = (buttons & JOY_RIGHT) !== 0;
    const left = (buttons & JOY_LEFT) !== 0;
    const down = (buttons & JOY_DOWN) !== 0;
    const up = (buttons & JOY_UP) !== 0;
    const x1 = right ? 1 : 0;
    const x0 = (down ? 1 : 0) ^ x1;
    const y1 = left ? 1 : 0;
    const y0 = (up ? 1 : 0) ^ y1;
    this.joy1dat = (y1 << 9) | (y0 << 8) | (x1 << 1) | x0;
    this.fire = (buttons & JOY_FIRE) !== 0;
  }

  /** Hält die Engine an der ersten nicht übertragenen Stelle an (siehe `unported`) */
  halt(reason: string): void {
    this.unported ??= reason;
  }

  tick(display: Display): void {
    this.ticks++;
    const video = this.video;
    video.beginFrame(display);
    // Während des Bildaufbaus: was vor dem Copper-Interrupt liegt, je an seiner Rasterzeile; was es schreibt, zeigen
    // erst die folgenden Zeilen
    if (!this.unported) this.runMainLoop(display, 0);
    video.renderLines(display, FRAME_LINES);
    if (this.unported) return;
    // Nach dem sichtbaren Bild: Copper-Interrupt, dann was danach liegt (oft der Beginn des nächsten Durchlaufs)
    if (video.copperIrqLine >= 0) copperInterrupt(this);
    this.runMainLoop(display, 1);
  }

  // ---- Hauptschleife -------------------------------------------------------------------------

  /**
   * Abschnitte der Hauptschleife ausführen, deren Lage erreicht ist: `side` 0 = vor dem Copper-Interrupt dieses Takts
   * (das Bild wird vorher bis zur Rasterzeile des Abschnitts aufgebaut), 1 = danach. Lage `at` = 2 · (Bilder seit dem
   * Start des Durchlaufs) + Seite.
   */
  private runMainLoop(display: Display, side: number): void {
    const p = this.placement;
    const V = this.V;
    for (;;) {
      if (this.unported || this.stage === Stage.Exited) return;
      const pos = 2 * (this.ticks - this.passTick) + side;
      if (!this.placed) {
        if (this.stage === Stage.Part1b) this.timing.place(this, this.nextStep, p);
        else if (this.stage === Stage.Part2) this.timing.part2(this, p);
        else this.timing.part2End(this, p);
        this.placed = true;
      }
      if (p.at > pos) return;
      // Teil 2 frühestens nach einem Copper-Interrupt (AF_Wait_Phase), der nächste Durchlauf erst bei
      // Gen_25hz_Phase ≥ 2 (Wait_Synch_Loop); die Lage aus der Zeitquelle hält das normalerweise schon ein
      if (this.stage === Stage.Part2 && this.w(V.genPhase) < 1) return;
      if (this.stage === Stage.WaitSync && this.w(V.genPhase) < 2) return;
      if (side === 0 && p.at === pos) {
        const line = this.stage === Stage.Part1b ? renderLine(this.nextStep, p.line) : p.line;
        this.video.renderLines(display, line + 1);
      }
      this.placed = false;
      if (this.stage === Stage.Part1b) {
        this.runStep(this.nextStep++);
        if (this.nextStep === STEPS) this.stage = Stage.Part2;
      } else if (this.stage === Stage.Part2) {
        this.mainLoopPart2();
        this.stage = this.result ? Stage.Exited : Stage.WaitSync;
      } else {
        // Wait_Synch_Loop erfüllt: neuer Durchlauf, hier im Bild (vor dem Interrupt, ab Zeile p.line) oder dahinter
        this.setW(V.genPhase, 0);
        this.passTick = this.ticks;
        this.mainLoopPart1a(side, p.at === pos ? p.line * LINE + p.h : -1);
        this.stage = Stage.Part1b;
        this.nextStep = 0;
      }
    }
  }

  /**
   * Main_Loop ab $AD8, Anfang: Copperliste, vorderes und hinteres Playfield, SEARCH SHORT PHASE. `side` wie bei
   * runMainLoop; `endTime` = Ende von Teil 2 in diesem Bild (Farbtakte ab Bildbeginn), −1 = früher.
   */
  private mainLoopPart1a(side: number, endTime: number): void {
    if (this.w(this.V.pause2) === 0) this.updateCopperList();
    const w = this.loopWork;
    const bl = this.blitter;
    w.copperFull = this.w(this.V.pause2) === 0 && this.w(this.V.backPhase) === 0;
    w.startTick = this.ticks;
    // Schleifenstart für das Zeitmodell: am Ende von Teil 2, frühestens nach dem Copper-Interrupt dieses Bilds
    w.loopStart = side === 0 ? Math.max(0, endTime) : Math.max(loopStart(this), endTime);
    let cycles = bl.cycles, blits = bl.blits;
    frontScroll(this);
    w.frontStopped = this.w(this.V.stop2) !== 0;
    w.frontCycles = bl.cycles - cycles;
    w.frontBlits = bl.blits - blits;
    cycles = bl.cycles;
    blits = bl.blits;
    w.backTiles = 0;
    backScroll(this);
    w.backCycles = bl.cycles - cycles;
    w.backBlits = bl.blits - blits;
    this.searchShortPhase();
    // Teil 1b folgt; die Zeitquelle legt jeden Abschnitt fest, wenn er an der Reihe ist
    this.timing.begin(this);
  }

  /** SEARCH SHORT PHASE ($147C): Short_Phase = $FF, wenn der Strahl hier nicht später steht als im vorigen Durchlauf */
  private searchShortPhase(): void {
    const V = this.V;
    const vpos = this.vposSource ? this.vposSource(this) : vposOf(shortPhaseTime(this));
    const old = this.w(V.oldVpos);
    this.setW(V.oldVpos, vpos);
    this.setW(V.shortPhase, vpos <= old ? 0xff : 0);
  }

  /** Ein Schritt von Teil 1b (STEP in timing.ts) */
  private runStep(step: number): void {
    this.stepWork.fill(0);
    switch (step) {
      case STEP.objects:
        objects(this);
        break;
      case STEP.play:
        // Pause2: weiter bei der Statuszeile ($29D6)
        this.playSkipped = this.w(this.V.pause2) !== 0;
        if (!this.playSkipped) playability(this);
        break;
      case STEP.palette:
        if (!this.playSkipped) paletteCtrl(this);
        break;
      case STEP.colision:
        if (!this.playSkipped) colisionTest(this);
        break;
      case STEP.routines:
        if (!this.playSkipped) routineManager(this);
        break;
      case STEP.status:
        status(this);
        break;
      case STEP.text:
        if (this.pendingText) drawTextChars(this, this.pendingText);
        this.pendingText = 0;
        break;
      case STEP.sounds:
        sounds(this);
        break;
    }
  }

  /** Teil 2 ab $3514 (nach AF_Wait_Synch): Gegnerschüsse, Seitenwechsel vorn, Begin_To_Start, Aufräumen */
  private mainLoopPart2(): void {
    const { V, L, ram } = this;
    alienFire(this);
    // FRONT SCROLL CONTROL ($3916)
    if (this.w(V.pause2) === 0) {
      // nach 16 Durchläufen ist die neue Spalte fertig: alle Bilder um 4 Byte (32 Pixel) weiter
      if (this.w(V.stop2) === 0 && this.w(V.frontPhase) === 16) {
        this.setW(V.frontPhase, 0);
        this.setL(V.curFrontBuild, this.l(V.curFrontBuild) + 4);
        this.setL(V.curFrontShow, this.l(V.curFrontShow) + 4);
        this.setL(V.restScreenPtr, this.l(V.restScreenPtr) + 4);
      }
      const build = this.l(V.curFrontBuild);
      this.setL(V.curFrontBuild, this.l(V.curFrontShow));
      this.setL(V.curFrontShow, build);
    }
    // BEGIN TO START ($394E)
    if (this.w(V.beginToStart) !== 0) {
      if (this.fire) {
        this.setW(V.stop, 0);
        this.setW(V.textDelay, 2);
        this.setW(V.beginToStart, 0);
        this.setB(V.oldTextNum + 1, 0xff);
        this.started = true;
      } else {
        this.setW(V.btsDelay, this.w(V.btsDelay) + 1);
        if (this.w(V.btsDelay) === 10) {
          this.setW(V.btsDelay, 0);
          if (this.w(V.beginToStart) !== 1) {
            this.setW(V.beginToStart, 1);
            ram.clear(L.statusScreen, L.statusScreen + 343 * 4); // 76 × 18 / 4 + 1 Langwörter
          } else {
            this.setW(V.beginToStart, 2);
            this.setW(V.textNum, 13);
            this.setW(V.textDelay, 0xffff);
            this.setB(V.oldTextNum + 1, 0xff);
          }
        }
      }
    }
    if (this.w(V.cleanUp) !== 0) this.cleanUp();
    // KEY UP CTRL ($3A4E)
    if (this.w(V.keyUpFlag) !== 0) {
      this.setW(V.keyUpFlag, 0);
      this.setB(V.key + 1, 0xff);
    }
    // QUIT DELAY ($3A5E): je Durchlauf 1 herunter, bei 1 ist das Level zu Ende
    if (this.w(V.quitDelay) !== 0) {
      this.setW(V.quitDelay, this.w(V.quitDelay) - 1);
      if (this.w(V.quitDelay) === 1) this.exitLevel();
    }
  }

  /**
   * CLEAN UP ($39C2), solange Clean_Up gesetzt ist (Spielende, Abbruch): Gegnerschüsse aus, alle Bahnen frei, die
   * ersten 32 Langwörter der Rout_Struct auf −1 (nur die Routinen 0–4, Eigenheit O-013) und jeder noch nicht
   * explodierende Gegner beginnt zu explodieren.
   */
  private cleanUp(): void {
    const { V, L, ram } = this;
    this.setB(V.afOff + 1, 0xff);
    for (let i = 0; i < 16; i++) ram.setLong(L.trackTable + 4 * i, (ram.long(L.trackTable + 4 * i) | 0x80000000) >>> 0);
    for (let i = 0; i < 32; i++) ram.setLong(L.routStruct + 4 * i, 0xffffffff);
    let a0 = L.awoStruct;
    for (;;) {
      const num = ram.word(a0);
      a0 += 2;
      if (num === 0 || num === 0xffff) {
        a0 += 16 * 12 + 2;
        if (a0 >= L.awoStructEnd) return;
        continue;
      }
      const off = ram.sword(a0);
      a0 += 2;
      this.setL(V.curentBankPtr, a0);
      for (let i = 0, awo = a0 + off; i < num; i++, awo += 12) {
        if ((ram.byte(awo + 8) & 0xf) === 0) ram.setByte(awo + 8, 1);
      }
      a0 = this.l(V.curentBankPtr) + 16 * 12;
      if (a0 === L.awoStructEnd) return;
    }
  }

  /**
   * EXIT LEVEL ($3A78): Zauber aus, Stop, Die gelöscht. Ohne Leben lädt das Original danach das Menü (`igt`), sonst
   * das Ladebild des nächsten Levels; währenddessen steht das Bild, nur der Copper-Interrupt läuft weiter (Regen,
   * „GAME OVER“ bzw. die stehende Eule).
   */
  private exitLevel(): void {
    const { V } = this;
    this.setB(V.curentSpell + 1, 0xff);
    this.setB(V.stop + 1, 0xff);
    this.setW(V.die, 0);
    // Quelle: Agony_Parent_.s, Label Exit (tst Life / beq Game_Over; Level 1 lädt FILE_2_4 = load_forest)
    this.result = this.ram.word(SHARED.life) !== 0 ? "levelDone" : "gameOver";
  }

  /** UPDATE COPPER LIST SCREEN INFO ($AE4) */
  private updateCopperList(): void {
    const { V, L, ram } = this;
    if (this.w(V.backPhase) === 0) {
      this.setW(V.backOldOff, this.w(V.backOldOff) ^ 240);
      const shift = this.w(V.backShift);
      const vs = ram.word(L.videoShift);
      ram.setWord(L.videoShift, (vs & 0x000f) | ((shift & 15) << 4));
      let show = this.l(V.curBackBuild);
      this.setL(V.curBackBuild, this.l(V.curBackShow));
      this.setL(V.curBackShow, show);
      if ((shift & 16) === 0) show += 2;
      // Bitplane 4 und 6 (6 = 4 + $500, siehe dateiformate.md), dann Bitplane 2 (Himmel) in 6 Bändern à 32 Zeilen
      this.copperPtr(L.backPtr, show);
      this.copperPtr(L.backPtr + 8, show + 0x500);
      let sky = show + 0x500 + 2 * 40 * 192 - 0x500;
      this.copperPtr(L.skyPtr0, sky);
      for (let band = 0; band < 5; band++) {
        sky += 40 * 32;
        this.copperPtr(L.skyPtr[band]![0], sky);
        this.copperPtr(L.skyPtr[band]![1], sky);
      }
    }
    // vorderes Playfield (Bitplanes 1, 3, 5)
    let front = this.l(V.curFrontShow);
    if ((this.w(V.frontShift) & 16) === 0) front += 2;
    this.copperPtr(L.frontPtr, front);
    this.copperPtr(L.frontPtr + 8, front + 192 * 44);
    this.copperPtr(L.frontPtr + 16, front + 2 * 192 * 44);
  }
}
