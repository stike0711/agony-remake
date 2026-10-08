# Setup

Stand: 06.10.2026

## Umgebung

| Komponente | Version | Zweck |
|---|---|---|
| Windows 11 Home, PowerShell 7 | 10.0.26300 | Entwicklungsrechner |
| Node.js | 24.18.0 | Werkzeuge in TypeScript (führt `.ts` direkt aus), Emulator-Server, Vite |
| npm | 11.18.0 | Pakete |
| Python | 3.14.6 | Analyse-Skripte; Pakete `numpy`, `Pillow`, `capstone` 5.0.7 (68000-Disassembler, `pip install capstone`) |
| ffmpeg | 8.1.1 | Audio/Video (z. B. Dauer der MP3s, später Konvertierung) |
| Git | 2.54.0 | installiert, wird im Projekt nicht benutzt (Entscheidung E-006) |

Geplant: ein MacBook für die native iPadOS/iOS-App (siehe [unten](#native-app-geplant)).

Alle Werkzeuge sollen unter Windows, macOS und Linux laufen: Pfade mit `/` schreiben, keine festen Laufwerkspfade,
Skripte finden den Projektordner relativ zu ihrem eigenen Speicherort (Entscheidung E-016).

## Heruntergeladene Komponenten

| Was | Quelle | Ablage | Stand |
|---|---|---|---|
| Original-Quellcode | https://aminet.net/package/game/shoot/YvesGrolet-sources | `reference/source/` (Zip, Readme, entpackt) | geladen 05.10.2026, 20.908.907 Byte |
| vAmigaWeb | https://github.com/vAmigaWeb/vAmigaWeb.github.io (GPL-3.0) | `tools/emulator/vamigaweb/` | Commit `bd0d2e9519…` vom 10.09.2026, 63 Dateien, 17,4 MB, ohne `doc/` |

vAmigaWeb neu laden (der aufgelöste Commit landet in `vamigaweb/VERSION.txt`):

```bash
node tools/emulator/fetch-vamigaweb.ts
```

Eine bestimmte Version laden: `node tools/emulator/fetch-vamigaweb.ts <commit-oder-branch>`.

## Referenz-Emulator

### Starten

- In der Claude-Desktop-App: Vorschau „emulator“ (`.claude/launch.json`).
- Im Terminal:

```bash
node tools/emulator/server.ts
```

Danach im Browser `http://localhost:8090/agony` öffnen. Kickstart 1.3 und Disk 1 werden automatisch geladen.
Optionen: `--port <nr>` (Standard 8090), `--lan` (auch im Heimnetz erreichbar, z. B. fürs Tablet).

### Routen des Servers

| Route | Inhalt |
|---|---|
| `/agony` | Weiterleitung auf vAmigaWeb mit Startparametern (Disk 1, Kickstart 1.3, Joystick an Port 2) |
| `/local/kick13.rom` | Kickstart 1.3 rev 34.5 (A500), CRC32 `C4F0F55F`, aus `reference/agony/game/Kickstart Images (TOSEC-v0.03)/` |
| `/local/disks/<name>.adf` | Spieldisketten aus `reference/agony/game/Agony/` |
| `/local/dev-disks/<name>.adf` | Grolets Disketten aus `reference/source/…/YvesDisks/Amiga_Disks/` |
| `/local/tools/<datei>` | Hilfsskripte für den Browser aus `tools/emulator/browser/` (z. B. `agony-helpers.js`) |
| `POST /local/capture/<name>` | speichert den Request-Body nach `work/captures/<name>` |
| `GET /local/capture/<name>` | liefert eine Datei aus `work/captures/` (z. B. Schnappschüsse zum Laden) |
| alles andere | Dateien von vAmigaWeb |

Die Startparameter übergibt der Server als JSON im URL-Fragment (`#{"url":…,"kickstart_rom_url":…,"port2":true,…}`),
ausgewertet von `get_parameter_link()` in `vamigaweb/js/vAmiga_ui.js`.

### Ablauf bis zum Start von Level 1

1. Booten von Disk 1 (grauer Bildschirm, ca. 15 s).
2. Crystal-Intro: Seite 1 → Feuer an Port 2 oder linke Maustaste, Seite 2 → linke Maustaste (die Maustaste
   überspringt meist beide Seiten).
3. Laden, dann Titelsequenz (Psygnosis, Art & Magic, Agony).
4. „Insert Disk 2“ → Disk 2 einlegen.
5. Menü mit brennendem Baum und Abspann-Seiten → Feuer.
6. Story-Seite während des Ladens, dann Ladebild von Level 1 (steht, bis das Level geladen ist).
7. Level 1 wartet auf den Start → Feuer.

Ausführlich, mit Bildnummern: [Ablauf bis Level 1](original/startsequenz.md). Schneller geht es mit den
Schnappschüssen (unten).

### Hilfsfunktionen für Aufnahmen (`AG`)

`tools/emulator/browser/agony-helpers.js` stellt im Emulator-Tab `window.AG` bereit:

```js
await import("/local/tools/agony-helpers.js");   // nach Änderungen mit ?v=<n> neu laden (Modul-Cache)
AG.halt();               // normale Ausführung von vAmigaWeb anhalten, ab jetzt nur noch schrittweise
AG.step(150);            // 150 Emulator-Bilder ausführen (≈ 8× Echtzeit, auch bei ausgeblendetem Tab)
AG.holdFire(10);         // Feuer 10 Bilder lang halten (auch AG.holdMouse)
AG.stepUntilChange(3000);// ausführen, bis sich das Bild ändert
await AG.insertDisk(2);  // Spieldiskette 2 einlegen
await AG.shot("name");   // Lowres-PNG (456 × 313) nach work/captures/
await AG.recordRaw("name", { every: 25, count: 100 });   // schnelle Rohaufnahme, s. raw_frames.py
await AG.recordInterlace("name", { every: 10, count: 20 }); // volle Auflösung: Hires + beide Halbbilder, 912 × 626
// Hires ohne Interlace, jedes Bild, Ausschnitt x/y/w/h (x in Hires-Texeln, y = Rasterzeile); actions wie bei traceRun
await AG.recordHires("name", { count: 100, x: 176, y: 40, w: 640, h: 224 });
await AG.dump("name");   // Chip-RAM ($000000) und Slow-RAM ($C00000), je 512 KB
await AG.snapshot("name");   // ganzer Emulatorzustand → work/captures/name.vAmiga
await AG.restore("name");    // Schnappschuss laden (hält danach an); Bildzähler stimmt nach 2 Schritten
AG.frameNr();            // Bildnummer seit dem Einschalten
AG.lof();                // 1 = langes Halbbild (Interlace)
// Ablaufspur: nach jedem Bild Speicherwörter und eine Bildpunktfarbe festhalten (für Bild-für-Bild-Vergleiche)
AG.traceStart({ words: [[0x14aa, 16], [0xdff002, 1]], pixel: [120, 40] });   // [Adresse, Anzahl Wörter]
AG.traceRun(1500, { 16400: () => AG.joy("PRESS_FIRE") });  // Bilder ausführen; Aktionen vor bestimmten Bildern
await AG.traceSave("name");  // → work/captures/name.trace.json { words, pixel, rows: [[Bild, RGB, Wörter …]] }
```

Lange Läufe in Abschnitten von höchstens etwa 2.000 Bildern ausführen: Ein einzelner Aufruf über ≈ 9.000 Bilder
blockierte den Browser so lange, dass der Emulator neu startete (W-013). Nach einem erneuten
`import("/local/tools/agony-helpers.js?v=…")` ohne dieselbe URL ist `window.AG` ein frisches Modul ohne Spur; die alte
Instanz bekommt man über ihre URL aus `performance.getEntriesByType("resource")` zurück.

Weil alles schrittweise läuft, ist ein Durchlauf mit denselben Eingaben bildgenau wiederholbar (geprüft: zwei
Durchläufe ab demselben Schnappschuss liefern identische Bilder).

- `recordInterlace`: Das lange Halbbild liefert die geraden, das kurze die ungeraden Zeilen (wie die Mischstufe von
  vAmigaWeb). Hires = jeder 2. Texel. Geprüft an der Titelsequenz: keine Zeilenversätze.
- `raw_frames.py` und `compare_capture.py` lesen Breite und Höhe aus dem Dateinamen und verarbeiten beide Formate.

### Zeitprofil

Haltepunkte im Level-Code liefern, wann der Strahl welche Programmstelle erreicht (Grundlage des Zeitmodells,
[E-034](entscheidungen.md#e-034-hauptschleife-im-level-zeitbedarf-als-feste-aufteilung-nach-messung)):

```js
const fire = { 13160: () => AG.joy("PRESS_FIRE"), 13162: () => AG.joy("RELEASE_FIRE") };
await AG.profileStart({ snapshot: "snap_f13100_level1_enter",
  pcs: [0xad8, 0xc2c, 0xef4, 0x147c, 0x149c, 0x153c, 0x29d2, 0x2e82, 0x302c, 0x316e, 0x3194, 0x342e, 0x348c, 0x34de,
        0x3514, 0x3800, 0x3916, 0x39c2, 0x43c6, 0x5bc4] });
AG.profileRun(450, fire);   // mehrmals, bis zum gewünschten Bild (hier 14724)
await AG.profileSave("level1_go");
```

- Ergebnis `work/captures/<name>.profile.json`: je Treffer `[Bild, PC, Zeile, Farbtakt]`. Bild = `frameNr()` während
  des Bilds (Ablaufspuren zählen eins weiter). Die Strahlposition kommt aus `VPOSR`/`VHPOSR` (`wasm_peek16`), der PC
  aus der Eingabezeile der RetroShell. Der CPU-Zykluszähler (`wasm_get_cpu_cycles`) taugt nicht als Zeitbasis.
- Stellen (sea): `$AD8` Schleifenstart, `$C2C` vorderes, `$EF4` hinteres Scrollen, `$147C` SEARCH SHORT PHASE,
  `$149C` Objekte, `$153C` ALIEN BANK CTRL, `$29D2` Spielmechanik, `$2E82` Kopie der Palette, `$302C` Kollisionstest,
  `$316E` Objekt-Routinen, `$3194` Statuszeile, `$342E` Zeichen eines neuen Statustexts, `$348C` Sounds, `$34DE` Ende
  Teil 1, `$3514` Teil 2, `$3800` Sprite-Liste der Gegnerschüsse, `$3916` Seitenwechsel vorn, `$39C2` Aufräumen,
  `$43C6`/`$5BC4` Beginn/Ende des Copper-Interrupts. Nicht `$4392` (W-014) und keine Warteschleifen (`$AD0`,
  `$34E8`), sonst hält jeder Durchlauf der Schleife an. Die Haltepunkte setzt `AG.setBreakpoints` in einem Bild;
  beim Laden bereinigt `Profile` die Treffer (W-016).
- Lange Läufe in Abschnitten: `await AG.profileStart({ snapshot, pcs })`, dann wiederholt
  `AG.profileRun(1900, actions, everyFrame)`, zum Schluss `await AG.profileSave(name)`. `everyFrame(frameNr)` läuft nach
  jedem Bild, z. B. Leben auffüllen: `() => { if ((wasm_peek16(0x1b8) & 0xff) < 3) wasm_poke(0x1b9, 7); }`.
- Laufzeit des Musiktreibers (E-035): Haltepunkte `$43B4`/`$43BA` über die ganze Levellänge (`level1_music_timing`,
  13.102–24.505, Eule per Poke unsterblich); daraus `python tools/analysis/music_timing.py` →
  `game/src/data/timing/music-sea.ts`.
- Läufe mit Zeitprofil (Eingaben und letztes verwertbares Bild) stehen in `game/test/runs.ts` (`level1_go`,
  `level1_shoot`); die Sammel-Skripte nehmen den Namen als Argument (Standard `level1_go`).
- Auswertung Teil 1a: `node test/tools/collect-loop-work.ts [<lauf>]` (aus `game/`, Arbeit je Durchlauf im Nachbau und
  Bus-Belegung → `<lauf>.work.json`) und `python tools/analysis/fit_loop_timing.py [--detail von bis]` (Anpassung,
  Trefferquote; liest nur `level1_go`).
- Auswertung Teil 1b und Copper-Interrupt: `node test/tools/collect-timing.ts [<lauf>]` (Arbeit je Schritt, Teile je
  Interrupt, Bus-Belegung je Bild → `<lauf>.timing.json`), `python tools/analysis/fit_part1b_timing.py [--run <lauf> …]
  [--residuals Schritt] [--outliers]` (Anpassung je Schritt; mehrere `--run` passen gemeinsam an und zeigen den Rest
  je Lauf), `python tools/analysis/fit_irq_timing.py [<lauf> …]` (Dauer des Copper-Interrupts über mehrere Läufe,
  Standard beide), `node test/tools/eval-timing.ts` (Uhr des Modells gegen die Messung je Schritt, Lauf `level1_go`)
  und `node test/tools/detail-timing.ts <lauf> <von> <bis>` (je Durchlauf Modell M und Messung G für Schleifenstart,
  SEARCH SHORT PHASE, jeden Schritt, Teil 2 und Ende, als Bild/Zeile ab dem Startbild).
- Fehlersuche im Bild: `node test/tools/debug-frames.ts [--model] [--shoot] Bild …` schreibt Nachbau, Original und
  Unterschied als PPM nach `work/debug/` (`--shoot`: Lauf `level1_shoot`). Kollisionsliste und Gegner je Bild im
  Nachbau und im Original: `node test/tools/debug-shoot.ts von bis`.
- Erkunden, wie weit Level 1 ohne Anhalten läuft (Cloud, kein Vergleich): `node test/tools/explore-level.ts [<letztes
  Bild>]` (Dauerfeuer, Bewegungsmuster des Planungs-Bots, Leben aufgefüllt; meldet Tode, Routinen, Bonusse, Beginn des
  Levelendes und Halt bzw. Verlassen des Levels).
- Eingaben für eine Aufnahme planen (Ablauf C): `node test/tools/plan-bot.ts <letztes Bild>` erzeugt eine Folge mit
  Dauerfeuer und Bewegung und probiert vor jedem Tod der Eule Ausweichbewegungen (im Nachbau mit dem Zeitmodell, gibt
  die Liste `[Bild, Knöpfe]` aus); `node test/tools/plan-shoot.ts <eingaben.json> [<letztes Bild>]` spielt eine Liste
  ab und meldet Tode, Punkte und wo die Engine anhält. Im Emulator dieselbe Liste als `actions`:
  `AG.joyActions(liste)` für `traceRun`, `recordHires` und `profileRun` (`AG.setJoy(b)` setzt den Joystick nach den
  Bits wie `JOY_*`: 1 hoch, 2 runter, 4 links, 8 rechts, 16 Feuer). Vor jedem Durchlauf `AG.setJoy(0)`.
- `AG.shell(cmd)` führt einen RetroShell-Befehl aus (wie `SH` unten).

### Schnappschüsse

Liegen in `work/captures/` (je ≈ 2,5–3 MB, mit eingelegter Diskette). Stand 06.10.2026:

| Datei | Stelle |
|---|---|
| `snap_f2999_present_loading.vAmiga` | Präsentation geladen, kurz vor dem Stereo-Symbol |
| `snap_f7100_menu.vAmiga` | Menü gerade eingeblendet (Disk 2 liegt ein) |
| `snap_f10310_load_sea.vAmiga` | Ladebild von Level 1 |
| `snap_f13494_level1_wait.vAmiga` | Level 1 wartet auf Feuer |
| `snap_f13100_level1_enter.vAmiga` | 12 Bilder vor dem Start von Level 1 (Copperliste ab Bild 13112) |

Nach dem Öffnen von `/agony` erst ein paar Bilder ausführen lassen, dann `AG.restore` aufrufen; sonst überschreibt
der Kaltstart den geladenen Zustand ([Bugs W-010](bugs.md#w-010-schnappschuss-direkt-nach-dem-seitenaufruf-lädt-nicht)).
Schnappschüsse sind an die vAmigaWeb-Version gebunden (hier 4.3.6).

### Debug-Konsole (RetroShell)

Befehle werden Zeichen für Zeichen eingegeben und mit Return (Sondertaste 12) abgeschickt. Jeder Befehl führt ein
Emulator-Bild aus, damit er abgearbeitet wird:

```js
window.SH = (cmd) => {
  wasm_retro_shell_press_special(9, 0); wasm_retro_shell_press_special(7, 0);   // Zeile leeren
  for (const ch of cmd) wasm_retro_shell_press_key(ch.charCodeAt(0));
  wasm_retro_shell_press_special(12, 0); AG.step(1);
  const t = wasm_retro_shell_get_text();                // Puffer ist begrenzt: ab dem eigenen Befehl ausschneiden
  const i = t.lastIndexOf(cmd.slice(1));
  return i >= 0 ? t.slice(i) : t.slice(-3000);
};
SH("debugger");          // in die Debug-Konsole wechseln (nötig für ?, r, watch …)
SH("r denise");          // BPLCON0–2, DIWSTRT/STOP, alle 32 Farbregister
SH("r agnus");           // DMACON, DDFSTRT/STOP, Bitplane-, Sprite- und Audio-Zeiger
SH("r copper");          // COP1LC, aktueller Copper-Programmzähler
SH("r cpu");             // Register und Programmzähler
SH("watch at $68A58");   // Watchpoint: hält bei CPU-Zugriff; AG.step liefert dann die Bildnummer ≥ 0
SH("clear");             // Konsole leeren
```

- Die Eingabezeile zeigt Strahlposition und Programmzähler, z. B. `(2,3) $001456:`.
- Watchpoints reagieren nur auf CPU-Zugriffe, nicht auf Blitter oder Disk-DMA.
- Die Werte von `r agnus` sind die laufenden Zeiger an der aktuellen Strahlposition; die Startwerte stehen in der
  Copperliste (`copper_scan.py`).

### Steuerung per JavaScript

Im Browser-Tab des Emulators (z. B. über das JavaScript-Werkzeug der Browser-Vorschau):

```js
// Joystick an Port 2
wasm_joystick("2PULL_RIGHT");  wasm_joystick("2RELEASE_X");   // auch 2PULL_LEFT
wasm_joystick("2PULL_UP");     wasm_joystick("2RELEASE_Y");   // auch 2PULL_DOWN
wasm_joystick("2PRESS_FIRE");  wasm_joystick("2RELEASE_FIRE");

// Linke Maustaste (Port 1): drücken / loslassen
Module._wasm_mouse_button(1, 1, 1);
Module._wasm_mouse_button(1, 1, 0);

// Disk 2 in Laufwerk DF0 einlegen
wasm_loadfile("agony-2.adf",
  new Uint8Array(await (await fetch("/local/disks/agony-2.adf")).arrayBuffer()), 0);

// Hardware-Konfiguration lesen
wasm_get_config_item("CHIP_RAM");   // auch SLOW_RAM, FAST_RAM, AGNUS.REVISION, DENISE.REVISION, CPU.REVISION
```

Getestet: Joystick-Feuer, Maustaste, Diskwechsel, Konfiguration lesen und setzen, `wasm_peek16`, `wasm_halt()`,
`Module._wasm_execute_one_frame()`, Debug-Konsole, Schnappschüsse (`wasm_take_user_snapshot()` /
`wasm_loadfile("x.vAmiga", …)`). Noch ungetestet: Richtungen im Spiel, `wasm_peek`, `wasm_poke`, `wasm_mem_patch`.

### Bilder und Speicher abgreifen

```js
// 16-Bit-Wort aus dem Amiga-Speicher lesen (Beispiel: Kickstart-Kennung $1111 bei $FC0000)
wasm_peek16(0xFC0000);

// Aktuelles Bild exakt auslesen und als PNG speichern
const W = HPIXELS, H = VPIXELS;                       // 1824 × 313
const ptr = Module._wasm_pixel_buffer();
const rgba = new Uint8ClampedArray(Module.HEAPU8.buffer.slice(ptr, ptr + W * H * 4));
for (let i = 3; i < rgba.length; i += 4) rgba[i] = 255;
const oc = new OffscreenCanvas(W, H);
oc.getContext("2d").putImageData(new ImageData(rgba, W, H), 0, 0);
await fetch("/local/capture/bild.png", { method: "POST", body: await oc.convertToBlob({ type: "image/png" }) });
```

- Der Puffer enthält ein ganzes PAL-Bild inklusive Rändern: 313 Zeilen, 1824 Texel pro Zeile (`HPIXELS` =
  912 × `TPP`, `TPP` = 2). Ein Lowres-Pixel ist 4 Texel breit. Die Anzeige von vAmigaWeb schneidet ab Texel 342 und
  Zeile 36 einen Bereich von 1338 × 266 aus.
- `canvas.toBlob()` liefert nur Schwarz (WebGL), siehe [Bugs W-001](bugs.md#w-001-bilder-aus-dem-webgl-canvas-sind-schwarz).

### Hardware-Konfiguration

Eingestellt am 06.10.2026: **A500 mit OCS** wie das Profil „A500_VANILLA“ von vAmigaWeb: Agnus und Denise OCS,
512 KB Chip-RAM, 512 KB Slow-RAM, kein Fast-RAM, 68000 ohne Übertaktung. Die Einstellung speichert vAmigaWeb im
Browser (für `http://localhost:8090`); in einem anderen Browser bzw. auf dem Mac einmalig wiederholen:

```js
wasm_configure_multi(["AGNUS_REVISION=OCS", "DENISE_REVISION=OCS", "CHIP_RAM=512", "SLOW_RAM=512",
  "FAST_RAM=0", "CPU_REVISION=0", "CPU_OVERCLOCKING=0"].join("\n"));
for (const [k, v] of Object.entries({ OPT_AGNUS_REVISION: "OCS", OPT_DENISE_REVISION: "OCS", OPT_CHIP_RAM: "512",
  OPT_SLOW_RAM: "512", OPT_FAST_RAM: "0", OPT_CPU_REVISION: "0", OPT_CPU_OVERCLOCKING: "0" })) save_setting(k, v);
```

Danach `/agony` neu laden. Prüfen mit `wasm_get_config_item("CHIP_RAM")` usw. Vorher lief vAmigaWeb mit 2 MB Chip,
2 MB Fast und ECS.

**Farben:** vAmiga gibt 4-Bit-Farbwerte ungefähr als Wert × 16 aus, mit kleinen Rundungsabweichungen, siehe
[Bugs W-005](bugs.md#w-005-emulator-farben-sind-nicht-exakt-16).

## Analyse-Skripte

### Disketten auslesen und Spieldateien entpacken

```bash
python tools/analysis/adf_ls.py "reference/agony/game/Agony/agony-1.adf;reference/agony/game/Agony/agony-2.adf;reference/agony/game/Agony/agony-3.adf" work/adf
python tools/analysis/pp20.py work/adf/agony-1 work/unpacked
python tools/analysis/pp20.py work/adf/agony-2 work/unpacked
python tools/analysis/pp20.py work/adf/agony-3 work/unpacked
```

- `adf_ls.py <adf1;adf2;…> [zielordner]` listet den Inhalt (Größe, erste Bytes) und extrahiert optional nach
  `<zielordner>/<adf-name>/`. Liest OFS und FFS; Disks ohne AmigaDOS-Dateisystem werden erkannt und übersprungen.
- `pp20.py <quellordner> <zielordner>` entpackt alle PowerPacker-Dateien. Ergebnis: 15 Dateien, 3.989.980 Byte
  (geprüft am 06.10.2026).
### Weitere Analyse-Skripte

| Skript | Zweck |
|---|---|
| `tools/analysis/waves_overview.py` | zählt die Starts und Objekte in den Startlisten der sechs Level-Quelltexte |
| `tools/analysis/startlist_level1.py` | sucht die Startliste von Level 1 im entpackten `work/unpacked/Agony.09` und dekodiert sie bis zum Listenende |
| `tools/analysis/raw_frames.py <datei.rgb> [--crop x0,y0,x1,y1] [--no-frames]` | wandelt Rohaufnahmen aus `AG.recordRaw` in PNGs und eine Übersichtstafel um |
| `tools/analysis/contact_sheet.py "<muster>" <ziel.png>` | Übersichtstafel aus einer PNG-Serie |
| `tools/analysis/copper_scan.py <chip.bin> [--at 0xADR]` | findet und dekodiert Copperlisten in einem Speicherabzug |
| `tools/analysis/find_in_file.py <chip.bin> <datei> <adr …>` | sucht Speicherbereiche des Abzugs in einer Spieldatei und nennt die Ladeadresse |
| `tools/analysis/planar.py <datei> <offset> <b> <h> <planes> --pal <offset> [--ehb]` | dekodiert Amiga-Bitplanes zu PNG |
| `tools/analysis/compare_capture.py <bild.png> <aufnahme.rgb> <index> [--at x,y] [--rows y0,y1]` | sucht ein Bild in einer Aufnahme (Lowres oder Interlace) und vergleicht pixelgenau auf 12-Bit-Farbebene |
| `tools/analysis/disasm68k.py <datei> <ladeadresse> <von> <bis> [--hex] [--out datei]` | disassembliert 68000-Code (Capstone); Ausgaben bisher in `work/disasm/` (`present_code.txt`, `igt_code.txt`, `load_sea_code.txt`) |

Alle finden den Projektordner selbst bzw. arbeiten mit übergebenen Pfaden. Sie sind Prototypen für die spätere
Asset-Pipeline.

Beispiele:

```bash
python tools/analysis/planar.py work/unpacked/Agony.01 0x24C28 640 256 4 --pal 0x38C28 --out work/present/agony.png
python tools/analysis/compare_capture.py work/present/agony.png work/captures/ilace_agony_912x626_1_every1_from4400.rgb 0 --at 186,160
python tools/analysis/disasm68k.py work/unpacked/Agony.07 0x600 0x600 0x30E4 --out work/disasm/igt_code.txt
```

### Hinweise

- Python-Skripte nicht wie Module der Standardbibliothek benennen (z. B. `inspect.py`), sonst werden sie beim Import
  versehentlich ausgeführt.
- Die Skripte geben UTF-8 aus. Für eigene Einzeiler in Git-Bash unter Windows `PYTHONIOENCODING=utf-8` setzen
  ([Bugs W-009](bugs.md#w-009-python-skripte-brachen-in-der-windows-konsole-ab)).

## Asset-Pipeline

```bash
node tools/pipeline/build-assets.ts            # mit Vorschau in work/assets-preview/
node tools/pipeline/build-assets.ts --no-preview
```

- TypeScript ohne Abhängigkeiten in `tools/pipeline/`: `build-assets.ts` (Einstieg), `extract/startsequence.ts`
  (Titelsequenz, Menü, Ladebild 1, Highscores), Bibliotheken in `lib/` (`adf.ts`, `powerpacker.ts`, `planar.ts`,
  `png.ts`, `wav.ts`, `gamefiles.ts`, `protracker.ts`).
- Liest die Disketten direkt aus `reference/agony/game/Agony/` und entpackt die Spieldateien im Speicher (alle 15
  byte-identisch zur Python-Fassung).
- Ausgabe nach `game/public/data/` (wird jedes Mal gelöscht und neu erzeugt, nie von Hand bearbeiten): `manifest.json`
  plus `img/*.idx` (ein Byte Farbindex pro Pixel), `font/menu.idx`, `snd/*.s8` (8-Bit-Samples), `mod/*.mod`
  (ProTracker). Format: `game/src/data/manifest.ts`. Stand 06.10.2026: 7 Bilder, 1 Schrift, 15 Textseiten,
  5 Samples, 2 Module, 6 Highscores, Tabellen (Feuerband `title.bandColors`/`title.bandCounters`, ProTracker
  `pt.periods`/`pt.sine`/`pt.funk`), 1,1 MB, Laufzeit ≈ 2–4 s.
- Vorschau in `work/assets-preview/`: PNG je Bild und Schrift, WAV je Sample, `texts_en.txt`.
- Geprüft: alle Bilder identisch mit den verifizierten Python-Dekodierungen bzw. pixelgenau gleich den
  Emulator-Aufnahmen; zwei Läufe liefern byte-identische Dateien.
- Die Daten enthalten Original-Assets: nicht öffentlich weitergeben (siehe `CLAUDE.md`, Rechtliches).
- Node führt `.ts` nur mit „löschbarer“ Syntax aus: keine Parameter-Properties im Konstruktor, keine `enum`, keine
  `namespace`; Importe mit Endung `.ts`. `tsc` prüft das über `erasableSyntaxOnly` (siehe Web-App).
- `tools/package.json` kennzeichnet die Werkzeuge als ES-Module (`"type": "module"`); Node erkennt das sonst nur
  anhand der Syntax, und TypeScript würde die Dateien als CommonJS prüfen.

## Web-App

Vite-Projekt in `game/` (Aufbau: [Architektur → Umsetzung](architektur.md#umsetzung-web-grundgerüst)). Einmalig bzw.
nach dem Wechsel des Rechners (E-018, Option A) im Ordner `game/` installieren:

```bash
cd game
npm install
```

| Paket | Version (06.10.2026) | Zweck |
|---|---|---|
| `typescript` | 7.0.2 (nativer Compiler `tsc`) | Typprüfung, strict |
| `vite` | 8.3.3 (Rolldown) | Dev-Server, Build |
| `vitest` | 5.0.3 | Tests in Node |
| `@types/node` | 26.6.4 | Typen für Pipeline und Tests |

Befehle (im Ordner `game/`):

| Befehl | Wirkung |
|---|---|
| `npm run dev` | Dev-Server auf Port 5173, auch im Heimnetz erreichbar (`host: true`) |
| `npm run build` | Typprüfung, dann Build nach `server/` (wird jedes Mal komplett neu erzeugt) |
| `npm run preview` | den Build auf Port 4173 ausliefern |
| `npm test` | Vitest (Kern, Mixer; Titelsequenz, Menü, Ladebild und Schrift gegen Aufnahmen des Originals) |
| `npm run typecheck` | drei Prüfungen: Kern ohne DOM/Node (`tsconfig.core.json`), Web (`tsconfig.json`), Pipeline + Emulator-Skripte + Tests (`tsconfig.tools.json`) |
| `npm run assets` | Asset-Pipeline (wie oben) |

Vorschau im Claude-Browser: Konfigurationen „game“ (Dev-Server) und „game-build“ (Build) in `.claude/launch.json`.

Hinweise:

- **NAS:** Vite bekommt über das Netzlaufwerk keine Änderungsmeldungen, deshalb ist Polling eingeschaltet
  (`server.watch.usePolling`, W-011).
- **Prüfen im verborgenen Vorschau-Fenster:** Dort laufen `requestAnimationFrame` und `ResizeObserver` nicht (W-012).
  Im Dev-Build steht `window.agony = { game, loop, platform }` bereit; die Schleife lässt sich per Skript antreiben:
  ```js
  let t = performance.now() + 100;
  const run = (n) => { for (let i = 0; i < n; i++) agony.loop.frame(t += 20); };
  run(50);  // ≈ 50 Takte
  ```
  Tasten per `window.dispatchEvent(new KeyboardEvent("keydown", { code: "Space" }))`, Touch per `PointerEvent` mit
  `pointerType: "touch"` auf `document.body`. Echte Klicks (Werkzeug `computer`) lösen den Ton aus.
- **Tablet im Heimnetz:** `npm run dev` zeigt die Netzwerkadresse. Über `http://<IP>:5173` ist die Seite kein
  sicherer Kontext: Dann fehlt das AudioWorklet, und der Ton läuft über den Notbehelf im Hauptthread (E-027).
- Ohne Spieldaten (`game/public/data/`) startet das Spiel nicht, und die Tests, die sie brauchen, werden übersprungen:
  vorher `npm run assets` ausführen.
- Ein Teil der Tests vergleicht mit Aufnahmen des Emulators in `work/captures/` (nur lokal vorhanden; fehlen sie, wird
  der Test übersprungen):

  | Datei | Inhalt | Test |
  |---|---|---|
  | `title.trace.json` | Titelsequenz, Bild 3002–4601 ab `snap_f2999_present_loading` | `title.test.ts` |
  | `ilace_build_912x626_24_every10_from3240.rgb` | Feuerband, Interlace-Aufnahme | `title-pixels.test.ts` |
  | `menu.trace.json` | Menü ab dem Start (Bild 6476), ein Zyklus (bis 14120 gültig) | `menu.test.ts` |
  | `menu2.trace.json`, `load.trace.json` | ab `snap_f7100_menu`: zweiter Zyklus, Feuer bei 16400, Story-Seite, Ladebild bis 23302 | `menu.test.ts` |
  | `menu_hiscore_f14710_chip.bin`, `menu_story_f16430_chip.bin` | Speicherabzüge: Highscore-Tabelle, Story-Seite | `menu.test.ts` |
  | `menu_text_f7450/f7700_chip.bin` | Speicherabzüge: Abspann-Seite | `text.test.ts` |
  | `level1_enter_640x224_*.rgb`, `level1_enter.trace.json` | Level 1 ohne Eingabe: Hires-Aufnahme Bild 13102–13301 (zwei Dateien), Spur 10313–13311 (ab `snap_f10310_load_sea`) | `level1.test.ts` |
  | `level1_joy_*.rgb`, `level1_joy.trace.json` | Level 1 mit Joystick, ab `snap_f13100_level1_enter` | `level1.test.ts` |
  | `level1_edge_*.rgb`, `level1_edge.trace.json` | Eule an den unteren Rand und in die Ecke oben links | `level1.test.ts` |
  | `level1_fire.trace.json` | Feuer bei „PRESS FIRE TO START“ (Bild 13161/13162) | `level1.test.ts` |
  | `level1_go_*.rgb`, `level1_go.trace.json` | Feuer bei 13161/13162, dann ohne Eingabe bis nach dem Spielende: Hires-Bilder 13102–14801 (17 Dateien), Spur 13103–14902 (Variablen a5 + `$7B68`, 200 Wörter; `$1B4`; `Rout_Struct`, `Die_Dyn_Ptr`, `Good_Col_List`, `AF_Struct`, Bahnen, AWO-Bänke) | `level1.test.ts` |
  | `level1_go.profile.json` | Zeitprofil desselben Laufs 13104–14723 mit 20 Haltepunkten | `level1.test.ts`, Zeitmodell |
  | `level1_go.work.json`, `level1_go.timing.json` | Arbeit je Durchlauf und je Schritt im Nachbau, Teile je Interrupt, Bus-Belegung | Anpassung des Zeitmodells |
  | `level1_shoot_*.rgb`, `level1_shoot.trace.json`, `level1_shoot.profile.json` | Dauerfeuer und Ausweichen (Eingaben `SHOOT_RUN` in `game/test/runs.ts`): Hires-Bilder 13102–14901, Spur 13103–14812 (Wörter wie `level1_go`), Zeitprofil 13104–14828 mit denselben 20 Haltepunkten; Abschüsse, ein Tod (14311), ab 14566 überlange Durchläufe | `level1.test.ts` |
  | `level1_shoot.work.json`, `level1_shoot.timing.json` | Arbeit und Interrupt-Teile wie oben, bis Bild 14565 (die Sammel-Skripte laufen inzwischen bis 14792, `RUNS` in `runs.ts`; für den nächsten Schritt neu erzeugen) | Anpassung des Zeitmodells |
  | `level1_go_obj.trace.json` | Fehlersuch-Spur 13240–13600: Variablen, AWO-Bänke, Bahnen, Kollisionsliste, Palettenpuffer | – |
  | `level1_obj.profile.json` | Zeitprofil Objekte (`$149C`, `$153C`, Copper-Interrupt) bis 13700 | Schwelle O-010 |
  | `level1_vbl*.profile.json`, `level1_music_timing.profile.json` | Laufzeit des Musiktreibers (mit/ohne Dauerfeuer, ganze Levellänge) | `music_timing.py` |
  | `level1_f13140_chip.bin`, `level1_full_912x313_*.rgb` | Speicherabzug und volles Hires-Bild (Prüfung des Bildaufbaus, kein Test) | – |
- Level direkt starten (Dev-Build, Browser-Konsole): `const { LevelScreen } = await import("/src/core/screens/level.ts");
  const { SEA } = await import("/src/core/level/layout.ts"); agony.game.setScreen(new LevelScreen(SEA, () => …));`
  Die Engine steht dann unter `agony.game["screen"].engine` (Variablen mit `engine.w(SEA.vars.…)`).
- Bildschirme gezielt ansehen: Im Dev-Build die Schleife anhalten (`agony.loop.setActive(false)`) und Takte direkt
  ausführen, z. B. `const i = { buttons: 0, tapX: -1, tapY: -1 }; for (let k = 0; k < 300; k++) agony.game.tick(i);
  agony.platform.renderer.draw(agony.game.display);` (Feuer: `buttons: 16`). Danach `agony.loop.setActive(true)`.

## Native App (geplant)

Sobald der Mac da ist (laut Nutzer in ein bis zwei Monaten, Stand 06.10.2026):

- macOS mit **Xcode 26** (Capacitor 8 verlangt Xcode 26; Apple nimmt seit 28.04.2026 nur noch Uploads mit Xcode 26
  bzw. iOS-26-SDK an).
- Node.js und npm wie unter Windows; danach im Projekt `npm ci`.
- Capacitor 8 mit iOS-Plattform; Abhängigkeiten laufen standardmäßig über den Swift Package Manager.
- Zum Installieren auf eigenen Geräten reicht eine Apple-ID (Installation läuft nach 7 Tagen ab); für dauerhafte
  Installation, TestFlight oder App Store ist das kostenpflichtige Apple Developer Program nötig.
- Einrichtungsschritte hier dokumentieren, sobald sie ausgeführt sind.

## Git-Arbeitskopie für Cloud-Sessions

Entscheidung E-041. Das Projekt selbst bleibt ohne Git; für Cloud-Sessions von Claude Code (claude.ai/code) gibt es
eine Arbeitskopie mit Git.

- Arbeitskopie: `P:\agony-remake-git` (auf dem NAS neben dem Projekt), Repo `https://github.com/stike0711/agony-remake`
  (privat), Zweig `main`. Git-Benutzer der Kopie: `stike0711`. In der globalen Git-Konfiguration des PCs ist der
  Ordner als `safe.directory` eingetragen (das NAS speichert keine Besitzer).
- Inhalt: alles außer `node_modules`, `server/`, `backup/`, `work/debug/`, `.claude/settings.local.json`; die
  Emulator-Aufnahmen gepackt in `work/captures-gz/` (109 MB statt 2,1 GB). Auf Wunsch des Nutzers auch ROMs, ADFs
  und Musik – **nur, weil das Repo privat ist**; nie öffentlich schalten oder weitergeben.
- Abgleich (aus dem Projekt):
  - `node tools/repo/sync.ts push ../agony-remake-git` – Projekt → Arbeitskopie (packt neue Aufnahmen), danach in
    der Kopie `git add -A`, `git commit`, `git push`. Den Push von Claude blockiert die automatische Freigabe
    (Datenweitergabe) beim großen ersten Push; kleine Pushes auf ausdrücklichen Wunsch gingen (08.10.2026).
  - Nach einer Cloud-Session: in der Kopie `git pull`, dann `node tools/repo/sync.ts pull ../agony-remake-git` –
    übernimmt geänderte Dateien ins Projekt, sichert Überschriebenes nach `backup/<datum>_<uhrzeit>_repo-pull/`, meldet in der
    Kopie gelöschte Dateien nur. Danach `npm test` und `npm run build` im Projekt.
- Cloud-Sessions pushen auf einen eigenen Zweig `claude/<name>`, nicht auf `main`. Zurückholen: in der Kopie
  `git fetch`, `git merge --ff-only origin/claude/<name>`, `git push origin main`, dann `sync.ts pull`. Aufgaben an
  eine laufende Cloud-Session kann Claude von hier aus schicken (SendMessage); antworten kann sie nicht, das Ergebnis
  steht in ihrem Verlauf und im Zweig. Bestätigt 08.10.2026: Das Cloud-Guthaben wird statt des Wochenlimits belastet.
- In der Cloud: `cd game && npm install`, einmal `node tools/repo/unpack-captures.ts` (aus der Wurzel), dann
  `npm test`. Für Analysen bei Bedarf `pip install numpy capstone` (Python-Skripte in `tools/analysis/`). Neue Emulator-Aufnahmen gehen nur am PC.
- Nie gleichzeitig im Projekt und in der Cloud an denselben Dateien arbeiten; vor einer Cloud-Session pushen, danach
  erst zurückholen, dann lokal weiter.
- Das Guthaben für Cloud-Sessions (Aktion, 100 $) verfällt am 04.11.2026; danach zählen Cloud-Sessions zum Plan-Limit.

## Zwei Rechner, ein NAS

Das Projekt liegt auf einem NAS. Der Windows-PC greift über Laufwerk `P:` darauf zu, der Mac später über die
eingebundene Netzwerkfreigabe (Pfad beim Einrichten hier eintragen). Beide Rechner können gleichzeitig zugreifen;
es muss nichts abgeglichen werden (Entscheidung E-017).

Regeln für den gemeinsamen Ordner:

- **Nie gleichzeitig dieselben Dateien bearbeiten.** Ohne Versionskontrolle fängt nichts Konflikte ab; die zuletzt
  gespeicherte Fassung gewinnt. Naheliegende Aufteilung: Entwicklung am PC, Xcode/iOS am Mac. Laufen auf beiden
  Rechnern Claude-Sitzungen, nicht parallel an Wiki oder Code arbeiten lassen.
- **Das Wiki ist das gemeinsame Gedächtnis.** Claudes eigene Erinnerungen werden pro Rechner getrennt gespeichert;
  alles Projektrelevante gehört ins Wiki bzw. in die `CLAUDE.md`.
- **UTF-8 und Zeilenenden LF** für alle Textdateien, festgelegt in `.editorconfig` im Projektordner. Achtung bei
  Windows-Werkzeugen, die von sich aus CRLF schreiben (z. B. PowerShell `Set-Content`). Stand 06.10.2026: alle
  Projektdateien sind LF.
- **Dateinamen exakt schreiben:** In Importen und Pfaden die Groß-/Kleinschreibung genau wie auf der Platte
  verwenden. Windows und macOS unterscheiden sie meist nicht, das NAS möglicherweise schon. In TypeScript
  `forceConsistentCasingInFileNames` eingeschaltet lassen.
- **Keine symbolischen Links im Projekt;** Netzwerkfreigaben behandeln sie je nach System unterschiedlich.
- **`node_modules`** enthält plattformabhängige Programme (z. B. esbuild und Rollup, die Vite benutzt). Eine
  Installation für Windows läuft nicht auf dem Mac und umgekehrt. Der Umgang damit wird entschieden und getestet,
  sobald der Mac da ist (E-018).
- **Dateiüberwachung:** Änderungsmeldungen kommen über Netzlaufwerke nicht zuverlässig an (macOS meldet sie dort
  gar nicht). Bei Bedarf in Vite `server.watch.usePolling: true` setzen.
- **Xcode:** Zwischenergebnisse (DerivedData) und Swift-Pakete liegen standardmäßig im Benutzerordner des Macs,
  nicht auf dem NAS; so lassen.
- **Server im Heimnetz:** Emulator-Server und später der Vite-Dev-Server können auf einem Rechner laufen und mit
  `--lan` bzw. `--host` vom anderen Rechner oder vom Tablet aus im Browser geöffnet werden.
