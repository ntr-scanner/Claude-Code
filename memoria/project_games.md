---
name: project-games
description: "Games (Progetti/Games/): Dashboard.html stile Work Tools + 7 giochi di riflessi/velocità di pensiero a file singolo, record in localStorage giochi:<id>"
metadata:
  node_type: memory
  type: project
  originSessionId: c600cec8-b6b3-4181-acc0-317214639c9a
  modified: 2026-10-25T18:13:26.919Z
---

`Progetti/Games/` (creata 2026-10-25): `Dashboard.html` clonata dallo stile di [[project-tool-for-work]] (lista `GAMES`, categorie rif/mente/arc, preferiti, recenti, ricerca) + `tetris.html` (preesistente, senza record né link alla dashboard) + 7 giochi, ognuno nella sua cartella: Tempo di Reazione, Bersagli, Go No-Go, Due Mani (effetto Simon, tasti F/J), Stroop, Calcolo Rapido, Tabella di Schulte. `Games/` nella radice di Vektora è la vecchia copia (solo tetris), non usarla.

Convenzioni: HTML singolo offline, link `../Dashboard.html`, favicon fulmine viola uguale alla dashboard, stessa base CSS. Ogni gioco salva `localStorage['giochi:<id>'] = {best,last,plays}` via `saveRecord(v, low)`; la dashboard legge quella chiave e usa `unit`/`low`/`dec` dalla voce `GAMES` (devono combaciare col gioco).

**Why:** l'utente vuole allenare riflessi e parte motoria, con accesso rapido come Work Tools.
**How to apply:** nuovo gioco = cartella propria + voce in `GAMES` con `id` uguale alla chiave record. Test: `python3 -m http.server` nella cartella + Playwright da `~/.npm/_npx/*/node_modules/playwright-core` con `executablePath: '/snap/bin/brave'`.
