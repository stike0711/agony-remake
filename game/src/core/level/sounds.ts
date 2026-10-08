// Soundeffekte im Level: Sound_Start ($5C12), Ag_Sounds.s ($348C) und Int4 ($5BD0). Ein Effekt läuft auf Kanal 0;
// ein neuer setzt sich nur durch, wenn seine Priorität (Tabelle a5 − $2FD8) nicht kleiner ist als die des laufenden.
// Stand: Nur der Zustand im Speicher (Sound0, Sound0_b, Priorität, Lautstärke) wie im Original; das Abspielen über
// Paula und das Ende per Audio-Interrupt (Int4 setzt Sound0_Last_Pri zurück) folgen mit dem Ton im Level.

import type { LevelEngine } from "./engine.ts";

/** Sound_Start: Effekt `req` mit Lautstärke `vol` anfordern (wie `move #req,Sound0_Req; move #vol,Sound0_Vol_Req; bsr`) */
export function soundStart(e: LevelEngine, req: number, vol: number): void {
  const { V, L, ram } = e;
  e.setW(V.sound0Req, req);
  e.setW(V.sound0VolReq, vol);
  const pri = ram.byte(L.soundPri + req);
  if (((pri << 24) >> 24) < ((e.b(V.sound0LastPri) << 24) >> 24)) return;
  e.setB(V.sound0LastPri, pri);
  e.setW(V.sound0, req);
  e.setW(V.sound0Vol, e.w(V.sound0VolReq));
}

/** Ag_Sounds.s im Hauptprogramm: angeforderten Effekt starten (Sound0 → Sound0_b → Kanal 0) */
export function sounds(e: LevelEngine): void {
  const { V } = e;
  if ((e.w(V.sound0b) & 0x8000) === 0) {
    e.setB(V.sound0b, 0xff);
    e.setW(V.sound0IntStep, 0);
  }
  const s = e.w(V.sound0);
  if ((s & 0x8000) === 0) {
    e.setB(V.sound0, 0xff);
    e.setW(V.sound0b, s);
  }
}
