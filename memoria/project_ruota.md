---
name: project-ruota
description: "Ruota (Porn Roulette v.3) in Intrattenimento/porn-roulette-v.3 — server Python + PWA moduli ES, Ritmo e Metriche dalla 3.8"
metadata:
  node_type: memory
  type: project
  originSessionId: deaedeb1-457c-4010-b94e-7e5d351ab91b
  modified: 2026-10-24T22:45:16.279Z
---

App personale in `Intrattenimento/porn-roulette-v.3/`: `server.py` (stdlib, dati in `Backup/`, catalogo StashDB) + `app/` moduli ES con CSP chiusa (niente CDN, niente stili inline in HTML; `el.style` da JS va bene). README molto dettagliato: aggiornarlo a ogni modifica (sezioni d'uso, tabella moduli, numero test, storia versioni).

- Dalla 3.8 (2026-10-17): funzione Ritmo (giorni previsti + limiti settimana/mese, «volta» = giorno con almeno un giro) e finestra 📊 Metriche con export CSV/JSON. L'utente ha scritto «vendere le metriche»: interpretato come «vedere»; non è stato confermato.
- Le finestre stanno in `generi.js`, `pornstar.js`, `calendario.js`, `metriche.js`; ricevono lo stato da `ctx` (getter/setter) in `app.js`, perché le variabili di stato vengono riassegnate.
- Logica pura in `logica.js`, testata con `node --test tests/test_logica.mjs`; tutto con `python3 -B -m unittest discover -s tests` (`-B`: la cartella è sincronizzata con Syncthing, niente `__pycache__`).
- Prova nel browser: server con `--port 8799 --dati <scratchpad> --no-browser -n --start`, Playwright da `~/.npm/_npx/*/node_modules/playwright-core` con `executablePath: "/snap/bin/brave"` (l'MCP Playwright cerca Chrome, assente). Brave snap ha una /tmp privata: i download non si recuperano, verificare i dati generati nella pagina.
- Dalla 3.9: sezione 🔗 Link (SECTIONS.link con `links: true`): link in `ruota-dati.json` → `links`, import con POST /api/link dai file in `Link/` (il server li cancella dopo il salvataggio). Nomi da `link_name()` in server.py; oltre 40 link la ruota mostra #numeri. I 3 file txt originali sono stati importati e cancellati il 2026-10-17 (copia `Backup/ruota-auto-2026-10-17-152516-prima-di-import.json` = stato prima).
- Dalla 3.10: ogni link può avere `genres` (indicati nel risultato) e `off: true` (tolto dalla ruota); la pagina li modifica cercando il link per URL (`linkByUrl`), perché applyData ricrea gli oggetti. Metriche: classifiche `link`/`generiLink` separate dai generi; CSV con colonna `generi_link`.
- Insidia nei test: `pkill -f`/`pgrep -f` con un pattern che compare anche nel comando Bash colpisce la shell stessa (exit 144) e interrompe il resto del comando: fermare i server per PID, in un comando separato.
- Dalla 3.11: niente `confirm()` del browser, si usa `ask(msg, etichetta, {danger})` di `dom.js` (Promise, finestra #askDlg); rinominare un genere aggiorna anche registro e generi dei link (`renameGenreInHistory`). L'utente vuole le conferme dentro la pagina, non popup del browser.
- Dalla 3.12: sfondi da `Background/` (GET /api/sfondi, /sfondi/<nome>), Opzioni → Aspetto; velo minimo calcolato con `minScrim(brightSpot(...))` su `--muted` a contrasto 4.5 (requisito utente: leggibile con qualsiasi colore). Il server dei test (`scratchpad/run.py`) imposta LINK_DIR e BG_DIR su cartelle di prova.
- Dalla 3.14: home a una colonna (barra titolo + menu a icone, scelta dell'utente fra due layout); sfondo con fit/pos/random (`BG_FITS`, `pickRandom`, `badBg` salta i file illeggibili). Il server di prova (`scratchpad/run.py`) deve impostare anche `KEY_FILE` a un file inesistente, altrimenti i giri di test interrogano StashDB con la chiave vera.
- Dalla 3.17: `.stage` contiene ruota, seconda ruota, risultato e video (la seconda ruota sostituisce la prima, poi il risultato); centratura verticale con margin-top calc su ≥700px. L'utente vuole che ogni impostazione dello sfondo resti come la lascia: mai azzerare valori scelti. Non usare `py_compile` per controllare server.py (crea `__pycache__` anche con -B).
- Dalla 3.18: sezione 💞 Coppia (`SECTIONS.coppia.real`), 40 voci in generi.json con `desc`; esclusi per richiesta utente terze persone e lui sottomesso (più soffocamento, scelta di sicurezza); fuori dal Ritmo. `migrateGenres` aggiunge le sezioni nuove anche alle liste personalizzate.
- Esc = uscita rapida sempre, anche nelle finestre (scelta voluta).
- Dalla 3.19 (2026-10-25): `porn-roulette-v.3/codice/` = repo git (remote `ntr-scanner/Routa-Intrattenimento`, privato, sfondi `Background/` inclusi, ~6 MB) e `dati/` accanto (`Backup/`, `Link/`, `stashdb.key`, più un .mkv da 3,4 GB tolto da Background). `DATI_DIR = BASE_DIR.parent / "dati"` in server.py. Vecchio `.git` (conteneva chiave e mkv) in `porn-roulette-v.3/_git-vecchio`. Dopo un clone: `--stashdb` poi `--scarica-cataloghi`.
- Dalla 3.20 (2026-10-31): sezione 📂 Cartella (`SECTIONS.cartella.files`): l'utente ha scelto il selettore del browser (`<input webkitdirectory>`, cartella da riscegliere a ogni sessione) invece di un percorso salvato sul server, quindi ffmpeg non serve: titolo e copertina li legge `app/metadati.js` nella pagina (MP4 ilst ©nam/covr, MKV Title + allegati via SeekHead), altrimenti fotogramma con `<video>`+canvas; lettore in pagina (CSP `media-src blob:`). Conta nel Ritmo come i Link, esclusa dalla classifica generi. Test Playwright: i file per `setInputFiles` vanno in `$HOME` (Brave snap non vede /tmp); `body[data-section]` fa collidere i selettori `[data-section=…]`, usare `.section-btn[...]`.
