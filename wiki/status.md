# Status

Stand: 09.10.2026

## Kurzfassung

Phase 1 (originalgetreue Nachbildung) läuft. Grundlagen sind gelegt: Recherche, Original-Quellcode, vollständige
Spieldaten, ein steuerbarer Referenz-Emulator, die Asset-Pipeline für die Startsequenz und dieses Wiki. Das
Web-Grundgerüst steht, und die Startsequenz läuft im Browser: Titelsequenz → Menü mit Abspann, Highscore-Tabelle und
Menümusik → Story-Seite → Ladebild von Level 1 mit Lademusik → Level 1, Bild für Bild wie im Emulator. Das Level
läuft auf einem Modell der Grafik-Hardware mit dem übertragenen Spielcode (E-032): Angriffswellen, die ersten zwei
Gegner mit eigener Routine, Tod der Eule, Schild beim Wiedereinstieg und Spielende mit Rückkehr ins Menü; ohne
Eingabe bis nach dem Spielende pixelgenau wie im Emulator, ebenso ein Lauf mit Dauerfeuer, Abschüssen und Ausweichen.
Alle Gegner-Routinen, Bonus, Zaubermenü mit allen Zaubern, Äxte, Pause und Levelende von Level 1 sind übertragen
(gegen das Original noch ungeprüft); nach dem Levelende folgen das Ladebild und Level 2 (Abbild und Layout stehen,
alle Gegner-Routinen samt Endgegner sind übertragen, das Level läuft bis zum Levelende), danach Ladebild und Level 3
(Abbild und Layout stehen, alle Gegner-Routinen samt Endgegner sind übertragen, das Level läuft bis zum Levelende),
danach Ladebild und Level 4 (Abbild und Layout stehen, die Wellen laufen bis zur ersten Gegner-Routine).
Als Nächstes: die Gegner-Routinen von Level 4; am PC Aufnahmen von Level 1 über Bild 14.792 hinaus und
von Level 2 zur Prüfung des Übertragenen, Zeitmodell bei hoher Last, Ton im Level. Eine native App für iPadOS (eventuell auch iOS) ist
eingeplant, sobald ein Mac zur Verfügung steht.

## Fahrplan und Fortschritt

### Phase 1 – Nachbildung des Originals

