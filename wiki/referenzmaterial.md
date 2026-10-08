# Referenzmaterial (`reference/`)

Stand: 06.10.2026

Alles in `reference/` ist **nur Lesequelle**: nichts ändern, verschieben oder löschen. Abgeleitete Daten erzeugen
die Skripte in `tools/` nach `work/`.

## Übersicht

```
reference/
├─ agony/
│  ├─ game/       Spieldisketten, Kickstart-ROMs, alte ADF-Werkzeuge
│  ├─ gfx/        Grafik-Rips, zusammengesetzte Ebenen, Screenshots
│  └─ music/      MP3-Mitschnitte des Soundtracks
├─ manual/        Original-Anleitung (vom Nutzer abgelegt)
├─ my_game/       früherer Flash/AIR-Prototyp fürs iPad (2012/13)
└─ source/        Original-Quellcode von Yves Grolet (Aminet)
```

Bewertung: Die **Spieldisketten** und der **Quellcode** sind vollständige Datenquellen. Rips, Screenshots und
MP3s sind lückenhaft und dienen nur zur Orientierung (Entscheidung E-007).

## `agony/game/`

| Datei/Ordner | Inhalt | Verwendung |
|---|---|---|
| `Agony/agony-1.adf`, `-2.adf`, `-3.adf` | die drei Spieldisketten (Crack-Fassung „Crystal“) | **Hauptquelle**, Details in [Dateiformate](dateiformate.md) |
| `Agony.zip`, `Agony/Agony.zip` | enthalten dieselben drei ADFs | nicht nötig |
| `Kickstart Images (TOSEC-v0.03)/` | rund 90 ROM- und Kickstart-Disk-Images (Kickstart 0.7–3.1, CDTV/CD32, Action Replay …) | nur Referenz-Emulation; benutzt wird Kickstart 1.3 rev 34.5 (A500), Datei `Kickstart v1.3 rev 34.5 (1987)(Commodore)(A500-A1000-A2000-CDTV)[!].rom`, CRC32 `C4F0F55F` |
| `ADFOpus1_2.exe` | ADF-Werkzeug für Windows (2011) | nicht nötig, eigene Skripte in `tools/analysis/` |
| `amiga_disk_file_suite_v15/` (+ `.zip`) | ADF-Werkzeuge für Windows (1997, Visual Basic 3) | nicht nötig |

Die Kickstart-ROMs sind urheberrechtlich geschützt: nur lokal für den Emulator verwenden, nie weitergeben oder ins
Spiel einbauen.

## `agony/gfx/`

Grafik-Rip (`agony_rip.gif`), Flug-Animation der Eule (`owl.gif`), zusammengesetzte Ebenen von Level 1
(`bg1.psd`, `fg1.psd`) und Screenshots, darunter Ebenen-Zerlegungen im Spielfeldformat 288 × 192. Die vollständige
Tabelle steht in [Grafik & Technik](original/grafik.md#referenzbilder-in-referenceagonygfx). `Thumbs.db`-Dateien
sind Windows-Vorschaucaches und ohne Bedeutung.

## `agony/music/`

14 MP3-Mitschnitte. Dateinamen und Titel-Tags widersprechen teilweise dem Quellcode (z. B. `09-level-2.mp3` mit
Titel „Mountain“, Level 2 ist aber der Wald). Tabelle mit Dauern und Anmerkungen in
[Audio](original/audio.md#mitschnitte-in-referenceagonymusic).

## `my_game/` – früherer Flash/AIR-Prototyp (2012/13)

Ein eigener Versuch, Agony als iPad-App nachzubauen, mit Adobe Flash/AIR für 1024 × 768. **Nur als Ideenquelle;
kein Code wird übernommen** (veraltete Technik, keine originalgetreuen Daten).

Entstanden in einem Kurs an der FH Köln (KISD, daher die App-ID `de.kisd.…`); der Nutzer hatte sich Agony als
Projektidee ausgesucht. Video des Prototyps auf YouTube: https://youtu.be/Uv_tTFSlcL0

| Datei | Inhalt |
|---|---|
| `flash/Main.as` | ActionScript 3: Parallax mit Hinter- (2 px/Bild) und Vordergrund (5 px/Bild), Gegner alle 20 Bilder (höchstens 7), Schüsse alle 6 Bilder, Kollision, Game Over, Musik in Schleife. Steuerung: **Tippen setzt das Ziel der Eule** (sie fliegt mit 6 px/Bild dorthin), **Zwei-Finger-Tipp schießt**. |
| `flash/my_game-app.xml` | AIR-App-Beschreibung: ID `de.kisd.s.veigel.Agony`, Vollbild, Querformat, nur iPad |
| `flash/my_game.fla`, `.swf`, `.ipa` | Flash-Quelldatei (22 MB), kompiliertes Programm und fertiges iOS-App-Paket |
| `flash/AppIconsForPublish/`, `res/icons/` | App-Icons 29–114 px |
| `res/bg1.psd`, `res/fg1.psd` | Hinter- und Vordergrund von Level 1 in **Originalhöhe 192 px** (3200 bzw. 4700 px lang) – nützlich zum Vergleich mit extrahierten Daten |
| `res/bg1.png`, `res/fg1.png` | dieselben Ebenen hochskaliert (12000 × 733 bzw. 17943 × 733) |
| `res/static_bg1.png` | statischer Hintergrund (Mond, Wolken, Berge), hochskaliert auf 1024 × 768 |
| `res/owl.png` | Flug-Animation der Eule (1460 × 256) |
| `res/enemy1.png`, `res/shot.png`, `res/Explode3.bmp`, `res/Explode4.bmp` | ein Gegner, Schuss, Explosionen |
| `res/waves-sprite*.psd`, `res/waves.gif` | Wellen-Animation |
| `res/waves.txt` | Zuordnung der Wellenphasen von linker und rechter Bildhälfte (rechts um 5 Phasen versetzt) |
| `res/03-forest.mp3` | identisch mit `agony/music/03-forest.mp3` |

Für die geplante native App interessant: Die Steuerungsidee „Tippen setzt das Ziel“ ist eine weitere Variante für
den Touch-Prototyp-Vergleich (siehe [Architektur](architektur.md#eingabe)).

## `manual/`

Anleitung, vom Nutzer abgelegt (06.10.2026):

| Datei | Größe | Inhalt |
|---|---|---|
| `view-source_https___www.lemonamiga.com_doc_agony_38.html` | 129.660 Byte | gespeicherte Quelltextansicht der Lemon-Amiga-Seite https://www.lemonamiga.com/doc/agony/38, laut Nutzer leicht überarbeitet; die englische Anleitung steht im Text-Block der Seite: Mitwirkende, Story, Spielbeschreibung, Steuerung, Zauberliste |

- Im Browser geöffnet zeigt die Datei den HTML-Quelltext, nicht die gestaltete Seite.
- Ausgewertet in [Überblick](original/ueberblick.md#anleitung-) und
  [Spielmechanik](original/spielmechanik.md#die-acht-zauber--anleitung).
- Eine deutsche Fassung fehlt noch.

## `source/`

`YvesGrolet-sources.zip` und `.readme` von Aminet, entpackt nach `YvesGrolet-sources/`. Landkarte in
[Quellcode](quellcode.md).
