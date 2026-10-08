# Das Original – Ablauf bis zum Start von Level 1

Stand: 06.10.2026 · Legende: ✔ belegt · 🌐 nur Web-Recherche · ❓ Vermutung/ungeklärt

Grundlage sind zwei Quellen:

- **Disassembly** der Programme `present`, `igt` und `load_sea` (`tools/analysis/disasm68k.py`, Ausgaben in
  `work/disasm/`). Daraus stammen alle Zeiten, Abläufe und Werte auf dieser Seite, soweit nicht anders vermerkt.
- **Referenz-Emulator** (A500, OCS, 512 KB Chip + 512 KB Slow, Kickstart 1.3), schrittweise und damit
  reproduzierbar. Bildnummern = Emulator-Bilder seit dem Einschalten (50 pro Sekunde) im Lauf vom 06.10.2026
  (Schnappschüsse siehe [Setup](../setup.md#schnappschüsse)). Ladezeiten stammen von der Crack-Fassung, die über
  AmigaDOS lädt; im Nachbau entfallen sie.

Dateiformate und Fundstellen: [Dateiformate](../dateiformate.md).

## Überblick

| Bild (Lauf 06.10.) | Was passiert | Datei | Eingabe |
|---|---|---|---|
| 0–≈1200 | Booten, Crack-Intro „Crystal“ (zwei Seiten) – **nicht Teil des Originals, wird nicht nachgebaut** | `Crystal` | Feuer bzw. Maustaste |
| ≈1200–3000 | Laden der Präsentation (grauer Bildschirm) | `present` | – |
| 3001–3155 | Symbol „Amiga → Stereoanlage“ ein- und ausgeblendet | `present` | – |
| 3185–3572 | **Psygnosis:** Umriss baut sich hinter einem Feuerband von unten nach oben auf, Logo wird eingeblendet, ausgeblendet | `present` | – |
| 3658–3790 | Text „and“ | `present` | – |
| 3820–4029 | **Art-&-Magic-Logo** (Zauberer + Schriftzug) | `present` | – |
| 4056–4187 | Text „Present“ | `present` | – |
| 4217–4428 | **Agony-Logo** (erscheint schlagartig), wird ausgeblendet | `present` | – |
| ≈4430–4490 | grauer Hintergrund blendet nach Schwarz | `present` | – |
| ≈5040 | „Insert Disk 2“ | Lader | Diskwechsel |
| ≈7100 | **Menü:** Bild mit brennendem Baum, Abspann-Seiten, Menümusik | `igt` | Feuer startet |
| 7300 (Feuer) – 8630 | **Story-Seite**, solange `load_sea` geladen wird | `igt` | – |
| ≈8630–8680 | Menü blendet aus, **Ladebild von Level 1** blendet ein; dabei wird das Level geladen und entpackt | `load_sea` | – |
| ≈13060 | Ladebild blendet aus (Laden fertig) | `load_sea` | – |
| ≈13080–13210 | Schwarz (Level wird entpackt und gestartet) | `sea` | – |
| ab ≈13220 | **Level 1:** Spielfeld, Statuszeile blinkt „PRESS FIRE TO START“, Eule flattert – das Spiel wartet auf Feuer | `sea` | Feuer |

Korrektur gegenüber dem ersten Lauf: Das Ladebild wartet **nicht** auf Feuer; es steht, bis das Level geladen ist.
Erst Level 1 wartet auf Feuer.

## Titelsequenz (`present`)

Alle Bilder Hires-Interlace, 640 Pixel breit, 16 Farben, grauer Hintergrund (Farbe 0 = `$666`). Lage in der Datei
und Bildfenster: [Dateiformate](../dateiformate.md#präsentation-present).

### Bausteine

- **Einblenden** (`$D9E`): Alle Farben (Puffer und Hardware) = `$666`, dann 17 Schritte; vor jedem Schritt 5 Bilder
  warten, pro Schritt geht jeder Farbanteil (R, G, B) um 1 auf den Zielwert zu. Dauer immer 85 Bilder, auch wenn die
  Farben früher am Ziel sind. (Die Schleife bearbeitet 17 statt 16 Farben; die 17. landet in `COLOR16` und im
  Bildzähler – ohne sichtbare Folgen.)
- **Ausblenden** (`$E42`): 17 Schritte, vor jedem 3 Bilder warten, jeder Anteil um 1 auf `6` zu (Ziel `$666`).
  Dauer 51 Bilder.
- **Warten** (`$EBC`): n Bilder.
- **Warten auf Zeile `$10`** (`$602`, `$708`, `$82A`, `$990`, `$A0C`, `$AF8`, `$B66`): Abfrage von VPOS auf genau
  Zeile 16. Liegt die Zeile im laufenden Bild schon zurück (z. B. weil der Code nach der vorigen Abfrage länger als
  eine Zeile braucht), trifft sie erst im nächsten Bild. Deshalb liegen `$602`/`$708` und `$AF8`/`$B66` je in zwei
  Bildern ✔ (Ablaufspur).
- Der Bild-Interrupt ist schon aktiv, wenn bei `$708` der Klangteppich startet; er läuft also schon in diesem Bild ✔.
- **Einmal-Sample** auf Kanal 2 oder 3: Sample starten, Audio-Interrupt-Anforderung löschen, auf die nächste warten
  (= Ende des ersten Durchlaufs), dann DMA des Kanals aus.

### Ablauf

| Schritt | Bild | Ton |
|---|---|---|
| Start: alle Farben `$666`, Bildfenster des Stereo-Symbols | – | Kanal 0 = Sample A, Kanal 1 = Sample B, beide in Schleife, Periode 244, Lautstärke 0 |
| Stereo-Symbol einblenden (85), warten 50, ausblenden (51) | | |
| Psygnosis: Bildfenster setzen, Copperliste mit **Feuerband** einschalten, Band läuft 250 Bilder | Umriss erscheint von unten nach oben (siehe unten) | |
| | | Kanal 2: Sample C, Periode `$C2`, Lautstärke 63 (einmal) |
| Psygnosis-Palette einblenden (85); Copperlisten auf die Fassung ohne Band umstellen | | |
| auf Ende von Sample C (Kanal 2) warten, warten 25 | | Kanal 3: Sample C, Periode `$D9`, Lautstärke 63 (einmal) |
| Psygnosis ausblenden (51), auf Ende von Kanal 3 warten | | |
| „and“: Bildfenster, Zeiger; einblenden (85), warten 25, ausblenden (51) | | Kanal 2 + 3: Sample D, Periode `$98`, Schleife, Lautstärke steigt alle 5 Bilder um 1 bis 63 |
| Art & Magic: einblenden (85), warten 100 | | |
| Art & Magic ausblenden (51) | | Kanal 2/3 werden leiser (alle 2 Bilder −1, bei 0 DMA aus), Kanal 0/1 gleichzeitig lauter (+1 bis 63) |
| „Present“: einblenden (85), warten 25, ausblenden (51) | | |
| Agony: Bildfenster, Zeiger, **Palette sofort** (kein Einblenden) | | Kanal 0/1 werden ausgeblendet |
| | | Echo: Sample E (Periode `$9A`) auf Kanal 2 (Lautstärke 63), nach 10 Bildern auf Kanal 3 (50); zweimal wiederholt mit 40/30 und 20/10 |
| warten 100, ausblenden (51) | | |
| Hintergrund nach Schwarz: alle Farben `$666`, `$555` … `$000`, je 3 Bilder | | |
| Sprung nach `$66352` (Diskwechsel, dann Menü) | | |

Samples A–E: Adressen und Längen in [Dateiformate](../dateiformate.md#ton), Klangbeschreibung in
[Audio](audio.md#titelsequenz-present).

### Feuerband (Psygnosis)

- Während des Bands sind alle Farben `$666` (unsichtbar), nur Farbe 1 (der schwarze Umriss des Logos) wird pro
  Rasterzeile von der Copperliste gesetzt: oberhalb des Bands `$666`, im Band 53 Zeilen Feuerfarben, darunter `$000`.
- Farbfolge (Copperliste bei `$10EA` bzw. `$12C2`, je Halbbild eine): `666 666 766 866 966 A66 B66 C66 D66 E66 F66
  F76 F86 F96 FA6 FB6 FC6 FD6 FE6 FF6 FF8 FFA FFC FFF FFB FF9 FF7 FF5 FF3 FE0 FD0 FC0 FB0 FA0 F90 F80 F70 F60 F50 E40
  D30 C20 B10 A00 900 800 700 600 500 400 300 200 100 000`.
- Position: 53 Zähler (Startwerte 250 … 302 bei `$14D6`); jedes Bild werden alle um 1 verringert und als
  `WAIT`-Zeile eingetragen (Werte über `$FF` auf `$FF` begrenzt). Ist der erste Zähler negativ, endet das Band.
  Zeilen zählen pro Halbbild (Interlace), das Band ist also 106 Bildzeilen hoch und wandert 2 Bildzeilen pro Bild.

### Ton der Titelsequenz (Bild-Interrupt `$EF0`)

- Alle 10 Bilder wird die Periode von Kanal 0/1 um 1 kleiner (Start 244): Der Klangteppich steigt langsam an.
- Lautstärke Kanal 0/1: alle 3 Bilder +1 bis 15; beim Agony-Logo zusätzlich jedes Bild −1 bis 0.
- Lautstärke Kanal 2/3: Einblenden +1 alle 5 Bilder bis 63; Ausblenden −1 alle 2 Bilder, dabei Kanal 0/1 +1 bis 63.
- **Eigenheit beim Agony-Echo:** Nach dem Ende von Kanal 2 löscht der Code die Interrupt-Anforderung von Kanal 3,
  prüft dann aber erneut die von Kanal 2, die noch gesetzt ist. Kanal 3 wird deshalb sofort abgeschaltet, sobald
  Kanal 2 fertig ist – das Echo auf Kanal 3 wird jedes Mal abgeschnitten.

## Menü (`igt`)

### Ablauf (Hauptschleife ab `$600`)

1. Menübild anzeigen, Copperliste mit schwarzer Palette; Palette in **17 Schritten zu je 1 Bild** einblenden
   (Farbe × n / 16, n = 0 … 16).
2. Ist die Punktzahl (`$1B4`) höher als der letzte Highscore: Namenseingabe (Seite 13), danach Highscore-Tabelle,
   500 Bilder warten, Text aus.
3. 150 Bilder warten.
4. Schleife: Seiten 0–11 je **400 Bilder Text, dann 200 Bilder nur Bild**; danach die Highscore-Tabelle 500 Bilder,
   400 Bilder nur Bild; von vorn. Ein Zyklus dauert 7.200 + 900 = 8.100 Bilder plus Zeichenzeit.
5. Texte erscheinen und verschwinden schlagartig (Doppelpuffer, kein Ein- oder Ausblenden).

**Zeichenzeiten** ✔ (Ablaufspuren vom 06.10.2026, zwei Läufe, je zwei Zyklen identisch): Vom Ende einer Wartezeit
bis zum Umschalten der Bildzeiger vergehen beim Kopieren („Text aus“, `$F06`) 6 Bilder, beim Zeichnen der Seiten 0–11
15, 14, 12, 11, 12, 14, 14, 19, 15, 13, 20 und 17 Bilder, bei der Highscore-Tabelle 21 und bei der Story-Seite 14.
Die nächste Wartezeit beginnt erst danach. Ein Zyklus dauert damit 8.100 + 13 × 6 + 197 = **8.375 Bilder**.

**Zeitachse ab dem ersten Bild-Interrupt** (Bild 0, erster Aufruf von `mt_music`; `mt_init` lief vorher) ✔: Zeiger auf
das Originalbild in Bild 0, sauberer Puffer ab Bild 6, Einblenden in Bild 7–23 (Farbe × n/16, n = 0 … 16), Seite 0
ab Bild 188 (Änderungen der Copperliste werden jeweils im folgenden Bild sichtbar). Doppelpuffer: anfangs zeigt
`$419F6` (hinten) auf `$558DC`, `$419FA` (vorn) auf `$42DCC`.

### Feuerknopf, Spielstart

- Der Bild-Interrupt fragt den Feuerknopf (Port 2) ab und biegt beim Drücken die Rücksprungadresse auf `$C9C` um –
  egal, was die Hauptschleife gerade tut (auch mitten im Einblenden oder Zeichnen). Abgefragt wird der Zustand, nicht
  der Wechsel: Wer beim Start des Menüs Feuer hält, landet sofort auf der Story-Seite. Danach reagiert der Interrupt
  nicht mehr (`$41A08`).
- Zeitablauf ✔: Im Bild des Feuerdrucks beginnt „Text aus“ (6 Bilder), dann wird Seite 12 direkt ins Originalbild
  `$2EEA6` gezeichnet (14 Bilder); die Story-Seite erscheint also 21 Bilder nach dem Druck.
- Spielstart (`$C9C`): Text aus, **Story-Seite** (Seite 12) direkt ins Originalbild zeichnen und anzeigen,
  Spielvariablen zurücksetzen (siehe [Dateiformate](../dateiformate.md#gemeinsame-variablen-1b0)), `load_sea` nach
  `$61500` laden und entpacken, Palette in 17 Bildern ausblenden (Musik dabei je Bild −2), warten bis die Musik
  stumm ist, `jmp $61500`.
- Die Story-Seite steht also, solange geladen wird (Crack-Fassung: 1.300 Bilder ≈ 26 s).
- Ausblenden ✔ (`$E80`): 17 Schritte; je Schritt Gesamtlautstärke der Musik −2, 1 Bild warten, Farben × n/16 mit
  n = 16 … 0. Danach je Bild weiter −2, bis die Musik stumm ist (15 Bilder). Vom ersten Schritt bis zum Sprung nach
  `load_sea` vergehen 32 Bilder; `load_sea` startet im selben Bild (`mt_init`), sein erster Bild-Interrupt folgt im
  nächsten.

### Highscore

- Tabelle: 6 Einträge, Kürzel bei x = 30, Punkte (6 BCD-Ziffern, das oberste Byte wird nicht angezeigt) bei
  x = 150, Zeilen ab y = 16 im Abstand 40.
- Namenseingabe: 3 Zeichen, mittig bei y = 210, vorbelegt mit `...`; Buchstaben über die Tastaturtabelle,
  Leertaste = Leerzeichen, Backspace = löschen, Return = fertig. Danach wird `Agony.00` geschrieben und zur Kontrolle
  gelesen; bei Fehler Seite 14 („REMOVE WRITE PROTECT …“, Taste R wiederholen, C abbrechen).

### Cheat „FANTASY“

Der Tastatur-Interrupt merkt sich die letzten 7 Tasten. Ergeben sie **FANTASY**, wird `Sheet_flag` (`$1D8`) gesetzt
und die Power-LED umgeschaltet. Im Spiel sind dann Zusatztasten aktiv (Quelle: `Agony_Parent_.s`, Labels
`Sheet_Next`, `F1`–`F4`):

| Taste | Wirkung |
|---|---|
| Return | Level beenden, weiter zum nächsten |
| F1 | untere Axt an/aus |
| F2 | obere Axt an/aus, alle 8 Zauber verfügbar |
| F3 | Schusswaffe eine Stufe weiter (0–3), Punkte `$20000` |
| F4 | Schusswaffe Stufe 3, beide Äxte, Punkte `$80000` |

### Bild und Text

- Bild: Extra-Halfbrite, **352 × 290 Pixel (Overscan)**, 6 Bitplanes; im Emulator ab Rasterzeile 32, die letzten
  Zeilen liegen außerhalb des PAL-Bilds ✔.
- Musik: ProTracker-Modul „mod.agony intro“ ✔.
- Schrift, Zeichenverfahren und Texttabelle: [Dateiformate](../dateiformate.md#schrift-des-menüs); Inhalte und
  Positionen: [Texte](../texte.md).

Reihenfolge der Seiten ✔:

0. PSYGNOSIS / PRESENTS / AGONY / BY / ART AND MAGIC
1. ARTWORK / FRANCK SAUER / MARC ALBINET
2. PROGRAMMING / YVES GROLET
3. GAME MUSIC / JEROEN TEL
4. PRODUCED / BY / STEVEN RIDING
5. TITLE MUSIC / TIM WRIGHT / FRANCK SAUER
6. END MUSIC / ROBERT LING / MARTIN WALL
7. LOADING MUSIC / R. LING / M. WALL / M. SIMONS / M. IVESON / A. BRIMBLE
8. FLASHBACK / COMPRESSOR / LAURENT / LARMINIER
9. DISK LOADER / MICHEL JANSSENS
10. QUALITY / ASSURANCE / GREG DUDDLE / CHRIS STANLEY / NICK BURCUMBE
11. COVER ART AND / LOGO DESIGN / TONY ROBERTS / ROGER DEAN
- danach Highscore-Tabelle (6 Einträge, Inhalt wie `Agony.00`)
- 12: Story-Seite beim Spielstart · 13: Highscore-Eingabe · 14: Schreibschutz-Hinweis

## Ladebild Level 1 (`load_sea`)

- Gemälde von Franck Sauer (Baum, Gewitterwolken, Meer); ein stehendes Bild ohne Farbanimation ✔.
- Ablauf: Bild anzeigen, Palette in 17 Schritten zu je 1 Bild einblenden, Musik (ProTracker-Modul „loading_sea“)
  starten, **Level laden und entpacken**, Palette in 17 Bildern ausblenden (Musik je Bild −2), warten bis die Musik
  stumm ist, `jmp $600`.
- Zeitachse ✔ (wie im Menü): `mt_init` im Startbild, im nächsten der erste Bild-Interrupt und der Bildzeiger, danach
  Einblenden in 17 Bildern. Am Ende: Ausblenden wie im Menü (`$61662`, 17 Schritte + 15 Bilder Musik), dann Level.
  Der Bild-Interrupt (`$61708`) spielt nur die Musik; ein Feuerknopf wird hier nicht abgefragt.
- Eigenheit: 29 Pixel oben links in der ersten Bildzeile fehlen (`mt_init` löscht die ersten 4 Byte des Bilds, siehe
  [Dateiformate](../dateiformate.md#ladebilder-load_level)).
- Prüfung: Bild aus der Datei = Emulator-Aufnahme, 100,00 % pixelgenau.

## Start von Level 1 (`sea`)

- Bildaufbau laut Copperliste ✔: oben eine Statuszeile in Hires mit 2 Bitplanes und goldenem Farbverlauf, darunter
  ab Rasterzeile `$3F` das Spielfeld im Dual-Playfield-Modus mit 6 Bitplanes; Himmelsverlauf über Farbe 0 pro
  Zeile; Details in [Dateiformate](../dateiformate.md#level-1-sea-zur-laufzeit).
- Ablauf Bild für Bild ✔ (Hires-Aufnahme, Takt 0 = erstes Bild mit der Copperliste des Levels):
  - Takt 0–1: Die Copperliste läuft, ihre Bitplane-Zeiger sind aber noch 0 – das Spielfeld zeigt Speicher ab Adresse 0
    als buntes Rauschen (O-008; im Nachbau nicht nachgebildet, E-033).
  - Takt 2: Himmelsverlauf, Regen und Eule; die Statuszeile ist noch leer.
  - Takt 3: „PRESS FIRE TO START“ erscheint (die Hauptschleife zeichnet den Text erst im Bild nach ihrem Beginn).
  - Takt 6: hinteres Playfield (Baum, Felsen, Wellen) und statische Ebene (Mond, Wolken, Berge) erscheinen auf
    einmal, sobald ihr erster Puffer in zwei Hälften fertig gezeichnet ist.
  - Der Text bleibt zuerst 39 Bilder stehen, dann blinkt er im Takt von 10 Hauptschleifen: 21 Bilder aus, 19 an
    (Löschen in Teil 2 der Schleife wirkt sofort, Neuzeichnen erst ein Bild später).
- Die Eule flattert (jedes zweite Bild eine von 16 Phasen) und lässt sich schon mit dem Joystick bewegen; die
  Landschaft steht, die Wellen bewegen sich, es regnet ✔. Feuer startet das Spiel in der nächsten Hauptschleife
  (Teil 2 sieht den Knopf, `Begin_To_Start` = 0) und löst zugleich den ersten Schuss aus.
- **Nachgebaut am 07.10.2026** (`core/level/`, E-032) und ab Takt 2 pixelgenau gegen den Emulator geprüft
  (`game/test/level1.test.ts`).
- Übersicht aller Stationen: `work/captures/ablauf_uebersicht.png`, Übergang Ladebild → Level:
  `work/captures/load_to_level_sheet.png`.

## Für den Nachbau

- Crack-Intro, „Insert Disk“-Aufforderungen und Ladezeiten entfallen (begründete Abweichung).
- Die Titelsequenz ist vollständig aus Code und Daten bestimmt und lässt sich bildgenau nachbauen. Das Ende von
  Einmal-Samples (Audio-Interrupt) bestimmt den Ablauf mit; der Kern berechnet es aus Länge und Periode
  (Dauer in Farbtakten = 2 × Länge in Wörtern × Periode, PAL-Takt 3.546.895 Hz).
- Story-Seite und Ladebild: Mindestdauer 150 Bilder, danach weiter per Feuer (E-025), weil die Ladezeit entfällt
  (Crack-Fassung: Story-Seite ≈ 26 s, Ladebild ≈ 88 s); dann blinkt der Bedienhinweis „PRESS FIRE“ / „FEUER DRÜCKEN“ (E-039).
- **Umgesetzt am 06.10.2026** (`core/screens/title.ts`, `menu.ts`, `loading.ts`) und Bild für Bild gegen Ablaufspuren
  des Emulators geprüft: Titelsequenz (1.480 Bilder: Farben, Hintergrund, Bild, Feuerband, Klangteppich, Lautstärken,
  Audio-DMA), Menü über einen ganzen Zyklus und Lauf 2 vom zweiten Zyklus über Feuer, Story-Seite und Ausblenden bis
  zum Ende des Ladebilds (Bildzeiger, Copper-Palette, Musikzustand, Audio-DMA). Pixelgenau: Feuerband (Interlace-
  Aufnahme, beide Halbbilder), Highscore-Tabelle und Story-Seite (Speicherabzüge). Tests: `game/test/title*.test.ts`,
  `game/test/menu.test.ts`.
- Noch nicht nachgebaut: Namenseingabe für den Highscore (kommt mit dem Spielende), Cheat „FANTASY“.
