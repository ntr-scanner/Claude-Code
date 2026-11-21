---
name: project-galleria-android
description: APK Galleria senza server (dalla 1.1 aggiornamento dal PC con aggiorna.py) in Suite Intrattenimento/galleria-android: tutto il telefono da MediaStore, minSdk 30, cestino/riordino con richieste di sistema; verificato su emulatore 2026-11-08
metadata:
  type: project
---

Creata 2026-11-08 su richiesta («apk del progetto galleria»), stessa base di [[project-musicoteca-android]] (stack, wrapper, Archivio→AtomicFile). Scelte dell'utente: senza server, **niente cartella da scegliere, scansiona tutto il telefono** (MediaStore Files, immagini+video), funzioni: per mese + visore, Un anno fa + preferite, duplicati, riordina anno/mese, video, cartelle escluse, elimina.

- minSdk 30 (scelta mia, dichiarata): `createWriteRequest` per spostare (update RELATIVE_PATH+DISPLAY_NAME), `createTrashRequest` per eliminare (cestino 30 giorni). Niente MANAGE_MEDIA.
- Insidia trovata: MediaStore lascia DATE_TAKEN = NULL se la data EXIF dista più di un giorno dalla data del file (foto copiate/pushate). L'app legge EXIF da sé (android.media.ExifInterface) solo per foto senza data né da nome, cache `files/exif.json` chiave "id:date_modified".
- Duplicati: resta il **più vecchio** (DATE_ADDED, id), NON il percorso più corto come sul PC (sul telefono la copia stava in cartella più corta dell'originale). Copie nel cestino, non `_Duplicati/`.
- Riordino: cartella scelta, `anno/mm-mese/`, nomi liberi case-insensitive, registro prima di spostare, Annulla; cartelle escluse saltate; radice esclusa dalla scelta.
- Preferite per id MediaStore (resta uguale dopo uno spostamento).
- Test emulatore: push file con `adb push` uno per volta (con `-a` fallisce), poi `content call --uri content://media/ --method scan_volume --arg external_primary`; dialoghi di sistema in inglese (ALLOW/DENY/ALLOW ALL). VideoView va dimensionato con aspectRatio (non ingrandisce da solo).
- APK debug ~55 MB: con minSdk ≥ 28 i dex sono salvati non compressi, normale.

- 1.1.0 (2026-11-09, fatta su Windows senza JDK/SDK: build e test JVM NON eseguiti): video assenti su telefono vero Android 14+ → lettura da raccolte Images+Video separate invece di MediaStore.Files (causa probabile, non provata); avviso SenzaVideo/SenzaFoto; vista Mese/Album in Foto (`Dati.album`); «Cerca aggiornamenti» in Strumenti + `aggiorna.py` (porta 8803, confronto SHA-256 dell'APK installato, PackageInstaller con USER_ACTION_NOT_REQUIRED, server si spegne dopo l'invio/«uguale»/15 min). Aggiunti INTERNET + REQUEST_INSTALL_PACKAGES (solo IP LAN, `indirizzoPc`). L'utente chiama «Impostazioni» la scheda Strumenti.

**Why:** l'utente vuole un'app galleria vera sul telefono, non un client del PC.
**How to apply:** prima di modifiche rileggere `Claude/Apk-&-Apps.md`; `./gradlew assembleDebug test lint`; non provati: telefono vero, migliaia di foto, SD, accesso parziale. Codice non committato.
- 1.2.0 (2026-11-15, Linux JDK 21): la 1.1 compilata davvero per la prima volta (verde, 10 test). Emulatore Android 14: video in griglia e riprodotti (VideoView nero solo a video finito). **Aggiornamento automatico all'apertura** (`Aggiornamento.cerca(silenzioso = true)` nell'`init` del VM, se `pc` è salvato) + permesso `UPDATE_PACKAGES_WITHOUT_USER_ACTION` (senza, Android chiedeva sempre «Update?»); limite Android 1 aggiornamento silenzioso/30 s per app. Firma comune `Suite Intrattenimento/firma/vektora.keystore` (fuori da git). Telefono vero non provato; DA-FARE punti 3-4 ancora da fare.
- 1.3.0 (2026-11-15, DA-FARE punti 3-4): `files/indice.json` (Media @Serializable, `DataIso`) caricato in `leggi()` se la lista è vuota → niente «Lettura…»; rilettura completa in background (shortcut: niente GENERATION_MODIFIED). Condividi (`ui/Condividi.kt`, ACTION_SEND/SEND_MULTIPLE + clipData) e sfondo: sull'emulatore `ATTACH_DATA` apriva solo Contatti → prima `getCropAndSetWallpaperIntent` (com.android.wallpapercropper), riserva ATTACH_DATA. Provato su AVD: aggiornamento 1.2→1.3 dall'app, sfondo impostato, condivisione 2 file. Insidia prove: dopo il riavvio dell'AVD `appops REQUEST_INSTALL_PACKAGES` torna default → finestra di sistema. Resta solo la prova sul telefono vero (DA-FARE.md).
- 1.4.0 (2026-11-21): utente «nell'app non ci sono i video e non si può fare lo sfondo». Codice permessi giusto (IMAGES+VIDEO+USER_SELECTED); causa probabile: sul telefono c'è ancora la build Windows (DA-FARE punto 1 mai fatto, firma diversa → va disinstallata una volta). Sfondo rifatto: `impostaSfondo` (WallpaperManager.setStream, scelta Home/Blocco/Entrambe, SET_WALLPAPER) + «Ritaglia prima…» (vecchio intent). Build/11 test/lint verdi; build+lint insieme = exit 137 (memoria), lanciarli separati con `--no-daemon`. NON provato su emulatore/telefono.
