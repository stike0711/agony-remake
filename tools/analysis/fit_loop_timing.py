"""Kalibrierung des Zeitmodells der Level-Hauptschleife (E-034, game/src/core/level/timing.ts).

Eingaben in work/captures/:
  level1_go.profile.json            Haltepunkte im Emulator (Wiki setup.md „Zeitprofil“): [Bild, PC, Zeile, Farbtakt]
  level1_go.work.json               Arbeit je Durchlauf im Nachbau und Bus-Belegung je Zeile im Startbild des
                                    Durchlaufs (game/test/tools/collect-loop-work.ts)
  level1_music_timing.profile.json  Laufzeit des Musiktreibers je Bild (Haltepunkte $43B4/$43BA)

Modell: Ab dem Schleifenstart verbrauchen Copperlisten-Update, vorderes und hinteres Scrollen Buszyklen. Jede
Rasterzeile hat 227 Zyklen, davon sind bus[Zeile] durch DMA belegt (Bitplanes, Sprites, Copper, Refresh, Audio);
der Rest steht Blitter und CPU zur Verfügung. Läuft die Arbeit über das Bildende, kommt der Vertical-Blank-Interrupt
mit dem Musiktreiber dazu (gemessene Laufzeit je Bild). Gesucht: Zeile von SEARCH SHORT PHASE ($147C).

Aufruf: python tools/analysis/fit_loop_timing.py [--detail Bild-von Bild-bis]
"""
import json, os, sys
from profile_hits import load_hits

C = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "work", "captures")
LINE, LINES = 227, 313
# gerade Buszyklen je Zeile (Prozessor, Blitter, Copper); die Bus-Belegung in den Daten zählt nur diese
EVEN = 113
FRAME = LINE * LINES
NAMES = ["COPPER_FULL", "COPPER_FRONT", "FRONT_STOPPED", "FRONT_IDLE", "FRONT_BLITS", "FRONT_PER_BLIT", "BACK_BASE",
         "BACK_PER_TILE", "BACK_PER_BLIT", "VBL"]


def music_durations():
    t0, dur = {}, {}
    for f, pc, v, h in json.load(open(os.path.join(C, "level1_music_timing.profile.json")))["hits"]:
        t = (f * LINES + v) * LINE + h
        if pc == 0x43B4:
            t0[f] = t
        elif pc == 0x43BA and f in t0:
            dur[f] = t - t0[f]
    return dur


def load():
    work = json.load(open(os.path.join(C, "level1_go.work.json")))
    starts, checks = [], []
    for f, pc, v, h in load_hits(os.path.join(C, "level1_go.profile.json")):
        t = (f * LINES + v) * LINE + h
        if pc == 0xAD8:
            starts.append(t)
        elif pc == 0x147C:
            checks.append(t)
    pairs = []
    for k, w in enumerate(work["loops"]):
        if k >= len(checks):
            break
        c = checks[k]
        s = max((x for x in starts if x < c), default=None)
        if s is not None:
            pairs.append((w, s, c))
    return pairs


PAIRS = load()
MUSIC = music_durations()


