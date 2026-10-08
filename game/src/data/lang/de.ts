// Deutsche Übersetzung der Seiten, die mit der Menüschrift gezeichnet werden (von Hand gepflegt, Wiki texte.md).
// Eine Zeichenkette pro Zeile, "" = Leerzeile. Gleiche Zeilenzahl wie im Original → dieselben y-Positionen;
// x wird immer neu zentriert. Erlaubte Zeichen: A–Z, 0–9, . : ( ) Ä Ö Ü , - und Leerzeichen; ß als SS schreiben.
// Fehlt eine Seite, gilt die englische (z. B. hiscore.writeProtect: entfällt im Nachbau).
// Stand: Entwürfe ❓, vom Nutzer noch gegenzulesen.

export const DE_PAGES: Readonly<Record<string, readonly string[]>> = {
  "credits.0": ["PSYGNOSIS", "PRÄSENTIERT", "", "AGONY", "VON", "ART AND MAGIC"],
  "credits.1": ["GRAFIK", "", "FRANCK SAUER", "MARC ALBINET"],
  "credits.2": ["PROGRAMMIERUNG", "", "YVES GROLET"],
  "credits.3": ["SPIELMUSIK", "", "JEROEN TEL"],
  "credits.4": ["PRODUZIERT", "VON", "", "STEVEN RIDING"],
  "credits.5": ["TITELMUSIK", "", "TIM WRIGHT", "FRANCK SAUER"],
  "credits.6": ["ABSPANNMUSIK", "", "ROBERT LING", "MARTIN WALL"],
  "credits.7": ["LADEMUSIK", "R. LING", "M. WALL", "M. SIMONS", "M. IVESON", "A. BRIMBLE"],
  "credits.8": ["PACKPROGRAMM", "FLASHBACK", "", "LAURENT", "LARMINIER"],
  "credits.9": ["DISKETTENLADER", "", "MICHEL JANSSENS"],
  "credits.10": ["QUALITÄTS-", "SICHERUNG", "", "GREG DUDDLE", "CHRIS STANLEY", "NICK BURCUMBE"],
  "credits.11": ["TITELBILD", "UND LOGO", "", "TONY ROBERTS", "ROGER DEAN"],
  "story.start": ["ALESTES", "VERWANDELT SICH", "IN EINE EULE.", "DIE ZEIT ZU", "KÄMPFEN IST", "GEKOMMEN."],
  "hiscore.enter": ["DU GEHÖRST NUN", "ZU DEN BESTEN", "SPIELERN.", "BITTE GIB DEINE", "INITIALEN EIN."],
};

/**
 * Statuszeile der Level (Text_Dat, Text 1–13 wie Text_Num), Schlüssel = Spieldatei des Levels. Gezeichnet ab Byte 10
 * der Statuszeile in der Statusschrift; erlaubte Zeichen: A–Z, 0–9, ! ? . , ( ) Ä Ö Ü und Leerzeichen. Führende
 * Leerzeichen wie im Original. Text 1–9: Zauber mit Dauer in Sekunden (zwei Ziffern vorn, Text 9 = kein Zauber).
 * Stand: Entwürfe ❓, vom Nutzer noch gegenzulesen.
 */
export const DE_STATUS: Readonly<Record<string, readonly string[]>> = {
  sea: [
    "15  ENERGIEUMKEHR.",
    "06  KREISENDER FEUERBALL.",
    "05  ZEITSTOPP.",
    "10  SCHWARZMAGISCHER SUCHER.",
    "08  PLASMASCHILD.",
    "06  SUPERBOMBE.",
    "12  UNVERWUNDBARKEIT.",
    "08  VORWÄRTSKRAFT.",
    "00  NICHT VERFÜGBAR.",
    "   P A U S E",
    "   ENDE",
    "   E X T R A L E B E N",
    "   ZUM STARTEN FEUER DRÜCKEN",
  ],
};
