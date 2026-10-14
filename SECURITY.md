# SECURITY.md - Linee Guida di Sicurezza e Protezione

Questo documento definisce i protocolli di sicurezza obbligatori, le policy di accesso e le linee guida di protezione che l'agente (Claude Code / OpenHands) deve esaminare e rispettare **prima di iniziare qualsiasi fase di progettazione, scrittura del codice o esecuzione di comandi**.

---

## 1. Principi Fondamentali di Sicurezza
- **Principio del Minimo Privilegio (PoLP):** All'agente devono essere concessi solo i permessi strettamente necessari per completare il task assegnato. Nessun comando di sistema deve essere eseguito con privilegi elevati (`sudo`) se non espressamente e preventivamente autorizzato dall'utente.
- **Modello Zero Trust:** Nessun input (proveniente da file esterni, API o dall'utente stesso) deve essere considerato sicuro a priori. Ogni dato deve essere validato e sanitizzato.
- **Isolamento dell'Ambiente:** L'esecuzione del codice e dei comandi deve avvenire all'interno dell'area di lavoro designata (`workspace`), evitando modifiche non autorizzate ai file di sistema globali.

---

## 2. Gestione dei Segreti e delle Credenziali
- **Divieto Assoluto di Hardcoding:** È severamente vietato inserire chiavi API, token OAuth, password, stringhe di connessione a database o certificati direttamente nel codice sorgente o nei file di configurazione pubblici.
- **Utilizzo di Variabili d'Ambiente:** Qualsiasi credenziale deve essere gestita esclusivamente tramite variabili d'ambiente (`.env`) o sistemi di gestione dei segreti sicuri (`Settings -> Secrets`).
- **Scansione Pre-Commit:** Prima di finalizzare qualsiasi modifica o generare script di commit, l'agente deve verificare che non siano presenti dati sensibili tracciati o esposti.

---

## 3. Validazione e Sanitizzazione degli Input/Output
- **Prevenzione delle Iniezioni:** Nello sviluppo di query (SQL, NoSQL), comandi di sistema o interazioni con API, l'agente deve utilizzare esclusivamente parametri associati o funzioni sicure per prevenire vulnerabilità di tipo Injection (Command Injection, SQL Injection, XSS).
- **Gestione dei Dati Sensibili nei Log:** I messaggi di log, gli output della console e la cronologia delle chat non devono mai stampare dati personali identificabili (PII) o token di autenticazione in chiaro.

---

## 4. Controllo delle Dipendenze e Supply Chain Security
- **Verifica delle Librerie:** Prima di integrare nuove dipendenze (`npm`, `pip`, ecc.), l'agente deve verificare che provengano da fonti attendibili e che non presentino vulnerabilità note.
- **Script di Post-Installazione:** Gli script di post-installazione dei pacchetti devono essere eseguiti in ambienti controllati e conformi alle policy definite nel file `package.json` (es. tramite array `allowScripts`).

---

## 5. Protocollo Operativo Prima della Progettazione
Prima di procedere con la stesura dell'architettura o del codice, l'agente deve completare la seguente checklist di sicurezza:
1. [ ] Verificare che l'area di lavoro sia pulita e priva di file di configurazione compromessi.
2. [ ] Identificare eventuali vettori di attacco noti legati al task richiesto.
3. [ ] Confermare che l'autenticazione ai modelli LLM avvenga tramite canali cifrati e chiavi valide.
4. [ ] Assicurarsi che i comandi Bash generati non eseguano operazioni distruttive sul file system locale (es. `rm -rf /` o modifiche a directory di sistema).