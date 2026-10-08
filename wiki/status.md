# Status

Stand: 08.10.2026

## Kurzfassung

Phase 1 (originalgetreue Nachbildung) läuft. Grundlagen sind gelegt: Recherche, Original-Quellcode, vollständige
Spieldaten, ein steuerbarer Referenz-Emulator, die Asset-Pipeline für die Startsequenz und dieses Wiki. Das
Web-Grundgerüst steht, und die Startsequenz läuft im Browser: Titelsequenz → Menü mit Abspann, Highscore-Tabelle und
Menümusik → Story-Seite → Ladebild von Level 1 mit Lademusik → Level 1, Bild für Bild wie im Emulator. Das Level
läuft auf einem Modell der Grafik-Hardware mit dem übertragenen Spielcode (E-032): Angriffswellen, die ersten zwei
Gegner mit eigener Routine, Tod der Eule, Schild beim Wiedereinstieg und Spielende mit Rückkehr ins Menü; ohne
Eingabe bis nach dem Spielende pixelgenau wie im Emulator, ebenso ein Lauf mit Dauerfeuer, Abschüssen und Ausweichen.
Als Nächstes: Zeitmodell bei hoher Last, die übrigen Gegner-Routinen von Level 1, Ton im
Level. Eine native App für iPadOS (eventuell auch iOS) ist eingeplant, sobald ein
Mac zur Verfügung steht.

## Fahrplan und Fortschritt

### Phase 1 – Nachbildung des Originals

