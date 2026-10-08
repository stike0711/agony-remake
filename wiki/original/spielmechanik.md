# Das Original – Spielmechanik

Stand: 06.10.2026 · Legende: ✔ belegt · 🌐 nur Web-Recherche · ❓ Vermutung/ungeklärt

Quellen: die Anleitung (englische Abschrift bei Lemon Amiga, ✔ „Anleitung“), der Quellcode und Rezensionen (🌐).
Alles muss vor dem Nachbau im Quellcode (vor allem `Ag_Playability_.s`, „GAME MODULE“) und im Emulator bestätigt
werden.

## Steuerung

- Joystick an Port 2 mit einem Feuerknopf; die Eule fliegt in alle **8 Richtungen** (Diagramm in der Anleitung) ✔.
  Im Emulator startet Feuer an Port 2 das Spiel ✔.
- **Zaubermenü:** Feuerknopf **länger als eine halbe Sekunde** halten ✔ (Anleitung), alternativ Leertaste ✔
  (Quellcode). Das Spiel pausiert dabei 🌐.
- Ein Joystick mit Dauerfeuer bringt laut einer Rezension Vorteile 🌐.
- Tastatur laut Tastaturabfrage in `Agony_Parent_.s` (Abschnitt „KEY TEST“) ✔: `P` = Pause, Leertaste = Zaubermenü
  (`Do_Menu`, gesperrt während des Sterbens, vor dem Start und während bestimmter Zauber), `Esc` = Abbruch, `M` =
  `Change_Mode` (schaltet `Menu_Mode` um ❓ Bedeutung), `F1`–`F4` und `Return` nur im Cheat-Modus (`Sheet_Flag`).
