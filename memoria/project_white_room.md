---
name: project-white-room
description: White Room, gioco di allenamento cognitivo HTML singolo in Games/White Room, salvataggi in Saves/ condivisi Windows+Ubuntu via Syncthing tramite server Python locale
metadata:
  type: project
---

`Games/White Room/white-room.html`: gioco di allenamento cognitivo (moduli, indice, protocollo giornaliero) in un solo file HTML.

- L'utente usa **Brave** su **Windows e Ubuntu** (dual boot o due PC), cartella sincronizzata con Syncthing.
- Progressi in un unico file `Saves/white-room-dati.js` (`window.WHITE_ROOM_DATA = {...}`), caricato con `<script src="Saves/...">`. Export `.json` in `Saves/Backup/`; copie in conflitto di Syncthing unite e spostate in `Saves/Backup/conflitti-syncthing/`. Backup vecchi della pagina in `Versioni precedenti/`.
- Brave blocca la File System Access API, quindi dal 2026-10-07 il gioco si apre con `avvia-white-room.bat` (Windows) o `avvia-white-room.sh` (Ubuntu) → `white_room_server.py` (stdlib, 127.0.0.1:8770, porta fissa perché localStorage dipende dall'origine). API `/api/dati` GET/POST con etag (409 se il file è cambiato → la pagina rilegge, unisce con `mergeStates`, riprova), `/api/backup`, header obbligatorio `X-White-Room: 1` contro richieste da altri siti.
- Pausa (pulsante, tasto Z, automatica al cambio scheda): `later()` restituisce oggetti timer con scadenza sull'orologio `now()` che si ferma (`Clock`); per annullarli usare `cancel()`, non `clearTimeout`. Barre del tempo fermate con `document.getAnimations()`. Pausa solo con `Run.live` (prove in corso); primo Esc = pausa. Bip Web Audio negli ultimi 3 s se limite >= 5 s, impostazione `settings.sound` (tasto M). Tempo mancante in `renderClock()` (`Tick`).
- Pannello «Tu contro Ayanokoji» in cima alla home (`renderAyano`): riferimento livello 10 + ema 0.95 per modulo = indice 99.5 (`AYANO_IDX`), ritmo con regressione sugli ultimi 30 giorni (`indexPace`), distanza anche nel risultato. Richiesto dall'utente come motivazione.
- La pagina in modalità server rilegge il file ogni 15 s, al focus e al ritorno sulla scheda, solo dalla home (mai a metà sessione). Aperta con doppio clic (file://) resta il vecchio flusso con picker/download.

**Why:** l'utente vuole che «Salva» e il salvataggio automatico scrivano sempre sullo stesso file senza scaricare/sostituire a mano, e che i due sistemi vedano subito gli stessi progressi.
**How to apply:** non reintrodurre download o file multipli; per test usare una copia della cartella nello scratchpad su un'altra porta, mai il `Saves/` vero.
