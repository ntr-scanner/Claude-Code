---
name: project-scaffale-dashboard
description: "Scaffale, dashboard lettura manga/manhwa/webtoon di Media Loader in `Cybersecurity/Script/Media Loader/dashboard/`, porta 8790, import/conversione da In arrivo"
metadata:
  node_type: memory
  type: project
  originSessionId: 5022339b-d81d-4780-870f-5436d2ccd427
  modified: 2026-10-17T15:07:29.142Z
---

Creata il 2026-10-17. `server.py` (stdlib ThreadingHTTPServer + Pillow, pypdfium2 per PDF) + `static/` vanilla JS, avvio `avvia.sh`/`avvia.bat` (creano `.venv` locale). Libreria in `dashboard/dati/biblioteca/<slug>/` (serie.json con capitoli e dimensioni pagine, cover.webp, `capitoli/cNNNN/`). In arrivo = `~/Videos/MediaLoader/manga` + `dati/caricati/`. Test: `test_dashboard.py` (30 controlli).

Insidie:
- gallery-dl (motore manga di Media Loader) salva Webtoons piatto come `EP-PAGINA.jpg` in `manga/webtoons/<serie>/`: il numero EP è `episode_no` di Webtoons, non il numero "Ep." del titolo.
- CDN Webtoons ~1 immagine ogni 2 s per connessione: per serie intere lanciare più gallery-dl con `--chapter-range` disgiunti (l'ordine indice è dal più recente).
- MangaDex è bloccato in Italia (ordine AGCOM, DNS restituisce pagina "AVVISO"): non aggirarlo.
- Test browser: MCP Playwright cerca Chrome assente → Playwright da `~/.npm/_npx/*/node_modules/playwright-core` con `/snap/bin/brave`, screenshot in `~/` (Brave snap ha /tmp privata).

**Why:** progetto richiesto dall'utente per leggere i download di Media Loader. **How to apply:** modifiche alla dashboard partono da qui; vedi anche [[project-media-loader]].
