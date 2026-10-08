// Vite-Konfiguration: Entwicklung (npm run dev), Build nach ../server (npm run build) und Tests (npm test).
import { defineConfig } from "vitest/config";

export default defineConfig({
  // Relative Pfade: das Spiel läuft aus jedem Unterordner eines Webservers und später in der nativen App.
  base: "./",
  build: {
    outDir: "../server",
    emptyOutDir: true,
    target: "es2022",
    // Spieldaten (public/data) werden 1:1 kopiert; nichts als data:-URL einbetten
    assetsInlineLimit: 0,
  },
  server: {
    port: 5173,
    strictPort: true,
    // Erreichbar im Heimnetz (Test auf dem Tablet)
    host: true,
    // Das Projekt liegt auf einem NAS: Änderungsmeldungen über das Netzlaufwerk kommen nicht an, daher Polling
    watch: { usePolling: true, interval: 300 },
  },
  preview: {
    port: 4173,
    strictPort: true,
    host: true,
  },
  test: {
    include: ["test/**/*.test.ts"],
    environment: "node",
  },
});
