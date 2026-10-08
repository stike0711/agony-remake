# Das Original – Grafik & Technik

Stand: 07.10.2026 · Legende: ✔ belegt · 🌐 nur Web-Recherche · ❓ Vermutung/ungeklärt

## Bildaufbau

- PAL-Lowres-Bild mit 320 × 256 Pixeln; das eigentliche Spielfeld ist **288 × 192 Pixel** groß (3:2) 🌐. Die
  Ebenen-Zerlegungen in `reference/agony/gfx/screenshots/sprite-tricks/` und `…/freigestellt/` haben genau dieses
  Format ✔.
- Das Darstellungsfenster reicht vertikal von Rasterzeile `$40` bis `$FF` 🌐, das sind 192 Zeilen.
- Laut Packung bis zu 144 Farben gleichzeitig 🌐.
- Auf Screenshots liegt eine Statuszeile über dem Spielfeld ✔ (Modul `Ag_Status.s`).

### Bildschirm-Modi im Überblick ✔

| Bildschirm | Modus | Auflösung | Farben | Bildfenster |
|---|---|---|---|---|
| Titelsequenz (`present`) | Hires, Interlace, 4 Bitplanes | 640 × bis 256 Zeilen (2 Halbbilder) | 16, Farbe 1 beim Feuerband pro Zeile | je Bild eigenes `DIWSTRT`/`DIWSTOP`, grauer Rand (`$666`) |
| Menü, Ladebilder | Lowres, 6 Bitplanes, Extra-Halfbrite | 352 × 290 (Overscan) | 32 + 32 halbe Helligkeit | `$2071`–`$42D1` |
| Statuszeile im Level | Hires, 2 Bitplanes | 640 breit, Zeilen `$2D`–`$3E` | 4, Farbe 3 mit Verlauf pro Zeile | `$2D90` … |
| Spielfeld | Lowres, Dual-Playfield, 6 Bitplanes | 288 × 192 | 2 × 7 + Himmelsverlauf | ab Zeile `$3F` |

Details und Fundstellen: [Dateiformate](../dateiformate.md). Der Renderer des Nachbaus muss alle vier Modi
abdecken; Hires-Interlace ergibt bei der Ausgabe 640 × 512 Bildpunkte für ein 320 × 256-Lowres-Raster.

## Dual-Playfield und die dritte Ebene ✔

Agony nutzt den Dual-Playfield-Modus: zwei unabhängige Bildebenen mit je 3 Bitplanes (je 8 Farben).

| Ebene | Bitplanes | Farben | Inhalt | Bewegung |
|---|---|---|---|---|
| vorderes Playfield | 1, 3, 5 | 7 + transparent | Vordergrund | scrollt mit 50 fps |
| hinteres Playfield, Teil 1 | 2 | 1 + transparent | Mond, Wolken, Berge | steht still |
| hinteres Playfield, Teil 2 | 4, 6 | 3 + transparent | Bäume, Felsen, Meer | wird mit 25 fps neu gezeichnet |
| Hintergrundfarbe | – | Copper-Verlauf | Himmel | – |

**Der Trick:** Grolet teilt das hintere Playfield in zwei Ebenen. Dessen Farbindex setzt sich aus den Bitplanes 2
(Wert 1), 4 (Wert 2) und 6 (Wert 4) zusammen:

- Nur Bitplane 2 gesetzt → Farbe 9: die statische Ebene. Ihre Farbe ändert der Copper in Bändern, daher der Verlauf
  auf Mond und Wolken.
- Bitplane 4 oder 6 gesetzt → Farben 10–15. Diese Register sind paarweise gleich belegt (10 = 11, 12 = 13,
  14 = 15). Dadurch ist es egal, ob an derselben Stelle auch Bitplane 2 gesetzt ist: Die scrollende Ebene verdeckt
  die statische.
- Nichts gesetzt → durchsichtig, man sieht die Hintergrundfarbe mit dem Himmelsverlauf.

So entstehen drei Parallax-Ebenen plus Himmel, obwohl die Hardware nur zwei Playfields kennt.

