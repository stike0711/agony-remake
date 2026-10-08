// Neue Texte des Remakes (Optionsmenü, Hinweise), beide Sprachen von Hand gepflegt (Wiki texte.md).
// Nur Zeichen der Menüschrift verwenden; "|" trennt Zeilen. Sprachnamen stehen immer in ihrer eigenen Sprache.

export const UI_TEXTS = {
  en: {
    "ui.options": "OPTIONS",
    "ui.language": "LANGUAGE",
    "ui.language.en": "ENGLISH",
    "ui.language.de": "DEUTSCH",
    "ui.back": "BACK",
    "ui.rotate": "PLEASE TURN|YOUR DEVICE",
    "ui.tapToStart": "TAP TO START",
    "ui.pause": "PAUSE",
    "ui.levelStub": "LEVEL 1|COMING SOON",
    "ui.level2Stub": "LEVEL 2|COMING SOON",
    "ui.pressFire": "PRESS FIRE",
  },
  de: {
    "ui.options": "OPTIONEN",
    "ui.language": "SPRACHE",
    "ui.language.en": "ENGLISH",
    "ui.language.de": "DEUTSCH",
    "ui.back": "ZURÜCK",
    "ui.rotate": "BITTE GERÄT|DREHEN",
    "ui.tapToStart": "ZUM STARTEN|TIPPEN",
    "ui.pause": "PAUSE",
    "ui.levelStub": "LEVEL 1|KOMMT BALD",
    "ui.level2Stub": "LEVEL 2|KOMMT BALD",
    "ui.pressFire": "FEUER DRÜCKEN",
  },
} as const;

export type UiKey = keyof (typeof UI_TEXTS)["en"];
