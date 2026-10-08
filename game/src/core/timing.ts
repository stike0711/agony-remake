// Zeitbasis des Originals: PAL-Amiga. Alle Zeiten im Kern sind ganzzahlig (Bilder bzw. Farbtakte, E-020).

/** Farbtakt (Color Clock) eines PAL-Amiga in Hz; Paula zählt ihre Perioden in diesem Takt. */
export const PAULA_CLOCK_PAL = 3546895;

/** Farbtakte je Rasterzeile (PAL: immer 227). */
export const CC_PER_LINE = 227;

/** Rasterzeilen eines langen bzw. kurzen Halbbilds (Interlace wechselt zwischen beiden). */
export const LINES_LONG_FIELD = 313;
export const LINES_SHORT_FIELD = 312;

/** Dauer eines Bilds ohne Interlace in Farbtakten (≈ 49,92 Hz). */
export const CC_PER_FRAME = LINES_LONG_FIELD * CC_PER_LINE;
