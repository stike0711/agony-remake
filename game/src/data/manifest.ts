// Format der Spieldaten, die die Asset-Pipeline (tools/pipeline/build-assets.ts) nach public/data/ schreibt.
// Wird von Pipeline und Spiel gemeinsam benutzt (die Pipeline importiert nur die Typen).
// Alle Farben sind Amiga-Farbwörter mit 12 Bit ($0RGB); umgerechnet wird erst beim Darstellen.

export const MANIFEST_FORMAT = 2;

/** Indiziertes Bild: Datei mit einem Byte Farbindex pro Pixel, zeilenweise. */
export interface ImageAsset {
  file: string;
  width: number;
  height: number;
  /** 12-Bit-Farben; bei `ehb` 32 Einträge, die Farben 32–63 ergeben sich als halbe Helligkeit */
  palette: number[];
  ehb?: boolean;
  /** Herkunft, z. B. "present $01548" */
  source: string;
}

/** Bitmap-Schrift: Bogen mit `count` Zeichen à `cellWidth` × `cellHeight`, nebeneinander, Index 1 = gesetzt. */
export interface FontAsset {
  file: string;
  cellWidth: number;
  cellHeight: number;
  count: number;
  /** Zeichen in Code-Reihenfolge (Code = Position); Leerzeichen wird nicht gezeichnet */
  chars: string;
  /** Vorschub je Zeichen ohne den zusätzlichen 1 Pixel Abstand */
  widths: number[];
  /** Zeile der Zelle, die der Zeichen-Zeile 0 des Originals entspricht (darüber Platz für Umlautpunkte) */
  originRow: number;
  /** Codes unterhalb dieser Zahl sind Originalzeichen, darüber per Skript ergänzte (Ä, Ö, Ü, Komma …) */
  originalCount: number;
  /** Originalzeichen: Anzahl der Zeilen ab `originRow`, die das Original tatsächlich zeichnet (20 von 21, O-003) */
  drawRows: number;
  source: string;
}

export interface TextLine {
  x: number;
  y: number;
  text: string;
}

/** 8-Bit-Sample (vorzeichenbehaftet, wie im Amiga-Speicher). */
export interface SampleAsset {
  file: string;
  /** Länge in Byte */
  length: number;
  source: string;
}

/** ProTracker-Modul unverändert aus der Spieldatei. */
export interface ModuleAsset {
  file: string;
  name: string;
  length: number;
  source: string;
}

/**
 * Speicherblock eines Levels: Bytes unverändert aus dem Level-Abbild, mit ihrer Originaladresse (E-032). Die
 * Level-Engine arbeitet wie das Original auf diesen Daten (planare Grafik, Copperlisten, Sprite-Listen, Tabellen).
 */
export interface MemoryAsset {
  file: string;
  /** Amiga-Adresse des ersten Bytes */
  address: number;
  length: number;
  source: string;
}

export interface HighscoreEntry {
  name: string;
  score: number;
}

export interface Manifest {
  format: typeof MANIFEST_FORMAT;
  /** SHA-1 der verwendeten Disketten-Abbilder */
  sources: { file: string; sha1: string }[];
  images: Record<string, ImageAsset>;
  fonts: Record<string, FontAsset>;
  /** Englische Originaltexte; Schlüssel siehe Wiki texte.md */
  texts: Record<string, TextLine[]>;
  samples: Record<string, SampleAsset>;
  modules: Record<string, ModuleAsset>;
  highscores: HighscoreEntry[];
  /** Tabellen aus den Spieldateien (Zahlenfolgen), z. B. Farben des Feuerbands */
  tables: Record<string, number[]>;
  /** Speicherblöcke der Level, Schlüssel „<level>.<block>“ (z. B. „sea.back“) */
  memory: Record<string, MemoryAsset>;
}
