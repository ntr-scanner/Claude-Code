---
name: project-scaffale-mangawa
description: "Scaffale Mangawa: lettore locale manga/manhwa in Progetti/Scaffale Mangawa/ (codice/ = repo, dati/ = biblioteca 22 GB fuori dal repo), porta 8790, separato da Media Loader dal 2026-10-18"
metadata:
  type: project
---

Nato il 2026-10-17 come `dashboard/` dentro Media Loader; il 2026-10-18 l'utente l'ha fatto diventare progetto separato "Scaffale Mangawa" in `Progetti/Scaffale Mangawa/`: `codice/` (server.py stdlib + Pillow + pypdfium2, `static/` vanilla JS, `avvia.sh`/`avvia.bat`, `test_dashboard.py` 39 controlli, README per GitHub) e `dati/` accanto, mai dentro il codice (`--dati` default `../dati`). Niente git iniziato: l'utente fa git e push più avanti, il repo deve contenere solo `codice/`.

Cartelle In arrivo: niente più percorso fisso a Media Loader; stanno in `dati/impostazioni.json` (`cartelle_in_arrivo`), gestite con `./avvia.sh --aggiungi-inbox/--togli-inbox` (valgono al riavvio; una cartella sparita viene saltata, non ricreata). Su questo PC c'è `Cybersecurity/Script/Media Loader/Download/manga`. APP_NOME "Scaffale Mangawa" (usato da `/api/ping` per riconoscere il server attivo), env porta `SCAFFALE_PORTA`.

Saghe (2026-10-18, richiesta utente): campi `saga` + `arco` in serie.json (PATCH), niente cartelle annidate su disco; il frontend raggruppa (`groupSagas`) in una card a pila "N archi", vista `#/saga/<nome>` con badge "Arco N". Re:Zero = archi 2-5 (arco 1 non trovato online). Sicurezza: `HOSTS_OK` blocca Host estranei (DNS rebinding), con `--rete` aggiunge gli IP locali.

Import da script: POST `/api/import` `{source: percorso assoluto, slug | new_series:{title,type,status}}`, poi `/api/jobs/<id>`; porta da `./avvia.sh --stato` (l'utente può riavviarlo su un'altra porta). Un'immagine da 0 byte fa fallire l'import a metà (serie creata con parte dei capitoli): reimportare nella stessa slug.

Test browser: MCP Playwright cerca Chrome assente → Playwright da `~/.npm/_npx/*/node_modules/playwright-core` con `/snap/bin/brave`, screenshot in `~/` (Brave snap ha /tmp privata).

**Why:** l'utente vuole il lettore indipendente dal downloader e il codice pubblicabile senza la biblioteca. **How to apply:** modifiche al lettore partono da qui; i download sono in [[project-media-loader-manga]].
