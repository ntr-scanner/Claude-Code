---
name: project-scaffale-mangawa
description: "Scaffale Mangawa: lettore locale manga/manhwa in Progetti/Scaffale Mangawa/ (codice/ = repo, dati/ = biblioteca 22 GB fuori dal repo), porta 8790, separato da Media Loader dal 2026-10-18"
metadata:
  type: project
---

Nato il 2026-10-17 come `dashboard/` dentro Media Loader; il 2026-10-18 l'utente l'ha fatto diventare progetto separato "Scaffale Mangawa" in `Progetti/Scaffale Mangawa/`: `codice/` (server.py stdlib + Pillow + pypdfium2, `static/` vanilla JS, `avvia.sh`/`avvia.bat`, `test_dashboard.py` 39 controlli, README per GitHub) e `dati/` accanto, mai dentro il codice (`--dati` default `../dati`). Niente git iniziato: l'utente fa git e push più avanti, il repo deve contenere solo `codice/`.

Cartelle In arrivo: niente più percorso fisso a Media Loader; stanno in `dati/impostazioni.json` (`cartelle_in_arrivo`), gestite con `./avvia.sh --aggiungi-inbox/--togli-inbox` (valgono al riavvio; una cartella sparita viene saltata, non ricreata). Dal 2026-10-18 (richiesta utente: «scolleghiamo per sempre») nessuna cartella In arrivo verso Media Loader: si scarica solo dalla sezione Scarica. APP_NOME "Scaffale Mangawa" (usato da `/api/ping` per riconoscere il server attivo), env porta `SCAFFALE_PORTA`.

Saghe (2026-10-18, richiesta utente): campi `saga` + `arco` in serie.json (PATCH), niente cartelle annidate su disco; il frontend raggruppa (`groupSagas`) in una card a pila "N archi", vista `#/saga/<nome>` con badge "Arco N". Re:Zero = archi 1-5 (arco 1 da MangaDex; archi 4 e 5 fermi a 59 e 9.1 su tutte le fonti). Telefono: domanda all'avvio, `--rete`, o `"rete_locale": true` in impostazioni.json; a server già attivo `./avvia.sh` dice se è in rete (`/api/ping` → `rete`). Sicurezza: `HOSTS_OK` blocca Host estranei (DNS rebinding), con `--rete` aggiunge gli IP locali.

Sezione «Scarica» (2026-10-18, v1.2.0, richiesta utente: copiare SOLO il download manga da Media Loader): `codice/scarica.py` solo stdlib, classi Mgeko e LikeManga (`cerca`, `info`, `pagine`), numerazione copiata da Media Loader; endpoint `/api/cerca`, `/api/scarica` (solo da 127.0.0.1), `/api/scaricamenti`; staging `dati/caricati/.scarica-<sha1 url>` (nascosta, riprende dopo interruzioni) → `run_import` con delete_source. Aggiorna = solo capitoli mancanti. Job in memoria: persi al riavvio del server (staging resta). MangaDex/MangaRead/Webtoons non copiati (servirebbe gallery-dl). Da allora le due copie del downloader divergono: correzioni ai siti vanno fatte in entrambi.

Insidie download/import: likemanga usa caratteri come ’ negli URL → `scarica._get` li codifica con `quote` (urllib altrimenti va in errore ascii); i siti possono servire pagine rotte (0 byte o 2 byte "28" con Content-Type image) anche in modo permanente: dal 2026-10-18 `run_import` salta le pagine illeggibili e lo dice nello status invece di fallire a metà (unOrdinary cap. 215 pag. 143). Se una fonte ha un capitolo rotto, provare l'altra (ORV 278 rotto su mgeko, ok su likemanga). Disco: 28 GB liberi dopo 23 serie / 4012 capitoli (~35 GB di biblioteca).

Insidia: un server vecchio ancora acceso serviva i file nuovi di `static/` → «endpoint non trovato» sulla ricerca (utente con 1.1.0 aperto). Dal 2026-10-18 `STATIC` carica l'interfaccia in memoria all'avvio: pagina e server sempre della stessa versione; dopo un aggiornamento va riavviato. Titoli likemanga con entità HTML (&#39;) → `html.unescape` in scarica.py. Gusti utente (Ayanokoji `dati/manga-manhwa.json`, 301 opere): seinen cupi/psicologici (Berserk, Punpun, Usogui, Vagabond tier S/Z), manhwa regressione/accademia/murim/combattimento (top: High Class, Solo Leveling, Sashimi, Jakdu, The Boxer).

v1.3.0 (2026-10-18): ogni serie ha `fonte` (URL mgeko/likemanga, salvato da run_download o in Modifica), `avvisi` (scelti dall'utente serie per serie, MAI accenderli al posto suo), `nuovi` (capitoli usciti dopo l'ultimo posseduto), `controllato`. `controlla_novita()` all'avvio + ogni 6 h (`ciclo_novita`) + POST `/api/novita`. Download di un intervallo: `da`/`a` in `/api/scarica` (uguali = un capitolo). Pagina Scarica: campo «Usa il link». Fonte impostata su 21 serie (non AoT/MangaRead né Re:Zero arco 1/MangaDex). Avvisi funzionano solo a server acceso (niente notifiche push).

Import da script: POST `/api/import` `{source: percorso assoluto, slug | new_series:{title,type,status}}`, poi `/api/jobs/<id>`; porta da `./avvia.sh --stato` (l'utente può riavviarlo su un'altra porta). Un'immagine da 0 byte fa fallire l'import a metà (serie creata con parte dei capitoli): reimportare nella stessa slug.

Test browser: MCP Playwright cerca Chrome assente → Playwright da `~/.npm/_npx/*/node_modules/playwright-core` con `/snap/bin/brave`, screenshot in `~/` (Brave snap ha /tmp privata).

**Why:** l'utente vuole il lettore indipendente dal downloader e il codice pubblicabile senza la biblioteca. **How to apply:** modifiche al lettore partono da qui; i download sono in [[project-media-loader-manga]].
