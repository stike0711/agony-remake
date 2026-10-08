"""Zeitprofile des Emulators laden (AG.profile*, Wiki setup.md „Zeitprofil“), bereinigt wie game/test/load-profile.ts:
bei Farbtakt 0 und 1 meldet vAmiga noch die vorige Zeile, und an der Bildgrenze kann die Bildnummer noch die alte sein
(dann läge der Treffer vor seinem Vorgänger). Liefert [Bild, PC, Zeile, Farbtakt] in Aufnahmereihenfolge.
"""
import json

LINE, LINES = 227, 313
FRAME = LINE * LINES


def load_hits(path):
    hits = []
    prev = -1
    for f, pc, v, h in json.load(open(path))["hits"]:
        if h <= 1:
            v += 1
        if v >= LINES:
            v -= LINES
            f += 1
        t = (f * LINES + v) * LINE + h
        if t < prev:
            f += 1
            t += FRAME
        prev = t
        hits.append([f, pc, v, h])
    return hits
