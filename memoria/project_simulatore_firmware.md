---
name: project_simulatore_firmware
description: Simulatore Firmware riutilizzabile (Python) + firmware Flip; entrambi con repo GitHub ntr-scanner
metadata:
  node_type: memory
  type: project
  originSessionId: 69527181-2301-43f2-b87c-53e90a4c2250
  modified: 2026-09-30T12:47:46.609Z
---

Due progetti collegati creati il 2026-09-30, entrambi con repo GitHub privato `ntr-scanner`.

**Flip — firmware Flipper DIY (ESP32-S3)** in `Cybersecurity/Script/Flip/`. Refactor di 9 file grezzi in struttura ESP-IDF (main/, components/core|drivers|apps), driver NFC PN532 su I2C, parser file `.sub` + replay OOK, harness test C (mock+Valgrind) e simulazione Python. Originali in `_original/`. Repo: `github.com/ntr-scanner/Flip`.

**Simulatore Firmware 1.0.0** in `Cybersecurity/Script/Simulatore Firmware/`. Launcher Python riutilizzabile: metti un firmware in `Firmware da Analizzare/`, scegli la console (pc/tablet/mobile/hardware = form-factor dello schermo, non cambia il firmware) e lui sceglie fra emulazione reale (Wokwi/QEMU/Renode se compilato+disponibile) e anteprima logica servita via server locale. Moduli in `core/` (detector, targets, dependencies, viewer, emulator); modelli logici in `models/<nome>/` con `meta.json` (firme per il match), `model.html` (UI), `wokwi/diagram.json` opzionale. Esempio incluso: `models/flipper_diy/`. Repo: `github.com/ntr-scanner/Simulatore-Firmware`.

**Eccezione a [[feedback_no_commit_git]] e SCRIPT.md §8:** in questa sessione l'utente ha chiesto esplicitamente i push (li ho fatti io) e l'auto-installazione dipendenze nel Simulatore (attiva di default, disattivabile con `--no-install`, simulabile con `--dry-run`). L'eccezione vale per questo tool, non è una nuova regola generale.
