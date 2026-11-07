---
name: project-intrattenimento-base
description: Musicoteca, Galleria, Biblioteca, Serata (2026-10-31) condividono base.py, app/comune.js, app/base.css come copie IDENTICHE: cambiarle in tutte e alzare VERSION
metadata:
  type: project
---
Dal 2026-10-31 in `Cybersecurity/Script/Intrattenimento/` ci sono 4 app nuove con la stessa base (dal 2026-11-01 anche [[project-videoteca]], 8802: 5 copie): [[project-musicoteca]] (8798), [[project-galleria]] (8799), [[project-biblioteca]] (8800), [[project-serata]] (8801). Ruota e Cineteca NON usano la base (server propri).

- `codice/base.py`: App (dataclass), Archive (sezioni + validatori, `put`, `update` sotto lock, backup giornalieri/«prima-di»/mensili), Auth (password scrypt in `dati/accesso.json`, sessioni in tempdir, 5 errori = 60 s, 4 h di inattività), BaseHandler (`app_get`/`app_post`/`app_dati`, `/api/salva/<sezione>`, `/f/…` sotto password), `--apri`, `--icona`, `--password`, `--lan`/`--solo-pc`.
- `app/comune.js`: login in finestra sopra la pagina, `api()` (riprova dopo 401 accesso / 403 token), `save()`, `serverBlock()` (Riavvia, Spegni a due clic, Esci, Cambia password), barra «codice aggiornato».
- `app/base.css`: tema; ogni app cambia solo le variabili in `style.css`.
- Controllo: `sha256sum */codice/base.py */codice/app/comune.js */codice/app/base.css` devono coincidere.

**Why:** l'utente ha scelto «Serve una password» anche dal PC per tutte e 4; la base evita 4 implementazioni diverse della sicurezza.
**How to apply:** una modifica a base/comune/base.css va copiata nelle 4 cartelle e richiede di alzare VERSION nei 4 server.py.
Test Playwright: Brave non accetta cartelle con setFiles → iniettare File con `webkitRelativePath` via DataTransfer + defineProperty su `input.files`. Non usare `pkill -f` con pattern che compare nel proprio comando (uccide la shell): `kill $(ss -ltnp | grep ':PORTA ' …)`.

Dal 2026-11-01: `codice/menu_app.py` (copia identica anche in cineteca, porn-roulette-v.3, videoteca e Ayanokoji `server/`, 8 copie: controllare con sha256sum): voce nel menu app Linux (.desktop) e Windows (.lnk nel menu Start via PowerShell, `pythonw`, icona `app/favicon.ico` generata da favicon.svg con Brave headless perché ImageMagick MSVG perde i tratti). `POST /api/icona {attiva}` solo dal PC, stato in `/api/sessione` (`icona`, `icona_possibile`); bottone in serverBlock. `--togli-icona`. Login `::backdrop` opaco in base.css.
Dal 2026-11-01 (sera): password con le regole di Ayanokoji (SERVER-LOCALI §5): min 12, scrypt n=2^15 (`n` nel file, vecchie n=2^14 ok), sleep 1 s, sessioni solo in memoria (niente più file in tempdir), `dati/.blocco.json` + `POST /api/blocco`, `screen_watch`, controllo inattività ogni 20 s in comune.js (`session.dentro`: i telefoni di Serata senza password non vengono bloccati). Test con password ≥ 12 caratteri.

2026-11-01: le sei app (biblioteca, cineteca, galleria, musicoteca, serata, videoteca) spostate in `Cybersecurity/Script/Intrattenimento/Suite Intrattenimento/<app>/{codice,dati}`, un solo repo git alla radice della suite (prima ogni `codice/` aveva un `.git` vuoto, senza commit: tolti). `.gitignore` radice esclude `*/dati/`, chiavi, accesso.json, media; README radice con tabella app/porte. Peso tracciato ~4,3 MB (137 file, il più grosso pdf.worker.min.js 1 MB). Ruota (`porn-roulette-v.3`) resta fuori con il suo repo. Dopo lo spostamento rigenerate le voci `.desktop` con `python3 server.py --icona` (contengono percorsi assoluti): rifarlo a ogni spostamento. Remoto non ancora creato: lo fa l'utente.

Dal 2026-11-07: finestra della password in comune.js creata una volta e poi chiusa/riaperta (id `loginPassword`, name fissi), mai `remove()`: Bitwarden mette il suo menu dentro la `<dialog>` modale e aggancia il campo in ritardo; rifatta a ogni blocco il suggerimento spariva dopo il primo accesso.
