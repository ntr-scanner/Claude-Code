---
name: project-cyber-study-room
description: Cyber Study Room, pagina HTML singola, tracciatore dell'apprendimento cybersecurity (un argomento alla volta per materia); stesso stile e server di salvataggio di White Room (porta 8771)
metadata:
  type: project
---

`Ayanokoji/Ayanokoji System/Cyber Study Room/cyber-study-room.html` (creata 2026-10-08), accanto a `../White Room/`.

- **Scopo (dal 2026-10-08, 2ª versione):** tracciatore dell'apprendimento, NON più abitudini giornaliere (serie/calendario/giorno minimo rimossi: l'utente le gestisce in Super Productivity). Per ogni materia un programma completo ordinato; si vede **un solo argomento alla volta** (il primo non completato: titolo, "cosa devi saper fare", risorsa, ~30 min, appunto). «Fatto» avanza, «Annulla» solo sull'ultimo completato, sezione «Completati (N)» richiudibile. I titoli futuri non si renderizzano (il curriculum vive nei dati, non è nascosto nel senso di assente).
- **Struttura:** 7 materie (una per giorno, barre in home, oggi evidenziata) + 2 facoltative (Security+ 28 obiettivi, Ethical Hacker Musa a lezioni, totale impostabile). Dati nell'oggetto `CURRICULUM` tra marcatori INIZIO/FINE DATI; formato `[id, titolo, goal, chiaveRisorsa, url?]`. Conteggi: Linux 30, Net 28, Web 28, Python 29, OWASP 27, THM 19, Bandit 34, Security+ 28, Musa dinamico.
- **Progresso iniziale (DEFAULT_DONE):** linux 8, web 2, thm 5, musa 2. Bandit: Level 0→1 … 33→34 (34 argomenti, niente password/soluzioni). OWASP edizione 2025. THM Pre-Security: elenco da verificare (avviso in pagina), «Mastery Chest» incluso.
- **Dati schema v2** (`cyberStudy.v2`), migrazione da v1: appunti preservati (sezione "Appunti importati"), progresso stimato per materia, serie/calendario ignorati. Ogni materia ha `{n, at, notes}`: merge per `at` più recente (così «Annulla» non viene annullato dall'autosave/sync), appunti uniti senza perdite. Export/import JSON con rifiuto dei file non validi; Azzera non riapplica i default.
- **Server/file:** `cyber_study_server.py` stdlib, 127.0.0.1:**8771**, header `X-Cyber-Study`, etag/409, crea `Saves/cyber-study-dati.js` segnaposto se manca (la pagina lo tratta come vuoto con `hasJson`). `dati_validi` accetta v1(days) e v2(subjects). Timer (Date.now) solo in localStorage, non nel file.
- **Test:** Playwright Node nella cache npx (`npm-cache/_npx/e41f203b7505f1fb`), `channel:'msedge'`, nessun browser scaricato. Copia nello scratchpad, porta 8791; resettare il file placeholder tra i run (il server vi riscrive lo stato). Backup `cyber-study-room.backup.html` accanto alla pagina.

**Why:** l'utente ha ripensato lo scopo: vuole un percorso di studio che mostri una cosa alla volta, con lo stesso autosalvataggio via server di White Room.
**How to apply:** tocca `CURRICULUM` per i contenuti; tieni allineato lo schema v2 tra pagina e server; non usare la porta 8770; non reintrodurre serie/calendario.
