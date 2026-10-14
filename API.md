# API.md — Protocolli di Comunicazione e Integrazione

Questo documento definisce le specifiche, i contratti e le modalità di comunicazione tra il frontend, il backend e i servizi esterni (come i provider LLM e le API di terze parti).

---

## 1. Architettura e Standard di Comunicazione
- **RESTful API:** Le comunicazioni HTTP tra frontend e backend devono seguire i principi architetturali REST, utilizzando i metodi standard:
  - `GET`: Recupero di risorse.
  - `POST`: Creazione di nuove risorse.
  - `PUT / PATCH`: Aggiornamento totale o parziale di risorse.
  - `DELETE`: Eliminazione di risorse.
- **Comunicazione in Tempo Reale (WebSockets):** Utilizzata per flussi di dati continui, log in tempo reale o interazioni di chat con l'agente (es. `/sockets/session/...`).

---

## 2. Formato dei Dati e Payload
- **Standard JSON:** Tutti i payload di richiesta e risposta devono essere formattati in JSON rigoroso, con chiavi scritte in `camelCase` o `snake_case` in modo coerente all'interno dello stesso modulo.
- **Struttura Standard delle Risposte:**
  - **Successo:** Restituire codici di stato HTTP appropriati (`200 OK`, `201 Created`) accompagnati dai dati richiesti.
  - **Errore:** Fornire risposte di errore strutturate e consistenti, contenenti un codice identificativo, un messaggio descrittivo per il debugging e il timestamp dell'evento.

---

## 3. Autenticazione e Sicurezza delle API
- **Token-Based Authentication:** L'accesso alle rotte protette deve avvenire tramite token di autenticazione (es. JWT o chiavi API) passati nell'header HTTP di autorizzazione (`Authorization: Bearer <token>`).
- **Validazione dei Parametri:** Ogni endpoint deve validare rigorosamente i dati in ingresso (tramite librerie come Zod, Joi o Pydantic) per prevenire attacchi di tipo Injection o corruzione dello stato.
- **Rate Limiting:** Implementare limiti di frequenza sulle richieste per proteggere il backend da attacchi DoS o utilizzi abusivi delle risorse.

---

## 4. Integrazione con Servizi Esterni (LLM / API Terze)
- **Astrazione dei Client:** Le chiamate verso servizi esterni (es. Anthropic, OpenAI, NVIDIA NIM) devono essere racchiuse all'interno di moduli di servizio dedicati per isolare la logica di business dai dettagli di rete.
- **Gestione dei Timeout e Fallback:** Configurare timeout espliciti per tutte le chiamate di rete esterne e prevedere meccanismi di gestione degli errori di connessione (es. retry esponenziali o messaggi di errore chiari per l'utente).