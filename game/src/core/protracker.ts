// ProTracker-Abspieler (Menü- und Lademusik) als wörtliche Portierung der Routine im Original.
// Quelle: igt $1DDA (mt_init) bis $2AE8, byte-gleich auch in load_sea ab $61F32 (nur verschoben). Es ist der
// ProTracker-2.x-Abspieler mit einer Änderung von Art & Magic: Lautstärken gehen nicht direkt an Paula, sondern über
// $30D8 in einen Zwischenspeicher je Kanal ($30DA–$30E0); geschrieben wird „Lautstärke − 64 + Gesamtlautstärke“
// ($30E2, mindestens 0). Damit blenden Menü und Ladebild die Musik aus.
//
// Eigenheiten des Originals bleiben erhalten (Phase 1), u. a.: 9xx wird bei neuen Noten zweimal angewandt;
// Tremolo-Rampe prüft die Vibrato-Position; SetTonePorta rechnet mit 37 statt 36 Perioden je Finetune-Zeile;
// mt_LowMask ist anfangs 0 (das erste 1xx/2xx nach dem Laden gleitet nicht). Lesezugriffe hinter die Periodentabelle
// (nur mit Finetune ≠ 0 bzw. Perioden unter 113 möglich) liefern hier 0 statt des folgenden Speichers; die Module
// des Spiels nutzen nur Finetune 0. E0x (Filter) wird ignoriert, der Mixer bildet den Tiefpass nicht nach.
// Die Warteschleifen um das Einschalten der DMA ($2268, $29B0) entfallen; die Reihenfolge der Zugriffe bleibt.

import type { ProtrackerModule } from "./assets.ts";
import { AUD_LC, AUD_LEN, AUD_PER, AUD_VOL, DMAF_SETCLR, type Paula, REG_DMACON } from "./paula.ts";

/** Kanal-Struktur des Abspielers (44 Byte je Kanal ab $2F9A); Byte-Felder 0–255, Wort-Felder 0–65535. */
class Voice {
  /** n_note: Periode der Note und obere Hälfte der Samplenummer (Bits 12–15) */
  note = 0;
  /** n_cmd (Befehl in Bits 0–3, untere Hälfte der Samplenummer in 4–7) und n_cmdlo (Parameter) */
  cmd = 0;
  cmdlo = 0;
  start = 0;
  length = 0;
  loopstart = 0;
  replen = 0;
  period = 0;
  finetune = 0;
  volume = 0;
  readonly dmabit: number;
  toneportdirec = 0;
  toneportspeed = 0;
  wantedperiod = 0;
  vibratocmd = 0;
  vibratopos = 0;
  tremolocmd = 0;
  tremolopos = 0;
  wavecontrol = 0;
  glissfunk = 0;
  sampleoffset = 0;
  pattpos = 0;
  loopcount = 0;
  funkoffset = 0;
  wavestart = 0;
  reallength = 0;

  constructor(dmabit: number) {
    this.dmabit = dmabit;
  }
}

/** Tabellen aus igt (Asset-Pipeline: pt.periods, pt.sine, pt.funk). */
export interface ProtrackerTables {
  /** 16 Finetunes × 36 Perioden */
  readonly periods: readonly number[];
  readonly sine: readonly number[];
  readonly funk: readonly number[];
}

export class ProtrackerPlayer {
  readonly voices = [new Voice(1), new Voice(2), new Voice(4), new Voice(8)];
  /** $30DA–$30E0: zuletzt gesetzte Lautstärke je Kanal (vor der Gesamtlautstärke) */
  readonly stored = new Int32Array(4);
  /** $30E2: Gesamtlautstärke 0–64; Menü und Ladebild ziehen beim Ausblenden je Bild 2 ab */
  master = 64;
  speed = 6;
  counter = 0;
  songPos = 0;
  patternPos = 0;

  private readonly paula: Paula;
  private readonly periods: readonly number[];
  private readonly sine: readonly number[];
  private readonly funk: readonly number[];
  private mod: Uint8Array = new Uint8Array(1084);
  private address = 0;
  private readonly sampleStarts = new Int32Array(31);
  private pbreakPos = 0;
  private posJumpFlag = 0;
  private pbreakFlag = 0;
  private lowMask = 0;
  private pattDelTime = 0;
  private pattDelTime2 = 0;
  private dmaconTemp = 0;
  /** $30D8: von den Effekten gesetzte Lautstärke dieses Kanals, −1 = keine */
  private volOut = -1;

