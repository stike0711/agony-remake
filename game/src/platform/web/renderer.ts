// WebGL2-Renderer: zeigt das indizierte Bild des Kerns an.
//   Durchgang 1: Index + Palette der Zeile (Copper) → Farbe, Extra-Halfbrite, Overlay; Ergebnis in eine Textur in
//                Originalauflösung.
//   Durchgang 2: diese Textur auf den Bildschirm skalieren – ganzzahlig, wenn das kaum Fläche kostet, sonst „scharf“
//                (ganzzahlig vergrößert gedacht, dann linear auf die Zielgröße; keine ungleich breiten Pixel).
// Der Bildausschnitt `display.view` wird in den sicheren Bereich (Safe Areas) eingepasst; rundherum ist, soweit
// Platz ist, der Rest des Bilds zu sehen, darüber hinaus Schwarz.

import { COLORS, type Display, MAX_HEIGHT, MAX_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH } from "../../core/display.ts";
import type { Renderer } from "../types.ts";

/** Ganzzahlig skalieren, solange das Bild dabei mindestens diesen Anteil der möglichen Größe erreicht. */
const INTEGER_SCALE_MIN_FILL = 0.9;

const VERTEX = `#version 300 es
in vec2 aPos;
out vec2 vUv;
void main() {
  // Bildzeile 0 liegt oben: v = 0 am oberen Rand
  vUv = vec2(aPos.x * 0.5 + 0.5, 0.5 - aPos.y * 0.5);
  gl_Position = vec4(aPos, 0.0, 1.0);
}`;

const PALETTE_PASS = `#version 300 es
precision highp float;
precision highp int;
precision highp usampler2D;
uniform usampler2D uIndex;
uniform usampler2D uPalette;
uniform usampler2D uOverlay;
uniform bool uEhb;
uniform bool uOverlayOn;
uniform uint uOverlayPalette[32];
uniform float uDim;
uniform ivec2 uOverlayDiv;
out vec4 outColor;

vec3 rgb12(uint c) {
  return vec3(float((c >> 8u) & 15u), float((c >> 4u) & 15u), float(c & 15u)) / 15.0;
}

void main() {
  // Zielzeile y der Farbtextur = Bildzeile y (Textur-Zeile 0 = oberste Bildzeile); Durchgang 2 dreht beim Anzeigen
  ivec2 p = ivec2(gl_FragCoord.xy);
  uint idx = texelFetch(uIndex, p, 0).r;
  uint col = texelFetch(uPalette, ivec2(int(idx & 31u), p.y), 0).r;
  if (idx >= 32u && uEhb) col = (col >> 1u) & 0x777u;
  vec3 c = rgb12(col);
  if (uOverlayOn) {
    c *= 1.0 - uDim;
    uint o = texelFetch(uOverlay, p / uOverlayDiv, 0).r;
    if (o != 0u) c = rgb12(uOverlayPalette[o & 31u]);
  }
  outColor = vec4(c, 1.0);
}`;

const SCALE_PASS = `#version 300 es
precision highp float;
uniform sampler2D uImage;
uniform vec2 uTexSize;
uniform vec2 uScale;
in vec2 vUv;
out vec4 outColor;
void main() {
  // „Sharp bilinear“: innerhalb eines Texels flach, nur am Übergang (≤ 1 Bildschirmpixel) linear gemischt
  vec2 texel = vUv * uTexSize;
  vec2 region = max(0.5 - 0.5 / uScale, 0.0);
  vec2 d = fract(texel) - 0.5;
  vec2 f = (d - clamp(d, -region, region)) * uScale + 0.5;
  outColor = texture(uImage, (floor(texel) + f) / uTexSize);
}`;

interface Layout {
  /** Gerätepixel je Lowres-Pixel */
  scale: number;
  /** linke obere Ecke des ganzen Bildausschnitts (WINDOW_*) in Gerätepixeln, y von oben */
  x: number;
  y: number;
}

