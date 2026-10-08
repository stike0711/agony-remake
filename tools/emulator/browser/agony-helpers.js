// Hilfsfunktionen für Aufnahmen aus vAmigaWeb. Im Browser-Tab des Emulators laden:
//   await import("/local/tools/agony-helpers.js")   → stellt window.AG bereit
// Bilder und Speicherabzüge landen über den Emulator-Server in work/captures/.

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

// Bildnummer des Emulators (wasm_frame_info liefert frameNr << 2 | prevLOF << 1 | currLOF)
function frameNr() {
  return Module._wasm_frame_info() >>> 2;
}

async function waitFrames(n) {
  const start = frameNr();
  while (frameNr() - start < n) await sleep(10);
}

// Ganzes PAL-Bild als RGBA: HPIXELS × VPIXELS Texel (1824 × 313), 4 Texel pro Lowres-Pixel
function grabRGBA() {
  const w = HPIXELS;
  const h = VPIXELS;
  const ptr = Module._wasm_pixel_buffer();
  return { w, h, rgba: new Uint8ClampedArray(Module.HEAPU8.buffer.slice(ptr, ptr + w * h * 4)) };
}

// Auf Lowres-Auflösung reduzieren: von je 4 Texeln den ersten nehmen (456 × 313)
function toLores({ w, h, rgba }) {
  const lw = w / 4;
  const out = new Uint8ClampedArray(lw * h * 4);
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < lw; x++) {
      const s = (y * w + x * 4) * 4;
      const d = (y * lw + x) * 4;
      out[d] = rgba[s];
      out[d + 1] = rgba[s + 1];
      out[d + 2] = rgba[s + 2];
      out[d + 3] = 255;
    }
  }
  return { w: lw, h, rgba: out };
}

async function toPng({ w, h, rgba }) {
  const pixels = new Uint8ClampedArray(rgba);
  for (let i = 3; i < pixels.length; i += 4) pixels[i] = 255;
  const canvas = new OffscreenCanvas(w, h);
  canvas.getContext("2d").putImageData(new ImageData(pixels, w, h), 0, 0);
  return canvas.convertToBlob({ type: "image/png" });
}

async function save(name, body) {
  const res = await fetch("/local/capture/" + name, { method: "POST", body });
  const text = await res.text();
  if (!res.ok) throw new Error(text);
  return text;
}

// Bildschirmfoto als PNG speichern (Standard: Lowres 456 × 313, mit full: true das ganze Texelbild)
async function shot(name, { full = false } = {}) {
  let img = grabRGBA();
  if (!full) img = toLores(img);
  return save(name + ".png", await toPng(img));
}

// Amiga-Speicher lesen (16-Bit-weise, big-endian)
function peekBlock(start, len) {
  const out = new Uint8Array(len);
  for (let i = 0; i < len; i += 2) {
    const v = wasm_peek16(start + i);
    out[i] = v >> 8;
    out[i + 1] = v & 0xff;
  }
  return out;
}

// Speicherabzug: Chip-RAM ($000000, 512 KB) und Slow-RAM ($C00000, 512 KB) eines A500
async function dump(name) {
  const chip = await save(name + "_chip.bin", peekBlock(0x000000, 0x80000));
  const slow = await save(name + "_slow.bin", peekBlock(0xc00000, 0x80000));
  return [chip, slow];
}

// Joystick an Port 2, linke Maustaste an Port 1
function joy(cmd) {
  wasm_joystick("2" + cmd);
}
// Joystick an Port 2 als Bitmaske wie im Nachbau (JOY_*: 1 hoch, 2 runter, 4 links, 8 rechts, 16 Feuer)
function setJoy(b) {
  joy(b & 4 ? "PULL_LEFT" : b & 8 ? "PULL_RIGHT" : "RELEASE_X");
  joy(b & 1 ? "PULL_UP" : b & 2 ? "PULL_DOWN" : "RELEASE_Y");
  joy(b & 16 ? "PRESS_FIRE" : "RELEASE_FIRE");
}
// Eingabeliste [Bild, Knöpfe] (wie game/test/runs.ts) als `actions` für traceRun, recordHires und profileRun
function joyActions(list) {
  return Object.fromEntries(list.map(([f, b]) => [f, () => setJoy(b)]));
}
async function fire(ms = 200) {
  joy("PRESS_FIRE");
  await sleep(ms);
  joy("RELEASE_FIRE");
}
async function mouseClick(ms = 200) {
  Module._wasm_mouse_button(1, 1, 1);
  await sleep(ms);
  Module._wasm_mouse_button(1, 1, 0);
}