  constructor(paula: Paula, tables: ProtrackerTables) {
    this.paula = paula;
    this.periods = tables.periods;
    this.sine = tables.sine;
    this.funk = tables.funk;
  }

  /**
   * mt_init. Setzt außerdem alle Variablen auf den Stand der Datei zurück – im Original wird igt bzw. load_sea jedes
   * Mal frisch geladen. Die Gesamtlautstärke setzt der Aufrufer (igt $69A, load_sea $6156A).
   */
  init(module: ProtrackerModule): void {
    this.mod = module.data;
    this.address = module.address;
    for (let i = 0; i < 4; i++) this.voices[i] = new Voice(1 << i);
    this.stored.fill(0);
    this.pbreakPos = this.posJumpFlag = this.pbreakFlag = this.lowMask = 0;
    this.pattDelTime = this.pattDelTime2 = this.dmaconTemp = 0;

    // Höchste Patternnummer suchen – wie im Original: jede neue Höchstzahl kostet einen Schleifendurchlauf extra
    let d0 = 0x7f, d2 = 0, i = 0x3b8;
    outer: for (;;) {
      d0--;
      for (;;) {
        const d1 = (this.mod[i++]! << 24) >> 24; // cmp.b: vorzeichenbehaftet
        if (d1 > d2) {
          d2 = d1;
          continue outer;
        }
        if (--d0 < 0) break outer;
      }
    }
    let sample = this.address + 0x43c + (((d2 + 1) & 0xff) << 10);
    for (let s = 0; s < 31; s++) {
      for (let k = 0; k < 4; k++) this.paula.poke(sample + k, 0); // clr.l (a2): O-001
      this.sampleStarts[s] = sample;
      sample += this.word(20 + 30 * s + 22) * 2;
    }
    this.speed = 6;
    this.counter = 0;
    this.songPos = 0;
    this.patternPos = 0;
    for (let ch = 0; ch < 4; ch++) this.paula.write(AUD_VOL, ch, 0);
    this.paula.write(REG_DMACON, 0, 0x000f);
  }

  /** mt_music: einmal je Bild (Bild-Interrupt). */
  music(): void {
    this.counter = (this.counter + 1) & 0xff;
    if (this.counter < this.speed) {
      this.noNewAllChannels();
      this.noNewPosYet();
      return;
    }
    this.counter = 0;
    if (this.pattDelTime2 !== 0) {
      this.noNewAllChannels();
      this.dskip();
      return;
    }
    this.getNewNote();
  }

  // ---- Ablauf je Zeile ($1EA0–$2374) ----

  private noNewAllChannels(): void {
    for (let ch = 0; ch < 4; ch++) {
      this.volOut = -1;
      this.checkEfx(ch);
      this.setVolume(ch);
    }
  }

  /** Lautstärke an Paula: Zwischenspeicher − 64 + Gesamtlautstärke, mindestens 0 (Quelle: $1EB6–$1EE0). */
  private setVolume(ch: number): void {
    if (this.volOut >= 0) this.stored[ch] = this.volOut;
    const v = this.stored[ch]! - 0x40 + this.master;
    this.paula.write(AUD_VOL, ch, v < 0 ? 0 : v);
  }

  private getNewNote(): void {
    const pattern = this.mod[0x3b8 + this.songPos]!;
    let pos = 0x43c + ((pattern << 10) & 0xffff0000) + (((pattern << 10) + this.patternPos) & 0xffff);
    this.dmaconTemp = 0;
    for (let ch = 0; ch < 4; ch++) {
      this.volOut = -1;
      this.playVoice(ch, pos);
      pos += 4;
      this.setVolume(ch);
    }
    // mt_SetDMA ($2268)
    this.paula.write(REG_DMACON, 0, DMAF_SETCLR | this.dmaconTemp);
    for (let ch = 3; ch >= 0; ch--) {
      const v = this.voices[ch]!;
      this.paula.write(AUD_LC, ch, v.loopstart);
      this.paula.write(AUD_LEN, ch, v.replen);
    }
    this.dskip();
  }

  private dskip(): void {
    this.patternPos = (this.patternPos + 16) & 0xffff;
    if (this.pattDelTime !== 0) {
      this.pattDelTime2 = this.pattDelTime;
      this.pattDelTime = 0;
    }
    if (this.pattDelTime2 !== 0) {
      this.pattDelTime2 = (this.pattDelTime2 - 1) & 0xff;
      if (this.pattDelTime2 !== 0) this.patternPos = (this.patternPos - 16) & 0xffff;
    }
    if (this.pbreakFlag !== 0) {
      this.pbreakFlag = 0;
      this.patternPos = this.pbreakPos << 4;
      this.pbreakPos = 0;
    }
    if (this.patternPos >= 0x400) this.nextPosition();
    this.noNewPosYet();
  }

