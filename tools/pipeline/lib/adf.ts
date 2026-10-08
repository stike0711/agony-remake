// AmigaDOS-Disketten (ADF) lesen: Verzeichnisse durchlaufen und Dateien extrahieren, OFS und FFS.
// Port von tools/analysis/adf_ls.py. Aufbau siehe Wiki dateiformate.md, Abschnitt „AmigaDOS-Disketten (ADF)“.

const BLOCK = 512;
const ROOT_BLOCK = 880;
const ST_USERDIR = 2;

export interface AdfEntry {
  path: string; // z. B. "s/startup-sequence"
  size: number; // -1 bei Verzeichnissen
  headerBlock: number;
}

export class Adf {
  readonly volumeName: string;
  readonly isFfs: boolean;
  private readonly data: Uint8Array;
  private readonly view: DataView;

  constructor(data: Uint8Array) {
    if (data.length !== 1760 * BLOCK) throw new Error(`ADF hat ${data.length} Byte statt ${1760 * BLOCK}`);
    this.data = data;
    if (data[0] !== 0x44 || data[1] !== 0x4f || data[2] !== 0x53) throw new Error("kein AmigaDOS-Bootblock (DOS)");
    this.view = new DataView(data.buffer, data.byteOffset, data.byteLength);
    this.isFfs = (data[3]! & 1) === 1;
    if (this.long(ROOT_BLOCK, 0) !== 2) throw new Error("Root-Block nicht gefunden");
    this.volumeName = this.nameOf(ROOT_BLOCK);
  }

  private long(block: number, offset: number): number {
    return this.view.getUint32(block * BLOCK + offset);
  }

  private nameOf(block: number): string {
    const base = block * BLOCK;
    const len = this.data[base + BLOCK - 80]!;
    return String.fromCharCode(...this.data.subarray(base + BLOCK - 79, base + BLOCK - 79 + len));
  }

  /** Alle Einträge (Dateien und Verzeichnisse), rekursiv. */
  list(): AdfEntry[] {
    const out: AdfEntry[] = [];
    const walk = (dirBlock: number, prefix: string): void => {
      for (let i = 0; i < 72; i++) {
        let ptr = this.long(dirBlock, 24 + i * 4);
        while (ptr) {
          const name = prefix + this.nameOf(ptr);
          const secType = this.view.getInt32(ptr * BLOCK + BLOCK - 4);
          if (secType === ST_USERDIR) {
            out.push({ path: name + "/", size: -1, headerBlock: ptr });
            walk(ptr, name + "/");
          } else {
            out.push({ path: name, size: this.long(ptr, BLOCK - 188), headerBlock: ptr });
          }
          ptr = this.long(ptr, BLOCK - 16); // Hash-Kette
        }
      }
    };
    walk(ROOT_BLOCK, "");
    return out.sort((a, b) => a.path.localeCompare(b.path));
  }

  /** Dateiinhalt über den Header-Block. */
  read(entry: AdfEntry): Uint8Array {
    const size = entry.size;
    const out = new Uint8Array(size);
    let pos = 0;
    if (!this.isFfs) {
      // OFS: verkettete Datenblöcke mit 24 Byte Kopf (Nutzlänge bei 12, nächster Block bei 16)
      let next = this.long(entry.headerBlock, 16);
      while (next && pos < size) {
        const len = Math.min(this.long(next, 12), size - pos);
        out.set(this.data.subarray(next * BLOCK + 24, next * BLOCK + 24 + len), pos);
        pos += len;
        next = this.long(next, 16);
      }
    } else {
      // FFS: Blocknummern stehen rückwärts in Header- und Erweiterungsblöcken
      let ext = entry.headerBlock;
      while (ext && pos < size) {
        const count = this.long(ext, 8);
        for (let i = 0; i < count && pos < size; i++) {
          const blk = this.long(ext, 24 + (71 - i) * 4);
          const len = Math.min(BLOCK, size - pos);
          out.set(this.data.subarray(blk * BLOCK, blk * BLOCK + len), pos);
          pos += len;
        }
        ext = this.long(ext, BLOCK - 8);
      }
    }
    if (pos !== size) throw new Error(`${entry.path}: nur ${pos} von ${size} Byte gelesen`);
    return out;
  }

  /** Datei über ihren Pfad (Groß-/Kleinschreibung egal, wie bei AmigaDOS). */
  readFile(path: string): Uint8Array {
    const entry = this.list().find((e) => e.size >= 0 && e.path.toLowerCase() === path.toLowerCase());
    if (!entry) throw new Error(`Datei ${path} nicht auf ${this.volumeName}`);
    return this.read(entry);
  }
}
