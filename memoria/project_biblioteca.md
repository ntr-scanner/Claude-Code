---
name: project-biblioteca
description: Biblioteca 1.0 (porta 8800) in Intrattenimento/biblioteca: lettore EPUB fatto in casa (DecompressionStream) e PDF (pdf.js 3.11.174 in vendor/), segnalibri, Open Library
metadata:
  type: project
---
Creata 2026-10-31. Base comune: [[project-intrattenimento-base]].
- `app/epub.js`: zip + OPF + toc con regex (testabile in Node). Capitoli ricostruiti elemento per elemento (KEEP/DROP), mai innerHTML; prima del DOMParser si tolgono script/style/on…= perché Chromium segnala alla CSP anche i documenti inerti.
- PDF: pdf.js classico (`window.pdfjsLib`, `isEvalSupported: false`), una pagina alla volta, niente livello di testo (shortcut).
- Server: sezioni `stato` (cap/pos/pagina/pct/finito), `segnalibri`, `info` (Open Library); `/api/ol/cerca`, `/api/ol/trama`, `/f/copertina/<id>` in cache `dati/cache/`.
