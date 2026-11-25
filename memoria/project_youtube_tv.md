---
name: project-youtube-tv
description: "APK Fire TV/Android TV in Progetti/Lumen — WebView su youtube.com/tv + script TizenTube (GPL) per togliere le pubblicità; l'utente non vuole SmartTube"
metadata:
  node_type: memory
  type: project
  originSessionId: 1dc452ba-de4f-40f6-8a48-1ed93fc3db05
  modified: 2026-11-23T22:17:34.554Z
---

App «Lumen» (nome scelto dall'utente il 2026-11-23; pacchetto invariato). Creata il 2026-11-23 in `~/Vektora/Progetti/Lumen/` (package `com.vektora.youtubetv`). L'utente ha una Fire Stick con Fire OS e ha rifiutato SmartTube. Ha chiesto un APK nostro «più consistente» di uno script fatto in casa, preso da repo GitHub: scelto TizenTube (reisxd), il cui `userScript.js` (npm `@foxreis/tizentube`) toglie le pubblicità agganciando `JSON.parse`.

Insidie scoperte: il «video format not supported» con lo UA Cobalt era colpa di AV1 (la WebView lo dichiara, la Fire Stick non ha il decoder hardware). Dalla 1.2.0 (2026-11-24) AV1 è nascosto via MediaSource.isTypeSupported e si usa lo UA dell'app ufficiale Fire TV, quindi stesso design. Con quello UA la CSP di YouTube blocca sponsor.ajay.app, perciò le richieste passano da un JavascriptInterface (`Ponte`). Densità 2 = pagina 960x540, quindi 480p e immagini sfocate: si risolve con `setInitialScale(100)`. La Fire Stick dell'utente (AFTSS, Fire OS 7.7.1.7, IP 192.168.43.114) è su un hotspot del telefono (rete a consumo), che limita la qualità anche nell'app ufficiale. Sulla Fire TV la console della pagina non arriva in logcat: per il debug si usa `setWebContentsDebuggingEnabled` temporaneo + `adb forward localabstract:webview_devtools_remote_<pid>` + Node con WebSocket. Lo script a inizio documento si ferma su `observe(document.body)`, quindi parte a DOMContentLoaded. YouTube consuma sempre Esc, quindi per uscire si tiene premuto Indietro.

Dalla 1.1.0 (2026-11-23), su richiesta: lo script TizenTube si aggiorna da solo da jsDelivr all'apertura (`Script.kt`). L'APK si aggiorna dal PC con `aggiorna.py` (copia della Galleria, porta 8807), che la TV trova in broadcast UDP (`Aggiornamento.kt`, copia di Theca TV). Aggiunto anche `fetch().json()` passato per `JSON.parse`. L'utente ha detto che l'app resta per uso personale (licenza GPL e Termini di servizio di YouTube accettati).

**Why:** l'utente vuole niente pubblicità e app che si aggiornano da sole ([[feedback-app-aggiornamenti]]).
**How to apply:** prove sull'emulatore con `adb reverse tcp:8807 tcp:8807` (il broadcast non esce dall'emulatore). Restano da verificare la sparizione di una pubblicità vera (l'emulatore non ne riceve) e la prova su Fire Stick reale. Se tornano le pubblicità e lo script nuovo non basta, guardare se YouTube ha spostato i dati delle pubblicità fuori da `JSON.parse`.

**Prossimo passo (deciso 2026-11-24, da fare il giorno dopo):** l'utente vuole alleggerire la Fire Stick e cambiarne la home (sfondo ecc.). Scelto di partire da FireFrame (github.com/dyascj/FireFrame: launcher + debloat via ADB, senza root, testato su Fire OS 7). CleanYourTV su Fire OS fa solo debloat. LineageOS per sheldonp: rischio brick e sblocco forse chiuso su 7.7.1.7, quindi non verificato. Primo controllo: `adb shell getprop ro.product.model`.
