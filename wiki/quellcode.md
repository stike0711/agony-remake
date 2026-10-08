# Quellcode

Stand: 07.10.2026

Landkarte des Original-Quellcodes. Bisher auf Datei-Ebene; Routinen, Variablen und Datenstrukturen werden hier
nach und nach ergänzt (Fahrplan-Schritt 2).

## Herkunft und Lizenz

- Yves Grolet hat am 04.07.2020 ein Backup seiner letzten Amiga-Festplatte veröffentlicht (Ankündigung auf Facebook,
  Upload über WeTransfer). Aminet hat daraus urheberrechtlich unklare Dateien entfernt und das Archiv als
  `game/shoot/YvesGrolet-sources.zip` bereitgestellt (07.07.2020).
- Lizenz laut Grolet: „You can do whatever you want with those sources excepting commercial use“.
- Geladen am 05.10.2026: `reference/source/YvesGrolet-sources.zip` (20.908.907 Byte) und `.readme`; entpackt nach
  `reference/source/YvesGrolet-sources/` (946 Dateien, 42,1 MB).
- **Ausnahme:** Jeroen Tels Audio-Treiber und Musikdaten haben einen eigenen Copyright-Vermerk, siehe
  [Audio](original/audio.md).

## Allgemeines

- 68000-Assembler im Format von **Devpac** (`OPT`, `INCDIR`, `SECTION Chip,Code_c`, `EQUR`). Devpac liegt als
  `dev_util/Devpac/` bzw. Disk-Image `DevPack1.adf` bei.
- Kommentare überwiegend englisch, Bezeichner oft französisch (`Poisson` = Fisch, `Feux` = Feuer, `Tir` = Schuss).
- Jeder Modul-Kopf: „by ART & MAGIC“, Artwork Franck Sauer und Marc Albinet, Coding Yves Grolet, Datum 25/06/1990.
- Register-Konventionen in `Agony_Parent_.s`: `C EQUR a6` und `D EQUR a5`. ❓ Vermutlich zeigt `a6` auf die
  Custom-Chips (`Bltcon0(C)` usw.) und `a5` auf einen Datenbereich (`Life(D)`, `Sprites_Struct(D)`).
- Auf dem PC lassen sich die Quellen vermutlich mit vasm assemblieren (`vasmm68k_mot -devpac`) – noch nicht
  versucht. Hindernis: Die per `INCBIN` eingebundenen Rohdaten fehlen.

## Verzeichnis-Landkarte

```
YvesGrolet-sources/
├─ YvesHDD/
│  ├─ Work HDD partition/
│  │  ├─ Agony/              ★ Hauptquellcode (jüngster Stand)
│  │  │  ├─ DISK/            Bootblock, Loader, Ladetabelle, Installer, Disk-IDs
│  │  │  └─ UTIL/            Editoren in GFA-Basic
│  │  ├─ Global/             gemeinsame Includes und Hilfsroutinen
│  │  ├─ Arny's_Dreams/, Av/, SpellSinger/   andere Projekte
│  └─ Corupted system HDD partition partialy restored/
│     ├─ ag/                 ★ fertige Spieldateien (Grolets Packer)
│     ├─ dev_util/           Devpac, Packer
│     └─ s/, Sound_Util/, Present/ (leer)
└─ YvesDisks/
   ├─ PC_Files/
   │  ├─ AgonyDosBoot/       ★ ältere Sicherung, aber mit Level-Modulen und Musikquellen
   │  ├─ AgonyIntro/         ★ Jeroen Tels Musik + 8SVX-Samples
   │  ├─ AgonyDemoDosBackup/ ★ Demo-Fassung mit ProTracker-Modulen
   │  └─ ArnysDream/, c64Tunes/, DMADOS/, FlorenceAudioMonsters/, GlobalBack/, HardDiskBackUtil/,
   │     Maxiplan/, MON1/, NoLabel04/, Scroll6PlansDosBack/, TFMX/, UnrealMusic*/, Utilities/   andere Projekte/Werkzeuge
   └─ Amiga_Disks/           31 Disk-Images (Inhalte von PC_Files als ADF und weitere Disks)
```

★ = für Agony relevant.

