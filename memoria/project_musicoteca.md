---
name: project-musicoteca
description: "Musicoteca 1.2 (porta 8798) in Intrattenimento/Suite-Intrattenimento/musicoteca: tag, playlist, ruota, karaoke .lrc; dalla 1.2 cartella ricordata dal server, sezione Online (YouTube/SoundCloud/Archive + Classica), popup dettagli"
metadata:
  node_type: memory
  type: project
  originSessionId: af479898-ab23-4355-adc6-16deb3fb3e3d
  modified: 2026-11-03T10:30:24.256Z
---

Creata 2026-10-31. Base comune: [[project-intrattenimento-base]]. Fino alla 1.1 cartella solo dal selettore del browser.
- `app/tag.js`: ID3v2.2/2.3/2.4, MP4 ilst, FLAC (no ogg/opus: nome file). `logica.js`: parseName, buildLibrary, parseLrc, lineAt.
- Server: sezioni `brani` (n, preferito) e `playlist`; `/api/ascolto` e `/api/preferito` via `Archive.update`; karaoke in memoria (`/api/karaoke/*`, catalogo pubblicato dalla pagina del PC, comandi con numero crescente).
- Telefono: `/telecomando.html` (serve `--lan` + password). Karaoke dentro la Musicoteca per scelta dell'utente.

1.2.0 (2026-11-03, richiesta utente):
- **Cartella ricordata**: percorso scritto in ⚙ (solo dal PC) → `~/.cache/vektora-musicoteca/cartella.json` (come Galleria). `/api/disco` elenca cartella + `dati/scaricati`, file da `/f/disco/<0|1>/<rel>` con Range; nella pagina `RemoteFile` imita File (slice→fetch Range, text), così tag.js, lettore e karaoke restano uguali. Percorso «NomeCartella/rel» = stessa chiave del selettore del browser (ascolti e playlist restano). Selettore del browser rimasto come «solo per questa volta».
- **Online** (`online.py`): yt-dlp `ytsearch`/`scsearch` + API Internet Archive (`advancedsearch`; album → `/metadata/<id>` mp3). «Tutti» alterna le fonti. 🎻 Classica: Archive `collection:musopen OR subject:"classical music" OR subject:"musica classica"` (`subject:classical` da solo dava Pokémon ecc.), YT/SC aggiungono «classical music». CSP `media-src 'self'` → audio e copertine passano dal server (`/f/online?u=`, `/f/copertina?u=`) con whitelist di host https (anti-SSRF). YouTube/Archive girati con Range; SoundCloud solo HLS → scaricato in `%TEMP%/musicoteca-ascolto` (~7 s). Download solo dal PC, un lavoro alla volta in memoria, mp3 + copertina con ffmpeg; a lavoro «fatto» la pagina ricarica `/api/disco`. yt-dlp facoltativo, node passato come `js_runtimes`.
- **Vetrina** (stesso giorno, richiesta utente «fammi vedere tutte le musiche dei siti»): senza testo `VETRINA` in online.py → YouTube playlist «Top 100 Music Videos Italy» (Classica: `ytsearch:classical music`), SoundCloud `music-charts-us/sets/all-music-genres` (charts `discover/sets/charts-*` e music-charts-it danno 404; in playlist flat SC dà solo l'URL → titolo/artista dallo slug, niente copertina), Archive `collection:audio_music` per download. `pagina` 1-10 + «Mostra altri».
- **Bitwarden**: barra orizzontale nel login = animazione di riempimento `scale(1.2)` → `overflow-x: hidden` sulle dialog (vedi SERVER-LOCALI §5).
- **Popup dettagli**: `#pCover`/`#pInfo` sono bottoni → `#detailsDlg`.
- Brani online fuori da preferiti/playlist/ascolti (chiave = URL): versione minima concordata con l'utente.
- Test 15 (`python -B tests/test_server.py`; subprocess con `encoding="utf-8"` su Windows). Server di prova: launch.json «musicoteca-prova» porta 8897, dati temporanei, password con `base.Auth(...).set_password`.
- Insidia: in Git Bash un percorso `/c/...` dentro una stringa raw di Python diventa `C:\c\...` → usare `cygpath -w`.

**Why:** l'utente voleva Online «come Scaffale Mangawa ma con ascolto, un po' come Spotify», una sezione Classica e non riscegliere la cartella ogni volta.
**How to apply:** ricerca e download stanno in `online.py`; le correzioni ai siti valgono solo qui (Media Loader ha le sue).