  private nextPosition(): void {
    this.patternPos = this.pbreakPos << 4;
    this.pbreakPos = 0;
    this.posJumpFlag = 0;
    this.songPos = (this.songPos + 1) & 0x7f;
    if (this.songPos >= this.mod[0x3b6]!) this.songPos = 0;
  }

  private noNewPosYet(): void {
    while (this.posJumpFlag !== 0) this.nextPosition();
  }

  // ---- Neue Note ($20F0–$2264) ----

  private playVoice(ch: number, pos: number): void {
    const v = this.voices[ch]!;
    if (v.note === 0 && v.cmd === 0 && v.cmdlo === 0) this.perNop(ch);
    const b0 = this.mod[pos] ?? 0;
    v.note = (b0 << 8) | (this.mod[pos + 1] ?? 0);
    v.cmd = this.mod[pos + 2] ?? 0;
    v.cmdlo = this.mod[pos + 3] ?? 0;
    const sample = ((v.cmd & 0xf0) >> 4) | (b0 & 0xf0);
    if (sample !== 0) {
      const info = 20 + 30 * (sample - 1) + 22;
      v.start = this.sampleStarts[sample - 1] ?? 0;
      v.length = this.word(info);
      v.reallength = v.length;
      v.finetune = this.mod[info + 2] ?? 0;
      v.volume = this.mod[info + 3] ?? 0;
      const repeat = this.word(info + 4);
      if (repeat !== 0) {
        v.loopstart = v.start + ((repeat << 1) & 0xffff);
        v.wavestart = v.loopstart;
        v.length = (repeat + this.word(info + 6)) & 0xffff;
        v.replen = this.word(info + 6);
      } else {
        v.loopstart = v.start;
        v.wavestart = v.start;
        v.replen = this.word(info + 6);
      }
      this.volOut = v.volume;
    }
    if ((v.note & 0xfff) === 0) {
      this.checkMoreEfx(ch);
      return;
    }
    const cmdWord = (v.cmd << 8) | v.cmdlo;
    if ((cmdWord & 0xff0) === 0xe50) {
      v.finetune = v.cmdlo & 0xf;
    } else {
      const c = v.cmd & 0xf;
      if (c === 3 || c === 5) {
        this.setTonePorta(ch);
        this.checkMoreEfx(ch);
        return;
      }
      if (c === 9) this.checkMoreEfx(ch);
    }
    this.setPeriod(ch);
  }

  private setPeriod(ch: number): void {
    const v = this.voices[ch]!;
    const note = v.note & 0xfff;
    let i = 0;
    for (let n = 36; n >= 0; n--, i++) if (note >= this.period(i)) break;
    v.period = this.period(v.finetune * 36 + i);
    if ((((v.cmd << 8) | v.cmdlo) & 0xff0) === 0xed0) {
      this.checkMoreEfx(ch);
      return;
    }
    this.paula.write(REG_DMACON, 0, v.dmabit);
    if ((v.wavecontrol & 0x04) === 0) v.vibratopos = 0;
    if ((v.wavecontrol & 0x40) === 0) v.tremolopos = 0;
    this.paula.write(AUD_LC, ch, v.start);
    this.paula.write(AUD_LEN, ch, v.length);
    this.paula.write(AUD_PER, ch, v.period);
    this.dmaconTemp |= v.dmabit;
    this.checkMoreEfx(ch);
  }

  // ---- Effekte ohne neue Note ($2376–$23E4) ----

  private checkEfx(ch: number): void {
    const v = this.voices[ch]!;
    this.updateFunk(ch);
    if ((((v.cmd << 8) | v.cmdlo) & 0xfff) === 0) {
      this.perNop(ch);
      return;
    }
    switch (v.cmd & 0xf) {
      case 0x0: this.arpeggio(ch); return;
      case 0x1: this.portaUp(ch); return;
      case 0x2: this.portaDown(ch); return;
      case 0x3: this.tonePortamento(ch); return;
      case 0x4: this.vibrato(ch); return;
      case 0x5: this.tonePortNoChange(ch); this.volumeSlide(ch); return;
      case 0x6: this.vibrato2(ch); this.volumeSlide(ch); return;
      case 0xe: this.eCommands(ch); return;
    }
    this.paula.write(AUD_PER, ch, v.period);
    if ((v.cmd & 0xf) === 0x7) this.tremolo(ch);
    else if ((v.cmd & 0xf) === 0xa) this.volumeSlide(ch);
  }

