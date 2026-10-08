// Minimaler PNG-Schreiber für Vorschaubilder (indiziert mit Palette oder RGB), nur Node-Bordmittel.

import { crc32, deflateSync } from "node:zlib";

function chunk(type: string, body: Uint8Array): Uint8Array {
  const out = new Uint8Array(12 + body.length);
  const view = new DataView(out.buffer);
  view.setUint32(0, body.length);
  for (let i = 0; i < 4; i++) out[4 + i] = type.charCodeAt(i);
  out.set(body, 8);
  view.setUint32(8 + body.length, crc32(out.subarray(4, 8 + body.length)));
  return out;
}

function png(width: number, height: number, colorType: number, rows: Uint8Array, extra: Uint8Array[] = []): Uint8Array {
  const header = new Uint8Array(13);
  const view = new DataView(header.buffer);
  view.setUint32(0, width);
  view.setUint32(4, height);
  header[8] = 8; // Bit pro Kanal bzw. Index
  header[9] = colorType;
  const parts = [
    new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
    chunk("IHDR", header),
    ...extra,
    chunk("IDAT", deflateSync(rows, { level: 9 })),
    chunk("IEND", new Uint8Array(0)),
  ];
  const out = new Uint8Array(parts.reduce((n, p) => n + p.length, 0));
  let pos = 0;
  for (const p of parts) {
    out.set(p, pos);
    pos += p.length;
  }
  return out;
}

/** Indiziertes PNG: ein Byte pro Pixel, Palette als [R, G, B]-Liste (höchstens 256 Einträge). */
export function encodeIndexedPng(width: number, height: number, indices: Uint8Array, palette: [number, number, number][]): Uint8Array {
  const rows = new Uint8Array((width + 1) * height);
  for (let y = 0; y < height; y++) rows.set(indices.subarray(y * width, (y + 1) * width), y * (width + 1) + 1);
  const plte = new Uint8Array(palette.length * 3);
  palette.forEach(([r, g, b], i) => plte.set([r, g, b], i * 3));
  return png(width, height, 3, rows, [chunk("PLTE", plte)]);
}

/** RGB-PNG: drei Byte pro Pixel. */
export function encodeRgbPng(width: number, height: number, rgb: Uint8Array): Uint8Array {
  const rows = new Uint8Array((width * 3 + 1) * height);
  for (let y = 0; y < height; y++) rows.set(rgb.subarray(y * width * 3, (y + 1) * width * 3), y * (width * 3 + 1) + 1);
  return png(width, height, 2, rows);
}
