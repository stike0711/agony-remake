// Zeitmodell der Hauptschleife (E-034, E-035, E-036). Das Modell rechnet in Farbtakten (227 je Zeile, 313 Zeilen je
// Bild) ab dem Bild, in dem die Schleife startet, und beantwortet zwei Fragen:
//   1. Wo steht der Rasterstrahl bei SEARCH SHORT PHASE ($147C)? Short_Phase vergleicht die Zeile mit der des vorigen
//      Durchlaufs; davon hängen Startliste, Palettenwechsel und Gegnerschüsse ab. Kette: Ende des Copper-Interrupts
//      (Dauer nach seinen Teilen) → Copperlisten-Update → vorderes Scrollen → hinteres Scrollen.
//   2. Wo liegen die Schritte von Teil 1b und Teil 2 (ModelTiming)? Vor oder nach dem Copper-Interrupt des Folgebilds,
//      in welcher Rasterzeile; davon hängt ab, in welchem Bild z. B. ein Tod, eine Palette oder die Statuszeile wirkt.
// Blitter-Arbeit verbraucht die Buszyklen, die der Bildaufbau übrig lässt (Video.busUsed); Prozessorarbeit in Teil 1b
// nur die freien geraden Zyklen (Video.busEven: Copper, Lowres-Bitplanes 5/6). Unterwegs unterbrechen der
// Copper-Interrupt und der Vertical-Blank-Interrupt mit dem Musiktreiber (gemessene Laufzeit je Bild, E-035).
// Konstanten aus dem Zeitprofil level1_go angepasst (tools/analysis/fit_loop_timing.py, fit_part1b_timing.py).

import type { LevelEngine } from "./engine.ts";

export const LINE = 227;
const LINES = 313;
const FRAME = LINES * LINE;
/** Zeile, in der die Copperliste den Copper-Interrupt auslöst, solange sie im laufenden Bild noch nicht dort war */
const IRQ_LINE = 255;
/**
 * Beginn des Copper-Interrupts ab der Zeile, in der die Copperliste ihn auslöst (Zeile 255): gemessen Zeile 256,
 * Farbtakt 129–136
 */
const IRQ_RESPONSE = LINE + 132;
/**
 * Dauer des Copper-Interrupts: Grundteil und je ausgeführtem Teil (IRQ, Farbtakte). Angepasst an 2.523 Interrupts der
 * Läufe level1_go und level1_shoot (tools/analysis/fit_irq_timing.py, mittlerer Fehler 83 Takte, ohne die rund 8 %
 * verspätet beginnenden, O-010); der Schild ersetzt den Regen und ist billiger als die Eule allein. Eule und Äxte laufen
 * immer gemeinsam (Anteil bei der Eule); ein neuer Schuss kostet mit Sound_Start 145 Takte. Für Gegnerschüsse unterwegs
 * gibt es noch keine Messung (in beiden Läufen schießt kein Gegner; geschätzt).
 */
const IRQ_BASE = 1139;
const IRQ_COST = [0, 1066, 219, 0, 0, -494, 9, 80, 610, 30, 1410, 145];
/** Interrupt, der nach dem 25-Hz-Takt sofort endet (Hauptschleife hinkt hinterher; geschätzt) */
const IRQ_SKIP = 150;
/** Vom Ende des Interrupts bis zum Schleifenstart $AD8 (gemessen 96–103) */
const IRQ_TO_LOOP = 100;
// Teil 1a bis SEARCH SHORT PHASE (fit_loop_timing.py, 767 Durchläufe): mittlerer Fehler 0,43 Zeilen, 2 Entscheidungen
// anders als im Original
/** UPDATE COPPER LIST: alle Zeiger (Back_Phase 0) bzw. nur die vorderen */
const COPPER_FULL = 476;
const COPPER_FRONT = 119;
/** FRONT SCROLL: angehalten, ohne Blits, mit Blits (CPU-Anteil plus je Blit; dazu die Blitter-Takte) */
const FRONT_STOPPED = 74;
const FRONT_IDLE = 187;
const FRONT_BLITS = 378;
const FRONT_PER_BLIT = 32;
/** BACK SCROLL: Prüfschleife über 30 Kacheln und Himmel, je neu gezeichneter Kachel und je Blit */
const BACK_BASE = 2227;
const BACK_PER_TILE = 54;
const BACK_PER_BLIT = 22;
/** Vertical-Blank-Interrupt ohne den Musiktreiber */
const VBL = 198;
/** Laufzeit des Musiktreibers, falls die Tabelle fehlt */
const MUSIC_DEFAULT = 1116;

