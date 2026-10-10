---
name: project-vektora-rmm
description: Vektora RMM Console — demo HTML a file singolo (RMM multi-tenant, patch pipeline, LAPS vault) in Prodotti Vektora/vektora-rmm/, dati simulati
metadata:
  type: project
---

Creata il 2026-10-10 da un prompt dell'utente ("dashboard controllo multi-clienti"): `Vektora Site/Prodotti Vektora/vektora-rmm/index.html` + `README.md`. Vanilla HTML/CSS/JS, nessuna build, UI in inglese come da prompt, palette brand del prompt (#0B0F17/#111827/#1F2937, teal #00F2FE, viola #7C3AED, ambra, cremisi). Viste: Fleet Overview, Patch Manager, Clients, Credential Vault; deep-link `#overview|#patch|#clients|#vault`.

Dati: 1.248 endpoint con seed fisso (mulberry32 20261010), 6 clienti fittizi tarati per semaforo A/D rossi, B/E gialli, C/F verdi (parametri `posture` e `risk = (1-posture)*1.5`); CVE/KB reali. Tutte le azioni sono simulate.

**Why:** demo per presentazioni/vendita, non collegata a backend.
**How to apply:** test logici con jsdom di `Progetti/Sonar/app/node_modules` (serve `structuredClone` e `history.replaceState` protetto da try/catch); screenshot con `/snap/bin/brave --headless=new --screenshot` salvando in una cartella della home (lo snap ha /tmp privato; Firefox è solo stub snap). Su questa macchina Linux non ci sono altri browser headless. Vedi [[project-vektora-prodotti]] se va aggiunta al catalogo.
