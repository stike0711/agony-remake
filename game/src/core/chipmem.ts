// Sample-Speicher: ein zusammenhängender Block wie das Chip-RAM des Amiga (Samples und ProTracker-Module).
// Paula-Register (AUDxLC) enthalten Adressen in diesen Block; der Mixer der Plattform bekommt beim Start eine Kopie
// und erfährt spätere Schreibzugriffe der CPU über das Paula-Protokoll (REG_POKE).

export class ChipMemory {
  readonly bytes: Int8Array;
  private used = 0;

  constructor(size: number) {
    // Gerade Größe: Paula liest immer ganze Wörter
    this.bytes = new Int8Array((size + 1) & ~1);
  }

  /** Daten ablegen (wortausgerichtet) und ihre Adresse zurückgeben; `padding` Byte dahinter bleiben 0. */
  store(data: Uint8Array | Int8Array, padding = 0): number {
    const address = this.used;
    if (address + data.length + padding > this.bytes.length) throw new Error("Sample-Speicher voll");
    this.bytes.set(new Int8Array(data.buffer, data.byteOffset, data.length), address);
    this.used = (address + data.length + padding + 1) & ~1;
    return address;
  }
}
