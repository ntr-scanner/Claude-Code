---
name: feedback-coerenza-nuovi-file
description: "Regola standing per creare nuovi file/pagine sui siti Vektora — riusare animazioni, CSS/JS e struttura esistenti senza chiederlo ogni volta"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5bf867d2-8edc-43ba-a0b6-5664b0035f3c
  modified: 2026-07-24T12:05:41.111Z
---

Quando si crea un nuovo file/pagina per un sito del progetto [[project_vektora]] (o [[project_vektora_blog]]), applicare automaticamente, senza che l'utente lo debba ripetere:
- Le stesse animazioni, transizioni ed effetti già presenti nelle altre pagine del sito.
- La stessa configurazione: CSS in `css/styles.css`, JS in `js/script.js`, stessa struttura header/nav/footer, stesse variabili di colore/font.
- Nessuno stile, libreria o pattern nuovo rispetto a quanto già presente nel progetto, salvo richiesta esplicita.

Se il file richiesto richiederebbe necessariamente qualcosa di diverso da ciò che già esiste (es. un layout che non si adatta alla struttura attuale), segnalarlo all'utente prima di procedere invece di decidere autonomamente.

**Why:** L'utente vuole coerenza visiva/tecnica automatica tra tutte le pagine dei siti Vektora, senza dover ripetere queste istruzioni ad ogni nuovo file.

**How to apply:** Prima di creare un nuovo file HTML/pagina per un sito Vektora, leggere le pagine/file esistenti (css/styles.css, js/script.js, componenti header/nav/footer) e replicarne pattern e variabili. Interrompersi e chiedere solo se serve qualcosa di strutturalmente diverso.
