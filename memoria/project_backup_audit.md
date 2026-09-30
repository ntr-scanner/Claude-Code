---
name: project-backup-audit
description: "Vektora Backup Integrity Audit — install_backup_audit.py genera struttura completa per verificare integrita' reale di backup Restic/Git+GPG/archivi, con test restore e report PDF."
metadata: 
  node_type: memory
  type: project
  originSessionId: f1ce2be3-482f-4d1d-89dc-e62586f92ec7
  modified: 2026-09-08T13:29:28.626Z
---

**Percorso progetto:** `C:\Users\pc\Documents\Web Developer\Cybersecurity\Script per server\Backup Audit\`

> Nota: il pattern bootstrap installer (install_backup_audit.py) e' stato eliminato.
> Il progetto esiste ora come struttura di file reali separati, pronta all'uso.

**Struttura** (`Backup Audit/`):
- `backup_audit.py` — entry point: --quick / --normal / --deep / --setup-telegram / --serve-report
- `requirements.txt` — pyyaml, reportlab, requests
- `config.yaml` — elenco backup con tipo, path, frequenza attesa
- `checkers/restic_checker.py` — snapshots JSON, restic check, restore parziale da tmp; password via getpass o file, env var RESTIC_PASSWORD solo nel subprocess
- `checkers/git_backup_checker.py` — git fetch+sync, decrypt .gpg in TemporaryDirectory, verifica header SQL/JSON valido; passphrase da /root/.backup-passphrase o interattiva
- `checkers/generic_archive_checker.py` — tar -tz / zipfile.testzip + estrazione campione in tmp
- `reporter/report_builder.py` — PDF con reportlab (A4, contatori OK/WARN/CRIT, tabella risultati, sezione problemi, raccomandazioni)
- `notifier/telegram_notifier.py` — sendDocument PDF + summary HTML; stesso pattern .env chmod 600

**Dipendenze runtime:** `pyyaml reportlab requests` + `restic` + `gpg`

**Sicurezza hardcoded:**
- Password/passphrase mai loggata, mai su disco da questo tool
- Decrypt GPG sempre in `tempfile.TemporaryDirectory()` (eliminato automaticamente anche in caso di crash)
- Backup originali mai modificati (solo lettura)

**Fonti reali integrate:**
- Restic: da Backup Automatico Local (repo_dirname: "restic-repo", password interattiva)
- Git+GPG: da Backup Automatico Servers (path: /opt/backups/github-backup/repo, passphrase: /root/.backup-passphrase, file: n8n-db-*.sql.gpg, n8n-workflows-*.json.gpg)

**Cadenza raccomandata:**
- `--quick` settimanale (cron)
- `--normal` (default) mensile
- `--deep` (--read-data) trimestrale
- `--serve-report` one-shot: audit + web server 127.0.0.1 + **conferma manuale YES a terminale** prima di auto-eliminare (timeout = no-elimina, INVIO/altro = ri-propone prompt)
- `webserver/report_server.py`: `_find_port()`, `_html_page()`, `_Handler`, `_schedule_delete()`, `_terminal_confirm_loop()`, `serve_report()`
- Auto-eliminazione SOLO dopo digitazione esplicita "YES" (case-sensitive), mai automatica

**Why:** backup esistente != backup funzionante; verifica ripristinabilita' reale in ambiente isolato.
**How to apply:** config.yaml a-la-carte: aggiungere backup = aggiungere entry YAML, nessun codice da toccare.