// Spieldiskette n (1–3) in DF0 einlegen
async function insertDisk(n) {
  const bytes = new Uint8Array(await (await fetch(`/local/disks/agony-${n}.adf`)).arrayBuffer());
  return wasm_loadfile(`agony-${n}.adf`, bytes, 0);
}

// Einfache Prüfsumme des Lowres-Bilds, um Bildwechsel zu erkennen
function signature() {
  const { rgba } = toLores(grabRGBA());
  let s = 0;
  for (let i = 0; i < rgba.length; i += 16) s = (s * 31 + rgba[i] + rgba[i + 1] * 3 + rgba[i + 2] * 7) >>> 0;
  return s;
}

// Bildfolge aufnehmen: `count` Bilder im Abstand von `every` Emulator-Bildern
async function record(prefix, { every = 25, count = 40 } = {}) {
  const t0 = frameNr();
  const log = [];
  for (let i = 0; i < count; i++) {
    const f = frameNr() - t0;
    await shot(`${prefix}_${String(i).padStart(3, "0")}_f${String(f).padStart(5, "0")}`);
    log.push(f);
    await waitFrames(every);
  }
  return log;
}

// Wartet, bis sich das Bild ändert (oder bis zum Timeout in Emulator-Bildern)
async function waitForChange(maxFrames = 1500) {
  const before = signature();
  const start = frameNr();
  while (frameNr() - start < maxFrames) {
    await waitFrames(5);
    if (signature() !== before) return frameNr() - start;
  }
  return -1;
}

// ---- Schrittweises Ausführen --------------------------------------------------------------
// Unabhängig von requestAnimationFrame (läuft auch, wenn der Browser-Tab nicht sichtbar ist) und
// bildgenau reproduzierbar. Etwa 8× Echtzeit. Vorher halt() aufrufen, damit die normale
// Ausführung von vAmigaWeb nicht zusätzlich Bilder berechnet.

function halt() {
  wasm_halt();
}

// n Emulator-Bilder ausführen; liefert die Zahl der Bilder, nach denen ein Haltepunkt ausgelöst hat (sonst -1)
function step(n = 1) {
  for (let i = 0; i < n; i++) {
    if (Module._wasm_execute_one_frame() != 0) return i;
  }
  return -1;
}

// Bilder ausführen, bis sich das Bild ändert; liefert die Zahl der ausgeführten Bilder (oder -1)
function stepUntilChange(maxFrames = 3000, chunk = 5) {
  const before = signature();
  for (let done = 0; done < maxFrames; done += chunk) {
    step(chunk);
    if (signature() !== before) return done + chunk;
  }
  return -1;
}

// Taste/Feuer für eine Anzahl Bilder halten
function holdFire(frames = 10) {
  joy("PRESS_FIRE");
  step(frames);
  joy("RELEASE_FIRE");
}
function holdMouse(frames = 10) {
  Module._wasm_mouse_button(1, 1, 1);
  step(frames);
  Module._wasm_mouse_button(1, 1, 0);
}

// Bildfolge schrittweise aufnehmen: `count` Bilder im Abstand von `every` Emulator-Bildern
async function recordStepped(prefix, { every = 10, count = 50, start = 0 } = {}) {
  const log = [];
  for (let i = 0; i < count; i++) {
    const n = start + i * every;
    await shot(`${prefix}_f${String(n).padStart(5, "0")}`);
    log.push(n);
    step(every);
  }
  return log;
}

