---
name: project-ruota
description: Ruota (Porn Roulette v.3) in Intrattenimento/porn-roulette-v.3 — server Python + PWA moduli ES, Ritmo e Metriche dalla 3.8
metadata:
  type: project
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
- Esc = uscita rapida sempre, anche nelle finestre (scelta voluta).
