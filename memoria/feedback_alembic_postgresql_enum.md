---
name: feedback-alembic-postgresql-enum
description: Come creare ENUM PostgreSQL in Alembic async (asyncpg) senza DuplicateObjectError
metadata: 
  node_type: memory
  type: feedback
  originSessionId: db0f1d06-1993-4431-9d85-71c7055bb523
---

Nelle migration Alembic con asyncpg, la creazione di ENUM PostgreSQL richiede due accorgimenti specifici:

**1. Usare `postgresql.ENUM(..., create_type=False)` nelle colonne di `op.create_table`**

`sa.Enum(..., create_type=False)` NON propaga `create_type=False` all'oggetto `postgresql.ENUM` interno — l'evento `_on_table_create` viene comunque triggerato e ricrea il tipo causando `DuplicateObjectError`.

Forma corretta:
```python
from sqlalchemy.dialects import postgresql

sa.Column("col", postgresql.ENUM("val1", "val2", name="my_enum", create_type=False), ...)
```

**2. Creare il tipo ENUM con SELECT su `pg_type` (no DO block)**

I DO block con `EXCEPTION WHEN duplicate_object` non funzionano con asyncpg perché PostgreSQL trasmette l'errore sul wire protocol anche quando è catturato da PL/pgSQL, contaminando la transazione.

Forma corretta:
```python
def _crea_enum(name: str, *values: str) -> None:
    exists = op.get_bind().execute(
        sa.text("SELECT 1 FROM pg_type WHERE typname = :name"),
        {"name": name},
    ).scalar()
    if not exists:
        vals = ", ".join(f"'{v}'" for v in values)
        op.execute(sa.text(f"CREATE TYPE {name} AS ENUM ({vals})"))
```

**Why:** asyncpg gestisce le eccezioni PostgreSQL in modo diverso da psycopg2 — anche le eccezioni catturate da PL/pgSQL inquinano lo stato della connessione.

**How to apply:** Ogni volta che si aggiungono ENUM in una migration Alembic con asyncpg (progetto ATM e qualsiasi altro progetto FastAPI+asyncpg).

---

**3. `.env` con bcrypt hash — singole virgolette obbligatorie**

Docker Compose (godotenv) espande i `$` nei valori dell'`.env`. Un hash bcrypt contiene `$2b$12$...` che viene troncato.

Fix: avvolgere il valore tra singole virgolette:
```
ATM_PASSWORD_HASH='$2b$12$xxxxx...'
```

**Why:** godotenv interpreta `$VAR` come variabile anche nell'env file. Le singole virgolette disabilitano l'espansione.
