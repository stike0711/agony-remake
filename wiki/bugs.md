# Bugs

Stand: 07.10.2026

## Nachbau

Offen: B-001. Beim Aufbau des Web-Grundgerüsts (06.10.2026) gefundene und sofort behobene Fehler: Bild stand
im Renderer auf dem Kopf (Zeilen doppelt gespiegelt); negative Zeitdifferenz in der Hauptschleife (jetzt auf ≥ 0
begrenzt); `setPointerCapture` warf bei Touch eine Ausnahme (entfernt, Touch erfasst ohnehin implizit).

Beim Bau der Startsequenz (06.10.2026) fielen beim Abgleich mit dem Emulator auf und wurden behoben: Der Bild-Interrupt
der Titelsequenz lief ein Bild zu spät an (Zähler für Klangteppich und Lautstärke um ein Bild verschoben); ein
eigener Vergleichsfehler (×17 statt ×16 beim Speichern der Nachbau-Bilder) täuschte Farbabweichungen vor.

Beim Bau der Level-Engine (07.10.2026) gefunden und behoben: Stand die Eule am unteren Rand, lief das Sprite-Ende
über Zeile 255 hinaus (VSTOP hat 8 Bit und wird dann kleiner als VSTART); das Hardware-Modell schaltete solche
Sprites nie ein, auf der Hardware bleiben sie bis zum Bildende an. Außerdem lief die Engine nach dem Feuer bei
„PRESS FIRE TO START“ im selben Takt weiter in noch nicht übertragene Teile. Beides ist jetzt durch Tests abgedeckt
(`level1.test.ts`, Aufnahme mit der Eule am Rand).

### B-001 Flacker-Trick bei 60/120 Hz ungleichmäßig
- Status: offen
- Gefunden: 07.10.2026, beim Aufbau der Level-Engine
- Die Copperliste wechselt in jedem Bild zwischen zwei Hälften mit leicht verschiedenen Farbverläufen (Flacker-Trick).
  Bei 50 Hz mischt das Auge beide. Auf 60/120-Hz-Displays zeigt der Renderer manche Bilder doppelt; die Abwechslung
  wird dadurch unregelmäßig und kann schimmern.
