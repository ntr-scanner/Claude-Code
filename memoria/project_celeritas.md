---
name: project_celeritas
description: Celeritas — motore download a segmenti Python (piano JSON/eventi JSON, compatibile Velora) fortificato, in Cybersecurity/Script/Celeritas, usato da Media Loader 5.1.0
metadata:
  type: project
---

Celeritas 1.0.0 (2026-11-22) in `~/Vektora/Cybersecurity/Script/Celeritas/` (repo git inizializzato, nessun commit: lo fa l'utente; GitHub da creare). Nato dalla dissezione di Velora 2.2.0 (binario Rust chiuso di VibraVid) con REA CLI (`npx rea-agents@6.9.0`, serve Node ≥26.12.1: installato 26.13.1 con nvm, default resta 26.11.1 → per questo l'MCP REA cade con CONNECTION_CLOSED) + prove nere su server locale.

Velora osservato: PIE/NX/RELRO sì, CET no, strippato; accetta HTML 200 come segmento, nessun limite di byte (250 MB infiniti scritti), path non confinati, `.part` orfani su troncamento; buono: niente Cookie/Authorization verso altri host, `file://` non seguito. Chiavi piano: max_redirects, max_speed_bytes_per_sec, user_agent, http_version 1.1/2.0/3.0, proxy_url, verify_tls.

Celeritas aggiunge: radice di confinamento (default cartella del piano, `--root`), `max_bytes_per_task`, HTML rifiutato, reti private bloccate (SSRF; `allow_private_networks` solo test), redirect solo http/https senza downgrade, `.part` O_EXCL|O_NOFOLLOW + os.replace, Retry-After, sha256 per evento, header validati, `trust_env=False`, URL fuori dagli eventi. CLI secondo SCRIPT.md (help italiano, wizard, --dry-run, exit 0/1/2/130). 27 test (`.venv` propria). Copie identiche in Media Loader `codice/celeritas/` e, dal 2026-11-25, in Theca e Cineteca-FCC `codice/celeritas/` (usate da `core/celeritas_hls.py`): correzioni in tutte ([[project_media_loader_v3]], [[project_cineteca]]).

**Why:** l'utente voleva Velora «fortificato e all'avanguardia» come progetto separato con nome greco/romano. Rust (rustup) negato dal controllo permessi → scritto in Python; port Rust possibile se l'utente autorizza rustup.
**How to apply:** modifiche al motore nel repo Celeritas, poi ricopiare in Media Loader (`diff -r` deve essere vuoto).