export class WebGLRenderer implements Renderer {
  private readonly canvas: HTMLCanvasElement;
  private readonly safeArea: HTMLElement;
  private gl!: WebGL2RenderingContext;
  private palettePass!: WebGLProgram;
  private scalePass!: WebGLProgram;
  private indexTex!: WebGLTexture;
  private paletteTex!: WebGLTexture;
  private overlayTex!: WebGLTexture;
  private colorTex!: WebGLTexture;
  private fbo!: WebGLFramebuffer;
  private colorSize = { width: 0, height: 0 };
  private readonly overlayPalette = new Uint32Array(COLORS);
  private layout: Layout = { scale: 1, x: 0, y: 0 };
  private lastFrame = -1;
  private sizeDirty = true;
  private readonly lastView = { x: 0, y: 0, width: 0, height: 0 };
  private lastClient = { width: 0, height: 0, dpr: 0 };
  private readonly uniforms = new Map<string, WebGLUniformLocation | null>();
  private lost = false;

  constructor(canvas: HTMLCanvasElement, safeArea: HTMLElement) {
    this.canvas = canvas;
    this.safeArea = safeArea;
    this.init();
    canvas.addEventListener("webglcontextlost", (e) => {
      e.preventDefault();
      this.lost = true;
    });
    canvas.addEventListener("webglcontextrestored", () => {
      this.init();
      this.lost = false;
      this.lastFrame = -1;
    });
    const resize = (): void => {
      this.sizeDirty = true;
    };
    new ResizeObserver(resize).observe(canvas);
    window.addEventListener("resize", resize);
  }

  draw(display: Display): void {
    if (this.lost) return;
    // Größe oder Pixeldichte geändert? (zusätzlich zu ResizeObserver, der nicht in jeder Umgebung meldet)
    const cw = this.canvas.clientWidth, ch = this.canvas.clientHeight, dpr = window.devicePixelRatio || 1;
    if (cw !== this.lastClient.width || ch !== this.lastClient.height || dpr !== this.lastClient.dpr) {
      this.lastClient = { width: cw, height: ch, dpr };
      this.sizeDirty = true;
    }
    const v = display.view, last = this.lastView;
    const relayout = this.sizeDirty || v.x !== last.x || v.y !== last.y || v.width !== last.width || v.height !== last.height;
    if (relayout) this.resize(display);
    if (!relayout && display.frame === this.lastFrame) return;
    this.lastFrame = display.frame;
    const gl = this.gl;

    // Durchgang 1: Farben nachschlagen
    this.upload(display);
    gl.bindFramebuffer(gl.FRAMEBUFFER, this.fbo);
    gl.viewport(0, 0, display.width, display.height);
    gl.useProgram(this.palettePass);
    const ov = display.overlay;
    this.set1i(this.palettePass, "uEhb", display.ehb ? 1 : 0);
    this.set1i(this.palettePass, "uOverlayOn", ov.visible ? 1 : 0);
    gl.uniform1f(this.uniform(this.palettePass, "uDim"), ov.dim / 15);
    gl.uniform2i(this.uniform(this.palettePass, "uOverlayDiv"), display.hires ? 2 : 1, display.lace ? 2 : 1);
    this.overlayPalette.set(ov.palette);
    gl.uniform1uiv(this.uniform(this.palettePass, "uOverlayPalette"), this.overlayPalette);
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);

