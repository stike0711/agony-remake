"""PowerPacker (PP20) Entpacker – Python-Port des bekannten ppDecrunch-Algorithmus (vgl. libxmp/ppdepack.c)."""
import struct, sys, os
sys.stdout.reconfigure(encoding="utf-8")  # Windows-Konsole (cp1252) kann z. B. „→“ nicht ausgeben


def pp20_unpack(packed: bytes) -> bytes:
    if packed[:4] != b"PP20":
        raise ValueError("kein PP20-Header")
    offset_lens = packed[4:8]
    src = packed[8:-4]
    dest_len = (packed[-4] << 16) | (packed[-3] << 8) | packed[-2]
    skip_bits = packed[-1]

    out = bytearray(dest_len)
    o = dest_len           # Ausgabe wird rückwärts gefüllt
    s = len(src)           # Eingabe wird rückwärts gelesen
    bit_buffer = 0
    bits_left = 0

    def read_bits(n):
        nonlocal bit_buffer, bits_left, s
        while bits_left < n:
            if s <= 0:
                raise ValueError("Eingabe zu kurz")
            s -= 1
            bit_buffer |= src[s] << bits_left
            bits_left += 8
        v = 0
        bits_left -= n
        for _ in range(n):
            v = (v << 1) | (bit_buffer & 1)
            bit_buffer >>= 1
        return v

    read_bits(skip_bits)
    written = 0
    while written < dest_len:
        if read_bits(1) == 0:
            todo = 1
            while True:
                x = read_bits(2)
                todo += x
                if x != 3:
                    break
            for _ in range(todo):
                o -= 1
                out[o] = read_bits(8)
                written += 1
            if written == dest_len:
                break
        x = read_bits(2)
        offbits = offset_lens[x]
        todo = x + 2
        if x == 3:
            if read_bits(1) == 0:
                offbits = 7
            offset = read_bits(offbits)
            while True:
                x = read_bits(3)
                todo += x
                if x != 7:
                    break
        else:
            offset = read_bits(offbits)
        if o + offset >= dest_len:
            raise ValueError("Match außerhalb des Puffers")
        for _ in range(todo):
            o -= 1
            out[o] = out[o + offset + 1]
            written += 1
    return bytes(out)


if __name__ == "__main__":
    src_dir, out_dir = sys.argv[1], sys.argv[2]
    os.makedirs(out_dir, exist_ok=True)
    for n in sorted(os.listdir(src_dir)):
        p = os.path.join(src_dir, n)
        if not os.path.isfile(p):
            continue
        data = open(p, "rb").read()
        if data[:4] != b"PP20":
            continue
        try:
            raw = pp20_unpack(data)
            open(os.path.join(out_dir, n), "wb").write(raw)
            print(f"{n:<10} {len(data):>8} -> {len(raw):>8}  (0x{len(raw):06x})  Kopf: {raw[:8].hex()}")
        except Exception as e:
            print(f"{n:<10} FEHLER: {e}")
