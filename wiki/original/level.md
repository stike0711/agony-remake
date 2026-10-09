# Das Original – Level

Stand: 06.10.2026 · Legende: ✔ belegt · 🌐 nur Web-Recherche · ❓ Vermutung/ungeklärt

Die Abschnitte Übersicht, Startliste und Objektnamen beruhen auf Quellcode und Spieldaten (✔); Spielbeschreibungen sind mit 🌐 markiert.

## Übersicht

Reihenfolge laut Ladetabelle `DISK/load_label.s` und Include-Reihenfolge in `Agony_Parent_.s`.

| Nr. | Welt | Name im Quellcode | Dateien (Original → Crack) | Ingame-Musik | Einträge in der Startliste¹ | letzter `WAIT` |
|---|---|---|---|---|---|---|
| 1 | Meer | `LMER` (sea) | `load_sea` + `sea` → `Agony.08` + `.09` | Sea & Fire | 121 (im Abbild bestätigt) | `$22F0` |
| 2 | Wald | `LFORET` (forest) | `load_forest` + `forest` → `.0A` + `.0B` | Forest | 116 | `$22F0` |
| 3 | Sumpf | `LMARAIS` (marshes) | `load_marshes` + `marshes` → `.0C` + `.0F` | Marshes & Highlands | 106 | `$2300` |
| 4 | Berge | `LMONTAGNES` (mountains) | `load_mountains` + `mountains` → `.10` + `.11` | Mountains | 123 | `$2300` |
| 5 | Hochland | `LPLATEAUX` (highlands) | `load_highlands` + `highlands` → `.12` + `.13` | Marshes & Highlands | 237 | `$2300` |
| 6 | Feuer | `LFEUX` (fire) | `load_fire` + `fire` → `.14` + `.02` | Sea & Fire | 262 | `$2300` |

¹ Laut Quelltext, ohne die `Demo_Page`-Einträge, die nur im Demo-Modus assembliert werden (Level 1: 8, Level 2: 9).
Der Quelltext ist älter als die Release-Fassung; für Level 1 stimmt die Zahl mit dem Binärabbild überein.

- Vor jedem Level kommt ein Ladebild mit eigener Musik (`load_*`). Die Ladebilder sind signierte Gemälde von
  Franck Sauer im EHB-Modus (320 × 256, 64 Farben) 🌐.
- Am Level-Ende lädt das Hauptmodul die nächste Ladebild-Datei; nach Level 6 lädt es `ending` ✔.
- Die Startlisten sind ungefähr gleich lang (letzter `WAIT` bei `$22F0`/`$2300`), Level 5 und 6 haben aber
  doppelt so viele Einträge ✔.
- Level 6 liegt auf der ersten Original-Diskette (zusammen mit Präsentation und Ende), vermutlich um am Schluss
  einen Diskwechsel zu sparen ❓.

## Aufbau der Startliste

Jedes Level-Modul (`Ag_Game_L*.s` in `YvesDisks/PC_Files/AgonyDosBoot/`) beginnt mit einer „ATTACK WAVE START LIST“
(`Start_List`). Jeder Eintrag besteht aus einem `WAIT <Position>` und genau einem Start:

```
Start_List
        WAIT    $40
        START_A Poisson_Bl_1,280+256,220+256
        WAIT    $42
        START_A Poisson_Bl_3,260+256,230+256
        …
```

- `WAIT` wartet, bis `Level_X` den Wert erreicht ✔. `Level_X` beginnt bei −32 und steigt je Durchlauf der Hauptschleife
  (25 Hz) um 2, also 50 je Sekunde – so schnell, wie das vordere Playfield scrollt (1 Einheit = 1 Pixel). Je
  Durchlauf mit `Short_Phase` wird höchstens ein Eintrag ausgeführt.
- Drei Arten von Starts, unterschieden durch die oberen Bits des Zeigers ✔:
  - `START_A obj,x,y` – Zeiger + `$40000000`, dazu x und y
  - `START_C obj` – Zeiger + `$80000000`
  - `START_R obj` – Zeiger ohne Zusatz; wird unter anderem für `Awsrt…`-Strukturen benutzt
  
  Bedeutung ✔ (`Ag_Playability_.s`, INTERPRET START LIST): A = Welle auf einer absoluten Bahn mit Startpunkt (Bahn
  `Absolute_Tracks`, Koordinaten +256), R = Welle auf einer relativen Bahn (Startpunkt im Kopf der Bahn, x relativ zum
  Scrollen), C = Objekt mit eigener Routine (`R_…`) und Parametern bis `PAR_END`. Wellen belegen eine von 16 Bahnen
  und eine von 32 AWO-Bänken (je bis 16 Gegner), Routinen einen von 32 Routinenplätzen.
