# Architektur – technisches Konzept des Nachbaus

Stand: 06.10.2026 · Status: Web-Grundgerüst umgesetzt (Abschnitt [Umsetzung](#umsetzung-web-grundgerüst)); was
sich ändert, hier nachziehen und in [Entscheidungen](entscheidungen.md) begründen.

## Zielplattformen

| Plattform | Wann | Technik |
|---|---|---|
| Browser auf Tablets: iPadOS (Safari), Android (Chrome) | Hauptziel ab Schritt 5 | Web-Build aus `game/` → `server/` |
| Desktop-Browser unter Windows, macOS, Linux | ab Schritt 5, vor allem für Entwicklung und Tests | derselbe Web-Build |
| **Native App für iPadOS**, eventuell auch iOS (iPhone) | sobald ein Mac verfügbar ist (laut Nutzer in ein bis zwei Monaten, Stand 06.10.2026) | derselbe Web-Build in einer nativen Hülle (Empfehlung: Capacitor) |

Grundsatz: **eine Codebasis für alle Plattformen.** Der Code wird von Anfang an so geschrieben, dass er ohne Umbau
in die native App passt.

## Weg zur nativen App

**Empfehlung: Capacitor** (Entscheidung fällt, wenn der Mac da ist; siehe E-015).

- Capacitor packt den fertigen Web-Build in eine iOS-App. Darin läuft er in einer WKWebView, also mit derselben
  Engine wie Safari: WebGL2, Web Audio und Touch funktionieren wie im Browser.
- Native Funktionen kommen über Plugins: dauerhafter Speicher, Statusleiste und Home-Indikator, App-Lebenszyklus,
  Haptik, später etwa Game Center.
- Stand Oktober 2026 🌐: Capacitor 8 benötigt Xcode 26 und nutzt standardmäßig den Swift Package Manager
  (CocoaPods ist nur noch in Wartung). Apple nimmt seit dem 28.04.2026 nur noch Uploads an, die mit Xcode 26 bzw.
  dem iOS-26-SDK gebaut sind.
- Bauen und Signieren geht nur auf macOS mit Xcode. Zum Testen auf eigenen Geräten reicht eine kostenlose Apple-ID
  (die Installation läuft dann nach 7 Tagen ab); TestFlight und App Store brauchen das kostenpflichtige Apple
  Developer Program.
- Später wäre mit Capacitor auch eine Android-App möglich (derzeit nicht geplant).

**Alternative:** ein vollständig nativer Nachbau in Swift mit Metal oder SpriteKit. Das bedeutet deutlich mehr
Aufwand und doppelte Spiellogik. Er bliebe aber möglich, weil Kern, Daten und Tests plattformneutral angelegt werden:
Die Logik ist dokumentiert, die Assets liegen in neutralen Formaten, und Replays dienen als Prüfstein für jede
Portierung.

## Schichtenmodell

```
game/src/
  core/       Spiellogik: Zustand, 50-Hz-Takt, Eule, Objekte, Wellen, Kollision, Punkte, Zufall
              → reines TypeScript, kein DOM, keine Browser-APIs, keine Plattform-Imports
  data/       Typen und Lader für die Spieldaten aus der Asset-Pipeline
  platform/   Schnittstellen für Plattformdienste plus Web-Umsetzungen:
              Renderer (WebGL2), Audio (Web Audio), Eingabe (Touch, Tastatur, Gamepad),
              Speicher, Lebenszyklus, Anzeige (Viewport, Safe Areas, Pixeldichte)
  native/     (später) Capacitor-Umsetzungen derselben Schnittstellen
  app/        Zusammenbau: Plattform erkennen, Dienste verbinden, Hauptschleife starten
```

Regeln:

- `core/` importiert nichts aus `platform/`, `native/` oder `app/` und nutzt keine DOM-Typen. Eingaben kommen pro Tick
  als Joystick-Zustand herein; heraus gehen Spielzustand und Ereignisse (z. B. „Sound abspielen“).
- Plattformdienste nur über Schnittstellen, die `app/` beim Start einsetzt.
- Die Plattform wird an genau einer Stelle erkannt (später z. B. über `Capacitor.isNativePlatform()`).
- Gewinn: Kern und Replays laufen ohne Browser in Node (Vitest), und jede Plattform tauscht nur die Dienste aus.

## Darstellung

- **WebGL2.** Original-Grafiken bleiben indiziert (Farbindex plus Paletten). Der Kern setzt Ebenen, Sprites und
  Text zu einem indizierten Bild mit einer Palette pro Zeile (Copper) zusammen; der Shader schlägt nur die Farben nach
  und skaliert (E-026). Später kommen HD-Assets (RGBA) als alternative Ebenen-Quelle hinzu (Phase 2).
- **Interne Auflösung wie im Original:** fester Ausschnitt des PAL-Bilds mit 352 × 280 Lowres-Pixeln (Hires und
  Interlace doppelt so fein, E-026). Jeder Bildschirm legt fest, welchen Teil davon er mindestens zeigen muss
  (`view`); im Level sind das Statuszeile und Spielfeld: 288 Pixel breit, Rasterzeilen `$2D`–`$FF` (211 Zeilen).
- **Level:** Dort entsteht das indizierte Bild aus einem Modell der Grafik-Hardware (Copper, Bitplanes, Sprites),
  auf dem der übertragene Spielcode mit den Originaldaten arbeitet (E-032, [Level-Engine](#level-engine-e-032)).
- **Skalierung:** ganzzahlig und pixelgenau, solange das Bild dabei mindestens 90 % der möglichen Größe erreicht;
  sonst „scharf“ (Sharp Bilinear: innerhalb eines Pixels flach, nur am Übergang höchstens ein Bildschirmpixel
  gemischt), damit keine ungleich breiten Pixel entstehen. Rest als Rand (Letterbox).
- **Pixeldichte:** Canvas-Größe in physischen Pixeln (`devicePixelRatio`) setzen.
- **Bildschirmformen:**
  - Das 3:2-Spielfeld passt gut zu iPads (etwa 1,43:1) und 16:10-Tablets; dort bleibt wenig Rand, Bedienelemente
    überlagern den Spielfeldrand oder liegen in schmalen Leisten.
  - iPhone im Querformat (etwa 2,16:1): breite Seitenränder, also Steuerung links und Knöpfe rechts neben dem
    Spielfeld.
- **Safe Areas** (Notch, Dynamic Island, Home-Indikator): `viewport-fit=cover` und `env(safe-area-inset-*)`.
- **Bildwiederholrate:** Die Logik läuft mit 50 Hz, die Darstellung mit der Rate des Displays (60/120 Hz,
  ProMotion). Der Flacker-Trick des Originals wird auf solchen Displays durch die Mischfarbe ersetzt; Interpolation
  für flüssigere Bewegung gehört zu Phase 2.

## Spielschleife

- Feste Schritte im Takt des Originals (Länge in Farbtakten, ≈ 49,92 Hz, E-029) mit Akkumulator, getrennt vom
  Rendering per `requestAnimationFrame`. Begrenztes Aufholen nach Aussetzern (höchstens 4 Takte pro Bild).
- Deterministisch, inklusive nachgebautem Zufallsgenerator des Originals. Eingaben pro Tick lassen sich aufzeichnen
  und als Replay abspielen.
- Pause bei App-Wechsel, Bildschirmsperre, Tab-Wechsel und im Zaubermenü.

## Eingabe

- Abstraktionsschicht „virtueller Amiga-Joystick“: 8 Richtungen + Feuer, dazu eine Taste für das Zaubermenü. Das
  Original öffnet das Menü mit gehaltenem Feuerknopf; das kollidiert mit Dauerfeuer, daher eine eigene Schaltfläche.
- Quellen:
  - Touch: virtueller Joystick (originalgetreu) und/oder relative Ziehsteuerung; mehrere Varianten als Prototyp
    vergleichen.
  - Tastatur.
  - Gamepad über die Gamepad API ❓ (in der WKWebView der nativen App prüfen; sonst nativ über das
    GameController-Framework per Plugin).
- Bedienlayouts je Geräteklasse (iPad, iPhone quer, Desktop). Bedienelemente möglichst außerhalb des Spielfelds,
  damit die Finger nichts verdecken.
- Keine Browser-Gesten: `touch-action: none`, kein Zoom, kein Scroll-Bounce, keine Textauswahl, kein Kontextmenü
  bei langem Drücken.

## Audio

- Web Audio API, in Browser und WKWebView gleich.
- Erst nach der ersten Berührung freischalten (iOS-Autoplay-Regeln). In der nativen App hängt das von der
  WebView-Konfiguration ab; der Freischalt-Pfad bleibt trotzdem erhalten.
- Paula-Modell im Kern, Klangerzeugung (Mixer) in der Plattform, AudioWorklet mit Notbehelf im Hauptthread (E-027).
  Die Samples liegen als 8-Bit-Rohdaten im Build; keine komprimierten Audioformate nötig.
- ProTracker-Abspieler als Kern-Logik, die Paula-Register schreibt (wie `mt_music` im Bild-Interrupt): wörtliche
  Portierung der Routine aus `igt`/`load_sea` samt Eigenheiten (`core/protracker.ts`, Details in
  [Audio](original/audio.md#protracker-abspieler-menü-und-ladebilder)).
- Schreibzugriffe tragen einen Zeitpunkt innerhalb des Takts; wartet das Original auf einen Audio-Interrupt, geschieht
  der Zugriff genau in dem Moment, in dem das Sample endet. Die CPU kann außerdem Sampledaten ändern (E-030).
- Offen: Jeroen Tels Treiber portieren oder Stücke vorab rendern (siehe [Status → Offene Fragen](status.md#offene-fragen));
  mit dem Paula-Modell liegt die Portierung nahe.
- Native App: Audio-Sitzung passend einstellen (z. B. ob der Stummschalter respektiert wird). Bei App-Wechsel
  pausieren.

## Sprachen

Deutsch und Englisch ab dem ersten Code (E-021); Textbestand und Übersetzungen in [Texte](texte.md).

- **Keine Texte im Code:** Alles, was der Spieler liest, kommt über Schlüssel aus Sprachtabellen (`en`, `de`),
  z. B. `story.start`, `credits.3`, `ui.options`. Ausnahme Statuszeile der Level: Sie arbeitet wie das Original mit
  Textnummern (`Text_Num`); Englisch kommt aus dem Level-Abbild, Deutsch aus `DE_STATUS` (Liste je Level).
- **Englisch = Original:** Die englische Tabelle erzeugt die Asset-Pipeline aus den Texttabellen der Spieldateien,
  inklusive der Original-Positionen. Im englischen Modus sehen die Bildschirme also exakt aus wie 1992.
- **Deutsch = Übersetzung** in derselben Bitmap-Schrift; die Tabelle wird von Hand gepflegt. Zeilen werden
  automatisch zentriert, weil die Original-Positionen für die englischen Längen berechnet sind.
- **Schrift:** Ä, Ö und Ü erzeugt ein Skript aus A, O, U plus zwei Punkten im Stil der Schrift; ß wird als „SS“
  geschrieben.
- **Auswahl:** Voreinstellung nach Gerätesprache (`navigator.language` bzw. Systemsprache der App: `de*` → Deutsch,
  sonst Englisch), änderbar im Optionsmenü (E-022). Gespeichert über die Speicher-Schnittstelle.
- **Optionsmenü:** wird im Spiel selbst mit der Original-Schrift gezeichnet, nicht als HTML; so sieht es in Browser
  und App gleich aus. Aufruf über ein kleines Symbol am Bildrand (Touch) bzw. eine Taste (Desktop).
- Sprache wird zur Laufzeit umgeschaltet, ohne Neustart.

## Speicher

- Schnittstelle für Highscores und Einstellungen (Schlüssel/Wert).
- Web: `localStorage` oder IndexedDB.
- Native App: Capacitor-Plugin „Preferences“, weil iOS den Speicher der WebView unter Umständen löscht.

## Lebenszyklus

- Web: `visibilitychange` und `pagehide`.
- Native App: App-Plugin von Capacitor (Wechsel in den Hintergrund/zurück).
- Beides löst dieselben Ereignisse aus: Spiel und Audio pausieren bzw. fortsetzen.

## Web und native App im Vergleich

| Thema | Web | Native App (Capacitor) |
|---|---|---|
| Vollbild | Fullscreen API bzw. Web-App-Manifest (`display: fullscreen`) | automatisch |
| Querformat | Hinweis „Gerät drehen“; Manifest `orientation: landscape` | in der App-Konfiguration festlegen |
| Offline | Service Worker (PWA, Phase 2) | automatisch, alle Dateien sind in der App |
| Speicher | `localStorage` / IndexedDB | Preferences-Plugin |
| Statusleiste, Home-Indikator | – | per Plugin bzw. Konfiguration ausblenden |
| Adressen | relative Pfade (`base: './'`) | Inhalte kommen von `capacitor://localhost` → ebenfalls nur relative Pfade |
| Updates | neuer Build auf dem Server | neue App-Version über Xcode bzw. TestFlight |

Daraus folgen Regeln, die **ab dem ersten Code** gelten:

- Nur relative Pfade, keine festen Server-Adressen. Alle Assets liegen im Build, nichts wird aus dem Internet
  nachgeladen.
- Die Grundfunktion darf nicht von Web-only-APIs abhängen (Service Worker, Fullscreen API, Web-App-Manifest).
  Diese sind optionale Extras der Web-Fassung.
- Plattformdienste nur über die Schnittstellen in `platform/`.

## Build

- `game/` ist ein Vite-Projekt mit TypeScript (strict), ohne Game-Engine.
- `npm run build` schreibt das spielbare Spiel nach `server/` (`index.html`, JavaScript, Assets). Vite-Einstellungen:
  `build.outDir: '../server'`, `build.emptyOutDir: true` und `base: './'`, damit das Spiel aus jedem
  Unterordner des Webservers läuft. `server/` wird bei jedem Build komplett neu erzeugt, also nie von Hand
  bearbeiten.
- Aufruf nur über einen Webserver (http/https), lokal z. B. mit `npm run preview`. Per Doppelklick (`file://`)
  blockiert der Browser Module und Assets.
- Test auf einem echten Tablet im Heimnetz: Dev-Server mit `--host` starten.
- Native App (später): Capacitor übernimmt den Build und kopiert ihn ins Xcode-Projekt (`npx cap sync ios`). Wo das
  Capacitor-Projekt liegt, wird beim Einrichten entschieden ❓ (naheliegend: `game/ios/`, Web-Verzeichnis =
  Build-Ausgabe).
- Das Projekt liegt auf einem NAS, PC und Mac arbeiten auf denselben Dateien (E-017). `node_modules` enthält
  plattformabhängige Programme; wie beide Rechner damit umgehen, wird mit dem Mac entschieden (E-018). Die
  Dateiüberwachung des Dev-Servers bei Bedarf auf Polling umstellen (`server.watch.usePolling`), weil
  Änderungsmeldungen über Netzlaufwerke unzuverlässig sind. Regeln für den gemeinsamen Ordner:
  [Setup](setup.md#zwei-rechner-ein-nas).

## Leistung

- Keine Allokationen in der Spielschleife (Objekt-Pools); Assets vorab laden und dekodieren.
- Ziel: stabile Bildrate auf Mittelklasse-Tablets und iPhones.

## Tests

- Vitest für `core/` in Node, ohne Browser: Kollision, Gegnerbewegung, Punkte, Wellen.
- Replays (Eingaben pro Tick + Prüfsummen des Zustands) als Regressionstests. Dieselben Replays prüfen später jede
  Plattform und jede Portierung.
- Sichtprüfung im Browser (Tablet- und Smartphone-Viewport, Querformat), auf echten Geräten im Heimnetz, später im
  Xcode-Simulator und auf dem iPad.
- Abgleich mit dem Original im Referenz-Emulator: Bildpuffer und Speicher auslesen (siehe [Setup](setup.md)).
  Ablaufspuren (`AG.traceRun`: Speicherwörter je Bild) prüfen ganze Abläufe Bild für Bild, Speicherabzüge und
  Interlace-Aufnahmen einzelne Bilder pixelgenau, Hires-Aufnahmen (`AG.recordHires`) jedes Bild eines Ablaufs
  pixelgenau (Level). Die Tests überspringen sich, wenn `work/captures/` fehlt.

## Asset-Pipeline

- Ablauf: ADF lesen → PowerPacker entpacken → Formate anhand des Quellcodes entschlüsseln → Grafiken (Bitplanes,
  Paletten, Sprites), Angriffswellen und Leveldaten, Musik und Samples in neutrale Formate umwandeln
  (PNG/JSON/Audio).
- Alles reproduzierbar per Skript aus `reference/`; erzeugte Assets nicht von Hand bearbeiten.
- Werkzeuge in `tools/`, bevorzugt in TypeScript (Node führt `.ts` direkt aus); Python ist für Analysen erlaubt.
  Alle Werkzeuge laufen unter Windows, macOS und Linux.
- Neutrale Formate halten auch einen späteren nativen Nachbau offen.

## Umsetzung (Web-Grundgerüst)

Stand 06.10.2026. Befehle und Werkzeuge: [Setup → Web-App](setup.md#web-app).

```
game/
  index.html            Canvas, Safe-Area-Hilfselement, Joystick-Anzeige, Zahnrad (Optionen)
  vite.config.ts        base './', Build nach ../server, Polling (NAS), Vitest
  tsconfig.core.json    Kern + Daten ohne DOM- und Node-Typen → erzwingt die Plattformneutralität
  tsconfig.json         Web-Fassung (DOM, Vite)
  tsconfig.tools.json   Asset-Pipeline, Emulator-Skripte, Tests (Node)
  public/data/          Spieldaten aus der Asset-Pipeline (nicht von Hand bearbeiten)
  src/core/             Kern (kein DOM):
    timing.ts           PAL-Takt, Farbtakte je Zeile/Bild
    display.ts          indiziertes Bild + Palette pro Zeile + Overlay, Bildausschnitt, Modi (E-026)
    paula.ts, chipmem.ts  Paula-Register, DMA-Zeitverhalten, Zugriffe mit Zeitpunkt, Sample-Speicher (E-027, E-030)
    protracker.ts       ProTracker-Abspieler des Originals (Menü- und Lademusik) mit Gesamtlautstärke
    script.ts           Ablaufsteuerung: Programm des Originals als Schritte mit Wartebedingungen
    flow.ts             Reihenfolge der Bildschirme (Titel → Menü → Ladebild → Level)
    text.ts             Menüschrift und Zeichenverfahren des Originals (pixelgenau geprüft)
    i18n.ts             Sprachtabellen, Voreinstellung nach Gerätesprache, Zentrieren der deutschen Zeilen
    input.ts            virtueller Joystick pro Takt (JOY_*, BTN_SPELL, BTN_OPTIONS, Antippen)
    game.ts             Takt, Bildschirm-Zustandsautomat, Optionsmenü, Hinweise, Einstellungen
    options.ts, notice.ts  Optionsmenü (E0) und Hinweise im Overlay
    replay.ts           Eingaben aufzeichnen/abspielen, Prüfsumme über Bild und Paletten
    assets.ts           Spieldaten aus manifest.json aufbereiten
    screens/            start-gate.ts (E-028), title.ts (present), menu.ts (igt, mit Story-Seite),
                        loading.ts (load_<level>), picture.ts (Copper-Bild, Ein-/Ausblenden),
                        level.ts (Level-Engine als Bildschirm), level-stub.ts (Platzhalter nach dem Start)
    amiga/              Hardware-Modell für die Level (E-032): ram.ts (512 KB Chip-RAM), blitter.ts,
                        video.ts (Copper, Bitplanes, Dual-Playfield, Sprites, Prioritäten → indiziertes Bild)
    level/              Port von Agony_Parent_.s: layout.ts (Adressen je Level-Abbild), engine.ts (Init,
                        Hauptschleife, Zeitmodell), back-scroll.ts, interrupt.ts (Copper-Interrupt: Eule, Äxte,
                        Regen), status.ts (Statuszeile)
  src/data/             manifest.ts (Format der Pipeline), lang/de.ts, lang/ui.ts
  src/platform/types.ts Schnittstellen: Renderer, AudioOutput, InputSource, KeyValueStore, Lifecycle, Platform
  src/platform/audio/   paula-mixer.ts (Klangerzeugung, ohne Browser-APIs)
  src/platform/web/     renderer.ts (WebGL2), audio.ts + paula-worklet.ts, input.ts, services.ts, platform.ts
  src/app/              main.ts (Zusammenbau, Einstellungen), loop.ts (Hauptschleife), style.css
  test/                 Vitest: Schrift/Sprachen, Paula, Mixer, Spielschleife, Blitter; Abgleich mit dem Emulator
                        (title, title-pixels, menu, level1: Ablaufspuren, Speicherabzüge und Aufnahmen aus
                        work/captures/; load-trace.ts, load-capture.ts, chip-dump.ts lesen sie)
```

Ablauf eines Takts: Die Hauptschleife fragt die Eingabe ab → `game.tick(input)` → das Paula-Protokoll des Takts geht
mit der Taktlänge an den Mixer → einmal pro Bildschirmbild zeichnet der Renderer (nur wenn sich etwas geändert hat).

**Bildschirme der Startsequenz** (Stand 07.10.2026): StartGate → Titelsequenz → Menü (Feuer: Story-Seite) →
Ladebild Level 1 → Level 1 bis „PRESS FIRE TO START“ → vorläufig Platzhalter „Level 1 kommt bald“ (Feuer: zurück
ins Menü). Jeder Bildschirm bildet das Programm
des Originals nach: das Hauptprogramm als `Script` (Schritte mit Wartebedingungen wie „warte n Bilder“, „warte auf
Zeile $10“, „warte auf Sample-Ende“), den Bild-Interrupt als Methode, die zu Beginn jedes Takts läuft. Menü und
Ladebilder führen ihre Copperliste (Palette, Bitplane-Zeiger) wie das Original: Was die CPU nach dem Interrupt
ändert, sieht man erst im nächsten Bild. Kopieren und Zeichnen der Menüseiten kosten im Original sichtbar Zeit; der
Nachbau übernimmt die im Emulator gemessenen Dauern (E-031). Ergebnis: Titelsequenz, Menü, Story-Seite und Ladebild
stimmen Bild für Bild mit dem Emulator überein (Farben, Bildzeiger, Musikzustand, Audio-DMA; Feuerband, Highscore-
Tabelle und Story-Seite zusätzlich pixelgenau).

### Level-Engine (E-032)

Stand 07.10.2026: Level 1 von der Initialisierung bis zum Spielende (Wellen, zwei Gegner-Routinen, Tod, Schild).

- **Speicher:** `Ram` (512 KB) enthält die Speicherblöcke des Levels an ihren Originaladressen (`manifest.memory`,
  [Dateiformate](dateiformate.md#speicherblöcke-der-level)), dazu die gemeinsamen Variablen ab `$1B0` wie nach dem
  Spielstart im Menü. Variablen des Spielcodes liegen wie im Original bei `a5 + Versatz` (`layout.ts`), sodass Tests
  sie an denselben Adressen mit den Ablaufspuren vergleichen.
- **Blitter:** Kanäle A–D, Minterm, Verschiebung, Masken, Modulos, auf- und absteigend; ein Blit läuft sofort durch.
- **Bildaufbau (`Video`):** führt je Bild die Copperliste ab `COP1LC` aus (MOVE, WAIT, Sprünge,
  Copper-Interrupt über `INTREQ`) und baut jede Rasterzeile: Bitplane-Abruf nach `DDFSTRT`/`DDFSTOP` mit Modulos,
  Verzögerung je Planegruppe (`BPLCON1`), Lowres/Hires, Dual-Playfield, Darstellungsfenster, Sprites per DMA-Liste
  (auch mehrfach genutzt, angehängte Paare; Endzeile auch unsichtbarer Sprites, O-014), Prioritäten (`BPLCON2`).
  Zeitmodell je Zeile: Copper-Befehle vor `$38` wirken auf den Abruf, vor `$48` auf die Farben der ganzen Zeile, vor
  `$D0` auf den Modulo am Zeilenende; außerhalb des Fensters steht die Farbe 0 vom Zeilenanfang (Rand). Positionen
  (erstes Datenpixel bei `2·DDFSTRT+17` bzw. `+9` in Hires, Sprite ab `HSTART+1`) sind gegen den Emulator bestätigt.
  Das Bild entsteht zeilenweise (`beginFrame`, `renderLines`), damit die Engine dazwischen Programmteile an ihrer
  Rasterzeile ausführen kann (E-037). Je Zeile zählt es die belegten Buszyklen (`busUsed`, für den Blitter) und davon
  die geraden (`busEven`, Copper und Lowres-Bitplanes 5/6, für den Prozessor). Das Bild ist Hires ohne Interlace
  (704 × 280); Lowres-Pixel sind doppelt.
- **Ablauf je Takt (`LevelEngine.tick`):** Bild beginnen → während des Aufbaus Teil 1b (Schritte vor dem
  Copper-Interrupt des Folgebilds bzw. im übernächsten Bild, je an ihrer Rasterzeile) und Teil 2 (ab Zeile `$40`) →
  Rest des Bilds → Copper-Interrupt → Schritte von Teil 1b nach dem Interrupt → Teil 1, sobald der 25-Hz-Takt
  `Gen_25hz_Phase` 2 erreicht (Copperliste, Scrolling, SEARCH SHORT PHASE). Teil 1b besteht aus den Schritten Objekte,
  Startliste und Bahnen, Paletten, Kollisionstest, Objekt-Routinen, Statuszeile, Statustext und Sounds; ihre Lage
  liefert eine Zeitquelle (`LoopTiming`: Zeitmodell, in Tests die Messung). Nach EXIT LEVEL läuft nur noch der
  Interrupt (stehendes Level wie während des Ladens, E-036).
- **Übertragen** sind: Init (`Restart`) mit Vorberechnung der Objekt-Masken (`objects.ts`, `precompute`),
  Copperlisten-Update, hinteres Playfield mit Mustern und Wellen-Animation, statische Ebene, vorderes Playfield
  (`front-scroll.ts`), Startliste mit Wellen und Routinen-Starts, Bahnverfolgung, Paletten, Kollisionen
  (`playability.ts`), Gegner-Routinen `R_Sol_Crache` und `R_Araignee` (`routines.ts`), Gegner als Blitter-Objekte
  (`objects.ts`), Gegnerschüsse (`alien-fire.ts`), Soundeffekt-Zustand ohne Ausgabe (`sounds.ts`), Statuszeile,
  „PRESS FIRE TO START“, Eule, Schuss, Äxte, Regen, Tod der Eule, Schild (Zauber 6), Zauberdauer, Aufräumen,
  Spielende. Die Engine hält an (`unported`), sobald eine noch nicht übertragene Gegner-Routine startet; der
  Level-Bildschirm wechselt dann zum Platzhalter. Andere nicht übertragene Wege (übrige Zauber, Zaubermenü, Pause,
  Bonus, Levelende mit Leben) lösen einen Fehler aus.
- **Zeitmodell (`timing.ts`, E-034, E-035, E-037):** Schleifenbeginn aus der Dauer des Copper-Interrupts (nach seinen
  Teilen), dann Copperliste, Scrolling und SEARCH SHORT PHASE (setzt `Short_Phase` wie das Original); danach eine
  Uhr für Teil 1b, die jeder Schritt um seine gezählte Arbeit (`stepWork`, Blitter-Takte) vorrückt, unterbrochen von
  Copper-Interrupt und Vertical Blank mit Musiktreiber (E-035). Rechenzeit mit Gegnern ≈ 1,4 ms je Bild.
- **Abgleich:** Ab dem dritten Bild jedes Bild pixelgenau gegen Hires-Aufnahmen des Emulators (ohne Eingabe,
  mit Joystick, mit der Eule am Rand; zusammen 520 Bilder), dazu Variablen je Bild und der Startzeitpunkt bei Feuer;
  nach dem Start der Lauf ohne Eingabe bis nach dem Spielende (1.690 Bilder: Wellen, drei Tode, Schild, Routinen,
  „GAME OVER“), einmal mit gemessener Strahlposition und Zeitlage, einmal mit dem Zeitmodell (`level1.test.ts`).

**Renderer:** Durchgang 1 rechnet Index → Farbe (Palette der Zeile, Extra-Halfbrite, Overlay mit Abdunkelung) in
eine Textur in Originalauflösung, Durchgang 2 skaliert sie (siehe [Darstellung](#darstellung)). Größe und Pixeldichte
werden bei jedem Bild geprüft; verlorener WebGL-Kontext wird neu aufgebaut.

**Eingabe (erste Fassung):**

| Quelle | Belegung |
|---|---|
| Tastatur | Pfeiltasten, WASD, Ziffernblock (auch diagonal) · Feuer: Leertaste, Strg, X, Ziffernblock 0 · Zauber: Umschalt links, M · Optionen: Esc, O |
| Gamepad (Standard-Belegung) | Steuerkreuz oder linker Stick · Feuer: A, B · Zauber: X, Y · Optionen: Start, Select |
| Touch | linke Hälfte: Joystick, entsteht beim Aufsetzen des Fingers (Totzone 14 px, 8 Richtungen) · rechte Hälfte: Feuer · Zahnrad oben rechts: Optionen |
| Antippen/Klicken | als Koordinate im Bildausschnitt an den Kern (z. B. Menüpunkte im Optionsmenü) |

Kurze Drücke zwischen zwei Takten gehen nicht verloren. Touch-Varianten werden später verglichen (offene Frage).

**Lebenszyklus:** Tab-Wechsel, Bildschirmsperre und Seitenwechsel halten Schleife und Ton an. Im Hochformat auf
Touch-Geräten zeigt der Kern „Bitte Gerät drehen“ und steht. Vollbild ist noch nicht eingebaut (optionales Extra).
