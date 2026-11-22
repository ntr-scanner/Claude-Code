---
name: project-converti-ts
description: Converti TS — .ts → .mp4 senza ricodifica, tool da terminale + copia identica in Cineteca, Theca, Videoteca
metadata:
  type: project
---

Creato il 2026-11-22 in `Cybersecurity/Script/Converti TS/` (`converti_ts.py` + `test_converti_ts.py`, 8 test con video ffmpeg). Da terminale: anteprima di default, `--apply`, `--originale cestino|tieni`. Funzioni `converti(src, on_progress, stop)`, `nel_cestino`, `e_ts`, `trova`: le usano le app ([[project-cineteca]], [[project-videoteca]]); il file è identico nelle tre (`sha256sum */codice/converti_ts.py`). Il vecchio `Converitore mkv/converter.py` (HEVC, batch, di un'altra AI) non è stato toccato.
Shortcut noto: video MPEG-2 viene copiato lo stesso (MP4 che il browser non legge).
