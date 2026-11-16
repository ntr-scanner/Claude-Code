---
name: feedback-app-aggiornamenti
description: Le app Android dell'utente devono aggiornarsi da sole (controllo all'apertura) sopra la vecchia, mai disinstallare, mai restare su codice vecchio
metadata:
  type: feedback
---

L'utente vuole che ogni app (Galleria, Musicoteca, Cineteca TV) controlli da sola gli aggiornamenti e li installi sopra, senza disinstallare, e che non resti a girare sul codice vecchio (WebView compresa).

**Why:** chiesto il 2026-11-15 dopo aver dovuto disinstallare/reinstallare; causa: chiavi debug diverse tra PC e aggiornamento solo a mano.
**How to apply:** firma sempre con `Suite Intrattenimento/firma/vektora.keystore`, `UPDATE_PACKAGES_WITHOUT_USER_ACTION` nel manifest, controllo all'apertura; regole in `Claude/Apk-&-Apps.md` §8. Vedi [[project-galleria-android]], [[project-musicoteca-android]], [[project-cineteca]].
