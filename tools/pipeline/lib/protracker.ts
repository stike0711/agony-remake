// ProTracker-Module in Spieldateien vermessen und die Speicher-Wirkung von mt_init nachbilden.
// Quelle der Logik: mt_init des Abspielers, z. B. load_sea $61F32–$61F80 (identisch mit Ag_Pt_Player.s).

export interface ModuleInfo {
  name: string;
  /** Anzahl Patterns, ermittelt wie mt_init */
  patterns: number;
  /** Offsets der 31 Sample-Starts relativ zum Modulanfang */
  sampleStarts: number[];
  sampleLengths: number[];
  /** Gesamtlänge des Moduls in Byte */
  length: number;
}

export function moduleInfo(data: Uint8Array, offset: number): ModuleInfo {
  const tag = String.fromCharCode(...data.subarray(offset + 1080, offset + 1084));
  if (tag !== "M.K.") throw new Error(`kein ProTracker-Modul bei 0x${offset.toString(16)} (${tag})`);
  const name = String.fromCharCode(...data.subarray(offset, offset + 20)).replace(/\0.*$/s, "");

  // Höchste Pattern-Nummer suchen – genau wie mt_init: Bei jedem neuen Höchstwert wird der Zähler zusätzlich
  // verringert, es werden also nicht immer alle 128 Positionen geprüft.
  let d0 = 127;
  let max = 0;
  let pos = offset + 952;
  let d1 = 0;
  outer: for (;;) {
    max = d1;
    d0--;
    for (;;) {
      d1 = data[pos++]!;
      if (d1 > max) continue outer;
      if (--d0 < 0) break outer; // dbra
    }
  }
  const patterns = max + 1;

  const sampleStarts: number[] = [];
  const sampleLengths: number[] = [];
  let start = 1084 + patterns * 1024;
  for (let i = 0; i < 31; i++) {
    const len = ((data[offset + 42 + i * 30]! << 8) | data[offset + 43 + i * 30]!) * 2;
    sampleStarts.push(start);
    sampleLengths.push(len);
    start += len;
  }
  return { name, patterns, sampleStarts, sampleLengths, length: start };
}

/**
 * Wirkung von mt_init auf den Speicher: Das erste Langwort jedes der 31 Sample-Plätze wird gelöscht, auch bei leeren
 * Plätzen. Diese liegen am Modulende – dort beginnt bei Menü und Ladebildern das Bild (Wiki bugs.md O-001).
 * Verändert `data` direkt.
 */
export function applyMtInit(data: Uint8Array, moduleOffset: number): void {
  const info = moduleInfo(data, moduleOffset);
  for (const start of info.sampleStarts) data.fill(0, moduleOffset + start, Math.min(moduleOffset + start + 4, data.length));
}
