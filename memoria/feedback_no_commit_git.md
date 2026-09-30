---
name: feedback-no-commit-git
description: "L'utente gestisce i commit git manualmente, non proporre né chiedere di fare commit"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 1e5a1bb4-73f4-4fe4-ad78-7beff22778b5
  modified: 2026-09-23T11:45:39.539Z
---

Non offrire né chiedere di eseguire commit git dopo aver modificato file in un repository — l'utente fa sempre i commit manualmente per conto proprio.

**Why:** L'utente ha esplicitamente detto "non serve che mi chieda di fare i commit verso git, poiché li faccio io manualmente" dopo che avevo chiesto conferma per committare le modifiche a [[project_password_import_converter]] (Cybersecurity/Script/Password Import Converter).

**How to apply:** Dopo modifiche a file in una cartella che risulta essere un repository git, non chiedere "vuoi che faccia il commit?" né eseguire commit di propria iniziativa. È comunque ok segnalare passivamente cosa è stato modificato/non committato se rilevante, ma senza offrire l'azione di commit. Resta valido chiedere conferma per altre azioni git rischiose (push, force, reset) se mai richieste, ma l'iniziativa di commit non va mai presa né proposta.

**Eccezione (2026-09-30):** per il repo di backup `Web Developer/Claude/` (remote `https://github.com/ntr-scanner/Claude-Code.git`, privato) l'utente ha chiesto esplicitamente di fare commit e push ogni volta che c'è una modifica in `Claude/`. Lì li faccio io senza chiedere. Vedi [[claude-folder-unica-fonte]].
