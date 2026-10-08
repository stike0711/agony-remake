// Paula-Modell des Kerns: die vier Audiokanäle als Register (AUDxLC/LEN/PER/VOL, DMACON) mit dem Zeitverhalten
// der DMA. Der Kern schreibt Register wie das Original; Paula zählt in Farbtakten mit und meldet wie die Hardware
// einen Audio-Interrupt, sobald ein Block (LC/LEN) gestartet bzw. neu geladen wird – z. B. „Sample zu Ende“.
// Alle Schreibzugriffe landen außerdem in einem Protokoll, das die Plattform an ihren Mixer weitergibt; der Mixer
// bildet dieselbe DMA nach und erzeugt den Klang. So bleibt der Kern deterministisch und ohne Audio-API.
//
// Zeit innerhalb eines Takts: Jeder Eintrag trägt den Zeitpunkt (Farbtakte seit Beginn des Takts). Normalerweise
// ist das 0 (alles am Taktanfang, wie Code direkt nach dem Bild-Interrupt). Wartet das Original auf einen
// Audio-Interrupt, rückt `seek` die Zeit bis zu diesem Moment vor, und die folgenden Zugriffe geschehen dort.

export const AUD_LC = 0;
export const AUD_LEN = 1;
export const AUD_PER = 2;
export const AUD_VOL = 3;
/** DMACON: Wert wie im Register, Bit 15 = setzen (sonst löschen), Bits 0–3 = Kanäle */
export const REG_DMACON = 4;
/** Schreibzugriff der CPU auf den Sample-Speicher: Kanal-Feld = Adresse, Wert = Byte (z. B. mt_init, EFx) */
export const REG_POKE = 5;

export const DMAF_SETCLR = 0x8000;
export const DMAF_AUDIO = 0x000f;

/**
 * Kleinste Periode, die die Audio-DMA bedienen kann (PAL: 123 Farbtakte; kleinere Werte liefern auf der Hardware
 * doppelte Samples). Vorerst einfach begrenzt.
 */
export const MIN_PERIOD = 124;

/** Einträge im Schreibprotokoll je Takt. */
export const LOG_CAPACITY = 1024;
/** Werte je Eintrag: Register, Kanal (bzw. Adresse), Wert, Zeitpunkt im Takt (Farbtakte) */
export const LOG_STRIDE = 4;

export class Paula {
  readonly lc = new Int32Array(4);
  /** Länge in Wörtern; 0 bedeutet wie bei der Hardware 65536 */
  readonly len = new Int32Array(4);
  readonly per = new Int32Array(4);
  readonly vol = new Int32Array(4);
  /** aktive Audio-DMA-Kanäle (Bits 0–3) */
  dmacon = 0;
  /** anstehende Audio-Interrupts (Bit n = Kanal n, entspricht INTREQ-Bit 7 + n) */
  intreq = 0;
  /** Farbtakte seit Beginn des laufenden Takts */
  now = 0;
  /** Sample-Speicher (wie Chip-RAM), für `poke` und `peek` */
  memory: Int8Array = new Int8Array(2);

  /** Schreibprotokoll seit dem letzten `clearLog()`: [Register, Kanal, Wert, Zeitpunkt] × logCount */
  readonly log = new Int32Array(LOG_CAPACITY * LOG_STRIDE);
  logCount = 0;

  private readonly bytesLeft = new Int32Array(4);
  private readonly phase = new Int32Array(4);

  write(reg: number, channel: number, value: number): void {
    switch (reg) {
      case AUD_LC: this.lc[channel] = value & ~1; break;
      case AUD_LEN: this.len[channel] = value & 0xffff; break;
      case AUD_PER: this.per[channel] = value & 0xffff; break;
      case AUD_VOL: this.vol[channel] = Math.min(value & 0x7f, 64); break;
      case REG_DMACON: this.writeDmacon(value); break;
    }
    this.record(reg, channel, value);
  }

  /** Byte in den Sample-Speicher schreiben (die CPU ändert Sampledaten); der Mixer erfährt es über das Protokoll. */
  poke(address: number, value: number): void {
    if (address < 0 || address >= this.memory.length) return;
    this.memory[address] = value;
    this.record(REG_POKE, address, value & 0xff);
  }

  peek(address: number): number {
    return this.memory[address] ?? 0;
  }