## Hauptquellcode `YvesHDD/Work HDD partition/Agony/`

| Datei | Größe | Modul (laut Kopf) | Inhalt |
|---|---|---|---|
| `Agony_Parent_.s` | 41.741 | MAIN MODULE | Hauptmodul, Assemblier-Schalter, bindet alles ein, Level-Wechsel, Game Over |
| `Ag_Copper_List.s` | 104.285 | COPPER LIST | Copperlisten (Farbverläufe, Paletten, Display-Aufbau) |
| `Ag_Back_Scroll.s` | 9.469 | BACK SCROLL | hinteres Playfield |
| `Ag_Front_Scroll_.s` | 5.025 | FRONT SCROLL | vorderes Playfield |
| `Ag_Object_.s` | 31.995 | OBJECTS MODULE | Objekte und Gegner |
| `Ag_Playability_.s` | 14.792 | GAME MODULE | Spielmechanik |
| `Ag_Playability_old.s` | 14.626 | GAME MODULE | ältere Fassung (gleich groß wie die in `AgonyDosBoot`) |
| `Ag_Sprites.s` | 36.024 | – | Sprites (Eule, Schüsse, Regen) ❓ |
| `Ag_Status.s` | 5.982 | STATUS LINE | Statuszeile |
| `Ag_Alien_Fire.s` | 7.670 | ALIEN FIRE MODULE | Gegnerschüsse |
| `Ag_Sounds.s` | 1.818 | SOUNDS MODULE | Soundeffekte |
| `Ag_Pt_Player.s` | 25.265 | PT MODULE PLAYER | ProTracker-Abspieler |
| `Ag_Pre_comp.s` | 3.345 | PRECOMPUTE MODULE | Vorberechnungen, z. B. Masken für 8-farbige Sprites per Blitter |
| `back.sh` | 104 | – | Shell-Skript |

### `Agony_Parent_.s` – bisher bekannt

- **Assemblier-Schalter:** `Debug` (1 = Debug-Fassung), `Asm_Level` (1–6, welches Level), `Asm_Vdo_Mode`
  (0 = PAL, 1 = NTSC; im HDD-Stand auf 1 gesetzt), `Asm_Absolute` (0 = verschiebbar, 1 = `ORG $600`),
  `Asm_Demo_Mode` (0 = aus, 1 = aufnehmen, 2 = abspielen), `Asm_Protect`, `ASM_Restart`.
- **Includes in dieser Reihenfolge:** `Global/Preset.s` bzw. `Preset_ntsc.s`, `Disk/Load.s`, Label-Dateien der
  Level (`Game/L*.lab`, `.alb`), `Ag_Pre_Comp.s`, `Ag_Front_Scroll_.s`, `Ag_Back_Scroll.s`, `Ag_Object_.s`,
  `Ag_Playability_.s`, `Ag_Status.s`, `Ag_Sounds.s`, `Ag_Alien_Fire.s`, `Ag_Sprites.s`, Leveldaten per `INCBIN`
  (`LMer/` … `LFeux/`), Musik (`Muzack/…`), Level-Module (`Game/Ag_Game_L*.s`), Präsentationstexte und Fonts
  (`Present/…`), zuletzt `Ag_Copper_List.s`.
- **Level-Ende:** lädt je nach `ASM_Level` die nächste Ladebild-Datei (`FILE_1_4` = `load_forest` nach Level 1 …)
  bzw. nach Level 6 `FILE_0_3` = `ending`, blendet aus (`SetFade`), wartet 50 Bilder (`Delay_Count`), schaltet
  Interrupts und DMA ab und springt über `$80` in die neue Datei (siehe [Dateiformate](dateiformate.md)).
- **Game Over:** `tst Life` / `beq Game_Over` → lädt `FILE_1_1` = `igt` (Menü).
- **Variablen (Auswahl):** `Life`, `Die`, `Curent_Spell`, `Stop`, `Delay_Count`, `Load_Buffer`,
  `Sprites_Struct`, `Sprites_Mask`.
