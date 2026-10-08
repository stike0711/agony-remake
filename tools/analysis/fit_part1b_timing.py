"""Kalibrierung des Zeitmodells für Teil 1b der Level-Hauptschleife (game/src/core/level/timing.ts, ModelTiming).

Eingaben in work/captures/:
  level1_go.profile.json  Haltepunkte im Emulator: [Bild, PC, Zeile, Farbtakt] (Wiki setup.md „Zeitprofil“)
  level1_go.timing.json   Arbeit je Schritt von Teil 1b im Nachbau und Bus-Belegung je Bild
                          (game/test/tools/collect-timing.ts)
  level1_music_timing.profile.json  Laufzeit des Musiktreibers je Bild

Modell: Ab ALIEN BANK CTRL verbraucht jeder Schritt freie Buszyklen (227 je Zeile minus DMA) in Höhe von
Grundwert + Summe(Faktor · Arbeit). Fällt der Copper-Interrupt in die Zeit, kommt seine Dauer dazu, beim Bildwechsel
der Vertical-Blank-Interrupt mit dem Musiktreiber. Gesucht: je Schritt Grundwert und Faktoren (kleinste Quadrate),
danach die Trefferquote der Lage (vor/nach dem Interrupt, Zeile im übernächsten Bild).

Aufruf: python tools/analysis/fit_part1b_timing.py [--run <lauf>]   (Standard level1_go; Ausgabe <lauf>.part1b_fit.json)
"""
import json, os, sys
import numpy as np
from profile_hits import load_hits

sys.stdout.reconfigure(encoding="utf-8")
C = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "work", "captures")
LINE, LINES = 227, 313
# gerade Buszyklen je Zeile (Prozessor, Blitter, Copper); die Bus-Belegung in den Daten zählt nur diese
EVEN = 113
FRAME = LINE * LINES
WORK = ["aliens", "subs", "clipped", "tracks", "trackAliens", "startEntry", "palCopy", "palOverlays", "colAliens",
        "colRects", "routines", "chars", "clears", "colCompares", "colHits", "routineStart", "blitCycles", "blits",
        "irqIn", "vblIn"]
STEPS = ["objects", "play", "palette", "colision", "routines", "status", "text", "sounds"]
STEP_PCS = [[0x153C], [0x29D2], [0x2E82], [0x302C], [0x316E], [0x3194], [0x342E], [0x348C]]

RUN = sys.argv[sys.argv.index("--run") + 1] if "--run" in sys.argv else "level1_go"
prof_hits = load_hits(os.path.join(C, RUN + ".profile.json"))
data = json.load(open(os.path.join(C, RUN + ".timing.json")))
music = {}
t0 = {}
for f, pc, v, h in json.load(open(os.path.join(C, "level1_music_timing.profile.json")))["hits"]:
    t = (f * LINES + v) * LINE + h
    if pc == 0x43B4:
        t0[f] = t
    elif pc == 0x43BA and f in t0:
        music[f] = t - t0[f]

hits = [((f * LINES + v) * LINE + h, pc) for f, pc, v, h in prof_hits]
irqs = [(t, pc) for t, pc in hits if pc in (0x43C6, 0x5BC4)]
irq_start = [t for t, pc in irqs if pc == 0x43C6]
irq_end = [t for t, pc in irqs if pc == 0x5BC4]

# Durchläufe aus dem Profil: Zeitpunkte je Haltepunkt ab dem Schleifenstart
loops = []
cur = None
for t, pc in hits:
    if pc == 0xAD8:
        cur = {"start": t, "pc": {}}
        loops.append(cur)
    elif cur is not None:
        cur["pc"][pc] = t   # letzter Treffer je Haltepunkt (doppelt, wenn ein Interrupt genau dort ankam)
assert len(loops) >= len(data["loops"]), (len(loops), len(data["loops"]))


def bus_of(frame, key="busEven"):
    """Bus-Belegung des Bilds (Profilbild = Takt − 1): busEven = gerade Zyklen (Prozessor), bus = alle (Blitter)"""
    b = data[key]
    return b.get(str(frame + 1)) or b.get(str(frame)) or [0 if key == "busEven" else 8] * LINES


