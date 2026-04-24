'use strict';

// Minimal "build" step: copy src/ to dist/. Deliberately dependency-free so
// that `npm ci` on this fixture is instant and offline-safe.
const fs = require('node:fs');
const path = require('node:path');

const srcDir = path.join(__dirname, '..', 'src');
const outDir = path.join(__dirname, '..', 'dist');

fs.rmSync(outDir, { recursive: true, force: true });
fs.mkdirSync(outDir, { recursive: true });

for (const entry of fs.readdirSync(srcDir, { withFileTypes: true })) {
  if (entry.isFile()) {
    fs.copyFileSync(path.join(srcDir, entry.name), path.join(outDir, entry.name));
  }
}

console.log(`[build] copied ${srcDir} -> ${outDir}`);
