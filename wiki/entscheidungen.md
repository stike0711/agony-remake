# Entscheidungen

Stand: 06.10.2026

Architektur- und Designentscheidungen mit Begründung. Neue Entscheidungen unten anhängen; überholte nicht löschen,
sondern als „ersetzt durch E-xxx“ markieren.

Status: **gilt** · **vorgeschlagen** (noch nicht umgesetzt oder bestätigt) · **ersetzt**

---

### E-001 Neuimplementierung statt Emulator-Hülle
- Datum: 05.10.2026 · Status: gilt
- Das Spiel wird in TypeScript neu geschrieben. Ein Amiga-Emulator dient nur als Vergleichsreferenz.
- Begründung: Nur so sind Touch-Bedienung, Tablet-Darstellung und die modernen Features aus Phase 2 sauber möglich.
  Außerdem bräuchte eine Emulator-Hülle Kickstart-ROMs, die nicht weitergegeben werden dürfen.

### E-002 Der Original-Quellcode ist die maßgebliche Referenz
- Datum: 05.10.2026 · Status: gilt
- Verhalten, Werte und Datenformate werden aus Grolets Quellcode und den Spieldaten abgeleitet. Web-Angaben gelten
  nur, bis sie geprüft sind. Übernommene Werte bekommen einen Herkunftskommentar.

### E-003 Zielplattform Browser auf Tablets
- Datum: 05.10.2026 · Status: gilt
- Primär iPadOS (Safari) und Android (Chrome), Touch, Querformat, Vollbild. Desktop-Browser unter Windows und Linux
  müssen ebenfalls funktionieren (Entwicklung, Tests).

### E-004 Technik-Stack
- Datum: 05.10.2026 · Status: gilt (umgesetzt am 06.10.2026 mit TypeScript 7, Vite 8, Vitest 5; Zusammensetzen der
  Ebenen im Kern statt im Shader, siehe E-026)
- TypeScript (strict) + Vite, keine Game-Engine. Rendering mit WebGL2: Grafiken bleiben indiziert, Paletten pro
  Rasterzeile im Shader (bildet Copper-Effekte direkt nach). Spiellogik in festen 50-Hz-Schritten, deterministisch,
  Rendering per `requestAnimationFrame`.
- Begründung: Die Amiga-Tricks (Paletten pro Zeile, Ebenen-Prioritäten) lassen sich mit einem eigenen,
  schlanken Renderer exakter nachbilden als mit einer Engine. Fester Takt und Determinismus erlauben Replays als
  Regressionstests.
- Wird mit Fahrplan-Schritt 5 umgesetzt und dann bestätigt oder angepasst. Ausführlich in
  [Architektur](architektur.md).

### E-005 Build-Ausgabe nach `server/`
- Datum: 05.10.2026 · Status: gilt
- Entscheidung des Nutzers: `server/` enthält das spielbare Spiel (`index.html` + Assets). Quellen liegen in `game/`;
  `npm run build` erzeugt `server/` jedes Mal komplett neu.

