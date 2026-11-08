---
name: project-musicoteca-android
description: APK Musicoteca per telefono senza server (com.vektora.musicoteca) in Suite Intrattenimento/musicoteca-android, cartella SAF, Media3, preferiti/playlist/ruota
metadata:
  type: project
---

Creata 2026-11-07/08 su richiesta («APK che funzioni senza attivare alcun server»). Scelte dell'utente: cartella scelta con SAF (niente permessi file), Album/Artisti/Brani + casuale, preferiti e playlist, Ruota; **niente** Online (YouTube/SoundCloud servono yt-dlp), niente .lrc/karaoke. Progetto indipendente da [[project-musicoteca]] (nessun codice condiviso, regola `Apk-&-Apps.md`), dentro il repo della Suite.

- Stack come [[project-apk-android]]: Kotlin 2.0.21, AGP 8.7.2, Gradle 8.10.2, Compose BOM 2024.12.01, + Media3 1.5.1 (ExoPlayer + MediaSessionService), kotlinx.serialization, minSdk 26. Niente Koin/navigation: AndroidViewModel + pila di dettagli nel VM.
- Dati in `files/dati.json` con la forma delle sezioni «brani»/«playlist» del PC; chiave = percorso dentro la cartella scelta. Indice in `libreria.json`, tag riletti solo se size/modified cambiano. `AtomicFile`, file rovinato rinominato `.rovinato-<ms>`.
- `MediaSession.Callback.onAddMediaItems` rimette l'URI da `requestMetadata.mediaUri`. Ascolto contato nel servizio a metà durata (controllo ogni 3 s).
- Insidie: lint `ProduceStateDoesNotAssignValue` falso positivo → `remember`+`LaunchedEffect`; adaptive icon deve stare in `mipmap-anydpi-v26` con AGP 8.7 (lint ObsoleteSdkInt da ignorare); senza `secondaryContainer`/`surfaceContainer*` nel tema compaiono i viola di default; gradle + emulatore insieme = exit 137 (RAM 14 GB): spegnere l'emulatore prima di compilare.
- Verificato: `./gradlew assembleDebug lint test` (9 test), emulatore AVD «telefono» Android 14 guidato con uiautomator (script in scratchpad, non salvato): cartella, tag/copertina, sottofondo + notifica, ascolti, preferiti, playlist, ruota, tema scuro, dati dopo `install -r`. Mai su telefono vero né con migliaia di brani.

**Why:** l'utente vuole ascoltare la musica dal telefono senza accendere il server della Musicoteca.
**How to apply:** prima di toccarla rileggere `Claude/Apk-&-Apps.md`; APK in `app/build/outputs/apk/debug/app-debug.apk` (debug, firmato con la chiave di questo PC).