/** Arbeit eines Durchlaufs, festgehalten von Teil 1a der Engine */
export interface LoopWork {
  /** Schleifenstart ($AD8) in Farbtakten ab Beginn des Bilds: Ende des Copper-Interrupts (irqEnd) + IRQ_TO_LOOP */
  loopStart: number;
  copperFull: boolean;
  frontStopped: boolean;
  frontCycles: number;
  frontBlits: number;
  backCycles: number;
  backBlits: number;
  /** neu gezeichnete Kacheln des hinteren Playfields (CPU-Arbeit je Kachel) */
  backTiles: number;
  /** Takt, in dem die Schleife begann (Index der Musiktabelle für das folgende Bild) */
  startTick: number;
}

/**
 * Teile des Copper-Interrupts, die er im laufenden Bild ausgeführt hat (LevelEngine.irqWork, Anzahl bzw. 1): Grundlage
 * seiner Dauer im Zeitmodell. sprites = alles nach dem 25-Hz-Takt, sorcerer = Joystick und Sprite-Listen der Eule,
 * fire = Schuss unterwegs, dieParts = bewegte Teile der Explosion, alienFireShots = Gegnerschüsse unterwegs,
 * fireStart = neuer Schuss (mit Sound_Start).
 */
export const IRQ = {
  sprites: 0, sorcerer: 1, fire: 2, axes: 3, spells: 4, shield: 5, dieStart: 6, dieParts: 7, alienFire: 8,
  alienFireShots: 9, rain: 10, fireStart: 11,
} as const;
export const IRQ_PARTS = 12;

/**
 * Arbeit der Schritte von Teil 1b (LevelEngine.stepWork, je Schritt neu gezählt): Gegner und Teilbilder beim
 * Zeichnen (davon mit Clipping), aktive Bahnen und bewegte Gegner, Einträge der Startliste, kopierte Paletten und ihre
 * Überlagerungen, geprüfte Gegner und Trefferrechtecke im Kollisionstest, aufgerufene Routinen, gezeichnete Zeichen
 * und gelöschte Statuszeilen. Blitter-Takte und Blits zählt der Blitter selbst.
 */
export const WORK = {
  aliens: 0, subs: 1, clipped: 2, tracks: 3, trackAliens: 4, startEntry: 5, palCopy: 6, palOverlays: 7,
  colAliens: 8, colRects: 9, routines: 10, chars: 11, clears: 12, colCompares: 13, colHits: 14, routineStart: 15,
} as const;
export const WORK_SLOTS = 16;

/** Tabelle der Laufzeiten des Musiktreibers (Vorlauf, dann periodisch), siehe data/timing/ */
export interface MusicTiming {
  lead: number;
  period: number;
  hex: string;
}

/** Hex-Tabelle (drei Ziffern je Bild) in Farbtakte umwandeln */
export function decodeMusicTiming(t: MusicTiming): Uint16Array {
  const out = new Uint16Array(t.hex.length / 3);
  for (let i = 0; i < out.length; i++) out[i] = parseInt(t.hex.slice(3 * i, 3 * i + 3), 16);
  return out;
}

/** Laufzeit des Musiktreibers im Vertical Blank vor Takt `tick` (Takt 1 = erstes Bild des Levels) */
function music(e: LevelEngine, tick: number): number {
  const table = e.musicTiming;
  const lead = e.L.musicTiming?.lead ?? 0;
  if (!table || table.length === 0) return MUSIC_DEFAULT;
  const i = tick < table.length ? tick : lead + ((tick - lead) % (table.length - lead));
  return table[i]!;
}

