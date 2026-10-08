# Agony-Remake – Projekt-Wiki

Nachbau des Amiga-Shoot-'em-ups **Agony** (Art & Magic / Psygnosis, 1992) als Browser-Spiel, in erster Linie für
Tablets; später zusätzlich als native App für iPadOS (eventuell auch iOS). Dieses Wiki ist das Gedächtnis des Projekts: Hier steht alles, was wir über das Original wissen, wie weit
der Nachbau ist, welche Entscheidungen gefallen sind und wie man die Werkzeuge benutzt.

Die verbindlichen Arbeitsregeln stehen in der [`CLAUDE.md`](../CLAUDE.md) im Projektordner.

## Seiten

**Projekt**

- [Status](status.md) – aktueller Stand, nächste Schritte, Verlauf
- [Arbeitsablauf](arbeitsablauf.md) – Sitzungen, Effort, „genau genug“, Standardabläufe für wiederkehrende Aufgaben
- [Features](features.md) – Checkliste: was vom Original nachgebaut ist, was in Phase 2 kommt
- [Enhanced-Fassung](enhanced.md) – Fahrplan für zuschaltbare Erweiterungen: Komfort, Story, Intro, Bilder, Plattformen
- [Texte](texte.md) – alle Spieltexte Englisch (Original) und Deutsch (Übersetzung), Schrift und Sonderzeichen
- [Bugs](bugs.md) – bekannte Fehler im Nachbau, in Werkzeugen und Eigenheiten des Originals
- [Entscheidungen](entscheidungen.md) – Architektur- und Designentscheidungen mit Begründung
- [Architektur](architektur.md) – technisches Konzept: Schichten, Plattformen (Web und native App), Rendering,
  Eingabe, Audio, Build, Tests
- [Setup](setup.md) – Umgebung, Werkzeuge, Referenz-Emulator, Befehle, geplante Mac-Umgebung
- [Referenzmaterial](referenzmaterial.md) – was in `reference/` liegt, inklusive des früheren Flash-Prototyps

**Das Original**

- [Überblick](original/ueberblick.md) – Eckdaten, Team, Story, Entstehung, Vermächtnis
- [Ablauf bis Level 1](original/startsequenz.md) – Titelsequenz, Menü, Abspann, Ladebild, Levelstart (aufgenommen)
- [Spielmechanik](original/spielmechanik.md) – Steuerung, Waffen, Zauber, Leben, Punkte
- [Level](original/level.md) – die sechs Welten, Reihenfolge, Gegner laut Quellcode
- [Grafik & Technik](original/grafik.md) – Playfields, Sprites, Copper-Tricks, Auflösung
- [Audio](original/audio.md) – Musikstücke, Komponisten, Formate, Mitschnitte

**Daten und Code**

- [Dateiformate](dateiformate.md) – Disketten, Packer, Spieldateien, Highscore, Datenformate
- [Quellcode](quellcode.md) – Landkarte des Original-Quellcodes von Yves Grolet

## Konventionen

- **Sprache:** Deutsch. Bezeichner aus dem Quellcode bleiben im Original (`Start_List`, `Poisson_Bl_1` …).
- **Stand-Datum:** Jede Seite trägt oben ein „Stand“-Datum; bei Änderungen aktualisieren.
- **Belege:** Jede Angabe soll ihre Herkunft erkennen lassen. Kennzeichnung bei Fakten über das Original:
  - ✔ belegt durch Quellcode, Spieldaten oder Beobachtung im Emulator
  - 🌐 nur aus Web-Recherche, noch nicht am Original geprüft
  - ❓ Vermutung oder ungeklärt
- **Bei Widersprüchen gilt der Quellcode.** Web-Angaben, die sich als falsch herausstellen, nicht löschen, sondern
  korrigieren und den Irrtum kurz vermerken.
- **Verlauf:** Größere Änderungen am Projekt mit Datum in [Status → Verlauf](status.md#verlauf) eintragen.
- **Pfade** zu Projektdateien in `Code-Schrift` relativ zum Projektordner angeben, z. B.
  `reference/source/YvesGrolet-sources/…`.
