---
name: project-vivlio
description: Vivlío (cartella «Free Claude Code/Vivlos/codice», dati in ../dati) — lettore/downloader manga derivato da Scaffale; dalla 3.1 download dal telefono sul PC host e copertine PNG
metadata:
  type: project
---

Vivlío = lettore e downloader manga/manhwa (modalità normale e Speciale/hentai), derivato da [[project-scaffale-mangawa]]. Il nome della cartella è **Vivlos**, non Vivlio: `~/Vektora/Free Claude Code/Vivlos/codice/` (repo git) + `../dati/`. Porta 8790, server stdlib `server.py` + `static/app.js`, scrapers in `scrapers/` (non più `scarica.py`).

- 3.1.0 (2026-11-07): download avviabili dal telefono ma eseguiti sul server (regola in `SERVER-LOCALI.md` §9), coda `CODA` = 2, polling `/api/scaricamenti` 10 s/2 s, Riprova sugli errori, controllo spazio 500 MB, richiesta salvata appena accettata. Copertine sempre `cover.png` (lato max 1200, `make_cover`), le .webp vecchie convertite all'avvio. HEIC escluso per scelta dell'utente (niente pillow-heif).
- 3.1.2: Indietro con `history.state.from` su serie e saga (niente più `navDepth`), cambio capitolo con replaceState. 3.2.0: «Cartelle in più» (HDD) in Server → `impostazioni.json` `biblioteche_extra`, `radici()`/`serie_in()`/`series_dir()` le guardano; disco staccato = serie nascoste senza errori.
- 3.3.0 (2026-11-08): cache `meta_leggera()` per `/api/library` (tutte le serie stanno sull'HDD NTFS, 34 MB di serie.json riletti a ogni pagina = lentezza); PC bloccato chiude solo le sessioni locali (`Accesso.locali`), il telefono resta aperto (scelta dell'utente, diversa da SERVER-LOCALI §5 «chiude tutte»); PIN 6-12 cifre per la rete in `.pin.json` (scrypt), vale anche la password.
- L'utente NON vuole che si tocchino adesso i test/filtri per adulti in `test_dashboard.py` (righe ~610-705): li sistema lui a fine progetto. Quindi la suite resta ferma a 70 controlli.
- Insidie: schermo del PC bloccato (`loginctl … LockedHint=yes`) = il server chiude le sessioni ogni 5 s → nei test mettere `{"blocco_schermo": false}` in `<dati>/.blocco.json`.
- Altre insidie: `server.py` e `README.md` hanno fine riga **CRLF** (riscriverli da Python con `read_text`/`write_text` li converte in LF: usare bytes). `test_dashboard.py` fallisce già al test «sito che blocca» perché monkeypatcha `scarica.scarica_capitolo` mentre il server usa quello di `scrapers`. Server di prova lanciati con `&` in Bash ignorano SIGINT: fermarli con `kill PID`, altrimenti restano sulla porta e il successivo parte sulla porta dopo.
- Verifica usata: lanciatore che chiama `server.main()` con sito finto (sostituisce `server.capitoli/scarica_capitolo/sito_di/dettagli`) e `--rete`; il «telefono» si collega all'IP LAN (client_address ≠ 127.0.0.1). Playwright da `codice/node_modules` con il Chromium di `~/.cache/ms-playwright`.

**Why:** progetto nuovo, non in memoria, con un nome di cartella diverso dal nome dell'app.
**How to apply:** cercarlo come «Vivlos»; prima di modificare guardare `git status` (spesso modifiche dell'utente non committate in server.py/scrapers).
