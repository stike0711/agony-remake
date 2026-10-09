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
    "ui.level3Stub": "LEVEL 3|COMING SOON",
    "ui.level4Stub": "LEVEL 4|COMING SOON",
    "ui.pressFire": "PRESS FIRE",
    "ui.spellFire": "FIRE MENU",
    "ui.on": "ON",
    "ui.off": "OFF",
    "ui.quit": "QUIT GAME",
    "ui.quitConfirm": "REALLY QUIT",
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
    "ui.level3Stub": "LEVEL 3|KOMMT BALD",
    "ui.level4Stub": "LEVEL 4|KOMMT BALD",
    "ui.pressFire": "FEUER DRÜCKEN",
    "ui.spellFire": "FEUERMENÜ",
    "ui.on": "AN",
    "ui.off": "AUS",
    "ui.quit": "SPIEL BEENDEN",
    "ui.quitConfirm": "WIRKLICH BEENDEN",
  },
} as const;

export type UiKey = keyof (typeof UI_TEXTS)["en"];
