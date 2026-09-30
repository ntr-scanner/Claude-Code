---
name: feedback-blog-immagini-copertina
description: "Regola obbligatoria: prima di creare un nuovo articolo del blog Vektora, controllare se esiste un'immagine di copertina corrispondente"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 866739fb-b82e-4b77-a206-b96dd02cbb2c
  modified: 2026-07-21T08:28:26.991Z
---

Per il blog Vektora ([[project-vektora-blog]]), prima di creare un nuovo
articolo in `blog-src/`, controllare sempre `blog-src/image/` per un file
il cui nome corrisponda (anche solo per somiglianza, non serve match
esatto) al titolo dell'articolo da pubblicare.

- Se il file esiste → collegarlo nel front matter `copertina:` con il
  path `/blog/image/<nome file esatto>` (percorso invariato, nome file
  con spazi/apostrofi/accenti lasciato com'è — il filtro Eleventy
  `encodeUri` in `.eleventy.js` si occupa di codificarlo ovunque serva
  in HTML: card, hero articolo, `og:image`, JSON-LD)
- Se il file NON esiste → **non procedere con un placeholder o
  un'immagine scelta autonomamente**. Segnalarlo esplicitamente
  all'utente e aspettare che aggiunga il file in `blog-src/image/`
  prima di continuare.

**Why:** l'utente vuole controllare personalmente ogni immagine che va
online sul blog (coerente con la regola generale del progetto Vektora
di non scegliere mai immagini in autonomia), ma vuole anche che il
collegamento tra articolo e immagine sia automatico quando il file
è già presente, senza doverlo chiedere ogni volta esplicitamente.

**How to apply:** il match nome-file/titolo è un giudizio umano
approssimativo (esempio reale: titolo "3 errori di sicurezza che
vediamo più spesso nei siti delle PMI italiane" abbinato al file
"3 errori di sicurezza nelle PMI.png") — non serve corrispondenza
esatta carattere per carattere, basta che sia chiaramente lo stesso
articolo. In caso di dubbio, chiedere conferma invece di indovinare.

Nota tecnica collegata: `blog-src/` deve restare alla radice di
`vektora-site-main/` (sibling di `assets/`, `index.html`, ecc.), MAI
dentro la cartella `blog/` (quella è solo output di build, rigenerata
da Eleventy e ignorata da git — vedi `.gitignore`).
