---
name: project-galleria
description: Galleria 1.0 (porta 8799) in Intrattenimento/galleria: foto lette dal SERVER (percorso), EXIF in Python, un anno fa, luoghi senza mappa online, duplicati e riordino anno/mese con Annulla
metadata:
  type: project
---
Creata 2026-10-31. Base comune: [[project-intrattenimento-base]].
- Cartella scelta dal PC scrivendo il percorso; `~/.cache/vektora-galleria/` (solo PC) tiene cartella e indice con GPS: mai nella cartella dati sincronizzata (posizioni = dato personale).
- `read_exif` (data, GPS, miniatura IFD1 servita da `/f/mini/`), `date_from_name`, duplicati = stessa dimensione poi SHA-256.
- Riordino: anteprima → registro scritto prima → `os.rename` senza sovrascrivere (`foto (2).jpg`) → Annulla toglie cartelle vuote. `_Duplicati/` esclusa dalla lettura. Spostamenti solo da 127.0.0.1.
- Scelta utente: niente mappa online (zone a 1 decimale + link OSM a richiesta).
- Dalla 1.1 (2026-10-31): `miniature.py` — miniature 320 px con ffmpeg (`-noautorotate` + transpose da EXIF Orientation, indice v2) in `~/.cache/vektora-galleria/mini/`; `/f/mini/` le serve per prime, la pagina aggiunge `?t=1` per non riusare la foto intera in cache. Bottone ⚙ «Scarica ffmpeg»: BtbN latest LGPL + `checksums.sha256`, estrae solo `bin/ffmpeg`, in `~/.local/share/vektora-galleria/strumenti/`. Il download vero NON è stato provato: il classificatore dei permessi ha bloccato scaricare/eseguire codice esterno; provato con archivio finto. Cartella reale dell'utente: `/home/joyboy/Pictures` (440 foto, 418 senza miniatura EXIF).
