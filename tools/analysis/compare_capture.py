"""Vergleicht ein dekodiertes Bild pixelgenau mit einem Emulator-Rohbild und findet dessen Lage im Raster.

Aufruf: python tools/analysis/compare_capture.py <bild.png> <aufnahme.rgb> <bildnummer-index>
        [--search 120] [--at x,y] [--rows y0,y1]
Die Aufnahme ist eine Datei aus AG.recordRaw (456 × 313, Lowres) oder AG.recordInterlace (912 × 626, Hires mit
beiden Halbbildern); die Größe steht im Dateinamen. Ausgegeben werden die beste Verschiebung (x, y) und der Anteil
gleicher Pixel.

Verglichen wird auf der Ebene der 12-Bit-Amiga-Farben (4 Bit je Anteil): Das dekodierte Bild nutzt Anteil × 17,
vAmiga gibt etwa Anteil × 16 aus und liegt dabei manchmal um 1 darunter (z. B. $8 → 0x7F, siehe Wiki
bugs.md W-005). Deshalb wird der Emulatorwert gerundet: (v + 8) >> 4. Teile des Bilds außerhalb der Aufnahme
werden nicht verglichen.
"""
import argparse, re, sys
from pathlib import Path
import numpy as np
from PIL import Image
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben

ap = argparse.ArgumentParser()
ap.add_argument("image")
ap.add_argument("raw")
ap.add_argument("index", type=int)
ap.add_argument("--search", type=int, default=120, help="maximale Verschiebung in x und y (ab 0)")
ap.add_argument("--at", help="feste Lage x,y statt Suche")
ap.add_argument("--rows", help="nur diese Bildzeilen y0,y1 des dekodierten Bilds vergleichen")
a = ap.parse_args()

img = np.asarray(Image.open(a.image).convert("RGB")).astype(np.int32) // 17
if a.rows:
    r0, r1 = map(int, a.rows.split(","))
    img = img[r0:r1]
m = re.search(r"_(\d+)x(\d+)_(\d+)_every", Path(a.raw).name)
if not m:
    raise SystemExit("Dateiname passt nicht zum Schema <name>_<b>x<h>_<anzahl>_every<abstand>_from<start>.rgb")
w, h, count = map(int, m.groups())
frames = np.frombuffer(Path(a.raw).read_bytes(), dtype=np.uint8)[: count * w * h * 3].reshape(count, h, w, 3)
frame = (frames[a.index].astype(np.int32) + 8) >> 4
ih, iw = img.shape[:2]


def compare(dx: int, dy: int) -> tuple[float, int]:
    vh, vw = min(ih, h - dy), min(iw, w - dx)
    if vh <= 0 or vw <= 0:
        return -1.0, 0
    equal = np.all(frame[dy:dy + vh, dx:dx + vw] == img[:vh, :vw], axis=2)
    return float(equal.mean()), int((~equal).sum())


if a.at:
    dx, dy = map(int, a.at.split(","))
    eq, bad = compare(dx, dy)
else:
    best = (-1.0, 0, 0, 0)
    for y in range(0, min(a.search, h - 1) + 1):
        for x in range(0, min(a.search, w - 1) + 1):
            e, b = compare(x, y)
            if e > best[0]:
                best = (e, b, x, y)
    eq, bad, dx, dy = best
vis = f"{min(iw, w - dx)} × {min(ih, h - dy)}"
print(f"Lage: x={dx}, y={dy} im {w}×{h}-Raster; verglichen {vis} Pixel; gleich: {eq * 100:.2f} %; abweichend: {bad}")
