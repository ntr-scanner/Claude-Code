---
name: project-katharsis
description: "Katharsis = fork rinominato di Tron (vocatus, MIT) in Cybersecurity/Script/Katharsis; Fasi 0-3 + confronto Tron 2026-10-04 fatti; manca un test VM completo; impronta manifest 401ce396035e50a3"
metadata:
  node_type: memory
  type: project
  originSessionId: b9981542-5590-4ac4-a0e4-5a7a1b3e253c
  modified: 2026-10-04T12:00:00.000Z
---

Katharsis è il fork di Tron v12.0.6 (orchestratore Batch di vocatus/r/TronScript, MIT) in `Cybersecurity/Script/Katharsis/` (script in `katharsis/katharsis.bat`). Riferimento originale: `Katharsis/Tron v12.0.6 (2023-10-17).exe` (7z SFX, `7z x` per estrarlo). La copia estratta `Cybersecurity/Script/Tron/` è stata ELIMINATA il 2026-10-04 su richiesta dell'utente, dopo il confronto.

Piano e modifiche: `ANALISI_KATHARSIS.md`, `FASE0..3_MODIFICHE.md` (tutte applicate il 2026-10-01: sicurezza S1-S7, WMIC -> `resources/functions/katharsis_sys.ps1`, log JSONL, Defender primo motore, TDSSKiller/MBAM rimossi, manifest, triage PowerShell + YARA-Forge, report HTML, regole firmate, rilevamento ransomware -> modalità IR). Confronto con Tron del 2026-10-04 in `Katharsis/CONFRONTO_TRON.md`: corretti update check verso il server di Tron (ora `UPDATE_URL` in katharsis_settings.bat, vuoto = spento; si può cambiare KATHARSIS_VERSION), downgrade di 7-Zip nello stage 5 (azione `version-older`), Windows Update online che non faceva nulla (azione `windows-update` via COM WUA), chiave SafeBoot\\MSIServer creata fuori dalla Safe Mode.

Ogni modifica al pacchetto richiede di ricostruire `MANIFEST.sha256`. Da Linux: script Python che replica `katharsis_manifest.ps1 -Build` (percorsi con `\`, CRLF, UTF-8 senza BOM). Impronta attuale `401ce396035e50a3` (2026-10-04), scritta anche in `vm_test/expected_fp.txt`. I file del pacchetto sono CRLF: modificarli preservando CRLF.

Test VM: ora su Linux con VirtualBox, VM "Windows " (Win10, Guest Additions). Snapshot "pulito-pre-katharsis" creato il 2026-10-04; cartelle condivise transient `katharsis_pkg` (sola lettura) e `katharsis_vmtest` -> `\\VBOXSVR\...`. Il runner `vm_test/katharsis_vm_runner.bat` riconosce VirtualBox e VMware e ha gli scenari sintassi (parser PS 5.1), stage5, dryrun, ir, ransomware, reset, full. Non ci sono credenziali del guest: il runner lo lancia l'utente, copiato sul Desktop, come amministratore. Test precedenti (VMware, 2026-10-01): prima Defender della VM bloccava la lettura di un file del pacchetto, poi con AV spento tutti fermi al gate per impronta vecchia (il gate funziona). Nessuno scenario reale è ancora stato eseguito fino in fondo.

Aperti (decide l'utente): download di binari aggiornati (Stinger 2023, AdwCleaner/KVRT 2023, Sophos 2021, 7-Zip 23.01); liste debloat ancora da GitHub bmrf/tron (protette da hash pinnati); MalwareBazaar non scaricato (decisione utente). Una run reale di Tron del 2024-03-23 su LAPTOP-FR25O2FD ha probabilmente lasciato un backup del registro esposto in C:\logs\tron. Insidia PowerShell ricorrente: nomi di variabile case-insensitive ($sev nasconde $Sev).

**Why:** l'utente vuole decidere lui le tecniche e i download; il pacchetto gira come amministratore sui PC dei clienti.
**How to apply:** nuove funzionalità o download solo dopo conferma esplicita; dopo ogni modifica ricostruire il manifest e aggiornare expected_fp.txt; testare in VM su snapshot e poi ripristinarlo. Collegamento possibile con [[project-ransomware-identifier]].
