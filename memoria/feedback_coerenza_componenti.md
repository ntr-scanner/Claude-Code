---
name: feedback-coerenza-componenti
description: Prima di programmare leggere come il programma fa già le cose; un elemento nuovo deve avere tutto quello che hanno i suoi simili
metadata:
  type: feedback
---

Prima di aggiungere un elemento a un'interfaccia esistente (scheda, pagina, sezione), leggere come sono fatti quelli che ci sono già e dare al nuovo le stesse funzioni. Se tutte le schede hanno i dettagli a comparsa (descrizione, metriche, Stato, Ultima revisione), li deve avere anche la nuova.

**Why:** in Ayanokoji System il 2026-10-21 avevo fatto il riquadro di sezione senza i dettagli che hanno tutte le altre schede e l'utente ha dovuto chiederli («se vedi che tutti ce l'hanno non devi non farlo»). Il 2026-10-20 avevo tolto i dettagli a comparsa senza che nessuno lo chiedesse.
**How to apply:** prima di scrivere codice di interfaccia elencare le funzioni dei componenti fratelli e replicarle; mai togliere o saltare una funzione comune senza richiesta. Vedi [[project-ayanokoji-system]].