def advance(bus, t, units, per):
    """`units` Arbeit ab Zeitpunkt t (bus = belegte Zyklen je Zeile, per = Zyklen je Zeile dieser Art)"""
    while units > 0:
        line = int(t // LINE) % LINES
        free = (per - bus[line]) / per
        rest = LINE - t % LINE
        if units <= rest * free:
            return t + units / free
        units -= rest * free
        t += rest
    return t


EVEN_CPU = "--even" in sys.argv


def work(w, t, cpu, blit):
    """Blitter-Takte und Prozessorarbeit nacheinander, beide gegen alle freien Buszyklen. Mit --even die Prozessorarbeit
    gegen die freien geraden Zyklen (passt hier schlechter: rms 0,74 statt 0,43 Zeilen; vermutlich überlappen Prozessor
    und Blitter beim Scrollen)"""
    t = advance(w["bus"], t, blit, LINE)
    if EVEN_CPU:
        return advance(w["busEven"], t, cpu, EVEN)
    return advance(w["bus"], t, cpu, LINE)


def model(w, start, P):
    cf, cp, fstop, fidle, fbase, fpb, bbase, bpt, bpb, vbl = P
    t = start + (cf if w["copperFull"] else cp)
    if w["frontStopped"]:
        t += fstop
    elif w["frontBlits"] == 0:
        t += fidle
    else:
        t = work(w, t, fbase + fpb * w["frontBlits"], w["frontCycles"])
    frame_end = (t // FRAME + 1) * FRAME
    t2 = work(w, t, bbase + bpt * w["backTiles"] + bpb * w["backBlits"], w["backCycles"])
    if t2 >= frame_end:
        t2 = work(w, t2, vbl + MUSIC.get(int(frame_end // FRAME), 1116), 0)
    return t2


def evaluate(P, fixed_start=None, verbose=False, model_start=False):
    err, wrong = [], 0
    prev_m = prev_a = None
    for w, s, c in PAIRS:
        start = s if fixed_start is None else (s // FRAME) * FRAME + fixed_start
        if model_start:
            start = (s // FRAME) * FRAME + w["loopStart"]
        m = model(w, start, P)
        err.append((m - c) / LINE)
        vm = int(m // LINE) % LINES & 0xFF
        va = int(c // LINE) % LINES & 0xFF
        if prev_m is not None and ((vm <= prev_m) != (va <= prev_a)):
            wrong += 1
            if verbose:
                print("  falsch: Bild", int(c // FRAME), "Modell", vm, "gemessen", va, "vorher", prev_m, prev_a)
        prev_m, prev_a = vm, va
    return (sum(e * e for e in err) / len(err)) ** 0.5, wrong, max(abs(e) for e in err)


def fit(P):
    steps = [20, 10, 10, 20, 40, 5, 100, 20, 5, 100]
    for _ in range(6):
        for i in range(len(P)):
            best = evaluate(P)
            for d in (-4, -2, -1, 1, 2, 4):
                Q = P[:]
                Q[i] = max(0, P[i] + d * steps[i])
                r = evaluate(Q)
                if r[0] < best[0]:
                    best, P = r, Q
        steps = [max(1, s // 2) for s in steps]
    return P


def sections():
    """Je Durchlauf die gemessenen Zeitpunkte LOOP, FRONT, BACK, CHECK (gleiche Zuordnung wie PAIRS)"""
    ev = {0xAD8: [], 0xC2C: [], 0xEF4: [], 0x147C: []}
    for f, pc, v, h in load_hits(os.path.join(C, "level1_go.profile.json")):
        if pc in ev:
            ev[pc].append((f * LINES + v) * LINE + h)
    out = []
    for w, s, c in PAIRS:
        fr = min((x for x in ev[0xC2C] if s < x < c), default=None)
        bk = min((x for x in ev[0xEF4] if s < x < c), default=None)
        if fr and bk:
            out.append((w, s, fr, bk, c))
    return out


def fit_sections(P):
    """Konstanten je Abschnitt an dessen gemessene Dauer anpassen"""
    rows = sections()
    full = [fr - s for w, s, fr, bk, c in rows if w["copperFull"]]
    part = [fr - s for w, s, fr, bk, c in rows if not w["copperFull"]]
    P[0], P[1] = round(sum(full) / len(full)), round(sum(part) / len(part))
    stopped = [bk - fr for w, s, fr, bk, c in rows if w["frontStopped"]]
    idle = [bk - fr for w, s, fr, bk, c in rows if not w["frontStopped"] and w["frontBlits"] == 0]
    P[2], P[3] = round(sum(stopped) / len(stopped)), round(sum(idle) / len(idle))
    blits = [(w, bk - fr, fr) for w, s, fr, bk, c in rows if w["frontBlits"] > 0]

    def front_err(Q):
        e = [work(w, fr, Q[4] + Q[5] * w["frontBlits"], w["frontCycles"]) - fr - d for w, d, fr in blits]
        return sum(x * x for x in e)

    def back_err(Q):
        e = []
        for w, s, fr, bk, c in rows:
            frame_end = (bk // FRAME + 1) * FRAME
            t = work(w, bk, Q[6] + Q[7] * w["backTiles"] + Q[8] * w["backBlits"], w["backCycles"])
            if t >= frame_end:
                t = work(w, t, Q[9] + MUSIC.get(int(frame_end // FRAME), 1116), 0)
            e.append(t - c)
        return sum(x * x for x in e)

    for idx, err in (((4, 5), front_err), ((6, 7, 8, 9), back_err)):
        steps = {i: 64 for i in idx}
        for _ in range(10):
            for i in idx:
                best = err(P)
                for d in (-2, -1, 1, 2):
                    Q = P[:]
                    Q[i] = P[i] + d * steps[i]
                    r = err(Q)
                    if r < best:
                        best, P = r, Q
            steps = {i: max(1, s // 2) for i, s in steps.items()}
    return P


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    P = fit_sections([476, 119, 74, 181, 434, 34, 2319, 54, 22, 140])
    print("Durchläufe:", len(PAIRS))
    print("angepasst:", dict(zip(NAMES, [round(x) for x in P])))
    print("rms/falsch/max (gemessener Start):", evaluate(P, verbose=True))
    print("rms/falsch/max (Start fest 275/100):", evaluate(P, fixed_start=275 * LINE + 100))
    print("rms/falsch/max (Start aus dem Interrupt):", evaluate(P, model_start=True, verbose=True))
    starts = [(s - (s // FRAME) * FRAME) - w["loopStart"] for w, s, c in PAIRS]
    print("Schleifenstart Modell − gemessen: rms", round((sum(x * x for x in starts) / len(starts)) ** 0.5), "max", max(starts, key=abs))
    if "--detail" in sys.argv:
        a, b = (int(x) for x in sys.argv[sys.argv.index("--detail") + 1:][:2])
        for w, s, c in PAIRS:
            f = int(c // FRAME)
            if a <= f <= b:
                m = model(w, s, P)
                print(f, "gemessen", int(c % FRAME // LINE), int(c % LINE), "Modell", int(m % FRAME // LINE),
                      int(m % LINE), "Diff", round(m - c), "Kacheln", w["backTiles"], "Blits", w["backBlits"])