| Schritt | Stand | Bemerkung |
|---|---|---|
| 1. Wiki anlegen und die Rechercheergebnisse übernehmen | ✅ erledigt | 06.10.2026 |
| 2. Quellcode sichten und in [Quellcode](quellcode.md) kartieren (Routinen, Datenstrukturen, Tabellen) | 🟡 begonnen | Überblick auf Datei-Ebene; Routinen und Datenstrukturen fehlen noch |
| 3. Referenz-Emulator mit den ADFs und Kickstart 1.3 einrichten | ✅ erledigt | vAmigaWeb als A500 (OCS, 512 + 512 KB), schrittweise steuerbar, siehe [Setup](setup.md#referenz-emulator) |
| 4. Asset-Pipeline: Spieldateien entpacken; Grafiken, Paletten, Angriffswellen, Sounds und Musik extrahieren | 🟡 begonnen | Disketten ausgelesen, alle 15 Spieldateien entpackt, Lade- und Startadressen bestimmt; Titelbilder, Menübild, Menüschrift, Texttabelle und Ladebilder 1–2 lokalisiert und mit Python-Prototypen pixelgenau dekodiert; Startliste von Level 1 dekodiert. Pipeline in TypeScript für die Startsequenz fertig (`tools/pipeline/`); Level-Daten fehlen noch |
| 5. Web-Grundgerüst: Spielschleife, Renderer, Eingabe, Audio, Build nach `server/` | ✅ erledigt | 06.10.2026, [Architektur → Umsetzung](architektur.md#umsetzung-web-grundgerüst); ProTracker-Abspieler inzwischen auch; offen: Vollbild, Tests auf echten Geräten |
| 6. Level 1 vollständig spielbar machen und mit dem Original abgleichen, danach Level 2–6 | 🟡 begonnen | Hardware-Modell (E-032); Level 1 ohne Eingabe bis zum Spielende fertig (Wellen, 2 von 11 Gegner-Routinen, Tod, Schild), 07.10.2026; übrige Gegner-Routinen, Bonus und Levelende übertragen, ungeprüft (08.10.2026); Level 2 bis zum Levelende übertragen, ungeprüft (09.10.2026); Level 3 bis zum Levelende, ungeprüft (09.10.2026); Level 4: Abbild, Layout, Startliste, ungeprüft (09.10.2026) |
| 7. Titel/Intro, Menü, Ladebilder, Highscore und Spielende; Gesamtabgleich und Bugfixing | 🟡 begonnen | Titelsequenz, Menü, Story-Seite, Ladebild Level 1 fertig und geprüft (06.10.2026); Ladebilder Level 2–4 übertragen, ungeprüft (08./09.10.2026); offen: Namenseingabe, Cheat, Ladebilder 5–6, Spielende |

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

1. **Level 4 – bekannte Gegner-Routinen** (nächster Cloud-Schritt, Ablauf B, Effort „mittel“; Muster: Schritt „Level 3:
   bekannte Gegner-Routinen“ im Verlauf): `R_Bomber` `$4C412` (hier hält der Lauf, 211 Bilder nach dem Start),
   `R_Volant_Missile` `$4BD54`, `R_Sol_Kamikaze` `$4C196`, `R_Araignee` `$4C368` per `diff` gegen
   `AG_GAME_LMARAIS.S`/`Ag_Game_LMER.s` und Abbild (`work/disasm/mountains_rout.txt`) vergleichen, als Einträge in
   `MOUNTAINS.routines`. Danach die neuen Routinen `R_Colonne_Flamme` `$4C276`, `R_Sol_Guide` `$4C55C`, `R_Dragon`
   `$4C710` (Effort „hoch“) und der Endgegner `R_Final` `$4C888` (Effort „hoch“). Level 4 endet mit
   `ui.level5Stub` (`flow.ts`, `level4`).
2. Danach weitere Teile nur aus Quellcode und vorhandenen Daten (Arbeitsweise „Cloud-Aufträge“ in
   [arbeitsablauf.md](arbeitsablauf.md)): nächste Level, Präsentation, Highscore, Spielende.

### Für den PC

Braucht Emulator, Aufnahmen, Messungen oder Geräte (je mit Empfehlung):

- **Ladebilder Level 2–4 prüfen** (Ablauf C, Effort „mittel“, kann mit der Aufnahme über Bild 14.792 hinaus
  zusammen laufen): nach `levelDone` die ersten ≈ 100 Bilder von `load_forest`, `load_marshes` bzw. `load_mountains`
  aufnehmen (Bild, Palette beim Einblenden, Lademusik) und mit `LoadingScreen(LOAD_FOREST)`, `LOAD_MARSHES` bzw.
  `LOAD_MOUNTAINS` vergleichen wie bei `load_sea`.
- **Level 3 aufnehmen** (Ablauf C, Effort „hoch“; wie Level 2, kann im selben Durchgang laufen): Level 3 ist ganz
  ohne Aufnahme übertragen. Erste Prüfpunkte: Wellen ab dem Start, `R_Jumper`, `R_Sol_Kamikaze` (im Nachbau 1.363
  Bilder nach dem Start), `R_Final` (9.045; erste Zunge 100 Bilder später, Explosion und Levelende wie in
  `level3.test.ts`). Dazu O-016 prüfen: Wort an Adresse `$2` beim Erreichen des Endgegners und nach einem Spielende
  im Endgegner-Kampf (bleibt der Wert im nächsten Spiel erhalten? Dann im Nachbau zwischen Spielen übernehmen).
- **Level 2 aufnehmen** (Ablauf C, Effort „hoch“; `R_Final` ist seit 09.10.2026 übertragen): Level 2 ist ganz ohne
  Aufnahme übertragen. Im Emulator Level 2 direkt starten (Schnappschuss nach dem Ladebild, oder Level 1 mit Cheat bzw. per
  Poke überspringen), mit Dauerfeuer und Bewegungsmuster wie `explore-level.ts --forest`, Leben aufgefüllt; Bilder
  und Spur in Abschnitten von ≈ 2.000 Bildern. Erste Prüfpunkte: Wellen ab dem Start, `R_Kamikaze` (im Nachbau
  ≈ 450 Bilder nach dem Start), `R_Sol_Etoile` (≈ 600; Farben des Monsters am Boden ohne eigene Palette), `R_Final`
  (im Nachbau 9.068 Bilder nach dem Start; erste Bumerangwelle 18 Durchläufe später, Reihenfolge der Wellen,
  Explosion und Levelende: `Quit_Delay` 100 ab Bild 12.113, Exit 12.317, wie in `level2.test.ts`).

- **Geräte-Test** (Effort „mittel“): Start bis Level 1 auf iPad/Android-Tablet im Heimnetz: Ton-Freischaltung, Touch
  (Feuer rechts), Safe Areas, Bildrate, Klang der Musik, Flacker-Trick bei 60/120 Hz (B-001).
- **Aufnahme über Bild 14.792 hinaus** (Ablauf C, Effort „hoch“; prüft W-022 und W-023): Gegner-Routinen und Bonus
  sind übertragen, aber ungeprüft. Vom Schnappschuss `snap_f13100_level1_enter` mit den Eingaben von `SHOOT_RUN` bis
  14.790, danach Dauerfeuer mit dem Bewegungsmuster des Planungs-Bots (wie `explore-level.ts`), Leben jedes Bild per
  Poke auffüllen (`if ((wasm_peek16(0x1b8) & 0xff) < 3) wasm_poke(0x1b9, 7)`), bis nach dem Levelende (im Nachbau
  `Quit_Delay` ab ≈ 23.172, Exit bei 23.369; dabei auch prüfen, ob Feuer während des Levelendes Schüsse startet, O-015);
  Bilder, Spur und Zeitprofil in Abschnitten von höchstens ≈ 2.000 Bildern ab 14.793. Starts (Bild ≈ 13.193 +
  `Level_X`): `R_Transporteur` 14.793, `R_Tir_Etoile` ≈ 16.880, `R_Spectre` ≈ 17.160, `R_Rapide` ≈ 17.350,
  `R_Bomber` ≈ 19.110, `R_Volant_Grossi` ≈ 20.550, `R_Volant_Missile` ≈ 21.900, `R_Final` ≈ 22.140; erster Bonus
  im Nachbau bei ≈ 15.160. Darin auch die ersten Gegnerschüsse im Einsatz. Der Nachbau muss dieselbe Lebens-Auffüllung
  nachspielen (Test wie `explore-level.ts`). Den Planungs-Bot über so lange Strecken nicht verwenden (rechnet für
  jeden Ausweichversuch den ganzen Lauf neu, zu langsam).
- **Dauer des Bonus im Copper-Interrupt** (mit derselben Aufnahme, Ablauf D): Das Zeitmodell kennt den Bonus-Teil
  nicht (`IRQ_COST`); aus dem Zeitprofil nachmessen.
- **Zeitmodell bei hoher Last** (E-037, W-021, Ablauf C + D, Effort „maximal“): Der Objekt-Schritt ist bei großer
  Blitter-Last (Spinne ganz im Bild) im Original rund 10 Zeilen kürzer als gerechnet. Im Emulator je Blit des
  Objektteils messen (Haltepunkte an BLTSIZE und WaitBlit), dann `fit_part1b_timing.py --run level1_go --run
  level1_shoot` mit dem neuen Posten und `SHOOT_MODEL_LAST` in `level1.test.ts` auf `SHOOT_LAST` (14792) anheben;
  Detail je Durchlauf mit `node test/tools/detail-timing.ts level1_shoot 14520 14600`.

- **Zaubermenü, Zauber und Pause** (mit der Aufnahme über Bild 14.792 hinaus, Ablauf C; prüft W-024): an einigen
  Stellen Leertaste drücken, mit dem Joystick einen Zauber wählen und mit Feuer starten (vorher alle Zauber per Poke
  verfügbar machen: `Spell_Advailable` $1C4–$1D3 = 1), einmal P drücken und mit Feuer beenden; dazu einen Bonus mit
  Äxten einsammeln. Im Emulator die Tasten über die Tastatur von vAmiga senden (Tastencodes $40, $19).

Für den Nutzer zu entscheiden:

- Ton im Level: Soundeffekte (`Sound.bin`) und die Musik von Jeroen Tel (offene Frage: Treiber portieren oder vorab
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
| 08.10.2026 | Zeitmodell bei hoher Last (Cloud-Session) | hoch | – | – | in der Cloud nicht abfragbar (kein `get_usage`); Cloud-Guthaben statt Plan-Limit; 1 Sitzung, kein Compact |
| 08.10.2026 | Ladebild Level 2 (Cloud-Session) | mittel | – | – | in der Cloud nicht abfragbar (kein `get_usage`); 1 Sitzung, kein Compact |
| 08.10.2026 | Gegner-Routinen Level 1 (Cloud-Session) | hoch | – | – | wie oben; dieselbe Sitzung wie der Schritt davor, kein Compact |
| 08.10.2026 | Bonus (Cloud-Session) | hoch | – | – | wie oben; dieselbe Sitzung |
| 08.10.2026 | Levelende Level 1 (Cloud-Session) | hoch | – | – | in der Cloud nicht abfragbar; neue Sitzung, kein Compact |
| 09.10.2026 | Zaubermenü, Zauber, Äxte, Pause (Cloud-Session) | hoch | – | – | in der Cloud nicht abfragbar; 1 Sitzung, kein Compact |
| 09.10.2026 | Bedienung nach E-043 (Cloud-Session) | mittel | – | – | in der Cloud nicht abfragbar; 1 Sitzung, kein Compact |
| 09.10.2026 | Level 2: Abbild und Layout (Cloud-Session) | hoch | – | – | in der Cloud nicht abfragbar; 1 Sitzung, kein Compact |
| 09.10.2026 | Level 2: bekannte Gegner-Routinen (Cloud-Session) | hoch | – | – | in der Cloud nicht abfragbar; 1 Sitzung, kein Compact |
| 09.10.2026 | Level 2: `R_Kamikaze`, `R_Sol_Etoile` (Cloud-Session) | hoch | – | – | in der Cloud nicht abfragbar; 1 Sitzung, kein Compact |
| 09.10.2026 | Level 2: Endgegner `R_Final` und Levelende (Cloud-Session) | hoch | – | – | in der Cloud nicht abfragbar; neue Sitzung nach `/clear`, kein Compact |
| 09.10.2026 | Level 3: Ladebild, Abbild, Layout, Startliste (Cloud-Session) | hoch | – | – | in der Cloud nicht abfragbar; neue Sitzung nach `/clear`, kein Compact |
| 09.10.2026 | Level 3: bekannte Gegner-Routinen und `R_Jumper` (Cloud-Session) | mittel | – | – | in der Cloud nicht abfragbar; neue Sitzung nach `/clear`, kein Compact |
| 09.10.2026 | Level 3: `R_Sol_Kamikaze` (Cloud-Session) | mittel | – | – | in der Cloud nicht abfragbar; neue Sitzung nach `/clear`, kein Compact |
| 09.10.2026 | Level 3: Endgegner `R_Final` und Levelende (Cloud-Session) | hoch | – | – | in der Cloud nicht abfragbar; neue Sitzung nach `/clear`, kein Compact |
| 09.10.2026 | Level 4: Ladebild, Abbild, Layout, Startliste (Cloud-Session) | hoch | – | – | in der Cloud nicht abfragbar; neue Sitzung nach `/clear`, kein Compact |

## Verlauf

- **09.10.2026 (Level 4: Ladebild, Abbild, Layout, Startliste; Cloud-Session)** – `load_mountains` hat denselben Code
  wie `load_marshes` (Bild `$692AE`); der gemeinsame Code von `mountains` ist Befehl für Befehl der von `marshes`
  (Unterschiede nur 80 Teilbilder und Datei `$12` als nächstes Level). Layout `MOUNTAINS` per `derive_layout.py` aus
  `MARSHES`, Pipeline-Blöcke `mountains.*`, Startliste (123 Einträge) und 8 Routinen-Adressen gegen den Quelltext
  geprüft. Nach dem Levelende von Level 3 folgen Ladebild und Level 4; der Lauf hält beim ersten `R_Bomber` (Bild
  211), danach `ui.level4Stub`. Neuer Test `level4.test.ts`, Ladebild-Test für Level 4, `explore-level.ts
  --mountains`; 87 Tests. Gerendertes Bild von Level 4 per `--ppm` angesehen (plausibel). Gegen das Original
  ungeprüft. origin/main war schon enthalten.
- **09.10.2026 (Level 3: Endgegner `R_Final` und Levelende, Cloud-Session)** – Abbild `$4FE74` gleich dem Quelltext
  (`finalMarais` in `routines.ts`, [Level](original/level.md#level-3--sumpf-ag_game_lmaraiss-wellen-parameter-in-lmarais_rtrs)):
  folgt der Eule, streckt alle 50 Durchläufe die Zunge aus, nach der Explosion `Quit_Delay` 25 und Levelende.
  Zwei Eigenheiten des Originals: Zähler der Zunge an Adresse `$2` (O-016), Schreibzugriff in `Final_Shape` ohne
  Wirkung (O-017). `level3.test.ts` spielt bis zum Levelende (10.609 Bilder), danach `ui.level4Stub`. 1 neuer
  Test, 84 Tests. Im Browser nicht geprüft (nur Kern). Gegen das Original ungeprüft. origin/main war schon enthalten.
- **09.10.2026 (Level 3: `R_Sol_Kamikaze`, Cloud-Session)** – Routine aus `AG_GAME_LMARAIS.S` und Abbild `$4FD7C`
  übertragen (`solKamikaze`, Eintrag in `MARSHES.routines`): läuft am Boden, stürmt bei tief fliegender Eule mit
  10 Pixeln los. Level 3 läuft jetzt bis zum Endgegner `R_Final` (Bild 9.046), alle anderen Routinen des Levels sind
  dabei gestartet. 1 neuer Test, 83 Tests. Im Browser nicht geprüft (nur Kern). Gegen das Original ungeprüft.
  origin/main war schon enthalten.
- **09.10.2026 (Level 3: bekannte Gegner-Routinen, Cloud-Session)** – Quelltext per `diff` und Abbild Befehl für Befehl
  mit Level 1/2 verglichen: 8 Routinen als Einträge in `MARSHES.routines`, keine mit eigener Palette; neue Felder
  `RapideDef.count`, `pal: null` bei Transporteur und Sol_Crache, Schuss von `R_Volant_Missile` 2 Pixel. `R_Jumper`
  hat in Level 3 eigenen, kurzen Code (`jumperMarais`), gleich mit übertragen. Level 3 läuft bis zum ersten
  `R_Sol_Kamikaze` (Bild 1.365). 5 neue Tests, 82 Tests. Im Browser nicht geprüft (nur Kern, Level 3 erst nach zwei
  Leveln erreichbar). Gegen das Original ungeprüft. origin/main war schon enthalten.
- **09.10.2026 (Level 3: Ladebild, Abbild, Layout, Startliste; Cloud-Session)** – `load_marshes` hat denselben Code wie
  `load_forest` (Bild `$686C4`); `marshes` hat denselben gemeinsamen Code wie `forest`, Befehl für Befehl. Neues
  Werkzeug `tools/analysis/derive_layout.py` überträgt ein Layout über die ausgerichteten Operanden (Selbsttest
  `SEA` → `FOREST` stimmt bis auf Regen und Teilbildzahl); daraus `MARSHES` (`layout.ts`), Pipeline-Blöcke
  `marshes.*`. Nach dem Levelende von Level 2 folgen Ladebild und Level 3 mit den gemeinsamen Variablen; der Lauf
  hält beim ersten `R_Rapide`, danach `ui.level3Stub`. Neuer Test `test/level3.test.ts`, Ladebild-Test für beide
  Level; `explore-level.ts --marshes`. 77 Tests. Gegen das Original ungeprüft. Vorher origin/main übernommen.
- **09.10.2026 (Bedienung nach E-043, Cloud-Session)** – Pause-Knopf für Touch (oben links neben dem Zahnrad) und
  Gamepad (Start), automatische Pause, wenn die App in den Hintergrund geht (nur ohne laufende Pause), im Optionsmenü
  „FEUERMENÜ: AN/AUS“ (`Menu_Mode`, gespeichert) und im Level „SPIEL BEENDEN“ mit Rückfrage (wie Esc). Im Browser
  geprüft (Tablet quer, Touch): Knöpfe und Menü. Kern-Tests `test/controls.test.ts`. 74 Tests.
- **09.10.2026 (Level 2: Endgegner `R_Final` und Levelende, Cloud-Session)** – Eigener Code, nicht der Endgegner von
  Level 1: Ober- und Unterteil pendeln, das Oberteil wirft alle 18 Durchläufe eine Bumerangwelle, Explosion in vier
  Schritten bis `Clean_Up` (`finalForet` in `routines.ts`, [Level](original/level.md#level-2--wald-ag_game_lforets)).
  Abbild weicht wie in Level 1 vom Quelltext ab (Schussrate 20, `Quit_Delay` 100 in Schritt 1). Level 2 läuft jetzt
  bis zum Levelende, danach `ui.level3Stub`; `level2.test.ts` spielt mit Dauerfeuer bis dorthin (12.317 Bilder).
  1 neuer Test, 71 Tests. Gegen das Original ungeprüft.
- **09.10.2026 (Level 2: `R_Kamikaze` und `R_Sol_Etoile`, Cloud-Session)** – Beide neuen Routinen nach Quelltext und
  Abbild übertragen (`routines.ts`, `FOREST.routines`): Kamikaze hält auf die Eule zu und fliegt dann davon,
  Sol_Etoile wandert am Boden und schießt drei Schüsse nach oben ([Level](original/level.md#level-2--wald-ag_game_lforets)).
  Level 2 läuft ohne Eingabe bis `R_Final` (`level2.test.ts`, jetzt ≈ 9.000 Bilder). Fehlendes `PAR_END` im
  Quelltext bei `WAIT $12D0` ist im Abbild vorhanden. `explore-level.ts` nennt den Grund des Anhaltens. 3 neue
  Tests, 70 Tests. Gegen das Original ungeprüft.
- **09.10.2026 (Level 2: bekannte Gegner-Routinen, Cloud-Session)** – `R_Spectre`, `R_Tir_Etoile`,
  `R_Volant_Missile`, `R_Araignee` und `R_Rapide` von Level 2 nach Quelltext und Abbild verglichen und als Einträge in
  `FOREST.routines` übertragen; die Unterschiede (keine eigene Palette, CLOSE ohne Zählerabzug, Energie, Tempo des
  Schusses, Lage einer Variablen) stehen als Felder der `…Def`-Typen ([Level](original/level.md#level-2--wald-ag_game_lforets)).
  5 neue Tests in `routines.test.ts`, 67 Tests. Im Spiel noch nicht zu sehen: Der Lauf hält vorher an `R_Kamikaze`.
  Gegen das Original ungeprüft. Vorher origin/main mit E-043 übernommen.

- **09.10.2026 (Level 2: Abbild und Layout, Cloud-Session)** – Neues Werkzeug `tools/analysis/align_levels.py`
  richtet die Disassemblies von `sea` und `forest` Befehl für Befehl aus: Der gemeinsame Code ist bis auf den Regen
  gleich, daraus alle Werte des Layouts `FOREST` (`layout.ts`). Pipeline (`extract/levels.ts`, vorher `level1.ts`)
  schneidet die Speicherblöcke von `forest`; Regen nur noch in Level 1 (`LevelLayout.rain`); die gemeinsamen
  Variablen ab `$1B0` gehen beim Levelende an Level 2 (`LevelExits.levelDone(shared)`). Nach dem Ladebild läuft
  Level 2 bis zum ersten `R_Kamikaze` (`WAIT $170`), danach Platzhalter. Gegen das Original noch ungeprüft. Neuer
  Test `test/level2.test.ts`; `explore-level.ts --forest --ppm`. 62 Tests.
- **09.10.2026 (Zaubermenü, Zauber, Äxte, Pause; Cloud-Session)** – Nach der Disassembly übertragen (`spells.ts`):
  Zaubermenü (ICONES SPRITES: Pfeil, Auswahl, Maske für fehlende Zauber, Start mit Dauer aus `Time_Table`), die Zauber
  0–5 und 7 (Back/Rotative/Forward Fire Ball, Stop Time, Seeker, Smart Bomb, Mega Blast), Kollisionsrechtecke der
  Äxte, Pause und Tastatur-Interrupt (KEY TEST). Das Abbild öffnet das Menü mit der Leertaste, Feuer halten nur mit
  `Menu_Mode` (E-042: Zauber-Knopf = Leertaste, neuer Pause-Knopf = P). Gegen das Original noch ungeprüft (W-024).
  Kern-Tests `test/spells.test.ts`; Level 1 läuft mit `explore-level.ts` weiter bis zum Levelende. 60 Tests.
- **08.10.2026 (Ladebild Level 2, Cloud-Session)** – `load_forest` disassembliert (`work/disasm/load_forest_code.txt`):
  derselbe Code wie `load_sea`, nur mit verschobenen Adressen (Bild `$66F1A`, Palette `$79A2A`, Modul
  „loading_forest“ bei `$6323C`). Pipeline erzeugt alle Ladebilder aus einer Tabelle, `LoadingScreen` mit
  `LOAD_SEA`/`LOAD_FOREST`; nach `levelDone` folgt das Ladebild, dann der Platzhalter. Gegen das Original noch
  ungeprüft (Test in `game.test.ts`: Bild, Palette, Musik, Feuer). 55 Tests.

- **08.10.2026 (Levelende Level 1, Cloud-Session)** – `Quit_Delay`-Zweig der Eule übertragen (Joystick übersprungen,
  Kollisionsrechteck weiter, `$4412`) und EXIT LEVEL mit Leben (`Agony_Parent_.s`, Label `Exit`): Ergebnis
  `levelDone`, der Level-Bildschirm wartet wie beim Spielende und führt dann vorläufig zum Platzhalter „Level 2“
  (`ui.level2Stub`). Alle Lesestellen von `Quit_Delay` im Abbild geprüft; neue Eigenheit O-015 (Feuersperre wirkungslos).
  Erkundungslauf endet regulär: Levelende ab Bild ≈ 23.172, Exit 23.369. Gegen das Original noch ungeprüft. Neuer
  Kern-Test `test/level-end.test.ts`. 54 Tests.
- **08.10.2026 (Bonus, Cloud-Session)** – BONUS aus dem Copper-Interrupt (`$56BA`, `Ag_Sprites.s`) übertragen und
  gegen die Disassembly abgeglichen: Auswahl nach 2000 Bildern (Waffe, Geld, Äxte, nächster fehlender Zauber nach
  `Spell_Pri`), Regen aus, Fallen und Rollen, Anzeige mit Sprite 6/7, Einsammeln. Gegen das Original noch ungeprüft
  (W-023). Eigenheit nachgebildet: Beim Schließen schreibt das Original `Spr6pt`/`Spr7pt` relativ zu a5 in den
  Speicher statt in die Custom-Register. Neu: Kern-Test `test/bonus.test.ts`, Erkundungs-Werkzeug
  `test/tools/explore-level.ts` (Dauerfeuer, Leben aufgefüllt): Level 1 läuft damit bis ≈ Bild 23.020 durch alle
  Gegner-Routinen samt Endgegner; nächste Lücke ist das Levelende (`Quit_Delay`). Arbeitsweise für Cloud-Aufträge in
  `arbeitsablauf.md` festgehalten. 51 Tests.
- **08.10.2026 (Gegner-Routinen von Level 1, Cloud-Session)** – Ablauf B ohne Bildvergleich: `R_Transporteur`,
  `R_Tir_Etoile`, `R_Spectre`, `R_Rapide`, `R_Bomber`, `R_Volant_Grossi`, `R_Jumper`, `R_Volant_Missile` und
  `R_Final` aus `Ag_Game_LMER.s` übertragen, Befehl für Befehl gegen das Abbild abgeglichen (Disassembly neu mit
  `disasm68k.py`; Capstone in der Cloud per `pip install capstone`). Übertragen, gegen das Original noch ungeprüft
  (W-022). Eigenheiten nachgebildet (Wellen mit 32 statt 16 Gegnern, Kugelschleife von `R_Bomber`); Abbild weicht in
  `R_Final` vom Quelltext ab (`Quit_Delay`). Korrektur: `$4F696` ist `R_Volant_Grossi`, `R_Jumper` (`$4F75E`) wird in
  Level 1 nie gestartet. Neue Kern-Tests ohne Aufnahme (`test/routines.test.ts`, Werte aus dem Quelltext). Der Lauf
  `level1_shoot` kommt mit seinen Eingaben jetzt bis Bild 15.159 (Transporteur-Wellen abgeschossen); nächste Lücke:
  Bonus in 15.160. Bilder bis 14.792 unverändert. 50 Tests.
- **08.10.2026 (Zeitmodell bei hoher Last, Cloud-Session, angehalten)** – Ablauf D über beide Läufe: Daten neu
  gesammelt (`level1_shoot` bis 14792), Anpassungen je Lauf und gemeinsam. Die Konstanten bleiben, denn die gemeinsame
  Anpassung verschlechtert `level1_go` (56 statt höchstens 40 sichtbar falsche Lagen) und löst den Fehler nicht.
  Ursache eingegrenzt (W-021): Objekt-Schritt bei großer Blitter-Last im Original rund 10 Zeilen kürzer als
  gerechnet; Interrupt-Dauer, Blit-Art, Blit-Größe und Sprite-DMA erklären es nicht. Nach der Zwei-Versuche-Regel
  angehalten. Neu: `fit_part1b_timing.py` mit mehreren `--run` (gemeinsame Anpassung, Rest je Lauf; `--residuals`
  rechnet den Objekt-Schritt jetzt gegen alle freien Zyklen), `test/tools/detail-timing.ts` (Modell gegen Messung je
  Durchlauf). `SHOOT_MODEL_LAST` bleibt 14566. 42 Tests.
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
