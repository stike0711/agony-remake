# Enhanced-Fassung – Fahrplan für Erweiterungen

Stand: 06.10.2026

Grundsatz (Entscheidung E-019, vom Nutzer bestätigt): Der **Original-Modus** bleibt exakt wie 1992. Alle
Verbesserungen sind **zuschaltbar** und kommen erst nach Abschluss von Phase 1 – mit Ausnahme der Grundlagen in E0,
die das Original nicht verändern.

Ergänzung (E-040, 08.10.2026): Die Enhanced-Fassung wird ein **eigener, neuer Kern** auf Basis des fertigen
Nachbaus. Der Nachbau bleibt Original-Modus und Prüfstein (gleiche Replays, gleicher Spielzustand).

Reihenfolge nach Nutzen und Aufwand: Erst was wenig kostet und viel bringt, dann Story und Präsentation, zuletzt
große Grafik- und Inhaltsarbeiten. Aufwand: S = klein, M = mittel, L = groß.

## E0 – Grundlagen (parallel zu Phase 1)

| Punkt | Aufwand | Bemerkung |
|---|---|---|
| Zweisprachigkeit Deutsch/Englisch | M | ab dem ersten Code, siehe [Texte](texte.md) und E-021 |
| Optionsmenü (zunächst nur Sprache) | S | Vorschlag E-022; später Steuerung, Ton, Enhanced-Schalter |
| Einstellungen speichern | S | über die Speicher-Schnittstelle (Web und App) |
| Schalter-System für Enhanced-Optionen | S | alle Optionen standardmäßig aus |

## E1 – Komfort und Darstellung (direkt nach Phase 1)

| Punkt | Aufwand | Bemerkung |
|---|---|---|
| Flüssigere Bewegung auf 60/120-Hz-Displays | M | Zwischenpositionen beim Zeichnen, Spiellogik bleibt bei 50 Hz |
| Darstellungsfilter | S–M | CRT/Scanlines, Pixel-Art-Hochskalierer (xBR, ScaleFX) als Shader |
| Fehler des Originals beheben | S–M | je Fehler ein Schalter, z. B. Flackern, schwer sichtbare Gegner (Kontrasthilfe), Note in falscher Oktave; Liste in [Bugs](bugs.md#eigenheiten-und-fehler-des-originals) |
| Steuerung | M | Touch-Varianten, Autofire, Belegung, Empfindlichkeit |
| Ton | S | Musik und Effekte getrennt regelbar |
| Pause-Menü | S | Fortsetzen, Optionen, zurück zum Menü |

## E2 – Story und Präsentation

Im Original erzählt nur die Anleitung die Vorgeschichte; im Spiel gibt es nur die Story-Seite beim Start und den
Text am Ende (siehe [Überblick](original/ueberblick.md#story)).

| Punkt | Aufwand | Bemerkung |
|---|---|---|
| Anleitung beschaffen und auswerten | S | ✅ englisch ausgewertet (Vorgeschichte mit Bromire, Krocott, der Prüfung der beiden Schüler; Zauberliste), siehe [Überblick](original/ueberblick.md#anleitung-); deutsche Fassung noch nicht gefunden |
| Prolog: Vorgeschichte als Bildfolge | M | über den vorhandenen Gemälden, Text in der Original-Schrift, langsame Kamerafahrten, Musik; DE/EN |
| Welt-Texte auf den Ladebildern | S | je Welt zwei, drei Sätze; DE/EN |
| Epilog ausbauen | S–M | Abschluss der Geschichte nach „The End“ |
| Galerie | S | alle Gemälde, Logos, Titelbilder zum Ansehen |
| Remake-Abspann | S | ergänzt den Original-Abspann, ohne ihn zu verändern |

Für eine Veröffentlichung eigene Formulierungen statt des Anleitungstexts verwenden (Urheberrecht).

## E3 – Neues Intro und zusätzliche Bilder

| Punkt | Aufwand | Bemerkung |
|---|---|---|
| Neu inszeniertes Intro | L | Ersatz für das 1992 gestrichene Animations-Intro; z. B. animiert aus vorhandenen Gemälden. Marc Albinets veröffentlichte Skizzen nur mit Erlaubnis |
| Zusätzliche Story-Bilder | L | im Stil von Franck Sauer, neu gezeichnet oder KI-gestützt; Gefahr von Stilbrüchen |
| HD-Fassungen der Gemälde | M–L | Menü und Ladebilder profitieren am meisten |

## E4 – Spielinhalte

| Punkt | Aufwand | Bemerkung |
|---|---|---|
| Schwierigkeitsgrade | M | das Original kennt keine |
| Übungsmodus und Levelauswahl | S–M | |
| Zusätzliche Animationsphasen | L | nur gezielt, z. B. Endgegner mit sehr wenigen Phasen; erfordert neue Grafik |
| Bestenlisten | S–M | lokal; in der App über Game Center (nur mit geklärten Rechten bei Veröffentlichung) |
| Neu abgemischte Musik, neue Soundeffekte | L | Rechte der Komponisten beachten |
| Breitbild | M | nur mit Vorsicht: Mehr Sichtfeld verrät, wo Gegner erscheinen, und verändert das Spiel |

## E5 – Weitere Plattformen

| Punkt | Aufwand | Bemerkung |
|---|---|---|
| Native App für iPadOS/iOS | M | parallel zu Phase 1, sobald ein Mac da ist; siehe [Architektur](architektur.md#weg-zur-nativen-app) |
| Game Boy Advance | L | eigenes Projekt nach Phase 1 (siehe unten) |
| Nintendo Switch | L | nur mit Nintendo-Lizenz (siehe unten) |

### Game Boy Advance (Idee)

- Passt technisch gut: 240 × 160 Pixel (3:2 wie das Spielfeld), 4 Hintergrundebenen mit Hardware-Scrolling,
  Rastereffekte pro Zeile über HBlank-DMA (ähnlich dem Copper), 128 Sprites, Musik z. B. mit Maxmod (kann MOD).
- Aber: eigenes Projekt in C/C++ (devkitPro bzw. Butano), Grafiken müssen auf 240 × 160 verkleinert oder
  beschnitten werden (beides verändert das Spiel), Tests im Emulator mGBA.
- Vorbereitung schon jetzt: plattformneutraler Kern mit Ganzzahl-Arithmetik (E-020), Assets in neutralen Formaten,
  Replays als Prüfstein für jede Portierung.

### Nintendo Switch (Idee)

- Offizieller Weg: Registrierung im Nintendo Developer Portal, Freigabe als lizenzierter Entwickler, Entwicklerkonsole
  und Nintendo-SDK unter Geheimhaltung; Veröffentlichung im eShop mit Prüfung durch Nintendo. Setzt die Rechte am
  Spiel voraus (siehe Rechtliches) – für ein Fanprojekt ohne Rechte nicht möglich.
- Technik: kein brauchbarer Browser auf der Switch, also ein nativer Kern in C++ (oder Rust) oder eine Engine mit
  Switch-Export (z. B. Godot über Partnerfirmen, Unity). Ein TypeScript-Kern lässt sich nicht direkt mitnehmen.
- Homebrew (libnx/devkitPro) läuft nur auf veränderten Konsolen; kein Weg für eine Veröffentlichung.

## Rechtliches

Alles, was über die private Nutzung hinausgeht (Veröffentlichung, App Store), setzt geklärte Rechte voraus: Grafik
und Spiel (Psygnosis/Art & Magic bzw. Rechtsnachfolger), Musik (Komponisten), Anleitungstext (Psygnosis).
