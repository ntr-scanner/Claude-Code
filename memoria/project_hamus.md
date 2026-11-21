---
name: project-hamus
description: "Hamus — servizio locale identità fittizie + ricezione email/SMS (FastAPI+SQLite), in ~/Vektora/Hamus/codice (repo git); stato dopo la correzione bug del 2026-11-21"
metadata:
  node_type: memory
  type: project
  originSessionId: 2781f7a8-de5e-445a-adad-ab679aa3d2e2
  modified: 2026-11-21T09:06:34.729Z
---

Hamus: FastAPI + SQLAlchemy async + SQLite, UI SPA vanilla in `server/ui/` (index.html + app.js), porta 8765, SMTP local-sink 2525. Codice in `~/Vektora/Hamus/codice/` (repo git, l'utente committa da sé). `.venv` creato con Python 3.14, test con `.venv/bin/python -m pytest -p no:cacheprovider`.

Il 2026-11-21 sistemati circa 25 bug (94 test verdi, flusso UI provato in Brave headless). Insidie emerse:
- La CSP `script-src 'self'` blocca script e `onclick` inline: il JS sta in `server/ui/app.js`, mai rimetterlo inline.
- Niente `signal.signal()` a livello di modulo in main.py: sostituiva il gestore di uvicorn e SIGTERM non spegneva il server.
- SQLite perde il fuso: le colonne data usano `UTCDateTime` (models.py); i PRAGMA (WAL) vanno dati nell'evento `connect`, non nell'URL.
- If-Match è facoltativo (la UI non manda ETag); `/api/settings` nasconde hash e accetta solo chiavi in `EDITABLE_SETTINGS`.
- I router che leggono il DB devono usare `Depends(get_settings)`, sennò i test scrivono in `./data/hamus.db` (tasks.py lo fa ancora).

Sempre il 2026-11-21: sessione verificata con SHA-256 (prima scrypt da ~90 ms a ogni richiesta), Docker funzionante (`HAMUS_HOST=0.0.0.0` solo nel container, porte 8765/2525 pubblicate su 127.0.0.1, servizi local-sink e haraka tolti dal compose), backup via modulo sqlite3 di Python (il DB è in WAL, niente `cp`; il comando sqlite3 non è installato), cookies*.txt tolti da git. L'utente vuole Hamus 24/7 in Docker più avanti. In Docker gli endpoint admin danno 403 (IP del bridge, non localhost): Riavvia/Spegni si fanno con docker.

Versione 0.2.0 (2026-11-21, su richiesta dell'utente): pulizia automatica `retention_days` (default 7, Impostazioni → Server, `purge_old` in services/identity.py), migrazioni Alembic all'avvio in `init_db` (DB nuovo: create_all + stamp head; senza alembic_version: stamp 7a629822e944 + upgrade), sessioni multiple (setting `sessions` {sha256: ts}, max 20), identità eliminate (status deleted) non ricevono più — le scadute sì (interpretazione di «solo se selezionata come deve»), `webhook_port` tolta, porte con 20 tentativi e `--porta N`, sottopagina «Server → Accesso remoto» (off/tailscale/proxy/https, `public_url` ammesso in Host/Origin via `set_public_url`, https diretto = uvicorn con cert e 0.0.0.0). Admin solo dal PC: `_is_localhost` rifiuta X-Forwarded-For e Host non loopback (Tailscale serve arriva da 127.0.0.1). README riscritto con comandi e changelog. Insidia: httpx non rimanda il cookie `Secure` su http (Brave sì) — nei test a mano in production passare il cookie nell'header.

**Why:** progetto nuovo per la memoria, con insidie non ovvie dal codice.
**How to apply:** prima di toccare Hamus rileggi le insidie; per verificare la UI usa Playwright Python con `/snap/bin/brave` (il browser MCP può essere occupato). Vedi [[feedback-no-commit-git]].