- Lösung geplant (siehe [Architektur → Darstellung](architektur.md#darstellung)): auf solchen Displays die Mischfarbe
  beider Hälften zeigen; braucht eine begründete Abweichung, sobald es auf echten Geräten geprüft ist.

Vorlage für neue Einträge:

```
### B-001 Kurztitel
- Status: offen | erledigt (Datum)
- Gefunden: Datum, wo/wie
- Beschreibung, Schritte zum Nachstellen
- Ursache / Lösung
```

## Werkzeuge

### W-001 Bilder aus dem WebGL-Canvas sind schwarz
- Status: umgangen (05.10.2026)
- `canvas.toBlob()` auf dem vAmigaWeb-Canvas liefert nur ein schwarzes Bild, weil WebGL den Zeichenpuffer nach
  dem Anzeigen verwirft.
- Lösung: den Bildpuffer des Emulators direkt lesen (`Module._wasm_pixel_buffer()`), siehe
  [Setup](setup.md#bilder-und-speicher-abgreifen).

### W-002 `pp20.py` brach bei Unterordnern ab
- Status: erledigt (06.10.2026)
- Der Entpacker versuchte, den Ordner `s/` als Datei zu öffnen. Er überspringt jetzt alles, was keine Datei ist.

### W-003 Emulator nicht im A500-Zustand
- Status: erledigt (06.10.2026)
- vAmigaWeb startete mit 2 MB Chip-RAM, 2 MB Fast-RAM und ECS-Chipsatz. Jetzt auf A500 mit OCS (512 KB Chip +
  512 KB Slow) umgestellt; die Einstellung bleibt im Browser gespeichert, siehe [Setup](setup.md#hardware-konfiguration).

### W-005 Emulator-Farben sind nicht exakt ×16
- Status: gelöst (06.10.2026), beim Vergleichen berücksichtigen
- vAmiga gibt einen 4-Bit-Farbwert als Wert × 16 aus (nicht × 17), rechnet aber über ein Farbmodell, sodass
  einzelne Kanäle um 1 darunter liegen, z. B. `$98B` → `90 7F AF` statt `90 80 B0`. Mit Abschneiden (`v >> 4`)
  ergab das scheinbar falsche Farben.
- Lösung: Emulatorwerte **runden**, `(v + 8) >> 4`. Damit stimmen alle bisher geprüften Bilder (Menü, Ladebild,
  sechs Titelbildschirme) zu 100 % überein. `tools/analysis/compare_capture.py` rechnet so.

### W-006 Ausgeblendeter Browser-Bereich hält den Emulator an
- Status: umgangen (06.10.2026)
- vAmigaWeb rechnet im Takt von `requestAnimationFrame`; ist der Browser-Bereich ausgeblendet, steht der Emulator.
- Lösung: schrittweises Ausführen per `AG.step(n)` (`Module._wasm_execute_one_frame()`), unabhängig von der
  Sichtbarkeit und bildgenau reproduzierbar.

### W-007 PNG-Erzeugung im Browser ist langsam
- Status: umgangen (06.10.2026)
- Bei ausgeblendetem Tab braucht `convertToBlob` rund 1 s pro Bild, und lange Aufnahmen überschreiten das
  45-Sekunden-Limit des JavaScript-Werkzeugs.
- Lösung: `AG.recordRaw` sammelt Rohbilder und speichert sie gebündelt; `tools/analysis/raw_frames.py` macht daraus
  PNGs und Übersichtstafeln.

### W-008 Letzte Rasterzeile in Aufnahmen schwarz
- Status: bekannt
- Die unterste Zeile des PAL-Rasters (Zeile 312) ist in den Aufnahmen teilweise schwarz. Bei Vergleichen ignorieren.

### W-004 Konsolenmeldung „Failed to load resource: net::ERR_FAILED“
- Status: offen, harmlos
- Erscheint beim Start von vAmigaWeb. Vermutlich eine Ressource aus dem nicht heruntergeladenen Ordner `doc/`.
  Ohne Einfluss auf den Emulator.

### W-009 Python-Skripte brachen in der Windows-Konsole ab
- Status: erledigt (06.10.2026)
- Ausgaben mit Zeichen wie „→“ führten in Git-Bash (Codepage cp1252) zu `UnicodeEncodeError`.
- Lösung: Alle Skripte in `tools/analysis/` stellen die Ausgabe auf UTF-8 um (`sys.stdout.reconfigure`). Für
  Einzeiler `PYTHONIOENCODING=utf-8` setzen.

### W-010 Schnappschuss direkt nach dem Seitenaufruf lädt nicht
- Status: umgangen (06.10.2026)
- Ein `AG.restore` unmittelbar nach dem Öffnen von `/agony` wurde vom Kaltstart des Emulators überschrieben.
- Lösung: erst warten, bis der Emulator läuft (z. B. ein paar Bilder ausführen), dann laden. Nach dem Laden zieht der
  Bildzähler erst nach 2 Schritten nach.

### W-011 Vite bemerkt Änderungen auf dem NAS nicht
- Status: erledigt (06.10.2026)
- Der Dev-Server lieferte nach dem Bearbeiten weiter die alte Fassung einer Datei aus; Änderungsmeldungen kommen über
  das Netzlaufwerk nicht an.
- Lösung: `server.watch.usePolling` in `game/vite.config.ts` (Intervall 300 ms).

### W-012 Im verborgenen Vorschau-Fenster läuft keine Bildschleife
- Status: umgangen (06.10.2026)
- Ist der Browser-Bereich der Claude-App nicht sichtbar, ruft der Browser `requestAnimationFrame` und
  `ResizeObserver` nicht auf (vgl. W-006). Das Spiel steht dann, und Größenänderungen kommen nicht an.
- Lösung: zum Prüfen die Schleife per Skript antreiben (`agony.loop.frame(t)`, siehe [Setup](setup.md#web-app)).
  Der Renderer prüft die Canvas-Größe zusätzlich bei jedem Zeichnen.

### W-013 Lange Skriptaufrufe setzen den Emulator zurück
- Status: umgangen (06.10.2026)
- Ein einzelner `javascript_tool`-Aufruf, der ≈ 9.000 Emulator-Bilder am Stück ausführte, brach mit „Internal error“ ab;
  danach lief der Emulator ab Bild 0 neu (Kaltstart), und die Bilder kurz davor waren unbrauchbar (Musik hing).
- Lösung: in Abschnitten von höchstens etwa 2.000 Bildern ausführen ([Setup](setup.md#hilfsfunktionen-für-aufnahmen-ag)).

### W-014 Haltepunkte: Eingaben und Schnappschuss
- Status: umgangen (07.10.2026)
- Mit einem Haltepunkt am Einstieg des Level-3-Interrupts (`$4392`, Zeile 0) kamen Joystick-Eingaben nicht im
  Spiel an (Feuer startete das Level nicht). Außerdem greift ein geladener Schnappschuss erst beim nächsten
  ausgeführten Bild; `frameNr()` zeigt bis dahin noch das alte Bild.
- Lösung: `AG.profile` lädt den Schnappschuss, führt zwei Bilder aus und setzt erst dann die Haltepunkte; keinen
  Haltepunkt auf den Interrupt-Einstieg legen. Ein Lauf mit Haltepunkten weicht in 25 von 394 Messungen um eine Zeile
  vom Lauf ohne ab.

### W-015 Bildmodell: Farbwechsel mitten in der Zeile
- Status: offen (bekannte Abweichung, im Test aufgeführt)
- Gefunden: 07.10.2026, Lauf `level1_go` Bild 14538–14549
- An jeder Bandgrenze des vorderen Playfields setzt die Copperliste Farbe 7 erst nach `WAIT h=$42`; durch den
  Bitplane-Abruf verzögert wirkt das im Original etwa 50 Pixel nach dem linken Rand. Das Bildmodell kennt eine Palette
  je Zeile und setzt die Farbe für die ganze Zeile. Sichtbar nur, wo links an der Grenze Farbe 7 liegt und sich die
  Bänder darin unterscheiden (im Testlauf 10 Bilder mit 2–6 Pixeln).
- Lösung möglich mit Farbwechseln innerhalb der Zeile im Kern (Anzeige mit mehr als 32 Farben je Zeile).

### W-016 Zeitprofile: Strahlposition und doppelte Treffer
- Status: umgangen (07.10.2026)
- Bei Farbtakt 0 und 1 meldet vAmiga in `VHPOSR` noch die vorige Zeile; an der Bildgrenze trägt ein Treffer teils
  noch die alte Bildnummer (er läge dann vor seinem Vorgänger). Kommt genau an einem Haltepunkt ein Interrupt an,
  meldet vAmiga den Haltepunkt davor und danach.
- Lösung: `Profile` (`game/test/load-profile.ts`) und `tools/analysis/profile_hits.py` korrigieren beim Laden (Zeile + 1
  bei Farbtakt ≤ 1, Bild + 1, wenn ein Treffer vor seinem Vorgänger läge); je Durchlauf zählt der letzte Treffer eines
  Haltepunkts. Haltepunkte setzt `AG.setBreakpoints` jetzt in einem Bild (vorher eines je Haltepunkt, dann fehlten die
  ersten Treffer).

### W-017 Bildmodell: Strahl überholt das Zeichnen der Punkte
- Status: toleriert (Genauigkeitsregel, im Test aufgeführt)
- Gefunden: 07.10.2026, Lauf `level1_shoot` Bild 13295, 13779, 13787 (7–11 Pixel)
- Beginnt der Schritt Statuszeile in Zeile 39/40, also kurz vor dem Statusfenster (Zeile $2D), überholt der Strahl das
  Zeichnen der Ziffern: Von einer Ziffer erscheinen im Original die obersten 2–3 Zeilen erst im nächsten Bild. Der
  Nachbau führt den Schritt als Ganzes aus (`renderLine` in `engine.ts` behandelt nur den Beginn im Fenster).
- Lösung möglich: das Zeichnen Zeichen für Zeichen mit der Zeit je Zeichen (`STATUS_PER_CHAR`) an den Strahl koppeln.

### W-018 Zeitmodell: Objektteil vor oder nach dem Copper-Interrupt
- Status: toleriert (Genauigkeitsregel, im Test aufgeführt)
- Gefunden: 07.10.2026, Lauf `level1_shoot`: 9 von 727 Durchläufen (je 2 Bilder mit Gegnern 1 Pixel versetzt, O-010)
- Ob das Zurücksetzen des Arbeitsbilds vor dem Copper-Interrupt fertig wird, entscheidet das Modell mit einer festen
  Schwelle für den Beginn des Objektteils (Zeile 32, Farbtakt 105, aus `level1_go`). Im Lauf mit Dauerfeuer überlappen
  „früh“ und „spät“ zwischen Zeile 30,8 und 33,4; auch die gerechnete Bus-Belegung trennt sie nicht (51 Fehler). Die
  Dauer des Zurücksetzens selbst ist in beiden Läufen gleich (22.857 bzw. 22.929 freie Buszyklen).
- Vermutete Ursache: Audio-Interrupts der Soundeffekte (Int4, `$5BD0`), die während des Zurücksetzens den Start der
  nächsten Blits verzögern; bei Dauerfeuer läuft ständig das Schussgeräusch. Wieder aufnehmen mit dem Ton im Level
  (Abspielen der Effekte über Paula samt Int4).
- Ohne Folgen für den Spielzustand (Variablen je Bild gleich).

### W-019 Spinne mit versetzten Bitplanes im überlangen Durchlauf
- Status: toleriert (Genauigkeitsregel, im Test aufgeführt), Ursache offen
- Gefunden: 08.10.2026, Lauf `level1_shoot`, Bild 14598 (4.116 Pixel, nur dieses Bild)
- Der Durchlauf beginnt dort in Zeile 63 bzw. 158 an einer Bandgrenze; im Original erscheint eine Spinne mit
  gegeneinander versetzten Bitplanes (ein Teil der Blits liegt schon im neuen, ein Teil noch im alten Arbeitsbild).
  Zwei Versuche (Zeile 63 erst nach Teil 1a aufbauen, Zeiger nur teilweise neu) machten es schlechter.
- Ohne Folgen für den Spielzustand; ab dem nächsten Bild wieder gleich.

### W-020 Zwischenwert von Front_Shift beim Schleifenstart am Bildende
- Status: toleriert im Variablenvergleich (`run()` in `level1.test.ts`)
- Beginnt ein Durchlauf im Original erst in Zeile 311, verringern Copper-Interrupt und Teil 1a `Front_Shift` erst im
  nächsten Bild; der Nachbau steht am Bildende schon auf dem Wert dazwischen (Bilder 14569, 14611). Die Spur liest
  nur einmal je Bild, die Bilder stimmen.

### W-021 Zeitmodell: Objekt-Schritt unter hoher Blitter-Last zu lang
- Status: offen (begrenzt die Modelltests im Lauf `level1_shoot` auf Bild 14566, `SHOOT_MODEL_LAST`)
- Gefunden: 08.10.2026, Lauf `level1_shoot` ab Bild 14535. Die Spinne steht dort weiter im Bild als in `level1_go`
  (dasselbe Bild 14563: 22.152 statt 9.900 Blitter-Takte im Objekt-Schritt bei gleichen 4 Gegnern und 24 Teilbildern),
  dazu Regen (Copper-Interrupt 4.400 statt 2.500 Farbtakte). Im Original ist der Objekt-Schritt ($153C → $29D2) dann
  rund 500 Arbeitseinheiten (freie Buszyklen) kürzer, als die lineare Anpassung rechnet; die Modelluhr liegt danach
  rund 10 Zeilen zu spät. Teil 2 landet in 14561/14565 hinter dem Copper-Interrupt, im freien Lauf kommt der überlange
  Durchlauf ab 14567 eine Runde zu früh (Variablen weichen ab). Short_Phase stimmt mit gemessener Zeitlage bis 14792.
- Geprüft und verworfen (je Anpassung über beide Läufe, 1.607 Durchläufe):
  - Dauer des Copper-Interrupts: im Modell richtig (4.444 statt gemessen 4.400–4.670).
  - Art der Blits: alle Objekt-Blits nutzen A+B+C+D (4 Takte je Wort); eigene Faktoren je Kanalkombination ändern nichts.
  - Größe der Blits (Takte², mittlere Blit-Größe × Interrupt) und Überlappung von Prozessor und Blitter
    (Blits × min(mittlerer Blit, C)): Rest im Bereich höchstens von 520 auf 280 Einheiten, Gesamtfehler kaum besser.
  - Sprite-DMA (Regen, Schüsse; im Bereich 1.152 statt sonst 244 Zyklen je Schritt) nur anteilig als belegt zählen:
    erklärt rund 20 %, Gesamtfehler bei mehr als 30 % schlechter.
  - Gemeinsame Anpassung aller Schritte über beide Läufe (`fit_part1b_timing.py --run level1_go --run level1_shoot`):
    `level1_go` wird schlechter (56 statt höchstens 40 sichtbar falsche Lagen), der Rest im Bereich bleibt.
- Nächster Ansatz: im Emulator je Blit messen (Haltepunkte an BLTSIZE-Schreibzugriffen und WaitBlit im Objektteil),
  ob der Prozessor zwischen den Blits wartet oder parallel rechnet und wie viele Buszyklen ein A+B+C+D-Blit unter
  Bitplane- und Sprite-DMA tatsächlich braucht. Neuer Hardware-Zeiteffekt, Effort „maximal“ (arbeitsablauf.md).

### W-022 Gegner-Routinen von Level 1 ungeprüft
- Status: offen (wartet auf eine Aufnahme über Bild 14.792 hinaus, status.md)
- Seit 08.10.2026: `R_Transporteur`, `R_Tir_Etoile`, `R_Spectre`, `R_Rapide`, `R_Bomber`, `R_Volant_Grossi`,
  `R_Jumper`, `R_Volant_Missile` und `R_Final` sind aus dem Quelltext übertragen und gegen die Disassembly des Abbilds
  abgeglichen, aber nicht gegen den Emulator geprüft. Abgesichert nur durch Kern-Tests mit Werten aus dem Quelltext
  (`test/routines.test.ts`). Nicht im Test: Zusammenspiel mit Kollisionen, Explosionen, Gegnerschüssen und Paletten,
  Zeitlage.

### W-023 Bonus ungeprüft
- Status: offen (wartet auf eine Aufnahme über Bild 14.792 hinaus, status.md „Für den PC“)
- Seit 08.10.2026: BONUS (`$56BA`) aus dem Quelltext übertragen, gegen die Disassembly abgeglichen, Kern-Test
  `test/bonus.test.ts`. Ungeprüft gegen den Emulator; im Zeitmodell fehlt die Dauer des Bonus-Teils im
  Copper-Interrupt.

## Eigenheiten und Fehler des Originals

Grundsatz in Phase 1: originalgetreu, also nachbilden. Beheben erst als zuschaltbare Option (E1, siehe
[Enhanced-Fassung](enhanced.md)).

### Aus Code und Daten belegt ✔

- BONUS schreibt beim Schließen `Empty_Spr` nach `Spr6pt(D)`/`Spr7pt(D)`, also nach a5 + `$138`/`$13C` in den
  Speicher statt in die Custom-Register SPR6PT/SPR7PT (`$DFF138`); nachgebildet (`interrupt.ts`, 08.10.2026).
| Nr. | Wo | Eigenheit | Sichtbar/hörbar | Phase 1 |
|---|---|---|---|---|
| O-001 | Ladebilder (`load_sea`, `…marshes`, `…mountains`, `…highlands`) | `mt_init` des ProTracker-Abspielers löscht das erste Langwort hinter dem Modul = die ersten 4 Byte des Bilds | ja, wenige Pixel oben links in der ersten Bildzeile | nachgebildet (Pipeline wendet den Effekt aufs Bild an; im Sample-Speicher löscht der Abspieler selbst) |
| O-002 | Menü (`igt`) | Kopierschleife kopiert 12 Byte zu wenig (Bildzeile 289, Plane 6) | nein (außerhalb des PAL-Bilds) | entfällt |
| O-003 | Menü-Schrift | nur 20 von 21 Glyphenzeilen werden geblittet; die unterste Zeile von `Q`, `(`, `)` fehlt | ja, minimal (`Q` in „QUALITY“) | nachbilden |
| O-004 | Titelsequenz | Einblenden schreibt 17 statt 16 Farben (in `COLOR16` und den Bildzähler) | nein | entfällt |
| O-005 | Titelsequenz, Agony-Logo | Der Code wartet auf den Interrupt von Kanal 2 statt 3; das Echo auf Kanal 3 wird abgeschnitten | ja, hörbar | nachgebildet |
| O-006 | ProTracker-Abspieler (Menü, Ladebilder) | Eigenheiten des ProTracker-2.x-Abspielers: 9xx doppelt, Tremolo-Rampe nach Vibrato-Position, SetTonePorta mit 37er-Zeilen, LowMask anfangs 0 ([Audio](original/audio.md#protracker-abspieler-menü-und-ladebilder)) | nein (die Module nutzen die Effekte nicht) | nachgebildet |
| O-007 | Menü (`igt`) | Feuer wird als Zustand abgefragt: Wer beim Start des Menüs Feuer hält, springt sofort zur Story-Seite, auch mitten im Einblenden | ja | nachgebildet |
| O-008 | Levelstart (Level 1 belegt, vermutlich alle) | Die ersten zwei Bilder zeigen Speicher ab Adresse 0 als Bitplanes, weil die Copperliste schon läuft, bevor die Hauptschleife die Zeiger setzt | ja, 40 ms buntes Rauschen | nicht nachgebildet (E-033): an der Stelle Farbverlauf mit Regen |
| O-009 | Level, Äxte | Ausgeschaltete Äxte laufen trotzdem mit: Position und Sprite-Steuerwörter werden in jedem Bild berechnet (x = 0, also unsichtbar) | nein | nachgebildet |
| O-010 | Level, Gegner | In langen Durchläufen der Hauptschleife kopiert ALIEN BANK CTRL `Front_Shift` erst nach dem Copper-Interrupt, der es schon verringert hat: alle Gegner dieses Durchlaufs stehen ein Pixel weiter | ja, kaum (1 Pixel für 2 Bilder) | nachgebildet (Zeitmodell, E-034) |
| O-011 | Level, Gegner | Die Schuss-Zähler (`F_Rt_D`) laufen auch bei Gegnern ohne Schuss: Rate `$FF` heißt „alle 255 Durchläufe ein Schuss“ (≈ 20 s), nicht „nie“ | ja, bei langlebigen Gegnern | nachgebildet |
| O-013 | Level, Spielende | CLEAN UP soll alle Objekt-Routinen beenden, löscht aber nur 32 Langwörter der `Rout_Struct` (Einträge à 28 Byte): Routinen ab Platz 5 laufen weiter | nur mit mehr als 4 Routinen beim Spielende | nachgebildet |
| O-014 | Level, Tod der Eule | Die 8 Teile der Explosion liegen als Sprite-Listen hintereinander; nach seinem Teil liest jeder Sprite-Kanal die Steuerwörter des nächsten. Teile erscheinen so zusätzlich in den Farben eines anderen Kanals, und ein Teil, dessen Startzeile durch den 8-Bit-Überlauf vor der Sprite-DMA liegt, holt in seiner Endzeile die Steuerwörter des nächsten (auch die Eule darunter verschwindet dann vorzeitig) | ja, während der Explosion | nachgebildet (Sprite-DMA des Bildmodells) |
| O-012 | Level, Bahnen | Ein neuer Gegner auf einer relativen Bahn schiebt den Lesezeiger der Bahntabelle um ein Wort weiter, auch für die Gegner danach in derselben Schleife (er steht aber immer am Ende der Liste) | nein | nachgebildet |

Details: [Dateiformate](dateiformate.md) und [Ablauf bis Level 1](original/startsequenz.md).

### Aus Rezensionen 🌐

Vor dem Nachbau im Code prüfen.

- 🌐 Ein Ton der Titelmusik (Menümodul „mod.agony intro“) liegt in der falschen Oktave. Grund: Bessere
  Klavier-Samples ließen sich auf dem Amiga nicht weit genug transponieren.
- 🌐 Einige Gegner haben große Farbflächen in Hintergrundfarbe und sind dadurch schlecht zu sehen.
- 🌐 Gelegentliches Flackern bzw. Blinken von Gegnern und Geschossen.
- 🌐 Der Flacker-Trick bei den Farbverläufen sieht in Emulatoren und auf Screenshots schlecht aus; auf modernen
  Displays durch die Mischfarbe ersetzen (siehe [Grafik](original/grafik.md)).
- 🌐 Die Trefferzone der Eule ist wegen der schlagenden Flügel schwer einzuschätzen.