  private perNop(ch: number): void {
    this.paula.write(AUD_PER, ch, this.voices[ch]!.period);
  }

  private arpeggio(ch: number): void {
    const v = this.voices[ch]!;
    const r = this.counter % 3;
    if (r === 0) {
      this.paula.write(AUD_PER, ch, v.period);
      return;
    }
    const step = r === 2 ? v.cmdlo & 0xf : v.cmdlo >> 4;
    const base = v.finetune * 36;
    for (let k = 0; k < 37; k++) {
      if (v.period >= this.period(base + k)) {
        this.paula.write(AUD_PER, ch, this.period(base + k + step));
        return;
      }
    }
  }

  private portaUp(ch: number): void {
    const v = this.voices[ch]!;
    const d0 = v.cmdlo & this.lowMask;
    this.lowMask = 0xff;
    v.period = (v.period - d0) & 0xffff;
    if ((v.period & 0xfff) < 0x71) v.period = (v.period & 0xf000) | 0x71;
    this.paula.write(AUD_PER, ch, v.period & 0xfff);
  }

  private portaDown(ch: number): void {
    const v = this.voices[ch]!;
    const d0 = v.cmdlo & this.lowMask;
    this.lowMask = 0xff;
    v.period = (v.period + d0) & 0xffff;
    if ((v.period & 0xfff) >= 0x358) v.period = (v.period & 0xf000) | 0x358;
    this.paula.write(AUD_PER, ch, v.period & 0xfff);
  }

  private setTonePorta(ch: number): void {
    const v = this.voices[ch]!;
    const note = v.note & 0xfff;
    const base = v.finetune * 37; // Original: MULU #$4A (37 Wörter) statt #$48 – Eigenheit
    let i = 0;
    for (;;) {
      if (note >= this.period(base + i)) break;
      if (++i >= 37) {
        i = 35;
        break;
      }
    }
    if ((v.finetune & 8) !== 0 && i !== 0) i--;
    v.wantedperiod = this.period(base + i);
    v.toneportdirec = 0;
    if (v.period === v.wantedperiod) v.wantedperiod = 0;
    else if (v.wantedperiod < v.period) v.toneportdirec = 1;
  }

  private tonePortamento(ch: number): void {
    const v = this.voices[ch]!;
    if (v.cmdlo !== 0) {
      v.toneportspeed = v.cmdlo;
      v.cmdlo = 0;
    }
    this.tonePortNoChange(ch);
  }

  private tonePortNoChange(ch: number): void {
    const v = this.voices[ch]!;
    if (v.wantedperiod === 0) return;
    if (v.toneportdirec === 0) {
      v.period = (v.period + v.toneportspeed) & 0xffff;
      if (!(v.wantedperiod > v.period)) {
        v.period = v.wantedperiod;
        v.wantedperiod = 0;
      }
    } else {
      v.period = (v.period - v.toneportspeed) & 0xffff;
      if (!(v.wantedperiod < v.period)) {
        v.period = v.wantedperiod;
        v.wantedperiod = 0;
      }
    }
    let d2 = v.period;
    if ((v.glissfunk & 0xf) !== 0) {
      const base = v.finetune * 36;
      let i = 0;
      for (;;) {
        if (d2 >= this.period(base + i)) break;
        if (++i >= 36) {
          i = 35;
          break;
        }
      }
      d2 = this.period(base + i);
    }
    this.paula.write(AUD_PER, ch, d2);
  }

  private vibrato(ch: number): void {
    const v = this.voices[ch]!;
    if (v.cmdlo !== 0) {
      let d2 = v.vibratocmd;
      if ((v.cmdlo & 0x0f) !== 0) d2 = (d2 & 0xf0) | (v.cmdlo & 0x0f);
      if ((v.cmdlo & 0xf0) !== 0) d2 = (d2 & 0x0f) | (v.cmdlo & 0xf0);
      v.vibratocmd = d2;
    }
    this.vibrato2(ch);
  }

