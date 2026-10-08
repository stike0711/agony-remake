"""Sucht und dekodiert Copperlisten in einem Chip-RAM-Abzug (AG.dump → work/captures/*_chip.bin).

Aufruf: python tools/analysis/copper_scan.py work/captures/<name>_chip.bin [--min 20] [--show 1] [--at 0xADRESSE]
Eine Copperliste besteht aus Paaren von 16-Bit-Wörtern: MOVE (erstes Wort gerade = Registeradresse $020–$1FE)
oder WAIT/SKIP (erstes Wort ungerade). Ende: $FFFF,$FFFE.
"""
import argparse, struct, sys
from pathlib import Path
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben

REG = {
    0x08E: "DIWSTRT", 0x090: "DIWSTOP", 0x092: "DDFSTRT", 0x094: "DDFSTOP", 0x096: "DMACON",
    0x09A: "INTENA", 0x09C: "INTREQ", 0x100: "BPLCON0", 0x102: "BPLCON1", 0x104: "BPLCON2",
    0x108: "BPL1MOD", 0x10A: "BPL2MOD", 0x080: "COP1LCH", 0x082: "COP1LCL", 0x084: "COP2LCH", 0x086: "COP2LCL",
    0x088: "COPJMP1", 0x08A: "COPJMP2",
}
for i in range(6):
    REG[0x0E0 + i * 4] = f"BPL{i + 1}PTH"
    REG[0x0E2 + i * 4] = f"BPL{i + 1}PTL"
for i in range(8):
    REG[0x120 + i * 4] = f"SPR{i}PTH"
    REG[0x122 + i * 4] = f"SPR{i}PTL"
for i in range(32):
    REG[0x180 + i * 2] = f"COLOR{i:02d}"


def decode(mem: bytes, addr: int, limit: int = 4000):
    """Dekodiert ab addr bis zum Listenende; liefert Liste (adresse, art, a, b)."""
    out = []
    p = addr
    while p + 4 <= len(mem) and len(out) < limit:
        a, b = struct.unpack_from(">HH", mem, p)
        if a == 0xFFFF and b == 0xFFFE:
            out.append((p, "END", a, b))
            break
        if a & 1:
            out.append((p, "SKIP" if b & 1 else "WAIT", a, b))
        else:
            if not (0x020 <= a <= 0x1FE):
                out.append((p, "BAD", a, b))
                break
            out.append((p, "MOVE", a, b))
        p += 4
    return out


def fmt(entry):
    p, kind, a, b = entry
    if kind == "MOVE":
        return f"${p:06X}  MOVE {REG.get(a, f'${a:03X}'):<8} = ${b:04X}"
    if kind in ("WAIT", "SKIP"):
        return f"${p:06X}  {kind} V=${a >> 8:02X} H=${a & 0xFE:02X} (Maske ${b:04X})"
    return f"${p:06X}  {kind} {a:04X} {b:04X}"


def score(entries):
    """Grobe Plausibilität: viele MOVEs auf bekannte Register, sauberes Ende."""
    known = sum(1 for e in entries if e[1] == "MOVE" and e[2] in REG)
    return known + (20 if entries and entries[-1][1] == "END" else 0)


parser = argparse.ArgumentParser()
parser.add_argument("dump")
parser.add_argument("--min", type=int, default=20, help="Mindestzahl bekannter MOVEs")
parser.add_argument("--show", type=int, default=0, help="die besten N Listen vollständig ausgeben")
parser.add_argument("--at", help="nur die Liste ab dieser Adresse dekodieren")
args = parser.parse_args()
mem = Path(args.dump).read_bytes()

if args.at:
    for e in decode(mem, int(args.at, 0)):
        print(fmt(e))
    raise SystemExit

# Kandidaten: Startpunkte, an denen eine plausible Liste beginnt (nicht mitten in einer anderen)
cands = []
covered = set()
for addr in range(0, len(mem) - 8, 2):
    if addr in covered:
        continue
    a = struct.unpack_from(">H", mem, addr)[0]
    if a not in REG:
        continue
    entries = decode(mem, addr)
    s = score(entries)
    if s >= args.min:
        cands.append((s, addr, entries))
        covered.update(e[0] for e in entries)
cands.sort(key=lambda c: -c[0])
for s, addr, entries in cands[:40]:
    kinds = {}
    for e in entries:
        kinds[e[1]] = kinds.get(e[1], 0) + 1
    bpl = [f"{REG[e[2]]}=${e[3]:04X}" for e in entries if e[1] == "MOVE" and 0x0E0 <= e[2] <= 0x0EE][:12]
    print(f"${addr:06X}  Punkte {s:4}  {kinds}  {' '.join(bpl)}")
for s, addr, entries in cands[: args.show]:
    print(f"\n=== Liste ab ${addr:06X} ===")
    for e in entries:
        print(fmt(e))