// ---- Schnelle Rohaufnahme ------------------------------------------------------------------
// PNG-Erzeugung im Browser ist langsam, besonders bei ausgeblendetem Tab. recordRaw sammelt
// Lowres-Bilder als rohe RGB-Daten (456 × 313 × 3 Byte je Bild) und speichert sie in einer Datei:
//   <name>_456x313_<anzahl>_every<abstand>.rgb
// Umwandeln in PNGs und Übersichtstafel: python tools/analysis/raw_frames.py work/captures/<datei>

function grabLoresRGB() {
  const { w, h, rgba } = toLores(grabRGBA());
  const rgb = new Uint8Array(w * h * 3);
  for (let i = 0, j = 0; i < rgba.length; i += 4, j += 3) {
    rgb[j] = rgba[i];
    rgb[j + 1] = rgba[i + 1];
    rgb[j + 2] = rgba[i + 2];
  }
  return rgb;
}

async function recordRaw(name, { every = 10, count = 100 } = {}) {
  const frameSize = 456 * 313 * 3;
  const buf = new Uint8Array(count * frameSize);
  const start = frameNr();
  for (let i = 0; i < count; i++) {
    buf.set(grabLoresRGB(), i * frameSize);
    step(every);
  }
  const file = `${name}_456x313_${count}_every${every}_from${start}.rgb`;
  return save(file, buf);
}

// ---- Volle Auflösung: Hires und Interlace ----------------------------------------------------
// Hires = jeder 2. Texel (912 × 313). Im Interlace-Modus zeigt jedes Emulator-Bild nur ein Halbbild;
// wasm_frame_info meldet im untersten Bit, ob es das lange (LOF = 1) oder kurze Halbbild ist. Wie in der
// Mischstufe von vAmigaWeb liefert das lange Halbbild die geraden, das kurze die ungeraden Zeilen.
// Ergebnis: 912 × 626, gleiche Rohdatei-Schreibweise wie recordRaw (raw_frames.py versteht beide).

function lof() {
  return Module._wasm_frame_info() & 1;
}

function grabHiresRGB() {
  const { w, h, rgba } = grabRGBA();
  const hw = w / 2;
  const rgb = new Uint8Array(hw * h * 3);
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < hw; x++) {
      const s = (y * w + x * 2) * 4;
      const d = (y * hw + x) * 3;
      rgb[d] = rgba[s];
      rgb[d + 1] = rgba[s + 1];
      rgb[d + 2] = rgba[s + 2];
    }
  }
  return rgb;
}

// Aktuelles und nächstes Halbbild verschränken (führt dafür 1 Emulator-Bild aus)
function grabInterlaceRGB() {
  const a = grabHiresRGB();
  const lofA = lof();
  step(1);
  const b = grabHiresRGB();
  const [long, short] = lofA ? [a, b] : [b, a];
  const line = 912 * 3;
  const out = new Uint8Array(line * 626);
  for (let y = 0; y < 313; y++) {
    out.set(long.subarray(y * line, (y + 1) * line), 2 * y * line);
    out.set(short.subarray(y * line, (y + 1) * line), (2 * y + 1) * line);
  }
  return out;
}

async function recordInterlace(name, { every = 10, count = 20 } = {}) {
  const frameSize = 912 * 626 * 3;
  const buf = new Uint8Array(count * frameSize);
  const start = frameNr();
  for (let i = 0; i < count; i++) {
    buf.set(grabInterlaceRGB(), i * frameSize);
    step(Math.max(0, every - 1));
  }
  return save(`${name}_912x626_${count}_every${every}_from${start}.rgb`, buf);
}

// Hires ohne Interlace, jedes Bild einzeln und auf einen Ausschnitt beschnitten (z. B. Statuszeile + Spielfeld):
//   <name>_<b>x<h>_<anzahl>_every<abstand>_from<bild>_at<x>x<y>.rgb   (x in Hires-Texeln, y = Rasterzeile)
// Mit `actions` lassen sich wie bei traceRun Eingaben an Bildnummern hängen.

