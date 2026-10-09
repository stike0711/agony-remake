# Texte und Übersetzungen (Englisch/Deutsch)

Stand: 07.10.2026

Das Spiel ist ab dem ersten Code zweisprachig (Entscheidung E-021). **Englisch = Originaltexte**, unverändert und an
den Original-Positionen. **Deutsch = Übersetzung**, in derselben Schrift, Zeilen automatisch zentriert. Die
deutschen Texte unten sind Entwürfe ❓ und sollen vor dem Einbau vom Nutzer gegengelesen werden.

Quelle der Originaltexte: Texttabellen in `igt` und `ending` (Kodierung siehe
[Dateiformate](dateiformate.md#texttabelle)) sowie die Statuszeile von Level 1 (Emulator-Aufnahme).

## Schrift und Sonderzeichen

- Die Schrift des Menüs (Format und Zeichenverfahren in
  [Dateiformate](dateiformate.md#schrift-des-menüs)) hat genau diese Zeichen ✔: **A–Z, 0–9, `.` `:` `(` `)`**, einen
  Pfeil `◄` (Löschen bei der Namenseingabe) und das Leerzeichen. Es fehlen Komma, Bindestrich, `!`, `?` und
  Umlaute.
- Für Deutsch fehlen **Ä, Ö, Ü**. Sie werden per Skript aus A, O, U plus zwei Punkten im Stil der Schrift erzeugt
  (reproduzierbar, kein Handzeichnen); Breite wie A, O, U. ß wird in Großschrift als „SS“ geschrieben.
- Komma und Bindestrich werden wie die Umlaute per Skript im Stil der Schrift ergänzt (E-023), nur für Deutsch.
  Umgesetzt in der Asset-Pipeline (`tools/pipeline/extract/startsequence.ts`); Vorschau `work/assets-preview/font.menu.png`.
- Die Statusschrift der Level hat Ä, Ö, Ü ebenfalls per Skript (siehe [Statuszeile](#statuszeile-level-1-sea)).
  Komma hat sie schon im Original.

### Layout der Menüseiten ✔

- Jede Zeile ist auf x = 160 zentriert (Mitte des 352 Pixel breiten Bilds nach dem Versatz um 16 Pixel).
- Zeilenraster 40 Pixel: y = 8, 48, 88, 128, 168, 208 (Seiten mit weniger Zeilen beginnen tiefer, z. B. bei 28
  oder 48). Höchstens 6 Zeilen pro Seite.
- Zeilenbreite = Summe aus (1 + Zeichenbreite); die breiteste Originalzeile hat 306 Pixel („DISK 2 AND PRESS“).
  Deutsche Zeilen sollten 320 Pixel nicht überschreiten.
- Breitenprüfung der deutschen Entwürfe unten (06.10.2026): alle Zeilen passen (breiteste „VERWANDELT SICH“ mit
  310 Pixel, „PROGRAMMIERUNG“ 309). Nicht einzeilig passen „QUALITÄTSSICHERUNG“ (358) und „TITELBILD UND LOGO“
  (346); beide stehen ohnehin auf zwei Zeilen.
- Die Pipeline übernimmt für Englisch die Original-Koordinaten; für Deutsch zentriert sie neu nach demselben Schema.

## Titelsequenz (`present`)

Die Wörter der Titelsequenz sind **fertige Bilder** in einer eigenen Serifenschrift mit Kleinbuchstaben, keine
Schrift-Zeichen ✔:

| Englisch (Original) | Deutsch | Bemerkung |
|---|---|---|
| and | (und) | zwischen den Logos „Psygnosis … and … Art & Magic … Present … Agony“ |
| Present | (präsentieren) | |
| Do you want to skip the intro sequence? (y/n) | – | wird nie angezeigt (Überbleibsel des gestrichenen Intros) |

Entschieden (E-024): Diese Bild-Wörter bleiben auch in der deutschen Fassung englisch, wie die Logos.

## Menü: Abspann-Seiten (`igt`)

| Nr. | Englisch (Original) | Deutsch (Entwurf) |
|---|---|---|
| 1 | PSYGNOSIS / PRESENTS / (Leerzeile) / AGONY / BY / ART AND MAGIC | PSYGNOSIS / PRÄSENTIERT / AGONY / VON / ART AND MAGIC |
| 2 | ARTWORK / FRANCK SAUER / MARC ALBINET | GRAFIK / FRANCK SAUER / MARC ALBINET |
| 3 | PROGRAMMING / YVES GROLET | PROGRAMMIERUNG / YVES GROLET |
| 4 | GAME MUSIC / JEROEN TEL | SPIELMUSIK / JEROEN TEL |
| 5 | PRODUCED / BY / STEVEN RIDING | PRODUZIERT / VON / STEVEN RIDING |
| 6 | TITLE MUSIC / TIM WRIGHT / FRANCK SAUER | TITELMUSIK / TIM WRIGHT / FRANCK SAUER |
| 7 | END MUSIC / ROBERT LING / MARTIN WALL | ABSPANNMUSIK / ROBERT LING / MARTIN WALL |
| 8 | LOADING MUSIC / R. LING / M. WALL / M. SIMONS / M. IVESON / A. BRIMBLE | LADEMUSIK / (Namen unverändert) |
| 9 | FLASHBACK / COMPRESSOR / LAURENT / LARMINIER | PACKPROGRAMM / FLASHBACK / LAURENT / LARMINIER |
| 10 | DISK LOADER / MICHEL JANSSENS | DISKETTENLADER / MICHEL JANSSENS |
| 11 | QUALITY / ASSURANCE / GREG DUDDLE / CHRIS STANLEY / NICK BURCUMBE | QUALITÄTS- / SICHERUNG / (Namen unverändert) |
| 12 | COVER ART AND / LOGO DESIGN / TONY ROBERTS / ROGER DEAN | TITELBILD / UND LOGO / TONY ROBERTS / ROGER DEAN |
| 13 | Highscore-Tabelle (Kürzel und Punkte) | unverändert |

„/“ trennt Zeilen. Personennamen und Firmennamen werden nicht übersetzt.

## Story-Seite beim Spielstart (`igt`)

| Englisch (Original) | Deutsch (Entwurf) |
|---|---|
| ALESTES / METAMORPHOSES / INTO AN OWL. / THE TIME TO / FIGHT HAS COME. | ALESTES / VERWANDELT SICH / IN EINE EULE. / DIE ZEIT ZU / KÄMPFEN IST / GEKOMMEN. |

## Highscore (`igt`)

| Englisch (Original) | Deutsch (Entwurf) |
|---|---|
| YOU ARE NOW / AMONGST THE / TOP PLAYERS. / PLEASE ENTER / YOUR INITIALS. | DU GEHÖRST NUN / ZU DEN BESTEN / SPIELERN. / BITTE GIB DEINE / INITIALEN EIN. |
| REMOVE WRITE / PROTECT ON / DISK 2 AND PRESS / R TO RETRY OR / PRESS C TO / CANCEL HISCORE. | entfällt (kein Diskettenschreibschutz) |

## Statuszeile Level 1 (`sea`)

✔ Texttabelle `Text_Dat` (`$5BEDA`) und Zeichensatz `Status_Digit` (`$5BC1A`, 44 Zeichen à 8 × 16 Pixel, Hires)
ausgelesen (Dateiformate: [Weitere Laufzeitstrukturen](dateiformate.md#weitere-laufzeitstrukturen-)). Codes: 0–9
Ziffern, 10 Leben-Symbol (Punkt), 11–36 A–Z, 37 `!`, 38 `?`, 39 `.`, 40 `,`, 41 `(`, 42 `)`, 43 Leerzeichen.
Ziffer 0 und Buchstabe O sind dieselbe Glyphe. Kein Bindestrich, keine Umlaute. Text 1–9 sind die Zauber mit ihrer
Dauer (zwei Ziffern vorn, mit Punkt am Ende), 10–13 Meldungen (die gesperrten mit drei Leerzeichen davor); alle
werden ab Byte 10 der Statuszeile gezeichnet, ohne Zentrierung.

**Ä, Ö, Ü (Codes 44–46)** erzeugt die Asset-Pipeline (`tools/pipeline/extract/levels.ts`, Tabelle `status.extra`
im Manifest; Vorschau `work/assets-preview/font.status.png`): Die Originalzeichen füllen alle 16 Zeilen, deshalb wird
der Grundbuchstabe um 3 Zeilen gestaucht. Dabei fällt jeweils eine Zeile aus der längsten Folge gleicher Zeilen weg
(gerade Striche). Darüber stehen zwei Punkte à 2 × 2 Pixel (wie beim „!“) und eine Leerzeile.

**Eingebaut** (07.10.2026): Deutsche Texte stehen in `game/src/data/lang/de.ts` (`DE_STATUS`, Schlüssel =
Spieldatei des Levels). Englisch zeichnet weiter die Originaltabelle aus dem Level-Abbild. Die Sprache lässt sich
mitten im Level umschalten; ein stehender Text wird dann sofort neu gezeichnet. Ein Test prüft Zeichenvorrat und
Länge (Text endet spätestens vor den Leben-Symbolen ab Byte 68) und die Anzeige in beiden Sprachen.

„␣“ steht unten für ein Leerzeichen, wo es auf die Anzahl ankommt.

| Nr. | Englisch (Original) | Deutsch (Entwurf ❓, eingebaut) |
|---|---|---|
| 1 | 15␣␣REVERSE ENERGY. | 15␣␣ENERGIEUMKEHR. |
| 2 | 06␣␣ROTATING FIREBALL. | 06␣␣KREISENDER FEUERBALL. |
| 3 | 05␣␣TIME FREEZE. | 05␣␣ZEITSTOPP. |
| 4 | 10␣␣BLACK MAGIC SEEKER. | 10␣␣SCHWARZMAGISCHER SUCHER. |
| 5 | 08␣␣PLASMA SHIELD. | 08␣␣PLASMASCHILD. |
| 6 | 06␣␣SMART BOMB. | 06␣␣SUPERBOMBE. |
| 7 | 12␣␣INVULNERABILITY. | 12␣␣UNVERWUNDBARKEIT. |
| 8 | 08␣␣FORWARD POWER. | 08␣␣VORWÄRTSKRAFT. |
| 9 | 00␣␣NOT AVAILABLE. | 00␣␣NICHT VERFÜGBAR. |
| 10 | ␣␣␣P A U S E | ␣␣␣P A U S E |
| 11 | ␣␣␣G A M E␣␣␣O V E R␣␣! | ␣␣␣ENDE |
| 12 | ␣␣␣E X T R A␣␣␣L I F E | ␣␣␣E X T R A L E B E N |
| 13 | ␣␣␣PRESS FIRE TO START | ␣␣␣ZUM STARTEN FEUER DRÜCKEN |

Längster Text: Nr. 13 auf Deutsch mit 28 Zeichen (Byte 10–37), Platz wäre bis Byte 67.

## Spielende (`ending`)

| Seite | Englisch (Original) | Deutsch (Entwurf) |
|---|---|---|
| 1 | CONGRATULATIONS / YOU DEFEATED / MENTOR. | GLÜCKWUNSCH. / DU HAST MENTOR / BESIEGT. |
| 2 | THE SPIRIT OF / ACANTHOPSIS / APPEARS | DER GEIST VON / ACANTHOPSIS / ERSCHEINT |
| 3 | AND GIVES YOU / THE SCROLL THAT / REVEALS | UND GIBT DIR / DIE SCHRIFTROLLE / MIT DEM GEHEIMNIS |
| 4 | THE SECRET OF / COSMIC STRENGTH / AND / WORLD CREATION. | DER KOSMISCHEN / KRAFT UND DER / ERSCHAFFUNG / DER WELT. |
| 5 | YOU WILL HAVE / TO HIDE THIS / MIGHTY SECRET / IN A SAFE PLACE / TO PRESERVE THE / PEACE FOREVER. | DU MUSST DIESES / MÄCHTIGE / GEHEIMNIS GUT / VERSTECKEN, UM / DEN FRIEDEN FÜR / IMMER ZU WAHREN. |
| 6 | THE END | ENDE |
| 7 ff. | GREETINGS TO … (Namen) | GRÜSSE AN … (Namen unverändert) |

## Zaubernamen (aus der Anleitung)

Ob das Spiel die Namen anzeigt oder nur Symbole, ist noch zu prüfen ❓. Gebraucht werden sie mindestens für eine
Hilfe- oder Anleitungsseite (Enhanced) und fürs Wiki; Tabelle mit Wirkung in
[Spielmechanik](original/spielmechanik.md#die-acht-zauber--anleitung).

| Schlüssel | Englisch | Deutsch (Entwurf) |
|---|---|---|
| `spell.reverseEnergy` | REVERSE ENERGY | RÜCKWÄRTSENERGIE |
| `spell.rotatingFireball` | ROTATING FIREBALL | KREISENDER FEUERBALL |
| `spell.timeFreeze` | TIME FREEZE | ZEITSTOPP |
| `spell.blackMagicSeeker` | BLACK MAGIC SEEKER | SCHWARZMAGISCHER SUCHER |
| `spell.plasmaShield` | PLASMA SHIELD | PLASMASCHILD |
| `spell.smartBomb` | SMART BOMB | SMARTBOMB |
| `spell.invulnerability` | INVULNERABILITY | UNVERWUNDBARKEIT |
| `spell.forwardPower` | FORWARD POWER | VORWÄRTSKRAFT |

## Neue Texte des Remakes

| Schlüssel | Englisch | Deutsch |
|---|---|---|
| `ui.options` | OPTIONS | OPTIONEN |
| `ui.language` | LANGUAGE | SPRACHE |
| `ui.language.en` | ENGLISH | ENGLISH |
| `ui.language.de` | DEUTSCH | DEUTSCH |
| `ui.back` | BACK | ZURÜCK |
| `ui.rotate` | PLEASE TURN / YOUR DEVICE | BITTE GERÄT / DREHEN |
| `ui.tapToStart` | TAP TO START | ZUM STARTEN / TIPPEN |
| `ui.pause` | PAUSE | PAUSE |
| `ui.levelStub` | LEVEL 1 / COMING SOON | LEVEL 1 / KOMMT BALD |
| `ui.level2Stub` | LEVEL 2 / COMING SOON | LEVEL 2 / KOMMT BALD |
| `ui.level3Stub` | LEVEL 3 / COMING SOON | LEVEL 3 / KOMMT BALD |
| `ui.pressFire` | PRESS FIRE | FEUER DRÜCKEN |
| `ui.spellFire` | FIRE MENU | FEUERMENÜ |
| `ui.on` / `ui.off` | ON / OFF | AN / AUS |
| `ui.quit` | QUIT GAME | SPIEL BEENDEN |
| `ui.quitConfirm` | REALLY QUIT | WIRKLICH BEENDEN |

Optionsmenü (E-043): „FEUERMENÜ: AN/AUS“ schaltet, ob gehaltenes Feuer das Zaubermenü öffnet (`Menu_Mode`); die
längere Fassung passte nicht in den Bildausschnitt. „SPIEL BEENDEN“ steht nur im Level; erstes Auswählen zeigt
„WIRKLICH BEENDEN“, zweites bestätigt. Die Menüschrift hat kein Fragezeichen.

`ui.pressFire` ist der Bedienhinweis an ersetzten Ladezeiten (E-039), gezeichnet in der auf 50 % verkleinerten
Menüschrift. `ui.levelStub` ist ein vorläufiger Platzhalter an noch nicht übertragenen Stellen von Level 1, `ui.level2Stub` an
solchen Stellen von Level 2 und `ui.level3Stub` nach dem Levelende von Level 2, bis alles nachgebaut ist; alle
verschwinden dann.

Sprachnamen stehen immer in ihrer eigenen Sprache, damit man sie auch in der falschen Sprache findet. „/“ steht hier
für einen Zeilenumbruch (im Code `|`): „ZUM STARTEN TIPPEN“ ist mit 360 Pixeln zu breit für eine Zeile.

## Technik (Kurzfassung, Details in [Architektur](architektur.md#sprachen))

- Alle Texte über Schlüssel aus Sprachtabellen (`en`, `de`); kein Text fest im Code.
- Die englische Tabelle erzeugt die Asset-Pipeline aus den Originaldaten (samt Positionen); die deutsche wird von
  Hand gepflegt: Seiten in `game/src/data/lang/de.ts`, neue Texte des Remakes in `game/src/data/lang/ui.ts`.
- Deutsche Seiten haben dieselbe Zeilenzahl wie das Original (Leerzeilen inklusive) und übernehmen dessen y-Werte;
  x wird nach dem Schema des Originals neu zentriert: x = (320 − Breite) / 2. Das Schema stimmt für alle englischen
  Zeilen (per Test geprüft).
- Ein Test prüft bei jedem Lauf: nur Zeichen der Schrift, deutsche Zeilen ≤ 320 Pixel, Remake-Texte ≤ 336 Pixel.
- Voreinstellung nach Gerätesprache (`de*` → Deutsch, sonst Englisch), umschaltbar im Optionsmenü.
