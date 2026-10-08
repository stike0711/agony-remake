# Dateiformate

Stand: 06.10.2026 · Legende: ✔ belegt · 🌐 nur Web-Recherche · ❓ Vermutung/ungeklärt

Wo nicht anders markiert, sind die Angaben auf dieser Seite an Spieldaten oder Quellcode geprüft (✔).

## Datenquellen im Überblick

| Quelle | Ort | Rolle |
|---|---|---|
| Spieldisketten (Crack „Crystal“) | `reference/agony/game/Agony/agony-{1,2,3}.adf` | **Hauptquelle** für alle Spieldaten; vollständig ✔ |
| Grolets fertige Spieldateien | `reference/source/…/Corupted system HDD partition partialy restored/ag/` | gleiche Dateien in etwas anderer Revision, anderer Packer |
| Original-Quellcode | `reference/source/YvesGrolet-sources/` | erklärt Aufbau und Bedeutung der Daten |
| Rips, Screenshots, MP3s | `reference/agony/gfx/`, `reference/agony/music/` | nur Orientierung, lückenhaft |

## AmigaDOS-Disketten (ADF)

- 880-KB-Image: 1760 Blöcke à 512 Byte, Root-Block bei Block 880.
- Die Spieldisketten nutzen das alte Dateisystem OFS (Bootblock `DOS\0`): Jeder Datenblock hat 24 Byte Kopf
  (u. a. Nummer, Nutzlänge, nächster Block) und 488 Byte Nutzdaten.
- Datei-Header-Blöcke enthalten Name (ab Offset 432), Größe (Offset 324) und den ersten Datenblock (Offset 16);
  Verzeichnisse verteilen ihre Einträge über eine Hash-Tabelle mit 72 Einträgen, Kollisionen über eine Kette.
