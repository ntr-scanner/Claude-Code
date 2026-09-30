---
name: project-bounty-session-assistant
description: "Bounty Session Assistant — assistente metodologia IDOR/business logic ispirato a PentestGPT legacy, mai esecutivo; in Cybersecurity/Script/"
metadata:
  node_type: memory
  type: project
  originSessionId: 330745bc-6ac2-461a-a5bc-5ac6a8930bd6
  modified: 2026-09-24T14:44:24.946Z
---

`Cybersecurity/Script/Bounty Session Assistant/` (package `bounty_assistant`, Python stdlib + `anthropic` opzionale, SQLite). Ispirato al legacy di PentestGPT (clonato in `Script/PentestGPT`), ma solo consulenza: propone, l'utente esegue a mano.

Vincoli decisi dall'utente (non negoziabili): nessun codice di rete/exec verso target (test AST in `tests/test_structure.py`); target fuori scope = blocco netto senza alcuna opzione di conferma, con messaggio che cita la regola dello Scope Store, l'unica via è `scope edit`; export markdown leggibile a fine sessione; log persistente delle sessioni per tracking metodologia (estendibile al bug bounty).

Ha una shell interattiva (`python -m bounty_assistant` senza args, `shell.py`) con chat libera, `next/more/todo/discuss/brainstorm` come il legacy; le risposte chat passano dal Gate come le proposte. Venv in `.venv/`, test con `python -m unittest discover -s tests -t .`.

**Why:** l'utente sta costruendo competenza IDOR/business logic su HackerOne e vuole strutturare il ragionamento, non delegarlo.
**How to apply:** ogni estensione deve mantenere questi invarianti; non aggiungere HTTP client, loop autonomi o override dello scope. Vedi [[project-cybersecurity-dr-audit]] per lo stile dei tool in quella cartella.