✔ Belegt durch Code und Nachbau (Level 1, pixelgenau gegen den Emulator): `BPLCON0 $6600`, `BPLCON2 $24` (alle Sprites
vor beiden Playfields, Playfield 1 vor 2). Die Planes 4 und 6 liegen verschränkt in einem Puffer; die Copperliste
überspringt an jeder Bandgrenze mit `BPL2MOD = $502` die Zeilen der anderen Plane ([Dateiformate](../dateiformate.md#adressen-im-abbild-sea-)).
Das hintere Playfield wird in zwei Hälften gezeichnet (je Hauptschleife 5 Spalten à 32 Pixel) und erst danach
gezeigt, wechselt also mit 12,5 Hz; die Wellen-Animation schaltet im selben Takt weiter (alle 4 Bilder).

## Hardware-Sprites ✔

| Sprites | Verwendung |
|---|---|
| 0–3 | die Eule (32 Pixel breit): zwei angehängte („attached“) Paare mit je 16 Farben (16–31); in denselben Listen die obere und untere Axt |
| 4 | Schuss der Eule (ohne Schuss leeres Sprite) |
| 5 | Gegnerschüsse (bis zu 12, eine Liste) |
| 6–7 | Regen in Level 1: je 24 Tropfen untereinander (Multiplexing), Farben 29–31; sonst Zauber und Bonusse |

Belegt durch `Ag_Sprites.s`, die Disassembly von `sea` und den Nachbau (Web-Recherche hatte 4–5 als Spielerschüsse
angegeben). Beim Tod der Eule zeigen alle 8 Sprites je ein Teil der Explosion (Listen à 33 Langwörter ab `Die_Spr`
`$20190`), beim Schild nach dem Wiedereinstieg zeigen Sprite 6/7 die Eule mit Schild (`Sorcerer2_Dat` `$1B8F0`).

✔ Sprite-DMA, bestätigt gegen den Emulator (Tod der Eule, O-014): In der Endzeile (VSTOP) holt die DMA die nächsten
Steuerwörter, auch wenn das Sprite nie zu sehen war (Startzeile vor der Sprite-DMA ab Zeile `$19`, z. B. durch den
8-Bit-Überlauf am unteren Rand). Nennen die neuen Steuerwörter dieselbe Zeile als Start, beginnt das Sprite erst in der
nächsten Zeile, weil die DMA-Plätze der Zeile schon verbraucht sind.

✔ Copper und Farbbänder: An jeder Bandgrenze des vorderen Playfields setzt die Copperliste die Farben 1–6 am Ende der
Zeile davor, Farbe 7 erst nach `WAIT h=$42`. Durch den Bitplane-Abruf verzögert wirkt Farbe 7 etwa 50 Pixel nach
dem linken Rand (W-015).

✔ `Ag_Pre_comp.s` („PRECOMPUTE MODULE“) baut beim Start mit dem Blitter Masken für 8-farbige Sprites
(„BUILD 8 COL. SPR. MASK“). `Ag_Sprites.s` enthält die Sprite-Verwaltung.

## Copper-Effekte

- ✔ Pro Rasterzeile setzt der Copper eine Verlaufsfarbe (ab horizontaler Position `$42`) und schaltet sie am
  Zeilenende (Position `$D6`) wieder auf Schwarz. Daher kommen der Himmelsverlauf und die schwarzen Ränder; im
  Emulator ist der ganze Rand außerhalb des Fensters schwarz, das Fenster ganz in der Verlaufsfarbe.
- ✔ Farbe 9 (statische Ebene) wird in Bändern geändert (Level 1: 16 Stufen).
- ✔ **Flacker-Trick:** Die Copperliste hat zwei Hälften (`Cl_Flip_Phase0`/`1`), die sich in jedem Bild abwechseln;
  in Level 1 unterscheiden sich 139 der 384 Himmelsfarben um eine Stufe. Das Auge mischt sie zu feineren
  Abstufungen. Auf Screenshots und in Emulatoren sieht das schlecht aus (Nachbau bei 60/120 Hz: B-001).
- 🌐 Paletten werden auch während des Spiels getauscht, zum Beispiel für Blitze oder Gegner.
- ✔ `Ag_Copper_List.s` („COPPER LIST“, rund 104 KB) enthält die Copperlisten. Die Wellen-Parameter der Level
  enthalten ebenfalls Farbänderungen (`AWS_Pal_Mod_…`, siehe [Level](level.md)).

## Animationen

- 🌐 Wasser (Level 1): 12 Phasen, alle 4 Bilder wird die nächste gezeichnet.
  `reference/agony/gfx/screenshots/sprite-tricks/agony_water_anim.gif` (288 × 32) zeigt die Animation.
- ❓ `reference/my_game/res/waves.txt` (eigene Notiz aus dem Flash-Prototyp) ordnet Phasen der linken und rechten
  Bildhälfte einander zu; die rechte Hälfte ist darin um 5 Phasen versetzt.
- 🌐 Die Eule ist sehr flüssig animiert (`reference/agony/gfx/owl.gif`: 15 Phasen).

## Was das für den Nachbau heißt

- Interne Auflösung 288 × 192 für das Spielfeld (plus Statuszeile); Ausgabe pixelgenau skaliert.
- Renderer mit getrennten Ebenen: Himmel (Farbe pro Zeile), statische Ebene (1 Farbe pro Zeile), hintere
  scrollende Ebene (25 fps), vordere Ebene (50 fps), Sprites.
- Grafiken indiziert halten und Paletten pro Rasterzeile anwenden; das bildet die Copper-Effekte direkt nach.
- Flacker-Trick auf 60/120-Hz-Displays durch die Mischfarbe der beiden Verläufe ersetzen (begründete Abweichung).

## Referenzbilder in `reference/agony/gfx/`

| Datei | Größe | Inhalt |
|---|---|---|
| `agony_rip.gif` | 736 × 736 | Grafik-Rip mit Kacheln von Level 1 (Wellen, Felsen, Baum) |
| `owl.gif` | 730 × 128 | Flug-Animation der Eule, 15 Phasen |
| `bg1.psd`, `fg1.psd` | 1300 × 300, 1900 × 300 | zusammengesetzter Hinter- und Vordergrund von Level 1 |
| `screenshots/*.png` | 640 × 480 | MobyGames-Screenshots (Titel, Spiel, Endgegner Level 1) |
| `screenshots/*` | 320 × 256 / 320 × 215 | native Screenshots |
| `screenshots/freigestellt/` | 288 × 192 | einzelne Ebenen und Schuss |
| `screenshots/sprite-tricks/` | 288 × 192 | Ebenen-Zerlegung (statisch, hinten, vorne, Sprites) und Wasser-Animation |

Diese Bilder dienen nur zur Orientierung. Datenquelle für den Nachbau sind die Spieldateien.

## Quellen

- Codetapper, Sprite-Tricks in Agony: https://codetapper.com/amiga/sprite-tricks/agony
- Wikipedia: https://en.wikipedia.org/wiki/Agony_(1992_video_game)
- Hardcore Gaming 101: https://www.hardcoregaming101.net/agony/
- Lilura1: https://lilura1.blogspot.com/2022/04/Agony-Amiga-1992-Art-and-Magic-Yves-Grolet.html
- Quellcode: `Ag_Copper_List.s`, `Ag_Pre_comp.s`, `Ag_Sprites.s`, `Ag_Status.s`
