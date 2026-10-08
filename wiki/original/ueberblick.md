# Das Original – Überblick

Stand: 06.10.2026 · Legende: ✔ belegt · 🌐 nur Web-Recherche · ❓ Vermutung/ungeklärt

## Eckdaten

| | |
|---|---|
| Titel | Agony |
| Genre | horizontal scrollender Shoot-'em-up |
| Plattform | Amiga (OCS), läuft auf einem A500 mit 512 KB und Kickstart 1.2/1.3 🌐 |
| Erschienen | 1992 (Europa und Nordamerika) 🌐 |
| Entwickler | Art & Magic, Belgien (vormals Ordilogic Systems) 🌐 – „ART & MAGIC“ steht in jedem Quellcode-Kopf ✔ |
| Publisher | Psygnosis 🌐 – Seriennummern „Psygnosis“ im Bootblock-Quelltext ✔ |
| Datenträger | 3 Disketten à 880 KB, nicht auf Festplatte installierbar 🌐 |
| Videonorm | PAL, 50 Hz; der Quellcode hat zusätzlich einen NTSC-Schalter (`Asm_Vdo_Mode`) ✔ |
| Freeware | Franck Sauer bietet die Disk-Images seit etwa 2010 kostenlos an 🌐 |
| Quellcode | im Juli 2020 von Yves Grolet veröffentlicht, nicht-kommerzielle Lizenz ✔ (siehe [Quellcode](../quellcode.md)) |

## Team

| Aufgabe | Person(en) | Beleg |
|---|---|---|
| Programmierung, Design | Yves Grolet | ✔ Quellcode-Köpfe („Coding: Yves Grolet“) |
| Grafik | Franck Sauer, Marc Albinet | ✔ Quellcode-Köpfe („Artwork“) |
| Titelmusik (Klavierstück) | Tim Wright, laut ExoticA zusammen mit Franck Sauer | 🌐 |
| Ingame-Musik | Jeroen Tel | ✔ Dateiköpfe der Musikquellen, Diskname „Agony Music -Jeroen Tel/TSC-“ |
| Lademusik | Martin Iveson, Robert Ling, Martin Wall, Matthew Simmonds; Allister Brimble wird genannt, sein Beitrag blieb laut ExoticA ungenutzt | 🌐 |
| Logo | Roger Dean | 🌐 |
| Packungsbild | Tony Roberts | 🌐 |
| Producer (Psygnosis) | Steve Riding | ✔ Abspann im Spiel, Anleitung |
| Intro (Präsentation) | T. Landspurg, L. Larminier | ✔ Anleitung |
| Anleitung | Nik Wild | ✔ Anleitung |

### Abspann im Spiel ✔

