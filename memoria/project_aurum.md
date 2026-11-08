---
name: project_aurum
description: "Aurum — server locale PAC disciplinato su ETF a fasi di rischio, in Free Claude Code/Aurum, piano in 4 prompt"
metadata:
  node_type: memory
  type: project
  originSessionId: ecad07a2-8efd-4c13-af7b-ab607d9e9031
  modified: 2026-11-07T14:37:01.060Z
---

Aurum (`Free Claude Code/Aurum/`), nato il 2026-11-07. L'idea iniziale era un server 24/7 con segnali di mercato.
È stato ridotto a uno strumento di disciplina per il PAC: versamenti, tappe, ribilanciamento, costi e tasse, avvisi
di drawdown. Il modulo segnali resta spento finché una regola non batte il PAC fuori campione, al netto di costi e tasse.

- **Fasi di rischio** (scelta dell'utente): si parte prudenti e si sale. Fase 1 strumenti a basso rischio tenuti fino alla scadenza (BFP, iBonds, BTP)
  fino a 5k, Fase 2 50/50 fino a 25k, Fase 3 80/20 con satellite al massimo 10% del totale. Il passaggio di fase
  è proposto e confermato dall'utente, mai automatico; i nuovi versamenti seguono la nuova allocazione.
- **Server:** porta 10000, solo 127.0.0.1. Telegram attivabile. In seguito un bot separato avvisa quando il server
  è spento.
- **Dove sono le decisioni:** in `README.md`, sezione «Decisioni». I prompt originali (5) sono in
  `prompt_originali/`; quelli riscritti (4) seguono l'ordine ricerca → server → controllo → correzioni.

**Why:** l'utente aveva chiesto investimenti «che non cadono». Va ricordato che anche i titoli di stato perdono
valore (2022, durate lunghe).

**How to apply:** non promettere rendimenti. Prima di toccare il codice, leggere le Decisioni nel README.
Il passo 1 (ricerca) è stato completato il 2026-11-08: `ricerca/LEGGIMI.md`. Nessuna regola di segnale supera il PAC, quindi i segnali restano spenti. Per la Fase 1 il candidato è il BFP 4 anni RisparmioSemplice. Yahoo chart API richiede `period1`/`period2` (con range=max arrivano dati mensili); Stooq ha un controllo anti-bot. Il passo 2 (server 1.0.0) è stato completato il 2026-11-08 in `codice/`: base.py, menu_app.py, comune.js e base.css sono copie identiche della Suite Intrattenimento. Archivio JSON al posto di SQLite. Test: 18 unittest più Playwright via Node, usando `node_modules` di Vivlos (l'MCP Playwright era occupato da un'altra sessione). Prossimi: `prompt_3.md` (controllo, meglio in una sessione nuova) e `prompt_4.md`.