def free_between(a, b, key="busEven"):
    """Arbeitszeit zwischen den Zeitpunkten a und b in Farbtakten bei voller Geschwindigkeit: für den Prozessor
    zählen die freien geraden Zyklen (je Zeile 113 minus Copper und Bitplanes 5/6), für den Blitter alle freien"""
    total = 0.0
    t = a
    per = EVEN if key == "busEven" else LINE
    while t < b:
        frame, rest = divmod(t, FRAME)
        line = int(rest // LINE)
        bus = bus_of(frame, key)
        nxt = min(b, (t // LINE + 1) * LINE)
        total += (nxt - t) * (per - bus[line]) / per
        t = nxt
    return total


def advance(a, units, key):
    """Zeitpunkt nach `units` Arbeit ab a (Umkehrung von free_between)"""
    t = a
    per = EVEN if key == "busEven" else LINE
    while units > 0:
        frame, rest = divmod(t, FRAME)
        line = int(rest // LINE)
        free = (per - bus_of(frame, key)[line]) / per
        room = (LINE - rest % LINE) * free
        if units <= room:
            return t + units / free
        units -= room
        t = (t // LINE + 1) * LINE
    return t


RESTORE_CYCLES = 11520 * 2
VBL = int(sys.argv[sys.argv.index("--vbl") + 1]) if "--vbl" in sys.argv else 198


def interruptions(a, b, key="busEven"):
    """Dauer der Interrupts (Copper und VBL mit Musik) innerhalb von [a, b), in freien Buszyklen gerechnet wie Arbeit"""
    d = 0.0
    for s, e in zip(irq_start, irq_end):
        lo, hi = max(a, s), min(b, e)
        if lo < hi:
            d += free_between(lo, hi, key)
    for f in range(int(a // FRAME), int(b // FRAME) + 1):
        start = f * FRAME
        lo, hi = max(a, start), min(b, start + VBL + music.get(f, 1116))
        if lo < hi:
            d += free_between(lo, hi, key)
    return d


def step_times(L):
    """gemessene Zeitpunkte der Schritte; fehlende wie der nächste vorhandene"""
    out = [None] * len(STEP_PCS)
    nxt = None
    for s in range(len(STEP_PCS) - 1, -1, -1):
        t = next((L["pc"][pc] for pc in STEP_PCS[s] if pc in L["pc"]), None)
        out[s] = t if t is not None else nxt
        nxt = out[s]
    return out


# Stichproben: Arbeitszeit (freie Zyklen ohne Interrupts) je Schritt gegen dessen Arbeit
samples = {s: ([], []) for s in range(len(STEPS) - 1)}
for k, rec in enumerate(data["loops"]):
    L = loops[k]
    times = step_times(L)
    work = rec["work"]
    for s in range(len(STEPS) - 1):
        a, b = times[s], times[s + 1]
        if a is None or b is None or s >= len(work):
            continue
        # Fehlt Schritt s+1 im Profil, ist die Zeit 0 (nächster Schritt gleich) – dann nicht verwerten
        if b <= a:
            continue
        if s == 0:
            # Objekte: Blitter-lastig, gerechnet gegen alle freien Zyklen (der Blitter nutzt auch ungerade)
            units = free_between(a, b, "bus") - interruptions(a, b, "bus")
        else:
            units = free_between(a, b) - interruptions(a, b)
        row = list(work[s])
        if s == 0:
            # nur die Blits der Gegner: Zurücksetzen (9 Blits, 11.520 Wörter A→D) liegt vor ALIEN BANK CTRL
            row[WORK.index("blitCycles")] -= RESTORE_CYCLES
            row[WORK.index("blits")] -= 9
        if s == 1 and len(work) > 2:
            # Kopieren und Überlagern der Palette liegen vor $2E82, also noch in dieser Zeit
            for n in ("palCopy", "palOverlays"):
                row[WORK.index(n)] = work[2][WORK.index(n)]
        if s == 2:
            row = [0] * len(row)
        # Unterbrechung im Schritt: Mehrarbeit über ihre Dauer hinaus (z. B. wartet der nächste Blit auf den Prozessor)
        row = row[:len(WORK) - 2] + [1 if any(a <= x < b for x in irq_start) else 0,
                                     1 if int(a // FRAME) != int(b // FRAME) else 0]
        samples[s][0].append(row)
        samples[s][1].append(units)

coefs = {}
for s, (X, y) in samples.items():
    if len(y) < 5:
        continue
    X = np.array(X, float)
    y = np.array(y, float)
    cols = [i for i in range(X.shape[1]) if X[:, i].std() > 0]
    A = np.hstack([np.ones((len(y), 1)), X[:, cols]])
    c, *_ = np.linalg.lstsq(A, y, rcond=None)
    err = A @ c - y
    coefs[s] = (c[0], {WORK[i]: c[j + 1] for j, i in enumerate(cols)})
    print(f"{STEPS[s]:9s} → {STEPS[s + 1]:9s} n {len(y):3d} rms {np.sqrt((err ** 2).mean()):7.0f} max {abs(err).max():7.0f}"
          f"  Grund {c[0]:7.1f}  " + ", ".join(f"{WORK[i]} {c[j + 1]:.3f}" for j, i in enumerate(cols)))

json.dump({STEPS[s]: {"base": b, **f} for s, (b, f) in coefs.items()},
          open(os.path.join(C, RUN + ".part1b_fit.json"), "w"), indent=1)

if "--outliers" in sys.argv:
    for k, rec in enumerate(data["loops"]):
        L = loops[k]
        times = step_times(L)
        for s in range(len(STEPS) - 1):
            a, b = times[s], times[s + 1]
            if a is None or b is None or b <= a:
                continue
            if b - a > 30000:
                fa, ra = divmod(a, FRAME)
                fb, rb = divmod(b, FRAME)
                print(f"Durchlauf {k} Takt {rec['tick']}: {STEPS[s]} {fa}/{ra // LINE} → {STEPS[s + 1]} {fb}/{rb // LINE}")

if "--residuals" in sys.argv:
    s = STEPS.index(sys.argv[sys.argv.index("--residuals") + 1])
    base, fac = coefs[s]
    rows = []
    for k, rec in enumerate(data["loops"]):
        L = loops[k]
        times = step_times(L)
        a, b = times[s], times[s + 1]
        if a is None or b is None or b <= a or s >= len(rec["work"]):
            continue
        w = dict(zip(WORK, rec["work"][s]))
        pred = base + sum(c * w[n] for n, c in fac.items())
        units = free_between(a, b) - interruptions(a, b)
        irq_in = any(a <= x < b for x in irq_start)
        fe = int(a // FRAME) != int(b // FRAME)
        rows.append((units - pred, k, rec["tick"], irq_in, fe, divmod(a, FRAME)[1] // LINE, w))
    rows.sort(key=lambda r: -abs(r[0]))
    for r in rows[:15]:
        print(f"Rest {r[0]:7.0f} Durchlauf {r[1]} Takt {r[2]} IRQ {r[3]} Bildwechsel {r[4]} ab Zeile {r[5]}",
              {n: v for n, v in r[6].items() if v})
    import collections
    for key in ("irq", "fe"):
        g = collections.defaultdict(list)
        for r in rows: g[r[3] if key == "irq" else r[4]].append(r[0])
        print(key, {k: (len(v), round(sum(v) / len(v))) for k, v in g.items()})


def extra_fits():
    """Zurücksetzen (OBJ → BANK, Blitter), Prüfung → Objekte, Teil 2: Beginn nach Zeile $40 und Sprite-Liste"""
    restore, check_obj, wake, p2_afl = [], [], [], []
    for k, rec in enumerate(data["loops"]):
        L = loops[k]["pc"]
        if 0x149C in L and 0x153C in L:
            a, b = L[0x149C], L[0x153C]
            restore.append((free_between(a, b, "bus") - interruptions(a, b, "bus"),
                            1 if any(a <= x < b for x in irq_start) else 0, 1 if int(a // FRAME) != int(b // FRAME) else 0))
        if 0x147C in L and 0x149C in L:
            check_obj.append(L[0x149C] - L[0x147C])
        if 0x3514 in L and 0x348C in L:
            p2, snd = L[0x3514], L[0x348C]
            line64 = (int(p2 // FRAME)) * FRAME + 64 * LINE
            if snd < line64 - 2 * LINE:
                wake.append(p2 - line64)
        if 0x3514 in L and 0x3800 in L and len(rec["work"]) > 3:
            a, b = L[0x3514], L[0x3800]
            p2_afl.append((rec["work"][3][WORK.index("colAliens")], free_between(a, b) - interruptions(a, b)))
    m = lambda v: sum(v) / len(v)
    X = np.array([[1, i, v] for _, i, v in restore], float)
    y = np.array([u for u, _, _ in restore], float)
    c, *_ = np.linalg.lstsq(X, y, rcond=None)
    err = X @ c - y
    print(f"Zurücksetzen OBJ→BANK: Grund {c[0]:.0f}, Interrupt +{c[1]:.0f}, Vertical Blank +{c[2]:.0f}, "
          f"rms {np.sqrt((err ** 2).mean()):.0f}, n {len(y)}")
    print(f"Prüfung → Objekte: Mittel {m(check_obj):.0f} (Spanne {min(check_obj)}–{max(check_obj)})")
    print(f"Teil 2 nach Zeile $40: Mittel {m(wake):.0f} (Spanne {min(wake)}–{max(wake)}, n {len(wake)})")
    X = np.array([[1, a] for a, _ in p2_afl], float)
    y = np.array([u for _, u in p2_afl], float)
    c, *_ = np.linalg.lstsq(X, y, rcond=None)
    err = X @ c - y
    print(f"Teil 2 → Sprite-Liste: Grund {c[0]:.0f} + {c[1]:.1f} je Gegner, rms {np.sqrt((err ** 2).mean()):.0f}, n {len(y)}")


extra_fits()
