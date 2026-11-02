---
name: project-stealth-fetch
description: "stealth_fetch, pacchetto Python fetch anti-bot a 4 tier (curl_cffi→patchright→camoufox→flaresolverr), in Cybersecurity/Script/stealth/"
metadata:
  node_type: memory
  type: project
  originSessionId: 3b2c29ee-c990-4477-9ef2-4086fd9444d2
  modified: 2026-11-02T08:33:04.918Z
---

Pacchetto `stealth_fetch/` in `Cybersecurity/Script/stealth/` (spostato lì dall'utente il 2026-11-02; nato in `Documents/Scaffale` e `Documents/stealth`). CLI `python -m stealth_fetch` + libreria (`await fetch`, `fetch_sync`), README per GitHub, 86 test pytest offline.

Insidia: su Windows `curl_cffi.AsyncSession` si blocca in circa 1 richiesta su 5 (succede con qualsiasi event loop), mentre la versione sincrona no. Per questo http_tier e solver_tier usano `Session` sincrona dentro `asyncio.to_thread`.

**Why:** i tier patchright e camoufox non sono mai stati eseguiti dal vivo (non installati al momento della creazione); nessun repo git nella cartella.
**How to apply:** prima di modificare i tier browser, installarli (`patchright install chrome`, `camoufox fetch`) e provarli davvero. Per i test usare un venv con curl_cffi, pytest e pytest-asyncio.