- **Tastatur-Interrupt** (ab „KEYBOARD INTERRUPTION“): `$19` P = Pause (`Do_pause`), `$40` Leertaste = Zaubermenü,
  `$45` ESC = Abbruch, `$37` M = `Change_Mode` (schaltet `Menu_Mode` um). Nur mit gesetztem `Sheet_Flag`
  (Cheat „FANTASY“ im Menü): Return = `Sheet_Next` (Level beenden), F1–F4 = Äxte, Zauber, Waffenstufe, Punkte
  (Tabelle in [Ablauf bis Level 1](original/startsequenz.md#cheat-fantasy)).

### Hauptschleife und Interrupts ✔

Kartiert am Level-1-Abbild `sea` (Adressen) und nachgebaut in `game/src/core/level/` (E-032):

- **Init** (`Code_Start`/`Restart`, `$600`–`$AD0`): Interrupts und DMA aus, Audio und `MUSIC_INIT`, `Ag_Pre_Comp.s`
  (Masken für Objekt-Sprites), dann Variablen, Muster und Farben des hinteren Playfields, Zeiger der Statuszeile,
  Startliste, Löschen der Laufzeitpuffer, Text 13 („PRESS FIRE TO START“), `Stop` gesetzt. „LET'S GO“ setzt die
  Copperliste, die Interrupt-Vektoren (`$6C` → `Int3`, `$70` → `Int4`) und `DMACON $87E0`.
- **`Main_Loop`** (`$AD0`) läuft mit 25 Hz: wartet, bis `Gen_25hz_Phase` 2 erreicht; dann Copperliste aktualisieren
  (Zeiger der Bitplanes, `BPLCON1`), `Ag_Front_Scroll_.s`, `Ag_Back_Scroll.s`, „SEARCH SHORT PHASE“ (Strahlposition
  im Vergleich zur letzten Schleife), `Ag_Object_.s`, `Ag_Playability_.s`, `Ag_Status.s`, `Ag_Sounds.s`; dann
  `AF_Wait_Phase`/`AF_Wait_Synch` (nächster Copper-Interrupt, dann Rasterzeile `$40`–`$100`), `Ag_Alien_Fire.s`,
  Seitenwechsel des vorderen Playfields, „BEGIN TO START“ (Blinken von „PRESS FIRE TO START“ alle 10 Schleifen, Feuer
  startet), Aufräumen, Tasten, `Quit_Delay`.
- **`Int3`** (`$4392`), zwei Quellen: Vertical Blank → `Delay_Count` und `MUSIC_PLAY`; Copper-Interrupt am Ende der
  Copperliste → `Gen_25hz_Phase` + 1, `Ag_Sprites.s` (Eule, Schuss, Äxte, Zaubermenü, Zauber, Tod, Bonus,
  Gegnerschüsse, Sprite-Zeiger), Verzögerung des vorderen Playfields, Regen (Level 1). Hinkt die Hauptschleife
  (`Gen_25hz_Phase` ≥ 3), fällt dieser Teil aus.
- **`Int4`** (`$5BD0`): Ende eines Soundeffekts auf Kanal 0.
- **Tod, Zauber, Spielende** ✔ (07.10.2026): SPELL TIME (`$4C04`, BCD mit `sbcd` nur im unteren Byte), SPELL
  ROUTINES (`$4C38`, Zauber 6 SHIELD `$52CC`), MAIN CHAR DIE (`$54EA`), CLEAN UP (`$39C2`), QUIT DELAY und EXIT LEVEL
  (`$3A5E`/`$3A78`; ohne Leben lädt es `igt`, sonst das nächste Ladebild). Die Warteschleife vor Teil 2 (`$34E8`)
  wartet auf `Gen_25hz_Phase` ≥ 1 und Zeile 64–256.
- **Gegner-Routinen** ✔: Code im Block `game` ab `$4E9F0` (Disassembly `work/disasm/sea_rout.txt`), dazwischen ihre
  Paletten und Animationstabellen. Die Engine ordnet die Code-Adresse über `LevelLayout.routines` der Umsetzung in
  `routines.ts` zu.
- **Gegner** ✔ (07.10.2026): `Ag_Pre_comp.s` (`$674`), `Ag_Object_.s` (`$149C`–`$29D2`: Zurücksetzen, ALIEN BANK
  CTRL, Zeichnen mit N/H/V-Blit-Routinen), `Ag_Playability_.s` (`$29D2`–`$3194`: Startliste, Bahnen, Paletten,
  Kollisionen, Routinenverwaltung), `Ag_Alien_Fire.s` (`$3514`–`$3916`), `Sound_Start` (`$5C12`). Die Release-Fassung
  weicht vom HDD-Quelltext ab, z. B. ohne Pause-Abfrage im Kollisionstest und mit `Clean_Up` an anderer Stelle;
  maßgeblich ist die Disassembly. Strukturen in [Dateiformate](dateiformate.md#weitere-laufzeitstrukturen-).

### `DISK/`

| Datei | Inhalt |
|---|---|
| `BootBlock.s`, `BootBlock2.s`, `OldBootBlock.s` | Bootblock; Liste der ausgelieferten Versionen mit Seriennummern |
| `load.s`, `old_load.s` | Lader für das eigene Diskformat; außerdem der Block „RESIDENT LABEL“ mit den gemeinsamen Variablen ab `$1B0` (`Score`, `Life`, `Sheet_flag` …, Tabelle in [Dateiformate](dateiformate.md#gemeinsame-variablen-1b0)) |
| `load_label.s` | Ladetabelle aller Dateien (siehe [Dateiformate](dateiformate.md#original-diskformat-ordilogic-disk-filing-system)) |
| `Ols_file_instalator_v1.5.s`, `…_spec.s` | Installer: schreibt die Dateien `dh0:ag/…` auf die Disketten |
| `install_Ag_info.s`, `CREATE_LABEL.GFA` | erzeugen Disk-Infos bzw. die Ladetabelle |
| `Insert_Disk.s`, `insert_disk.*` | „Insert Disk“-Anzeige |
| `boot.s`, `boot`, `boot.pp`, `decrunch.bin` | Startcode, Entpackroutine |
| `DISKID0`–`3` | Disk-Kennungen `ur00`–`ur03` |
| `loadtest*.s`, `test_boot*.s` | Tests |

### `UTIL/` – Editoren in GFA-Basic

`ATTACK_WAVE_EDITOR.GFA` (Angriffswellen), `BACK_EDITOR.GFA` und `FRONT_EDITOR.GFA` (Hinter-/Vordergrund),
`OBJECT_EDITOR.GFA` (Objekte), `TRACK_EDITOR.GFA` (Bahnen), `SKY_CONVERT.GFA` (Himmel), `TIR_CONVERT.GFA`
(Schüsse), `MINI_TRACKER.GFA`, `PRINT_MAP_MODEL.GFA`, `FILESELECT.GFA`, dazu `TEXT_PALETTE.LST` und `c_mask.s`.
GFA-Basic-Dateien sind binär (Kennung `GFA-AMIGAB`); um sie zu lesen, braucht es einen GFA-Basic-Lister ❓.

## `Global/`

`Preset.s` / `preset_ntsc.s` (Grundeinstellungen PAL/NTSC), `decrunch.s`, `decrunch2.s`, `decrunch_am.s`,
`asm_decrunch.s` (Grolets Entpacker), `Byte_Sort.s`, `find_ddfstrt.s`, `joy.s` (Joystick-Test), `keyboard.s`,
`mus.s`, `power.s`, außerdem `LF_CODE.GFA` und `STICKERS.GFA`.

## Level-Module `YvesDisks/PC_Files/AgonyDosBoot/`

| Datei | Größe | Level |
|---|---|---|
| `Ag_Game_LMER.s` + `lmer_rtr.s` | 68.975 + 3.363 | 1 Meer |
| `Ag_Game_LFORET.s` + `lforet_rtr.s` | 53.510 + 3.363 | 2 Wald |
| `AG_GAME_LMARAIS.S` + `lmarais_rtr.s` | 45.095 + 13.124 | 3 Sumpf |
| `AG_GAME_LMONTAGNES.S` + `lmontagnes_rtr.s` | 37.813 + 10.849 | 4 Berge |
| `Ag_Game_LPLATEAUX.s` + `lplateaux_rtr.s` | 65.783 + 3.198 | 5 Hochland |
| `Ag_Game_LFEUX.s` + `lfeux_rtr.s` | 69.934 + 3.198 | 6 Feuer |

- Aufbau eines Level-Moduls: Makros (`Wait`, `SL_End`, `Start_R`, `Start_A`, `Start_C`, `Par`, `Par_l`, `Par_End`),
  dann `Start_List` (Angriffswellen), `SL_END`, `INCLUDE Game/L…_Rtr.s` (relative Bahnen), danach die
  Strukturen der absoluten Bahnen (`Poisson_Bl_1` …), Animationen (`Anim_…`), Bahntabellen (`TX_…`, `TY_…`) und
  Objekte mit eigenen Routinen (`R_…`). Details in [Level](original/level.md).
- `Demo_Page`-Einträge stehen in `IFNE ASM_Demo_Mode=2`-Blöcken und fehlen in der Release-Fassung.
- Außerdem in diesem Ordner: ältere Fassungen der Hauptmodule, `00 Agony Audio Sequ.S`, `Audio_Drivers.s` und
  `Forest.s` (Musik), `boot.s`, `load.s`, `load_label.s` (abweichende Ladetabelle, offenbar für ein geplantes
  Intro mit Bildern wie `Pics:sequ.5/Alestes.cbm` ❓).

## Versionen

Die Hauptmodule liegen in zwei Ständen vor:

| Datei | `Work HDD partition/Agony/` | `AgonyDosBoot/` |
|---|---|---|
| `Agony_Parent_.s` | 41.741 (mit NTSC-Option) | 40.780 |
| `Ag_Copper_List.s` | 104.285 | 101.411 |
| `Ag_Sprites.s` | 36.024 | 34.598 |
| `Ag_Playability_.s` | 14.792 | 14.626 |
| `Ag_Alien_Fire.s` | 7.670 | 7.618 |
| übrige Module | gleich groß | gleich groß |

Der HDD-Stand ist jünger: Seine Datei `Ag_Playability_old.s` ist genau so groß wie die Fassung in `AgonyDosBoot`.
Die Release-Fassung der Spieldaten kann trotzdem von beiden abweichen; maßgeblich sind die Binärdaten.

## Was fehlt

- Rohdaten der Level (`WORK:Agony/LMer/` … `LFeux/`), eingebunden per `INCBIN`
- die meisten Musik-Includes (`Muzack/Sea&Fire.s`, `Marshes&Highlands.s`, `Mountains.s`)
- generierte Label-Dateien `Game/*.lab`, `*.alb`
- `Present/` (Texte `Level_Sea.txt` …, Fonts `Font.bin`, `Font_L.bin`)
- die Quelltexte von Präsentation (`present`), Menü (`igt`) und Ladebildern (`load_*`)

Diese Daten stecken in den fertigen Spieldateien und müssen dort herausgelöst werden. Für die fehlenden Programme
gibt es Disassemblies (`tools/analysis/disasm68k.py`, Ergebnisse in `work/disasm/`); ihr Ablauf ist in
[Ablauf bis Level 1](original/startsequenz.md) beschrieben.

## Nächste Schritte beim Kartieren

1. ~~Hauptschleife und Interrupt-Struktur in `Agony_Parent_.s` finden.~~ Erledigt (siehe oben).
2. ~~Objektstruktur und Bewegungslogik (`Ag_Object_.s`), Bahntabellen (`TX_`/`TY_`).~~ Erledigt für Level 1;
   Gegner-Routinen: `R_Sol_Crache` und `R_Araignee` übertragen (07.10.2026), die übrigen 9 von Level 1 offen.
3. Spielmechanik (`Ag_Playability_.s`): Schuss, Upgrades, Schwerter, Zauber, Leben, Punkte.
4. Zufallsgenerator finden.
5. Aufbau der Copperlisten (`Ag_Copper_List.s`) verstehen – für Level 1 erledigt ([Dateiformate](dateiformate.md#weitere-laufzeitstrukturen-)).
6. Für jedes Label die Adresse im Level-Abbild bestimmen (Basis `$600`) – Level 1 für alles bis zum Spielbeginn
   erledigt (`game/src/core/level/layout.ts`).