    // Durchgang 2: skalieren
    gl.bindFramebuffer(gl.FRAMEBUFFER, null);
    gl.viewport(0, 0, this.canvas.width, this.canvas.height);
    gl.clearColor(0, 0, 0, 1);
    gl.clear(gl.COLOR_BUFFER_BIT);
    const { scale, x, y } = this.layout;
    const w = Math.round(WINDOW_WIDTH * scale), h = Math.round(WINDOW_HEIGHT * scale);
    gl.viewport(x, this.canvas.height - y - h, w, h);
    gl.useProgram(this.scalePass);
    gl.activeTexture(gl.TEXTURE3);
    gl.bindTexture(gl.TEXTURE_2D, this.colorTex);
    this.set1i(this.scalePass, "uImage", 3);
    gl.uniform2f(this.uniform(this.scalePass, "uTexSize"), display.width, display.height);
    gl.uniform2f(this.uniform(this.scalePass, "uScale"), w / display.width, h / display.height);
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
  }

  toWindow(clientX: number, clientY: number): { x: number; y: number } | null {
    const r = this.canvas.getBoundingClientRect();
    const dpr = this.canvas.width / Math.max(1, r.width);
    const x = Math.floor(((clientX - r.left) * dpr - this.layout.x) / this.layout.scale);
    const y = Math.floor(((clientY - r.top) * dpr - this.layout.y) / this.layout.scale);
    return x >= 0 && y >= 0 && x < WINDOW_WIDTH && y < WINDOW_HEIGHT ? { x, y } : null;
  }

  private init(): void {
    const gl = this.canvas.getContext("webgl2", { antialias: false, alpha: false, depth: false, stencil: false, preserveDrawingBuffer: false });
    if (!gl) throw new Error("WebGL2 wird nicht unterstützt");
    this.gl = gl;
    this.palettePass = this.program(VERTEX, PALETTE_PASS);
    this.scalePass = this.program(VERTEX, SCALE_PASS);

    this.uniforms.clear();

    // Ein Rechteck über die ganze Zielfläche; aPos liegt in beiden Programmen auf Attribut 0
    const quad = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, quad);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 1, -1, -1, 1, 1, 1]), gl.STATIC_DRAW);
    gl.enableVertexAttribArray(0);
    gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 0, 0);

    gl.pixelStorei(gl.UNPACK_ALIGNMENT, 1);
    this.indexTex = this.intTexture(0, gl.R8UI, MAX_WIDTH, MAX_HEIGHT);
    this.paletteTex = this.intTexture(1, gl.R16UI, COLORS, MAX_HEIGHT);
    this.overlayTex = this.intTexture(2, gl.R8UI, WINDOW_WIDTH, WINDOW_HEIGHT);
    gl.useProgram(this.palettePass);
    this.set1i(this.palettePass, "uIndex", 0);
    this.set1i(this.palettePass, "uPalette", 1);
    this.set1i(this.palettePass, "uOverlay", 2);

    this.fbo = gl.createFramebuffer()!;
    this.colorSize = { width: 0, height: 0 };
    this.sizeDirty = true;
  }

  private upload(display: Display): void {
    const gl = this.gl;
    gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, this.indexTex);
    gl.texSubImage2D(gl.TEXTURE_2D, 0, 0, 0, display.width, display.height, gl.RED_INTEGER, gl.UNSIGNED_BYTE, display.pixels);
    gl.activeTexture(gl.TEXTURE1);
    gl.bindTexture(gl.TEXTURE_2D, this.paletteTex);
    gl.texSubImage2D(gl.TEXTURE_2D, 0, 0, 0, COLORS, display.height, gl.RED_INTEGER, gl.UNSIGNED_SHORT, display.palette);
    if (display.overlay.visible) {
      gl.activeTexture(gl.TEXTURE2);
      gl.bindTexture(gl.TEXTURE_2D, this.overlayTex);
      gl.texSubImage2D(gl.TEXTURE_2D, 0, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, gl.RED_INTEGER, gl.UNSIGNED_BYTE, display.overlay.pixels);
    }
    if (this.colorSize.width !== display.width || this.colorSize.height !== display.height) this.createColorTexture(display);
  }

  /** Zieltextur von Durchgang 1 in genau der Bildgröße des Modus (sonst würde linear über den Rand gemischt). */
  private createColorTexture(display: Display): void {
    const gl = this.gl;
    if (this.colorTex) gl.deleteTexture(this.colorTex);
    this.colorTex = gl.createTexture()!;
    gl.activeTexture(gl.TEXTURE3);
    gl.bindTexture(gl.TEXTURE_2D, this.colorTex);
    gl.texStorage2D(gl.TEXTURE_2D, 1, gl.RGBA8, display.width, display.height);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    gl.bindFramebuffer(gl.FRAMEBUFFER, this.fbo);
    gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, this.colorTex, 0);
    this.colorSize = { width: display.width, height: display.height };
  }

  private resize(display: Display): void {
    this.sizeDirty = false;
    const dpr = window.devicePixelRatio || 1;
    const r = this.canvas.getBoundingClientRect();
    const w = Math.max(1, Math.round(r.width * dpr)), h = Math.max(1, Math.round(r.height * dpr));
    if (this.canvas.width !== w || this.canvas.height !== h) {
      this.canvas.width = w;
      this.canvas.height = h;
    }
    this.updateLayout(display);
  }

  /** Bildausschnitt `view` in den sicheren Bereich einpassen. */
  private updateLayout(display: Display): void {
    const dpr = this.canvas.width / Math.max(1, this.canvas.getBoundingClientRect().width);
    const c = this.canvas.getBoundingClientRect(), s = this.safeArea.getBoundingClientRect();
    const ax = (s.left - c.left) * dpr, ay = (s.top - c.top) * dpr;
    const aw = Math.max(1, s.width * dpr), ah = Math.max(1, s.height * dpr);
    const v = display.view;
    Object.assign(this.lastView, v);
    let scale = Math.min(aw / v.width, ah / v.height);
    const whole = Math.floor(scale);
    if (whole >= 1 && whole / scale >= INTEGER_SCALE_MIN_FILL) scale = whole;
    this.layout = {
      scale,
      x: Math.round(ax + (aw - v.width * scale) / 2 - v.x * scale),
      y: Math.round(ay + (ah - v.height * scale) / 2 - v.y * scale),
    };
  }

  private intTexture(unit: number, format: number, width: number, height: number): WebGLTexture {
    const gl = this.gl;
    const tex = gl.createTexture()!;
    gl.activeTexture(gl.TEXTURE0 + unit);
    gl.bindTexture(gl.TEXTURE_2D, tex);
    gl.texStorage2D(gl.TEXTURE_2D, 1, format, width, height);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
    return tex;
  }

  private program(vs: string, fs: string): WebGLProgram {
    const gl = this.gl;
    const p = gl.createProgram()!;
    for (const [type, src] of [[gl.VERTEX_SHADER, vs], [gl.FRAGMENT_SHADER, fs]] as const) {
      const s = gl.createShader(type)!;
      gl.shaderSource(s, src);
      gl.compileShader(s);
      if (!gl.getShaderParameter(s, gl.COMPILE_STATUS)) throw new Error(`Shader: ${gl.getShaderInfoLog(s)}`);
      gl.attachShader(p, s);
    }
    gl.bindAttribLocation(p, 0, "aPos");
    gl.linkProgram(p);
    if (!gl.getProgramParameter(p, gl.LINK_STATUS)) throw new Error(`Programm: ${gl.getProgramInfoLog(p)}`);
    return p;
  }

  private set1i(p: WebGLProgram, name: string, value: number): void {
    this.gl.uniform1i(this.uniform(p, name), value);
  }

  /** Uniform-Adressen zwischenspeichern (getUniformLocation erzeugt jedes Mal ein neues Objekt). */
  private uniform(p: WebGLProgram, name: string): WebGLUniformLocation | null {
    const key = (p === this.palettePass ? "p:" : "s:") + name;
    let loc = this.uniforms.get(key);
    if (loc === undefined) {
      loc = this.gl.getUniformLocation(p, name);
      this.uniforms.set(key, loc);
    }
    return loc;
  }
}
