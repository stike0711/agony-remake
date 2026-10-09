"""Überträgt ein Level-Layout aus layout.ts auf ein anderes Level-Abbild (Analyse-Werkzeug).

Alle Level teilen den Code von Agony_Parent_.s; nur Operanden (Daten- und Variablenadressen) verschieben sich. Das
Skript richtet die Disassemblies des bekannten Levels A und des neuen Levels B wie align_levels.py aus, sammelt aus
jedem zugeordneten Befehlspaar die Operanden (absolute Adressen, Direktwerte, Versätze zu a5) und übersetzt damit jeden
Zahlenwert des Layouts von A. Variablen (`vars`) sind Versätze zu a5, alle anderen Werte absolute Adressen; ein
Versatz zu a5 zählt dabei auch als absolute Adresse D + Versatz.

Aufruf: python tools/analysis/derive_layout.py <disasm A> <disasm B> <layout.ts> <NAME A> [--end 0x5E1E]
  <disasm …>  Ausgaben von disasm68k.py über denselben Codebereich (ab $600)
  <NAME A>    Name des Layouts von A in layout.ts, z. B. FOREST
  --end       nur Befehle unterhalb dieser Adresse von A (Ende des gemeinsamen Codes, danach Musiktreiber/Daten)
Ausgabe: je Wert „Schlüssel: A → B“ mit Kennzeichen: = eindeutig, ~ über den nächsten bekannten Wert (Abstand gleich
angenommen, prüfen), ? nicht gefunden oder mehrdeutig (von Hand bestimmen).
"""
import argparse, difflib, re, sys
from collections import defaultdict
from pathlib import Path
sys.stdout.reconfigure(encoding="utf-8")

ap = argparse.ArgumentParser()
ap.add_argument("a")
ap.add_argument("b")
ap.add_argument("layout")
ap.add_argument("name")
ap.add_argument("--end", type=lambda s: int(s, 0), default=0x5E1E)
ap.add_argument("--emit", help="übertragenes Layout als TypeScript-Block in diese Datei (ohne Kommentare und Routinen)")
ap.add_argument("--compare", help="Name eines vorhandenen Layouts von B: nur Abweichungen davon ausgeben (Selbsttest)")
args = ap.parse_args()

LINE = re.compile(r"^([0-9A-F]{6})  (\S+)\s*(.*)$")
NUM = re.compile(r"(#?)(-?)\$([0-9a-fA-F]+)(\.l)?(\((a\d|pc)[^)]*\))?")


def load(path, end=None):
    rows = []
    for line in Path(path).read_text(encoding="utf-8").splitlines():
        m = LINE.match(line)
        if m:
            addr = int(m.group(1), 16)
            if end is not None and addr >= end:
                continue
            rows.append((addr, m.group(2), m.group(3).split(";")[0].strip()))
    return rows


def shape(ops):
    return re.sub(r"-?\$[0-9a-fA-F]+|#?-?\d+", "N", ops)


def tokens(ops):
    """Zahlen eines Operanden: (Art, Wert); Art = "a5" (Versatz zu a5), "abs" (Adresse/Direktwert), "reg" (sonst)"""
    out = []
    for m in NUM.finditer(ops):
        v = int(m.group(3), 16) * (-1 if m.group(2) else 1)
        base = m.group(6)
        kind = "a5" if base == "a5" else "reg" if base else "abs"
        out.append((kind, v))
    return out


A = load(args.a, args.end)
B = load(args.b)
ka = [m + " " + shape(o) for _, m, o in A]
kb = [m + " " + shape(o) for _, m, o in B]
pairs = []
for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, ka, kb, autojunk=False).get_opcodes():
    if tag == "equal":
        pairs += [(A[i1 + k], B[j1 + k]) for k in range(i2 - i1)]

# D = a5 aus „lea.l $XXXXXX.l, a5“ (bei $61E)
def find_d(rows):
    for _, m, o in rows:
        if m == "lea.l" and o.endswith("a5") and ".l" in o:
            return tokens(o)[0][1]
    raise SystemExit("lea …,a5 nicht gefunden")

DA, DB = find_d(A), find_d(B)
off_map, abs_map = defaultdict(set), defaultdict(set)
for (_, _, oa), (_, _, ob) in pairs:
    ta, tb = tokens(oa), tokens(ob)
    if len(ta) != len(tb):
        continue
    for (kind, va), (_, vb) in zip(ta, tb):
        if kind == "a5":
            off_map[va].add(vb)
            abs_map[DA + va].add(DB + vb)
        elif kind == "abs":
            abs_map[va].add(vb)

