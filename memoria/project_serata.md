---
name: project-serata
description: Serata 1.0 (porta 8801, rete di casa di default) in Intrattenimento/serata: Quiz a domande importate e Disegna e indovina, TV con password, telefoni con codice stanza
metadata:
  type: project
---
Creata 2026-10-31. Base comune: [[project-intrattenimento-base]] con `lan_default=True` e `public_api` per i giocatori.
- Server autoritativo (classe Game in memoria, `_tick` a ogni richiesta, `seq` per ridisegnare): quiz 500 + fino a 500 per velocità; disegna 300 + fino a 400, 100 a chi disegna per indovino; «quasi!» con Levenshtein 1.
- `/gioca.html` + `gioca.js`: ridisegna solo quando cambia la firma della fase (altrimenti cancellerebbe disegno e testo). Invio tratti avviato con setTimeout dopo il mount.
- `logica.js`: parseQuiz (CSV/JSON/Markdown/testo, motivo per ogni scarto), AI_PROMPT. `ruota.js` (copia modificata): `spin(index)` si ferma sullo spicchio scelto dal server.
- Giochi scelti dall'utente: Quiz e Disegna e indovina (non «Chi è stato»).
