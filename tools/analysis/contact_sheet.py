"""Übersichtstafel aus einer PNG-Serie (z. B. Emulator-Aufnahmen aus AG.recordStepped).

Aufruf: python tools/analysis/contact_sheet.py "work/captures/title_f*.png" work/captures/title_sheet.png [--cols 10] [--scale 0.5]
"""
import argparse, glob, sys
from PIL import Image, ImageDraw
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben

parser = argparse.ArgumentParser()
parser.add_argument("pattern")
parser.add_argument("out")
parser.add_argument("--cols", type=int, default=10)
parser.add_argument("--scale", type=float, default=0.5)
args = parser.parse_args()

files = sorted(glob.glob(args.pattern))
if not files:
    raise SystemExit("keine Dateien gefunden")
first = Image.open(files[0])
fw, fh = int(first.width * args.scale), int(first.height * args.scale)
rows = (len(files) + args.cols - 1) // args.cols
sheet = Image.new("RGB", (args.cols * fw, rows * (fh + 12)), (40, 40, 40))
draw = ImageDraw.Draw(sheet)
for i, path in enumerate(files):
    img = Image.open(path).convert("RGB").resize((fw, fh), Image.NEAREST)
    x, y = (i % args.cols) * fw, (i // args.cols) * (fh + 12)
    sheet.paste(img, (x, y + 12))
    label = path.replace("\\", "/").rsplit("/", 1)[-1].rsplit(".", 1)[0]
    draw.text((x + 2, y), label[-14:], fill=(255, 255, 0))
sheet.save(args.out)
print(f"{len(files)} Bilder → {args.out}")