  private vibrato2(ch: number): void {
    const v = this.voices[ch]!;
    const amount = (this.waveValue(v.vibratopos, v.wavecontrol & 3, v.vibratopos) * (v.vibratocmd & 0xf)) >> 7;
    const per = (v.vibratopos & 0x80) !== 0 ? v.period - amount : v.period + amount;
    this.paula.write(AUD_PER, ch, per & 0xffff);
    v.vibratopos = (v.vibratopos + ((v.vibratocmd >> 2) & 0x3c)) & 0xff;
  }

  private tremolo(ch: number): void {
    const v = this.voices[ch]!;
    if (v.cmdlo !== 0) {
      let d2 = v.tremolocmd;
      if ((v.cmdlo & 0x0f) !== 0) d2 = (d2 & 0xf0) | (v.cmdlo & 0x0f);
      if ((v.cmdlo & 0xf0) !== 0) d2 = (d2 & 0x0f) | (v.cmdlo & 0xf0);
      v.tremolocmd = d2;
    }
    // Rampe prüft die Vibrato-Position (Original-Eigenheit)
    const amount = (this.waveValue(v.tremolopos, (v.wavecontrol >> 4) & 3, v.vibratopos) * (v.tremolocmd & 0xf)) >> 6;
    let vol = (v.tremolopos & 0x80) !== 0 ? v.volume - amount : v.volume + amount;
    if (vol < 0) vol = 0;
    if (vol > 0x40) vol = 0x40;
    this.volOut = vol;
    v.tremolopos = (v.tremolopos + ((v.tremolocmd >> 2) & 0x3c)) & 0xff;
  }

  /** Wellenform für Vibrato/Tremolo: 0 Sinus, 1 Rampe (Richtung nach `rampPos`), sonst Rechteck. */
  private waveValue(pos: number, waveform: number, rampPos: number): number {
    const i = (pos >> 2) & 0x1f;
    if (waveform === 0) return this.sine[i] ?? 0;
    const ramp = (i << 3) & 0xff;
    if (waveform === 1) return (rampPos & 0x80) !== 0 ? 0xff - ramp : ramp;
    return 0xff;
  }

  // ---- Effekte bei neuer Note ($272A–$2848) ----

  private checkMoreEfx(ch: number): void {
    const v = this.voices[ch]!;
    this.updateFunk(ch);
    switch (v.cmd & 0xf) {
      case 0x9: this.sampleOffset(ch); return;
      case 0xb: this.positionJump(ch); return;
      case 0xd: this.patternBreak(ch); return;
      case 0xe: this.eCommands(ch); return;
      case 0xf: this.setSpeed(ch); return;
      case 0xc: this.volumeChange(ch); return;
    }
    this.perNop(ch);
  }

  private sampleOffset(ch: number): void {
    const v = this.voices[ch]!;
    if (v.cmdlo !== 0) v.sampleoffset = v.cmdlo;
    const d0 = (v.sampleoffset << 7) & 0xffff;
    // cmp.w: vorzeichenbehaftet
    if (d0 >= ((v.length << 16) >> 16)) {
      v.length = 1;
      return;
    }
    v.length = (v.length - d0) & 0xffff;
    v.start += (d0 << 1) & 0xffff;
  }

  private positionJump(ch: number): void {
    this.songPos = (this.voices[ch]!.cmdlo - 1) & 0xff;
    this.pbreakPos = 0;
    this.posJumpFlag = 0xff;
  }

  private volumeChange(ch: number): void {
    const v = this.voices[ch]!;
    const vol = v.cmdlo > 0x40 ? 0x40 : v.cmdlo;
    v.volume = vol;
    this.volOut = vol;
  }

  private patternBreak(ch: number): void {
    const p = this.voices[ch]!.cmdlo;
    const row = ((p >> 4) * 10 + (p & 0xf)) & 0xff;
    this.pbreakPos = row > 0x3f ? 0 : row;
    this.posJumpFlag = 0xff;
  }

  private setSpeed(ch: number): void {
    const p = this.voices[ch]!.cmdlo;
    if (p === 0) return;
    this.counter = 0;
    this.speed = p;
  }

  private volumeSlide(ch: number): void {
    const v = this.voices[ch]!;
    const up = v.cmdlo >> 4;
    if (up !== 0) this.volSlideUp(ch, up);
    else this.volSlideDown(ch, v.cmdlo & 0xf);
  }

  private volSlideUp(ch: number, d0: number): void {
    const v = this.voices[ch]!;
    v.volume = (v.volume + d0) & 0xff;
    if ((((v.volume - 0x40) & 0xff) & 0x80) === 0) v.volume = 0x40;
    this.volOut = v.volume;
  }