/** `units` freie Buszyklen ab Zeitpunkt `t` verbrauchen (Bus-Belegung des zuletzt aufgebauten Bilds) */
function advance(bus: Uint16Array, t: number, units: number): number {
  while (units > 0) {
    const line = ((t / LINE) | 0) % LINES;
    const free = (LINE - bus[line]!) / LINE;
    const rest = LINE - (t % LINE);
    if (units <= rest * free) return t + units / free;
    units -= rest * free;
    t += rest;
  }
  return t;
}

/** Dauer des zuletzt ausgeführten Copper-Interrupts nach seinen Teilen (Farbtakte ab seinem Beginn) */
function irqDuration(e: LevelEngine): number {
  const w = e.irqWork;
  let d = IRQ_SKIP;
  if (w[IRQ.sprites]) {
    d = IRQ_BASE;
    for (let i = 0; i < IRQ_PARTS; i++) d += IRQ_COST[i]! * w[i]!;
  }
  return d;
}

/** Zeile des Copper-Interrupts: im laufenden Bild, sonst die übliche */
function irqLineOf(e: LevelEngine): number {
  return e.video.copperIrqLine >= 0 ? e.video.copperIrqLine : IRQ_LINE;
}

/** Ende des Copper-Interrupts dieses Bilds in Farbtakten ab Bildbeginn (nach dem Interrupt aufrufen) */
export function irqEnd(e: LevelEngine): number {
  return irqLineOf(e) * LINE + IRQ_RESPONSE + irqDuration(e);
}

/** Schleifenstart nach dem Copper-Interrupt dieses Bilds (für LoopWork.loopStart) */
export function loopStart(e: LevelEngine): number {
  return irqEnd(e) + IRQ_TO_LOOP;
}

/**
 * Zeitpunkt von SEARCH SHORT PHASE in Farbtakten ab Beginn des Bilds, in dem die Schleife startet. Beginnt der
 * Durchlauf vor dem Copper-Interrupt seines Bilds (Durchlauf davor länger als zwei Bilder), unterbricht ihn dieser.
 */
export function shortPhaseTime(e: LevelEngine): number {
  const w = e.loopWork;
  const bus = e.video.busUsed;
  const irq0 = irqLineOf(e) * LINE + IRQ_RESPONSE;
  let t = w.loopStart + (w.copperFull ? COPPER_FULL : COPPER_FRONT);
  if (w.frontStopped) t += FRONT_STOPPED;
  else if (w.frontBlits === 0) t += FRONT_IDLE;
  else t = advance(bus, t, FRONT_BLITS + w.frontCycles + FRONT_PER_BLIT * w.frontBlits);
  t = advance(bus, t, BACK_BASE + w.backCycles + BACK_PER_TILE * w.backTiles + BACK_PER_BLIT * w.backBlits);
  if (w.loopStart < irq0 && t >= irq0) t += irqDuration(e);
  if (t >= FRAME) t = advance(bus, t, VBL + music(e, w.startTick));
  return t;
}

/** Von SEARCH SHORT PHASE bis zum Beginn der Objekte ($149C), gemessen 50–81 Farbtakte (Mittel 55) */
const CHECK_TO_OBJECTS = 55;
/**
 * Beginnt der Objektteil im Folgebild später als Zeile 32, Farbtakt 105, endet das Zurücksetzen des Arbeitsbilds
 * (11.520 Blitter-Wörter) erst nach dem Copper-Interrupt, und ALIEN BANK CTRL liest das schon verringerte Front_Shift
 * (O-010). Gemessen über 767 Durchläufe: spätester Beginn ohne Verspätung Zeile 31/224, frühester mit Verspätung
 * 32/174 (einmal schon 31/111). Genauer als die gerechnete Dauer des Zurücksetzens (±1 Zeile).
 */
const LATE_OBJECTS = 32 * LINE + 105;

/**
 * Schritte von Teil 1b in Programmreihenfolge, mit dem Haltepunkt, der ihre Lage bestimmt: Objekte (ALIEN BANK CTRL
 * $153C, danach liest es Front_Shift), Startliste und Bahnen $29D2, Paletten (Kopie in die Copperliste $2E82),
 * Kollisionstest $302C, Objekt-Routinen $316E, Statuszeile $3194, Zeichen eines neuen Statustexts nach dem Löschen
 * $342E, Sounds $348C
 */
