---
name: project-folder-pull
description: Folder Pull, tool Python per pull/push tra cartelle locali non sincronizzate e una cartella Syncthing con una casella per PC, in Cybersecurity/Script/Folder Pull/
metadata:
  type: project
---

`Cybersecurity/Script/Folder Pull/folder_pull.py` (creato il 2026-10-26, file singolo, solo stdlib + rich facoltativo). L'utente lo vuole come repo separata e **non integrato** in [[project-ayanokoji-system]].

Il modello l'ha scelto l'utente: ogni PC scrive solo in `<sincronizzata>/<nome-PC>/<coppia>/` (push) e fa il pull dalle caselle degli altri PC. Nel pull vince il file più recente per mtime, con backup in `backup/<data-ora>/`. Le cancellazioni non si propagano. Default in simulazione, `--apply` per scrivere. `config.json` è per PC ed è in .gitignore.

**Why:** evitare i conflitti Syncthing quando due PC scrivono lo stesso file.
**How to apply:** test con `python3 -m unittest discover -s tests` (10 test). Se servono altre funzioni (es. propagare le cancellazioni), chiedere prima: sono state escluse di proposito.
