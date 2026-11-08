---
name: project-attrezzi-file
description: "App Android «Attrezzi File» (nome provvisorio) in `Progetti/Attrezzi File/`, solo piano.md dal 2026-11-08; primo strumento Svuota Cartella sul telefono, prima si prova Termux"
metadata:
  node_type: memory
  type: project
  originSessionId: 9c53e1e2-bef3-43d4-94c2-b22c7081d287
  modified: 2026-11-08T09:33:31.546Z
---

`~/Vektora/Progetti/Attrezzi File/piano.md` (2026-11-08): app Android che lavora sui file direttamente sul telefono, senza PC. Primo strumento: porting di Svuota Cartella 1.1.0 (`Cybersecurity/Script/Svuota Cartella/`), con `.svuota_cartella.json` compatibile con lo script. Base: scheletro copiato da [[project-apk-android]] (Apk-Telefono) senza la parte di rete; `MANAGE_EXTERNAL_STORAGE`, servizio in primo piano `dataSync`.

**Why:** l'utente voleva svuotare cartelle senza tenere il telefono collegato via USB (MTP lento). Gli è stato proposto prima Termux con lo script Python (zero codice); l'APK solo se Termux non basta.
**How to apply:** nessun codice finché l'utente non conferma dopo la prova Termux (fase 0 del piano). Decisioni aperte nel piano §10: nome/package, strumenti oltre Svuota, blocco o avviso per DCIM/Download, icona. Prima di scrivere codice rileggere `Claude/Apk-&-Apps.md`.
