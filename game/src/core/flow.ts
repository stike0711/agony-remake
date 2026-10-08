// Reihenfolge der Bildschirme: Titelsequenz → Menü (Feuer: Story-Seite) → Ladebild → Level 1 → Ladebild Level 2.
// Hier zentral verdrahtet, damit sich die Bildschirme nicht gegenseitig importieren.

import type { Screen } from "./game.ts";
import { SEA } from "./level/layout.ts";
import { LevelScreen } from "./screens/level.ts";
import { LevelStub } from "./screens/level-stub.ts";
import { LOAD_FOREST, LOAD_SEA, LoadingScreen } from "./screens/loading.ts";
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
  // LOAD FILE_2_4 bei ASM_Level=1), danach vorläufig der Platzhalter für Level 2; an der ersten nicht übertragenen
  // Stelle der Platzhalter
  return new LevelScreen(SEA, {
    gameOver: menu,
    levelDone: () => new LoadingScreen(LOAD_FOREST, () => new LevelStub(menu, "ui.level2Stub")),
    unported: () => new LevelStub(menu, "ui.levelStub"),
  });
}
