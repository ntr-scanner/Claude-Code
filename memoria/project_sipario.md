---
name: project-sipario
description: "Sipario (2026-11-02) = progetto unico in Intrattenimento/Sipario: copia di Scaffale + 6 app Suite + Media Loader, dashboard 8780, repo GitHub privato da creare"
metadata:
  node_type: memory
  type: project
  originSessionId: 47865a5a-cfd3-4dd8-8593-19eb7646a85b
  modified: 2026-11-02T21:43:50.537Z
---

Creato il 2026-11-02 in `Cybersecurity/Script/Intrattenimento/Sipario/` come **copia** (originali intatti) di [[project-scaffale-mangawa]], della Suite ([[project-intrattenimento-base]]) e di [[project-media-loader-v3]]. Copiati solo i file tracciati e quelli non ignorati (`git ls-files -co --exclude-standard`), niente dati/.git/.venv.

- Struttura: `<app>/codice` + `<app>/dati` (fuori dal repo), `.gitignore` alla radice, una sola `.venv` alla radice con `requirements.txt` unione, `avvia.sh`/`avvia.bat` → `dashboard/codice/server.py`.
- Dashboard 1.0.0 su 8780: registro `APPS` in server.py, accende le app staccate (`start_new_session`) con `sys.executable`, log in `dashboard/dati/log/<app>.log`. Lo stato guarda solo se la porta è aperta (shortcut). Media Loader parte con `--no-finestra --porta 8805` (8800 è di Biblioteca). Scaffale senza tty salta la domanda sul telefono.
- Scelte dell'utente: repo GitHub **privato** (nome Sipario scelto da Claude), solo codice; porno+hentai restano insieme in Videoteca; nuove librerie da fare: **Film & Serie TV** e **Anime** (stile Scaffale, da Videoteca), più Scarica dentro le librerie con i motori di Media Loader (una sola copia dei motori).
- Insidie: originali e copia usano le stesse porte (la dashboard apre quello acceso) e condividono `~/.medialoader/`. Playwright MCP occupato → screenshot con Brave headless in `~/rprova/`.
- Non ancora: git init/push (lo chiede l'utente), fasi 3-4, test delle app copiate, Windows.

**Why:** l'utente vuole un posto unico per tutto l'intrattenimento, con dashboard d'ingresso.
**How to apply:** le modifiche alle app di Sipario NON si riportano negli originali (e viceversa) senza richiesta; aggiungere ogni app nuova al registro `APPS` e al README.
