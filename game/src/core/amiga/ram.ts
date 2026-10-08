// Chip-RAM des Amiga 500 (512 KB) für die Level-Engine (E-032): Die Level arbeiten wie das Original auf ihren
// Originaladressen – Bitplanes, Copperlisten, Sprite-Listen, Tabellen und Variablen liegen hier.
// Wörter und Langwörter sind Big-Endian wie beim 68000. Adressen werden wie auf dem A500 auf 512 KB gespiegelt.

import type { MemoryBlock } from "../assets.ts";

export const RAM_SIZE = 0x80000;
const MASK = RAM_SIZE - 1;

export class Ram {
  readonly bytes = new Uint8Array(RAM_SIZE);

  byte(address: number): number {
    return this.bytes[address & MASK]!;
  }

  word(address: number): number {
    const a = address & MASK;
    return (this.bytes[a]! << 8) | this.bytes[a + 1]!;
  }

  /** Wort mit Vorzeichen (−32768 … 32767) */
  sword(address: number): number {
    return (this.word(address) << 16) >> 16;
  }

  long(address: number): number {
    return ((this.word(address) << 16) | this.word(address + 2)) >>> 0;
  }

  setByte(address: number, value: number): void {
    this.bytes[address & MASK] = value;
  }

  setWord(address: number, value: number): void {
    const a = address & MASK;
    this.bytes[a] = value >> 8;
    this.bytes[a + 1] = value;
  }

  setLong(address: number, value: number): void {
    this.setWord(address, value >>> 16);
    this.setWord(address + 2, value & 0xffff);
  }

  /** Speicherblock an seine Originaladresse kopieren */
  load(block: MemoryBlock): void {
    this.bytes.set(block.data, block.address);
  }

  /** Bereich [from, to) mit Nullen füllen */
  clear(from: number, to: number): void {
    this.bytes.fill(0, from, to);
  }
}
