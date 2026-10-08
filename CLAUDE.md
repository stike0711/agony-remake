# CLAUDE.md – Agony (Amiga) als Browser-Spiel für Tablets

## Worum es geht

Dieses Projekt baut den Amiga-Klassiker **Agony** (Art & Magic / Psygnosis, 1992) originalgetreu nach. Das Spiel
soll **im Browser laufen** und in erster Linie **auf Tablets** gespielt werden (Touch, Querformat, Vollbild).
Später entsteht daraus zusätzlich eine **native App für iPadOS**, eventuell auch für iOS (iPhone).

Der **Original-Quellcode ist erhalten**: 68000-Assembler von Yves Grolet, 2020 veröffentlicht, nicht-kommerzielle
Lizenz. Er liegt in `reference/source/` und ist die **maßgebliche Referenz** für Spiellogik, Timings und
Datenformate. Verhalten wird daraus abgeleitet, nicht geraten.

Alles Wissen über das Original, den Projektstand, die Entscheidungen und die Werkzeuge steht im **Wiki**
(Einstieg: `wiki/README.md`). Diese Datei enthält nur Regeln, Struktur und Verweise.

## Grundregeln

1. **Wiki aktuell halten.** In `wiki/` liegen Markdown-Dateien mit allen relevanten Informationen: Wissen über das
   Original, Status, Bugs, Features, Entscheidungen, Setup (Aufbau siehe unten). Nach jeder nennenswerten Änderung
   oder Erkenntnis aktualisieren. Das Wiki ist das Gedächtnis des Projekts.
2. **Installieren, was nötig ist.** Benötigte Werkzeuge, Pakete und Programme (npm-/Python-Pakete,
   Referenz-Emulator, Konverter …) selbstständig installieren und in `wiki/setup.md` festhalten.
3. **Zuerst die vollständige, originalgetreue Nachbildung:** alle 6 Level, Gegner, Endgegner, Waffen, Zauber,
   Musik, Soundeffekte, Titel/Menü, Ladebilder, Highscore und Spielende. Keine eigenen Erweiterungen, solange
   das Original nicht komplett nachgebaut ist. Unvermeidbare Abweichungen (v. a. Touch-Steuerung, Bildwiederholrate,
   Seitenverhältnis) im Wiki begründen.
4. **Danach moderne Features**, z. B. an Bildschirm und Auflösung angepasste Darstellung (Retina, beliebige
   Seitenverhältnisse), höher aufgelöste Assets, flüssige Darstellung auf 60/120-Hz-Displays, Einstellungsmenü
   (Steuerung, Lautstärke, Autofire), lokale Highscores, Offline-Nutzung (PWA), Gamepad-Unterstützung.
5. **Zielplattform: Browser auf aktuellen Tablets**, also iPadOS (Safari) und Android (Chrome), Bedienung per Touch,
   Querformat, Vollbild. Desktop-Browser unter Windows, macOS und Linux (Tastatur, Gamepad) müssen ebenfalls
   funktionieren, schon für Entwicklung und Tests. **Zusätzlich geplant:** eine native App für iPadOS, eventuell
   auch iOS (iPhone), sobald ein Mac zur Verfügung steht (laut Nutzer in ein bis zwei Monaten, Stand 06.10.2026).
   Der Code wird von Anfang an so geschrieben, dass er ohne Umbau in die native App passt.

## Arbeitsweise

- **Sprache:** Kommunikation, Wiki und Code-Kommentare auf Deutsch; Code-Bezeichner und Dateinamen auf Englisch.
- **`reference/` ist nur Lesequelle.** Dort nichts ändern, verschieben oder löschen. Abgeleitete Daten erzeugen
  Skripte nach `work/` bzw. über die Asset-Pipeline.
- **Herkunft belegen:** Aus dem Original übernommene Werte (Geschwindigkeiten, Tabellen, Gegnerwellen, Punkte,
  Trefferzonen) mit Quelle kommentieren, z. B. `// Quelle: Ag_Game_LMER.s, Label Start_List`. Im Wiki Fakten über
  das Original kennzeichnen: ✔ belegt, 🌐 nur Web-Recherche, ❓ Vermutung.
