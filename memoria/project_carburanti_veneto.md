---
name: project_carburanti_veneto
description: "Carburanti Veneto — dashboard prezzi Diesel/Benzina/Metano dai CSV MIMIT, server Python stdlib porta 8795, in Sincronizzazione/Progetti/"
metadata:
  node_type: memory
  type: project
  originSessionId: bdf37437-9db8-4078-b932-f2206fb5eb33
  modified: 2026-10-27T13:11:38.703Z
---

Creato il 2026-10-27 in `Sincronizzazione/Progetti/Carburanti Veneto/` (l'utente ha chiesto esplicitamente quella cartella, anche se INDEX.md dice di non mettere progetti in Sincronizzazione).

- `server.py` (stdlib): scarica `prezzo_alle_8.csv` e `anagrafica_impianti_attivi.csv` da mimit.gov.it/images/exportCSV/, cache in `dati/` 12 ore, filtra le 7 province venete, serve `web/index.html` + `/api/prezzi` su 127.0.0.1:8795. `--aggiorna`, `--porta`, `--no-browser`.
- CSV con separatore `|`, prima riga «Estrazione del AAAA-MM-GG»; ~112 righe dell'anagrafica hanno un `|` dentro nome/indirizzo: campi certi = primi 4 e ultimi 4.
- Esclusi: varianti premium (Blue Diesel, HVO…), GPL, prezzi fuori 0,50–4,00 (nei dati ci sono 0.100 e 4.999), prezzi più vecchi di 30 giorni.
- Pagina: bottoni Dashboard/Diesel/Benzina/Metano come `schede.js` di [[project_ayanokoji_system]] (`.btn` + `aria-pressed`, pagina in `#hash`), accento per sezione via `body[data-sezione]` (viola/arancio/verde/blu).
- Test: `python -B -m unittest discover tests`. Server di sviluppo `carburanti-veneto` in `.claude/launch.json`.