export const STEP = { objects: 0, play: 1, palette: 2, colision: 3, routines: 4, status: 5, text: 6, sounds: 7 } as const;
export const STEPS = 8;

/**
 * Lage eines Abschnitts der Hauptschleife: `at` = 2 · k + Seite, k = Bilder seit dem Bild, in dem der Durchlauf
 * begann, Seite 0 = vor dessen Copper-Interrupt, 1 = danach (hinter dem sichtbaren Bild). Üblich: Durchlauf beginnt
 * nach dem Interrupt (at 1), Teil 1b liegt bei at 2–4, Teil 2 bei at 4. `line`/`h` = Rasterzeile und Farbtakt. Vor dem
 * Interrupt baut die Engine das Bild bis einschließlich dieser Zeile auf und führt den Abschnitt dann aus.
 */
export interface Placement {
  at: number;
  line: number;
  h: number;
}

/** Zeitquelle für Teil 1b und Teil 2 eines Durchlaufs: das Zeitmodell oder (Tests) die Messung im Emulator */
export interface LoopTiming {
  /** Neuer Durchlauf: Teil 1a ist gelaufen */
  begin(e: LevelEngine): void;
  /** Lage von Schritt `step`; alle vorigen Schritte sind ausgeführt */
  place(e: LevelEngine, step: number, out: Placement): void;
  /** Lage von Teil 2 (Aufbau der Sprite-Liste der Gegnerschüsse); Teil 1 ist fertig */
  part2(e: LevelEngine, out: Placement): void;
  /**
   * Ende von Teil 2 (Seitenwechsel, Aufräumen): Ist Gen_25hz_Phase dort schon 2, beginnt hier der nächste Durchlauf,
   * sonst nach dem nächsten Copper-Interrupt
   */
  part2End(e: LevelEngine, out: Placement): void;
}

/** Letzte Zeile des sichtbaren Bilds (Fenster bis $100): danach Ausgeführtes wirkt erst im nächsten Bild */
const LAST_VISIBLE = 0xff;

// Teil 1b und Teil 2 (fit_part1b_timing.py, 767 Durchläufe; mittlerer Fehler je Schritt in Farbtakten in Klammern).
// Fällt ein Interrupt in einen Schritt, kostet er über seine Dauer hinaus Zusatzarbeit (IRQ_EXTRA, VBL_EXTRA): z. B.
// kann der Prozessor währenddessen keinen Blit starten.
/** Zurücksetzen des Arbeitsbilds bis ALIEN BANK CTRL ($149C → $153C, 11.520 Blitter-Wörter): freie Buszyklen (±104) */
const RESTORE = 22857;
const RESTORE_IRQ_EXTRA = 162;
const RESTORE_VBL_EXTRA = 143;
/**
 * Objekte bis zur Spielmechanik ($153C → $29D2), gegen alle freien Buszyklen: Blitter-Takte der Gegner (ohne das
 * Zurücksetzen: 9 Blits, 23.040 Takte) und Prozessoranteil je Gegner, Teilbild, Clipping und Blit (±268)
 */
const RESTORE_BLIT_CYCLES = 23040;
const RESTORE_BLITS = 9;
const OBJ_BASE = 818;
const OBJ_PER_BLIT_CYCLE = 0.974;
const OBJ_PER_ALIEN = 131.9;
const OBJ_PER_SUB = 105.2;
const OBJ_PER_CLIP = 129.2;
const OBJ_PER_BLIT = 82.1;
const OBJ_IRQ_EXTRA = 488;
const OBJ_VBL_EXTRA = 635;
/**
 * Startliste und Bahnen bis zur Kopie der Palette ($29D2 → $2E82, ohne Kopie bis $302C), freie gerade Zyklen: je
 * Bahn, bewegtem Gegner, Welle aus der Startliste und gestarteter Routine; dazu PALETTE CTRL vor der Kopie (±125)
 */