- **Vergleichen statt schätzen:** Bei Unklarheiten den Quellcode lesen und/oder das Original im Referenz-Emulator
  ansehen: `node tools/emulator/server.ts` (oder Vorschau „emulator“), dann `http://localhost:8090/agony`.
  Bedienung, JavaScript-Steuerung, Bild- und Speicherzugriff: `wiki/setup.md`.
- **Änderungen prüfen:** Dev-Server starten, im Browser prüfen (Tablet- und Smartphone-Viewport, Querformat), Tests
  laufen lassen, Ergebnis im Wiki festhalten.
- **In Schritten arbeiten:** Nach jedem Arbeitsschritt anhalten, Ergebnis kurz zusammenfassen und den sinnvollen
  Aufwand (Effort-Einstellung) für den nächsten Schritt empfehlen; der Nutzer stellt ihn vor dem Weitermachen ein.
- **Standardabläufe nutzen** (`wiki/arbeitsablauf.md`, E-038): Vor jedem Schritt den passenden Ablauf lesen und ihm
  folgen; begründet abweichen ist erlaubt. Sitzungen klein schneiden (ein Schritt je Sitzung, Übergabe über
  `wiki/status.md`), große Dateien nur ausschnittsweise lesen. Effort im Regelfall „mittel“, „hoch“ für Neues,
  „maximal“ nur selten. Genauigkeitsregel: Spielzustand immer exakt; Versatz um 1 Pixel in einzelnen Bildern ohne
  Folgen wird toleriert und notiert, nicht weiter verfolgt.
- **Kein Git:** Das Projekt läuft bewusst ohne Versionskontrolle. Vor größeren Umbauten oder Löschungen eine
  Sicherungskopie in `backup/` anlegen, mit Datum im Dateinamen (z. B. `backup/2026-10-06_CLAUDE.md`).
- **Ein Ordner für zwei Rechner:** Das Projekt liegt auf einem NAS; der Windows-PC (Laufwerk `P:`) und später der
  Mac greifen gleichzeitig darauf zu. Deshalb:
  - Skripte und Build laufen unter Windows, macOS und Linux, ohne feste Laufwerkspfade (Pfade relativ zum Projekt
    bzw. Skript).
  - Textdateien in UTF-8 mit Zeilenenden LF (`.editorconfig`).
  - Dateinamen in exakter Schreibweise, keine symbolischen Links.
  - Dieselben Dateien nie gleichzeitig auf beiden Rechnern bearbeiten.
  - Projektwissen gehört ins Wiki, denn Claudes eigene Erinnerungen sind pro Rechner getrennt.

  Details, Umgebung und Befehle: `wiki/setup.md`.

## Kernfakten

Kurzfassung; Details und Belege im Wiki.

- Horizontal scrollender Shoot-'em-up, PAL mit 50 Hz. Spielfeld 288 × 192 Pixel (3:2) im 320 × 256-Bild;
  Dual-Playfield, Copper-Farbverläufe, Hardware-Sprites (`wiki/original/grafik.md`).
- 6 Level in dieser Reihenfolge: Meer (`LMER`), Wald (`LFORET`), Sumpf (`LMARAIS`), Berge (`LMONTAGNES`),
  Hochland (`LPLATEAUX`), Feuer (`LFEUX`) (`wiki/original/level.md`).
- Datenquelle sind die drei vollständigen Spieldisketten in `reference/agony/game/Agony/` (Crack-Fassung, Dateien
  PowerPacker-gepackt). Ausgelesen und entpackt liegen sie in `work/adf/` und `work/unpacked/`. Die Level-Abbilder
  sind für Adresse `$600` assembliert (`wiki/dateiformate.md`).
