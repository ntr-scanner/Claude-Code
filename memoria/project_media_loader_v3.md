---
name: project-media-loader-v3
description: "Media Loader v3 in `Cybersecurity/Script/Media Loader v3/`: app web in finestra (app.py + interfaccia/), terminale muto; unica versione dal 2026-10-18 (v2 integrata ed eliminata, .git qui)"
metadata:
  node_type: memory
  type: project
  originSessionId: 140c28f0-3678-4588-9f54-78db07fec960
  modified: 2026-10-18T10:53:31.800Z
---

Creata il 2026-10-18 su richiesta dell'utente: copia di `Media Loader` (v2, intatta) senza Download, dashboard Scaffale (progetto a sé, resta separato), .venv, .git. Avvio `./medialoader.sh` / `medialoader.bat` → `app.py`: server stdlib solo 127.0.0.1:8800 (+19 porte), finestra `brave --app` (fallback Chrome/Edge, poi webbrowser). L'utente voleva "finestra desktop" ma ha accettato web app; pywebview scartato (WebKitGTK dava errore GLib).

Come funziona: stdout/stderr sostituiti da un instradatore per thread (output di ogni download → suo lavoro, il resto scartato: terminale con sola riga di avvio e "Chiuso."); `input()` sostituito: le domande dei motori (file esistente a/b/c, 301, nome) compaiono nella coda con pulsanti. Annullo = eccezione `Annullato(BaseException)` alla prossima scrittura del thread. Avanzamento dedotto da `%` o `n/m` nelle righe. Due download paralleli. Senza battito dalla finestra per 30 s e senza download attivi il server si spegne. `main.py` v3: `scarica_manga(url, title, nome_cartella)` estratta dal menu, gallery-dl via Popen con righe passate a print.

Test: `test_app.py` (21), `test_manga_capitoli.py` (16). Test reali via Playwright + Brave snap (vedi [[project-scaffale-dashboard]] per il setup) il 2026-10-18: YouTube video/MP3, domanda file esistente, AnimeWorld, Mgeko (annullo + ripresa), Webtoons, XNXX nativo e yt-dlp, xHamster, HentaiGasm, HentaiMama, dominio sconosciuto, sistema/chiusura.

Corretti in v3 (bug anche della v2, non riportati): `detect_platform` su host intero (xnxx.com veniva preso per x.com, reddit per t.co), HentaiMama MP4 diretti marcati hls, titoli xHamster (`.video-thumb-info__name`), CHAP_DIR accetta "[Season 1] Ep. 0".

Domini (2026-10-18, tecnica presa da VibraVid, cartella poi eliminata): `refresh_domains` scarica prima `https://domains-tracker.server66.workers.dev/get` (serve User-Agent; mappa TRACKER_KEYS: SC, AltaDefinizione, Eurostreaming, AnimeWorld, AnimeUnity), poi GET senza www forzato, scarta pagine parcheggiate (`_PARCHEGGIO`) e redirect a host senza `key[:5]`. Cache `~/.medialoader/site_domains.json` condivisa con la v2. Dominio manuale: Sistema → Domini dei siti (`/api/siti`, `imposta_dominio`). AltaDefinizione ora app Next.js: ricerca su `/api/v1/web/archive?q=` (download non provato). SC: version Inertia va letta da HTML con `html.unescape`. FilmSenzaLimiti e GuardaSerie: nessun dominio valido trovato (non nel tracker).

Link → `/api/analizza` restituisce `motore`: `episodi` (host con resolver), `nativo` (solo generic_hls: .m3u8/.mpd/.mp4), `ytdlp` (resto). Il vecchio "nativo" per siti adulti estraeva con yt-dlp e scaricava con httpx: PornHub dava 410. yt-dlp usa `impersona()` (curl_cffi, in requirements): senza, PornHub 403.

Prova nomi utente 2026-10-18 tutte riuscite: One Piece ep 2 (AnimeWorld), Tarzan 1999 (SC), Supersex 1-3 (SC), Tsf Monogatari 1 (HentaiGasm, yt-dlp), Solo Leveling cap. 1 (Mgeko, da/a), short YouTube, PornHub (yt-dlp).

Ancora rotti: ricerca adulti a 0 su Eporner, SpankBang, JavGuru, MissAV, NoodleMagazine, 141Jav, HentaiWorld.eu/.tv; mp4decrypt non installato.

Dal 2026-10-18 sera (richiesta utente) è l'unica versione: v2 `Media Loader` eliminata dopo aver portato l'ultima modifica (MangaDex `-o lang=en`, Manga.md), log e archivio gallery-dl (merge `insert or ignore`, 6120 voci); `.git` della v2 spostato qui (le modifiche risultano non committate, l'utente committa). Scaffale Mangawa è in `Progetti/Scaffale Mangawa/` (inbox vuota, non dipendeva dalla v2). Rimossi download_fix3/per_categoria/richiesti e test_downloads.py (quest'ultimo ignorava --help e scaricava davvero).

Aggiunte stessa sera: siti personali in Cerca (`~/.medialoader/siti_personali.json`, `search_personale` + `_risultati_lista` condivisa con WP), copertine (`SearchResult.cover` da SC/AD; altrimenti `/api/copertina?u=` legge og:image e scarica l'immagine col Referer del sito; solo URL usciti da /api/cerca, niente SVG), `_irraggiungibili` salvati in cache `_stato` e saltati in ricerca, ripristino dominio di prima se il tracker sbaglia, Webtoons + intervallo capitoli → 400 (gallery-dl non filtra episodi Webtoons). Test 22.

Ripresa (2026-10-18): classe `Sospesi` in app.py scrive `~/.medialoader/coda_in_sospeso.json` (`istanze` con battito ogni 5 s da `sorveglia`, `lavori` con la richiesta /api/scarica; episodi: una richiesta per episodio). Lavoro tolto a fine (anche errore/annullato); istanza ferma >30 s = interrotti → riquadro Riprendi/Scarta (`/api/riprendi`). Provato con kill -9 al 26%: yt-dlp riprende dal .part (28,9%), file completo. Episodi HLS ripartono da zero (temp dir persa). Test 22.

**Why:** l'utente voleva un'app interattiva senza testo che scorre, senza toccare la versione funzionante. **How to apply:** modifiche all'app partono da `app.py`/`interfaccia/`; i motori sono condivisi nel codice con la v2 ma copiati, quindi una correzione va portata a mano nell'altra versione se l'utente lo chiede.