async function recordHires(name, { every = 1, count = 100, x = 0, y = 0, w = 912, h = 313, actions = {} } = {}) {
  const frameSize = w * h * 3;
  const buf = new Uint8Array(count * frameSize);
  const start = frameNr();
  for (let i = 0; i < count; i++) {
    const full = grabHiresRGB();
    for (let r = 0; r < h; r++) buf.set(full.subarray(((y + r) * 912 + x) * 3, ((y + r) * 912 + x + w) * 3), i * frameSize + r * w * 3);
    for (let k = 0; k < every; k++) {
      actions[frameNr()]?.();
      step(1);
    }
  }
  return save(`${name}_${w}x${h}_${count}_every${every}_from${start}_at${x}x${y}.rgb`, buf);
}

// ---- Schnappschüsse --------------------------------------------------------------------------
// Ganzer Emulatorzustand (inklusive Disketten) als <name>.vAmiga in work/captures/. Damit lässt sich eine
// Stelle, z. B. der Beginn der Titelsequenz, beliebig oft ab demselben Bild abspielen, ohne neu zu booten.

async function snapshot(name) {
  const info = JSON.parse(wasm_take_user_snapshot());
  const bytes = new Uint8Array(Module.HEAPU8.buffer, info.address, info.size).slice();
  wasm_delete_user_snapshot();
  return save(name + ".vAmiga", bytes);
}

async function restore(name) {
  const res = await fetch("/local/capture/" + name + ".vAmiga");
  if (!res.ok) throw new Error(`Schnappschuss ${name} nicht gefunden`);
  const result = wasm_loadfile(name + ".vAmiga", new Uint8Array(await res.arrayBuffer()), 0);
  halt();
  return result;
}

// ---- Ablaufspur ------------------------------------------------------------------------------
// Für den bildgenauen Vergleich mit dem Nachbau: Nach jedem Emulator-Bild werden ausgewählte Speicherwörter und die
// Farbe eines Bildpunkts (Lowres-Koordinaten im 456 × 313-Bild) festgehalten. Mehrere Aufrufe hängen an dieselbe
// Spur an (lange Läufe in Abschnitten, damit der Browser nicht blockiert); traceSave schreibt sie als
//   <name>.trace.json  { words: [[Adresse, Anzahl] …], pixel: [x, y], rows: [[Bild, RGB, Wort …] …] }
// Aktionen (z. B. Feuer drücken) lassen sich über `actions` an bestimmte Bildnummern hängen.

let traceState = null;

function traceStart({ words, pixel = [20, 20] }) {
  traceState = { words, pixel, rows: [] };
}

function traceRun(frames, actions = {}) {
  const { words, pixel, rows } = traceState;
  for (let i = 0; i < frames; i++) {
    const f = frameNr();
    actions[f]?.();
    if (Module._wasm_execute_one_frame() != 0) return i;
    const ptr = Module._wasm_pixel_buffer() + (pixel[1] * HPIXELS + pixel[0] * 4) * 4;
    const px = Module.HEAPU8;
    const row = [frameNr(), (px[ptr] << 16) | (px[ptr + 1] << 8) | px[ptr + 2]];
    for (const [addr, count] of words) for (let k = 0; k < count; k++) row.push(wasm_peek16(addr + 2 * k));
    rows.push(row);
  }
  return -1;
}

async function traceSave(name) {
  const { words, pixel, rows } = traceState;
  return save(name + ".trace.json", JSON.stringify({ words, pixel, rows }));
}

// ---- Debug-Konsole und Zeitprofil ----------------------------------------------------------
// shell(cmd): Befehl in der RetroShell ausführen (führt dafür ein Bild aus), liefert den Text ab dem Befehl.
// profile(name, { snapshot, pcs, until, actions }): Haltepunkte an Programmstellen setzen und den Lauf ab einem
// Schnappschuss aufzeichnen; je Treffer [Bild (frameNr während des Bilds), PC, Zeile 0–312, Farbtakt] →
// work/captures/<name>.profile.json. Eigenheiten (W-014): erst nach dem Laden des Schnappschusses zwei Bilder
// ausführen, dann die Haltepunkte setzen; kein Haltepunkt am Einstieg des Level-3-Interrupts (Zeile 0), sonst kommen
// Joystick-Eingaben nicht an.

