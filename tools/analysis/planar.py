"""Amiga-Bitplane-Bilder aus Spieldateien dekodieren (Analyse-Werkzeug).

Aufruf:
  python tools/analysis/planar.py <datei> <offset> <breite> <höhe> <planes> --pal <offset> [--ehb] [--out bild.png]
    [--stride <bytes pro Zeile>] [--interleaved]

Annahmen: Bitplanes liegen nacheinander (nicht interleaved), jede Zeile hat `stride` Bytes (Standard: breite/8).
Farben im Amiga-Format $0RGB (12 Bit) als 16-Bit-Wörter. --ehb: Extra-Halfbrite (Farben 32–63 = halbe Helligkeit).
"""
import argparse, struct, sys
from pathlib import Path
import numpy as np
from PIL import Image
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben


def amiga_rgb(word: int) -> tuple[int, int, int]:
    return (((word >> 8) & 15) * 17, ((word >> 4) & 15) * 17, (word & 15) * 17)


def palette_from(data: bytes, offset: int, count: int, ehb: bool) -> list[tuple[int, int, int]]:
    words = struct.unpack_from(f">{count}H", data, offset)
    pal = [amiga_rgb(w) for w in words]
    if ehb:
        pal += [amiga_rgb(((w >> 1) & 0x777)) for w in words]
    return pal


def decode_planar(data: bytes, offset: int, width: int, height: int, planes: int, stride: int, interleaved: bool) -> np.ndarray:
    """Liefert ein Array height × width mit Farbindizes."""
    idx = np.zeros((height, width), dtype=np.uint8)
    plane_size = stride * height
    for p in range(planes):
        for y in range(height):
            if interleaved:
                row_off = offset + (y * planes + p) * stride
            else:
                row_off = offset + p * plane_size + y * stride
            row = np.frombuffer(data, dtype=np.uint8, count=width // 8, offset=row_off)
            bits = np.unpackbits(row)[:width]
            idx[y] |= (bits << p).astype(np.uint8)
    return idx


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("file")
    ap.add_argument("offset")
    ap.add_argument("width", type=int)
    ap.add_argument("height", type=int)
    ap.add_argument("planes", type=int)
    ap.add_argument("--pal", required=True, help="Datei-Offset der Palette")
    ap.add_argument("--colors", type=int, default=32)
    ap.add_argument("--ehb", action="store_true")
    ap.add_argument("--stride", type=int)
    ap.add_argument("--interleaved", action="store_true")
    ap.add_argument("--out", default="planar.png")
    a = ap.parse_args()
    data = Path(a.file).read_bytes()
    stride = a.stride or a.width // 8
    idx = decode_planar(data, int(a.offset, 0), a.width, a.height, a.planes, stride, a.interleaved)
    pal = palette_from(data, int(a.pal, 0), a.colors, a.ehb)
    rgb = np.array(pal + [(255, 0, 255)] * (256 - len(pal)), dtype=np.uint8)[idx]
    Image.fromarray(rgb, "RGB").save(a.out)
    print(f"{a.width}×{a.height}, {a.planes} Planes, {len(np.unique(idx))} Farben benutzt → {a.out}")
