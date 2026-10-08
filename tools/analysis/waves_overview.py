"""Überblick über die Angriffswellen-Listen der Level-Module (START_A/START_R/START_C).
Aufruf aus beliebigem Verzeichnis: python tools/analysis/waves_overview.py
Hinweis: Die drei Makro-Definitionen (Start_R/Start_A/Start_C MACRO) werden als „MACRO“ mitgezählt."""
import re, os, collections, sys
from pathlib import Path
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben

PROJECT = Path(__file__).resolve().parents[2]
base = PROJECT / "reference" / "source" / "YvesGrolet-sources" / "YvesDisks" / "PC_Files" / "AgonyDosBoot"
files = ["Ag_Game_LMER.s", "Ag_Game_LFORET.s", "AG_GAME_LMARAIS.S", "AG_GAME_LMONTAGNES.S", "Ag_Game_LPLATEAUX.s", "Ag_Game_LFEUX.s"]

for fn in files:
    text = open(os.path.join(base, fn), encoding="latin-1").read()
    starts = re.findall(r"^\s*START_([ARC])\s+([A-Za-z0-9_]+)", text, re.M | re.I)
    waits = re.findall(r"^\s*WAIT\s+(\$?[0-9A-Fa-f]+)", text, re.M | re.I)
    kinds = collections.Counter(k.upper() for k, _ in starts)
    names = collections.Counter(n for _, n in starts)
    last_wait = waits[-1] if waits else "-"
    labels = re.findall(r"^([A-Za-z_][A-Za-z0-9_]*)\s*$", text, re.M)
    print(f"== {fn}: {len(starts)} Starts ({dict(kinds)}), {len(waits)} WAITs, letzter WAIT {last_wait}, {len(set(names))} verschiedene Objekte")
    print("   " + ", ".join(f"{n}×{c}" for n, c in names.most_common()))
    print("   Labels (Auswahl): " + ", ".join(labels[:25]))
