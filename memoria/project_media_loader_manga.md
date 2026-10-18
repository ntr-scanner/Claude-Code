---
name: project-media-loader-manga
description: "Flusso manga di Media Loader (Cybersecurity/Script/Media Loader): cartelle JPG per capitolo, siti diretti Mgeko/LikeManga (core/mgeko.py motore), MangaRead/Webtoons via gallery-dl, insidie"
metadata:
  type: project
---

Dal 2026-10-17 (richiesta utente) Media Loader scarica TUTTO in `<cartella progetto>/Download/` (`core/library.DOWNLOAD_ROOT`, vale dopo ogni clone; `.gitignore` tiene solo `Download/.gitkeep`). Manga: gallery-dl in `Download/manga/.scaricamento` con `--download-archive`, poi `core/manga_capitoli.py` crea `Download/manga/<Titolo>/Capitolo NNN/0001.jpg...` (JPEG copiati, altri formati → JPEG q92; temp nascosta `.Capitolo NNN.part`, la dashboard ignora le cartelle con "."). Dal 2026-10-18 niente più PDF (richiesta utente: i PDF non riducevano il peso e duplicavano la biblioteca, 22 GB cancellati dopo verifica 1563/1563). Per evitare doppioni: in import spuntare "Elimina l'originale". Dopo aver svuotato Download, rilanciare mgeko/likemanga su una serie la riscarica tutta: usare `--da`.

Insidie:
- gallery-dl (motore manga di Media Loader) salva Webtoons piatto come `EP-PAGINA.jpg` in `manga/webtoons/<serie>/`: il numero EP è `episode_no` di Webtoons, non il numero "Ep." del titolo.
- CDN Webtoons ~1 immagine ogni 2 s per connessione: per serie intere lanciare più gallery-dl con `--chapter-range` disgiunti (l'ordine indice è dal più recente).
- MangaDex è bloccato in Italia (ordine AGCOM, DNS restituisce pagina "AVVISO"): non aggirarlo.
- Test browser: MCP Playwright cerca Chrome assente → Playwright da `~/.npm/_npx/*/node_modules/playwright-core` con `/snap/bin/brave`, screenshot in `~/` (Brave snap ha /tmp privata).

Dal 2026-10-17 anche **Mgeko** (`core/mgeko.py`, `python -m core.mgeko URL [--titolo cartella] [--da N --a M] [--elenco]`): gallery-dl non lo supporta; un PDF per capitolo, salta i capitoli con PDF già presente; in menu chiede il nome cartella (serve per continuare serie scaricate altrove). Ricerca `search_mgeko` in `sites/search.py`. Scaricati Solo Leveling e Sashimi Knife 90-99.

Dal 2026-10-18 anche **LikeManga** (`core/likemanga.py`, elenco capitoli da `/?act=ajax&code=load_list_chapter`, usa il motore di `core/mgeko.py`: `scarica(..., sito=modulo)`, `cli(sito, esempio)`; un modulo-sito espone NOME, BASE, FALLBACK_IMG, e_sito, client, info_serie, pagine) e **MangaRead** (gallery-dl nativo). Ricerca: `search_likemanga`, `search_mangaread`. gallery-dl dal menu ora scarica in `.scaricamento/gallery-dl/` (prima `.scaricamento/`: la conversione finale avrebbe preso anche i capitoli a metà dei siti diretti). Scaricati: Limit Breaker, Eternally Regressing Knight (mgeko); Attack on Titan (mangaread), Gantz, Tokyo Ghoul, Subaru the Invincible, Superhuman Era (likemanga).

Insidie aggiuntive:
- Webtoons `episode_no` ≠ numero "Ep.": prologo + Ep. 49.1/49.2 spostano tutto (episode_no 92 = Ep. 89). Fix: main.py passa `-o directory=["{category}","{comic}","{episode_name}"]` per webtoons, manga_pdf legge "Ep. N" dalla cartella (Prologue → 0). Sashimi già rinumerata (49.1/49.2 → 49.5/49.6 come mgeko).
- Su Linux la `.venv` del progetto è Windows: usare `.venv-linux/`. Background con `python -u` sennò il log resta vuoto.
- MangaRead (AoT): metadati sporchi, alcuni capitoli in cartelle `Attack On Titan - Chapter N/cNNN` e side story etichettato 16 (è il 19); sul sito mancano 11-13 e 131. CDN likemanga può rispondere 200 con 0 byte (fix in `_scarica_img`); Superhuman Era cap. 23 pag. 26 vuota sul server, PDF fatto con 42 pagine.
- `pkill -f "core.mgeko"` uccide anche la shell di Claude: usare il pattern `"[c]ore.mgeko"`.
- 2026-10-18 spegnimento improvviso del PC: gli ultimi capitoli scritti erano tutti file da 0 byte (scrittura non ancora su disco). Fix: `manga_capitoli.salva_capitolo` fa fsync prima del rename, `_scarica_img` riscarica pagine vuote. Download in background: lanciare con `setsid nohup` così sopravvivono alla chiusura di Claude Code.

**Why:** download manga richiesti dall'utente. **How to apply:** modifiche al flusso manga di Media Loader partono da qui; il lettore è [[project-scaffale-mangawa]].