function shell(cmd) {
  wasm_retro_shell_press_special(9, 0);
  wasm_retro_shell_press_special(7, 0);
  for (const ch of cmd) wasm_retro_shell_press_key(ch.charCodeAt(0));
  wasm_retro_shell_press_special(12, 0);
  step(1);
  const t = wasm_retro_shell_get_text();
  const i = t.lastIndexOf(cmd.slice(1));
  return i >= 0 ? t.slice(i) : t.slice(-3000);
}

// Haltepunkte setzen: alle Befehle eingeben und erst dann ein Bild ausführen (je Befehl ein Bild verschöbe den Beginn
// der Messung über die ersten Treffer hinaus)
function setBreakpoints(pcs) {
  shell("debugger");
  for (const pc of pcs) {
    for (const ch of "break at $" + pc.toString(16)) wasm_retro_shell_press_key(ch.charCodeAt(0));
    wasm_retro_shell_press_special(12, 0);
  }
  step(1);
}

async function profile(name, { snapshot, pcs, until, actions = {} }) {
  await restore(snapshot);
  Module._wasm_execute_one_frame();
  Module._wasm_execute_one_frame();
  setBreakpoints(pcs);
  const hits = [];
  let guard = 0;
  while (frameNr() < until && guard++ < 300000) {
    const r = Module._wasm_execute_one_frame();
    if (r === 0) {
      actions[frameNr()]?.();
      continue;
    }
    const m = [...wasm_retro_shell_get_text().slice(-200).matchAll(/\$([0-9a-f]{6}):/g)].pop();
    const vh = wasm_peek16(0xdff006);
    hits.push([frameNr(), m ? parseInt(m[1], 16) : -1, ((wasm_peek16(0xdff004) & 1) << 8) | (vh >> 8), vh & 0xff]);
  }
  for (let i = pcs.length - 1; i >= 0; i--) shell("break delete " + i);
  return save(name + ".profile.json", JSON.stringify({ pcs, hits }));
}


// Fortsetzbares Zeitprofil für lange Läufe (W-013: höchstens ≈ 2.000 Bilder je Aufruf):
//   await AG.profileStart({ snapshot, pcs });  AG.profileRun(2000, actions, everyFrame);  await AG.profileSave(name)
// everyFrame(frameNr) wird nach jedem vollständigen Bild aufgerufen (z. B. Leben auffüllen per wasm_poke).
let profileState = null;

async function profileStart({ snapshot, pcs }) {
  await restore(snapshot);
  Module._wasm_execute_one_frame();
  Module._wasm_execute_one_frame();
  setBreakpoints(pcs);
  profileState = { pcs, hits: [] };
}

function profileRun(frames, actions = {}, everyFrame = null) {
  const { hits } = profileState;
  const until = frameNr() + frames;
  let guard = 0;
  while (frameNr() < until && guard++ < 50 * frames + 1000) {
    const r = Module._wasm_execute_one_frame();
    if (r === 0) {
      actions[frameNr()]?.();
      everyFrame?.(frameNr());
      continue;
    }
    const m = [...wasm_retro_shell_get_text().slice(-200).matchAll(/\$([0-9a-f]{6}):/g)].pop();
    const vh = wasm_peek16(0xdff006);
    hits.push([frameNr(), m ? parseInt(m[1], 16) : -1, ((wasm_peek16(0xdff004) & 1) << 8) | (vh >> 8), vh & 0xff]);
  }
  return frameNr();
}

async function profileSave(name) {
  const { pcs, hits } = profileState;
  for (let i = pcs.length - 1; i >= 0; i--) shell("break delete " + i);
  return save(name + ".profile.json", JSON.stringify({ pcs, hits }));
}

const AG = { setBreakpoints, sleep, frameNr, waitFrames, grabRGBA, toLores, shot, save, peekBlock, dump, joy, setJoy, joyActions, fire, mouseClick, insertDisk, signature, record, waitForChange, halt, step, stepUntilChange, holdFire, holdMouse, recordStepped, grabLoresRGB, recordRaw, lof, grabHiresRGB, grabInterlaceRGB, recordInterlace, recordHires, snapshot, restore, traceStart, traceRun, traceSave, shell, profile, profileStart, profileRun, profileSave };
window.AG = AG;
export default AG;
