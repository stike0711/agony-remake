// Amiga-Bitplanes in Farbindizes umwandeln und Paletten lesen.
// Port der Funktionen decode_planar/palette_from aus tools/analysis/planar.py.

export interface PlanarLayout {
  width: number; // Pixel
  height: number; // Zeilen
  planes: number;
  /** Bytes pro Zeile einer Plane (Standard: width / 8) */
  rowBytes?: number;
  /** Abstand zweier Planes in Byte (Standard: rowBytes × height, d. h. Planes nacheinander) */
  planeBytes?: number;
}

/** Bitplanes ab `offset` → ein Byte Farbindex pro Pixel (Plane 1 = Bit 0). */
export function decodePlanar(data: Uint8Array, offset: number, layout: PlanarLayout): Uint8Array {
  const { width, height, planes } = layout;
  const rowBytes = layout.rowBytes ?? width / 8;
  const planeBytes = layout.planeBytes ?? rowBytes * height;
  const end = offset + planeBytes * (planes - 1) + rowBytes * height;
  if (end > data.length) throw new Error(`Bitplanes reichen über das Datenende (${end} > ${data.length})`);
  const out = new Uint8Array(width * height);
  for (let p = 0; p < planes; p++) {
    const bit = 1 << p;
    for (let y = 0; y < height; y++) {
      const row = offset + p * planeBytes + y * rowBytes;
      for (let x = 0; x < width; x++) {
        if ((data[row + (x >> 3)]! >> (7 - (x & 7))) & 1) out[y * width + x]! |= bit;
      }
    }
  }
  return out;
}

/** `count` Farbwörter `$0RGB` ab `offset` (12 Bit je Farbe). */
export function readPalette(data: Uint8Array, offset: number, count: number): number[] {
  const out: number[] = [];
  for (let i = 0; i < count; i++) out.push(((data[offset + 2 * i]! << 8) | data[offset + 2 * i + 1]!) & 0xfff);
  return out;
}

/** Extra-Halfbrite: Farben 32–63 = Farben 0–31 mit halber Helligkeit (jeder Anteil um 1 Bit nach rechts). */
export function expandEhb(palette: number[]): number[] {
  return [...palette, ...palette.map((c) => (c >> 1) & 0x777)];
}

/** 12-Bit-Farbe → [R, G, B] mit 8 Bit je Anteil (Anteil × 17). */
export function rgb12(c: number): [number, number, number] {
  return [((c >> 8) & 15) * 17, ((c >> 4) & 15) * 17, (c & 15) * 17];
}