- Quellcode: Hauptstand in `reference/source/YvesGrolet-sources/YvesHDD/Work HDD partition/Agony/`, Level-Module in
  `reference/source/YvesGrolet-sources/YvesDisks/PC_Files/AgonyDosBoot/` (`wiki/quellcode.md`).

## Technische Leitplanken

Verbindlich. Begründungen und Details in `wiki/architektur.md`; Abweichungen in `wiki/entscheidungen.md`
begründen.

- **Neuimplementierung** in TypeScript (strict) mit Vite, ohne Game-Engine. Ein Emulator dient nur als Vergleich und
  wird nie Teil des Spiels.
- **Plattformneutraler Kern:** Die Spiellogik in `game/src/core/` nutzt weder DOM noch Browser-APIs. Rendering,
  Audio, Eingabe, Speicher, Lebenszyklus und Anzeige laufen nur über Schnittstellen (`game/src/platform/`); die
  Web-Umsetzung kommt jetzt, die native Umsetzung später (voraussichtlich mit Capacitor).
- **Native-tauglich ab dem ersten Code:** nur relative Pfade, alle Assets im Build, die Grundfunktion hängt nicht
  von Web-only-APIs ab (Service Worker, Fullscreen API, Web-App-Manifest sind optionale Extras der Web-Fassung).
- **Rendering** mit WebGL2: Grafiken indiziert, Paletten pro Rasterzeile (Copper); interne Auflösung wie im
  Original, pixelgenau skaliert; Safe Areas und Pixeldichte beachten.
- **Spielschleife** in festen 50-Hz-Schritten, deterministisch (Zufallsgenerator des Originals), Rendering per
  `requestAnimationFrame`. Eingaben lassen sich als Replays aufzeichnen. Der Kern rechnet wie das Original mit
  Ganzzahlen bzw. Festkomma, nicht mit Gleitkomma (E-020).
- **Original zuerst:** Phase 1 bildet auch Fehler und Eigenheiten des Originals nach; Verbesserungen kommen später
  als zuschaltbare Optionen (E-019, Fahrplan in `wiki/enhanced.md`).
- **Zweisprachig Deutsch/Englisch ab dem ersten Code** (E-021): Kein Spielertext steht fest im Code, alles kommt über
  Schlüssel aus Sprachtabellen. Englisch = Originaltexte samt Positionen (von der Pipeline erzeugt), Deutsch =
  Übersetzung in derselben Schrift (Ä/Ö/Ü per Skript ergänzt). Voreinstellung nach Gerätesprache, Wahl im
  Optionsmenü (`wiki/texte.md`).
- **Eingabe** über einen virtuellen Amiga-Joystick (Touch, Tastatur, Gamepad), Bedienlayouts für iPad, iPhone im
  Querformat und Desktop.
- **Build:** Quellen in `game/`, `npm run build` erzeugt `server/` (`index.html` + Assets) jedes Mal komplett neu;
  `server/` nie von Hand bearbeiten. Aufruf nur über einen Webserver, nicht per `file://`.
- **Leistung und Tests:** keine Allokationen in der Spielschleife; Vitest für den Kern (ohne Browser), Replays als
  Regressionstests.
- **Asset-Pipeline** in `tools/`: alles per Skript aus `reference/` reproduzierbar, erzeugte Assets nicht von Hand
  bearbeiten, Ausgabe in neutralen Formaten (PNG/JSON/Audio). Node/TypeScript bevorzugt, Python für Analysen
  erlaubt.

## Projektstruktur

