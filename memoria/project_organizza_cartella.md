---
name: project-organizza-cartella
description: "Script Organizza Cartella, sposta file di primo livello in sottocartelle per tipo, in Cybersecurity/Script/Organizza Cartella/"
metadata:
  node_type: memory
  type: project
  originSessionId: 53a730b7-dd95-4bcc-9c15-65b6d10325bf
  modified: 2026-11-02T21:08:50.865Z
---

Creato il 2026-11-02 in `Cybersecurity/Script/Organizza Cartella/` (`organizza_cartella.py`, test, README), stesso stile di Svuota Cartella. Solo stdlib (+`rich` opzionale).

Comportamento: file di primo livello → Immagini/Video/Audio/Documenti/Archivi/Codice/Programmi/Altro per estensione (dizionario `CATEGORIE`). Sottocartelle e nascosti non toccati. Mai sovrascrive (`nome (1).ext`). Default anteprima, `--apply` sposta con [s/N]. Cartelle protette come Svuota (radice, home, sistema).

Dalla 1.1 (2026-11-02, su richiesta: «come l'Organizza cartella della Ruota 3.21»): tag `genre` via ffprobe per Video/Audio → `<Cat>/<Genere>/`, registro `.organizza-registro.json` nella cartella scritto prima di spostare, `--annulla`.

Lasciato fuori: ricorsione nelle sottocartelle, EXIF/data per le immagini. Non è un repo git.

Collegato a [[project-svuota-cartella]], [[project-ruota]].
