# Das Original – Audio

Stand: 06.10.2026 · Legende: ✔ belegt · 🌐 nur Web-Recherche · ❓ Vermutung/ungeklärt

## Überblick

- Insgesamt 17 Musikstücke 🌐 von acht Musikern 🌐 (Namen siehe [Überblick](ueberblick.md#team)).
- Titelmusik: Tim Wrights Klavierstück 🌐. Es ist das ProTracker-Modul „mod.agony intro“ im **Menü** (`igt`) ✔,
  läuft also erst nach der Präsentation. Eigenheit: Ein Ton liegt in der falschen Oktave, weil sich die besseren
  Klavier-Samples nicht weit genug transponieren ließen 🌐.
- Die Präsentation davor (`present`) hat keine Musik im engeren Sinn, sondern eine Klanglandschaft aus Samples ✔
  (siehe unten). ❓ Ob dies der Anteil von Franck Sauer an „TITLE MUSIC“ im Abspann ist.
- Ingame-Musik: Jeroen Tel, orchestral und wuchtig 🌐.
- Lademusik: kürzere, ruhigere Stücke verschiedener Musiker 🌐.
- Soundeffekte: eigenes Modul `Ag_Sounds.s` („SOUNDS MODULE“, 1,8 KB) ✔. Schussgeräusche gelten als gelungen,
  Explosionen als eher schwach 🌐.

## Ingame-Musik ✔

`Agony_Parent_.s` bindet je nach Level eines von vier Stücken ein:

| Level | Include |
|---|---|
| 1 Meer, 6 Feuer | `Muzack/Sea&Fire.s` |
| 2 Wald | `Muzack/Forest.s` |
| 3 Sumpf, 5 Hochland | `Muzack/Marshes&Highlands.s` |
| 4 Berge | `Muzack/Mountains.s` |

Die `Muzack/`-Dateien fehlen im Archiv. Erhalten sind Jeroen Tels Arbeitsdateien:

- `YvesDisks/PC_Files/AgonyIntro/` (Diskname „Agony Music -Jeroen Tel/TSC-“): `00 Agony Audio FIRE.S`, `…FORE.S`,
  `…HIGH.S`, `…MARS.S`, `…Sequ.S` und vier Sample-Ordner mit 8SVX-Samples (`samples/`, `samples2/`, `samples3/`,
  `samplesI/`). Der Kopf von `…FORE.S` nennt das Stück „AGONY levl FOREST“.
- `YvesDisks/PC_Files/AgonyDosBoot/`: `00 Agony Audio Sequ.S`, `Audio_Drivers.s`, `Forest.s`.
- ❓ Wie sich FIRE, FORE, HIGH, MARS und Sequ auf die vier Includes verteilen, ist noch zu klären.

### Jeroen Tels Audio-Treiber ✔

Die Musik läuft über Tels eigenen „Amiga Audio Driver“ (The Sonic Circle, 1991). Die Stücke sind als
Assembler-Daten geschrieben; das Befehlsformat ist im Dateikopf dokumentiert. Kurz zusammengefasst:

- **Sequenzen** je Kanal: Liste von Step-Nummern, dazwischen Befehle für Transponieren, Wiederholen und Rücksprung.
- **Steps:** Noten mit Längen, Pausen, Glissando, Lautstärke, gebundene Noten, Arpeggios und die Auswahl des
  Instruments („Soundeffekt“).
- **Instrumente:** Lautstärke, Vibrato-Tiefe und -Geschwindigkeit und weitere Parameter, dazu die 8SVX-Samples.

Achtung: Treiber und Musikdaten tragen einen eigenen Copyright-Vermerk; Weitergabe nur mit Tels schriftlicher
Erlaubnis. Grolets Lizenz gilt dafür nicht. Für die private Nachbildung unkritisch, vor einer Veröffentlichung
klären (siehe `CLAUDE.md`, Abschnitt Rechtliches).

## Titelsequenz (`present`)

Fünf Samples ✔ (8 Bit, Adressen in [Dateiformate](../dateiformate.md#ton)), vom Code direkt über die Audio-Register
gestartet; Ablauf und Zeitpunkte in [Ablauf bis Level 1](startsequenz.md#ton-der-titelsequenz-bild-interrupt-ef0).

| Sample | Länge | Einsatz |
|---|---|---|
| A, B | je 44.850 Byte | Stereo-Klangteppich auf Kanal 0/1 in Schleife, Periode 244 (≈ 14,5 kHz) und alle 10 Bilder um 1 kleiner – der Klang steigt während der ganzen Sequenz langsam an |
| C | 34.306 Byte | einmal auf Kanal 2 (Periode 194) nach dem Feuerband, 25 Bilder nach dessen Ende nochmals tiefer auf Kanal 3 (Periode 217) |
| D | 22.716 Byte | Kanal 2 + 3 in Schleife (Periode 152) ab „and“, ein- und ausgeblendet |
| E | 13.978 Byte | Echo beim Agony-Logo: dreimal auf Kanal 2 und 10 Bilder später auf Kanal 3, immer leiser (Kanal 3 wird wegen eines Fehlers jeweils abgeschnitten) |

Nachbau (06.10.2026): Die Samples liegen als 8-Bit-Rohdaten im Build und laufen über das Paula-Modell mit denselben
Perioden, Lautstärken und Zeitpunkten (`core/screens/title.ts`). Das Ende eines Einmal-Samples bestimmt den Ablauf mit;
der Kern berechnet es aus Länge und Periode und schaltet den Kanal im selben Moment ab wie das Original (E-030).
Abgleich mit dem Emulator: Ein- und Ausschalten aller Kanäle, Perioden und Lautstärken stimmen in jedem Bild ✔.
Gemessene Einschaltdauern (Bilder): C auf Kanal 2 = 93, C auf Kanal 3 = 104, E = 30 (Kanal 3 jeweils mit Kanal 2
abgeschnitten).

## ProTracker ✔

- `Ag_Pt_Player.s` („PT MODULE PLAYER“) ist ein ProTracker-Abspieler.
- ProTracker-Module in den Spieldateien (Fundstellen in den entpackten Dateien):

| Datei | Offset | Modulname | Größe | Patterns | Samples |
|---|---|---|---|---|---|
| `igt` (Menü) | `0x2AE4` | mod.agony intro | 179.650 | 17 | 4 |
| `load_sea` | `0x1D3C` | loading_sea | 22.556 | 3 | 3 |
| `load_forest` | `0x1D3C` | loading_forest | 15.582 | 1 | 3 |
| `load_marshes` | `0x1D3C` | loading_marshes | 21.640 | 1 | 4 |
| `load_mountains` | `0x1D3C` | MOD.Loading_Mountain | 24.690 | 7 | 5 |
| `load_highlands` | `0x1D3C` | loading_highlands | 23.954 | 1 | 4 |
| `load_fire` | `0x1D3C` | loading_fire | 27.008 | 5 | 3 |
| `ending` | `0x21D4` | agony_end of game | 87.544 | 19 | 14 |

- Die Level selbst enthalten kein ProTracker-Modul; dort läuft Jeroen Tels Treiber (siehe oben).

### ProTracker-Abspieler (Menü und Ladebilder)

Aus der Disassembly und dem Abgleich mit dem Emulator ✔.

- In `igt` ab `$1DDA` (`mt_init`), `$1E70` (`mt_music`, aus dem Bild-Interrupt), Tabellen ab `$2AEA`, Kanaldaten ab
  `$2F9A` (4 × 44 Byte), Variablen `$30C6`–`$30E2`, Modul ab `$30E4`. In `load_sea` byte-gleich ab `$61F32` (nur
  verschoben, Modul ab `$6323C`) ✔. Adressen der Variablen: [Dateiformate](../dateiformate.md#protracker-abspieler).
- Es ist der ProTracker-2.x-Abspieler (Pattern-Delay, Finetune-Tabellen, E-Befehle, Funk) mit einer Änderung von
  Art & Magic: Lautstärken gehen nicht direkt an Paula, sondern über `$30D8` in einen Zwischenspeicher je Kanal
  (`$30DA`–`$30E0`). Jedes Bild schreibt der Abspieler für alle vier Kanäle „Lautstärke − 64 + Gesamtlautstärke“
  (`$30E2`, mindestens 0). Menü und Ladebild setzen die Gesamtlautstärke auf 64 und ziehen beim Ausblenden je Bild 2
  ab; gewartet wird, bis sie 0 ist ✔.
- Tempo nur über den Bild-Interrupt (Fxx setzt die Zahl der Bilder je Zeile, kein CIA-Tempo).
- Eigenheiten (aus dem Code, bekannt vom ProTracker-2.x-Abspieler): 9xx wird bei einer neuen Note zweimal angewandt;
  die Tremolo-Rampe prüft die Vibrato-Position; `SetTonePorta` rechnet mit 37 statt 36 Perioden je Finetune-Zeile
  (`MULU #$4A`); `mt_LowMask` ist nach dem Laden 0 (das erste 1xx/2xx gleitet nicht); E0x schaltet den Tiefpass
  (Power-LED). Die Module des Spiels nutzen davon nur C, F, A, 3 und B, alle mit Finetune 0.
- `mt_init` sucht die höchste Patternnummer wie üblich mit einer Schleife, die bei jeder neuen Höchstzahl einen
  Durchlauf mehr verbraucht (für die vorhandenen Module ohne Folgen).
- Nachbau: wörtliche Portierung in `core/protracker.ts`; Periodentabelle, Vibrato-Sinus und Funk-Tabelle liest die
  Asset-Pipeline aus `igt` (`pt.periods`, `pt.sine`, `pt.funk`). Abgleich mit dem Emulator über einen ganzen
  Menüzyklus und das ganze Ladebild: Tempo, Zähler, Song- und Patternposition, Perioden, Lautstärken und Audio-DMA
  stimmen in jedem Bild ✔.
- Eigenheit des Abspielers: `mt_init` löscht das erste Langwort jedes Samples, auch leerer Sample-Plätze; bei den
  Ladebildern trifft das die ersten Bildpixel (siehe [Dateiformate](../dateiformate.md#ladebilder-load_level)).
- Die Demo-Fassung (`YvesDisks/PC_Files/AgonyDemoDosBackup/` bzw. `Amiga_Disks/AgonyDemoDosBackup.adf`) enthält
  ProTracker-Module (Kennung `M.K.`):

| Datei | Größe | Modulname (Anfang) | Bemerkung |
|---|---|---|---|
| `mod.level_sea` | 48.036 | „agony-highla…“ | ❓ Name deutet auf Highlands |
| `mod.level_forest` | 50.400 | „foret“ | |
| `mod.loading_sea` | 77.790 | „loading_sea“ | |
| `mod.loading_forest` | 24.690 | „agony(volcan…“ | ❓ Name deutet auf einen Vulkan |
| `mod.ending` | 99.940 | „agony-endthe…“ | nur im ADF, nicht in `PC_Files` |

Die Demo-Module sind nicht unbedingt identisch mit der Musik des fertigen Spiels.

## Mitschnitte in `reference/agony/music/`

14 MP3-Dateien. Die Dateinamen und Titel-Tags widersprechen teilweise dem Quellcode und sind nur als grobe
Hörreferenz zu verwenden.

| Datei | Dauer | Titel-Tag | Anmerkung |
|---|---|---|---|
| `01-intro.mp3` | 4:22 | Intro | ❓ vermutlich Titelmusik (Tim Wright) |
| `02-loading-forest.mp3` | 0:11 | Loading Forest | |
| `03-forest.mp3` | 1:34 | Forest | |
| `04-loading-highlands.mp3` | 0:07 | Loading Highlands | |
| `05-highlands.mp3` | 1:32 | Highlands | |
| `06-loading-marshes.mp3` | 0:10 | Loading Marshes | |
| `07-loading-sea.mp3` | 1:57 | Loading Sea | ❓ ungewöhnlich lang für eine Lademusik |
| `08-loading-mountain.mp3` | 0:44 | Loading Mountain | |
| `09-level-2.mp3` | 2:34 | Mountain | ⚠ Level 2 ist laut Quellcode der Wald |
| `09-loading-fire.mp3` | 0:10 | Loading Fire | |
| `10-end-of-game.mp3` | 1:45 | End of Game | |
| `11-high-score.mp3` | 1:55 | High Score | |
| `11-level-4.mp3` | 4:17 | Marshes | ⚠ Level 4 sind laut Quellcode die Berge |
| `13-level-3-5.mp3` | 2:10 | Fire (Level 3/5 BGM) | ⚠ Level 3 + 5 nutzen laut Quellcode Marshes & Highlands |

`reference/my_game/res/03-forest.mp3` ist identisch mit `03-forest.mp3`.

## Offene Fragen

- Wo Tels Musikdaten und die Soundeffekte in den Level-Abbildern liegen (ProTracker-Module und Titel-Samples sind
  gefunden, siehe oben).
- Strategie für den Nachbau: Treiber nach TypeScript portieren oder Stücke vorab rendern (offener Punkt in
  `CLAUDE.md`).

## Quellen

- Quellcode: `Agony_Parent_.s` (Muzack-Includes), `Ag_Pt_Player.s`, `Ag_Sounds.s`, `AgonyIntro/`, `AgonyDosBoot/`,
  `AgonyDemoDosBackup/`
- Hardcore Gaming 101: https://www.hardcoregaming101.net/agony/
- ExoticA: https://www.exotica.org.uk/wiki/Agony_(game)
- Generation Amiga: https://www.generationamiga.com/2020/07/08/source-code-released-of-legendary-amiga-game-agony/
