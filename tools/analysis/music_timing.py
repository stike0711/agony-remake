"""Laufzeit des Musiktreibers im Level je Bild als Tabelle für das Zeitmodell (E-034, E-035).

Der Vertical-Blank-Interrupt ruft in jedem Bild den Musiktreiber auf; läuft die Hauptschleife über das Bildende,
verzögert ihn das um diese Laufzeit. Sie hängt nur vom Musikstück ab (Zeilen, Noten), nicht vom Spielgeschehen
(Vergleich mit und ohne Dauerfeuer: 584 von 589 Bildern gleich). Gemessen im Emulator mit Haltepunkten vor und
nach dem Aufruf (sea: $43B4 und $43BA), Wiki setup.md „Zeitprofil“:

  await AG.profileStart({ snapshot: "snap_f13100_level1_enter", pcs: [0x43b4, 0x43ba] });
  AG.profileRun(1900, { 13160: () => AG.joy("PRESS_FIRE"), 13162: () => AG.joy("RELEASE_FIRE") }, keepLife);
  … (weitere Abschnitte à 1900 Bilder) …
  await AG.profileSave("level1_music_timing");

Das Stück wiederholt sich nach einem Vorlauf; ausgegeben werden Vorlauf und eine Periode in Farbtakten
(Index 0 = erstes Bild mit der Copperliste des Levels = Takt 1 der Engine).

Aufruf: python tools/analysis/music_timing.py  →  game/src/data/timing/music-sea.ts
"""
import json, os, sys

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..")
SRC = os.path.join(ROOT, "work", "captures", "level1_music_timing.profile.json")
OUT = os.path.join(ROOT, "game", "src", "data", "timing", "music-sea.ts")
LINE, LINES = 227, 313
FIRST = 13111  # Bild (AG.frameNr während des Bilds) des ersten Vertical Blank mit der Copperliste des Levels
LEAD = 60
PERIOD = 3528


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    t0, dur = {}, {}
    for f, pc, v, h in json.load(open(SRC))["hits"]:
        t = (f * LINES + v) * LINE + h
        if pc == 0x43B4:
            t0[f] = t
        elif pc == 0x43BA and f in t0:
            dur[f] = t - t0[f]
    seq = [dur[FIRST + i] for i in range(LEAD + PERIOD)]
    # Prüfung der Periode im Rest der Aufnahme
    rest = [dur[f] for f in sorted(dur) if f >= FIRST + LEAD + PERIOD]
    bad = sum(1 for i, d in enumerate(rest) if abs(d - seq[LEAD + i % PERIOD]) > 40)
    print(f"{len(seq)} Werte, Periode geprüft an {len(rest)} weiteren Bildern: {bad} weichen um mehr als 40 Farbtakte ab")
    hexes = "".join(f"{min(d, 0xfff):03x}" for d in seq)
    lines = [hexes[i:i + 105] for i in range(0, len(hexes), 105)]
    body = "\n".join(f'  "{l}" +' for l in lines).rstrip(" +")
    with open(OUT, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(f"""// Laufzeit des Musiktreibers im Vertical-Blank-Interrupt je Bild, Level 1 (sea), in Farbtakten – erzeugt von
// tools/analysis/music_timing.py aus einer Emulator-Messung (nicht von Hand bearbeiten). Reine Zeitwerte, keine
// Musikdaten. Index 0 = erstes Bild mit der Copperliste des Levels; nach {LEAD} Bildern Vorlauf wiederholt sich
// das Stück alle {PERIOD} Bilder. Je Wert drei Hex-Ziffern.

export const MUSIC_TIMING_SEA = {{
  lead: {LEAD},
  period: {PERIOD},
  hex:
{body},
}};
""")
    print("geschrieben:", os.path.relpath(OUT, ROOT))


if __name__ == "__main__":
    main()