- Werkzeug: `tools/analysis/adf_ls.py` (listet und extrahiert OFS/FFS), siehe [Setup](setup.md#analyse-skripte).

## Die Spieldisketten

| Disk | Volume | Dateien |
|---|---|---|
| 1 | `AGONY  (1/3)` | `Crystal` (6.276 Byte, Amiga-Programm), `s/startup-sequence`, `Agony.01`–`.03` |
| 2 | `AGONY  (2/3)` | `Agony.00` (48 Byte), `Agony.07`–`.0C` |
| 3 | `AGONY  (3/3)` | `Agony.0F`–`.14` |

- `s/startup-sequence` enthält die eine Zeile `Crystal strikes again!`: Sie startet das Programm `Crystal` (den
  Lader der Crack-Fassung) mit diesen Wörtern als Argument.
- Beim Start zeigt die Crack-Fassung zwei Intro-Seiten der Gruppe Crystal (im Emulator beobachtet).
- Die Nummer `xx` in `Agony.xx` ist die Dateinummer aus der Original-Ladetabelle (siehe unten).

## PowerPacker (`PP20`)

Alle `Agony.xx` außer `Agony.00` sind mit PowerPacker gepackt:

| Bereich | Inhalt |
|---|---|
| Byte 0–3 | Kennung `PP20` |
| Byte 4–7 | „Effizienz“-Tabelle: Bitbreiten der Offsets für die vier Längenklassen |
| Byte 8 … Ende−4 | gepackter Bitstrom, wird **von hinten nach vorne** gelesen |
| letzte 4 Byte | entpackte Länge (24 Bit, big-endian) + Anzahl zu überspringender Bits |

Das Entpacken schreibt den Ausgabepuffer ebenfalls von hinten nach vorne: abwechselnd Literal-Folgen (Länge in
2-Bit-Schritten) und Kopien aus bereits Entpacktem (Länge 2–5 bzw. länger, Offset mit 7 oder tabellierter Bitbreite).
Werkzeug: `tools/analysis/pp20.py` (Python-Port des bekannten `ppDecrunch`-Algorithmus).

## Entpackte Spieldateien

Ergebnis von `pp20.py` (in `work/unpacked/`), verglichen mit Grolets Dateien in `ag/`. Deren erstes Langwort ist die
entpackte Größe; bei `present` stimmt es exakt.

| Crack | Original | gepackt | entpackt | `ag/` | Differenz |
|---|---|---|---|---|---|
| `Agony.01` | `present` | 210.820 | 419.208 (`$066588`) | `$066588` | 0 |
| `Agony.02` | `fire` | 221.904 | 395.048 (`$060728`) | `$060798` | 112 |
| `Agony.03` | `ending` | 120.608 | 330.564 (`$050B44`) | `$050B64` | 32 |
| `Agony.07` | `igt` | 175.772 | 272.336 (`$0427D0`) | `$0427F8` | 40 |
| `Agony.08` | `load_sea` | 69.156 | 106.936 (`$01A1B8`) | `$01A1D8` | 32 |
| `Agony.09` | `sea` | 235.256 | 393.656 (`$0601B8`) | `$060228` | 112 |
| `Agony.0A` | `load_forest` | 66.428 | 99.964 (`$01867C`) | `$018698` | 28 |
| `Agony.0B` | `forest` | 211.532 | 373.984 (`$05B4E0`) | `$05B550` | 112 |
| `Agony.0C` | `load_marshes` | 78.044 | 106.020 (`$019E24`) | `$019E44` | 32 |
| `Agony.0F` | `marshes` | 209.908 | 393.012 (`$05FF34`) | `$05FFA4` | 112 |
| `Agony.10` | `load_mountains` | 64.444 | 109.072 (`$01AA10`) | `$01AA2C` | 28 |
| `Agony.11` | `mountains` | 215.548 | 378.248 (`$05C588`) | `$05C5F8` | 112 |
| `Agony.12` | `load_highlands` | 53.304 | 108.336 (`$01A730`) | `$01A74C` | 28 |
| `Agony.13` | `highlands` | 197.216 | 392.208 (`$05FC10`) | `$05FC80` | 112 |
| `Agony.14` | `load_fire` | 69.584 | 111.388 (`$01B31C`) | `$01B33C` | 32 |

- Die Differenzen sind systematisch (alle Level 112 Byte) → vermutlich eine leicht andere Code-Revision der
  gemeinsamen Engine, keine fehlenden Daten ❓.
- Die entpackten Dateien sind **rohe Speicherabbilder** ohne Hunk-Struktur. Fast alle beginnen mit demselben Code
  (`2F00 2039 00DF F004` = `move.l d0,-(sp)` / `move.l $DFF004,d0`), nur `igt` beginnt anders.
- **Level-Abbilder sind für Adresse `$600` assembliert:** Amiga-Adresse = Datei-Offset + `$600`. Belegt über die
  Zeiger in der Startliste von Level 1 (siehe unten) ✔. Passt zum Schalter `Asm_Absolute` mit `ORG $600` in
  `Agony_Parent_.s`.
- Am Level-Ende lädt das Hauptmodul die nächste Datei nach `Load_Buffer`, legt `$61500` (nach Level 6: `$600`) auf
  den Stack und springt nach `$80` ✔. Bei `$80` liegt die Entpackroutine, die anschließend die neue Datei startet.
  Die Ladebild-Dateien laufen bei `$61500`, alle anderen bei `$600` ✔ (siehe [Ladeadressen](#ladeadressen)).

### Inhalt der Dateien

| Datei | Inhalt | Beleg |
|---|---|---|
| `present` | Titelsequenz (Logos, Sample-Klänge), danach „Insert Disk 2“ | ✔ Emulator, Disassembly |
| `igt` | Menü mit dem Bild des brennenden Baums, Abspann, Highscore; wird nach der Präsentation und nach Game Over geladen | ✔ Emulator, Quellcode, Disassembly |
| `load_<level>` | Ladebild und Lademusik; lädt und entpackt währenddessen das Level | ✔ Emulator, Disassembly (`load_sea`) |
| `<level>` | Engine + Leveldaten (Grafik, Wellen, Musik) für genau ein Level | ✔ Quellcode (`Asm_Level`) |
| `ending` | Spielende | ✔ Quellcode |

## Ladeadressen

| Datei | Lade- und Startadresse | Beleg |
|---|---|---|
| `present`, `igt`, Level (`sea` …), vermutlich `fire`, `ending` | `$600` | Speicherabzüge: `present` und `igt` liegen ab `$600` Byte für Byte im Speicher; Level über die Zeiger der Startliste |
| `load_<level>` (Ladebilder) | `$61500` | `igt` lädt `load_sea` nach `$61500` und springt dorthin (`jmp $61500`); Speicherabzug bestätigt |

- Allgemein: Amiga-Adresse = Datei-Offset + Ladeadresse.
- Verfahren: Speicherabzug im Emulator → `tools/analysis/copper_scan.py` findet die Copperliste → Bitplane-Zeiger →
  `tools/analysis/find_in_file.py` sucht die Bytes in der Datei (siehe [Setup](setup.md#analyse-skripte)).
- Korrektur 06.10.2026: Früher stand hier für `igt` die Ladeadresse `$014526`. Das war ein Fehlschluss: Das Menübild
  wird zur Laufzeit in einen Puffer bei `$42DCC` kopiert, und nur dieser Puffer war im Abzug gefunden worden.

## Gemeinsame Variablen (`$1B0`)

Menü, Ladebilder und Level tauschen Daten über einen festen Block ab `$1B0` aus (`DISK/load.s`, Abschnitt
„RESIDENT LABEL“) ✔:

| Adresse | Name | Größe | Bedeutung |
|---|---|---|---|
| `$1B0` | `Mem_Config` | L | Speicherausbau |
| `$1B4` | `Score` | L | Punkte (das Menü vergleicht damit die Highscores) |
| `$1B8` | `Life` | W | Leben als Bitmaske, Start `%111` |
| `$1BA` | `Axe_Up_On` | W | obere Axt aktiv |
| `$1BC` | `Axe_Down_On` | W | untere Axt aktiv |
| `$1BE` | `Fw_Fire_Weapon` | W | Stufe der Schusswaffe (0–3) |
| `$1C0` | `Extra_Life` | L | |
| `$1C4` | `Spell_Advailable` | 8 × W | verfügbare Zauber |
| `$1D4` | `Spell_Next_Bonus` | W | |
| `$1D6` | `Audio_Mode` | W | |
| `$1D8` | `Sheet_flag` | W | Cheat-Modus (wird im Menü mit „FANTASY“ gesetzt) |
| `$1DA` | `Curent_cl` | L | aktuelle Copperliste |
| `$1DE` | `Cop1lc_Bak` | L | |
| `$1E2` | `Menu_Mode` | L | |

Beim Spielstart setzt das Menü `Score` = 0, `Life` = 7 und löscht `$1BA`–`$1D5`; `Audio_Mode` und `Sheet_flag` bleiben
erhalten.

## Menü (`igt`)

Läuft bei `$600` (Adresse = Offset + `$600`). Code disassembliert in `work/disasm/igt_code.txt`.

| Datei-Offset | Adresse | Inhalt | Format |
|---|---|---|---|
| `0x0000` | `$000600` | Code (Hauptschleife, Textausgabe, Highscore, Interrupts, Lader der Crack-Fassung) | 68000 |
| `0x2AE4` | `$0030E4` | ProTracker-Modul „mod.agony intro“ (Menümusik), 179.650 Byte, 17 Patterns | `M.K.` |
| `0x2E8A6` | `$02EEA6` | Menübild | 352 × 290, 6 Bitplanes nacheinander (je 44 Byte × 290 Zeilen = 12.760 Byte), Extra-Halfbrite |
| `0x413B6` | `$0419B6` | Palette des Menübilds | 32 Farbwörter `$0RGB`; Farben 32–63 = halbe Helligkeit |
| `0x413F6` | `$0419F6` | Zeiger auf hinteren/vorderen Bildpuffer, Bildzähler, Highscore-Tabelle (`$41A36`, wie `Agony.00`) … | Variablen |
| `0x4140A` | `$041A0A` | Tastaturtabelle für die Namenseingabe: Amiga-Tastencode `$10`–`$37` → Buchstabe 1–26, `$FF` = keiner | 40 Byte |
| `0x414AE` | `$041AAE` | Copperliste (Bitplane-Zeiger, Bildfenster, Palette wird beim Einblenden eingetragen) | Copper |
| `0x415B6` | `$041BB6` | **Schrift** (siehe unten) | 42 Zeichen × 84 Byte |
| `0x4237E` | `$04297E` | Breitentabelle der Schrift | 42 Byte |
| `0x423A8` | `$0429A8` | Seitentabelle: 15 Wort-Offsets relativ zu `$0429A8` | |
| `0x423D0` | `$0429D0` | Texttabelle, 15 Seiten bis Dateiende `0x427D0` | siehe unten |

Zur Laufzeit ✔:

- Das Bild wird in zwei Puffer kopiert, `$42DCC` und `$558DC` (direkt hinter dem Dateiende). Eine Abspann-Seite wird
  in den gerade unsichtbaren Puffer gezeichnet, dann schaltet die Copperliste um (Doppelpufferung). „Text aus“ =
  sauberes Bild in den hinteren Puffer kopieren und umschalten.
- Copperliste: `BPLCON0 = $6200`, `DIWSTRT $2071`, `DIWSTOP $42D1`, `DDFSTRT $30`, `DDFSTOP $D8`.
- Die Kopierschleife kopiert 76.548 statt 76.560 Byte: Die letzten 12 Byte von Plane 6 (Bildzeile 289) bleiben
  unverändert. Zeile 289 liegt außerhalb des sichtbaren PAL-Bilds, die Eigenheit ist unsichtbar.
- Prüfung: Das mit `tools/analysis/planar.py` aus der Datei dekodierte Bild stimmt mit der Emulator-Aufnahme in allen
  sichtbaren Zeilen pixelgenau überein (`compare_capture.py`, 100,00 %).

### ProTracker-Abspieler

In `igt` ✔ (in `load_sea` dieselbe Routine, alle Adressen + `$60158`; Beschreibung in
[Audio](original/audio.md#protracker-abspieler-menü-und-ladebilder)):

| Adresse | Inhalt |
|---|---|
| `$1DDA` / `$1E70` | `mt_init` / `mt_music` |
| `$2AEA` | Funk-Tabelle (16 Byte) |
| `$2AFA` | Vibrato-Sinus (32 Byte) |
| `$2B1A` | Periodentabelle: 16 Finetunes × 36 Wörter (856 … 113) |
| `$2F9A` | 4 Kanäle à 44 Byte (ProTracker-Aufbau: `n_note` +0, `n_cmd` +2, `n_start` +4, `n_length` +8, `n_loopstart` +$A, `n_replen` +$E, `n_period` +$10, `n_finetune` +$12, `n_volume` +$13, `n_dmabit` +$14 …) |
| `$304A` | Startadressen der 31 Samples |
| `$30C6` | Zeiger aufs Modul; `$30CA` Tempo, `$30CB` Zähler, `$30CC` Songposition, `$30CD` Break-Position, `$30CE`/`$30CF` Sprung-/Break-Flag, `$30D0` LowMask, `$30D1`/`$30D2` Pattern-Delay, `$30D4` Patternposition, `$30D6` DMA-Bits |
| `$30D8` | von den Effekten gesetzte Lautstärke (−1 = keine) |
| `$30DA`–`$30E0` | Lautstärke je Kanal vor der Gesamtlautstärke |
| `$30E2` | Gesamtlautstärke (Menü/Ladebild: 64, Ausblenden −2 je Bild) |
| `$30E4` | Modul |

Weitere Variablen des Menüs: `$41A04` Bildzähler der Warteschleifen, `$41A06` verzögertes Umschalten auf das
Originalbild (in `igt` nie gesetzt), `$41A08` Feuer gedrückt.

### Schrift des Menüs

- 42 Zeichen, Codes `$00`–`$29`: `A`–`Z` (`$00`–`$19`), `0`–`9` (`$1A`–`$23`), `.` `:` `(` `)` (`$24`–`$27`), Pfeil
  `◄` (`$28`, Löschzeichen der Namenseingabe), Leerzeichen (`$29`, wird nicht gezeichnet). **Kein** Komma,
  Bindestrich, `!` oder `?`.
- Je Zeichen 84 Byte = 21 Zeilen × 32 Pixel (1 Bitplane). Geblittet werden nur **20 Zeilen** (`BLTSIZE $503`): Die
  21. Zeile von `Q`, `(` und `)` wird nie gezeichnet (Eigenheit des Originals).
- Proportional: Vorschub = 1 + Breite aus der Tabelle (z. B. `A` 23, `I` 9, `W` 32, Leerzeichen 16).
- Zeichnen (Routinen `$1030`/`$114C`): Erst wird jedes Zeichen an 5 Stellen – Mitte, oben, unten, links, rechts (je
  1 Pixel) – per Blitter in **alle 6 Bitplanes** ODER-verknüpft (`A | C`). Danach wird jedes Zeichen an seiner
  Stelle in den **Planes 2–6** gelöscht (`¬A & C`). Ergebnis: Zeichen = Farbindex 1 (`$FFF` weiß), Rand = Index 63
  (EHB-Hälfte von Farbe 31, fast schwarz).
- Position im Bild: x + 16, y + 16 (Zieladresse Puffer + `$2C2`).
- Ein Nachbau des Verfahrens stimmt mit dem Speicherabzug pixelgenau überein.
- In den Spieldaten des Nachbaus (`font/menu.idx`) liegt die Schrift als Bogen mit Zellen von 32 × 29 Pixeln:
  6 Zeilen Luft oben (Umlautpunkte), die 21 Originalzeilen, 2 Zeilen unten (Kommaschweif). Dahinter folgen die per
  Skript erzeugten Zeichen Ä, Ö, Ü (Grundbuchstabe plus zwei Punkte), Komma (Punkt mit Schweif) und Bindestrich
  (E-021, E-023).

### Texttabelle

```
<x: Wort> <y: Wort> <Zeichen …> $FE [$FE]   eine Zeile an Position x/y; zweites $FE nur als Füllbyte für Wortausrichtung
… weitere Zeilen …
$FFFF                                       Ende der Seite (x negativ)
```

- Alle Zeilen sind auf x = 160 zentriert (Bildmitte nach dem Versatz um 16), Zeilenraster 40 Pixel ab y = 8.
  Leere Zeilen stehen als `(160, y)` ohne Zeichen in der Tabelle.
- 15 Seiten: 0–11 Abspann, 12 Story („ALESTES …“), 13 Highscore-Eingabe, 14 Schreibschutz-Hinweis („… PRESS R TO
  RETRY OR PRESS C TO CANCEL HISCORE.“). Die Highscore-Tabelle selbst wird nicht aus der Texttabelle, sondern aus
  `$41A36` gezeichnet. Inhalt und Positionen: [Texte](texte.md).

## Ladebilder (`load_<level>`)

Laufen bei `$61500` (Adresse = Offset + `$61500`). Gleiches Schema in allen sechs Dateien ✔ (Größen im Detail noch
je Level prüfen):

| Datei-Offset | Inhalt (`load_sea`) |
|---|---|
| `0x0000` | Code: Einblenden, Level laden und entpacken, Ausblenden, `jmp $600` |
| `0x1D3C` | ProTracker-Modul „loading_sea“ (Lademusik), 22.556 Byte, 3 Patterns |
| `0x7558` | Ladebild direkt hinter dem Modul: 352 × 290, 6 Bitplanes, Extra-Halfbrite (wie das Menü) |
| `0x1A068` | Palette, 32 Farbwörter |
| `0x1A0A8` | Copperliste (Farben werden beim Einblenden eingetragen), bis Dateiende `0x1A1B8` |

- **Eigenheit des Originals:** Die Standard-Initialisierung des ProTracker-Abspielers (`mt_init`) löscht das erste
  Langwort jedes Samples, auch der leeren Sample-Plätze am Ende. Diese liegen genau am Modulende, also am Anfang des
  Ladebilds: Die ersten 4 Byte von Plane 1 werden 0 (Watchpoint im Emulator: Befehl `clr.l (a2)` bei `$61F6C`).
  Betroffen sind die Ladebilder von Meer (`fffffff8` → 29 Pixel oben links), Sumpf, Bergen und Hochland; bei Wald und
  Feuer sowie beim Menü sind die Bytes ohnehin 0.
- Prüfung `load_sea`: Bild aus der Datei mit diesem Effekt = Emulator-Aufnahme, 100,00 % pixelgenau.
- Die anderen Ladebild-Dateien enden nicht immer genau wie `load_sea` (z. B. `load_forest`); Aufbau dort noch prüfen.

## Präsentation (`present`)

Läuft bei `$600`; der Speicher bleibt während der ganzen Titelsequenz identisch mit der Datei (außer Variablen und
Copperlisten bei `$1000`–`$1547`). Code disassembliert in `work/disasm/present_code.txt`.

### Bilder

Alle Bilder: **Hires, Interlace, 4 Bitplanes (16 Farben)**, 640 Pixel breit (80 Byte je Zeile); die Zeilen beider
Halbbilder liegen nacheinander im Speicher (Modulo 80, Zeiger des zweiten Halbbilds + 80). Jedes Bild = 4 Planes
nacheinander, **direkt gefolgt von seiner Palette** (16 Farbwörter), die Bilder lückenlos hintereinander ✔:

| Datei-Offset | Adresse | Bild | Größe (Zeilen gesamt) | Palette (Offset) | `DIWSTRT`/`DIWSTOP` |
|---|---|---|---|---|---|
| `0x00F48` | `$01548` | Psygnosis-Logo (Eule + Schriftzug) | 640 × 240 | `0x13B48` | `$5481`/`$CCC1` |
| `0x13B68` | `$14168` | Symbol „Amiga → Stereoanlage“ | 640 × 58 (angezeigt 54) | `0x183E8` | `$FF81`/`$1AC1` |
| `0x18408` | `$18A08` | Art-&-Magic-Logo (Zauberer + Schriftzug) | 640 × 160 | `0x24C08` | `$6881`/`$B8C1` |
| `0x24C28` | `$25228` | Agony-Logo | 640 × 256 | `0x38C28` | `$5081`/`$D0C1` |
| `0x38C48` | `$39248` | Textzeilen: „and“ (Zeilen 0–23), „Present“ (24–41), „Do you want to skip the intro sequence? (y/n)“ (ab 42) | 640 × 70 | `0x3E3C8` | „and“ `$8A81`/`$96C1`, „Present“ `$8A81`/`$93C1` |

- Gemeinsam: `BPLCON0 = $C204` (Hires, 4 Planes, Interlace), `DDFSTRT $3C`, `DDFSTOP $D4`, Farbe 0 = `$666` (grauer
  Hintergrund).
- Die Frage „Do you want to skip the intro sequence? (y/n)“ wird nie angezeigt: ein Überbleibsel des gestrichenen
  Animations-Intros.
- Prüfung: Alle sechs Bildschirme der Titelsequenz stimmen mit den Interlace-Aufnahmen des Emulators pixelgenau
  überein (100,00 %).
- Ablauf, Effekte und Zeiten: [Ablauf bis Level 1](original/startsequenz.md#titelsequenz-present).

### Ton

Keine Tracker-Musik, sondern Samples, die der Code direkt startet ✔ (Details in
[Audio](original/audio.md#titelsequenz-present)):

| Adresse | Länge (Wörter) | Verwendung |
|---|---|---|
| `$3EEF8` | `$5799` | Kanal 0, Dauerschleife (Periode `$F4`), Lautstärke wird ein- und ausgeblendet |
| `$49E3A` | `$5799` | Kanal 1, ebenso (Stereo-Paar zu Kanal 0) |
| `$54D90` | `$4301` | Kanal 2/3 gleichzeitig mit Perioden `$C2`/`$D9`, Lautstärke 63 |
| `$60A96` | `$2C5E` | Kanal 2/3, Periode `$98`, Lautstärke wird ein- und ausgeblendet |
| `$5D3D6` | `$1B4D` | Kanal 2/3, Periode `$9A`, dreimal mit abnehmender Lautstärke (63/50, 40/30, 20/10) – Echo |

## Level 1 (`sea`) zur Laufzeit

Aus dem Speicherabzug am Levelstart (`work/captures/level1_start_f22156_chip.bin`):

- **Zwei Copperlisten** bei `$05E962` und `$05F88A` (Datei-Offsets `0x5E362` und `0x5F28A`, also am Ende des Abbilds,
  wo `Ag_Copper_List.s` eingebunden wird). Rund 500 Registerzugriffe und 400 Warte-Befehle je Liste.
- **Statuszeile** (Rasterzeilen `$2D`–`$3E`): `BPLCON0 = $A200` (Hires, 2 Bitplanes), `DIWSTRT $2D90`,
  `DDFSTRT $38`/`DDFSTOP $C8`, Bitplanes zur Laufzeit bei `$5B0D2`/`$5B676`; Farbe 3 läuft pro Zeile von `$653`
  bis `$DCA` (goldener Verlauf der Schrift).
- **Spielfeld** ab Zeile `$3F`: `BPLCON0 = $6600` (6 Bitplanes, Dual-Playfield), `BPLCON2 = $24`, `BPLCON1 = $00F0`.
  - Vorderes Playfield (Bitplanes 1/3/5) bei `$66AB4`, `$68BB4`, `$6ACB4`: je `$2100` Byte, Zeilenbreite 44 Byte
    (`BPL1MOD = 6`, gelesen werden 38 Byte), also ein Puffer, der breiter als das Bild ist.
  - Hinteres Playfield: Bitplane 2 bei `$77B3A` und wird in Bändern umgeschaltet (Schritte von `$500`), Bitplanes 4/6
    bei `$73F3A`/`$7443A`; `BPL2MOD = 2` (Zeilenbreite 40 Byte).
  - Farbregister 10/11, 12/13, 14/15 paarweise gleich (`$050`, `$554`, `$143`) – der Trick für die dritte Ebene.
  - Pro Rasterzeile: `WAIT V,$42` → Farbe 0 = Himmelsfarbe, `WAIT V,$D6` → Farbe 0 = Schwarz.
- **Sprites:** 0–3 (Eule) bei `$186C0`, `$18770`, `$18820`, `$188D0` – also im Level-Abbild (Datei-Offset
  Adresse − `$600`); Sprite 4 bei `$55B22`, 6 und 7 bei `$554F6`/`$557F6`.
- Die Bitplanes von Statuszeile und Spielfeld sind Laufzeitpuffer; die Spielfeldgrafik wird aus Kacheln aufgebaut
  (Adressen und Formate im folgenden Abschnitt).

### Adressen im Abbild `sea` ✔

Aus der Disassembly (`work/disasm/sea_code.txt`, erzeugt mit `disasm68k.py … 0x600 0x600 0x9000`) im Abgleich mit
`Agony_Parent_.s`, `Ag_Back_Scroll.s` und `Ag_Copper_List.s`. Das Binärabbild weicht an einzelnen Stellen vom
Quelltext ab (z. B. zusätzliche `Quit_Delay`-Abfragen in `Ag_Sprites.s`); maßgeblich ist das Abbild.

- **Register `a5` (`D`) = `$58ACE`**, also `Rel_Start` = `$50ACE`. Alle Variablen und relativen Daten liegen bei
  `$58ACE + Versatz` (Variablen ab Versatz `$7B68`, z. B. `Gen_25hz_Phase` `$7B68`, `Back_Shift` `$7BB0`,
  `Stop` `$7C0C`, `Begin_To_Start` `$7CDC`).
- **Code:** `$600` (Init), `Main_Loop` `$AD0`, `Int3` `$4392` (VBL: `Delay_Count`, `MUSIC_PLAY` `$9892`; Copper-Teil ab
  `$43C6`), `MUSIC_INIT` `$980E`.

| Daten | Adresse | Größe | Inhalt |
|---|---|---|---|
| `Sorcerer_Dat` | `$178C0` | `$4030` | Eule: 16 Phasen à 12 Byte (`y1`, Höhe, 4 Versätze für Sprite 0–3), dann Sprite-Listen (siehe unten) |
| `Sky_Dat` | `$205B4` | `$1680` | statische Ebene (Bitplane 2): 4 Blöcke à 40 Zeilen × 36 Byte (288 Pixel) |
| `Back_Charset` | `$21C34` | `$F300` | Kacheln des hinteren Playfields, 32 × 32 Pixel, 2 Planes |
| `Front_Charset` | `$30F34` | | Kacheln des vorderen Playfields (384 Byte je Kachel) |
| `Back_Frame` | `$50ACE` | `$1C20` | 120 Bilder à 30 Kachelnummern (5 Spalten × 6 Zeilen, Wörter) |
| `Back_Pattern` | `$526EE` | | 16 Wörter Kopf (Versätze der Muster, Wort 0 = `$20`), je Muster 48 Byte Farben + Animationsfolge |
| `Back_Char_Info` | `$52BAE` | | Wort `$F8`, 246 Modus-Bytes, ab `+$F8` 246 Versätze ins `Back_Charset` |
| `Read_Table` | `$52E92` | 5 × 240 | je Scroll-Stellung 60 × (Muster 0–2, Versatz im Bild) |
| `Back_Old_Char` | `$53342` | 480 | zuletzt gezeichnete Kacheln (nur geänderte werden geblittet) |
| `X60`, `Write_Table` | `$53522`, `$53622` | | Bildnummer × 60; Zieladressen der 60 Kacheln (10 Spalten × 6 Bänder) |
| `Sky_Anim_Table` | `$5369A` | 8 | Versätze der 4 Himmelsblöcke (Level 1: 0, 1440, 2880, 4320) |
| `Front_Map`, `Front_Pal` | `$536A2`, `$5452A` | | Karte und Paletten des vorderen Playfields |
| `Sorcerer_Pal` | `$55AFA` | 32 | Farben 16–31 (Eule) |
| `Status_Screen_Disp` | `$5B0D2` | 76 × 19 | Plane 1 der Statuszeile (18 Zeilen `$FF`, 1 Zeile 0) |
| `Main_Cl` | `$5E962` | | Copperliste, Kopfteil bis `COPJMP2`; `Cl_Flip_Phase0` `$5EAE6`, `Cl_Flip_Phase1` `$5F88A` |
| `Front_Screens` (Clear_Start) | `$607B2` | bis `$7F33A` | Laufzeitpuffer: Front-Bildschirme, `Back_Screen0` `$73F3A`, `Back_Screen1` `$7993A` |

**Hinteres Playfield (Bitplanes 4 und 6):** Ein Puffer hat 40 Byte je Zeile und 6 Bänder à 64 Zeilen; in jedem Band
liegen 32 Zeilen Plane 4, dann 32 Zeilen Plane 6 (Plane 6 = Plane 4 + `$500`). Die Copperliste setzt an jeder
Bandgrenze für eine Zeile `BPL2MOD = $502` und überspringt so die Plane-6-Zeilen; Bitplane 2 (Himmel) bekommt
danach ihren Zeiger neu. Kachel-Modi: 0 = beide Planes getrennt (256 Byte), 1 = beide gleich (128 Byte),
2 = nur Plane 6, 3 = nur Plane 4. Gezeichnet wird in zwei Hälften (5 Spalten je Hauptschleife, `Back_Phase`).

**Muster:** Jedes Muster bringt eigene Farben für die 6 Bänder mit (je Band 1 Füllwort + Farben 10/11, 12/13,
14/15, in beide Flacker-Hälften der Copperliste geschrieben) und eine Animationsfolge aus Paaren (Bild, Dauer),
Ende `$FF`. Die Wellen am Levelstart sind die Muster 0–2 mit je 12 Bildern à 1 Hauptschleife (= 4 Bilder).

### Weitere Laufzeitstrukturen ✔

Belegt durch den Nachbau, der damit pixelgenau wie der Emulator zeichnet:

- **Statuszeile:** Plane 1 (`Status_Screen_Disp`) ist fest gefüllt (Farbe 1 = Schwarz), gezeichnet wird in Plane 2
  (`Status_Screen` `$5B676`, 76 × 19 Byte); Farbe 3 läuft per Copper pro Zeile. Zeichen 8 × 16 Pixel, 16 Byte je
  Zeichen (`Status_Digit` `$5BC1A`, 44 Zeichen; Ziffern ab Code 0, Leben-Symbole ab `$A0`/`$2B0`; Code-Tabelle in
  [Texte](texte.md#statuszeile-level-1-sea)). Die Pipeline ergänzt Ä, Ö, Ü als Tabelle `status.extra` im Manifest
  (je 16 Byte, Codes 44–46). Texte: `Text_Dat` `$5BEDA`,
  Tabelle mit Wort-Versätzen, Text endet mit einem Byte ≥ `$80`; Text 13 = „PRESS FIRE TO START“, gezeichnet ab
  Byte 10. Punkte ab Byte 38 (6 BCD-Ziffern), Zauberdauer ab Byte 12, Leben ab Byte 68.
- **Eule:** `Sorcerer_Dat` beginnt mit 16 Phasen à 12 Byte: Versatz der Eule zur Spielkoordinate (`y1`), Höhe in
  Zeilen und die Versätze der vier Sprite-Listen (Sprite 0/1 links, 2/3 rechts, je ein angehängtes Paar mit 16
  Farben). Jede Liste enthält drei Abschnitte: obere Axt (7 Zeilen), Eule, untere Axt (7 Zeilen); der Copper-
  Interrupt schreibt ihre Steuerwörter in jedem Bild neu (ausgeschaltete Äxte mit x = 0). Die Phase wechselt jedes
  zweite Bild. Spielkoordinaten: Start (320, 306), Schritte von 3; geprüft wird vor dem Schritt (rechts bei x < 504,
  links bei x > 256, unten bei y < 388, oben bei y > 236), daher reicht x von 254 bis 506 und y von 234 bis 390.
  Sprite-Position = Koordinate − 256 + `$90` (x) bzw. + `$40` (y).
- **Regen:** zwei Sprite-Listen (`Rain_Spr0` `$554F6` für Sprite 6, `Rain_Spr1` `$557F6` für Sprite 7) mit je 24
  Tropfen à 32 Byte (Steuerwörter + 7 Zeilen), untereinander im Abstand von 8 Zeilen ab Zeile `$40`. Die
  x-Positionen kommen aus `Rain_X_Table` (`$55436`, zweimal dieselbe Tabelle), je Zeile um 1 bzw. 2 Einheiten
  schräg versetzt; der Tabellenzeiger läuft pro Bild um 6 bzw. 4 Byte weiter. Farben 29–31 = `$667`, `$778`,
  `$889`, jedes Bild vom Copper-Interrupt gesetzt.
- **Copperliste:** `Main_Cl` setzt Sprite-Zeiger, Statuszeile und Spielfeld-Grundwerte und springt per `COPJMP2` in
  eine der beiden Hälften `Cl_Flip_Phase0`/`1`; jede setzt am Ende `COP2LC` auf die andere (Flacker-Trick: die
  Verläufe beider Hälften wechseln sich jedes Bild ab) und löst den Copper-Interrupt aus (`INTREQ $8010`).
- **Vorderes Playfield:** drei Planes à 44 Byte × 192 Zeilen (Planes im Abstand `44·192`), zwei Arbeitsbilder und
  ein Restaurierungsbild (`Rest_Screen_Ptr`, nur Kacheln, ohne Gegner) ab `$607B2`. Die Karte (`Front_Map`
  `$536A2`) hat je Kachel zwei Bytes: Hintergrund- und Vordergrundkachel; `X384` (`$54FB6`) gibt ihren Versatz in
  `Front_Charset` (`$30F34`, 3 Planes à 128 Byte, 32 × 32 Pixel). Eine Spalte aus 6 Kacheln (Zeilenversätze in
  `Front_Table` `$54FAA`) entsteht in den Durchläufen 2–13 einer 16er-Phase: Hintergrund kopieren, Maske der
  Vordergrundkachel (`Front_Mask` `$553B6`, A∨B∨C über die Planes), Vordergrund mit `D = A ∨ (¬B ∧ C)` darüber,
  dann ins andere Arbeitsbild und ins Restaurierungsbild. Feinverschiebung `Front_Shift` (32 → 2 in Schritten von 2,
  dazwischen −1 im Copper-Interrupt); nach Phase 16 rücken alle Bildzeiger um 4 Byte weiter.
- **Paletten vorn:** `Front_Pal` (`$5452A`) mit je 6 Bändern × 7 Farben; alle 10 Spalten die nächste Palette
  (`Front_Pal_Count`, `Refresh_Pal`). Übernommen wird sie in einem Durchlauf mit `Short_Phase` über
  `Front_Pal_Buffer` (`$54F56`); Farben laufender Wellen und einer Objekt-Routine können einzelne Bänder überdecken.
  Ziel in der Copperliste: Band 0 bei `$5EA90` (6 Farben im Abstand 4) und `$5EAA8` (7. Farbe), Bänder 1–5 in beiden
  Flacker-Hälften (`layout.ts`, `frontColor`).
- **Short_Phase / Old_Vpos** (`a5 + $7C5E`/`$7C5C`): Zeile des Strahls bei `$147C`, nur die unteren 8 Bit
  (`move.l VPOSR,d0; lsr.w #8`); Short_Phase = `$FF`, wenn sie nicht größer ist als im vorigen Durchlauf.
- **Schuss der Eule:** Sprite 4 aus vier Formen (`$1EFC8`, `$1F02C`, `$1F0D0`, `$1F1C4` für Stufe 0–3), 20 Pixel je
  Bild, 12 Bilder lang (`Fw_Fire_Step` 0 → `$F0` = aus); Kollisionsrechteck jedes zweite Bild in `Good_Col_List + 8`.
- **Korrektur Variablen:** In sea liegt `Clean_Up` bei `a5 + $7CE0` (nach `BTS_Delay`); `$7CCC` wird beim Aufräumen
  gesetzt ($39CA) und im Teil 2 ausgewertet ($38E8).

- **Gegner (Wellen)** ✔, nachgebaut in `game/src/core/level/` (`playability.ts`, `objects.ts`, `alien-fire.ts`):
  - `Track_Table` (`$5E380`): 16 Zeiger auf Bahnstrukturen (TS, je `$90` Byte ab `$4D6C6`), Bit 31 = frei. TS: +0
    AWO-Bank, +4 Wellenbeschreibung (Bit 30 = absolute Bahn), +8 Anzahl Gegner, +`$A` erster lebender Gegner (×4),
    +`$B` eigener Index (×4), +`$C`/+`$E` Startpunkt, ab +`$10` je Gegner ein Langwort: Position auf der Bahn (oberes
    Wort, +1 je Durchlauf) und Animationsschritt (+2).
  - Wellenbeschreibung (AWS, 32 Byte): +0/+2 Versatz der x-/y-Bahn in `Absolute_Tracks` (`$50036`) bzw.
    `Relative_Tracks` (`$4FE22`), +4 Animation in `Anim_Base` (`$4E974`, Wörter = Objektversätze, −1 = von vorn),
    +6 Abstand, +7 Anzahl, +8 Energie (Wort), +`$A` Schussrate, +`$B` jeder wievielte schießt, +`$C` 6 Zeilen-Schalter,
    +`$12` 7 Farben. Bahnen: Nibbles mit Vorzeichen (oberes zuerst), x- und y-Schritt je Durchlauf, −8 = Ende;
    relative Bahnen beginnen mit einem Startwort und schieben x zusätzlich um 2 je Durchlauf.
  - AWO-Bänke (`$5C67A`–`$5DEFA`, 32 × 196 Byte): Wort Anzahl (0 = leer, −1 = frei), Wort Versatz zum ersten lebenden
    Gegner, 16 Gegner à 12 Byte: x, y (+256), Objektversatz, Energie, Status (Bits 0–3 Explosionsphase 1–15,
    Bits 4–7 Treffer-Blinkzähler), Schussrate, Schusszähler.
  - `Objects_Struct` (`$4D054`): je Objekt Wort Versatz der Trefferrechtecke (x1, y1, x2, y2 als Bytes, Ende `$80`),
    Schussursprung (dx, dy), dann Teilbilder (dx, dy, Sprite-Nummer; Ende dy = `$80`).
  - `Sprites_Struct` (`$5BFFA`, 64 × 26 Byte): Breite, Höhe, Zeiger auf Masken-, H-Clip-, V-Clip- und Blit-Routine,
    Bitmap, Maske bzw. Minterm der dritten Plane. In der Datei steht statt der Zeiger der Typ (0–11); `Ag_Pre_comp.s`
    setzt die Zeiger aus vier Tabellen (`$5E0FA` …) und baut für 7-Farben-Teilbilder Masken nach `$4A674`. Bitmaps
    ab `$40534`; bei 3 Farben hat Plane 1 ein Leerwort je Zeile mehr (sie wird ohne Maske verschoben).
  - Gegnerschüsse (`AF_Struct` `$4DFC6`, 32 × 8 Byte): x, y, y-Takt (Vorzeichen = Richtung), y-Zähler, Gruppengröße,
    Platz in der Gruppe; Sortierung über `BS_Count`/`BS_Offset`/`BS_Order` (`$5E41E` …), Wechselzähler `AF_Lfo`.
  - `Good_Col_List` (`$5E3C0`): 8 Rechtecke der eigenen Seite (Eule, Schuss, …), x < 0 = aus.
  - `Rout_Struct` (`$5E5E2`, 32 × 28 Byte): Code-Zeiger der Routine (−1 = frei), Zeiger auf ihre Parameter in der
    Startliste, AWO-Bank, 16 Byte Variablen (Bedeutung je Routine, z. B. Modus, Animationsschritt, Takte). Gestartet von
    `START_C` (Routine_Start `$2AA0`), aufgerufen vom ROUTINE MANAGER (`$316E`) mit `a0` = Eintrag.
  - Tod der Eule: `Die_Table` (`$5AAC6`: 8 Wortversätze auf Bahnen aus Bytepaaren dx, dy, Ende `$80`), `Die_Dyn_Ptr`
    (`$5B0B2`, 8 Langwörter, −1 = Teil fertig), `Die_X`/`Die_Y` (`a5 + $7C86/$7C88`), Sprites `Die_Spr` (`$20190`,
    8 × 33 Langwörter, 32 Zeilen). Schild: `Sorcerer2_Dat` (`$1B8F0`, Kopf je Phase: y1, Höhe, Versätze der Listen für
    Sprite 6 und 7).
  - Weitere Variablen: `Spell_Time_Delay` (`a5 + $7C2C`), `Key`/`Key_Up_Flag` (`$7C02`/`$7C04`), `Quit_Delay`
    (`$7CCA`), `AF_Off` (`$7CCC`), `Clean_Up` (`$7CE0`).

### Speicherblöcke der Level

Die Asset-Pipeline schneidet je Level diese Bereiche aus dem Abbild (`tools/pipeline/extract/level1.ts`,
`manifest.memory`, Dateien `data/level/<level>.<block>.bin`); die Level-Engine legt sie an ihre Adressen (E-032).
Programmcode und die Musik (Jeroen Tel) sind nicht dabei; nur im Block `game` stehen die Objekt-Routinen des
Level-Moduls als Bytes mit drin (werden nicht ausgeführt, sondern übertragen).

| Block | Level 1 (`sea`) | Inhalt |
|---|---|---|
| `sprites` | `$178C0`–`$205B4` | Sprites: Eule, Schüsse, Bonusse, Gegnerschüsse (`Alien_Fire_Spr` `$1FFDC`), Tod |
| `sky` | `$205B4`–`$21C34` | statische Ebene |
| `back` | `$21C34`–`$30F34` | Kacheln hinten |
| `game` | `$30F34`–`$50ACE` | Kacheln vorn, Objektgrafik, Strukturen, `AF_Struct`, Level-Modul (Startliste, Wellen, Animationen) |
| `rel` | `$50ACE`–`$607B2` | relative Daten bis zur Copperliste und den Variablen |

## Angriffswellen-Startliste (Binärformat)

Die Makros in den Level-Modulen ergeben folgende Kodierung (alle Werte big-endian):

| Makro | Bytes |
|---|---|
| `WAIT pos` | Wort `pos` |
| `START_A obj,x,y` | Langwort `obj + $40000000`, Wort `x`, Wort `y` |
| `START_C obj` | Langwort `obj + $80000000`, danach optional Parameter |
| `START_R obj` | Langwort `obj` |
| `PAR w` / `PAR_L l` | Wort / Langwort (Parameter für das Objekt) |
| `PAR_END` | Wort `$FFFF` |
| `SL_END` | Wort `$7FFF` (Listenende) |

**Level 1 im Abbild `Agony.09`:** Die Startliste beginnt bei Datei-Offset `0x4DAC6` (Adresse `$04E0C6`) und endet mit
`$7FFF` bei Offset `0x4DFB2`. Sie hat 121 Einträge (96 × `START_A`, 25 × `START_C`), der letzte `WAIT` ist `$22F0`.
Die ersten Einträge stimmen exakt mit `Ag_Game_LMER.s` überein. Der Quelltext hat 8 Einträge mehr: Die
`START_C Demo_Page`-Einträge werden nur im Demo-Modus assembliert (`IFNE ASM_Demo_Mode=2`).

Direkt hinter der Liste folgen die 5 Strukturen aus `lmer_rtr.s` (je 32 Byte) und dann `Poisson_Bl_1` bei Offset
`0x4E054` = Adresse `$04E654` – genau der Zeiger aus der Liste. Daraus folgt die Basisadresse `$600`.

### Wellen-Strukturen

32 Byte je Struktur (Wörter sind auf gerade Adressen ausgerichtet). Felder siehe [Level](original/level.md#wellen-parameter-attack-wave-start-struct-for-relative-tracks).
Achtung: Die Struktur für absolute Bahnen in `Ag_Game_LMER.s` (`Poisson_Bl_1`) weicht leicht ab (`AWS_Alien_Energy`
als Wort, `AWS_Alien_F_Rate` statt `AWS_Alien_Bad_GF`). Maßgeblich ist das Binärabbild der Release-Fassung.

## Grolets Packer (`ag/`-Dateien)

- Eigener Packer von Art & Magic: Entpacker-Quelltexte `Global/decrunch_am.s` und `Global/asm_decrunch.s`
  („DECRUNCHER V1.0“), fertige Routine `Agony/DISK/decrunch.bin` (298 Byte 68k-Code).
- Kopf: erstes Langwort = entpackte Größe; die Bedeutung des zweiten Langworts (meist `$0040xx2F`) ist offen ❓.
- Für den Nachbau nicht nötig, da die Crack-Dateien sich vollständig entpacken lassen. Nützlich, um die beiden
  Revisionen zu vergleichen.

## Original-Diskformat („Ordilogic disk filing system“)

`DISK/load_label.s` beschreibt jede Datei mit drei Konstanten:

```
File_<disk>_<n>_disk  equ  <Diskette>
File_<disk>_<n>_num   equ  <Dateinummer>
File_<disk>_<n>_code  equ  <32-Bit-Wert>
```

| Nr. | Disk | Datei | | Nr. | Disk | Datei |
|---|---|---|---|---|---|---|
| `$00` | 0 | DiskID0 | | `$0E` | 2 | DiskID2 |
| `$01` | 0 | `present` | | `$0F` | 2 | `marshes` |
| `$02` | 0 | `fire` | | `$10` | 2 | `load_mountains` |
| `$03` | 0 | `ending` | | `$11` | 2 | `mountains` |
| `$04`, `$05` | 0 | Platzhalter (DiskID0) | | `$12` | 2 | `load_highlands` |
| `$06` | 1 | DiskID1 | | `$13` | 2 | `highlands` |
| `$07` | 1 | `igt` | | `$14` | 2 | `load_fire` |
| `$08` | 1 | `load_sea` | | `$15` | 2 | Platzhalter (DiskID2) |
| `$09` | 1 | `sea` | | `$16`–`$1D` | 3 | Kopie der Disk-2-Einträge, DiskID3 |
| `$0A` | 1 | `load_forest` | | | | |
| `$0B` | 1 | `forest` | | | | |
| `$0C` | 1 | `load_marshes` | | | | |
| `$0D` | 1 | Platzhalter (DiskID1) | | | | |

- Die Disk-IDs sind 4-Byte-Dateien mit `ur00` … `ur03` (`DISK/DISKID0`–`3`).
- Der `code`-Wert ist vermutlich ein Schlüssel oder eine Prüfsumme ❓ (für `DiskID`-Einträge 0).
- Grolets Disk-Images `NoLabel01`–`03` haben einen DOS-Bootblock, aber kein AmigaDOS-Dateisystem und sind fast voll –
  möglicherweise Disketten in diesem Format ❓.

## Highscore (`Agony.00`)

48 Byte, ungepackt, auf Disk 2:

```
00 29 0C 00 00 20 00 00   00 29 0C 00 00 18 00 00
00 0D 03 00 00 15 69 77   00 0D 03 00 00 15 12 27
00 29 0C 00 00 15 00 00   00 0D 03 00 00 14 31 63
```

- 6 Einträge à 8 Byte. Das zweite Langwort ist die Punktzahl als BCD, absteigend sortiert: 200.000, 180.000,
  156.977, 151.227, 150.000, 143.163.
- Das erste Langwort hat nur zwei verschiedene Werte (`$00290C00`, `$000D0300`) – vermutlich Name/Kürzel in einer
  eigenen Zeichenkodierung ❓.

## Weitere Formate im Quellcode-Archiv

| Format | Erkennung | Vorkommen |
|---|---|---|
| IFF ILBM (Bilder) | `FORM….ILBM` | `NoLabel04.adf` (`fond1–3.pic` …), `MichaelDevoyGraph.adf`, `DISK/insert_disk.iff` |
| IFF 8SVX (Samples) | `FORM….8SVX` | `AgonyIntro/samples*/` |
| ProTracker-Modul | `M.K.` an Offset 1080 | `AgonyDemoDosBackup/mod.*` |
| Amiga-Programm (Hunk) | `$000003F3` | `Crystal`, Werkzeuge auf den Disks |
| GFA-Basic | `GFA-AMIGAB` am Anfang | `Agony/UTIL/*.GFA` (Editoren) |
| Quarterback-Backup | Bootblock `QB01`/`QB03` | `DevPack1.adf`, `3.adf` (unvollständig) |
| Jeroen Tels Musik | Assembler-Quelltext | `AgonyIntro/00 Agony Audio *.S` |

## Noch zu entschlüsseln

- Level 1: vorderes Playfield (`Front.Map`, `Front.Pal`), Objektgrafik und -strukturen (`Objects.bin`/`.obj`/`.sst`)
- Level 2–6: Adressen in den Abbildern (Schema wie Level 1)
- Aufbau der Objekte/Animationen (`Anim_…`), Bewegungstabellen (`TX_…`, `TY_…`)
- Musik und Samples in den Abbildern
- Ladebilder der Level 2–6: Aufbau im Einzelnen prüfen (Schema wie `load_sea`)
- `ending` (`Agony.03`): Aufbau