  /** Bequemer Start eines Kanals wie im Original: LC, LEN, PER, VOL setzen, dann DMA ein. */
  play(channel: number, address: number, lengthBytes: number, period: number, volume: number): void {
    this.write(AUD_LC, channel, address);
    this.write(AUD_LEN, channel, lengthBytes >> 1);
    this.write(AUD_PER, channel, period);
    this.write(AUD_VOL, channel, volume);
    this.write(REG_DMACON, 0, DMAF_SETCLR | (1 << channel));
  }

  stop(channelMask: number): void {
    this.write(REG_DMACON, 0, channelMask & DMAF_AUDIO);
  }

  /** Interrupt-Bits abholen und löschen (wie INTREQ lesen + quittieren). */
  takeInterrupts(mask = DMAF_AUDIO): number {
    const bits = this.intreq & mask;
    this.intreq &= ~mask;
    return bits;
  }

  /** Farbtakte bis zum nächsten Blockstart (= nächster Audio-Interrupt) von Kanal `ch`; −1, wenn die DMA aus ist. */
  ccUntilReload(ch: number): number {
    if ((this.dmacon & (1 << ch)) === 0) return -1;
    return this.bytesLeft[ch]! * effectivePeriod(this.per[ch]!) - this.phase[ch]!;
  }

  /** Zeit innerhalb des Takts bis `at` vorrücken; folgende Zugriffe geschehen zu diesem Zeitpunkt. */
  seek(at: number): void {
    if (at > this.now) this.advance(at - this.now);
  }

  /** Takt abschließen: Rest der `frameCc` Farbtakte vergehen lassen, Zeit wieder auf 0. */
  endFrame(frameCc: number): void {
    if (frameCc > this.now) this.run(frameCc - this.now);
    this.now = 0;
  }

  /** Zeit vergehen lassen (Farbtakte): Positionen weiterzählen, Blöcke neu laden, Interrupts setzen. */
  advance(cc: number): void {
    this.run(cc);
    this.now += cc;
  }

  clearLog(): void {
    this.logCount = 0;
  }

  reset(): void {
    this.lc.fill(0);
    this.len.fill(0);
    this.per.fill(0);
    this.vol.fill(0);
    this.dmacon = 0;
    this.intreq = 0;
    this.now = 0;
    this.write(REG_DMACON, 0, DMAF_AUDIO);
  }

  private record(reg: number, channel: number, value: number): void {
    if (this.logCount >= LOG_CAPACITY) return;
    const i = this.logCount++ * LOG_STRIDE;
    this.log[i] = reg;
    this.log[i + 1] = channel;
    this.log[i + 2] = value;
    this.log[i + 3] = this.now;
  }

  private run(cc: number): void {
    for (let ch = 0; ch < 4; ch++) {
      if ((this.dmacon & (1 << ch)) === 0) continue;
      const period = effectivePeriod(this.per[ch]!);
      let t = cc;
      while (t > 0) {
        const blockCc = this.bytesLeft[ch]! * period - this.phase[ch]!;
        if (t < blockCc) {
          const pos = this.phase[ch]! + t;
          this.bytesLeft[ch]! -= Math.floor(pos / period);
          this.phase[ch] = pos % period;
          break;
        }
        t -= blockCc;
        this.startBlock(ch);
      }
    }
  }

  private writeDmacon(value: number): void {
    const bits = value & DMAF_AUDIO;
    if (value & DMAF_SETCLR) {
      const started = bits & ~this.dmacon;
      this.dmacon |= bits;
      for (let ch = 0; ch < 4; ch++) if (started & (1 << ch)) this.startBlock(ch);
    } else {
      this.dmacon &= ~bits;
    }
  }

  /** LC/LEN in die DMA übernehmen; die Hardware meldet dabei den Audio-Interrupt. */
  private startBlock(ch: number): void {
    this.bytesLeft[ch] = blockBytes(this.len[ch]!);
    this.phase[ch] = 0;
    this.intreq |= 1 << ch;
  }
}

export function effectivePeriod(per: number): number {
  return per === 0 ? 65536 : Math.max(per, MIN_PERIOD);
}

export function blockBytes(lenWords: number): number {
  return (lenWords === 0 ? 65536 : lenWords) * 2;
}
