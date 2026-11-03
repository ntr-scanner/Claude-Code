---
name: project-biblioteca
description: "Biblioteca 1.0 (porta 8800) in Intrattenimento/biblioteca: lettore EPUB fatto in casa (DecompressionStream) e PDF (pdf.js 3.11.174 in vendor/), segnalibri, Open Library"
metadata:
  node_type: memory
  type: project
  originSessionId: af479898-ab23-4355-adc6-16deb3fb3e3d
  modified: 2026-11-03T10:59:55.856Z
---

Creata 2026-10-31. Base comune: [[project-intrattenimento-base]].
- `app/epub.js`: zip + OPF + toc con regex (testabile in Node). Capitoli ricostruiti elemento per elemento (KEEP/DROP), mai innerHTML; prima del DOMParser si tolgono script/style/on…= perché Chromium segnala alla CSP anche i documenti inerti.
- PDF: pdf.js classico (`window.pdfjsLib`, `isEvalSupported: false`), una pagina alla volta, niente livello di testo (shortcut).
- Server: sezioni `stato` (cap/pos/pagina/pct/finito), `segnalibri`, `info` (Open Library); `/api/ol/cerca`, `/api/ol/trama`, `/f/copertina/<id>` in cache `dati/cache/`.
- 1.2.0 (2026-11-03, «stessa metodologia di Musicoteca»): cartella ricordata (`BibliotecaServer.folder`, `~/.cache/vektora-biblioteca/cartella.json`, `/api/cartella` solo PC, `/api/disco`, `/f/disco/<0|1>/<rel>` con Range) + `dati/scaricati`; nella pagina `RemoteFile` (slice → Range, arrayBuffer) e `metaCache` per percorso. Pagina 🌐 Online (`online_libri.py`): Gutendex (`gutendex.com/books/?languages=&search=&page=`, 32 per pagina, EPUB `formats["application/epub+zip"]`, copertina `image/jpeg`) e Archive (`mediatype:texts AND format:EPUB AND NOT access-restricted-item:true`, file da `/metadata/<id>`: EPUB, poi Text PDF). Gutendex a volte impiega decine di secondi su una pagina nuova → timeout 60 s, e in errore la griglia si svuota. «Leggi subito» = fetch intero `/f/web?u=` → `File` → lettore esistente; per i libri online niente posizione né segnalibri salvati. `bookCard(b, onOpen)`: attenzione a `list.map(bookCard)` (passerebbe l'indice). Lettura vista nel browser NON verificata (pannello chiuso a metà prova): verificato via HTTP che EPUB e download arrivano (Divina Commedia 327 KB). LibGen/Anna's Archive esclusi per scelta (solo fonti legali).
