---
name: project-compliance-tracker
description: Vektora Compliance Tracker — console locale dell'auditor (Flask 127.0.0.1:8091) per audit ISO 27001, GDPR e Disaster Recovery multi-cliente, con guida per controllo, procedura, archivio comandi, Agente DR integrato, evidenze e report PDF
metadata:
  node_type: memory
  type: project
  originSessionId: dfdc2830-5421-4ca0-abab-c53d3c764abf
  modified: 2026-10-21T00:00:00.000Z
---

`Cybersecurity/Script/Compliance Tracker/` (repo git `ntr-scanner/Compliance-Tracker`, l'utente committa da sé). Avvio: `avvia.bat` / `avvia.sh` (apre il browser; `--no-browser`). Stack: Flask, pyyaml, reportlab, bcrypt (`requirements.txt`, `.venv`).

**2026-10-21: diventato «Vektora Audit», dashboard stile Ayanokoji** (richiesta dell'utente: integrare la cartella `Audit Automatico/Vektora Audit` e avere guida + archivio per gli audit Vektora):
- Terzo framework **Disaster Recovery** (`checklists/dr_checklist.yaml`, 25 controlli, id `dr-NN`). `FRAMEWORKS` in `core/client_manager.py` è l'unica lista dei framework: server, report e template ci girano sopra.
- `guida/` (YAML, nessun codice): `gdpr.yaml`/`iso27001.yaml`/`dr.yaml` con guida per id (riferimento, obiettivo, passi, dove, domande, comandi os linux|windows|rete, evidenze, agente), `procedura.yaml` (8 fasi), `raccolta.yaml` (ricette log con manifest SHA-256). Caricate da `core/guida.py` (cache per mtime); `guida.verifica()` controlla che ogni controllo abbia la guida (test).
- `agente-dr/`: copia di Vektora Audit; `dr-audit-vektora.py` **identico byte per byte** (sha256 702aae94…). Unica modifica: in `scripts/make_variants.py` i percorsi di destinazione (Vektora → `agente-dr/`, GV → `Cybersecurity/Audit Automatico/GV Audit`). La cartella originale `Audit Automatico/Vektora Audit` NON è stata cancellata (in attesa di conferma dell'utente).
- Pagine: Clienti (registro con 3 barre), Cliente (mappa dei controlli a celle per forma: pieno/metà/vuoto/tratteggiato, schede, guida apribile, Evidenze con upload), Procedura, Archivio comandi (filtri OS/ambito), Agente DR (compone comandi scp/ssh; quelli per il server si incollano nella sessione SSH per evitare il quoting di PowerShell 5.1; import del report su dr-25).
- Sicurezza aggiunta: nome cliente validato in `client_exists` (prima `..` passava), SameSite=Strict, API solo JSON, CSP senza inline (JS in `webapp/static/*.js`), upload con whitelist e download sempre allegato, escape del testo nel PDF, `.gitignore` che esclude `clients/*` tranne il demo.
- Test: `.venv\Scripts\python -m unittest discover -s tests` (16). Verifica visiva con playwright-core + Edge (`C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe`): Playwright MCP non trova Chrome su questo PC.

**2026-10-25: integrato il vecchio progetto `Script per server/Disaster Recovery`** (poi cartella eliminata, non aveva commit né dati): pagina «Piano DR» per cliente (`/clients/<c>/piano-dr`, `piano_dr.html` + `static/piano.js`), API JSON di salvataggio e check. Codice in `core/readiness/` (backup_checker, service_checker con urllib al posto di requests, risk_scoring copiati quasi identici; `check.py` con piano per cliente in `clients/<c>/piano_dr.yaml`, `piano_dr_ultimo.json`, `piano_dr_storico.json`, validazione `normalizza_piano`, CLI `python -m core.readiness.check "Cliente" [--dry-run]`), PDF `reporter/readiness_report.py` → `Report/readiness_<data>.pdf`. Docker/restic/git leggono la macchina del tracker; restic dal web mai getpass (`interactive=False`). Test Linux: venv in scratchpad (la `.venv` del repo è Windows), 26 test.

**Stato controllo:** `non_iniziato | in_corso | completato | non_applicabile`. **%:** pesi completati / pesi applicabili.

**Why:** servizio di readiness per Vektora, NON certificazione.

**How to apply:** nuovi controlli = YAML in `checklists/` + guida con stesso id in `guida/`. I clienti vecchi ricevono controlli/framework nuovi all'apertura (`refresh_client_from_template`). Il demo ha descrizioni salvate più vecchie dei YAML (es. gdpr-02).

[[project-cybersecurity-dr-audit]] [[project-ayanokoji-system]] [[project-ransomware-identifier]]