| Schritt | Stand | Bemerkung |
|---|---|---|
| 1. Wiki anlegen und die Rechercheergebnisse übernehmen | ✅ erledigt | 06.10.2026 |
| 2. Quellcode sichten und in [Quellcode](quellcode.md) kartieren (Routinen, Datenstrukturen, Tabellen) | 🟡 begonnen | Überblick auf Datei-Ebene; Routinen und Datenstrukturen fehlen noch |
| 3. Referenz-Emulator mit den ADFs und Kickstart 1.3 einrichten | ✅ erledigt | vAmigaWeb als A500 (OCS, 512 + 512 KB), schrittweise steuerbar, siehe [Setup](setup.md#referenz-emulator) |
| 4. Asset-Pipeline: Spieldateien entpacken; Grafiken, Paletten, Angriffswellen, Sounds und Musik extrahieren | 🟡 begonnen | Disketten ausgelesen, alle 15 Spieldateien entpackt, Lade- und Startadressen bestimmt; Titelbilder, Menübild, Menüschrift, Texttabelle und Ladebild 1 lokalisiert und mit Python-Prototypen pixelgenau dekodiert; Startliste von Level 1 dekodiert. Pipeline in TypeScript für die Startsequenz fertig (`tools/pipeline/`); Level-Daten fehlen noch |
| 5. Web-Grundgerüst: Spielschleife, Renderer, Eingabe, Audio, Build nach `server/` | ✅ erledigt | 06.10.2026, [Architektur → Umsetzung](architektur.md#umsetzung-web-grundgerüst); ProTracker-Abspieler inzwischen auch; offen: Vollbild, Tests auf echten Geräten |
| 6. Level 1 vollständig spielbar machen und mit dem Original abgleichen, danach Level 2–6 | 🟡 begonnen | Hardware-Modell (E-032); Level 1 ohne Eingabe bis zum Spielende fertig (Wellen, 2 von 11 Gegner-Routinen, Tod, Schild), 07.10.2026 |
| 7. Titel/Intro, Menü, Ladebilder, Highscore und Spielende; Gesamtabgleich und Bugfixing | 🟡 begonnen | Titelsequenz, Menü, Story-Seite, Ladebild Level 1 fertig und geprüft (06.10.2026); offen: Namenseingabe, Cheat, Ladebilder 2–6, Spielende |

### Aktueller Meilenstein: Start bis Level 1

Ziel (mit dem Nutzer vereinbart am 06.10.2026): Titelsequenz → Menü mit Abspann → Story-Seite → Ladebild →
Start von Level 1 im Browser, originalgetreu, ohne Crack-Intro. Ablauf des Originals:
[Ablauf bis Level 1](original/startsequenz.md).

| Teilschritt | Stand | Bemerkung |
|---|---|---|
| Referenz aufnehmen (Emulator) | ✅ | ganzer Ablauf bildgenau aufgenommen, Speicherabzüge, Schnappschüsse an allen Stationen |
| Titelsequenz: Bilder, Ablauf, Effekte, Ton | ✅ | 5 Hires-Interlace-Bilder mit Paletten in `present` gefunden, pixelgenau bestätigt; Ablauf und Feuerband aus dem Code; Ton = Sample-Klanglandschaft (5 Samples) |
| Menü: Bild, Palette, Schrift, Texttabelle, Musik, Ablauf | ✅ | Schrift (42 Zeichen) und Zeichenverfahren nachgebaut und pixelgenau bestätigt; Hauptschleife, Zeiten, Highscore, Cheat aus dem Code |
| Ladebild Level 1 | ✅ | Bild, Palette, Musik, Ablauf; pixelgenau inklusive Original-Eigenheit (`mt_init`) |
| Level 1: Bildaufbau verstehen | ✅ | Adressen aller Daten im Abbild, Format von Kacheln, Mustern, Himmel, Statuszeile und Copperliste ([Dateiformate](dateiformate.md#adressen-im-abbild-sea-)); Ablauf bis „PRESS FIRE TO START“ aus Quelltext und Disassembly |
| Eule (Sprites) extrahieren | ✅ | `Sorcerer_Dat` `$178C0` (16 Phasen); als Speicherblock exportiert |
| Asset-Pipeline (TypeScript) für die Startsequenz | ✅ | `node tools/pipeline/build-assets.ts` erzeugt alle Daten der Startsequenz nach `game/public/data/` (7 Bilder, Schrift inkl. Ä/Ö/Ü/Komma/Bindestrich, 15 Textseiten EN, 5 Samples, 2 Module, Highscores); pixelgenau geprüft, reproduzierbar |
| Web-Grundgerüst | ✅ | Vite 8 + TypeScript 7 + Vitest 5; Kern ohne DOM (Takt in Farbtakten, Bildschirm-Automat, Paula-Modell, Schrift, Sprachen, Optionsmenü, Replays), WebGL2-Renderer, AudioWorklet-Mixer, Tastatur/Gamepad/Touch; 17 Tests, Schrift pixelgenau gegen Speicherabzug; im Browser geprüft (Desktop, Tablet quer, Smartphone quer/hoch), Build nach `server/` |
| Bildschirme der Startsequenz bauen | ✅ | Titelsequenz, Menü (Abspann, Highscore-Tabelle, Musik), Story-Seite, Ladebild mit Lademusik; ProTracker-Abspieler; Bild für Bild gegen Ablaufspuren des Emulators geprüft, Feuerband, Highscore-Tabelle und Story-Seite pixelgenau; 22 Tests. Story-Seite und Ladebild: 3 s Mindestdauer, dann Feuer (E-025). Danach vorläufiger Platzhalter für Level 1 |
| Level 1: Schießen und Ausweichen | ✅ | Aufnahme `level1_shoot` mit Dauerfeuer: Treffer, Abschüsse, Punkte, Explosionen, ein Tod; bis Bild 14568 pixelgenau (gemessene Zeitlage; tolerierte Fälle W-015, W-017), Zeitmodell mit gleichem Spielzustand (W-018). Schussgeräusch als Zustand, Interrupt-Dauer über zwei Läufe angepasst; 42 Tests. Danach: Durchläufe über zwei Bilder hinaus |
| Level 1: Tod, Schild, Gegner mit eigener Routine, Spielende | ✅ | Tod der Eule (8 Teile als Sprites), Wiedereinstieg mit Schild (Zauber 6, 3 s), Zauberdauer, Routinenverwaltung mit `R_Sol_Crache` und `R_Araignee`, Aufräumen und Spielende („GAME OVER“, danach das Menü, E-036). Teil 1b und Teil 2 laufen an ihrer Rasterzeile, das Bild entsteht zeilenweise (E-037); Zeitmodell mit Dauer des Copper-Interrupts und Uhr für Teil 1b. Sprite-DMA genauer (Endzeile auch unsichtbarer Sprites, O-014). Lauf ohne Eingabe bis nach dem Spielende (1.690 Bilder): mit gemessener Zeitlage pixelgenau bis auf W-015 (10 Bilder, 2–6 Pixel), mit dem Modell zusätzlich 2 Durchläufe mit 1 Pixel Versatz; 37 Tests, im Browser geprüft |
| Level 1: Angriffswellen | ✅ | Startliste, Bahnen (absolut/relativ), Gegner als Blitter-Objekte mit Clipping und Explosion, Kollisionen, Gegnerschüsse, Paletten der Wellen, Vorberechnung der Masken; Zeitmodell mit Bus-Belegung und Musiktreiber-Tabelle (E-034, E-035). Bis zum ersten Tod der Eule (Bild 13586, 474 Bilder) pixelgenau, mit gemessener wie mit berechneter Strahlposition; 37 Tests. Danach Platzhalter |
| Level 1: Scrollen nach dem Start | ✅ | Vorderes Playfield (Kacheln, Masken, Seitenwechsel, Restaurierungsbild), Palettenwechsel, Level_X und Startliste (bis zum ersten Eintrag), Schuss der Eule; Zeitmodell für `Short_Phase` aus einem Zeitprofil des Emulators (E-034). Bis zur ersten Angriffswelle (144 Bilder) pixelgenau, Variablen und `Short_Phase` je Bild wie im Original; 36 Tests. Danach Platzhalter |
| Level 1: Spielfeld bis „PRESS FIRE TO START“ | ✅ | Hardware-Modell (Speicher, Blitter, Copper/Bildaufbau) und Port von Init, Hauptschleife, hinterem Playfield, Statuszeile, Eule, Äxten und Regen; ab dem dritten Bild pixelgenau gegen den Emulator (520 Bilder ohne/mit Joystick, Eule am Rand), Startzeitpunkt bei Feuer bildgenau; 30 Tests |

### Native App für iPadOS (eventuell iOS)

| Schritt | Stand | Bemerkung |
|---|---|---|
| Code von Anfang an plattformneutral anlegen | ✅ als Regel festgelegt | siehe [Architektur](architektur.md) und E-014 |
| Mac mit Xcode 26 einrichten, Capacitor-Projekt anlegen, Web-Grundgerüst in der App testen | ⬜ geplant | sobald der Mac da ist (laut Nutzer in ein bis zwei Monaten); läuft parallel zu Phase 1 |
| Bedienlayouts für iPad und iPhone, native Dienste (Speicher, Lebenszyklus, Audio-Sitzung) | ⬜ geplant | |

### Phase 2 – moderne Features

Erst nach Abschluss von Phase 1, als zuschaltbare Enhanced-Fassung; Fahrplan in [Enhanced-Fassung](enhanced.md).
Ausnahme ist Stufe E0 (Sprachen, Optionsmenü), die schon parallel zu Phase 1 entsteht.

## Nächste Schritte

Für den aktuellen Meilenstein:

Jeder Schritt folgt dem passenden [Standardablauf](arbeitsablauf.md); Effort im Regelfall „mittel“ (E-038).

1. Start bis Level 1 auf echten Geräten prüfen (iPad/Android-Tablet im Heimnetz): Ton-Freischaltung, Touch (Feuer
   rechts), Safe Areas, Bildrate, Klang der Musik, Flacker-Trick bei 60/120 Hz (B-001).
2. **Zeitmodell bei hoher Last** (E-037, Ablauf D, Effort „hoch“): Im Lauf `level1_shoot` sagt das Modell den
   überlangen Durchlauf ab Bild 14567 eine Runde zu früh voraus; Teil 1b (vor allem Schritt 2, Paletten) liegt bei
   hoher Last rund 10 Zeilen daneben. Teil 1b unter Last neu kalibrieren (`collect-timing.ts level1_shoot`,
   `fit_part1b_timing.py --run level1_shoot`), dann `SHOOT_MODEL_LAST` in `level1.test.ts` auf `SHOOT_LAST` (14792)
   anheben. Danach die übrigen Gegner-Routinen (`R_Transporteur` startet in Bild 14793, `R_Tir_Etoile`, `R_Spectre`,
   `R_Rapide`, `R_Bomber`, `R_Jumper`, `R_Volant_Missile`, `R_Final`), Bonus, Zaubermenü, Levelende mit Leben;
   Gegnerschüsse im Einsatz, sobald ein Gegner schießt (dafür eine neue Aufnahme über Bild 14792 hinaus).
3. Ton im Level: Soundeffekte (`Sound.bin`) und die Musik von Jeroen Tel (offene Frage: Treiber portieren oder vorab
   aufnehmen).

Kleinere Restpunkte: Klang (Mixer-Ausgabe) mit einer Audio-Aufnahme des Emulators abgleichen – der Mixer tastet
derzeit ohne Bandbegrenzung ab (Aliasing, klingt härter und „metallischer“ als ein Amiga), trennt die Kanäle hart
links/rechts und hat kein Ausgangsfilter des A500; Abhilfe: bandbegrenzte Abtastung (BLEP wie in UAE/vAmiga),
Ausgangsfilter des A500, später zuschaltbar Stereo-Mischung (Enhanced); Tiefpassfilter des A500
(E0x/LED) und Perioden unter 124 im Mixer; Namenseingabe und Cheat „FANTASY“ im Menü (mit dem Spielende).

Danach: Quellcode weiter kartieren (Objektstruktur, Zufallsgenerator) für das eigentliche Spiel.

## Offene Fragen

- **Hosting:** Wo und wie wird das fertige Web-Spiel bereitgestellt? Falls die Rechte an den Original-Assets nicht
  zu klären sind: Spiel ohne Daten ausliefern; beim ersten Start wählt der Spieler die drei ADFs (die Franck Sauer
  kostenlos anbietet), und die Pipeline extrahiert im Browser bzw. in der App (ADF-Leser und Entpacker sind TypeScript).
- **Touch-Steuerung:** virtueller Joystick, relative Ziehsteuerung oder „Tippen setzt Ziel“ (wie im Flash-Prototyp)?
  Mehrere Varianten als Prototyp vergleichen.
- **Ingame-Musik:** Jeroen Tels Treiber nach TypeScript portieren oder die Stücke vorab in Audiodateien rendern? Auch
  rechtlich relevant, weil Treiber und Musik einen eigenen Copyright-Vermerk tragen.
- **Native App:** Capacitor-Hülle (Empfehlung) oder vollständiger Swift-Nachbau? Nur iPad oder auch iPhone?
  Installation nur auf eigenen Geräten oder Verteilung über TestFlight/App Store? Eine Veröffentlichung setzt
  geklärte Rechte an den Original-Assets voraus.
- **Enhanced-Fassung:** Grundsatz entschieden (E-019, E-040: Original exakt; Enhanced als eigener, neuer Kern mit dem
  Nachbau als Prüfstein). Offen: Reihenfolge der Punkte im [Fahrplan](enhanced.md) und die Sprache des neuen Kerns
  (TypeScript für Web/iPad, C++/Rust falls Switch oder andere Konsolen gewünscht).
- **Cloud-Sessions (Guthaben aus der Aktion, verfällt 04.11.2026):** Arbeitskopie als privates GitHub-Repo? Geprüft
  08.10.2026, noch nicht entschieden: Code, Wiki und Werkzeuge rund 20 MB, Grolets Quellcode 43 MB (ohne Tels Teile),
  Spieldaten `game/public/data` 1,4 MB. Die Aufnahmen für die Tests sind roh 1,7 GB (Einzeldateien bis 70 MB), gzip
  verkleinert sie etwa 30-fach (43 MB → 1,4 MB); dafür müssten die Test-Lader `.gz` lesen. Emulator, ROMs und ADFs
  blieben lokal (Aufnahmen nur am PC). `git` ist vorhanden, `gh` nicht.
- **Game Boy Advance, Switch:** als weitere Plattformen nach Phase 1? (Ideen in [Enhanced-Fassung](enhanced.md#e5--weitere-plattformen); Switch nur mit Rechten und Nintendo-Lizenz)
- **Deutsche Anleitung:** Die englische ist ausgewertet (Lemon Amiga, vom Nutzer bereitgestellt). Eine deutsche
  Fassung wurde online nicht gefunden – liegt dem Nutzer evtl. die Originalverpackung vor?
- **Deutsche Texte:** Entwürfe in [Texte](texte.md) gegenlesen. (Entschieden: Komma und Bindestrich werden ergänzt,
  E-023; „and“/„Present“ bleiben englisch, E-024; Story-Seite und Ladebild mit Mindestdauer, dann Feuer, E-025.)
- **`node_modules` auf dem NAS:** Wie gehen PC und Mac mit den plattformabhängigen Paketen um? Mit dem Mac testen
  und entscheiden (E-018). Geklärt ist dagegen der Ort: Der Projektordner liegt auf einem NAS, auf das beide
  Rechner gleichzeitig zugreifen (E-017).

## Verbrauch je Schritt

Plan Pro. Werte in Prozent des jeweiligen Limits, gemessen zu Beginn und am Ende eines Schritts
([Arbeitsablauf](arbeitsablauf.md), A.4 und F.4). Seit 08.10.2026 erfasst.

| Datum | Schritt | Effort | Woche vorher → nachher | 5 h vorher → nachher | Bemerkung |
|---|---|---|---|---|---|
| 08.10.2026 | Stand vor dem nächsten Schritt | – | 96 % (Reset 11.10. ~03:00) | 3 % | Ausgangswert; Abschluss von Schritt 2 und Fragen ≈ 3 % des 5-h-Fensters |

## Verlauf

- **08.10.2026 (Hauptschleife über zwei Bilder hinaus)** – Die Engine führt Durchläufe der Hauptschleife über
  beliebig viele Bilder aus (`runMainLoop` mit den Stufen Teil 1b, Teil 2, Warten; Lage `at` = 2 · Bilder seit
  Schleifenstart + Seite des Copper-Interrupts; Teil 1a an beliebiger Zeile). Das Zeitmodell rechnet die Warteregeln
  von Teil 2 nach dem Original und Unterbrechungen über 5 Bilder; Sicherung `backup/2026-10-08_hauptschleife/`. Lauf
  `level1_shoot` mit gemessener Zeitlage jetzt bis Bild 14792 (Ende der Aufnahme) pixelgenau bis auf W-017, W-019 (neu)
  und zwei Bilder mit 1 Pixel. Teil 2 liegt im Modell fast immer auf der richtigen Seite des Interrupts (0 bzw. 3
  Grenzfälle). Das Zeitmodell selbst folgt im Lauf mit Schießen vorerst nur bis 14566 (eigener Schritt). 42 Tests.
- **07.10.2026 (Level 1: Schießen und Ausweichen)** – Neue Aufnahme `level1_shoot` nach Ablauf C: Eingaben vom
  Planungs-Bot (`plan-bot.ts`: Dauerfeuer, Bewegung, Ausweichen vor Toden, im Nachbau geplant), Bilder, Spur und
  Zeitprofil bis Bild 14901. Mit gemessener Zeitlage bis Bild 14568 pixelgenau bis auf tolerierte Fälle (W-015, W-017).
  Ergänzt: Schussgeräusch beim Start eines Schusses (Sound_Start, nur Zustand) und dessen Laufzeit im Zeitmodell;
  Interrupt-Dauer über beide Läufe neu angepasst (`fit_irq_timing.py`) – damit stimmt auch das Zeitmodell im
  Spielzustand, 9 Durchläufe mit 1 Pixel Versatz (W-018). Gefunden: ab Bild 14566 läuft die Hauptschleife länger als
  zwei Bilder; in Level 1 schießt bis Bild 14792 kein Gegner. Eingaben der Läufe zentral in `game/test/runs.ts`,
  Sammel-Skripte mit Laufnamen. 42 Tests.
- **07.10.2026 (Bedienhinweis „Feuer drücken“)** – Story-Seite, Ladebild und Spielende zeigen nach Ablauf der
  Ersatz-Wartezeit blinkend „PRESS FIRE“ / „FEUER DRÜCKEN“ in der auf 50 % verkleinerten Menüschrift (E-039); nur ein
  neuer Feuerdruck oder Antippen zählt, beim Spielende kürzt er die Wartezeit ab. Quellcode geprüft: keine der Stellen
  wartet im Original auf Feuer. Tests: `game.test.ts` (Story-Seite), `level1.test.ts` (Spielende); im Browser geprüft.
- **07.10.2026 (Arbeitsweise)** – Neue Seite [Arbeitsablauf](arbeitsablauf.md): kleine Sitzungen, Effort-Leitfaden,
  Genauigkeitsregel, Standardabläufe A–F (E-038); Bedienhinweis „Feuer drücken“ beschlossen (E-039); E-036 bestätigt.
- **07.10.2026 (Level 1: Tod, Schild, Routinen-Gegner, Spielende)** – Übertragen: MAIN CHAR DIE (Explosion in
  8 Sprite-Teilen, Leben als Bitreihe), Zauber 6 (Schild nach dem Wiedereinstieg), SPELL TIME, Routinenverwaltung mit
  `R_Sol_Crache` und `R_Araignee`, CLEAN UP, Quit_Delay und EXIT LEVEL; danach das Menü (E-036). Neue Aufnahme des
  Laufs ohne Eingabe bis nach dem Spielende (Bilder bis 14801, Spur bis 14902, Zeitprofil mit 20 Haltepunkten). Dabei
  gefunden: Teil 1b läuft im Original meist erst nach dem Copper-Interrupt oder im übernächsten Bild; die Engine baut
  das Bild deshalb zeilenweise und führt jeden Schritt an seiner Rasterzeile aus (E-037). Zeitmodell um die Dauer des
  Copper-Interrupts (Schleifenbeginn) und eine Uhr für Teil 1b erweitert, Prozessor nur auf geraden Buszyklen.
  Sprite-DMA nachgeschärft (O-014), Zeitprofile bereinigt (W-016). Neue Eigenheiten O-013, O-014; bekannte Abweichung
  W-015. 37 Tests, im Browser bis ins Menü geprüft.

- **07.10.2026 (Level 1: Angriffswellen)** – Gegner übertragen: Vorberechnung der Masken (byte-gleich mit dem
  Speicherabzug), Startliste mit Wellen, Bahnverfolgung, Zeichnen als Blitter-Objekte mit allen Clipping-Routinen,
  Kollisionstest, Gegnerschüsse, Soundeffekt-Zustand. Zeitmodell auf Bus-Belegung je Zeile und gemessene Laufzeit
  des Musiktreibers umgestellt (E-035, Tabelle per `music_timing.py`): 235 von 236 Entscheidungen wie im Original.
  Neue Eigenheiten O-010 bis O-012. Alle Bilder bis zum ersten Tod der Eule (13586) pixelgenau; neue Aufnahmen
  13402–13601, Zeitprofile mit Objekten und Musiktreiber, `AG.profileStart/Run/Save`. 37 Tests, im Browser geprüft.

- **07.10.2026 (Level 1: Scrollen nach dem Start)** – Vorderes Scrollen (`front-scroll.ts`), Seitenwechsel,
  Palettensteuerung und Startliste bis zum ersten Eintrag (`playability.ts`) und der Schuss der Eule übertragen.
  Zeitprofil per Haltepunkten im Emulator (`AG.profile`, W-014) zeigte den Ablauf der Hauptschleife; daraus das
  Zeitmodell für `Short_Phase` (`timing.ts`, E-034). Vergleich mit neuer Aufnahme `level1_go`: alle Bilder bis zur
  ersten Welle (Bild 13256) pixelgenau, Variablen und `Short_Phase` je Bild wie im Original. Die Engine hält an der
  ersten nicht übertragenen Stelle an (`unported`); der Bildschirm wechselt dann zum Platzhalter. Korrigiert:
  `Clean_Up` liegt bei `a5 + $7CE0` (nicht `$7CCC`). 36 Tests, im Browser geprüft.

- **07.10.2026 (Statuszeile auf Deutsch)** – Statusschrift um Ä, Ö, Ü ergänzt (Pipeline, Tabelle `status.extra`,
  Buchstabe um 3 Zeilen gestaucht, Punkte darüber), deutsche Statustexte (`DE_STATUS`) eingebaut, Engine zeichnet
  Texte nach Sprache und zeichnet beim Umschalten im Level sofort neu. Englisch unverändert pixelgenau. 34 Tests.
  Wiki: Komma und Punkt hat die Statusschrift doch (Codes 39/40), Ziffer 0 = Buchstabe O.

- **07.10.2026 (Level 1 bis „PRESS FIRE TO START“)** – Level-Abbild `sea` kartiert (Adressen aller Daten bis zum
  Spielbeginn, Formate von Kacheln, Mustern, Himmel, Statuszeile, Eule, Regen, Copperliste); Pipeline exportiert
  Speicherblöcke (`manifest.memory`, Format 2). Hardware-Modell gebaut (E-032): Chip-RAM, Blitter, Copper und
  Bildaufbau mit Dual-Playfield und Sprites – aus einem Speicherabzug auf Anhieb pixelgenau. Init, Hauptschleife,
  hinteres Playfield, Statuszeile und Copper-Interrupt (Eule, Äxte, Regen) aus Quelltext und Disassembly übertragen.
  Zeitmodell der Hauptschleife nach Ablaufspur (E-034). Ab dem dritten Bild stimmen alle 520 aufgenommenen Bilder
  pixelgenau (ohne Eingabe, mit Joystick, Eule am Rand), dazu Variablen je Bild und der Startzeitpunkt bei Feuer.
  Die zwei Datenmüll-Bilder am Levelstart werden nicht nachgebildet (E-033, O-008). Behoben: Sprite-Ende über Zeile 255
  hinaus. Emulator-Hilfe `AG.recordHires`, Schnappschuss `snap_f13100_level1_enter`. Rechenzeit ≈ 1,3 ms je Bild.
  Im Browser geprüft (Desktop, Tablet und Smartphone quer, echter Ablauf Menü → Ladebild → Level), Build geprüft.

- **06.10.2026 (Bildschirme der Startsequenz)** – Titelsequenz, Menü, Story-Seite und Ladebild von Level 1 als
  Nachbildung der Programme `present`, `igt` und `load_sea` gebaut (Hauptprogramm als Script, Bild-Interrupt,
  Copperliste); ProTracker-Abspieler wörtlich portiert (PT 2.x mit Gesamtlautstärke von Art & Magic); Paula-Zugriffe mit
  Zeitpunkt und CPU-Schreibzugriffe auf Sampledaten (E-030). Emulator um Ablaufspuren erweitert (`AG.traceRun`); damit
  Titelsequenz, ein ganzer Menüzyklus, Feuer, Story-Seite, Ausblenden und das Ladebild Bild für Bild verglichen
  (Farben, Bildzeiger, Musikzustand, Audio-DMA) – alles gleich. Zeichenzeiten der Menüseiten gemessen und übernommen
  (E-031). Feuerband pixelgenau gegen die Interlace-Aufnahme, Highscore-Tabelle und Story-Seite gegen Speicherabzüge.
  Mindestdauer für Story-Seite und Ladebild: 150 Bilder (E-025). Testbild entfernt; nach dem Ladebild vorläufig ein
  Platzhalter („LEVEL 1 KOMMT BALD“, Feuer → Menü). Im Browser durchgespielt (Englisch/Deutsch), Build geprüft.
- **06.10.2026 (Web-Grundgerüst)** – `game/` als Vite-Projekt angelegt (TypeScript 7, Vite 8, Vitest 5), Pipeline und
  Emulator-Skripte jetzt typgeprüft. Kern ohne DOM: indiziertes Bild mit Palette pro Zeile (E-026), Paula-Modell mit
  DMA-Zeitverhalten (E-027), Takt in PAL-Farbtakten (E-029), Bildschirm-Zustandsautomat, Menüschrift mit dem
  Zeichenverfahren des Originals (pixelgenau gegen Chip-RAM-Abzug des Menüs), Sprachtabellen DE/EN mit Umschalten zur
  Laufzeit, Optionsmenü, Hinweis „Gerät drehen“, Startbildschirm zum Freischalten des Tons (E-028), Replays.
  Plattform: WebGL2-Renderer (Palette pro Zeile, EHB, Overlay, ganzzahlige bzw. scharfe Skalierung, Safe Areas),
  Paula-Mixer im AudioWorklet mit Notbehelf, Tastatur/Gamepad/Touch, localStorage, Lebenszyklus. Build nach `server/`
  geprüft. Vite-Polling für das NAS (W-011).
- **06.10.2026 (Asset-Pipeline)** – Entscheidungen E-023 (Komma und Bindestrich ergänzen), E-024 („and“/„Present“
  bleiben englisch), E-025 (Story-Seite und Ladebild: Mindestdauer, dann Feuer). Asset-Pipeline in TypeScript
  fertig für die Startsequenz: Disketten lesen, entpacken, Bilder, Schrift (mit ergänzten Zeichen), Texte,
  Samples, Module und Highscores nach `game/public/data/`; Datenformat `game/src/data/manifest.ts`. Alle Bilder
  pixelgenau geprüft, Ausgabe reproduzierbar. In `CLAUDE.md` die Arbeitsweise „nach jedem Schritt anhalten und
  Effort-Einstellung empfehlen“ ergänzt.
- **06.10.2026 (Startsequenz entschlüsselt)** – Emulator um Schnappschüsse (`AG.snapshot`/`AG.restore`) und
  Interlace-Aufnahmen (`AG.recordInterlace`) erweitert; Server liefert `work/captures/` auch aus. 68000-Disassembler
  eingerichtet (Capstone, `tools/analysis/disasm68k.py`); `present`, `igt` und `load_sea` disassembliert.
  Ergebnisse: Alle Dateien laufen bei `$600`, die Ladebilder bei `$61500` (die frühere Angabe `$014526` für `igt` war
  falsch). Titelsequenz: 5 Hires-Interlace-Bilder mit Paletten, Ablauf mit exakten Zeiten, Feuerband-Effekt per
  Copper, Ton als Sample-Klanglandschaft. Menü: Schrift (42 Zeichen, proportional, Rand per Blitter), Texttabelle mit
  15 Seiten, Hauptschleife mit Zeiten, Highscore, Cheat „FANTASY“. Ladebild 1: Bild, Palette, Ablauf; es wartet nicht
  auf Feuer (Korrektur). Alle Bilder pixelgenau gegen den Emulator geprüft (100 %), nachdem die Farbrundung des
  Emulators geklärt war (W-005). Fünf Eigenheiten des Originals belegt (O-001 bis O-005). Analyse-Skripte geben
  UTF-8 aus; `compare_capture.py` überarbeitet.
- **06.10.2026 (Planung)** – E-019 vom Nutzer bestätigt: Original exakt, Verbesserungen später zuschaltbar.
  Fahrplan für die Enhanced-Fassung angelegt ([Enhanced-Fassung](enhanced.md)). Zweisprachigkeit DE/EN ab dem
  ersten Code beschlossen (E-021), Optionsmenü vorgeschlagen (E-022), Textbestand mit deutschen Entwürfen in
  [Texte](texte.md). Story-Texte des Spielendes in `ending` gefunden; Schreibweise im Spiel: „Acanthopsis“.
  Anleitung: Der Nutzer hat die englische Abschrift von Lemon Amiga bereitgestellt; ausgewertet in
  [Überblick](original/ueberblick.md#anleitung-) (Vorgeschichte, Mitwirkende) und
  [Spielmechanik](original/spielmechanik.md#die-acht-zauber--anleitung) (Steuerung, acht Zauber). Deutsche Fassung
  noch nicht gefunden. Optionsmenü für die Sprachwahl vom Nutzer bestätigt (E-022). Ordner `reference/manual/` angelegt;
  der Nutzer hat dort die Anleitung als gespeicherte Lemon-Amiga-Seite abgelegt (siehe
  [Referenzmaterial](referenzmaterial.md#manual)).
- **06.10.2026 (Meilenstein „Start bis Level 1“)** – Emulator auf A500 (OCS) umgestellt. Schrittweise Steuerung
  (`AG.step`) und schnelle Rohaufnahme eingeführt. Kompletten Ablauf vom Einschalten bis zum Start von Level 1
  bildgenau aufgenommen ([Ablauf bis Level 1](original/startsequenz.md)). Menü vollständig entschlüsselt: Ladeadresse
  `$014526`, Bild 352 × 290 EHB samt Palette direkt aus `igt` gewonnen und pixelgenau bestätigt, Texttabelle aller
  Abspann- und Hinweisseiten dekodiert, Menü- und Lademusik als ProTracker-Module lokalisiert. Copperliste von
  Level 1 dekodiert. Neue Analyse-Skripte in `tools/analysis/`, Hilfsfunktionen in `tools/emulator/browser/`.
- **06.10.2026** – Wiki angelegt und Rechercheergebnisse übernommen. Befehle zum Auslesen und Entpacken der
  Disketten nach `work/` geprüft; `pp20.py` überspringt jetzt Unterordner. `igt` per Emulator als Menü
  identifiziert, `Agony.00` als Highscore-Tabelle entschlüsselt. Startliste der Angriffswellen von Level 1 im
  entpackten Abbild gefunden und vollständig dekodiert (121 Einträge); daraus folgt, dass die Level-Abbilder für
  Adresse `$600` assembliert sind (siehe [Dateiformate](dateiformate.md)). Analyse-Skripte nach `tools/analysis/`
  übernommen und plattformunabhängig gemacht.
  Danach: `CLAUDE.md` auf Regeln, Struktur und Verweise gekürzt (Sicherung `backup/2026-10-06_CLAUDE.md`), Inhalte
  in neue Seiten [Architektur](architektur.md) und [Referenzmaterial](referenzmaterial.md) übertragen. Native App
  für iPadOS/iOS als Ziel aufgenommen; Code wird von Anfang an plattformneutral angelegt. Projektordner liegt auf
  einem NAS für PC und Mac: Regeln in [Setup](setup.md#zwei-rechner-ein-nas), `.editorconfig` angelegt (UTF-8,
  LF), E-017/E-018.
- **05.10.2026** – Projektstart: `CLAUDE.md` erstellt, Web-Recherche. Original-Quellcode von Aminet geladen
  (`reference/source/`). Disketten analysiert: Crack-Fassung „Crystal“, 15 PowerPacker-Dateien, Zuordnung zur
  Original-Ladetabelle, Vollständigkeit geprüft. Referenz-Emulator vAmigaWeb eingerichtet (`tools/emulator/`) und
  getestet: Booten, Joystick, Maus, Diskwechsel, Speicher lesen, Bilder speichern.
