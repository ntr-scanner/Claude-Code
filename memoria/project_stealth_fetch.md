---
name: project-stealth-fetch
description: "stealth_fetch, pacchetto Python fetch anti-bot a 4 tier (curl_cffi→patchright→camoufox→flaresolverr), in Cybersecurity/Script/stealth/"
metadata:
  node_type: memory
  type: project
  originSessionId: 3b2c29ee-c990-4477-9ef2-4086fd9444d2
  modified: 2026-11-02T09:37:06.066Z
---

Pacchetto `stealth_fetch/` in `Cybersecurity/Script/stealth/` (spostato lì dall'utente il 2026-11-02; nato in `Documents/Scaffale` e `Documents/stealth`). CLI `python -m stealth_fetch` + libreria (`await fetch`, `fetch_sync`), README per GitHub, 86 test pytest offline.

Insidia: su Windows `curl_cffi.AsyncSession` si blocca in circa 1 richiesta su 5 (succede con qualsiasi event loop), mentre la versione sincrona no. Per questo http_tier e solver_tier usano `Session` sincrona dentro `asyncio.to_thread`.

Integrazioni (2026-11-02), copia identica di `stealth_fetch/` dentro ogni repo (niente install a parte, `curl_cffi` in requirements):
- `Cybersecurity/Script/Scaffale Mangawa/codice` (copia di Test/codice, remote ntr-scanner/Scaffale-Mangawa, 1.7.0): `scarica._testo` riprova con stealth_fetch su 403/429/503 o challenge; sito **Toongod** (Madara, `/webtoon/<slug>/`, img `data-src` su i.tngcdn.com; ricerca e `/home/page/N/` non verificati); pagina **Server** con «Scarica e integra» (`/api/componenti`, `/api/integra`: pip + patchright + camoufox[geoip], `camoufox fetch`, Chrome se manca). 97 controlli.
- `Cybersecurity/Script/Media Loader/codice`: `sites/search._get_chrome` ora passa da stealth_fetch (prima AsyncSession, che su Windows si blocca); EXTRA_PIP in `_pacchetti`/`_aggiorna_pacchetti`. `test_help` fallisce su Windows già da prima (cp1252).
- `detect.py`: marker `/cdn-cgi/challenge-platform/h/`, non `challenge-platform` (lo script jsd di Cloudflare sta anche nelle pagine normali).
Insidie: toongod è tutto dietro challenge Cloudflare; analizzarlo o scaricarlo da Claude è negato dal classificatore (download lo lancia l'utente). CDN img-r2.2xstorage.com dà 503 fisso su alcuni file (Regressed Warriors cap. 76-80): attese lunghe inutili, tolte. Server Scaffale tiene i file statici in memoria (STATIC): dopo modifiche a static/ va riavviato; su Windows due server possono ascoltare sulla stessa porta (risponde il vecchio).

Scaffale 1.8.0 (2026-11-02, `Cybersecurity/Script/Scaffale Mangawa/codice`): regole SERVER-LOCALI aggiunte su richiesta: password (accesso.py, regole Ayanokoji, cookie HttpOnly SameSite=Strict, /api/accesso/*), Sec-Fetch-Site, CSP senza unsafe-inline (data-style + MutationObserver → CSSOM), lockfile in %TEMP% con token per --stato/--spegni/--riavvio (header X-Scaffale-Locale), menu_app.py identico + icona.svg/.ico + --icona/--apri (pythonw; riavvio da staccato = rilancio staccato, SCAFFALE_STACCATO), backup.py (giornalieri, mensili zip incrementali verificati, prima-di), read_json recupera il .tmp. Ricerca: CERCA_MAX_S=15 per sito; 403 non si ripete in _get. Insidie Windows: NUL isatty() True; fsync vuole r+b; nomi prima-di con microsecondi. Test 130. Server di prova: launch.json `scaffale-mangawa-script` con --dati %TEMP%/scaffale-prova-dati.

Scaffale 1.9.0 (2026-11-02): sezione **Hentai** (modalità in localStorage, `loadLibrary` filtra per `serie.hentai`, body.hentai = accento rosa, pagina #/hentai con GENERI_HENTAI → /api/genere; /api/siti?hentai=, /api/cerca&hentai=). Siti nuovi: MangaRead (classe `Madara` generica, anche Toongod), MangaWorldAdult, NHentai (API v2 `/api/v2/search`, `/api/v2/galleries/<id>`, immagini i.nhentai.net), HentaiFox (load_dir/load_id + g_th). Minori esclusi: TAG_VIETATI in query nhentai (-tag:), titoli filtrati, link con tag vietati → ValueError; MWA: controllare solo il blocco «Generi:» (il menu del sito elenca lolicon in ogni pagina). NON_SUPPORTATI: hentai2read e simply-hentai (app JS), yagahentai (immagini 403). Mgread: `genre_exclude=40` + titoli «Anime –» esclusi. Toongod `bloccato`+`pagine_ok`: capitoli() prova prima le altre fonti (slug su ManhwaFan) senza toccare Toongod; run_download non chiede la scheda a Toongod. Il classificatore nega qualunque prova che contatti Toongod (anche il download da link): testare il ripiego solo offline. L'utente aveva chiesto di «risolvere» Cloudflare su Toongod: non fatto, spiegato. Test 144; test_dashboard ora cancella la sua cartella temporanea.

Scaffale 1.10.0: generi da non mostrare in `dati/esclusioni.json` (pagina Server, solo in modalità Hentai, quadrato blu, valgono al riavvio via scarica.ESCLUSI_UTENTE + `vietati()`/`_re_vietati()`); i TAG_VIETATI dei minori sono sempre attivi e NON disattivabili (l'utente chiedeva di poterli spegnere: rifiutato). Genere Futanari. AsmHentai aggiunto (paginazione `?page=N`, immagini da cartella della copertina + «Pages: N», estensione dalle miniature). Da theporndude provati: hentairox (estensione miniatura ≠ immagine), asmhentai ok; non ancora analizzati: hentaifantasy.it, hentaihere, doujins, multporn, hentaiclap, hentairun/doujiva (Next.js), hitomi (JS), hentaidb (video). Test 152.

Scaffale 1.11.0: HentaiFantasy.it (FoOlSlide, ricerca solo POST via `_post_testo`, pagine da `var pages`, generi tradotti oppai/monster_girl) e Doujins (immagini firmate data-file, novità solo home) aggiunti; NON_SUPPORTATI estesi (hentaiclap come rox, multporn, hitomi, hentairun, doujiva, hentaidb). Serie hentai in `biblioteca/_Hentai/` (HENTAI_DIR, `series_dir` cerca lì prima, `cartelle_serie()`, `sposta_serie` su PATCH e all'avvio). `_re_vietati` accetta anche `_` come separatore. Test 159.

**Why:** i tier patchright e camoufox non sono mai stati eseguiti dal vivo (non installati al momento della creazione); nessun repo git nella cartella.
**How to apply:** prima di modificare i tier browser, installarli (`patchright install chrome`, `camoufox fetch`) e provarli davvero. Per i test usare un venv con curl_cffi, pytest e pytest-asyncio.