- Die Koordinaten sind um 256 verschoben (z. B. `280+256`), vermutlich damit Positionen außerhalb des Bildes positiv
  bleiben ❓.
- In jeder Liste kommt genau einmal `R_Final` vor ✔ – vermutlich der Endgegner ❓.
- `START_C Demo_Page`-Einträge stehen in `IFNE ASM_Demo_Mode=2`-Blöcken und existieren nur in Demo-Fassungen ✔.
- Für Level 1 ist die Liste im entpackten Spielabbild gefunden und vollständig dekodiert ✔, siehe
  [Dateiformate](../dateiformate.md#angriffswellen-startliste-binärformat).

### Wellen-Parameter („Attack Wave Start struct for Relative Tracks“)

Die Dateien `l*_rtr.s` enthalten Strukturen `Awsrt0`, `Awsrt1` … mit diesen Feldern:

| Feld | Typ | Bedeutung (❓ wo nicht offensichtlich) |
|---|---|---|
| `AWS_Table_X_Off`, `AWS_Table_Y_Off` | Wort | Versatz in einer Bahntabelle |
| `AWS_Table_Obj_Off` | Wort | Objekt/Animation, z. B. `Anim_Boulle` |
| `AWS_Alien_Rate` | Byte | Abstand zwischen den Gegnern einer Welle in Durchläufen (25 Hz) ✔ |
| `AWS_Alien_Num` | Byte | Anzahl Gegner ✔ |
| `AWS_Alien_Energy` | Byte bzw. Wort | Treffer bis zur Zerstörung ✔ |
| `AWS_Alien_Bad_F`, `AWS_Alien_Bad_GF` | Byte | Schussrate (Durchläufe zwischen zwei Schüssen) und welcher Gegner schießt (jeder n-te; 0 = keiner, dann Rate `$FF`) ✔ |
| `AWS_Pal_Mod_Lin0` … `Lin5` | Byte | für welche der 6 Farbbänder des vorderen Playfields die Farben gelten (−1 = nicht) ✔ |
| `AWS_Pal_Mod_Col1` … `Col7` | Wort | Farben 1–7 des vorderen Playfields, solange die Welle läuft (`-1` = unverändert) ✔ |

Die Kommentare neben den Strukturen (z. B. `* 2934($A76)  368`) sind vermutlich Positionsangaben ❓.

## Objektnamen

Die Namen sind französisch. Übersetzungen nach Wortsinn ❓, Verhalten noch nicht geprüft.

**Präfixe ❓:** Viele Namen beginnen mit Buchstabenfolgen aus D, G, H, B, M, P, S, C (`DGDP_`, `DGMP_`, `DGS_`,
`GDDP_`, `BHBH_`, `BDGD_` …). Vermutlich kodieren sie Bewegungsbahnen (D = droite/rechts, G = gauche/links,
H = haut/oben, B = bas/unten). Objekte mit `R_` haben vermutlich eigene Verhaltensroutinen.

### Level 1 – Meer (`Ag_Game_LMER.s`)

🌐 Sturm über dem Meer mit Regen, Wellen und Mond. Endgegner laut einer Rezension: eine unbewegliche Eisskulptur in
Form eines Delfins, die Kugeln und Murmeln schießt.

✔ Objekte (Anzahl Starts): `Poisson_1–3` und `Poisson_Bl_1–3` (Fische, zusammen 62), `R_Araignee` (Spinne, 8),
`DGDP_Fantome`/`Fantome2` (Gespenster), `R_Sol_Crache` (Boden-Spucker), `DGDP_Full_7c_1–4`, `DGDP_Feuillage_7c`
(Laub), `R_Rapide` (schnell), `DGS_Bestiolle`, `DGDP_Bestiolle_1/2` (Viecher), `R_Volant_Grossi` (fliegend,
wachsend), `R_Tir_Etoile` (Sternschuss), `DGDP_Grosse_Tete` (großer Kopf), `R_Transporteur`, `…_Boulle` (Kugeln),
`R_Spectre`, `R_Bomber`, `R_Volant_missile`, `R_Final`. Außerdem 8 Einträge `Demo_Page` (nur im Demo-Modus).

✔ Gegner mit eigener Routine (Code im Level-Abbild ab `$4E9F0`; Disassembly `work/disasm/sea_rout.txt`, die ab
`$4ED50` wegen eingestreuter Daten aus dem Takt gerät – einzelne Routinen besser mit `tools/analysis/disasm68k.py
game/public/data/level/sea.game.bin 0x30f34 <von> <bis>`), Adresse und Starts: `R_Spectre` `$4E9F0` (1), `R_Bomber`
`$4EC00` (1), `R_Tir_Etoile` `$4ED70` (2), `R_Transporteur` `$4EFC8` (1), `R_Sol_Crache` `$4F19A` (4),
`R_Volant_Missile` `$4F2F2` (1), `R_Volant_Grossi` `$4F696` (3), `R_Jumper` `$4F75E` (0, nie gestartet),
`R_Araignee` `$4F81C` (8), `R_Rapide` `$4F8EE` (3), `R_Final` `$4FA3A` (1). (Bis 08.10.2026 stand hier irrtümlich
`R_Jumper` bei `$4F696`.)

✔ Reihenfolge in der Startliste (Wartemarke `Level_X`, Bild ≈ 13.193 + `Level_X` bei ungestörtem Lauf): `R_Sol_Crache`
576/640, `R_Araignee` 1024–1280, `R_Transporteur` 1600 (Bild 14.793), `R_Tir_Etoile` 3685, `R_Spectre` 3968,
`R_Rapide` 4160/4192/4224, `R_Tir_Etoile` 4560, `R_Bomber` 5920, `R_Volant_Grossi` 7360–7584, `R_Araignee` und
`R_Sol_Crache` 7744–8128, `R_Volant_Missile` 8704, `R_Final` 8944.

Übertragen und gegen das Original geprüft (07.10.2026):
- `R_Sol_Crache` (Pflanze am Boden, Parameter Feuerrate): erscheint rechts (x 256 + 320, y 256 + 190, Energie 8) und
  wandert mit dem Boden 2 Pixel je Durchlauf nach links, bis x 200; Animation jedes zweite Mal. Alle Feuerrate
  Durchläufe spuckt sie einen Feuerball (Energie 2), der 38 Durchläufe lang einem Bogen aus `Sin_Table2` folgt.
- `R_Araignee` (Spinne, Parameter Start-y und Schritt): kommt von rechts (x 256 + 340, Energie 10), wandert nach links
  und läuft dabei an ihrem Faden zwischen y 150 und 340 auf und ab.

Übertragen, gegen das Original noch ungeprüft (08.10.2026; Ablauf in `routines.ts`, Kern-Tests `routines.test.ts`):
- `R_Transporteur` (Parameter Launch_X): großer, unverwundbarer Gegner (x 256 + 320, y 144 + 256), 1 Pixel je
  Durchlauf nach links. Bei x = Launch_X setzt er zwei Wellen kleiner Gegner ab (`R_T_Transporteur1/2`, absolute
  Bahnen, bei x − 4, y 138 + 256), vibriert dann, explodiert nach 150 und endet nach 175 Durchläufen.
- `R_Tir_Etoile` (Launch_X, Pos_Y; Energie 50): Monster, 2 Pixel je Durchlauf nach links; bei Launch_X fliegen acht
  Schüsse (`Obj_Tir_1–8`, Energie 10) sternförmig mit 3 Pixel Abstand je Durchlauf auseinander, das Monster zieht
  davon. Ende ab x ≤ 224.
- `R_Spectre` (Launch_X, Fire_Rate, X_Speed, Y_Speed): Phiole (Energie 5), aus der bei Launch_X ein Gespenst
  (Energie 2, schießt mit Fire_Rate) steigt, das danach der Eule folgt; Ende nach 200 Durchläufen oder wenn die
  getroffene Phiole x < 200 erreicht.
- `R_Rapide` (Animation, Tempo, Palette, y): schneller Gegner (Energie 3) von rechts nach links.
- `R_Bomber`: Sack (Energie 15), der alle 24 Durchläufe eine von bis zu vier Kugeln (Energie 3) entlang `Sin_Table1`
  fallen lässt.
- `R_Volant_Grossi` (y, Tempo; Energie 10): Bild wechselt mit der Energie (`Obj_Grossi_1–3`); `R_Jumper` ist im Code
  eine Kopie mit fester Höhe und ohne Palettenzähler, in Level 1 nicht gestartet.
- `R_Volant_Missile` (Energie 20): folgt der Eule 35 s lang und feuert alle 200 Durchläufe einen gelenkten Schuss
  (Energie 10), der waagrecht und senkrecht auf die Eule zusteuert und nach 175 Durchläufen explodiert; nach 45 s Ende.
- `R_Final` (Endgegner, Energie 130, Schussrate 30): startet alle 70 Durchläufe abwechselnd eine von drei
  Kugelwellen, blitzt bei Treffern; zerstört folgt eine Explosion in Schritten (Geräusche, Feuer-Palette, vorderes
  Playfield gelöscht) bis `Clean_Up` (Levelende).

✔ Eigenheiten des Originals (nachgebildet): Wellen aus Routinen (`R_Transporteur`, `R_Final`) setzen Energie und
Schussrate für 32 statt 16 Gegner und schreiben damit in die folgende AWO-Bank; `R_Bomber` meldet keine Palette an,
verringert beim Ende den Palettenzähler nicht und rückt in seiner Kugelschleife eine Kugel zu weit vor (bei vier
Kugeln das obere Byte von `R_B_Mode`); `R_Volant_Missile` und `R_Jumper` melden ihre Palette ohne Zähler an. Im
Abbild setzt `R_Final` `Quit_Delay` = 100 schon im ersten Explosionsschritt (Quelltext: 25 im letzten).

### Levelende ✔

Aus Quelltext und Abbild (`Ag_Sprites.s`, `Agony_Parent_.s`; Nachbau 08.10.2026, gegen das Original noch ungeprüft):

- Solange `Quit_Delay` ≠ 0 ist, überspringt der Copper-Interrupt Joystick (die Eule steht, `$4412`), Äxte und
  Zaubermenü; das Kollisionsrechteck der Eule wird weiter geschrieben. Ein Treffer setzt `Die`, die Todesfolge (MAIN
  CHAR DIE) läuft aber nicht, also kein Lebensverlust. Feuer startet weiter Schüsse (O-015).
- Die Hauptschleife zählt `Quit_Delay` je Durchlauf um 1 herunter; bei 1 folgt EXIT LEVEL (`$3A78`): Zauber aus,
  `Stop`, `Die` gelöscht. Ohne Leben lädt das Spiel das Menü (`igt`), mit Leben das Ladebild des nächsten Levels
  (Level 1: `FILE_2_4` = `load_forest`, `Agony.0A`). Währenddessen steht das Bild, nur der Copper-Interrupt läuft;
  danach blendet `SetFade` die vier Farbbereiche aus, 50 Bilder Wartezeit, Interrupts und DMA aus, Sprung ins
  Ladebild bei `$61500` (Level 6: `FILE_0_5` bei `$600`).
- Bei 100 aus `R_Final` dauert das Levelende 98 Durchläufe der Hauptschleife; im Erkundungslauf des Nachbaus
  (`explore-level.ts`) von Bild ≈ 23.172 bis 23.369.
- Nicht übertragen: die Tastatur (Abbruch per Taste und „Level überspringen“ setzen `Quit_Delay` = 20 und `Clean_Up`,
  `$5E22`/`$5E3E`).

❓ Folgen der 32er-Schleife, wenn die Bank dahinter schon belegt ist (Energie und Status laufender Gegner würden
überschrieben); ❓ `R_Final`: Wird er zerstört, bevor alle drei Wellen gestartet sind, schreibt Schritt 19 über einen
leeren Zeiger (`R_F_AWO_Ptr` = 0) nach Adresse 0 – ob das im Original vorkommen kann und was es bewirkt, zeigt erst die
Aufnahme.

Die Routinen melden (bis auf die genannten Ausnahmen) eine eigene Palette an (`Rout_Pal_Ptr`, Zähler
`Rout_Mod_Pal_Counter`), die über die Farben der Wellen gelegt wird; die letzte endende Routine stellt die Palette des
Levels wieder her.

### Level 2 – Wald (`Ag_Game_LFORET.s`)

🌐 Rezensionen beschreiben braune Gegner, die in acht Richtungen schießen, und einen Endgegner mit Bumerangs.

✔ Objekte: `R_Rapide` (41), `R_Spectre`, `R_Araignee`, `DGDP_Full_7c`, `DGDP_Feuillage_7c`,
`…_Bestiolle_1–5`, `R_Kamikaze`, `R_Sol_Etoile`, `R_Tir_Etoile`, `…_Batman` (fledermausartig ❓),
`R_Volant_missile`, `R_Final`, `Demo_Page` (9, nur im Demo-Modus).

✔ Startliste im Abbild (`$4AF44`, 116 Einträge, letzter `WAIT $22F0` startet `R_Final`). Routinen nach Adresse:
`R_Spectre` `$4B76C`, `R_Tir_Etoile` `$4B964`, `R_Volant_Missile` `$4BB60`, `R_Araignee` `$4BEE4`, `R_Rapide`
`$4BFA2`, `R_Kamikaze` `$4C048` (erster Start bei `WAIT $170`), `R_Sol_Etoile` `$4C160`, `R_Final` `$4C39E`. Level 2
hat keinen Regen. Die Startliste enthält ein `WAIT $E00` nach `WAIT $E40` (wirkt sofort, da `Level_X` schon größer ist).

✔ Unterschiede der aus Level 1 bekannten Routinen (Quelltext und Abbild verglichen, `work/disasm/forest_rout.txt`):
- `R_Spectre`, `R_Tir_Etoile`, `R_Araignee`: keine eigene Palette (MODE 0 ohne `Rout_Pal_Ptr`/`Rout_Mod_Pal_Counter`);
  CLOSE verringert den Zähler nicht, stellt aber die Palette des Levels wieder her, wenn er 0 ist. `R_Araignee` ohne
  `R_A_Anim_Step`, Richtung daher bei +2 statt +4. Objekte: Phiole `$300`, Gespenst `$312`–`$35E`, Monster `$54E`
  (Animation `$4B952`), Schüsse `Obj_Tir_1–8` `$416`–`$494`, Spinne `$3F4`.
- `R_Volant_Missile`: Palette auskommentiert wie in Level 1 (dort aber gesetzt), der gelenkte Schuss fliegt 1 statt
  3 Pixel je Durchlauf; Monster `$4A6`/`$4BC`.
- `R_Rapide`: Energie 2 statt 3; MODE 0 erhöht `Rout_Mod_Pal_Counter`, setzt aber keine Palette (der Parameter
  `Dummy_Pal` bleibt ungelesen); CLOSE wie in Level 1. Animation `Anim_Speedy` = `$4CE`, `$4EA`.
- Übertragen als Felder der Routinen-Definitionen (`layout.ts`, `FOREST.routines`), gegen das Original ungeprüft.

✔ Neue Routinen von Level 2 (Quelltext und Abbild stimmen überein; beide ohne eigene Palette, CLOSE ohne Zählerabzug):
- `R_Kamikaze` (`$4C048`–`$4C136`, Drache `Obj_Kamikaze` `$2EE`, Energie 20): erscheint rechts oberhalb des Bilds
  (x 256 + 300, y 200) und hält bis zur Zeit `P_VK_Launch_Time` auf Eule + (150, 40) zu, je Durchlauf um
  `P_VK_X_Speed` bzw. `P_VK_Y_Speed`, solange der Abstand größer als der Schritt ist. Danach steht er; ab
  Launch_Time + 50 fliegt er mit 8 Pixel je Durchlauf nach links, Ende ab x ≤ 200. Parameter in der Startliste
  meist 175, 2, 2 (einmal 175, 1, 1). `R_VK_Target_X/Y` sind belegt, aber ungenutzt.
- `R_Sol_Etoile` (`$4C160`–`$4C2B4`, `Obj_Sol_Etoile_1–10` `$614`–`$6BA`, Animation `R_SE_Shape` `$4C138` mit je
  zwei Durchläufen pro Bild, Energie 10): wandert am Boden (x 256 + 300, y 256 + 191) mit 2 Pixel je Durchlauf nach
  links, Ende ab x ≤ 200. Unversehrt und links von `P_SE_Launch_X` (meist 256 + 150, einmal 256 + 130) belegt es die
  nächsten drei Gegner der Bank mit `Obj_Tir_1`/`_2`/`_8` (Energie 10) und lässt sie vom Startpunkt aus mit 3 Pixel
  je Durchlauf nach oben, oben rechts und oben links fliegen; das Monster wandert weiter.
- Der Quelltext hat bei `WAIT $12D0` (zweiter Kamikaze mit 175, 1, 1) kein `PAR_END`; das Abbild schon (`$FFFF` bei
  `$4B24E`), die Startliste läuft also normal weiter.
- Übertragen in `routines.ts` (`kamikaze`, `solEtoile`), gegen das Original ungeprüft.

### Level 3 – Sumpf (`AG_GAME_LMARAIS.S`, Wellen-Parameter in `lmarais_rtr.s`)

🌐 Laut einer Rezension hat ein Endgegner einen blitzschnellen, sofort tödlichen Zungenangriff (Zuordnung zu
Level 3 unsicher).

✔ Objekte: `R_Jumper` (Springer), `R_Sol_Kamikaze`, `R_Rapide`, `R_Kamikaze`, `DGDP_Monster_1–4` und weitere
`…_Monster`, `Rond_Monster` (rund), `R_Sol_Crache`, `R_Spectre`, `R_Sol_Etoile`, `R_Tir_Etoile`,
`R_Volant_missile`, `R_Transporteur`, 19 relative Bahnen `Awsrt0–18`, `R_Final`.

### Level 4 – Berge (`AG_GAME_LMONTAGNES.S`, Wellen-Parameter in `lmontagnes_rtr.s`)

🌐 Eine wackelige Hängebrücke über einem Abgrund, dahinter ein Baum; Ruinen und Wasserfälle.

✔ Objekte: `R_Sol_Guide` (gelenkt, 18), `…_Plasma` (mehrere Varianten), `…_Cristal` (Kristall),
`R_Sol_Kamikaze`, `R_Volant_missile`, `R_Dragon` (Drache), `R_Colonne_Flamme` (Flammensäule), `R_Araignee`,
`…_Boulle`, `Pont_Boulle` (Brücke + Kugel – passt zur Hängebrücke), `R_Bomber`, relative Bahnen `Awsrt…`, `R_Final`.

### Level 5 – Hochland (`Ag_Game_LPLATEAUX.s`)

🌐 Fortsetzung mit Grabsteinen; einer trägt als Gag die Aufschrift „Bitmap Brothers 1989–1992“ (Zuordnung zu Level 5
laut einer Rezension).

✔ Objekte: `R_Rapide` (56), `R_Volant_accelaire` (fliegend, beschleunigend), `R_Sol_Guide`, `R_Sol_Crache`,
`Saut_Diable`/`Saut_Diable_2` (springende Teufel), `…_Diable…` (Teufel), `…_Squelette…` (Skelette), `DGDP_Tete`
(Köpfe), `R_Sol_Kamikaze`, `R_Dragon`, `R_Spectre`, `R_Tir_Etoile`, `R_Kamikaze`, `R_Sol_Etoile`,
`R_Volant_missile`, `R_Final`.

### Level 6 – Feuer (`Ag_Game_LFEUX.s`)

✔ Objekte: `R_Rapide` (71), `R_Sol_Etoile`, `R_Volant_accelaire`, `R_Sol_Guide`, `…_Monster_Gaz` (Gas-Monster),
`DGDP_Piaf` (Vögel), `DGDP_Monster_Fire`, `…_Monster_All`, `…_Tete`, `Serp1–6` mit `Serp1_Tete–Serp6_Tete`
(Schlangen mit Köpfen), `R_Colonne_flame`, `R_Dragon`, `R_Kamikaze`, `R_Tir_Etoile`, `R_Volant_missile`, `R_Final`.

## Quellen

- Quellcode: `Agony_Parent_.s`, `DISK/load_label.s`, `Ag_Game_L*.s`, `l*_rtr.s` (siehe [Quellcode](../quellcode.md))
- Super Adventures in Gaming: http://superadventuresingaming.blogspot.com/2012/09/agony-amiga.html
- Hardcore Gaming 101: https://www.hardcoregaming101.net/agony/
- Aminet-Rezension (1992): https://ftp.fau.de/mirrors/aminet/docs/rview/Agony.txt
