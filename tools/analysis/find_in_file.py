"""Sucht Speicherbereiche aus einem Emulator-Abzug in einer (entpackten) Spieldatei.

Aufruf: python tools/analysis/find_in_file.py <chip.bin> <datei> <adresse> [<adresse> ...] [--len 64]
Für jede Adresse werden `len` Bytes aus dem Abzug genommen und in der Datei gesucht. Bei einem Treffer wird die
mögliche Ladeadresse (Adresse − Datei-Offset) ausgegeben.
"""
import argparse, sys
from pathlib import Path
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben

parser = argparse.ArgumentParser()
parser.add_argument("dump")
parser.add_argument("file")
parser.add_argument("addrs", nargs="+")
parser.add_argument("--len", type=int, default=64)
args = parser.parse_args()

mem = Path(args.dump).read_bytes()
data = Path(args.file).read_bytes()
for a in args.addrs:
    addr = int(a, 0)
    needle = mem[addr: addr + args.len]
    if not any(needle):
        print(f"${addr:06X}: nur Nullbytes, übersprungen")
        continue
    hits = []
    start = 0
    while len(hits) < 5:
        i = data.find(needle, start)
        if i < 0:
            break
        hits.append(i)
        start = i + 1
    if hits:
        print(f"${addr:06X}: in Datei bei " + ", ".join(f"0x{h:05X} (Basis ${addr - h:06X})" for h in hits))
    else:
        print(f"${addr:06X}: nicht gefunden")
