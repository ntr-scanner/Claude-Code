---
name: project-galleria-android
description: APK Galleria senza server in Suite Intrattenimento/galleria-android: tutto il telefono da MediaStore, minSdk 30, cestino/riordino con richieste di sistema; verificato su emulatore 2026-11-08
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

**Why:** l'utente vuole un'app galleria vera sul telefono, non un client del PC.
**How to apply:** prima di modifiche rileggere `Claude/Apk-&-Apps.md`; `./gradlew assembleDebug test lint`; non provati: telefono vero, migliaia di foto, SD, accesso parziale. Codice non committato.
