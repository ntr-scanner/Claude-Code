---
name: project-media-loader-v3
description: "Media Loader v3 in `Cybersecurity/Script/Media Loader v3/`: app web in finestra (app.py + interfaccia/), terminale muto, v2 intatta"
metadata:
  node_type: memory
  type: project
  originSessionId: 140c28f0-3678-4588-9f54-78db07fec960
  modified: 2026-10-18T10:53:31.800Z
---

Creata il 2026-10-18 su richiesta dell'utente: copia di `Media Loader` (v2, intatta) senza Download, dashboard Scaffale (progetto a sé, resta separato), .venv, .git. Avvio `./medialoader.sh` / `medialoader.bat` → `app.py`: server stdlib solo 127.0.0.1:8800 (+19 porte), finestra `brave --app` (fallback Chrome/Edge, poi webbrowser). L'utente voleva "finestra desktop" ma ha accettato web app; pywebview scartato (WebKitGTK dava errore GLib).

Come funziona: stdout/stderr sostituiti da un instradatore per thread (output di ogni download → suo lavoro, il resto scartato: terminale con sola riga di avvio e "Chiuso."); `input()` sostituito: le domande dei motori (file esistente a/b/c, 301, nome) compaiono nella coda con pulsanti. Annullo = eccezione `Annullato(BaseException)` alla prossima scrittura del thread. Avanzamento dedotto da `%` o `n/m` nelle righe. Due download paralleli. Senza battito dalla finestra per 30 s e senza download attivi il server si spegne. `main.py` v3: `scarica_manga(url, title, nome_cartella)` estratta dal menu, gallery-dl via Popen con righe passate a print.

Test: `test_app.py` (14), `test_manga_capitoli.py` (16). Test reali via Playwright + Brave snap (vedi [[project-scaffale-dashboard]] per il setup) il 2026-10-18: YouTube video/MP3, domanda file esistente, AnimeWorld, Mgeko (annullo + ripresa), Webtoons, XNXX nativo e yt-dlp, xHamster, HentaiGasm, HentaiMama, dominio sconosciuto, sistema/chiusura.

Corretti in v3 (bug anche della v2, non riportati): `detect_platform` su host intero (xnxx.com veniva preso per x.com, reddit per t.co), HentaiMama MP4 diretti marcati hls, titoli xHamster (`.video-thumb-info__name`), CHAP_DIR accetta "[Season 1] Ep. 0".

Non funzionanti al 2026-10-18 (motori, non app): Film e Serie (domini StreamingCommunity/AltaDefinizione/FilmSenzaLimiti/GuardaSerie/Eurostreaming parcheggiati; ricerca impiega ~2 min per 0 risultati), ricerca adulti a 0 su Eporner, SpankBang, JavGuru, MissAV, NoodleMagazine, 141Jav, HentaiWorld.eu/.tv. mp4decrypt non installato.

**Why:** l'utente voleva un'app interattiva senza testo che scorre, senza toccare la versione funzionante. **How to apply:** modifiche all'app partono da `app.py`/`interfaccia/`; i motori sono condivisi nel codice con la v2 ma copiati, quindi una correzione va portata a mano nell'altra versione se l'utente lo chiede.