- **Cheat:** Im Menü „FANTASY“ tippen; die Power-LED schaltet um, im Spiel sind dann Return (Level überspringen) und
  F1–F4 (Äxte, Zauber, Waffen, Punkte) aktiv ✔ (Disassembly von `igt`, Quellcode; Tabelle in
  [Ablauf bis Level 1](startsequenz.md#cheat-fantasy)).
- Die Eingabe der Initialen für die Highscore-Liste fordert der Text „YOU ARE NOW AMONGST THE TOP PLAYERS. PLEASE
  ENTER YOUR INITIALS.“ an ✔ (Texttabelle in `igt`). Eingabe über die Tastatur: 3 Zeichen, Backspace löscht, Return
  bestätigt ✔.

## Die Eule

- Fliegt in 8 Richtungen ✔ (Anleitung), sehr flüssig animiert 🌐. `reference/agony/gfx/owl.gif` zeigt 15 Phasen des
  Flügelschlags.
- Besteht aus den Hardware-Sprites 0–3 (zwei angehängte Paare, 16 Farben) 🌐, siehe [Grafik](grafik.md).
- Große Trefferzone, wegen der Flügel schwer einzuschätzen 🌐.

## Waffen und Extras

- **Schuss:** eine Echoortungswelle. Zaubertränke (grüne Flaschen) rüsten ihn bis zu dreimal auf: mehr Schaden,
  größere Geschosse 🌐. Eine Rezension behauptet, die Flaschen könnten bei Berührung auch schaden ❓.
- **Schwerter:** Zwei Schwerter umkreisen die Eule, beschädigen Gegner und zerstören gegnerische Geschosse 🌐.
- **Zauber** ✔ (Anleitung): Einsammelbare Zauber erscheinen im Spiel als **Trankflasche oder Schriftrolle**. Im
  Zaubermenü sind noch nicht gesammelte Zauber durchgekreuzt; man wählt mit einem Pfeil und bestätigt mit Feuer.
  **Alle Zauber wirken nur begrenzte Zeit.** Die Restdauer steht als Zahl oben links 🌐. Im Hauptmodul gibt es die
  Variable `Curent_Spell` ✔.
  ❓ Wie sich „Trank rüstet den Schuss auf“ (Rezensionen) und „Trank ist ein Zauber“ (Anleitung) zueinander verhalten,
  klärt der Quellcode.

### Die acht Zauber ✔ (Anleitung)

| Englisch (Anleitung) | Deutsch (Vorschlag) | Wirkung laut Anleitung |
|---|---|---|
| Reverse Energy | Rückwärtsenergie | hilft gegen Angriffe von hinten |
| Rotating Fireball | Kreisender Feuerball | Schutz rundherum |
| Time Freeze | Zeitstopp | friert alle Gegner auf dem Bildschirm ein |
| Black Magic Seeker | Schwarzmagischer Sucher | für gezielte Treffer (zielsuchend) |
| Plasma Shield | Plasmaschild | breiter Schutz |
| Smart Bomb | Smartbomb | zerstört die meisten Gegner auf dem Bildschirm |
| Invulnerability | Unverwundbarkeit | unverwundbar, solange der Zauber wirkt |
| Forward Power | Vorwärtskraft | hilft gegen Angriffe von vorn |

Reihenfolge wie in der Anleitung; die Reihenfolge im Zaubermenü des Spiels ist noch zu prüfen ❓.

## Leben, Tod und Punkte

- 3 Leben, keine Continues ✔. `Life` ist eine Bitreihe (`%111`, je Leben ein Bit, rechtsbündig); ein Tod schiebt
  sie nach rechts, ein Extraleben schiebt ein Bit von rechts nach (höchstens 5) ✔.
- Tod ✔ (`Ag_Sprites.s`, MAIN CHAR DIE): Trifft ein Gegner oder Gegnerschuss die Eule, setzt die Hauptschleife
  `Die`; der Copper-Interrupt nimmt ein Leben, schaltet Schüsse und Gegnerschüsse ab und lässt die Eule in 8 Teile
  zerspringen (Sprites 0–7 mit eigenen Farben, Bahnen aus `Die_Table`). Nach etwa 90 Bildern, wenn alle Teile fertig
  sind, folgt der Wiedereinstieg an derselben Stelle.
- Wiedereinstieg ✔: eine Waffenstufe weniger (nicht unter 0), die untere Axt ist weg (ohne sie auch die obere), und
  3 Sekunden Schild (Zauber 6, `Spell_Time` 3): Die Eule erscheint weiß umrandet (Sprites 6/7, Farben 29–31) und ist
  unverwundbar (`Sorcerer_On` = 0); Gegner, die sie berührt, verlieren trotzdem Energie und bringen Punkte. Kein Regen,
  solange ein Zauber wirkt.
- Spielende ✔: Mit dem letzten Leben erscheint „GAME OVER“ (Text 11, bleibt stehen). Nach der Explosion beginnt
  `Quit_Delay` (50 Durchläufe ≈ 2 s) und `Clean_Up`: alle Gegner explodieren, Wellen und Gegnerschüsse enden (O-013).
  Dann lädt das Spiel das Menü (`igt`); das Level steht so lange, mit Regen.
- Extraleben alle 80.000 Punkte ✔ (`Ag_Status.s`: Zähler `Extra_Life` ≥ BCD `$080000`, Text „EXTRA LIFE“); die
  Angabe 8.000 aus dem Web 🌐 ist um eine Null zu kurz.
- Punkte werden als BCD-Zahl gespeichert ✔ (Highscore-Datei, siehe [Dateiformate](../dateiformate.md#highscore-agony00)).
- Highscore-Liste mit 6 Einträgen ✔, gespeichert auf Disk 2 🌐 ✔.
- Nach Game Over lädt das Spiel das Menü (`igt`) ✔.

## Gegner

- Rund 50 Gegnertypen und 6 Endgegner laut Packung 🌐. Gegner und Endgegner haben wenige Animationsphasen, weil der
  Speicher großteils in die Eule floss 🌐.
- Jedes Level hat eine Startliste mit Angriffswellen: ab welcher Scrollposition welches Objekt wo erscheint ✔,
  Details in [Level](level.md).
- Gegnerschüsse: eigenes Modul `Ag_Alien_Fire.s` („ALIEN FIRE MODULE“) ✔.
- Treffer ✔ (`Ag_Playability_.s`, AWO COLISION TEST): Jedes Objekt hat Trefferrechtecke; geprüft wird gegen bis zu
  8 Rechtecke der eigenen Seite (Eule, Schuss, Äxte, Zauber). Ein Treffer kostet den Gegner 1 Energie und bringt
  13 Punkte, die Zerstörung 116 Punkte (BCD `$13` bzw. `$116`). Trifft ein Gegner die Eule, stirbt sie (`Die`);
  trifft der Schuss, verschwindet er. Getroffene Gegner zeigen danach 14 Explosionsphasen (Sprites 1–7 der Objekte).
- Wellen ✔: Gegner einer Welle folgen nacheinander derselben Bahn im Abstand `AWS_Alien_Rate` Durchläufe (25 Hz);
  Energie, Schussrate und Farben stehen in der Wellenbeschreibung (Details in [Level](level.md)).
- Gegnerschüsse ✔: zielen beim Abschuss auf die Eule (alle Dx/(3·Dy) Durchläufe ein Pixel auf oder ab, 3 Pixel je
  Durchlauf nach links), nur wenn die Eule mehr als 64 Pixel links vom Gegner ist; bis zu 32 gleichzeitig, als Sprite
  mit Multiplexing (dicht übereinander liegende wechseln sich ab).
- Schuss der Eule ✔: 20 Pixel je Bild, 12 Bilder lang; ein neuer erst, wenn der alte weg ist.

## Statuszeile

- Eigenes Modul `Ag_Status.s` („STATUS LINE“) ✔. Auf Screenshots stehen oben über dem Spielfeld Symbole links, in
  der Mitte und rechts ❓ (Leben, Schusskraft, Zauber?).

## Demo-Modus

- Der Quellcode kann Demos aufnehmen und abspielen (`Asm_Demo_Mode`: 1 = aufnehmen, 2 = abspielen) ✔.
- Die Demo-Fassung enthält `demo_track_sea` und `demo_track_forest` (je 12.288 Byte) ✔ – vermutlich aufgezeichnete
  Eingaben für einen Vorführmodus ❓.

## Offene Fragen (im Quellcode/Emulator klären)

- Geschwindigkeiten der Eule (3 Pixel je Bild ✔) und der Schüsse (20 Pixel ✔), Schussfrequenz
- Trefferzonen von Eule, Gegnern und Geschossen
- Die 8 Zauber: Namen und grobe Wirkung sind aus der Anleitung bekannt; genaue Wirkung, Dauer, Reihenfolge im Menü
  und Zusammenspiel mit dem Schuss-Upgrade fehlen
- Verhalten der Schwerter
- Punkte pro Gegner (✔ 13/116 für Wellen-Gegner; Gegner mit eigener Routine noch offen)
- Dauer der Unverwundbarkeit nach einem Treffer
- Inhalt der Statuszeile

## Quellen

- Hardcore Gaming 101: https://www.hardcoregaming101.net/agony/
- Wikipedia: https://en.wikipedia.org/wiki/Agony_(1992_video_game)
- Super Adventures in Gaming: http://superadventuresingaming.blogspot.com/2012/09/agony-amiga.html
- Aminet-Rezension (1992): https://ftp.fau.de/mirrors/aminet/docs/rview/Agony.txt
- Quellcode: `Agony_Parent_.s`, `Ag_Status.s`, `Ag_Alien_Fire.s` (siehe [Quellcode](../quellcode.md))
