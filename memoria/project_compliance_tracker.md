---
name: project-compliance-tracker
description: Vektora Compliance Tracker — tool CLI GDPR/ISO 27001 multi-cliente con report PDF
metadata: 
  node_type: memory
  type: project
  originSessionId: dfdc2830-5421-4ca0-abab-c53d3c764abf
  modified: 2026-09-16T07:02:45.396Z
---

Dashboard web locale per tracciare avanzamento compliance GDPR e ISO 27001 per clienti multipli, in `Cybersecurity/Script/Compliance Tracker/`.

**Stack:** Python 3.10+, Flask, pyyaml, reportlab, bcrypt. Venv in `.venv/`.

**Entry point:** `python compliance_tracker.py` — avvia server Flask su 127.0.0.1:8091. Prima esecuzione: setup password interattivo con getpass, salvata come bcrypt hash in `.env`.

**Struttura:**
- `compliance_tracker.py` — entry point web: setup .env, rileva IP/SSH tunnel, avvia Flask
- `webapp/server.py` — Flask app (bind 127.0.0.1 esclusivo, auth sessione, 8 route)
- `webapp/templates/` — login.html, client_select.html, checklist.html, storico.html
- `webapp/static/style.css` — CSS professionale con variabili colore, accordion, tabs
- `checklists/gdpr_checklist.yaml` — 36 controlli GDPR organizzati in 11 aree
- `checklists/iso27001_checklist.yaml` — 43 controlli ISO 27001:2022 (Annex A, 4 categorie)
- `core/client_manager.py` — crea/elenca clienti, cartella per cliente
- `core/state_persistence.py` — salvataggio atomico stato.json + storico_modifiche.jsonl append-only
- `core/progress_calculator.py` — % ponderata per peso, per area e per framework
- `reporter/report_builder.py` — PDF reportlab: copertina, executive summary, dettaglio, evidenze, storico, prossimi passi, disclaimer

**Dati cliente:** `clients/<nome_cliente>/stato.json` + `storico_modifiche.jsonl` + `Report/`

**Stato controllo:** `non_iniziato | in_corso | completato | non_applicabile`

**Formula %:** somma pesi completati / somma pesi applicabili × 100 (esclude non_applicabile)

**Why:** Servizio di readiness compliance GDPR/ISO 27001 per Vektora — NON certificazione formale.

**How to apply:** Aggiungere nuovi controlli solo nei file YAML (no modifiche al codice). Ogni cliente ha la sua cartella isolata.

[[project-ransomware-identifier]]
