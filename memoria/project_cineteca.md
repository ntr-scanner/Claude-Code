---
name: project-cineteca
description: Cineteca, libreria film e serie TV in Intrattenimento/cineteca (server stdlib 8796, cartella dal browser, TMDB)
metadata:
  type: project
---

Creata il 2026-10-31 in `Cybersecurity/Script/Intrattenimento/cineteca/`: `codice/` (git init, nessun commit: li fa l'utente) e `dati/` accanto (`cineteca.json`, `backup/`, `cache/` locandine, `tmdb.key`, `battito-<pc>.json`). Server Python solo stdlib, porta 8796, `--lan` con PIN come la Ruota ([[project-ruota]]) ma scritto da zero.

Scelte dell'utente: libreria leggera (non Jellyfin), TMDB con chiave personale, cartella col **selettore del browser** (da riscegliere a ogni apertura, lettore nella pagina: mkv x265/AC3 spesso non vanno, la pagina lo dice), solo PC ma con possibilità telefono.

- Stato per voce (`POST /api/stato`, `/api/match`), niente revisioni: chiave = percorso senza la cartella radice (`fileKey`).
- Riconoscimento nomi in `app/logica.js` (`parseName`, `buildLibrary`), test `node --test`; `python3 -B -m unittest discover -s tests` lancia tutto.
- Prova nel browser: server con `tmdb_search` finto e locandina in `dati/cache/w342/`, cartella di prova in `$HOME` (Brave snap non vede /tmp).
- L'utente non ha chiavi API (Wallhaven, TMDB): va guidato a crearle, non si procurano per lui.
- Dalla 1.1 (2026-10-31): pagina 🎡 Ruota (Film/Serie/Anime/Tutto; fonti catalogo TMDB `/api/tmdb/scopri` con pagina a caso ≤500, PC, lista «Da vedere» `/api/lista`; genere fisso o «a sorte»; scheda con piattaforme Italia via `append_to_response=watch/providers`). Anime = genere 16 + `original_language` ja (`isAnime`): i match salvano `generi` e `lingua`. Generi TMDB film/serie hanno id diversi (`GENRES` in logica.js). Filtri ruota in localStorage `cineteca:ruota`. Test browser: `crun.py` sostituisce `server.tmdb_get` con un finto completo.
- Dalla 1.2: ↻ Riavvia (os.execv, stesso terminale) e ⏻ Spegni in Impostazioni, solo trusted_ips; `/api/ping` dà `versione_disco` (letta da server.py) e la pagina mostra «riavvia per le novità». Nato dall'«API sconosciuta» vista dall'utente con server 1.0 acceso e pagina 1.1. Regola generale messa in `Claude/SERVER-LOCALI.md`.
- Dalla 1.3: `--apri`/`--icona` (cineteca.desktop installata), `sw.js` pagina «Cineteca spenta», `v.onloadedmetadata` (non addEventListener once), ruota ridisegnata solo al cambio filtri (`wheelShown`), backfill generi/lingua via `/api/tmdb/scheda`, cache pagine discover 1 h, archivio mensile.
- Dalla 1.4 (2026-10-31): 📅 Uscite (`/api/tmdb/uscite`, cache 6 h, `releaseTitles`/`calendar`/`onMyPlatforms` in logica.js), «le tue piattaforme» per browser (localStorage `cineteca:piattaforme`, avvisi `cineteca:avvisati`), 📊 Anno (`yearSummary` dallo stato, senza cartella). Riepilogo NON fatto nella Ruota: ha già Metriche. Idee non scelte (per ora): Musicoteca+karaoke, gioco LAN, Galleria, Biblioteca.
- Dalla 1.6 (2026-11-03, Windows `Documents/Web Developer Claude/Cybersecurity/Script/Intrattenimento/Suite-Intrattenimento/cineteca/`): pagina 🌐 Online accanto a Ruota (richiesta utente: «come Media Loader, logica di Scaffale Online»). `sc_online()` in server.py = `search_sc` di Media Loader con query vuota riscritta in urllib: dominio dal tracker AstraeLabs, home `/it` con X-Inertia + versione, slider trending+latest; `POST /api/online` (cache 1 h in `server.online`), copertine via `GET /online-img/<uuid>.webp` (CSP vieta immagini esterne). Clic = `/api/tmdb/cerca` (serie senza anno: SC dà l'ultima messa in onda) → `openTmdb` con 📌. Nessun download. Media Loader non toccato (copia in `cineteca/temp` poi eliminata, come chiesto). Su questo PC manca `dati/tmdb.key`: clic non provato fino al 📌. Test Windows: `test_host_estraneo_e_token` e `test_guida_e_versione` falliscono a intermittenza (WinError 10053, cp1252), non legati a Online. launch.json «cineteca-prova» porta 8893.
