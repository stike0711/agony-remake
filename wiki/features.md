# Features

Stand: 06.10.2026

Legende: `[ ]` offen · `[~]` in Arbeit · `[x]` fertig und mit dem Original abgeglichen

## Phase 1 – Nachbildung des Originals

### Präsentation

- [x] Titelsequenz (`present`): Stereo-Hinweis, Psygnosis mit Feuerband, „and“, Art & Magic, „Present“,
      Agony-Logo; Sample-Klanglandschaft – bildgenau gegen den Emulator geprüft (06.10.2026, siehe
      [Ablauf bis Level 1](original/startsequenz.md#titelsequenz-present))
- [ ] Menü (`igt`): Bild mit brennendem Baum, Titelmusik von Tim Wright (ProTracker), Abspann-Seiten in der
      Original-Schrift, Highscore-Tabelle, Spielstart per Feuer, Story-Seite, Cheat „FANTASY“ – alles außer dem
      Cheat umgesetzt und bildgenau geprüft (06.10.2026)
- [ ] Ladebilder vor jedem Level (6 Gemälde von Franck Sauer) mit Lademusik – Level 1 umgesetzt und geprüft
- [ ] Highscore-Liste (6 Einträge) inklusive Namenseingabe und Speichern – Anzeige im Menü steht
- [ ] Spielende (`ending`) mit Musik
- [ ] Game Over und Rückkehr ins Menü – „GAME OVER“, stehendes Level, dann das Menü (07.10.2026, E-036); offen:
      Namenseingabe für die Highscore-Liste

### Spielmechanik

- [ ] Eule: Flug in 8 Richtungen, Flügelschlag-Animation – vor dem Start pixelgenau (07.10.2026, inkl. Ränder)
- [ ] Schuss (Echoortungswelle), dreimal aufrüstbar durch Zaubertränke – Flug als Sprite übertragen (alle 4 Stufen),
      Stufe 0 pixelgenau geprüft; Treffer, Abschüsse und Dauerfeuer gegen den Emulator geprüft (`level1_shoot`,
      07.10.2026); Schussgeräusch als Zustand (Sound_Start)
- [ ] Zwei kreisende Schwerter als Schutz
- [ ] Schriftrollen und Zauber-Auswahlmenü (pausiert das Spiel), 8 Zaubersprüche
- [ ] Leben (3), Verlust von Power-ups, Wiedereinstieg mit kurzer Unverwundbarkeit – Tod, Explosion, Schild
      (3 s) und Verlust von Waffenstufe und unterer Axt übertragen und geprüft (07.10.2026)
- [ ] Punkte, Extraleben – Punkte für Treffer (13) und Abschuss (116) geprüft (`level1_shoot`); Extraleben ab
      80.000 übertragen, noch nicht geprüft
- [ ] Statuszeile (`Ag_Status.s`) – übertragen (Punkte, Zauberdauer, Leben, Texte); „PRESS FIRE TO START“ geprüft;
      Texte auch auf Deutsch (Ä/Ö/Ü per Skript)
- [ ] Kollisionen Eule/Gegner, Schüsse/Gegner, Gegnerschüsse/Eule, Schwerter/Projektile – Eule/Gegner und
      Schuss/Gegner geprüft (`level1_go`, `level1_shoot`)
- [x] Gegnerschüsse (`Ag_Alien_Fire.s`) – übertragen; noch nicht im Einsatz geprüft (in Level 1 schießt bis
      Bild 14792 kein Gegner, auch nicht mit Dauerfeuer)
- [ ] Zufallsgenerator wie im Original

### Level (je: Ebenen, Angriffswellen, Zwischengegner, Endgegner, Musik, Ladebild)

- [ ] Level 1 – Meer (`LMER`) – Startbild bis „PRESS FIRE TO START“ fertig und geprüft (07.10.2026); Scrollen beider
      Playfields mit Palettenwechsel pixelgenau; Angriffswellen auf Bahnen (Fische, `Full_7c`) mit Kollisionen und
      Gegnerschüssen pixelgenau; Tod, Schild, `R_Sol_Crache`, `R_Araignee` und Spielende pixelgenau (07.10.2026);
      übrige Gegner-Routinen samt Endgegner übertragen, gegen das Original noch ungeprüft (`R_Transporteur`,
      `R_Tir_Etoile`, `R_Spectre`, `R_Rapide`, `R_Bomber`, `R_Volant_Grossi`, `R_Jumper`, `R_Volant_Missile`,
      `R_Final`; 08.10.2026, Kern-Tests in `routines.test.ts`); Bonus übertragen, ungeprüft (08.10.2026); offen: Zauber,
      Levelende mit Leben, Prüfung der neuen Teile mit einer Aufnahme über Bild 14792 hinaus
- [ ] Level 2 – Wald (`LFORET`)
- [ ] Level 3 – Sumpf (`LMARAIS`)
- [ ] Level 4 – Berge (`LMONTAGNES`)
- [ ] Level 5 – Hochland (`LPLATEAUX`)
- [ ] Level 6 – Feuer (`LFEUX`)

### Grafiktechnik

- [ ] Drei Parallax-Ebenen (statisch, hinten scrollend mit 25 fps, vorne mit 50 fps)
- [ ] Copper-Farbverläufe pro Rasterzeile, Palettenwechsel im Spiel – Copperlisten laufen im Hardware-Modell
      (E-032); Palettenwechsel im Spiel noch offen
- [ ] Flacker-Trick (zwei Verläufe im 50-Hz-Wechsel) → auf modernen Displays als Mischfarbe – Wechsel läuft,
      Mischfarbe offen (B-001)
- [ ] Sprites: Eule (16 Farben), Spielerschüsse, Regen – Eule und Regen pixelgenau, Schüsse offen
- [x] Wasser-Animation (12 Phasen, alle 4 Frames) – Muster des hinteren Playfields, pixelgenau (07.10.2026)
- [x] EHB-Bilder (64 Farben) für Menü und Ladebilder

### Audio

- [ ] Ingame-Musik von Jeroen Tel (4 Stücke: Sea & Fire, Forest, Marshes & Highlands, Mountains)
- [ ] Lademusiken (6, ProTracker) – Level 1 läuft
- [ ] Titelmusik im Menü (ProTracker „mod.agony intro“) ✔, Spielende-Musik (ProTracker „agony_end of game“)
- [x] Klanglandschaft der Titelsequenz (5 Samples, vom Code gesteuert)
- [x] Paula-Modell (Perioden, Lautstärken, Sample-Ende als Ereignis im Kern) und Mixer (AudioWorklet), E-027
- [x] ProTracker-Abspieler (wörtliche Portierung aus `igt`, mit Gesamtlautstärke; E-030)
- [ ] Soundeffekte (`Ag_Sounds.s`)

### Plattform

- [ ] Läuft im Browser (iPadOS Safari, Android Chrome, Desktop Chrome/Firefox/Edge/Safari)
- [ ] Touch-Steuerung (virtueller Joystick und/oder Ziehsteuerung), Feuer, Zaubermenü-Schaltfläche (erste Fassung:
      Joystick links, Feuer rechts, Zahnrad; Zaubermenü-Schaltfläche und Variantenvergleich fehlen)
- [x] Tastatur und Gamepad (Gamepad noch nicht mit einem echten Gerät getestet)
- [ ] Querformat, Vollbild, Hinweis bei Hochformat (Hinweis „Gerät drehen“ steht; Vollbild fehlt)
- [x] Audio-Freischaltung nach erster Berührung (iOS), Pause bei App-Wechsel (E-028; auf echten Geräten noch zu
      prüfen)
- [x] Build nach `server/` (`index.html` + Assets)
- [ ] Bedienlayouts für iPad (etwa 1,33:1 bis 1,43:1), iPhone im Querformat (etwa 2,16:1) und Desktop
- [x] Zweisprachig Deutsch/Englisch (E-021): Sprachtabellen, Ä/Ö/Ü in der Original-Schrift, Voreinstellung nach
      Gerätesprache, Umschalten zur Laufzeit – siehe [Texte](texte.md)
- [x] Optionsmenü mit Sprachwahl (E-022), gespeichert über die Speicher-Schnittstelle

### Native App (parallel zu Phase 1, sobald ein Mac verfügbar ist)

- [ ] Capacitor-Projekt mit Xcode 26 einrichten, Web-Build in der App starten
- [ ] App für iPadOS: Querformat fest, Vollbild, Statusleiste und Home-Indikator ausgeblendet
- [ ] Native Dienste: dauerhafter Speicher (Preferences), Lebenszyklus, Audio-Sitzung
- [ ] Installation auf eigenen Geräten
- [ ] App für iOS (iPhone), optional

## Phase 2 – Enhanced-Fassung (erst nach Abschluss von Phase 1)

Alle Erweiterungen sind zuschaltbar; der Original-Modus bleibt unverändert (E-019). Fahrplan mit Stufen E0–E5,
Aufwand und Rechte-Hinweisen: [Enhanced-Fassung](enhanced.md). Kurzliste:

- [ ] E1 Komfort und Darstellung: flüssigere Bewegung (60/120 Hz), Darstellungsfilter, Fehler-Schalter, Steuerung,
      Ton, Pause-Menü
- [ ] E2 Story und Präsentation: Anleitung auswerten, Prolog, Welt-Texte auf den Ladebildern, Epilog, Galerie
- [ ] E3 Neues Intro, zusätzliche Bilder, HD-Gemälde
- [ ] E4 Spielinhalte: Schwierigkeitsgrade, Übungsmodus, zusätzliche Animationsphasen, Bestenlisten
- [ ] E5 Weitere Plattformen: native App (parallel zu Phase 1), Game Boy Advance (Idee)
- [ ] Außerdem aus Grundregel 4: Offline-Nutzung (PWA), erweiterte Gamepad-Unterstützung, Haptik in der App
