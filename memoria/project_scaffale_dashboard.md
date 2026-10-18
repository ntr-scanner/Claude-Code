---
name: project-scaffale-dashboard
description: "Scaffale, dashboard lettura manga/manhwa/webtoon di Media Loader in `Cybersecurity/Script/Media Loader/dashboard/`, porta 8790, import/conversione da In arrivo"
metadata:
  node_type: memory
  type: project
  originSessionId: 5022339b-d81d-4780-870f-5436d2ccd427
  modified: 2026-10-17T15:07:29.142Z
---

Creata il 2026-10-17. `server.py` (stdlib ThreadingHTTPServer + Pillow, pypdfium2 per PDF) + `static/` vanilla JS, avvio `avvia.sh`/`avvia.bat` (creano `.venv` locale). Libreria in `dashboard/dati/biblioteca/<slug>/` (serie.json con capitoli e dimensioni pagine, cover.webp, `capitoli/cNNNN/`). In arrivo = `../Download/manga` (Media Loader) + `dati/caricati/`. Lanciatore in stile Ayanokoji (`--stato`, `--spegni`, `--rete`, porte 8790+20, browser staccato con log in `dati/browser.log`, `/api/ping`). Test: `test_dashboard.py` (35 controlli).

Dal 2026-10-17 (richiesta utente) Media Loader scarica TUTTO in `<cartella progetto>/Download/` (`core/library.DOWNLOAD_ROOT`, vale dopo ogni clone; `.gitignore` tiene solo `Download/.gitkeep`). Manga: gallery-dl in `Download/manga/.scaricamento` con `--download-archive`, poi `core/manga_pdf.py` (img2pdf, senza ricompressione) crea `Download/manga/<Titolo>/Capitolo NNN.pdf` e cancella le immagini; la dashboard estrae le pagine dai PDF con pypdfium2 senza perdita. Strisce spaziatrici < 8 px scartate (img2pdf/pikepdf rifiutano pagine < 3 pt).

Insidie:
- gallery-dl (motore manga di Media Loader) salva Webtoons piatto come `EP-PAGINA.jpg` in `manga/webtoons/<serie>/`: il numero EP è `episode_no` di Webtoons, non il numero "Ep." del titolo.
- CDN Webtoons ~1 immagine ogni 2 s per connessione: per serie intere lanciare più gallery-dl con `--chapter-range` disgiunti (l'ordine indice è dal più recente).
- MangaDex è bloccato in Italia (ordine AGCOM, DNS restituisce pagina "AVVISO"): non aggirarlo.
- Test browser: MCP Playwright cerca Chrome assente → Playwright da `~/.npm/_npx/*/node_modules/playwright-core` con `/snap/bin/brave`, screenshot in `~/` (Brave snap ha /tmp privata).

Dal 2026-10-17 anche **Mgeko** (`core/mgeko.py`, `python -m core.mgeko URL [--titolo cartella] [--da N --a M] [--elenco]`): gallery-dl non lo supporta; un PDF per capitolo, salta i capitoli con PDF già presente; in menu chiede il nome cartella (serve per continuare serie scaricate altrove). Ricerca `search_mgeko` in `sites/search.py`. Scaricati Solo Leveling e Sashimi Knife 90-99.

Insidie aggiuntive:
- Webtoons `episode_no` ≠ numero "Ep.": prologo + Ep. 49.1/49.2 spostano tutto (episode_no 92 = Ep. 89). Fix: main.py passa `-o directory=["{category}","{comic}","{episode_name}"]` per webtoons, manga_pdf legge "Ep. N" dalla cartella (Prologue → 0). Sashimi già rinumerata (49.1/49.2 → 49.5/49.6 come mgeko).
- Su Linux la `.venv` del progetto è Windows: usare `.venv-linux/`. Background con `python -u` sennò il log resta vuoto.
- `pkill -f "core.mgeko"` uccide anche la shell di Claude: usare il pattern `"[c]ore.mgeko"`.
- Import in dashboard da script: POST `/api/import` `{source: percorso assoluto, slug | new_series:{title,type,status}}`, poi `/api/jobs/<id>`; porta da `./avvia.sh --stato`.

**Why:** progetto richiesto dall'utente per leggere i download di Media Loader. **How to apply:** modifiche alla dashboard partono da qui; vedi anche [[project-media-loader]].
