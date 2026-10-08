"""Sucht die Angriffswellen-Startliste von Level 1 im entpackten Spielabbild (Agony.09 = sea) und dekodiert sie.
Voraussetzung: work/unpacked/Agony.09 (siehe wiki/setup.md, Abschnitt Analyse-Skripte).
Aufruf aus beliebigem Verzeichnis: python tools/analysis/startlist_level1.py

Kodierung laut Makros in Ag_Game_LMER.s:
  WAIT x          -> DC.W x
  START_A o,x,y   -> DC.L o+$40000000, DC.W x, DC.W y
  START_C o       -> DC.L o+$80000000, danach optional PAR (DC.W) / PAR_L (DC.L), Ende PAR_END (DC.W -1)
  START_R o       -> DC.L o
  SL_END          -> DC.W $7FFF
Erste Einträge im Quelltext:
  WAIT $40 / START_A Poisson_Bl_1,280+256,220+256
  WAIT $42 / START_A Poisson_Bl_3,260+256,230+256
  WAIT $50 / START_A Poisson_Bl_2,250+256,250+256
Die Level-Abbilder sind für Adresse $600 assembliert: Amiga-Adresse = Datei-Offset + $600.
"""
import re, struct, sys
from pathlib import Path
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben

PROJECT = Path(__file__).resolve().parents[2]
BASE = 0x600

data = (PROJECT / "work" / "unpacked" / "Agony.09").read_bytes()
pat = re.compile(
    rb"\x00\x40\x40(...)" + struct.pack(">HH", 280 + 256, 220 + 256) +
    rb"\x00\x42\x40(...)" + struct.pack(">HH", 260 + 256, 230 + 256) +
    rb"\x00\x50\x40(...)" + struct.pack(">HH", 250 + 256, 250 + 256),
    re.S,
)
hits = list(pat.finditer(data))
print(f"Treffer: {len(hits)}")
for m in hits:
    off = m.start()
    ptrs = [int.from_bytes(g, "big") for g in m.groups()]
    print(f"  Offset 0x{off:05x} (Adresse ${off + BASE:06x}): Zeiger Poisson_Bl_1=${ptrs[0]:06x}, "
          f"Poisson_Bl_3=${ptrs[1]:06x}, Poisson_Bl_2=${ptrs[2]:06x}")
    # Liste bis zum Ende dekodieren: WAIT-Wort, dann Start (Art über die oberen Bits des Zeigers)
    p, n, last_wait = off, 0, None
    kinds = {0: "R", 0x40: "A", 0x80: "C"}
    stats = {"A": 0, "C": 0, "R": 0}
    while p + 6 <= len(data):
        w = struct.unpack_from(">H", data, p)[0]
        if w == 0x7FFF:
            print(f"  Listenende (SL_END $7FFF) bei Offset 0x{p:05x}, {n} Einträge, letzter WAIT ${last_wait:04x}, Arten {stats}")
            break
        last_wait = w
        hi = data[p + 2]
        if hi not in kinds:
            print(f"  unerwartetes Startbyte ${hi:02x} bei Offset 0x{p + 2:05x} nach {n} Einträgen")
            break
        kind = kinds[hi]
        p += 2 + 4 + (4 if kind == "A" else 0)
        if kind in ("C", "R"):
            # optionale Parameterliste, abgeschlossen mit PAR_END = $FFFF
            q = p
            while q + 2 <= len(data) and struct.unpack_from(">H", data, q)[0] != 0xFFFF and q - p < 64:
                q += 2
            if q - p < 64 and struct.unpack_from(">H", data, q)[0] == 0xFFFF:
                p = q + 2
        n += 1
        stats[kind] += 1
