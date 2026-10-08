"""Wandelt Rohaufnahmen aus dem Emulator (AG.recordRaw) in PNGs und eine Übersichtstafel um.

Aufruf: python tools/analysis/raw_frames.py work/captures/<name>_456x313_<anzahl>_every<abstand>_from<start>.rgb
        [--crop x0,y0,x1,y1] [--no-frames]
Ergebnis neben der Rohdatei: Ordner <name>/ mit frame_<bildnummer>.png und <name>_sheet.png
"""
import argparse, re, sys
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben

parser = argparse.ArgumentParser()
parser.add_argument("raw")
parser.add_argument("--crop", help="Ausschnitt x0,y0,x1,y1 im 456×313-Raster")
parser.add_argument("--no-frames", action="store_true", help="nur die Übersichtstafel erzeugen")
parser.add_argument("--cols", type=int, default=10)
args = parser.parse_args()

raw = Path(args.raw)
m = re.match(r"(.+)_(\d+)x(\d+)_(\d+)_every(\d+)_from(\d+)\.rgb$", raw.name)
if not m:
    raise SystemExit("Dateiname passt nicht zum Schema <name>_456x313_<anzahl>_every<abstand>_from<start>.rgb")
name, w, h, count, every, start = m.group(1), *map(int, m.groups()[1:])
data = np.frombuffer(raw.read_bytes(), dtype=np.uint8)
frames = data[: count * w * h * 3].reshape(count, h, w, 3)

if args.crop:
    x0, y0, x1, y1 = map(int, args.crop.split(","))
    frames = frames[:, y0:y1, x0:x1]

out_dir = raw.parent / name
out_dir.mkdir(exist_ok=True)
images = []
for i, frame in enumerate(frames):
    img = Image.fromarray(frame, "RGB")
    images.append(img)
    if not args.no_frames:
        img.save(out_dir / f"frame_{start + i * every:06d}.png")

# Übersichtstafel: halbe Größe, mit Bildnummer
fh, fw = frames.shape[1] // 2, frames.shape[2] // 2
cols = args.cols
rows = (len(images) + cols - 1) // cols
sheet = Image.new("RGB", (cols * fw, rows * (fh + 12)), (40, 40, 40))
draw = ImageDraw.Draw(sheet)
for i, img in enumerate(images):
    x, y = (i % cols) * fw, (i // cols) * (fh + 12)
    sheet.paste(img.resize((fw, fh), Image.NEAREST), (x, y + 12))
    draw.text((x + 2, y), str(start + i * every), fill=(255, 255, 0))
sheet_path = raw.parent / f"{name}_sheet.png"
sheet.save(sheet_path)
print(f"{len(images)} Bilder ({w}×{h}{', zugeschnitten' if args.crop else ''}) → {out_dir if not args.no_frames else '-'}; Tafel: {sheet_path}")