const PLAY_BASE = 420;
const PLAY_PER_TRACK = 178;
const PLAY_PER_ALIEN = 178;
const PLAY_PER_WAVE = 948;
const PLAY_PER_ROUTINE_START = 287;
const PAL_COPY = 618;
const PAL_PER_OVERLAY = 636;
const PLAY_IRQ_EXTRA = 183;
const PLAY_VBL_EXTRA = 65;
/** COPY IN COPPER LIST ($2E82 → $302C) (±16) */
const PAL_TO_COPPER = 657;
const PAL_IRQ_EXTRA = 188;
/** Kollisionstest ($302C → $316E): je Gegner, Trefferrechteck, Vergleich mit einem aktiven Rechteck, Treffer (±184) */
const COL_BASE = 1423;
const COL_PER_ALIEN = -6;
const COL_PER_RECT = 238;
const COL_PER_COMPARE = 17;
const COL_PER_HIT = 217;
const COL_IRQ_EXTRA = 88;
const COL_VBL_EXTRA = 139;
/** Objekt-Routinen ($316E → $3194) (±101) */
const ROUT_BASE = 871;
const ROUT_PER_ROUTINE = 138;
const ROUT_IRQ_EXTRA = 178;
const ROUT_VBL_EXTRA = 147;
/** Statuszeile ($3194 → $342E bzw. $348C): je Zeichen, je gelöschter Zeile (±29) */
const STATUS_BASE = 88;
const STATUS_PER_CHAR = 285;
const STATUS_PER_CLEAR = 5080;
/** Sounds bis zum Ende von Teil 1 (geschätzt) */
const SOUNDS = 150;
/** Teil 2 beginnt frühestens in Zeile $40 (Warteschleife auf VPOSR, gemessen Farbtakt 40–140) */
const PART2_LINE = 0x40;
const PART2_WAKE = 90;
/** Teil 2 bis zum Aufbau der Sprite-Liste der Gegnerschüsse ($3514 → $3800): je Gegner in den Bänken (±730) */
const AF_BASE = 6592;
const AF_PER_ALIEN = 27;
/** Von der Sprite-Liste der Gegnerschüsse bis zum Schleifenstart ($3800 → $AD8, ohne Warten) (geschätzt) */
const PART2_REST = 650;
/** Copper-Interrupts und Vertical Blanks, die das Modell je Durchlauf kennt (Bilder ab dem Startbild) */
const EVENT_FRAMES = 5;
/** Gerade Buszyklen je Zeile */
const EVEN = 113;

/**
 * Zeitmodell für Teil 1b und Teil 2: eine mitlaufende Uhr ab SEARCH SHORT PHASE. Jeder Schritt rückt sie um seine
 * gezählte Arbeit vor (LevelEngine.stepWork, Blitter-Takte); dabei springt sie über Vertical Blank und Copper-Interrupt.
 * Die Palettenarbeit sagt sie voraus, weil das Original sie vor der Kopie in die Copperliste erledigt.
 */
export class ModelTiming implements LoopTiming {
  /** Uhr: Farbtakte ab Beginn des Bilds, in dem die Schleife startete (Werkzeuge lesen sie zum Abgleich) */
  t = 0;
  /**
   * Unterbrechungen (Beginn, Dauer, Art 0 = Copper-Interrupt, 1 = Vertical Blank): je Bild ab dem Startbild der
   * Interrupt (geschätzt mit den Teilen des letzten) und der Vertical Blank mit dem Musiktreiber
   */
  private readonly events = new Float64Array(EVENT_FRAMES * 2 * 3);
  private eventCount = 0;
  /** Zeile des Copper-Interrupts (Farbtakte ab Bildbeginn bis zu seinem Beginn) und seine geschätzte Dauer */
  private irqAt = 0;
  private irqDur = 0;
  private cycles = 0;
  private blits = 0;
  /** Gegner im Kollisionstest (Last von Teil 2) */
  private aliens = 0;

