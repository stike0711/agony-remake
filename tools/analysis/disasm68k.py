"""Disassembliert 68000-Code aus einer entpackten Spieldatei oder einem Speicherabzug (Analyse-Werkzeug).

Aufruf: python tools/analysis/disasm68k.py <datei> <ladeadresse> <von> <bis> [--hex] [--out datei.txt]
  <ladeadresse>  Amiga-Adresse des ersten Datei-Bytes (Spieldateien: 0x600, Chip-RAM-Abzug: 0)
  <von> <bis>    Amiga-Adressen des Bereichs
Benötigt Capstone (pip install capstone). Datenbereiche werden als `dc.w` ausgegeben, wenn Capstone dort nichts
dekodieren kann; Bereiche mit Daten mitten im Code ergeben daher teils unsinnige Befehle.
Zusätzlich werden absolute Adressen, die in den Bereich zeigen, als Sprungziele/Variablen markiert (`; ->`).
"""
import argparse, re, sys
from pathlib import Path
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben

import capstone

ap = argparse.ArgumentParser()
ap.add_argument("file")
ap.add_argument("load", type=lambda s: int(s, 0))
ap.add_argument("start", type=lambda s: int(s, 0))
ap.add_argument("end", type=lambda s: int(s, 0))
ap.add_argument("--hex", action="store_true", help="Bytes jedes Befehls mit ausgeben")
ap.add_argument("--out", help="Ausgabe in Datei statt Konsole")
a = ap.parse_args()

data = Path(a.file).read_bytes()
md = capstone.Cs(capstone.CS_ARCH_M68K, capstone.CS_MODE_M68K_000)
md.skipdata = True

lines = []
pos = a.start
while pos < a.end:
    off = pos - a.load
    chunk = data[off: off + (a.end - pos)]
    if not chunk:
        break
    progressed = False
    for ins in md.disasm(chunk, pos):
        progressed = True
        text = f"{ins.address:06X}  "
        if a.hex:
            text += f"{ins.bytes.hex():<20} "
        text += f"{ins.mnemonic:<9} {ins.op_str}"
        lines.append(text)
        pos = ins.address + ins.size
    if not progressed:
        lines.append(f"{pos:06X}  dc.w      ${int.from_bytes(data[off:off + 2], 'big'):04X}")
        pos += 2

out = "\n".join(lines)
# Absolute Adressen hervorheben ($xxxx.l)
out = re.sub(r"\$([0-9a-f]{4,6})\.l", lambda m: f"${int(m.group(1), 16):06X}.l", out)
if a.out:
    Path(a.out).write_text(out + "\n", encoding="utf-8", newline="\n")
    print(f"{len(lines)} Zeilen → {a.out}")
else:
    print(out)
