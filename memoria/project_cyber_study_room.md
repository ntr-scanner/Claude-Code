---
name: project-cyber-study-room
description: Cyber Study Room, pagina HTML singola per studio cybersecurity 30 min/giorno, stesso stile e server di salvataggio di White Room (porta 8771)
metadata:
  type: project
---

`Ayanokoji/Ayanokoji System/Diagnosi Ricadute/Cyber Study Room/cyber-study-room.html` (creata 2026-10-08), accanto a `White Room/` e `diagnosi-ricadute.html`.

- Clone architetturale di [[project-white-room]]: palette scura, componenti `.panel/.kicker/.btn`, `cyber_study_server.py` (stdlib, 127.0.0.1:**8771**, header `X-Cyber-Study: 1`, etag/409, `/api/backup`), lanciatori `avvia-cyber-study.bat/.sh`, dati in `Saves/cyber-study-dati.js` (`window.CYBER_STUDY_DATA`). Il server crea un segnaposto senza JSON se il file manca (la pagina lo tratta come vuoto con `hasJson`).
- Piano fisso per giorno (lun Linux … dom Bandit), Security+ solo come «tema libero», Musa Ethical Hacker bonus fuori dalla serie. Stato iniziale dell'utente in `DEFAULT_DONE` (vale finché la voce non viene cambiata; «Azzera» torna lì).
- Unione tra PC: per giorno / voce mappa / voce aggiunta vince `at` più recente. Il timer (Date.now) vive solo nel localStorage del browser.
- Test: Playwright Node nella cache npx (`npm-cache/_npx/e41f203b7505f1fb`) con `channel: 'msedge'`, nessun browser Playwright scaricato. Testare su copia nello scratchpad, porta 8791.

**Why:** l'utente vuole lo stesso autosalvataggio via server di White Room e le due app nella stessa cartella.
**How to apply:** modifiche a salvataggio/server vanno tenute allineate con White Room; non usare la porta 8770.
