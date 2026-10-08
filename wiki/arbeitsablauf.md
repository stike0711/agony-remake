# Arbeitsablauf

Wie wir arbeiten: Zuschnitt der Sitzungen, Effort-Einstellung, wann ein Ergebnis genau genug ist, und die
Standardabläufe für wiederkehrende Aufgaben. Ziel: gleichbleibende Qualität mit weniger Tokens (E-038).

**Grundsatz:** Vor jedem Schritt den passenden Ablauf hier kurz lesen und ihm folgen. Abweichen ist erlaubt, wenn es
an der Stelle sinnvoll ist; dann im Abschlussbericht in einem Satz sagen, warum.

## Sitzungen

- **Klein schneiden:** Eine Sitzung = ein Arbeitsschritt mit klarem Ergebnis (z. B. eine Gegner-Routine, eine
  Aufnahme samt Vergleich, eine Bedienänderung). Größere Vorhaben in mehrere Schritte teilen, lieber zu klein als zu
  groß.
- **Einstieg:** [CLAUDE.md](../CLAUDE.md) (wird automatisch geladen) → [Status, „Nächste Schritte“](status.md#nächste-schritte)
  → passender Ablauf unten → nur die Wiki-Abschnitte, die der Schritt braucht. Nicht das ganze Wiki lesen.
- **Sparsam lesen:** Große Dateien (z. B. `video.ts`, `engine.ts`, `level1.test.ts`, Disassemblies) erst per Suche
  eingrenzen, dann nur den Ausschnitt lesen. Bereits Gelesenes nicht erneut lesen.
- **Unterwegs anhalten:** An einer natürlichen Zwischenstelle (Teilergebnis fertig, Tests grün) darf der Schritt
  früher enden; dann den Stand so festhalten, dass die nächste Sitzung ohne Rückfragen weitermacht.
- **Übergabe:** Am Ende steht in [Status](status.md#nächste-schritte), was als Nächstes kommt, mit dem Ablauf, der
  dafür gilt. Danach eine neue Sitzung starten (oder `/compact`); lange Sitzungen kosten bei jeder Antwort mehr.

## Cloud-Aufträge

Auf ausdrücklichen Wunsch des Nutzers (08.10.2026) gilt für Aufträge an eine Cloud-Session (claude.ai/code, Git-Zweig
`claude/…`, E-041) abweichend von „nach jedem Schritt anhalten“ (CLAUDE.md):

- So viel wie möglich Schritt für Schritt erledigen, ohne nach jedem Schritt auf eine Antwort zu warten; erst anhalten,
  wenn nichts mehr ohne PC oder Emulator geht.
- Je Schritt den passenden Ablauf unten, dann Abschluss nach Ablauf F (Tests, Build, Wiki) und **ein Commit je
  Schritt**, sofort gepusht.
- Überspringen und unter „Für den PC“ in [Status](status.md) notieren (mit Empfehlung: welche Aufnahme ab welchem
  Bild, welche Eingaben, welcher Effort), statt zu raten oder selbst zu entscheiden: alles, was Emulator, Aufnahmen
  oder Messungen braucht; alles, was eine Entscheidung des Nutzers braucht; alles, was nach zwei Versuchen ungeklärt
  bleibt.
- Ungeprüftes als „gegen das Original noch ungeprüft“ kennzeichnen. Wird der Kontext knapp: Stand in Status übergeben,
  committen, weiter.
- Zum Schluss eine kurze Zusammenfassung: fertig, ungeprüft, „Für den PC“, Fragen an den Nutzer.

## Effort

| Einstellung | Wofür |
|---|---|
| **mittel** (Regelfall) | Gegner-Routinen und Bildschirme nach bekanntem Muster, Wiki-Pflege, kleine Bedien- und Ablaufänderungen, Aufnahmen mit vorhandenen Werkzeugen |
| **hoch** | Neues Spielsystem ohne Vorbild im Nachbau (Bonus, Zaubermenü, Endgegner, Soundeffekte), Abweichungen mit unklarer Ursache |
| **maximal** (selten) | Neuer Hardware- oder Zeiteffekt, der das Spielgeschehen ändert und mit „hoch“ nicht zu klären war |

Kommt ein Schritt nach zwei Versuchen an einer unerklärten Abweichung nicht weiter: anhalten, den Befund festhalten
und eine höhere Einstellung für einen eigenen Schritt empfehlen, statt weiter zu probieren.

## Genau genug

Pixel- und taktgenau bleibt das Ziel, aber nicht um jeden Preis (E-038).

**Immer exakt** (Abweichung = Fehler, wird behoben):

- Spielzustand: Positionen, Bahnen, Startliste, Zufallszahlen, Energie, Treffer, Tod, Leben, Punkte, Zauber
- in welchem Bild Treffer, Tod, Wellenstart, Levelende und Bildschirmwechsel geschehen
- Grafiken, Paletten und Texte im Normalfall

**Toleriert** (im Test als Toleranz mit Kommentar und Verweis, in [Bugs](bugs.md) notiert, nicht weiter verfolgt):

- Versatz um höchstens 1 Pixel in einzelnen Bildern (bis etwa 2 Bilder am Stück, in wenigen Durchläufen), ohne
  Folgen für den Spielzustand
- Abweichungen, die nur aus Grenzen des Bildmodells kommen (z. B. Farbwechsel mitten in der Zeile, W-015)
- seltene Zeitlagen an Grenzen des Zeitmodells, solange der Spielzustand stimmt

Für tolerierte Fälle höchstens ein kurzer Klärungsversuch; dann notieren und weiter.

## Standardabläufe

### A. Schritt beginnen

1. Status lesen: Was ist der Schritt, welcher Ablauf gilt?
2. Im Quellcode die Stelle finden ([Quellcode](quellcode.md); Level-Module unter `AgonyDosBoot/`, z. B.
   `Ag_Game_LMER.s`), Labels per Suche, nur den Ausschnitt lesen.
3. Vor größeren Umbauten Sicherung nach `backup/<Datum>_<Inhalt>/` (nur die betroffenen Dateien).
4. Verbrauch festhalten: Plan-Limits abfragen (Werkzeug `get_usage` der Desktop-App: 5-Stunden-Fenster und Woche in
   Prozent) und die Werte für den Abschluss merken (Nutzerwunsch 08.10.2026).

### B. Gegner-Routine (`R_…`) übertragen

Muster: `R_Sol_Crache` und `R_Araignee` in `game/src/core/level/routines.ts`.

1. Routine im Level-Modul lesen; Adressen der Routine und ihrer Daten (Palette, Formen, Tabellen) im Abbild
   bestimmen (`work/disasm/`, sonst `tools/analysis/disasm68k.py`).
2. Eintrag in der Tabelle `routines` in `layout.ts` (Adresse → Typ und Datenadressen), Typ `…Def` in `routines.ts`.
3. Routine wie die Vorbilder übertragen: dieselben Modi und Zähler, Ganzzahlen, keine Allokationen, jeder Wert mit
   Quellkommentar (`// Quelle: Ag_Game_LMER.s, Label …`).
4. Prüfen mit der vorhandenen Aufnahme, falls die Routine darin vorkommt (Test in `game/test/level1.test.ts`); sonst
   eine Aufnahme nach Ablauf C.
5. Abschluss nach Ablauf F; im Wiki: [Level](original/level.md) (Gegner), [Features](features.md), Status.

### C. Emulator-Aufnahme und Vergleich

Werkzeuge und Aufrufe: [Setup → Referenz-Emulator](setup.md#referenz-emulator).

1. Vorschau „emulator“ starten, `AG` laden, vom Schnappschuss `snap_f13100_level1_enter` ausgehen.
2. Eingaben als Aktionen je Bild festlegen und notieren (sie kommen 1:1 in den Test).
3. Ablaufspur (`traceStart`/`traceRun`) und Bilder (`recordHires`) aufnehmen, in Abschnitten von höchstens
   ≈ 2.000 Bildern (W-013). Zeitprofil (`profileStart`) nur, wenn der Schritt das Zeitmodell betrifft.
4. Test anlegen oder erweitern: Nachbau mit denselben Eingaben, Vergleich Bild für Bild und Spur.
5. Abweichungen: erst `node test/tools/debug-frames.ts Bild …` (aus `game/`), dann die Genauigkeitsregel anwenden.
6. Überholte Aufnahmen in `work/captures/` löschen, wenn kein Test sie mehr nutzt.

### D. Zeitmodell nachstellen

Nur wenn ein Fehler nach der Genauigkeitsregel nicht toleriert ist. Auswertung wie in
[Setup → Zeitprofil](setup.md#zeitprofil): `collect-timing.ts` → `fit_part1b_timing.py` → `eval-timing.ts`
(Teil 1a: `collect-loop-work.ts` → `fit_loop_timing.py`). Neue Konstanten mit Herkunft in `timing.ts`, Entscheidung
E-034/E-037 nachführen.

### E. Bildschirm oder Ablauf übertragen (Menü, Ladebild, Zwischenbild, Spielende)

1. Ablauf im Quellcode und in einer Aufnahme ansehen ([Ablauf bis Level 1](original/startsequenz.md) als Muster).
2. Als `Screen` in `game/src/core/screens/` umsetzen, Texte nur über Sprachschlüssel ([Texte](texte.md)).
3. Ersetzte Ladezeiten: wie E-025/E-036 (Mindestdauer, dann weiter); Bedienhinweis siehe Status.
4. Test gegen die Aufnahme, Abschluss nach Ablauf F.

### F. Schritt abschließen

1. `npm test` und `npm run build` (aus `game/`, Build enthält die Typprüfung).
2. Im Browser nur das prüfen, was sich geändert hat (Vorschau „game“), Konsole ohne Fehler; Tablet-Viewport nur bei
   Änderungen an Darstellung oder Bedienung.
3. Wiki: Status (Verlauf mit 2–4 Zeilen, nächste Schritte), Features, Bugs/Entscheidungen nur bei Neuem.
4. Verbrauch: Plan-Limits erneut abfragen; Differenz zum Beginn (Woche und 5-Stunden-Fenster, Effort, Zahl der
   Sitzungen bzw. Compacts) in die Tabelle „Verbrauch je Schritt“ in [Status](status.md) eintragen. Liegt ein Reset
   dazwischen, das vermerken statt zu rechnen.
5. Kurzer Bericht an den Nutzer (mit dem Verbrauch): was jetzt läuft, was geprüft ist, was offen bleibt, nächster Schritt mit Ablauf und
   Effort-Empfehlung. Dann anhalten.