  begin(e: LevelEngine): void {
    const w = e.loopWork;
    this.irqAt = irqLineOf(e) * LINE + IRQ_RESPONSE;
    this.irqDur = irqDuration(e);
    const ev = this.events;
    let n = 0;
    for (let k = 0; k < EVENT_FRAMES; k++) {
      const irq = k * FRAME + this.irqAt;
      if (irq > w.loopStart) {
        ev[n++] = irq;
        ev[n++] = this.irqDur;
        ev[n++] = 0;
      }
      if (k > 0) {
        ev[n++] = k * FRAME;
        ev[n++] = VBL + music(e, w.startTick + k - 1);
        ev[n++] = 1;
      }
    }
    this.eventCount = n;
    this.cycles = e.blitter.cycles;
    this.blits = e.blitter.blits;
    const obj = shortPhaseTime(e) + CHECK_TO_OBJECTS;
    let t = this.advance(e, obj, RESTORE, false, RESTORE_IRQ_EXTRA, RESTORE_VBL_EXTRA);
    // Seite des nächsten Interrupts nach der gemessenen Schwelle (Beginn des Objektteils in dessen Bild), die Uhr
    // passend dazu
    let k = Math.floor(obj / FRAME);
    if (obj >= this.irqTime(k)) k++;
    const irq = this.irqTime(k);
    const late = obj - k * FRAME >= LATE_OBJECTS;
    if (!late && t >= irq) t = irq - 1;
    else if (late && t < irq) t = irq + this.irqDur + 1;
    this.t = t;
  }

  place(e: LevelEngine, step: number, out: Placement): void {
    const w = e.stepWork;
    const { V } = e;
    switch (step) {
      case STEP.play: {
        const bl = e.blitter;
        const units = OBJ_BASE + OBJ_PER_BLIT_CYCLE * (bl.cycles - this.cycles - RESTORE_BLIT_CYCLES) +
          OBJ_PER_BLIT * (bl.blits - this.blits - RESTORE_BLITS) + OBJ_PER_ALIEN * w[WORK.aliens]! +
          OBJ_PER_SUB * w[WORK.subs]! + OBJ_PER_CLIP * w[WORK.clipped]!;
        this.t = this.advance(e, this.t, units, false, OBJ_IRQ_EXTRA, OBJ_VBL_EXTRA);
        break;
      }
      case STEP.palette: {
        let units = PLAY_BASE + PLAY_PER_TRACK * w[WORK.tracks]! + PLAY_PER_ALIEN * w[WORK.trackAliens]! +
          PLAY_PER_WAVE * w[WORK.startEntry]! + PLAY_PER_ROUTINE_START * w[WORK.routineStart]!;
        // PALETTE CTRL kopiert nur in kurzen Durchläufen nach Refresh_Pal; die Überlagerungen liegen vor der Kopie
        if (e.w(V.curentSpell) !== 2 && e.w(V.beginToStart) === 0 && e.w(V.shortPhase) !== 0 && e.w(V.refreshPal) !== 0) {
          units += PAL_COPY + PAL_PER_OVERLAY * overlays(e);
        }
        this.t = this.advance(e, this.t, units, true, PLAY_IRQ_EXTRA, PLAY_VBL_EXTRA);
        break;
      }
      case STEP.colision:
        if (w[WORK.palCopy]) this.t = this.advance(e, this.t, PAL_TO_COPPER, true, PAL_IRQ_EXTRA);
        break;
      case STEP.routines:
        this.aliens = w[WORK.colAliens]!;
        this.t = this.advance(e, this.t, COL_BASE + COL_PER_ALIEN * w[WORK.colAliens]! + COL_PER_RECT * w[WORK.colRects]! +
          COL_PER_COMPARE * w[WORK.colCompares]! + COL_PER_HIT * w[WORK.colHits]!, true, COL_IRQ_EXTRA, COL_VBL_EXTRA);
        break;
      case STEP.status:
        this.t = this.advance(e, this.t, ROUT_BASE + ROUT_PER_ROUTINE * w[WORK.routines]!, true, ROUT_IRQ_EXTRA, ROUT_VBL_EXTRA);
        break;
      case STEP.text:
        this.t = this.advance(e, this.t, STATUS_BASE + STATUS_PER_CHAR * w[WORK.chars]! + STATUS_PER_CLEAR * w[WORK.clears]!, true);
        break;
      case STEP.sounds:
        this.t = this.advance(e, this.t, STATUS_PER_CHAR * w[WORK.chars]!, true);
        break;
    }
    this.placeAt(this.t, out);
  }

