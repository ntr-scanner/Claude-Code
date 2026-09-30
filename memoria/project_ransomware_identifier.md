---
name: project-ransomware-identifier
description: "Ransomware Identifier + Sentinel v2.0 — identificazione famiglia ransomware, IR wizard, e sistema di monitoraggio real-time con 8 estensioni di sicurezza (partizione prove, honeypot, baseline, killswitch, insurance report, compliance, dashboard)."
metadata: 
  node_type: memory
  type: project
  modified: 2026-09-21T10:26:04.293Z
  originSessionId: 2c375b96-f0ce-4915-bfbb-4b99ae514699
---

**Percorso:** `C:\Users\pc\Documents\Web Developer\Cybersecurity\Script\Ransomware Identifier\`

**Struttura base:**
- `ransomware_id.py` — identificazione ransomware da file cifrati (sola lettura)
- `sentinel.py` — monitoraggio real-time (live + --dry-run + comandi admin)
- `install_sentinel.py` — wizard installazione guidata (NUOVO)
- `incident_response.py` — wizard IR interattivo 4 step
- `sentinel_config.yaml` — config completa con tutte le sezioni v2

**Moduli Sentinel (sentinel_modules/):**
- `auto_response.py` — risposta automatica con snapshot+isolamento PARALLELI (v2 CRITICO)
- `file_activity_monitor.py` — watchdog file, integra honeypot_manager
- `process_monitor.py` — psutil, shadow copy detection
- `activity_lock.py` — lockdown LOCKDOWN_ACTIVE file
- `honeypot_manager.py` — canary files (NUOVO)
- `behavior_baseline.py` — whitelist dinamica da dry-run (NUOVO)
- `killswitch_checker.py` — killswitch DNS check SPERIMENTALE (NUOVO)
- `backup_status_checker.py` — verifica ultimo snapshot Restic (NUOVO)

**IR modules (ir_modules/):**
- `ir_report_builder.py` — report incidente MD + `build_insurance_report()` (NUOVO)
- `evidence_collector.py`, `chain_of_custody.py`, `isolation_step.py`

**Dashboard (sentinel_dashboard/):**
- `app.py` — Flask 127.0.0.1:8765, endpoint /api/heartbeat, host_keys.yaml
- `templates/index.html` — dark theme, auto-refresh 60s

**Punti critici v2:**
- Snapshot in RAM + isolamento rete in PARALLELO → scrittura solo post-isolamento sulla partizione dedicata
- evidence_partition_path validato su mount point diverso (os.path.ismount / drive letter)
- Partizione dedicata obbligatoria per prove sicure; fallback locale con avviso
- Honeypot: score 999 immediato bypassa accumulo graduale
- Compliance Tracker integration: opzionale, fallisce silenziosamente

**Dipendenze v2:** pyyaml, watchdog, psutil, requests; Flask opzionale (solo dashboard)

**Why:** Passaggio 2 del protocollo IR Vektora + servizio Sentinel continuo su server clienti.

**How to apply:** Setup iniziale con `python install_sentinel.py`. Dry-run obbligatorio prima del live.