Der Abspann im Menü (siehe [Ablauf bis Level 1](startsequenz.md#menü-igt)) bestätigt die meisten Angaben oben und
nennt weitere Beteiligte:

- Title Music: Tim Wright, Franck Sauer · Game Music: Jeroen Tel · End Music: Robert Ling, Martin Wall
- Loading Music: R. Ling, M. Wall, M. Simons (so geschrieben), M. Iveson, A. Brimble – Brimble wird also im Spiel
  genannt; ob sein Stück verwendet wird, bleibt offen ❓
- Produced by: Steven Riding · Cover Art and Logo Design: Tony Roberts, Roger Dean
- Flashback Compressor: Laurent Larminier (vermutlich der Packer der Spieldateien ❓; er steht auch in der
  Versionsliste des Bootblocks)
- Disk Loader: Michel Janssens
- Quality Assurance: Greg Duddle, Chris Stanley, Nick Burcumbe

## Story

### Im Spiel ✔

Das Spiel selbst erzählt nur wenig (Texttabellen in `igt` und `ending`):

- **Beim Spielstart** (Story-Seite auf dem Menübild): „ALESTES METAMORPHOSES INTO AN OWL. THE TIME TO FIGHT HAS COME.“
- **Spielende** (mehrere Seiten): „CONGRATULATIONS – YOU DEFEATED MENTOR.“ – „THE SPIRIT OF ACANTHOPSIS APPEARS“ –
  „AND GIVES YOU THE SCROLL THAT REVEALS“ – „THE SECRET OF COSMIC STRENGTH AND WORLD CREATION.“ – „YOU WILL HAVE TO
  HIDE THIS MIGHTY SECRET IN A SAFE PLACE TO PRESERVE THE PEACE FOREVER.“ – „THE END“. Danach Grüße an Y. Robert,
  Deltatec, M. Vanzeise, G. Delmotte, den CCI Club (J.C. Sente, A. Leseigneur, S. Asquoet, M. Balet, Y. Jacot),
  C. Morant, F. Moras, M. Delvoyennes, T. Landspurg, P. Hunter, S. Bervas und Atreid Concept (F. Derwael, P. Lesire,
  F. Buttien, P. Wislez, V. Lacrosse).
- Die Ladebilder vor jedem Level transportieren Stimmung, aber keinen Text.
- Schreibweise im Spiel: **Acanthopsis**.

Die Vorgeschichte steht nur im Handbuch. Ein rund sechsminütiges Animations-Intro von Marc Albinet war geplant,
wurde aber gestrichen 🌐.

### Anleitung ✔

Quelle: englische Abschrift bei Lemon Amiga, https://www.lemonamiga.com/doc/agony/38 („Typed by Joey Beltram“,
aufbereitet von Lemon Amiga), vom Nutzer am 06.10.2026 bereitgestellt. Zusammenfassung in eigenen Worten:

- **Vorgeschichte:** Im Morgengrauen steht der Großmeister und Sonnenzauberer Acanthropsis auf dem Kamm von
  **Bromire**, den Blick auf die fernen Berge von **Krocott**, und weiß, dass er an diesem Tag sterben wird. In der
  Nacht hat er in seinem inneren Heiligtum nach Jahren der Forschung die **Kosmische Kraft** entdeckt; der Preis
  dafür ist sein Leben. Vor seinem Tod muss er das Wissen an einen Würdigen weitergeben. In Frage kommen seine beiden
  Schüler **Alestes** und **Mentor**, beide gleich begabt. Er ersinnt eine Prüfung und hofft, dass einer von beiden
  scheitert.
- **Das Spiel:** Laut Anleitung zeigt die Ladesequenz die Prüfung und ihr Ergebnis ❓ (im fertigen Spiel gibt es
  dazu nur die kurze Story-Seite; vermutlich bezog sich das auf das gestrichene Intro). Der Spieler ist Alestes in
  Gestalt einer Eule. Er fliegt durch sechs Level zu dem magischen Ort, der das Geheimnis der Kosmischen Kraft birgt,
  kämpft gegen die Kreaturen, die Mentor ihm entgegenschickt, und sammelt unterwegs Zauber und Tränke.
- **Schreibweise:** Anleitung „Acanthropsis“, Spiel „Acanthopsis“.
- Steuerung und Zauber: siehe [Spielmechanik](spielmechanik.md).

Andere Quellen 🌐 (Hardcore Gaming 101): Alestes gewinnt die Prüfung, Mentor stiehlt den Zauber, flieht und
überzieht das Land mit Fallen und Kreaturen. Davon steht in der Abschrift nichts – möglicherweise aus der gedruckten
Anleitung oder einer anderen Sprachfassung ❓.

### Mitwirkende laut Anleitung ✔

Programmierung Yves Grolet · Intro T. Landspurg und L. Larminier · Musik im Spiel und im Intro Jeroen Tel ·
Abspannmusik Robert Ling und Martin Wall · Grafik Franck Sauer und Yves Grolet · Packungsbild Tony Roberts ·
Anleitung Nik Wild · Producer Steve Riding (Schreibfehler der Abschrift wie „Frank Saur“ berichtigt).

Abweichung: Unter „Title Music“ nennt die Anleitung R. Ling, M. Wall, M. Simmons, M. Iveson und A. Brimble. Im Spiel
stehen dieselben Namen unter „Loading Music“, die Titelmusik wird Tim Wright und Franck Sauer zugeschrieben. Im
Zweifel gilt der Abspann im Spiel.

## Entstehung 🌐

- Begann als Nachfolger des Ordilogic-Spiels „Unreal“ (Arbeitstitel „Twilight“). Nach dem Wechsel zu einem anderen
  Publisher war ein Sequel nicht mehr möglich.
- Der Umfang wurde reduziert, weil ein Programmierer zum Militärdienst musste. ❓ Die Quellen widersprechen sich, wer:
  Franck Sauers Website nennt Yves Grolet, ein Interview nennt Yann Robert.
- Shoot-'em-up statt Fortsetzung, unter anderem weil Marc Albinet Erfahrung mit dem C64-Shooter „Ylliad“ hatte.
- Ein spielbarer Prototyp entstand in einem Monat und wurde auf der ECTS 1991 in London gezeigt.
- Erklärtes Ziel: die Parallax-Scrolls von „Shadow of the Beast“ übertreffen. Die Beast-Entwickler sollen nicht
  herausgefunden haben, wie das Scrolling funktioniert.
- Die Eule war die Idee des Teams (Naturthema), angelehnt an das Psygnosis-Logo. Als Vorbild für die Animation
  diente der Vorspann des Films „Labyrinth“.
- Name: klang gut und steht in alphabetischen Spielelisten der Magazine weit oben.
- Ein rund sechsminütiges Animations-Intro von Marc Albinet wurde gestrichen, weil eine vierte Diskette zu teuer war.
- Die Ladebilder orientieren sich an der Hudson River School, einer amerikanischen Landschaftsmalerei des
  19. Jahrhunderts.

Aus dem Quellcode ✔:

- Die Modul-Köpfe tragen das Datum 25.06.1990.
- Der Bootblock-Quelltext (`DISK/BootBlock.s`) listet ausgelieferte Versionen mit Seriennummern:
  000 (intern), 001–003 an Psygnosis, 004 an Laurent Larminier; danach „NEW VERSION (Marshes debuged)“ 005–006,
  „NEW VERSION (Marshes redebuged & no present)“ 007–009 und „NEW VERSION (Work on 3000)“ 010–012. Es gab also
  mehrere Revisionen, unter anderem mit Korrekturen am Sumpf-Level und für den Amiga 3000.

## Rezeption 🌐

- Technisch und künstlerisch hoch gelobt; gilt als eines der schönsten Amiga-Spiele.
- Spielerisch durchwachsen: oft enge, überfüllte Bildschirme, manche Gegner schwer zu erkennen, Terrain spielt keine
  Rolle, keine Schwierigkeitsstufen, wenig Waffenvielfalt. Eine Rezension von 1992 nennt es eher leicht.
- Kommerziell nur mäßig erfolgreich, weil der Amiga-Markt bereits schrumpfte. Kultstatus kam später.

## Vermächtnis 🌐

- Agony blieb das einzige Amiga-Spiel unter dem Namen Art & Magic; die Firma wechselte danach zu Arcade-Spielen.
  Grolet, Sauer und Robert gründeten später Appeal („Outcast“).
- Fan-Projekte: eine Remake-Demo in der Unreal Engine 4 (2016, itch.io „alestes“) und „Anguish“, ein inoffizieller
  geistiger Nachfolger von Lionagony (Demo 2025).
- Kurios: Der Keyboarder von Dimmu Borgir übernahm das Titelstück ohne Nennung für „Sorgens Kammer“ (Album
  „Stormblåst“, 1996). Bei der Neueinspielung strich die Band das Stück.

## Quellen

- Wikipedia: https://en.wikipedia.org/wiki/Agony_(1992_video_game)
- Hardcore Gaming 101: https://www.hardcoregaming101.net/agony/
- Franck Sauer, Agony: https://www.francksauer.com/index.php/games?view=article&id=10%3Aagony&catid=15%3Apublished-games
- Interview mit Franck Sauer (Games That Weren't): https://www.gamesthatwerent.com/2014/12/an-interview-with-franck-sauer/
- Lilura1: https://lilura1.blogspot.com/2022/04/Agony-Amiga-1992-Art-and-Magic-Yves-Grolet.html
- Aminet-Rezension (1992): https://ftp.fau.de/mirrors/aminet/docs/rview/Agony.txt
- Generation Amiga: https://www.generationamiga.com/2020/07/08/source-code-released-of-legendary-amiga-game-agony/
- ExoticA: https://www.exotica.org.uk/wiki/Agony_(game)
- Indie Retro News (Anguish, UE4-Remake): https://www.indieretronews.com/2025/04/anguish-amiga-classic-agony-by.html
