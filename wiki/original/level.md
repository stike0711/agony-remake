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

✔ Gegner mit eigener Routine (Code im Level-Abbild ab `$4E9F0`, Disassembly `work/disasm/sea_rout.txt`), Adresse und
Starts: `R_Spectre` `$4E9F0` (1), `R_Bomber` `$4EC00` (1), `R_Tir_Etoile` `$4ED70` (2), `R_Transporteur` `$4EFC8`
(1), `R_Sol_Crache` `$4F19A` (4), `R_Volant_Missile` `$4F2F2` (1), `R_Jumper` `$4F696` (3), `R_Araignee` `$4F81C` (8),
`R_Rapide` `$4F8EE` (3), `R_Final` `$4FA3A` (1). Übertragen (07.10.2026):
- `R_Sol_Crache` (Pflanze am Boden, Parameter Feuerrate): erscheint rechts (x 256 + 320, y 256 + 190, Energie 8) und
  wandert mit dem Boden 2 Pixel je Durchlauf nach links, bis x 200; Animation jedes zweite Mal. Alle Feuerrate
  Durchläufe spuckt sie einen Feuerball (Energie 2), der 38 Durchläufe lang einem Bogen aus `Sin_Table2` folgt.
- `R_Araignee` (Spinne, Parameter Start-y und Schritt): kommt von rechts (x 256 + 340, Energie 10), wandert nach links
  und läuft dabei an ihrem Faden zwischen y 150 und 340 auf und ab.
Beide melden eine eigene Palette an (`Rout_Pal_Ptr`, Zähler `Rout_Mod_Pal_Counter`), die über die Farben der Wellen
gelegt wird; die letzte endende Routine stellt die Palette des Levels wieder her.

### Level 2 – Wald (`Ag_Game_LFORET.s`)

🌐 Rezensionen beschreiben braune Gegner, die in acht Richtungen schießen, und einen Endgegner mit Bumerangs.

✔ Objekte: `R_Rapide` (41), `R_Spectre`, `R_Araignee`, `DGDP_Full_7c`, `DGDP_Feuillage_7c`,
`…_Bestiolle_1–5`, `R_Kamikaze`, `R_Sol_Etoile`, `R_Tir_Etoile`, `…_Batman` (fledermausartig ❓),
`R_Volant_missile`, `R_Final`, `Demo_Page` (9, nur im Demo-Modus).

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