# Layout aus layout.ts: Block „export const NAME: LevelLayout = { … };“
text = Path(args.layout).read_text(encoding="utf-8")
VAL = re.compile(r"-?0x[0-9a-fA-F]+|-?\b\d+\b")
ENTRY = re.compile(r"(\w+): (\[\s*\[.*?\]\s*\](?=,)|\[[^\[\]]*\]|-?0x[0-9a-fA-F]+|-?\d+)(?=[,\s])", re.S)


def block(name):
    m = re.search(rf"export const {name}: LevelLayout = \{{(.*?)\n\}};", text, re.S)
    if not m:
        raise SystemExit(f"Layout {name} nicht gefunden")
    body = re.sub(r"[ \t]*//[^\n]*", "", m.group(1))
    body = re.sub(r"routines: new Map.*?\]\),", "routines: new Map<number, RoutineDef>([]),", body, flags=re.S)
    return re.sub(r"\n\s*\n", "\n", body)


def sections(body):
    """(vars, übriges Layout) ohne Kommentare und ohne die levelspezifischen Routinen"""
    vm = re.search(r"\n  vars: \{(.*?)\n  \},", body, re.S)
    return (vm.group(1), body.replace(vm.group(1), "")) if vm else ("", body)


def entries(src):
    return {e.group(1): [int(x, 0) for x in VAL.findall(e.group(2))] for e in ENTRY.finditer(src)}


def translate(v, mp):
    s = mp.get(v)
    if s and len(s) == 1:
        return next(iter(s)), "="
    if s:
        return None, "? mehrdeutig " + ", ".join(hex(x) for x in sorted(s))
    # nächster eindeutig bekannter Wert in der Nähe
    near = [k for k, t in mp.items() if len(t) == 1 and abs(k - v) <= 0x100]
    if near:
        k = min(near, key=lambda k: abs(k - v))
        return next(iter(mp[k])) + (v - k), f"~ über {hex(k)}"
    return None, "? nicht gefunden"


def h(v):
    return ("-" if v < 0 else "") + "0x" + format(abs(v), "x")


body = block(args.name)
vars_body, rest = sections(body)
expected = {}
if args.compare:
    cv, cr = sections(block(args.compare))
    expected = {**{"vars." + k: v for k, v in entries(cv).items()}, **entries(cr)}

print(f"D: {h(DA)} → {h(DB)}; {len(pairs)} Befehle zugeordnet ({len(A)} in A unter {h(args.end)})")
emitted = {}
for section, src, mp, skip_small in (("vars", vars_body, off_map, False), ("Layout", rest, abs_map, True)):
    print(f"\n# {section}")
    out = src
    for e in ENTRY.finditer(src):
        key = e.group(1)
        vals = [int(x, 0) for x in VAL.findall(e.group(2))]
        res = []
        for v in vals:
            if skip_small and 0 <= v < 0x100:
                res.append((v, "~ Konstante übernommen, prüfen"))
            else:
                res.append(translate(v, mp))
        flag = " ".join(sorted({r[1][0] for r in res}))
        raw = "[" + ", ".join(h(v) for v in vals) + "]" if len(vals) != 1 else h(vals[0])
        shown = ", ".join("?" if r[0] is None else h(r[0]) for r in res)
        notes = "; ".join(r[1] for r in res if r[1] != "=")
        # Werte im Text ersetzen (übernommene Konstanten in ihrer Schreibweise, nicht gefundene als 0 /* ? */)
        it = iter(res)

        def subst(m):
            r = next(it)
            if r[0] is None:
                return "0 /* ? */"
            return m.group(0) if r[1].startswith("~ Konstante") else h(r[0])
        out = out.replace(e.group(0), VAL.sub(subst, e.group(0)), 1)
        if args.compare:
            want = expected.get(("vars." if section == "vars" else "") + key)
            if want == [r[0] for r in res]:
                continue
            notes += f"  ≠ {args.compare}: " + ("fehlt" if want is None else ", ".join(h(v) for v in want))
        if flag != "=" or args.compare:
            print(f"{flag} {key}: {raw} → {shown}" + (f"  [{notes}]" if notes else ""))
    emitted[section] = out
if args.emit:
    ts = emitted["Layout"].replace("\n  vars: {\n  },", "\n  vars: {" + emitted["vars"] + "\n  },", 1)
    Path(args.emit).write_text(f"export const {args.name}_TO_B: LevelLayout = {{{ts}\n}};\n", encoding="utf-8")
    print(f"\nLayout → {args.emit}")