```
CLAUDE.md      diese Datei: Regeln, Struktur, Verweise
wiki/          Projekt-Wiki, Einstieg wiki/README.md
reference/     Originalmaterial, Original-Quellcode, früherer Flash-Prototyp (nur lesen); Inventar: wiki/referenzmaterial.md
tools/
  emulator/    Referenz-Emulator: vAmigaWeb + lokaler Server (server.ts, fetch-vamigaweb.ts)
  analysis/    Analyse-Skripte (Python): ADF-Lister, PowerPacker-Entpacker, Startlisten, Disassembler
  pipeline/    Asset-Pipeline (TypeScript): Disketten → game/public/data/
work/          Zwischenergebnisse (ausgelesene Disketten, entpackte Spieldateien, Emulator-Mitschnitte); neu erzeugbar
backup/        Sicherungskopien vor größeren Umbauten
.claude/       launch.json für die Vorschauen „emulator“, „game“ (Dev-Server) und „game-build“
.editorconfig  UTF-8 und Zeilenenden LF für beide Rechner
game/          Quellcode der Web-App (Vite + TypeScript), später auch der nativen App-Hülle
server/        das spielbare Spiel = Build-Ausgabe von game/; wird generiert
```

## Wiki

| Seite | Inhalt |
|---|---|
| `wiki/README.md` | Index und Konventionen |
| `wiki/status.md` | Fahrplan, Fortschritt, nächste Schritte, offene Fragen, Verlauf |
| `wiki/arbeitsablauf.md` | Sitzungen, Effort, Genauigkeitsregel, Standardabläufe |
| `wiki/features.md` | Checkliste: Phase 1, native App, Phase 2 |
| `wiki/enhanced.md` | Fahrplan der zuschaltbaren Erweiterungen (E0–E5) |
| `wiki/texte.md` | alle Spieltexte Englisch/Deutsch, Schrift und Sonderzeichen |
| `wiki/bugs.md` | Fehler im Nachbau und in Werkzeugen, Eigenheiten des Originals |
| `wiki/entscheidungen.md` | Entscheidungen mit Begründung |
| `wiki/architektur.md` | technisches Konzept: Schichten, Plattformen, Rendering, Eingabe, Audio, Build, Tests |
| `wiki/setup.md` | Umgebung, Werkzeuge, Emulator-Bedienung, Befehle, geplante Mac-Umgebung |
| `wiki/referenzmaterial.md` | Inventar von `reference/` |
| `wiki/original/` | das Original: Überblick, Spielmechanik, Level, Grafik & Technik, Audio |
| `wiki/dateiformate.md` | Disketten, Packer, Spieldateien, Startlisten, Highscore |
| `wiki/quellcode.md` | Landkarte des Original-Quellcodes |

## Fahrplan

Phase 1 (Nachbildung): 1. Wiki · 2. Quellcode kartieren · 3. Referenz-Emulator · 4. Asset-Pipeline ·
5. Web-Grundgerüst · 6. Level 1–6 · 7. Präsentation, Highscore, Ende. Parallel dazu, sobald ein Mac da ist: die
native App. Danach Phase 2 (moderne Features, Grundregel 4) als zuschaltbare Enhanced-Fassung in den Stufen E0–E5
(`wiki/enhanced.md`; E0 mit Sprachen und Optionsmenü läuft schon parallel zu Phase 1). Stand und Details:
`wiki/status.md`.

## Rechtliches

- Nicht-kommerzielles Fanprojekt. Die Rechte am Spiel liegen bei Psygnosis/Art & Magic bzw. deren
  Rechtsnachfolgern, die Rechte an der Musik bei den Komponisten. Der Quellcode steht unter Grolets
  nicht-kommerzieller Lizenz; das gilt auch für alles, was daraus abgeleitet wird. Die ADFs bietet Franck Sauer
  seit etwa 2010 kostenlos an.
- **Ausnahme im Quellcode:** Jeroen Tels Audio-Treiber und Musikdaten tragen einen eigenen Copyright-Vermerk
  (Weitergabe nur mit seiner schriftlichen Erlaubnis). Grolets Lizenz deckt diese Teile nicht ab.
- Den Inhalt von `reference/` (ROMs, ADFs, MP3s, Quellcode-Archiv) und extrahierte Original-Assets nicht öffentlich
  weiterverbreiten. `server/` und die native App enthalten später Original-Assets: Vor öffentlichem Hosting oder
  einer Veröffentlichung über TestFlight bzw. den App Store klären, was ausgeliefert werden darf.
