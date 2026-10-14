# DATABASE.md — Architettura e Gestione dei Dati

Questo documento definisce le linee guida per la strutturazione, l'archiviazione, la relazione e la gestione dei dati all'interno del progetto, garantendo scalabilità, integrità e performance.

---

## 1. Principi di Modellazione dei Dati
- **Integrità dei Dati:** Ogni entità deve disporre di vincoli di integrità chiari (chiavi primarie, chiavi esterne, vincoli di unicità e controlli sui tipi di dato).
- **Normalizzazione vs Performance:** Strutturare i database relazionali almeno fino alla Terza Forma Normale (3NF), introducendo la denormalizzazione solo in presenza di colli di bottiglia misurati e documentati.
- **Tracciabilità Temporale:** Le tabelle principali devono includere campi di audit standard: `created_at` (timestamp di creazione) e `updated_at` (timestamp dell'ultima modifica).

---

## 2. Struttura e Storage
- **Database Relazionali (SQL):** Utilizzati per dati strutturati con relazioni complesse (es. utenti, permessi, transazioni). Preferire soluzioni come PostgreSQL o SQLite per ambienti leggeri/locali.
- **Database NoSQL / Document-based:** Utilizzati per dati non strutturati, log di sessione o cache ad alto volume (es. MongoDB, Redis), dove la flessibilità dello schema è prioritaria.
- **Migrazioni di Schema:** Qualsiasi modifica alla struttura del database deve essere gestita esclusivamente tramite script di migrazione tracciabili (es. Prisma, Alembic, Knex). È vietato apportare modifiche manuali dirette sul database di produzione.

---

## 3. Relazioni e Vincoli
- **Integrità Referenziale:** L'uso di `ON DELETE CASCADE` o `ON DELETE RESTRICT` deve essere valutato attentamente per prevenire la perdita accidentale di dati correlati.
- **Indicizzazione:** Creare indici mirati (`INDEX`) sulle colonne frequentemente utilizzate nelle clausole `WHERE`, `JOIN` o `ORDER BY` per ottimizzare le query, evitando un'indicizzazione eccessiva che rallenterebbe le operazioni di scrittura.

---

## 4. Gestione e Sicurezza dei Dati
- **Protezione dei Dati Sensibili:** Le informazioni di identificazione personale (PII) e le credenziali devono essere cifrate a riposo (at rest) e in transito (in transit). Le password non devono mai essere salvate in chiaro, ma esclusivamente tramite funzioni di hashing sicure (es. Argon2, bcrypt).
- **Backup e Ripristino:** Definire politiche regolari di backup automatico e test di ripristino per prevenire la perdita di dati critici.