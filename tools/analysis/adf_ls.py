"""Minimaler AmigaDOS (OFS/FFS) Verzeichnis-Lister für ADF-Images."""
import struct, sys, os
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben

BS = 512

def blk(data, n):
    return data[n * BS:(n + 1) * BS]

def l(b, off):
    return struct.unpack(">I", b[off:off + 4])[0]

def sl(b, off):
    return struct.unpack(">i", b[off:off + 4])[0]

def name_of(b):
    ln = b[BS - 80]
    return b[BS - 79:BS - 79 + ln].decode("latin-1")

def walk(data, dirblock, prefix, out):
    d = blk(data, dirblock)
    for i in range(72):
        ptr = l(d, 24 + i * 4)
        while ptr:
            h = blk(data, ptr)
            sec = sl(h, BS - 4)
            nm = name_of(h)
            if sec == 2:  # ST_USERDIR
                out.append((prefix + nm + "/", None, ptr))
                walk(data, ptr, prefix + nm + "/", out)
            else:
                size = l(h, BS - 188)
                out.append((prefix + nm, size, ptr))
            ptr = l(h, BS - 16)  # hash chain

def read_file(data, hdr, fs_type):
    """Liest eine Datei (OFS: verkettete Datenblöcke mit 24-Byte-Header)."""
    h = blk(data, hdr)
    size = l(h, BS - 188)
    out = bytearray()
    if fs_type == 0:  # OFS
        nxt = l(h, 16)
        while nxt and len(out) < size:
            d = blk(data, nxt)
            dsz = l(d, 12)
            out += d[24:24 + dsz]
            nxt = l(d, 16)
    else:  # FFS
        ext = hdr
        while ext and len(out) < size:
            e = blk(data, ext)
            cnt = l(e, 8)
            for i in range(cnt):
                p = l(e, 24 + (71 - i) * 4)
                out += blk(data, p)
            ext = l(e, BS - 8)
    return bytes(out[:size])

if __name__ == "__main__":
    extract_to = sys.argv[2] if len(sys.argv) > 2 else None
    for path in sys.argv[1].split(";"):
        data = open(path, "rb").read()
        fs_type = data[3]
        root = blk(data, 880)
        if data[:3] != b"DOS" or l(root, 0) != 2:
            print(f"== {os.path.basename(path)}  kein AmigaDOS-Dateisystem (Bootblock {data[:4]!r})\n")
            continue
        print(f"== {os.path.basename(path)}  [{name_of(root)}]  {'OFS' if fs_type % 2 == 0 else 'FFS'}")
        entries = []
        try:
            walk(data, 880, "", entries)
        except Exception as e:
            print(f"   !! Fehler beim Lesen des Verzeichnisses: {e!r}")
        total = 0
        for nm, size, ptr in sorted(entries):
            if size is None:
                print(f"   {'<DIR>':>9}  {nm}")
            else:
                total += size
                try:
                    head = read_file(data, ptr, fs_type % 2)[:12]
                except Exception:
                    head = b"????"
                magic = bytes(c if 32 <= c < 127 else 46 for c in head).decode()
                print(f"   {size:>9}  {nm:<32} {head[:4].hex()}  '{magic}'")
                if extract_to:
                    dst = os.path.join(extract_to, os.path.splitext(os.path.basename(path))[0], nm)
                    os.makedirs(os.path.dirname(dst), exist_ok=True)
                    with open(dst, "wb") as f:
                        f.write(read_file(data, ptr, fs_type % 2))
        print(f"   Summe: {total} Bytes in {sum(1 for e in entries if e[1] is not None)} Dateien\n")
