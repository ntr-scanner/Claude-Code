# CODE_STYLE.md — Linee Guida per lo Stile del Codice

Questo documento stabilisce gli standard di scrittura, formattazione e architettura del codice che devono essere rigorosamente seguiti durante lo sviluppo, la generazione e la revisione del codice all'interno del progetto.

---

## 1. Principi Generali di Clean Code
- **Leggibilità Prima di Tutto:** Il codice è fatto per essere letto dagli esseri umani prima che dalle macchine. Dai priorità a nomi chiari e descrittivi rispetto alla brevità eccessiva.
- **Principio DRY (Don't Repeat Yourself):** Evita la duplicazione del codice. Estrai la logica comune in funzioni, moduli o classi riutilizzabili.
- **Principio KISS (Keep It Simple, Stupid):** Mantieni la logica il più semplice possibile. Soluzioni complesse non necessarie aumentano i costi di manutenzione e i bug.
- **Single Responsibility Principle (SRP):** Ogni funzione, modulo o classe deve avere una sola, ben definita responsabilità.

---

## 2. Standard di Formattazione e Naming Conventions
- **Indentazione e Spaziatura:** 
  - Utilizza **2 o 4 spazi** per l'indentazione (coerente con il linguaggio e le configurazioni esistenti del progetto, es. `.prettierrc` o `editorconfig`).
  - Evita assolutamente l'uso misto di tabulazioni e spazi.
- **Convenzioni per i Nomi:**
  - **Variabili e Funzioni:** `camelCase` (es. `userData`, `fetchActiveUsers`) in linguaggi come JavaScript/TypeScript, oppure `snake_case` (es. `user_data`, `fetch_active_users`) in Python.
  - **Classi e Componenti:** `PascalCase` (es. `UserProfile`, `AuthenticationService`).
  - **Costanti:** `UPPER_SNAKE_CASE` (es. `MAX_RETRIES`, `API_TIMEOUT`).
  - **Nomi Significativi:** Usa nomi basati sul dominio di business (es. `expireDate` invece di `d`).

---

## 3. Gestione degli Errori e Resilienza
- **Errori Espliciti:** Non catturare eccezioni in modo generico (`catch (e) {}` o `except:`) nascondendo i problemi. Gestisci errori specifici o rilanciali arricchiti di contesto.
- **Validazione Preventiva:** Valida sempre gli argomenti delle funzioni, i dati in ingresso dalle API e le variabili d'ambiente all'inizio dell'esecuzione (Fail Fast).
- **Logging Consistente:** Inserisci log significativi nei punti critici dell'applicazione (es. avvio, errori, transazioni importanti) evitando di stampare dati sensibili o token.

---

## 4. Documentazione e Commenti
- **Codice Auto-esplicativo:** Il codice dovrebbe spiegare *cosa* fa grazie a nomi eccellenti. I commenti devono spiegare il *perché* di scelte architetturali complesse o workaround necessari.
- **JSDoc / Docstring:** Ogni funzione pubblica, modulo o classe principale deve includere una breve documentazione che descriva parametri, valori di ritorno ed eventuali eccezioni sollevate.

---

## 5. Controllo di Qualità e Testing
- **Test Unitari:** Scrivi test puliti e isolati per ogni nuova funzionalità o correzione di bug critica.
- **Pulizia del Codice Morto:** Rimuovi sempre variabili non utilizzate, codice commentato ("morto") e importazioni non necessarie prima di finalizzare le modifiche.