// Lokaler Webserver für den Referenz-Emulator (vAmigaWeb) mit den Original-Disketten von Agony.
// Aufruf: node tools/emulator/server.ts [--lan] [--port 8090]
//   --lan   auch im Heimnetz erreichbar machen (z. B. zum Testen auf dem Tablet)
//
// Routen:
//   /agony                    startet Agony (Disk 1 + Kickstart 1.3, Joystick an Port 2)
//   /local/kick13.rom         Kickstart 1.3 rev 34.5 (A500) aus reference/
//   /local/disks/<name>.adf   Spieldisketten aus reference/agony/game/Agony/
//   /local/dev-disks/<name>   Grolets Entwicklungsdisketten aus reference/source/…/Amiga_Disks/
//   /local/tools/<datei>      Hilfsskripte für den Browser aus tools/emulator/browser/ (z. B. agony-helpers.js)
//   POST /local/capture/<name>  speichert den Request-Body unter work/captures/<name> (Screenshots, Speicherabzüge)
//   GET  /local/capture/<name>  liefert eine Datei aus work/captures/ (z. B. Emulator-Schnappschüsse zum Laden)
//   alles andere              statische Dateien von vAmigaWeb (tools/emulator/vamigaweb/)
// Nichts davon verlässt den Rechner; reference/ wird nur gelesen.

import { createServer, type IncomingMessage, type ServerResponse } from "node:http";
import { createReadStream } from "node:fs";
import { mkdir, stat, writeFile } from "node:fs/promises";
import { dirname, extname, join, resolve, sep } from "node:path";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const projectRoot = resolve(here, "../..");

const args = process.argv.slice(2);
const lan = args.includes("--lan");
const portArg = args.indexOf("--port");
const port = portArg >= 0 ? Number(args[portArg + 1]) : Number(process.env.PORT ?? 8090);
const host = lan ? "0.0.0.0" : "127.0.0.1";

const VAMIGA_DIR = join(here, "vamigaweb");
const KICKSTART = join(
  projectRoot,
  "reference/agony/game/Kickstart Images (TOSEC-v0.03)/Kickstart v1.3 rev 34.5 (1987)(Commodore)(A500-A1000-A2000-CDTV)[!].rom",
);
const DISK_DIR = join(projectRoot, "reference/agony/game/Agony");
const DEV_DISK_DIR = join(projectRoot, "reference/source/YvesGrolet-sources/YvesDisks/Amiga_Disks");
const CAPTURE_DIR = join(projectRoot, "work/captures");
const TOOLS_DIR = join(here, "browser");

// Startparameter für vAmigaWeb (JSON im URL-Fragment, siehe get_parameter_link() in js/vAmiga_ui.js)
const AGONY_START = {
  url: "/local/disks/agony-1.adf",
  kickstart_rom_url: "/local/kick13.rom",
  port2: true,
  dialog_on_disk: false,
  dialog_on_missing_roms: false,
};

const MIME: Record<string, string> = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".mjs": "text/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".wasm": "application/wasm",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".gif": "image/gif",
  ".svg": "image/svg+xml",
  ".ico": "image/x-icon",
  ".mp3": "audio/mpeg",
  ".wav": "audio/wav",
  ".txt": "text/plain; charset=utf-8",
  ".md": "text/plain; charset=utf-8",
  ".map": "application/json; charset=utf-8",
};

function baseHeaders(res: ServerResponse): void {
  // Cross-Origin-Isolation erlaubt SharedArrayBuffer (Audio/Worker in vAmigaWeb)
  res.setHeader("Cross-Origin-Opener-Policy", "same-origin");
  res.setHeader("Cross-Origin-Embedder-Policy", "require-corp");
  res.setHeader("Cross-Origin-Resource-Policy", "same-origin");
  res.setHeader("Cache-Control", "no-cache");
}

function send(res: ServerResponse, status: number, text: string): void {
  res.writeHead(status, { "Content-Type": "text/plain; charset=utf-8" });
  res.end(text);
}

// Liefert eine Datei aus einem Verzeichnis aus; verhindert Ausbrüche per ../
async function serveFrom(res: ServerResponse, dir: string, relPath: string): Promise<void> {
  const file = resolve(dir, "." + sep + relPath);
  if (file !== dir && !file.startsWith(dir + sep)) return send(res, 403, "Forbidden");
  try {
    let target = file;
    let info = await stat(target);
    if (info.isDirectory()) {
      target = join(target, "index.html");
      info = await stat(target);
    }
    res.writeHead(200, {
      "Content-Type": MIME[extname(target).toLowerCase()] ?? "application/octet-stream",
      "Content-Length": info.size,
    });
    createReadStream(target).pipe(res);
  } catch {
    send(res, 404, "Not found");
  }
}

async function serveFile(res: ServerResponse, file: string): Promise<void> {
  return serveFrom(res, dirname(file), file.slice(dirname(file).length + 1));
}

async function readBody(req: IncomingMessage): Promise<Buffer> {
  const chunks: Buffer[] = [];
  for await (const chunk of req) chunks.push(chunk as Buffer);
  return Buffer.concat(chunks);
}

const server = createServer(async (req, res) => {
  baseHeaders(res);
  const url = new URL(req.url ?? "/", "http://localhost");
  const path = decodeURIComponent(url.pathname);

  if (req.method === "POST" && path.startsWith("/local/capture/")) {
    const name = path.slice("/local/capture/".length);
    if (!/^[A-Za-z0-9._-]+$/.test(name)) return send(res, 400, "Ungültiger Dateiname");
    await mkdir(CAPTURE_DIR, { recursive: true });
    const body = await readBody(req);
    await writeFile(join(CAPTURE_DIR, name), body);
    return send(res, 200, `gespeichert: work/captures/${name} (${body.length} Bytes)`);
  }

  if (req.method !== "GET" && req.method !== "HEAD") return send(res, 405, "Method not allowed");

  if (path === "/agony") {
    res.writeHead(302, { Location: "/#" + encodeURIComponent(JSON.stringify(AGONY_START)) });
    return res.end();
  }
  if (path === "/local/kick13.rom") return serveFile(res, KICKSTART);
  if (path.startsWith("/local/disks/")) return serveFrom(res, DISK_DIR, path.slice("/local/disks/".length));
  if (path.startsWith("/local/dev-disks/")) return serveFrom(res, DEV_DISK_DIR, path.slice("/local/dev-disks/".length));
  if (path.startsWith("/local/tools/")) return serveFrom(res, TOOLS_DIR, path.slice("/local/tools/".length));
  if (path.startsWith("/local/capture/")) return serveFrom(res, CAPTURE_DIR, path.slice("/local/capture/".length));
  if (path.startsWith("/local/")) return send(res, 404, "Not found");

  return serveFrom(res, VAMIGA_DIR, path === "/" ? "index.html" : path.slice(1));
});

server.listen(port, host, () => {
  console.log(`Emulator-Server läuft: http://localhost:${port}/agony` + (lan ? `  (im LAN erreichbar, Port ${port})` : ""));
});
