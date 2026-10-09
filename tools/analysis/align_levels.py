"""Richtet die Disassemblies zweier Level-Abbilder Befehl für Befehl aus (Analyse-Werkzeug).

Alle Level teilen den Code von Agony_Parent_.s und seinen Modulen; nur die Adressen von Daten, Variablen und
Routinen verschieben sich. Das Skript ordnet die Befehle per Folge der Befehlsnamen einander zu und gibt für jeden
Befehl des ersten Abbilds die Adresse und die Operanden des entsprechenden Befehls im zweiten Abbild aus.

Aufruf: python tools/analysis/align_levels.py <disasm A> <disasm B> [--out datei.tsv] [--diff]
  <disasm …>  Ausgaben von disasm68k.py (ohne --hex) über denselben Codebereich
  --out       Tabelle „Adresse A, Adresse B, Befehl A, Befehl B“ (Tabulator-getrennt)
  --diff      nur die nicht zugeordneten Abschnitte ausgeben (Unterschiede im Code)
"""
import argparse, difflib, re, sys
from pathlib import Path
sys.stdout.reconfigure(encoding="utf-8")

ap = argparse.ArgumentParser()
ap.add_argument("a")
ap.add_argument("b")
ap.add_argument("--out")
ap.add_argument("--diff", action="store_true")
args = ap.parse_args()

LINE = re.compile(r"^([0-9A-F]{6})  (\S+)\s*(.*)$")


def load(path):
    rows = []
    for line in Path(path).read_text(encoding="utf-8").splitlines():
        m = LINE.match(line)
        if m:
            ops = m.group(3).split(";")[0].strip()
            rows.append((int(m.group(1), 16), m.group(2), ops))
    return rows


def shape(ops):
    """Operanden ohne Zahlen: Registerform und Adressierungsart bleiben, Werte fallen weg"""
    return re.sub(r"-?\$[0-9a-fA-F]+|#?-?\d+", "N", ops)


A, B = load(args.a), load(args.b)
ka = [m + " " + shape(o) for _, m, o in A]
kb = [m + " " + shape(o) for _, m, o in B]
sm = difflib.SequenceMatcher(None, ka, kb, autojunk=False)
out = []
for tag, i1, i2, j1, j2 in sm.get_opcodes():
    if tag == "equal":
        for k in range(i2 - i1):
            a, b = A[i1 + k], B[j1 + k]
            out.append(f"{a[0]:06X}\t{b[0]:06X}\t{a[1]} {a[2]}\t{b[1]} {b[2]}")
    elif args.diff:
        print(f"--- {tag} A {A[i1][0]:06X}–{A[i2 - 1][0] if i2 > i1 else A[i1][0]:06X}"
              f" B {B[j1][0] if j1 < len(B) else 0:06X}–{B[j2 - 1][0] if j2 > j1 else 0:06X}")
        for a in A[i1:i2]:
            print(f"  A {a[0]:06X}  {a[1]} {a[2]}")
        for b in B[j1:j2]:
            print(f"  B {b[0]:06X}  {b[1]} {b[2]}")
if args.out:
    Path(args.out).write_text("\n".join(out) + "\n", encoding="utf-8")
    print(f"{len(out)} von {len(A)} Befehlen zugeordnet → {args.out}")
