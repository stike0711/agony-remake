"""Kalibrierung der Dauer des Copper-Interrupts im Level (game/src/core/level/timing.ts, IRQ_BASE/IRQ_COST/IRQ_SKIP).

Eingaben in work/captures/ je Lauf:
  <lauf>.profile.json  Haltepunkte im Emulator, darunter $43C6 (Beginn) und $5BC4 (Ende des Copper-Interrupts)
  <lauf>.timing.json   je Bild mit Copper-Interrupt die ausgeführten Teile im Nachbau (game/test/tools/collect-timing.ts)

Modell: Dauer ab dem gerechneten Beginn (Zeile der Copperliste · 227 + IRQ_RESPONSE) bis $5BC4 = Grundwert + Summe
(Kosten · Teil); ohne die Teile nach dem 25-Hz-Takt (sprites = 0) ein fester Wert. Kleinste Quadrate über alle Läufe,
dazu der Fehler der bisherigen Konstanten je Lauf. Nicht verwertet werden Interrupts, die mehr als 300 Farbtakte
verspätet beginnen (O-010: der lange Blit des Zurücksetzens hält den Prozessor auf; rund 8 % der Bilder). Eule und
Äxte laufen immer gemeinsam; ihr Anteil steht bei der Eule (Äxte 0).

Aufruf: python tools/analysis/fit_irq_timing.py [<lauf> …]   (Standard: level1_go level1_shoot)
"""
import json, os, sys
import numpy as np
from profile_hits import load_hits

sys.stdout.reconfigure(encoding="utf-8")
C = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "work", "captures")
LINE, LINES = 227, 313
IRQ_RESPONSE = LINE + 132
PARTS = ["sprites", "sorcerer", "fire", "axes", "spells", "shield", "dieStart", "dieParts", "alienFire",
         "alienFireShots", "rain", "fireStart"]
# bisherige Werte aus timing.ts
OLD_BASE, OLD_SKIP = 1139, 150
OLD_COST = [0, 1067, 233, 0, 0, -498, 9, 80, 610, 30, 1410, 0]

runs = [a for a in sys.argv[1:] if not a.startswith("--")] or ["level1_go", "level1_shoot"]
rows = []   # (Lauf, Bild, Teile, gemessene Dauer)
for run in runs:
    hits = load_hits(os.path.join(C, run + ".profile.json"))
    start, end = {}, {}
    for f, pc, v, h in hits:
        t = v * LINE + h
        if pc == 0x43C6:
            start[f] = t
        elif pc == 0x5BC4 and f in start:
            end[f] = t
    data = json.load(open(os.path.join(C, run + ".timing.json")))
    for row in data["irq"]:
        f, line, parts = row[0], row[1], row[2:]
        pf = f - 1   # Profilbild = Takt − 1
        if pf not in end:
            continue
        if start[pf] - (line * LINE + IRQ_RESPONSE) > 300:
            continue
        d = end[pf] - (line * LINE + IRQ_RESPONSE)
        rows.append((run, f, parts, d))

full = [r for r in rows if r[2][0]]
skip = [r for r in rows if not r[2][0]]
X = np.array([r[2] for r in full], float)
y = np.array([r[3] for r in full], float)
cols = [i for i in range(1, len(PARTS)) if X[:, i].std() > 0 and PARTS[i] != "axes"]
A = np.hstack([np.ones((len(y), 1)), X[:, cols]])
c, *_ = np.linalg.lstsq(A, y, rcond=None)
err = A @ c - y
cost = [0] * len(PARTS)
for j, i in enumerate(cols):
    cost[i] = round(c[j + 1])
print(f"n {len(y)}, rms {np.sqrt((err ** 2).mean()):.0f}, max {abs(err).max():.0f}")
print(f"IRQ_BASE = {round(c[0])}")
print(f"IRQ_COST = {cost}")
if skip:
    print(f"IRQ_SKIP: Mittel {np.mean([r[3] for r in skip]):.0f} (n {len(skip)}, Spanne {min(r[3] for r in skip)}–{max(r[3] for r in skip)})")

new = lambda p: round(c[0]) + sum(cost[i] * p[i] for i in range(len(PARTS)))
old = lambda p: OLD_BASE + sum(OLD_COST[i] * p[i] for i in range(len(PARTS)))
for run in runs:
    rr = [r for r in full if r[0] == run]
    for name, fn in (("bisher", old), ("neu", new)):
        e = np.array([fn(r[2]) - r[3] for r in rr], float)
        print(f"{run:13s} {name:6s} n {len(e)} Mittel {e.mean():6.0f} rms {np.sqrt((e ** 2).mean()):5.0f} max {abs(e).max():5.0f}")

if "--residuals" in sys.argv:
    rr = sorted(full, key=lambda r: -abs(new(r[2]) - r[3]))
    for r in rr[:20]:
        print(r[0], r[1], new(r[2]) - r[3], {PARTS[i]: v for i, v in enumerate(r[2]) if v})
