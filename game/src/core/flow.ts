// Reihenfolge der Bildschirme: Titelsequenz → Menü (Feuer: Story-Seite) → Ladebild → Level 1.
// Hier zentral verdrahtet, damit sich die Bildschirme nicht gegenseitig importieren.

import type { Screen } from "./game.ts";
import { SEA } from "./level/layout.ts";
import { LevelScreen } from "./screens/level.ts";
import { LevelStub } from "./screens/level-stub.ts";
import { LoadingScreen } from "./screens/loading.ts";
import { MenuScreen } from "./screens/menu.ts";
import { TitleSequence } from "./screens/title.ts";

export function titleSequence(): Screen {
  return new TitleSequence(menu);
}

export function menu(): Screen {
  return new MenuScreen(() => new LoadingScreen({ asset: "load.sea" }, level1));
}

function level1(): Screen {
  // Nach dem Spielende ins Menü (Highscore folgt); an der ersten nicht übertragenen Stelle der Platzhalter
  return new LevelScreen(SEA, { gameOver: menu, unported: () => new LevelStub(menu) });
}
