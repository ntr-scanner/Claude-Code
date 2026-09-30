---
name: project-scan-orchestrator
description: "scan_orchestrator.py — orchestratore scansioni vulnerabilità autorizzate, flusso interattivo con gate consenso"
metadata: 
  node_type: memory
  type: project
  originSessionId: 2d82adee-6b19-4359-a560-0c0f86841d42
  modified: 2026-09-16T13:38:59.300Z
---

Script `scan_orchestrator.py` in `Cybersecurity/Script/Scan Orchestrator/`.

**Why:** Automazione audit di sicurezza su siti/IP clienti con gate legale (consenso firmato obbligatorio per scansioni attive).

**How to apply:** Dipendenze runtime: `reportlab` (PDF), `rich` (opzionale). Tool esterni: subfinder, amass, whatweb, nmap, testssl.sh, nuclei, nikto, OWASP ZAP (Docker). Il modulo consenso PDF viene salvato nel path `CONSENSO_PDF_PATH` definito in cima al file (tradotto automaticamente in path WSL se rilevato).
