---
name: project-vektora
description: "Vektora — agenzia web freelance, framework WAT (Workflows-Agents-Tools) per gestire progetti clienti con HTML/Tailwind/JS vanilla deployati su Netlify"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6740d33f-f357-4214-8608-73d7e84bdc76
---

Il progetto principale si chiama **Vektora**, un framework WAT (Workflows, Agents, Tools) per gestire sviluppo web di clienti freelance.

**Struttura WAT:**
- `workflows/` — SOP in Markdown, definiscono obiettivo/input/step/output/edge-case
- `tools/` — Script Python per esecuzione deterministica (genera HTML, ottimizza immagini, ecc.)
- `docs/` — Documentazione Obsidian per ogni progetto cliente
- `.tmp/` — File temporanei rigenerabili, non in git
- Progetti clienti: `[anno]-[nome-cliente]-[tipo-sito]/` (es. `2025-rossi-parrucchiere/`)

**Stack tecnico:** HTML + Tailwind CDN + JS vanilla, deploy GitHub → Netlify auto

**Percorso progetto:** `c:\Users\pc\Documents\Web Developer\Vektora Site\`

**Why:** Separazione AI (orchestrazione) / script Python (esecuzione deterministica) per mantenere accuratezza alta su task ripetitivi.

**How to apply:** Quando si lavora su un task, leggere prima il workflow pertinente, poi eseguire o creare il tool corrispondente. Non fare generare codice direttamente all'AI quando esiste un workflow+tool.

**Template esistenti** (`templates/`):
- `parrucchiere-base.html`
- `dentista-base.html`
- `ristorante-base.html`
- `hotel-base.html`
- `idraulico-base.html`

**Template futuri** (da creare quando serviranno):
- `laboratorio-odontotecnico-base.html`
- `studio-legale-base.html`
- `palestra-fitness-base.html`
- `agenzia-immobiliare-base.html`
- `farmacia-base.html`
- `centro-estetico-base.html`

Workflow disponibili (tutti in `workflows/`):
- `nuovo-progetto-cliente.md`
- `crea-componente.md`
- `ottimizza-immagini.md`
- `deploy-netlify.md`
- `crea-documentazione.md`
- `audit-sito.md`
