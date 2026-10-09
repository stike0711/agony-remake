// Reihenfolge der Bildschirme: Titelsequenz → Menü (Feuer: Story-Seite) → Ladebild → Level 1 → Ladebild → Level 2 →
// Ladebild → Level 3 → Ladebild → Level 4 → Ladebild → Level 5.
// Hier zentral verdrahtet, damit sich die Bildschirme nicht gegenseitig importieren.

import type { Screen } from "./game.ts";
import { FOREST, HIGHLANDS, MARSHES, MOUNTAINS, SEA } from "./level/layout.ts";
import { LevelScreen } from "./screens/level.ts";
import { LevelStub } from "./screens/level-stub.ts";
import { LOAD_FOREST, LOAD_HIGHLANDS, LOAD_MARSHES, LOAD_MOUNTAINS, LOAD_SEA, LoadingScreen } from "./screens/loading.ts";
import { MenuScreen } from "./screens/menu.ts";
import { TitleSequence } from "./screens/title.ts";

export function titleSequence(): Screen {
  return new TitleSequence(menu);
}

export function menu(): Screen {
  return new MenuScreen(() => new LoadingScreen(LOAD_SEA, level1));
}

function level1(): Screen {
  // Nach dem Spielende ins Menü (Highscore folgt), nach dem Levelende Ladebild load_forest (Quelle: Agony_Parent_.s,
  // LOAD FILE_2_4 bei ASM_Level=1), danach Level 2; an der ersten nicht übertragenen Stelle der Platzhalter
  return new LevelScreen(SEA, {
    gameOver: menu,
    levelDone: (shared) => new LoadingScreen(LOAD_FOREST, () => level2(shared)),
    unported: () => new LevelStub(menu, "ui.levelStub"),
  });
}

function level2(shared: Uint8Array): Screen {
  // Punkte, Leben, Äxte, Waffe und Zauber aus Level 1; nach dem Levelende Ladebild load_marshes (LOAD FILE_2_6 bei
  // ASM_Level=2; Abbild forest $3A9A: Datei $C), danach Level 3
  return new LevelScreen(FOREST, {
    gameOver: menu,
    levelDone: (next) => new LoadingScreen(LOAD_MARSHES, () => level3(next)),
    unported: () => new LevelStub(menu, "ui.level2Stub"),
  }, shared);
}

function level3(shared: Uint8Array): Screen {
  // Nach dem Levelende Ladebild load_mountains (Abbild marshes $3A9A: Datei $10), danach Level 4
  return new LevelScreen(MARSHES, {
    gameOver: menu,
    levelDone: (next) => new LoadingScreen(LOAD_MOUNTAINS, () => level4(next)),
    unported: () => new LevelStub(menu, "ui.level3Stub"),
  }, shared);
}

function level4(shared: Uint8Array): Screen {
  // Nach dem Levelende Ladebild load_highlands (Abbild mountains $3A9A: Datei $12), danach Level 5
  return new LevelScreen(MOUNTAINS, {
    gameOver: menu,
    levelDone: (next) => new LoadingScreen(LOAD_HIGHLANDS, () => level5(next)),
    unported: () => new LevelStub(menu, "ui.level4Stub"),
  }, shared);
}

function level5(shared: Uint8Array): Screen {
  // Nach dem Levelende vorläufig der Platzhalter für Level 6 (das Original lädt load_fire, Abbild highlands $3A9A:
  // Datei $14)
  return new LevelScreen(HIGHLANDS, {
    gameOver: menu,
    levelDone: () => new LevelStub(menu, "ui.level6Stub"),
    unported: () => new LevelStub(menu, "ui.level5Stub"),
  }, shared);
}
