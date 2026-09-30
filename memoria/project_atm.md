---
name: project-atm
description: Ayanokoji Task Manager — task manager self-hosted costruito completamente in questa sessione
metadata: 
  node_type: memory
  type: project
  originSessionId: 1cbd1a97-f07e-49ce-accd-b08d87ab2f38
---

Progetto ATM completato in tutte e 6 le fasi.

**Why:** Sostituto leggero di Plane per hardware vincolato (4GB RAM, HDD). Self-hosted su homelab fisico, accessibile in rete locale.

**Percorso file:** `C:\Users\pc\Documents\SyncThings\Task Manager Ayanokoji\`

**Stack:** FastAPI + PostgreSQL 15 + Nginx + Vanilla JS/Tailwind CDN — 3 container Docker.

**Stato:** Tutte le fasi completate (1-6). Pronto per `docker compose up -d` dopo aver creato il `.env` con `setup_credenziali.py`.

**Deploy:** GitHub repo privata → `git clone` sul server → creare `.env` → `docker compose up -d`.

**How to apply:** Se l'utente torna su ATM, il codice è già completo. Le fasi future potrebbero essere: accesso esterno (tunnel/VPN), notifiche, app mobile PWA.

Link correlati: [[project_vektora]]
