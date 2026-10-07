---
name: project-generatore-firma
description: "Generatore di firma grafica offline (file HTML singolo, ~2,3 MB) in Tool for Work/Generatore Firme Digitale: modalità, PDF, insidie"
metadata:
  node_type: memory
  type: project
  originSessionId: 272fe237-ee9c-422d-967f-b0a29bef2354
  modified: 2026-10-06T13:13:44.669Z
---

`Tool for Work/Generatore Firme Digitale/generatore-firma.html`: un solo file HTML offline, nessuna dipendenza esterna a runtime. Copia pre-PDF e originale solo nello scratchpad di sessione (non persistenti).

Funzioni (ottobre 2026): 3 modalità (nome con 8 font OFL incorporati, disegno a mano con stilografica simulata dalla velocità + stabilizzatore, firma da foto con sfondo stimato a celle 32 px), sigla, PNG trasparente/bianco/2-4×/larghezza fissa 300-600-1200, SVG solo per il disegno, copia appunti compatibile Safari, firme salvate (localStorage `generatore-firma:salvate:v1`), stato in `generatore-firma:v1` con casella "Ricorda", firma di PDF.

PDF: pdf-lib 1.17.1 (MIT) + pdf.js 3.11.174 (Apache) incorporati in fondo come `<script type="text/plain">` e iniettati solo al primo PDF; worker di pdf.js nel thread principale (`globalThis.pdfjsWorker`) per funzionare da file://. `isEvalSupported:false` obbligatorio (CVE-2024-4367). Posizioni convertite con `viewport.convertToPdfPoint` (gestisce rotazione e CropBox).

**Why:** strumento di lavoro dell'utente, deve restare un file singolo apribile offline.
**How to apply:** per test usare il server `generatore-firma` (porta 8083) in `.claude/launch.json`, perché il pannello browser apre i file come `data:`. Nel pannello nascosto `requestAnimationFrame` non scatta: nei test sostituirlo con `setTimeout`. Il salvataggio su `pagehide` riscrive lo storage: per pulirlo usare un'altra pagina dello stesso server. Con Edit, le sequenze `\u` nel testo vengono convertite in caratteri: per scriverle usare sed a livello di byte.
