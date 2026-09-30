---
name: project-autoverifica
description: "Sito statico multi-materia di autoverifica esami (Ingegneria Informatica), vanilla JS, GitHub Pages, in Università/autoverifica/"
metadata:
  node_type: memory
  type: project
  originSessionId: 0ba23e18-ad3e-4906-abb4-0ef14fbd2bae
  modified: 2026-09-23T11:14:14.048Z
---

Sito statico in `Web Developer/Università/autoverifica/` (creato 2026-09-23). Materie in `subjects/<slug>/questions.json` ({name, questions:[{topic,q,opts,correct,expl}]}) + riga in `subjects/index.json`. Limite globale 10 domande/giorno, voto in trentesimi animato a fine ciclo (≥18 superato, confetti; altrimenti rosso + faccine tristi). Anteprima: config "autoverifica" in `Web Developer/.claude/launch.json` (porta 8765).

**Why:** l'utente vuole allenarsi per esami universitari senza backend, pubblicando su GitHub Pages.
**How to apply:** nessun riferimento a università/docente/"paniere" nel sito; titolo "Ingegneria Informatica" + nome materia. Progresso legato all'hash del testo domanda (non all'indice). Origine: il quiz singolo `Università/Fondamenti di Informatica/fondamenti-informatica-quiz.html`.
