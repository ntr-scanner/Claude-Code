---
name: project-musicoteca
description: Musicoteca 1.0 (porta 8798) in Intrattenimento/musicoteca: musica dai tag, playlist, ruota album, karaoke .lrc con telecomando dal telefono
metadata:
  type: project
---
Creata 2026-10-31. Base comune: [[project-intrattenimento-base]]. Cartella scelta col selettore del browser (file mai al server).
- `app/tag.js`: ID3v2.2/2.3/2.4, MP4 ilst, FLAC (no ogg/opus: nome file). `logica.js`: parseName, buildLibrary, parseLrc, lineAt.
- Server: sezioni `brani` (n, preferito) e `playlist`; `/api/ascolto` e `/api/preferito` via `Archive.update`; karaoke in memoria (`/api/karaoke/*`, catalogo pubblicato dalla pagina del PC, comandi con numero crescente).
- Telefono: `/telecomando.html` (serve `--lan` + password). Karaoke dentro la Musicoteca per scelta dell'utente.
