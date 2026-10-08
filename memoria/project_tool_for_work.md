---
name: project-tool-for-work
description: "Work Tools (ex Tool for Work): 18 strumenti HTML a file singolo + Dashboard.html, convenzioni comuni, librerie incorporate e insidie di test"
metadata:
  node_type: memory
  type: project
  originSessionId: 56887b00-d567-4a4f-aa79-bc867bdf28e3
  modified: 2026-10-08T08:12:46.753Z
---

`Work Tools/` (rinominata dall'utente da "Tool for Work"; repo git già pubblicato, commit manuali) (ottobre 2026): `Dashboard.html` + `README.md` nella radice, ogni strumento nella sua cartella (nome con spazi, file kebab-case). L'utente vuole caricarla su GitHub. Nuovi tool del 2026-10-08: Rimozione Sfondo, OCR Testo, Scanner Documenti, Comprimi e Dividi PDF, Pulitore Metadati, Password e Hash, Preventivi e Fatture, Validatore Codici, Calcolatore Date e Ore, Firma Email, Confronto Testi, Generatore QR; poi Generatore Dati Fittizi (dati di test, email example.com, cellulari con "555"; rifiutata la parte "numeri che ricevono SMS"). Preesistenti: Convertitore Immagini (con upscaling Lanczos + Real-ESRGAN ONNX), Pdf Editor, Generatore Firme Digitale ([[project-generatore-firma]]), Attestati, Rubrica Colleghi.

Convenzioni: stile del Convertitore (token CSS chiaro/scuro, `.panel`, `.drop`), link "← Dashboard" (`../Dashboard.html`) nei tool nuovi, italiano. Librerie offline come `<script type="text/plain" id="lib-…">` in fondo al file, iniettate al primo uso (pdf.js + worker in pagina, `isEvalSupported:false`; pdf-lib; JSZip; qrcode-generator; dati comuni ISTAT `data-comuni`). AI e OCR da CDN al primo uso (ONNX Runtime Web 1.22.0, modelli Hugging Face in IndexedDB, Tesseract.js 6.0.1).

**Why:** l'utente vuole strumenti che funzionino con doppio clic, offline e senza inviare dati.
**How to apply:** un nuovo tool va in una cartella sua e nella lista `TOOLS` di Dashboard.html e nel README. Se lo script legge un `<script type="text/plain">` posto in fondo, deve partire su `DOMContentLoaded` (bug già visto in Validatore e QR). Test: server `tool-for-work` (porta 8084) in `.claude/launch.json`; il pannello browser non apre file >2 MB come `data:`; con pannello nascosto `requestAnimationFrame` non scatta (pdf.js render si blocca) e gli screenshot vanno in timeout. La console del pannello conserva errori di pagine precedenti.
