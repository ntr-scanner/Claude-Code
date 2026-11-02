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

**Why:** i tier patchright e camoufox non sono mai stati eseguiti dal vivo (non installati al momento della creazione); nessun repo git nella cartella.
**How to apply:** prima di modificare i tier browser, installarli (`patchright install chrome`, `camoufox fetch`) e provarli davvero. Per i test usare un venv con curl_cffi, pytest e pytest-asyncio.
