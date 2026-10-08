// PowerPacker-Daten (Kennung „PP20“) entpacken. Port von tools/analysis/pp20.py, das wiederum dem bekannten
// ppDecrunch-Algorithmus folgt (vgl. libxmp/ppdepack.c). Format siehe Wiki dateiformate.md, „PowerPacker (PP20)“.

export function isPowerPacked(data: Uint8Array): boolean {
  return data.length > 12 && data[0] === 0x50 && data[1] === 0x50 && data[2] === 0x32 && data[3] === 0x30;
}

export function unpackPP20(packed: Uint8Array): Uint8Array {
  if (!isPowerPacked(packed)) throw new Error("keine PP20-Daten");
  const offsetBits = packed.subarray(4, 8); // Bitbreiten der Offsets je Längenklasse
  const src = packed.subarray(8, packed.length - 4);
  const n = packed.length;
  const destLen = (packed[n - 4]! << 16) | (packed[n - 3]! << 8) | packed[n - 2]!;
  const skipBits = packed[n - 1]!;

  const out = new Uint8Array(destLen);
  let o = destLen; // Ausgabe wird von hinten nach vorne gefüllt
  let s = src.length; // Eingabe wird von hinten nach vorne gelesen
  let bitBuffer = 0;
  let bitsLeft = 0;

  const readBits = (count: number): number => {
    while (bitsLeft < count) {
      if (s <= 0) throw new Error("PP20: Eingabe zu kurz");
      s--;
      bitBuffer |= src[s]! << bitsLeft;
      bitsLeft += 8;
    }
    let v = 0;
    bitsLeft -= count;
    for (let i = 0; i < count; i++) {
      v = (v << 1) | (bitBuffer & 1);
      bitBuffer >>>= 1;
    }
    return v;
  };

  readBits(skipBits);
  let written = 0;
  while (written < destLen) {
    if (readBits(1) === 0) {
      // Literal-Folge, Länge in 2-Bit-Schritten
      let todo = 1;
      for (;;) {
        const x = readBits(2);
        todo += x;
        if (x !== 3) break;
      }
      for (let i = 0; i < todo; i++) {
        out[--o] = readBits(8);
        written++;
      }
      if (written === destLen) break;
    }
    // Kopie aus bereits Entpacktem
    const x = readBits(2);
    let bits = offsetBits[x]!;
    let todo = x + 2;
    let offset: number;
    if (x === 3) {
      if (readBits(1) === 0) bits = 7;
      offset = readBits(bits);
      for (;;) {
        const y = readBits(3);
        todo += y;
        if (y !== 7) break;
      }
    } else {
      offset = readBits(bits);
    }
    if (o + offset >= destLen) throw new Error("PP20: Kopie außerhalb des Puffers");
    for (let i = 0; i < todo; i++) {
      o--;
      out[o] = out[o + offset + 1]!;
      written++;
    }
  }
  return out;
}
