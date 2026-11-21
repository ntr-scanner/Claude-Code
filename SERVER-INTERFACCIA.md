# Server locali: regole dei bottoni e delle azioni (regola dell'utente, 2026-11-14)

File separato da `SERVER-LOCALI.md` per non allungarlo: vale per ogni server locale e web app personale (Ayanokoji System, Suite Intrattenimento, Theca, Vivlos, …). Leggerlo insieme a `SERVER-LOCALI.md` §6 «Interfaccia».

## Cancellare e togliere

- **Mai la parola «Elimina»** su un bottone. Si usa solo il **cestino** 🗑, in un bottone neutro senza fondo colorato e con il cestino blu (colore d'accento del server), con `title` e `aria-label` «Elimina …» per il lettore di schermo.
- **Mai la parola «Togli»** su un bottone. Si usa **✕** rosso, con lo stile del bottone «Spegni server» (in Ayanokoji `class="btn danger"`), con `title` e `aria-label` «Togli …».
- Se il server ha icone a linee proprie (Ayanokoji: `icone.js`, e `emoji.js` toglie le emoji dal testo visibile), cestino e ✕ sono icone di quel set, non emoji: un'emoji filtrata lascerebbe il bottone vuoto. In Ayanokoji: `el('button', { …, ico: 'cestino' })` / `ico: 'chiudi'`.
- La conferma resta come prima: secondo clic nella pagina o finestra della pagina, mai `confirm()` del browser per le azioni distruttive. Il bottone di conferma dentro la finestra tiene una parola (es. «Cancella»), perché lì serve leggere cosa succede.

## Attività e cose da fare

- Un'attività che si può completare ha un bottone **✓** («svolta») e, se ha una data, **Rischedula** (sceglie la nuova data e tiene traccia dello spostamento).
- Se un'attività si ripete, la ripetizione si calcola al volo dalla regola; nei dati si salvano solo la regola e le eccezioni (fatta, spostata, cancellata), mai l'elenco infinito delle occorrenze.

## Registrazioni uguali

- Due registrazioni con gli stessi valori (es. due meditazioni da 5 minuti nello stesso giorno) sono **due** registrazioni: mai deduplicare o fondere voci in base ai valori. Ogni voce ha il suo id. Dove ha senso, il modulo ha un campo «Sessioni» (default 1) e i totali lo contano.