  /**
   * Teil 2 ($34DE–$3514): wartet auf den ersten Copper-Interrupt seit dem Schleifenstart (AF_Wait_Phase), dann, falls
   * noch kein zweiter kam, auf Rasterzeile $40–$100 (AF_Wait_Synch); danach bis zur Sprite-Liste der Gegnerschüsse
   */
  part2(e: LevelEngine, out: Placement): void {
    let t = this.advance(e, this.t, SOUNDS, true);
    const start = e.loopWork.loopStart;
    const first = start < this.irqAt ? 0 : 1;
    const end1 = this.irqTime(first) + this.irqDur;
    if (t < end1) t = end1;
    if (t < this.irqTime(first + 1) + this.irqDur) {
      const k = Math.floor(t / FRAME);
      const line = ((t - k * FRAME) / LINE) | 0;
      if (line < PART2_LINE) t = k * FRAME + PART2_LINE * LINE + PART2_WAKE;
      else if (line > 0x100) t = (k + 1) * FRAME + PART2_LINE * LINE + PART2_WAKE;
    }
    this.t = this.advance(e, t, AF_BASE + AF_PER_ALIEN * this.aliens, true);
    this.placeAt(this.t, out);
  }

  part2End(e: LevelEngine, out: Placement): void {
    this.t = this.advance(e, this.t, PART2_REST, true);
    this.placeAt(this.t, out);
  }

  /** Beginn des Copper-Interrupts im Bild k ab dem Startbild */
  private irqTime(k: number): number {
    return k * FRAME + this.irqAt;
  }

  /** Lage aus der Uhrzeit (Placement) */
  private placeAt(t: number, out: Placement): void {
    const k = Math.floor(t / FRAME);
    const side = t >= this.irqTime(k) ? 1 : 0;
    const rest = t - k * FRAME;
    out.at = 2 * k + side;
    out.line = side ? Math.min(LINES - 1, (rest / LINE) | 0) : Math.min(LAST_VISIBLE, (rest / LINE) | 0);
    out.h = (rest % LINE) | 0;
  }

  /**
   * `units` Arbeit ab `t` (Farbtakte bei voller Geschwindigkeit): Prozessor (`even`) mit den freien geraden Zyklen,
   * sonst (Blitter) mit allen freien; eine Unterbrechung, die unterwegs beginnt, verlängert die Zeit um ihre Dauer und
   * die Arbeit um den Zuschlag des Schritts
   */
  private advance(e: LevelEngine, t: number, units: number, even: boolean, irqExtra = 0, vblExtra = 0): number {
    const bus = even ? e.video.busEven : e.video.busUsed;
    const per = even ? EVEN : LINE;
    const ev = this.events;
    while (units > 0) {
      let next = Infinity;
      let dur = 0;
      let extra = 0;
      for (let i = 0; i < this.eventCount; i += 3) {
        if (ev[i]! >= t && ev[i]! < next) {
          next = ev[i]!;
          dur = ev[i + 1]!;
          extra = ev[i + 2] === 0 ? irqExtra : vblExtra;
        }
      }
      const limit = Math.min((((t / LINE) | 0) + 1) * LINE, next);
      const free = (per - bus[((t / LINE) | 0) % LINES]!) / per;
      const room = free > 0 ? (limit - t) * free : 0;
      if (free > 0 && units <= room) return t + units / free;
      units -= room;
      if (limit === next) {
        t = next + dur + 1;
        units += extra;
      } else {
        t = limit;
      }
    }
    return t;
  }
}

/** Überlagerungen in PALETTE CTRL: je laufende Welle und die Palette einer Objekt-Routine */
function overlays(e: LevelEngine): number {
  let n = (e.l(e.V.routPalPtr) & 0x80000000) === 0 ? 1 : 0;
  for (let i = 0; i < 16; i++) if ((e.ram.long(e.L.trackTable + 4 * i) & 0x80000000) === 0) n++;
  return n;
}

/** Old_Vpos hält nur die unteren 8 Bit der Zeile (move.l VPOSR, lsr.w #8) */
export function vposOf(t: number): number {
  return ((t / LINE) | 0) % LINES & 0xff;
}