  private volSlideDown(ch: number, d0: number): void {
    const v = this.voices[ch]!;
    v.volume = (v.volume - d0) & 0xff;
    if ((v.volume & 0x80) !== 0) v.volume = 0;
    this.volOut = v.volume;
  }

  // ---- E-Befehle ($284C–$2A96) ----

  private eCommands(ch: number): void {
    const v = this.voices[ch]!;
    const p = v.cmdlo & 0xf;
    switch (v.cmdlo >> 4) {
      case 0x0: return; // Filter (LED) – nicht nachgebildet
      case 0x1:
        if (this.counter !== 0) return;
        this.lowMask = 0x0f;
        this.portaUp(ch);
        return;
      case 0x2:
        if (this.counter !== 0) return;
        this.lowMask = 0x0f;
        this.portaDown(ch);
        return;
      case 0x3: v.glissfunk = (v.glissfunk & 0xf0) | p; return;
      case 0x4: v.wavecontrol = (v.wavecontrol & 0xf0) | p; return;
      case 0x5: v.finetune = p; return;
      case 0x6: this.jumpLoop(ch); return;
      case 0x7: v.wavecontrol = (v.wavecontrol & 0x0f) | (p << 4); return;
      case 0x9: this.retrigNote(ch); return;
      case 0xa:
        if (this.counter === 0) this.volSlideUp(ch, p);
        return;
      case 0xb:
        if (this.counter === 0) this.volSlideDown(ch, p);
        return;
      case 0xc:
        if (p === this.counter) {
          v.volume = 0;
          this.volOut = 0;
        }
        return;
      case 0xd:
        if (p === this.counter && v.note !== 0) this.doRetrig(ch);
        return;
      case 0xe:
        if (this.counter !== 0 || this.pattDelTime2 !== 0) return;
        this.pattDelTime = p + 1;
        return;
      case 0xf:
        if (this.counter !== 0) return;
        v.glissfunk = (v.glissfunk & 0x0f) | (p << 4);
        if (p !== 0) this.updateFunk(ch);
        return;
    }
  }

  private jumpLoop(ch: number): void {
    const v = this.voices[ch]!;
    if (this.counter !== 0) return;
    const p = v.cmdlo & 0xf;
    if (p === 0) {
      v.pattpos = (this.patternPos >> 4) & 0xff;
      return;
    }
    if (v.loopcount === 0) v.loopcount = p;
    else {
      v.loopcount = (v.loopcount - 1) & 0xff;
      if (v.loopcount === 0) return;
    }
    this.pbreakPos = v.pattpos;
    this.pbreakFlag = 0xff;
  }

  private retrigNote(ch: number): void {
    const v = this.voices[ch]!;
    const p = v.cmdlo & 0xf;
    if (p === 0) return;
    if (this.counter === 0 && (v.note & 0xfff) !== 0) return;
    if (this.counter % p !== 0) return;
    this.doRetrig(ch);
  }

  private doRetrig(ch: number): void {
    const v = this.voices[ch]!;
    this.paula.write(REG_DMACON, 0, v.dmabit);
    this.paula.write(AUD_LC, ch, v.start);
    this.paula.write(AUD_LEN, ch, v.length);
    this.paula.write(REG_DMACON, 0, DMAF_SETCLR | v.dmabit);
    this.paula.write(AUD_LC, ch, v.loopstart);
    this.paula.write(AUD_LEN, ch, v.replen);
    this.paula.write(AUD_PER, ch, v.period);
  }

  /** mt_UpdateFunk (EFx): kehrt Bytes im Schleifenteil des Samples um – die CPU ändert die Sampledaten. */
  private updateFunk(ch: number): void {
    const v = this.voices[ch]!;
    const speed = v.glissfunk >> 4;
    if (speed === 0) return;
    v.funkoffset = (v.funkoffset + (this.funk[speed] ?? 0)) & 0xff;
    if ((v.funkoffset & 0x80) === 0) return;
    v.funkoffset = 0;
    const end = v.loopstart + v.replen * 2;
    let a = v.wavestart + 1;
    if (a >= end) a = v.loopstart;
    v.wavestart = a;
    this.paula.poke(a, (-1 - this.paula.peek(a)) << 24 >> 24);
  }

  private period(i: number): number {
    return this.periods[i] ?? 0;
  }

  private word(offset: number): number {
    return ((this.mod[offset] ?? 0) << 8) | (this.mod[offset + 1] ?? 0);
  }
}
