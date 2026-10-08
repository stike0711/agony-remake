// WAV-Datei aus Amiga-Samples (8 Bit vorzeichenbehaftet) schreiben, für Vorschau und Hörvergleich.

/** Samples (Int8 wie im Amiga-Speicher) als 8-Bit-WAV (vorzeichenlos) mit der angegebenen Abtastrate. */
export function encodeWav8(samples: Uint8Array, sampleRate: number): Uint8Array {
  const out = new Uint8Array(44 + samples.length);
  const view = new DataView(out.buffer);
  const text = (pos: number, s: string): void => {
    for (let i = 0; i < s.length; i++) out[pos + i] = s.charCodeAt(i);
  };
  text(0, "RIFF");
  view.setUint32(4, 36 + samples.length, true);
  text(8, "WAVE");
  text(12, "fmt ");
  view.setUint32(16, 16, true);
  view.setUint16(20, 1, true); // PCM
  view.setUint16(22, 1, true); // mono
  view.setUint32(24, Math.round(sampleRate), true);
  view.setUint32(28, Math.round(sampleRate), true);
  view.setUint16(32, 1, true);
  view.setUint16(34, 8, true);
  text(36, "data");
  view.setUint32(40, samples.length, true);
  for (let i = 0; i < samples.length; i++) out[44 + i] = (samples[i]! + 128) & 0xff; // Int8 → Uint8
  return out;
}

/** PAL-Takt der Amiga-Audiohardware: Abtastrate = PAULA_CLOCK / Periode. */
export const PAULA_CLOCK_PAL = 3546895;
