---
name: project-videoteca
description: Videoteca 1.0 (porta 8802) in Intrattenimento/videoteca: libreria video porno/hentai stile Scaffale Mangawa, lettore con Range, scene, StashDB, doppioni oshash+phash, AV1, organizza, In arrivo, cestino, cassaforte AES-GCM
metadata:
  type: project
---
Creata 2026-11-01 su richiesta («come Scaffale Mangawa ma solo per video porno e hentai, guardare nel server, organizza da metadata come Ruota» + i 5 tool: doppioni, cassaforte, schede/tag, anteprime e scene, pulizia spazio). Base comune: [[project-intrattenimento-base]] (5ª app con base.py/comune.js/base.css identici).

Scelte dell'utente: **biblioteca propria** (video spostati nella libreria, non letti sul posto), **cassaforte cifrata dentro l'app**, **AV1**, rete **a scelta all'avvio** (menu 1 = PC, 2 = telefono / `--lan`).

- Libreria in una cartella scelta dal PC (default suggerito `~/Videoteca`, fuori da Syncthing: il disco ha ~36 GB liberi), tipo = prima cartella `Porno/` o `Hentai/`. Libreria e In arrivo salvate in `~/.cache/vektora-videoteca/impostazioni.json` (solo PC), con indice, `mini/`, `griglia/`, `copertine/`.
- Chiave di schede/scene/preferiti = **oshash** (come Stash): restano attaccate se il file si sposta; conversione e uscita dalla cassaforte le spostano sul nuovo oshash (`move_user_data`).
- phash «come Stash» (25 fotogrammi 160 px in 5×5 via ffmpeg con 25 `-ss -i`, 64×64 bilineare, DCT pura Python): compatibilità esatta con StashDB NON verificata (nessuna chiave usata nei test); oshash è la prima impronta. Stesso video in 2 risoluzioni = 2 bit, diversi ~38.
- StashDB: `findScenesBySceneFingerprints`, campo data `release_date` con ripiego su `date`; chiave da `../dati/stashdb.key` o quella di Ruota (`porn-roulette-v.3/dati/stashdb.key`). Hentai mai su StashDB: titolo da `scheda_da_nome`. Scheda `fonte: manuale` non sovrascritta senza `forza`.
- Cassaforte `<libreria>/.cassaforte/`: formato `VKT1` blocchi da 1 MiB, AAD = intestazione + indice blocco; chiave dati avvolta da scrypt(password); indice cifrato con nomi, schede e scene (tolte da videoteca.json). Si chiude quando finisce la sessione che l'ha aperta (`vault.owner`) o dopo i minuti di autoblocco senza usarla; `lock_all` avvolto per chiuderla col PC bloccato. Solo dal PC.
- Spostamenti (import, doppioni, organizza, tipo, ripristino) passano tutti dal Runner «spostamenti» con registro scritto prima e Annulla; `move_file` gestisce EXDEV (copia+rename+cancella).
- Insidie trovate: chiave `video` della risposta sovrascritta da `**self.state()` (ora `da_cercare`); pagina async (Cassaforte) che finisce dopo il cambio di pagina sovrascriveva la vista (controllo `page()` dopo await); un lavoro finito prima del primo controllo non ricaricava (`watch(after=true)`). Mai `prompt()`/`confirm()`: `ask()` della pagina con campo testo/password.
- Test: 18 Python (`python3 -B -m unittest discover -s tests`, ~25 s con ffmpeg, video di prova `testsrc2`; `mandelbrot` vuole `-t`, non `duration=`) + 6 Node. Prova browser con server `HOME=<scratch>/home … --port 8899 --dati <scratch>/dati`, Playwright Brave, screenshot in `~/rprova/`.
- Non provato: Windows (lanciatori, `.lnk`), conversione su video lunghi veri, StashDB reale.

**Why:** l'utente vuole un posto unico e privato per guardare e tenere in ordine i video, senza Stash.
**How to apply:** modifiche partono da `videoteca/codice/`; base comune va ricopiata nelle 5 app; alzare VERSION a ogni modifica al server.