### E-006 Keine Versionskontrolle
- Datum: 05.10.2026 · Status: gilt
- Entscheidung des Nutzers: kein Git. Ausgleich: Vor größeren Umbauten oder Löschungen Sicherungskopien in
  `backup/` anlegen, mit Datum im Dateinamen (z. B. `backup/2026-10-06_CLAUDE.md`); Änderungen im
  [Verlauf](status.md#verlauf) festhalten.

### E-007 Datenquelle: Crack-Disketten plus Quellcode
- Datum: 05.10.2026 · Status: gilt
- Die drei ADFs (Crack „Crystal“) enthalten alle 15 Spieldateien und lassen sich vollständig entpacken. Sie sind die
  Datenquelle für Grafik, Wellen, Musik usw. Grolets `ag/`-Dateien dienen zum Vergleich. Rips, Screenshots und MP3s
  in `reference/agony/` sind nur Orientierung.

### E-008 Referenz-Emulator: vAmigaWeb im Browser
- Datum: 05.10.2026 · Status: gilt
- vAmigaWeb läuft lokal im Browser-Fenster der Entwicklungsumgebung. Claude kann es dort sehen und per JavaScript
  steuern: Joystick, Maus, Diskwechsel, Speicher lesen, Bildpuffer auslesen.
- Verworfene Alternativen:
  - WinUAE: sehr genau, aber ein Desktop-Programm, das Claude weder sehen noch bedienen kann. Für den Nutzer weiter
    eine gute Wahl zum Selberspielen.
  - Scripted Amiga Emulator (SAE): reines JavaScript, aber seit 2022 nicht mehr gepflegt.
  - Gehostetes vAmigaWeb im Internet: Version kann sich jederzeit ändern; lokale Dateien wären nur über Umwege
    ladbar.
- Lizenz GPL-3.0; wird nur lokal als Werkzeug genutzt, nicht mit dem Spiel ausgeliefert.

### E-009 Lokaler Emulator-Server
- Datum: 05.10.2026 · Status: gilt
- `tools/emulator/server.ts` (Node, ohne Abhängigkeiten) liefert vAmigaWeb, Disketten und Kickstart aus
  `reference/` aus. Er hört standardmäßig nur auf `127.0.0.1`; mit `--lan` ist er im Heimnetz erreichbar.
- Er setzt die Header für Cross-Origin-Isolation (`COOP`/`COEP`), damit vAmigaWeb `SharedArrayBuffer` nutzen kann.
- `POST /local/capture/<name>` speichert Bilder und Speicherabzüge in `work/captures/`.

### E-010 Werkzeug-Sprachen
- Datum: 05.10.2026 · Status: gilt
- Projektwerkzeuge bevorzugt in TypeScript (Node 24 führt `.ts` direkt aus). Python ist für schnelle Analysen
  erlaubt. ADF-Lister und PowerPacker-Entpacker liegen derzeit in Python vor (`tools/analysis/`); ob sie für die
  Asset-Pipeline nach TypeScript portiert werden, wird beim Aufbau der Pipeline entschieden.

### E-011 Zwischenergebnisse in `work/`
- Datum: 05.10.2026 · Status: gilt
- Ausgelesene Disketten (`work/adf/`), entpackte Spieldateien (`work/unpacked/`) und Emulator-Mitschnitte
  (`work/captures/`) liegen in `work/`. Alles dort lässt sich per Skript neu erzeugen und darf gelöscht werden.

### E-012 Wiki-Aufbau und Belegkennzeichnung
- Datum: 06.10.2026 · Status: gilt
- Struktur wie in `CLAUDE.md` vorgegeben, ergänzt um die Unterseiten in `wiki/original/`. Fakten über das Original
  werden gekennzeichnet: ✔ belegt, 🌐 nur Web-Recherche, ❓ Vermutung.

### E-013 `CLAUDE.md` nur mit Regeln, Struktur und Verweisen
- Datum: 06.10.2026 · Status: gilt
- Wunsch des Nutzers: Die `CLAUDE.md` wird bei jeder Sitzung komplett geladen; doppelte Inhalte würden mit der Zeit
  auseinanderlaufen. Deshalb steht das Wissen nur noch im Wiki, die `CLAUDE.md` enthält Grundregeln, Arbeitsweise,
  Kernfakten, technische Leitplanken, Struktur und Verweise.
- Die vorherige Fassung liegt in `backup/2026-10-06_CLAUDE.md`; ihr Inhalt ist vollständig ins Wiki übertragen.

### E-014 Plattformneutraler Code von Anfang an
- Datum: 06.10.2026 · Status: gilt
- Anlass: Der Nutzer plant zusätzlich eine native App für iPadOS, eventuell auch iOS (iPhone), sobald er einen Mac
  hat (voraussichtlich in ein bis zwei Monaten).
- Festlegung: Schichtenmodell mit plattformneutralem Kern (`core/` ohne DOM und Browser-APIs), Plattformdienste
  (Rendering, Audio, Eingabe, Speicher, Lebenszyklus, Anzeige) nur über Schnittstellen, nur relative Pfade, keine
  Pflicht-Abhängigkeit von Web-only-APIs. Bedienlayouts auch für das iPhone im Querformat. Details in
  [Architektur](architektur.md).

### E-015 Weg zur nativen App: Capacitor
- Datum: 06.10.2026 · Status: vorgeschlagen
- Den Web-Build mit Capacitor in eine iOS-App packen: eine Codebasis, WKWebView mit Safari-Engine, native
  Funktionen über Plugins. Capacitor 8 verlangt Xcode 26 (nur auf macOS).
- Alternative: vollständiger Nachbau in Swift (Metal/SpriteKit) – deutlich aufwendiger, doppelte Logik.
- Endgültige Entscheidung, wenn der Mac eingerichtet ist und das Web-Grundgerüst in der App getestet wurde.

### E-016 Werkzeuge laufen unter Windows, macOS und Linux
- Datum: 06.10.2026 · Status: gilt
- Weil künftig auch auf einem Mac entwickelt wird: Skripte ohne feste Laufwerkspfade, Pfade relativ zum
  Projektordner bzw. zum Skript. Zum Umgang mit `node_modules` siehe E-018.

### E-017 Ein Projektordner auf dem NAS für PC und Mac
- Datum: 06.10.2026 · Status: gilt
- Angabe des Nutzers: Der Projektordner liegt auf einem NAS; Windows-PC (Laufwerk `P:`) und Mac können gleichzeitig
  darauf zugreifen. Ein Abgleich zwischen den Rechnern entfällt.
- Folgen: dieselben Dateien nie gleichzeitig auf beiden Rechnern bearbeiten; UTF-8 und LF über `.editorconfig`;
  Dateinamen in exakter Schreibweise; keine symbolischen Links; Projektwissen ins Wiki statt in rechnerlokale
  Notizen. Details in [Setup](setup.md#zwei-rechner-ein-nas).

### E-018 `node_modules` auf dem gemeinsamen Ordner
- Datum: 06.10.2026 · Status: offen, Entscheidung sobald der Mac da ist
- Problem: npm installiert plattformabhängige Programme (z. B. esbuild, Rollup) nur für den Rechner, auf dem es
  läuft. Ein gemeinsames `node_modules` passt deshalb immer nur zu einem der beiden Rechner.
- Möglichkeiten:
  - A: Node-Werkzeuge immer nur auf einem Rechner benutzen und beim Wechsel `npm ci` ausführen. Einfach, aber kein
    gleichzeitiges Arbeiten mit Node auf beiden Rechnern.
  - B: pnpm mit `node-linker=hoisted` und `supportedArchitectures` für Windows x64 und macOS (arm64): Ein
    `node_modules` enthält die Programme für beide Rechner. Muss auf dem NAS getestet werden.
  - C: Der PC baut die Web-Fassung nach `server/`; der Mac führt nur Capacitor und Xcode aus und braucht dafür
    möglichst keine plattformabhängigen Pakete ❓.
- Bis zur Entscheidung gilt A. Solange es keinen Mac gibt, ist nichts zu tun.

### E-019 Original-Modus plus zuschaltbare Verbesserungen
- Datum: 06.10.2026 · Status: gilt (vom Nutzer bestätigt: „erst später zuschaltbar“)
- Phase 1 bildet das Original exakt nach, einschließlich seiner Fehler und Eigenheiten. Ausnahme sind Effekte, die
  auf heutiger Hardware nicht funktionieren (z. B. der 50-Hz-Flacker-Trick) – begründete Abweichung.
- Begründung: Nur so lassen sich Nachbau und Original per Replay vergleichen. Was „Fehler“ und was „Charakter“ ist,
  entscheidet der Nutzer später pro Punkt.
- Verbesserungen kommen nach Phase 1 als Optionen („Enhanced“), Fahrplan in [Enhanced-Fassung](enhanced.md).
- Ergänzt durch E-040 (08.10.2026): Die Enhanced-Fassung wird ein eigener, neuer Kern statt Schaltern im Original-Kern.

### E-020 Spiellogik mit Ganzzahl-Arithmetik
- Datum: 06.10.2026 · Status: gilt
- Der Kern rechnet wie das 68000-Original mit Ganzzahlen bzw. Festkomma, nicht mit Gleitkomma.
- Begründung: exakt reproduzierbar (Replays), originalgetreue Rundung, und portierbar auf Plattformen ohne
  Gleitkomma-Einheit (z. B. Game Boy Advance, siehe [Enhanced-Fassung](enhanced.md#game-boy-advance-idee)).

### E-021 Zweisprachig Deutsch/Englisch ab dem ersten Code
- Datum: 06.10.2026 · Status: gilt (Wunsch des Nutzers: „mindestens 2-sprachig DE/EN jetzt schon angehen“)
- Alle Texte über Schlüssel aus Sprachtabellen. Englisch = Originaltexte samt Original-Positionen (aus den
  Spieldaten erzeugt), Deutsch = handgepflegte Übersetzung in derselben Schrift, automatisch zentriert.
- Ä/Ö/Ü werden per Skript aus der Original-Schrift abgeleitet; ß als „SS“.
- Voreinstellung nach Gerätesprache. Gilt schon im Original-Modus: Übersetzen ist keine spielerische Veränderung.
- Details: [Architektur → Sprachen](architektur.md#sprachen), Textbestand: [Texte](texte.md).

### E-022 Sprachwahl über ein Optionsmenü
- Datum: 06.10.2026 · Status: gilt (vom Nutzer bestätigt: „Optionsmenü passt“)
- Empfehlung: Optionsmenü statt einzelnem Umschalter, weil es ohnehin gebraucht wird (später Steuerung, Ton,
  Enhanced-Schalter). Zunächst enthält es nur die Sprache.
- Erreichbar über ein kleines Symbol am Bildrand (Touch) bzw. eine Taste (Desktop). Gezeichnet im Spiel mit der
  Original-Schrift. Die Voreinstellung nach Gerätesprache sorgt dafür, dass die meisten das Menü nie brauchen.
- Begründete Abweichung vom Original (das kein Optionsmenü hat): nötig für Sprachwahl und Touch-Bedienung.

### E-023 Komma und Bindestrich für die deutschen Texte ergänzen
- Datum: 06.10.2026 · Status: gilt (vom Nutzer entschieden)
- Die Menüschrift hat kein Komma und keinen Bindestrich. Beide werden wie Ä/Ö/Ü per Skript im Stil der Schrift
  erzeugt (Komma aus dem Punkt mit Unterlänge, Bindestrich als Balken in Strichstärke) und nur in deutschen Texten
  benutzt. Die englischen Originaltexte bleiben unverändert.

### E-024 Bild-Wörter der Titelsequenz bleiben englisch
- Datum: 06.10.2026 · Status: gilt (vom Nutzer entschieden)
- „and“ und „Present“ in der Titelsequenz sind fertige Bilder in einer eigenen Schrift. Sie bleiben auch in der
  deutschen Fassung englisch, wie die Logos.

### E-025 Story-Seite und Ladebild: Mindestdauer, dann weiter per Feuer
- Datum: 06.10.2026 · Status: gilt (vom Nutzer bestätigt)
- Im Original stehen beide, solange von Diskette geladen wird (Crack-Fassung ≈ 26 s bzw. ≈ 88 s). Im Nachbau gibt
  es keine Ladezeit. Deshalb: eine kurze Mindestdauer, danach geht es per Feuer weiter. Begründete Abweichung
  (Ladezeiten entfallen). Mindestdauer festgelegt beim Bau der Bildschirme: **150 Bilder (3 s)** für beide, gezählt
  ab dem Erscheinen der Story-Seite bzw. ab dem Ende des Einblendens; danach zählt nur ein neuer Feuerdruck. Ausblenden
  und Musik-Ausblenden laufen danach genau wie im Original nach dem Laden.

### E-026 Bildausgabe: Der Kern setzt ein indiziertes Bild zusammen, der Renderer schlägt nur Farben nach
- Datum: 06.10.2026 · Status: gilt (Umsetzung im Web-Grundgerüst)
- Der Kern schreibt wie Denise ein **indiziertes Bild** (Farbindex je Pixel) plus eine **Palette pro Zeile** (wie
  der Copper, 32 Farbregister je Zeile, Extra-Halfbrite als Schalter). Ebenen, Sprites und Text setzt der Kern
  selbst zusammen; der WebGL2-Renderer schlägt nur die Farben nach und skaliert.
- Gründe: so bleibt alles im Kern deterministisch und ohne Browser prüfbar (Prüfsummen von Bild und Paletten in
  Replays, Pixelvergleiche mit Emulator-Speicherabzügen in Vitest). Der Renderer bleibt klein und lässt sich in einer
  nativen Fassung leicht ersetzen. Die CPU-Last ist gering (höchstens 704 × 560 Byte pro Bild).
- Weicht vom ursprünglichen Konzept ab („Ebenen setzt der Shader zusammen“). HD-Ebenen (Phase 2) brauchen später einen
  zusätzlichen Weg; das wird dann entschieden.
- Bildausschnitt: immer derselbe Teil des PAL-Bilds, horizontal ab DIW-Position `$71`, 352 Lowres-Pixel breit
  (Menü-Overscan), vertikal Rasterzeile 32 bis 311 (280 Zeilen). Hires verdoppelt die Breite, Interlace die
  Zeilenzahl; alle Modi erscheinen gleich groß. Interlace wird ohne Flimmern gezeigt (beide Halbbilder zugleich).
  Was ein Bildschirm davon mindestens zeigen muss, legt er als `view` fest; der Renderer passt diesen Teil in den
  sicheren Bereich ein.

### E-027 Ton: Paula-Modell im Kern, Klangerzeugung in der Plattform
- Datum: 06.10.2026 · Status: gilt (Umsetzung im Web-Grundgerüst)
- Der Kern schreibt Paula-Register wie das Original (`AUDxLC/LEN/PER/VOL`, `DMACON`). Ein Modell rechnet die
  Audio-DMA in Farbtakten mit und setzt wie die Hardware einen Audio-Interrupt beim Start und bei jedem Neuladen eines
  Blocks („Sample zu Ende“). Logik, die auf Ton wartet, bleibt damit deterministisch.
- Alle Registerzugriffe eines Takts gehen samt Taktlänge als Block an die Plattform. Deren Mixer bildet dieselbe DMA
  nach und erzeugt den Klang (Stereo wie beim Amiga: Kanal 0 + 3 links, 1 + 2 rechts). Er spielt jeden Block genau so
  lange, wie der Takt dauert; eine kurze Warteschlange (2 bis 6 Blöcke) gleicht Schwankungen aus.
- Web: Mixer im AudioWorklet; ohne AudioWorklet (z. B. per `http://` über die IP im Heimnetz, kein sicherer Kontext)
  läuft derselbe Mixer im Hauptthread (ScriptProcessorNode).
- ProTracker-Module und später Jeroen Tels Treiber laufen als Kern-Logik, die pro Takt Paula-Register schreibt, wie
  im Original im Bild-Interrupt. Es gibt also keine vorab gerenderten Audiodateien für die ProTracker-Musik.
- Noch nicht nachgebildet: Tiefpassfilter des A500 („LED-Filter“), Perioden unter 124.

### E-028 Startbildschirm „Zum Starten tippen“ vor der Titelsequenz
- Datum: 06.10.2026 · Status: gilt
- Browser und iOS geben Ton erst nach einer Nutzeraktion frei. Die Titelsequenz hat von Anfang an Ton, deshalb steht
  davor ein schwarzer Bildschirm mit „ZUM STARTEN TIPPEN“ bzw. „TAP TO START“ in der Menüschrift. Feuer, Taste oder
  Antippen startet. Unvermeidbare Abweichung vom Original.

### E-029 Taktlänge wie im Original (PAL-Farbtakte)
- Datum: 06.10.2026 · Status: gilt
- Ein Takt dauert so lange wie ein Bild des Originals: 313 Zeilen × 227 Farbtakte (≈ 49,92 Hz), bei Interlace im
  Wechsel 313 und 312 Zeilen (≈ 50,0 Hz im Mittel). Die Hauptschleife zählt die vergangene Zeit in Farbtakten. Damit
  laufen Spiellogik und Ton im selben Maß wie auf dem Amiga, und der Mixer muss nichts nachregeln.

### E-030 Paula-Zugriffe mit Zeitpunkt im Takt, CPU-Schreibzugriffe auf Sampledaten
- Datum: 06.10.2026 · Status: gilt (Umsetzung mit den Bildschirmen der Startsequenz)
- Ergänzt E-027. Jeder Eintrag im Paula-Protokoll trägt seinen Zeitpunkt (Farbtakte seit Beginn des Takts); der
  Mixer wendet ihn genau dann an. Normal ist das 0 (Code direkt nach dem Bild-Interrupt). Wartet das Original auf
  einen Audio-Interrupt oder eine Rasterzeile, rückt der Kern die Zeit dorthin vor (`Paula.seek`), und die folgenden
  Zugriffe geschehen in diesem Moment.
- Grund: Die Titelsequenz schaltet Samples ab, sobald sie einmal durchgelaufen sind (Interrupt mitten im Bild), und
  richtet ihren weiteren Ablauf danach aus. Mit Zeitpunkt endet jedes Sample wie im Original, und der Ablauf bleibt
  bildgenau (geprüft gegen den Emulator).
- Außerdem kann die CPU Sampledaten ändern (`Paula.poke`, Eintrag `REG_POKE`): `mt_init` löscht das erste Langwort
  jedes Samples (O-001), EFx kehrt Bytes um. Der Mixer bekommt beim Start eine Kopie des Sample-Speichers und
  übernimmt Änderungen zum Zeitpunkt des Eintrags; nach einem Zurücksetzen (Pause) gleicht die Plattform den Speicher
  neu ab.

### E-031 Zeichenzeiten des Menüs: gemessene Werte übernehmen
- Datum: 06.10.2026 · Status: gilt
- Im Original kosten Kopieren und Zeichnen einer Menüseite sichtbar Zeit (CPU-Kopierschleife, Blitter, Musik im
  Interrupt): „Text aus“ 6 Bilder, Seiten 0–11: 15, 14, 12, 11, 12, 14, 14, 19, 15, 13, 20, 17 Bilder,
  Highscore-Tabelle 21, Story-Seite 14. Erst danach schaltet die Copperliste um, und erst dann beginnt die Wartezeit.
- Der Nachbau zeichnet sofort, schaltet aber nach genau diesen Dauern um. Die Werte stammen aus Ablaufspuren des
  Emulators (zwei Läufe, je zwei Zyklen, identisch) und stehen als Konstanten in `core/screens/menu.ts`.
- Sie gelten auch für die deutschen Seiten, damit der Ablauf in beiden Sprachen gleich lang ist (im Original gibt es
  nur Englisch). Ein Nachrechnen der Zykluszeiten aus der Zahl der Blitter-Aufrufe wäre ungenauer.

### E-032 Level-Engine arbeitet auf den Originaldaten im Speichermodell (Copper, Blitter, Sprites)
- Datum: 06.10.2026 · Status: gilt (vom Nutzer bestätigt am 06.10.2026)
- Die Level nutzen die Hardware sehr direkt: Die CPU schreibt Farben und Zeiger in die Copperliste, die Copperliste
  springt mit `BPL2MOD = $502` zwischen verschränkten Planes, Kacheln werden geblittet, Sprite-Listen werden zur
  Laufzeit umgeschrieben und gemultiplext (Regen). Ein Nachbau mit eigenen Ebenen müsste jeden dieser Effekte
  einzeln nachbilden und würde leicht um Pixel oder Bilder abweichen.
- Lösung: Der Kern hat ein schlankes Modell der Grafik-Hardware (`core/amiga/`): 512 KB Speicher, Blitter
  (Minterm, Verschiebung, Masken, Modulo), Copper (MOVE/WAIT/Sprünge) und Bildaufbau (Bitplanes, Dual-Playfield,
  Scrollen, Sprites, Prioritäten) bis ins indizierte Bild (E-026). Der Spielcode wird von Hand aus Quelltext und
  Disassembly nach TypeScript übertragen (`core/level/`) und arbeitet auf den Originaladressen; die Pipeline liefert
  dafür Speicherblöcke (`manifest.memory`, ohne Programmcode und ohne Jeroen Tels Musik). Einzige Ausnahme: Im Block
  `game` stehen die Objekt-Routinen des Level-Moduls als Bytes mit drin, weil sie zwischen den Leveldaten liegen; sie
  werden nie ausgeführt.
- Abgrenzung zu „kein Emulator“: Es wird keine CPU emuliert; das Hardware-Modell bildet nur die Funktionen nach, die
  Agony benutzt, so wie das Paula-Modell (E-027) den Ton.
- Folge für Phase 2: Verbesserte Grafik (höhere Auflösung) setzt später am Bildaufbau an, nicht an den Daten.
- Ergebnis (07.10.2026): Level 1 bis „PRESS FIRE TO START“ stimmt ab dem dritten Bild pixelgenau mit dem Emulator
  überein (520 Bilder mit und ohne Joystick); Rechenzeit ≈ 1,3 ms je Bild.
- Zum Spielen braucht man die Disketten nicht: Wie bei der Startsequenz extrahiert die Pipeline beim Build und
  legt die Blöcke in den Build. Es ändert sich nur die Form der Daten (Speicherblöcke statt dekodierter Bilder), nicht
  die Rechtefrage beim Hosting.

### E-033 Levelstart: die zwei Bilder mit Datenmüll werden nicht nachgebildet
- Datum: 07.10.2026 · Status: gilt
- Im Original zeigen die ersten zwei Bilder eines Levels Speicher ab Adresse 0 als Bitplanes: Die Copperliste läuft
  schon, ihre Bitplane-Zeiger sind aber noch 0, bis die Hauptschleife sie zum ersten Mal setzt (Eigenheit O-008).
  Zu sehen ist für 40 ms ein buntes Rauschen aus Vektortabelle und Programmcode.
- Der Nachbau lädt keinen Programmcode in den Speicher (E-032). In diesen zwei Bildern zeigt er deshalb, was sein
  Speichermodell hergibt: den Farbverlauf des Himmels mit Regen, ohne Rauschen. Das Nachbilden würde verlangen,
  Programmcode als Bilddaten auszuliefern.
- Die Tests vergleichen diese zwei Bilder nur oberhalb des Spielfelds (bis Zeile `$40`), alle folgenden ganz.

### E-034 Hauptschleife im Level: Zeitbedarf als feste Aufteilung nach Messung
- Datum: 07.10.2026 · Status: gilt (bis zur ersten Angriffswelle geprüft), ergänzt um ein Zeitmodell für `Short_Phase`
- Die Hauptschleife läuft mit 25 Hz und braucht im Original länger als ein Bild (Blitter-Arbeit). Wann ihre
  Schreibzugriffe sichtbar werden, hängt davon ab, wo der Strahl gerade ist. Statt die Laufzeit von CPU und Blitter
  zu modellieren, teilt der Nachbau die Schleife nach der Ablaufspur auf: Copperlisten-Update vor dem nächsten Bild,
  Scrolling, Objekte und Statuszeile nach dem Aufbau des folgenden Bilds, Teil 2 (Gegnerschüsse, Seitenwechsel,
  Startanzeige) zwei Bilder nach Schleifenbeginn. So stimmen alle Bilder bis zum Spielbeginn.
- Offen: Mit Gegnern und Scrolling kann die Schleife länger dauern (im Original bis 3 Bilder; dann fällt der
  Sprite-Teil des Copper-Interrupts aus) und `Short_Phase` hängt von der Strahlposition ab. Das wird mit der
  Spiellogik gemessen und, wenn nötig, durch ein Zeitmodell aus Blitter-Wörtern ersetzt.
- Ergänzung (07.10.2026, Gegner): `Short_Phase` steuert Startliste, Palettenwechsel und Gegnerschüsse. Es ist
  gesetzt, wenn der Strahl bei SEARCH SHORT PHASE (`$147C`) nicht später steht als im vorigen Durchlauf (nur die
  unteren 8 Bit der Zeile). Zeitprofile per Haltepunkten im Emulator ([Setup](setup.md#zeitprofil)) ergeben das
  Zeitmodell (`game/src/core/level/timing.ts`, angepasst mit `tools/analysis/fit_loop_timing.py`):
  - Schleifenstart Zeile 275 (Median Farbtakt 103), Copperlisten-Update 476 bzw. 119 Farbtakte, vorderes Scrollen
    74/181/≈ 1.200/≈ 2.230 je nach Phase, hinteres Scrollen 2.264 + 54 je neu gezeichneter Kachel + 22 je Blit.
  - Blits kosten 2 (A+D, D) bzw. 4 (A+B+C+D) Takte je Wort wie im HRM. Blitter und CPU bekommen nur die Buszyklen,
    die der Bildaufbau übrig lässt; `Video.busUsed` zählt dafür je Zeile Bitplanes, Sprites, Copper, Refresh und
    Audio (Zeile 0: Kopf der Copperliste, 45–62 Statuszeile, ab 63 das Spielfeld mit 6 Planes).
  - Läuft die Arbeit über das Bildende, kommt der Vertical-Blank-Interrupt dazu, vor allem der Musiktreiber mit
    1.100–2.900 Farbtakten je nach Bild (E-035).
  - Ergebnis: mittlerer Fehler 0,4 Zeilen; 235 von 236 Entscheidungen wie im Original. Die eine Ausnahme liegt
    32 Farbtakte an einer Zeilengrenze und hat keine sichtbare Folge. Die Engine prüft im Bild des Schleifenstarts
    (Teil 1a) oder im nächsten (Teil 1b) – wie im Original.
- Ergänzung (07.10.2026): Beginnt der Objektteil im Folgebild nach Zeile 32 (Farbtakt 105), endet das Zurücksetzen
  des Arbeitsbilds erst nach dem Copper-Interrupt; ALIEN BANK CTRL übernimmt dann das schon verringerte `Front_Shift`
  und alle Gegner stehen ein Pixel weiter (O-010). Gemessen in 13 von 294 Durchläufen, nachgebildet über das
  Zeitmodell (`lateObjects`).
- Tests: Die Spiellogik prüfen sie mit den gemessenen Strahlpositionen (exakt wie im aufgenommenen Lauf), das Spiel
  selbst läuft mit dem Modell; ein eigener Test vergleicht die Entscheidungen des Modells mit den gemessenen. Mit
  vielen Gegnern endet Teil 1b im Original oft erst nach dem Folgebild; Variablen der Spielmechanik erscheinen in
  den Spuren dann ein Bild später (Tests vergleichen mit beiden Bildern).
- Ergänzung (07.10.2026, Tod und Routinen): Nach dem Tod beginnt die Schleife früher (Zeile 262 statt 275), weil
  der Copper-Interrupt ohne Eule kürzer läuft. Der Schleifenbeginn ergibt sich jetzt aus dem Interrupt: Beginn in
  Zeile 256, Farbtakt 132, Dauer nach seinen Teilen (Grundteil 1.142 Farbtakte, Eule 1.046, Gegnerschüsse 470,
  Regen 1.541, je Explosionsteil 75 …; angepasst an 1.536 Interrupts, mittlerer Fehler 50), dann 100 Takte bis
  `$AD8`. Über den ganzen Lauf (767 Durchläufe): mittlerer Fehler 0,43 Zeilen, 2 Entscheidungen anders als im
  Original. Teil 1b und Teil 2 siehe E-037.
- Offen: Läuft eine Schleife länger als zwei Bilder (Endgegner, viele Wellen), verschiebt sich der nächste
  Schleifenstart (E-037).

### E-035 Laufzeit des Musiktreibers als gemessene Tabelle
- Datum: 07.10.2026 · Status: gilt (bis die Frage nach Jeroen Tels Musik geklärt ist)
- Der Musiktreiber läuft im Vertical-Blank-Interrupt; seine Laufzeit (1.100–2.900 Farbtakte) entscheidet mit, wann
  die Hauptschleife SEARCH SHORT PHASE erreicht, und damit, wann Wellen starten. Sie hängt nur vom Musikstück ab
  (Zeilen und Noten), nicht vom Spielgeschehen (mit und ohne Dauerfeuer 584 von 589 Bildern gleich).
- Der Nachbau hat den Treiber nicht (Rechte, siehe CLAUDE.md). Deshalb steht die Laufzeit je Bild als Tabelle im
  Spiel: gemessen im Emulator (Haltepunkte vor und nach dem Aufruf), erzeugt von `tools/analysis/music_timing.py` nach
  `game/src/data/timing/music-sea.ts`. Reine Zeitwerte ohne Musikdaten; das Stück wiederholt sich nach 60 Bildern
  Vorlauf alle 3.528 Bilder, gespeichert sind Vorlauf und eine Periode (10,8 KB als Hex-Text).
- Alternativen: den Treiber nachbauen (dann ergäbe sich die Laufzeit aus seinem Ablauf) oder einen Mittelwert nehmen
  (1.116 Farbtakte; dann kippen in den schweren Bildern alle 18 Bilder Entscheidungen). Wird mit der Musikfrage neu
  bewertet. Für die Level 2–6 entsteht je Level eine eigene Tabelle.

### E-036 Spielende: Ladezeit des Menüs wird ersetzt
- Datum: 07.10.2026 · Status: gilt (vom Nutzer bestätigt, ergänzt um den Bedienhinweis aus E-039)
- Nach dem letzten Leben zeigt das Original „GAME OVER“, zählt `Quit_Delay` ab (50 Durchläufe, 100 Bilder) und
  verlässt das Level (EXIT LEVEL). Dann lädt es das Menü (`igt`); in der Crack-Fassung dauert das ≈ 65 s. Währenddessen
  steht das Level, nur der Copper-Interrupt läuft weiter (Regen, „GAME OVER“). Nach dem Laden blendet die Musik aus,
  50 Bilder später wird das Bild schwarz.
- Im Nachbau gibt es keine Ladezeit. Wie bei Story-Seite und Ladebild (E-025): 150 Bilder stehendes Level statt der
  Ladezeit, dann wie im Original 50 Bilder, dann das Menü. Ohne Feuer, denn auch das Original reagiert dort nicht.
- Die Highscore-Eingabe (das Original übergibt dem Menü dafür den Spielstand) folgt mit Fahrplan-Schritt 7.

### E-037 Teil 1b und Teil 2 an ihrer Rasterzeile (Zeitmodell mit Uhr)
- Datum: 07.10.2026 · Status: gilt
- Der Rest von Teil 1 (Objekte, Startliste und Bahnen, Paletten, Kollisionstest, Objekt-Routinen, Statuszeile,
  Statustext, Sounds) läuft im Original je nach Last vor oder nach dem Copper-Interrupt des Folgebilds und oft bis ins
  übernächste Bild (Zeitprofil: in 374 von 767 Durchläufen beginnt die Spielmechanik erst dort). Davon hängt ab, in
  welchem Bild der Interrupt einen Tod bemerkt, ob die Gegner `Front_Shift` vor oder nach dem Verringern lesen (O-010),
  welche Farbbänder eine neue Palette schon zeigen und wann die Statuszeile wechselt. Teil 2 (Gegnerschüsse) baut die
  Sprite-Liste mitten im sichtbaren Bild neu auf.
- Lösung: Das Bildmodell baut das Bild zeilenweise (`Video.beginFrame`, `renderLines`). Die Engine führt jeden Schritt
  aus, sobald das Bild bis zu seiner Rasterzeile aufgebaut ist; Schritte nach dem Copper-Interrupt laufen hinter dem
  sichtbaren Bild. Lage und Zeile liefert eine Zeitquelle (`LoopTiming`): im Spiel das Zeitmodell, in Tests die Messung
  aus dem Zeitprofil (`measured-timing.ts`), sodass Spiellogik und Zeitmodell getrennt prüfbar bleiben.
- Zeitmodell (`ModelTiming`): eine Uhr ab SEARCH SHORT PHASE, die jeder Schritt um seine gezählte Arbeit vorrückt
  (Blitter-Takte, Gegner, Teilbilder, Bahnen, Trefferrechtecke, Zeichen …; `stepWork`). Blitter-Arbeit verbraucht alle
  Buszyklen, die der Bildaufbau übrig lässt, Prozessorarbeit nur die freien geraden (Copper, Lowres-Bitplanes 5/6;
  `Video.busEven`); Copper-Interrupt und Vertical Blank mit Musiktreiber unterbrechen und kosten zusätzlich Arbeit.
  Konstanten angepasst mit `tools/analysis/fit_part1b_timing.py` (767 Durchläufe, Fehler je Schritt 16–268 Einheiten).
  Ob die Objekte vor oder nach dem Interrupt liegen, entscheidet wie bisher die gemessene Schwelle (Beginn nach
  Zeile 32/105 des Folgebilds).
- Vereinfachungen: Statuszeile und -text schreiben langsamer, als der Strahl die Zeilen abholt; beginnen sie während
  ihrer Anzeige (ab Zeile `$2D`), wirken sie erst im nächsten Bild. Die Palette wirkt je Farbband ab dessen Zeile in
  der Copperliste.
- Ergebnis (Lauf ohne Eingabe bis nach dem Spielende, 1.690 Bilder): mit gemessener Zeitlage pixelgenau bis auf
  W-015; mit dem Modell zusätzlich 2 Durchläufe mit 1 Pixel Versatz der Gegner (der Interrupt kam dort 10–13 Zeilen
  verspätet, weil ein langer Blit lief). Sichtbar unterschiedliche Lagen bei gemessener Strahlposition: 37 von
  rund 6.100, fast alle wenige Zeilen an einer Schwelle.
- Zweiter Lauf mit Dauerfeuer und Ausweichen (`level1_shoot`, 07.10.2026): Die Dauer des Copper-Interrupts ist jetzt
  über beide Läufe angepasst (`tools/analysis/fit_irq_timing.py`, ohne die verspätet beginnenden), mit eigenem Posten
  für einen neuen Schuss (Sound_Start, 145 Farbtakte); ohne ihn kippten 5 Entscheidungen von Short_Phase an der
  Bildgrenze. Ergebnis bis Bild 14568: mit gemessener Zeitlage pixelgenau bis auf W-015/W-017, mit dem Modell
  Spielzustand gleich, dazu 9 Durchläufe mit 1 Pixel Versatz der Gegner (W-018: die Schwelle für den Objektteil trennt
  bei Dauerfeuer nicht mehr sauber). Im Lauf ohne Eingabe fällt einer der beiden Versatz-Fälle weg.
- Schleifen über zwei Bilder hinaus (08.10.2026): Ab Bild 14566 im Lauf `level1_shoot` dauert ein Durchlauf von
  14568 Zeile 311 bis 14571 Zeile 38, danach beginnen die Durchläufe mitten im Bild. Die Engine kennt dafür die Lage
  `at` = 2 · k + Seite (k Bilder seit Schleifenstart, Seite vor/nach dessen Copper-Interrupt) und arbeitet die Stufen
  Teil 1b, Teil 2 und Warten (`$AD0`/`$34E8`) über beliebig viele Bilder ab; Teil 1a beginnt an der gemessenen bzw.
  gerechneten Zeile. Mit gemessener Zeitlage bis Bild 14792 pixelgenau bis auf W-017/W-019 und zweimal 1 Pixel.
- Offen: Gegnerschüsse im Einsatz (Teil 2 an seiner Zeile ist eingebaut, aber ungeprüft; in Level 1 schießt bis
  Bild 14792 kein Gegner), das Zeitmodell bei hoher Last (ab Bild 14567 im Lauf `level1_shoot`
  sagt es den überlangen Durchlauf eine Runde zu früh voraus; Ursache eingegrenzt auf den Objekt-Schritt bei großer
  Blitter-Last, W-021), die ungeklärten Fälle, in denen Teil 2 schon in Zeile 6 beginnt (5 von
  532, Warteschleife `$34F0` müsste bis Zeile 64 warten ❓).

### E-038 Arbeitsweise: Standardabläufe, kleine Sitzungen, „genau genug“
- Datum: 07.10.2026 · Status: gilt (vom Nutzer beschlossen)
- Anlass: Die taktgenaue Analyse von Level 1 war teuer (viele Schritte mit Effort „maximal“), die Abläufe wiederholen
  sich inzwischen. Ziel: weniger Tokens und schneller vorwärts, ohne dass etwas ausgelassen wird.
- Standardabläufe stehen im Wiki ([Arbeitsablauf](arbeitsablauf.md)), nicht als Projekt-Skill: Das Wiki ist ohnehin
  der Einstieg jeder Sitzung, gilt auf beiden Rechnern und für spätere Sitzungen (native App, Game Boy Advance)
  genauso; CLAUDE.md verweist darauf.
- Sitzungen klein schneiden, ein Schritt je Sitzung, Übergabe über den Status. Effort im Regelfall „mittel“, „hoch“
  für Neues, „maximal“ nur selten.
- Genauigkeitsregel: Spielzustand und der Zeitpunkt spielrelevanter Ereignisse immer exakt; ein Versatz um 1 Pixel in
  einzelnen Bildern ohne Folgen (wie die 2 von 767 Durchläufen in E-037) wird toleriert, notiert und nicht weiter
  verfolgt.

### E-039 Bedienhinweis „Feuer drücken“ statt ersetzter Ladezeiten
- Datum: 07.10.2026 · Status: gilt (umgesetzt am 07.10.2026)
- Wo der Nachbau Ladezeiten des Originals durch Wartezeiten ersetzt (Story-Seite, Ladebild, Ladepausen zwischen den
  Leveln, Spielende), wirkt das Spiel ohne Hinweis, als hinge es. Bewusste Abweichung schon in Phase 1: Nach einer
  kurzen Pause (≈ 1 s) blinkt am unteren Rand ein kurzer Hinweis („PRESS FIRE“ / „FEUER DRÜCKEN“) in der
  Originalschrift, über Sprachschlüssel (E-021). Gezählt wird nur ein neuer Feuerdruck (bzw. Tippen); wer beim Tod
  Feuer hält, überspringt nichts. Ohne Eingabe geht es wie bisher weiter (E-036) bzw. wartet wie bisher (E-025).
- Stellen, an denen das Original selbst auf Feuer wartet, bleiben unverändert. Geprüft ✔: Story-Seite (igt nach `$C9C`),
  Ladebild (`load_sea`, Interrupt `$61708` nur Musik) und Spielende (Quit_Delay, EXIT LEVEL) fragen kein Feuer ab
  ([Ablauf bis Level 1](original/startsequenz.md)); keine dieser Stellen fällt weg.
- Umsetzung: `Game.setPrompt` blinkt den Hinweis im Overlay (20 Bilder an, 20 aus, wie „PRESS FIRE TO START“ in
  Level 1), zwei Zeilen über dem unteren Rand des Ausschnitts, in der **auf 50 % verkleinerten Menüschrift**
  (`Font.downscaled`, je 2 × 2 Pixel ein Pixel; Nutzerwunsch: ein Extra-Hinweis, der nicht mit dem Bild konkurriert;
  25 % probiert, nicht lesbar). Feuer = neue Flanke von Feuer oder Antippen/Klick (`Game.tapped`).
  Story-Seite und Ladebild: Hinweis ab dem Ende der Mindestdauer (150 Bilder, E-025), denn erst dann zählt Feuer.
  Spielende: Hinweis 50 Bilder nach EXIT LEVEL; ein neuer Druck kürzt die 150 Ersatzbilder ab, die 50 Bilder des
  Originals (Ausblenden) laufen danach wie bisher. Ohne Eingabe unverändert. Ladepausen zwischen den Leveln folgen
  mit Level 2.
- Später im Optionsmenü abschaltbar ([Enhanced-Fassung](enhanced.md)).

### E-040 Enhanced-Fassung als Neubau auf Basis des fertigen Nachbaus
- Datum: 08.10.2026 · Status: gilt im Grundsatz (vom Nutzer gewünscht); Details zu Beginn von Phase 2
- Der originalgetreue Nachbau (Phase 1) bildet ein Stück Amiga-Hardware nach (Speicher, Blitter, Copper, Strahl,
  Taktzeiten). Das ist für Originaltreue nötig, aber schwer zu erweitern (60/120 Hz, freie Auflösung, neue Inhalte).
- Entscheidung: Nach Phase 1 wird der Nachbau „eingefroren“. Er bleibt Original-Modus und **Prüfstein**: Beide
  Fassungen laufen mit denselben Replays, verglichen wird der Spielzustand (Positionen, Energie, Punkte, Tode), nicht
  Pixel. Die Enhanced-Fassung ist ein neuer, sauber strukturierter Kern (Objekte statt Speicheradressen, Rendering
  ohne Hardware-Modell) und nutzt dieselben Daten aus der Pipeline und dieselbe Plattformschicht.
- Folgen: zwei Codebasen (Fehlerbehebungen im Original-Modus nur noch selten); Timing-Eigenheiten des Originals
  bildet der Neubau nur nach, wo sie das Spielgefühl prägen (je Punkt entscheiden). Daten und Spielregeln schon in
  Phase 1 sauber im Wiki und in der Pipeline festhalten, weil der Neubau darauf aufsetzt.
- Offen: Sprache des neuen Kerns. TypeScript reicht für Web und iPad (Capacitor); für Switch und andere Konsolen
  wäre ein Kern in C++ oder Rust (oder eine Engine mit Konsolen-Export) nötig, der Game Boy Advance braucht ohnehin
  einen eigenen Port in C/C++ ([Enhanced-Fassung](enhanced.md#e5--weitere-plattformen)).

### E-041 Git-Arbeitskopie für Cloud-Sessions
- Datum: 08.10.2026 · Status: gilt (vom Nutzer beschlossen)
- Anlass: Guthaben für Cloud-Sessions von Claude Code (Aktion, verfällt 04.11.2026), das nicht zum Wochenlimit
  zählt. Cloud-Sessions brauchen ein GitHub-Repo; das Projekt läuft bewusst ohne Git (NAS, zwei Rechner).
- Entscheidung: Das Projekt bleibt ohne Git. Daneben gibt es die Arbeitskopie `P:\agony-remake-git` mit dem privaten
  Repo `stike0711/agony-remake`; Abgleich in beide Richtungen mit `tools/repo/sync.ts` (Rückweg mit Sicherung). Inhalt
  auf Wunsch des Nutzers vollständig einschließlich `reference/` (ROMs, ADFs, Musik), weil privat; Aufnahmen gepackt.
- Geeignet für die Cloud: Arbeit am Code mit den vorhandenen Aufnahmen (Gegner-Routinen, Wiki, Werkzeuge). Neue
  Emulator-Aufnahmen nur am PC.
- Ablauf: [Setup](setup.md#git-arbeitskopie-für-cloud-sessions).

### E-042 Zaubermenü und Pause als Tasten des Originals
- Datum: 09.10.2026 · Status: gilt
- Das Abbild weicht im Tastatur-Interrupt des Levels vom Quelltext ab (sea $5CCC): Die Leertaste ($40) öffnet und
  schließt das Zaubermenü, P ($19) schaltet die Pause, M ($37) schaltet `Menu_Mode` (nur dann öffnet auch 30 Bilder
  gehaltenes Feuer das Menü; beim Spielstart aus), Esc ($45) bricht das Spiel ab.
- Lösung: Der Zauber-Knopf des Remakes (`BTN_SPELL`, schon wegen Dauerfeuer vorgesehen) wirkt im Level wie die
  Leertaste, der neue Knopf `BTN_PAUSE` wie P (Tastatur: P). Drücken und Loslassen lösen wie im Original je einen
  Tastatur-Interrupt mit KEY TEST aus, zu Beginn des Takts (im Original irgendwann zwischen zwei Bildern).
- Die offenen Punkte (Pause für Touch und Gamepad, Esc, M) hat der Nutzer am 09.10.2026 entschieden: E-043.

### E-043 Pause-Knopf, „Spiel beenden“ und Zaubermenü per Feuer als Option
- Datum: 09.10.2026 · Status: gilt (vom Nutzer beschlossen), umgesetzt 09.10.2026
- Ergänzt E-042 für Touch, Gamepad und die Tasten Esc/M des Originals:
  - **Pause:** Touch-Knopf klein oben in einer Ecke neben dem Optionsmenü, außerhalb der Daumenzonen; Gamepad über
    die Start-Taste; dazu pausiert das Spiel automatisch, wenn die App in den Hintergrund geht (Sichtbarkeit bzw.
    Lebenszyklus über die Plattformschicht). Alle Wege lösen denselben Knopf `BTN_PAUSE` aus (wie Taste P).
  - **Esc (Abbruch im Original):** als Eintrag „Spiel beenden“ im Optionsmenü, mit Rückfrage; wirkt im Level wie
    Esc im Original.
  - **M (`Menu_Mode` im Original):** als Option „Zaubermenü mit Feuer öffnen“ im Optionsmenü, Voreinstellung aus wie
    beim Spielstart des Originals; an = `Menu_Mode` gesetzt (gehaltenes Feuer öffnet nach 30 Bildern das Menü).
- Begründung: Das Verhalten des Originals bleibt vollständig erreichbar, ohne Tasten doppelt zu belegen; auf dem
  Tablet ist die automatische Pause beim Wechsel der App nötig.
- Texte über Sprachschlüssel (E-021), Deutsch und Englisch.
- Umsetzung (09.10.2026): Pause-Knopf `#pause-button` links neben dem Zahnrad (nur Touch), Gamepad Start = `BTN_PAUSE`
  (Select bleibt Optionsmenü); `Game.pause()` beim Wechsel in den Hintergrund löst im Level Taste P nur aus, wenn noch
  keine Pause läuft (P schaltet sonst um) – während „LET'S GO“ und beim Tod ignoriert das Original P, dann bleibt das
  Level ungepaust. Optionsmenü: „FEUERMENÜ: AN/AUS“ (Einstellung `spellFire`, gespeichert; der Level-Bildschirm
  schreibt sie beim Start und bei jeder Änderung nach `Menu_Mode`), „SPIEL BEENDEN“ nur im Level, zweimal wählen
  (Rückfrage), dann Taste Esc des Originals. Kern-Tests `test/controls.test.ts`.
