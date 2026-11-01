---
name: project-n8n-templates
description: "Catalogo template n8n Vektora (19 cartelle, n8n 2.10.4) in Prodotti Vektora/vektora-n8n-templates, generati da sorgenti Python e testati in Docker"
metadata:
  node_type: memory
  type: project
  originSessionId: 2cb4f5cc-2229-4955-93d7-7d269fa7110e
  modified: 2026-10-31T21:43:33.183Z
---

Catalogo di workflow n8n da vendere alle PMI, in `Vektora Site/Prodotti Vektora/vektora-n8n-templates/` (repo git locale, nessun remote). Creato il 2026-10-31.

- Fonte di verità: `scripts/sorgenti/t*.py` → `scripts/genera.py` scrive `templates/*/workflow.json`. Poi `scripts/validate.py` (schema nodi da `.cache/nodes.json`) e `scripts/test-import.sh --apply [--solo NN] [--keep]` (n8n 2.10.4 + Mailpit + mock.js; esito in `catalogo/ESITO-TEST.md`, ultimo 130/130).
- Scelte: stato in Data Table `vk_*` per nome, email via SMTP, sotto-workflow `00-invio-messaggio` (email/WhatsApp), link con token del nodo Crypto, AI via API compatibile OpenAI con approvazione Telegram, ID workflow fissi `vk…`.
- Insidie di n8n 2.10: sotto-workflow ed error workflow vanno pubblicati; publish da CLI vale dopo il riavvio; un modulo n8n non può stare con nodi Respond to Webhook; `ignoreBots` e link di approvazione rifiutano curl/script (test con user-agent da browser); Code node senza `crypto`/`URL`, `tls` solo con NODE_FUNCTION_ALLOW_BUILTIN; il runner non riceve NODE_EXTRA_CA_CERTS; apostrofi nei nomi dei nodi rompono `$('...')`; checkbox dei moduli arrivano come stringa JSON; `/rest/data-tables-global` è paginato (`?take=500`).
- Decisioni aperte per l'utente (REPORT.md): prezzi/pacchetti, licenza (bozza), WhatsApp, hosting un'istanza per cliente, webhook in uscita in [[project_vektora_order]], tenere o no il generatore.

**Why:** l'utente ha chiesto commit per template in questo repo (eccezione esplicita a [[feedback_no_commit_git]]).
**How to apply:** per modifiche al catalogo cambiare i sorgenti e rigenerare, mai editare a mano i workflow.json; rilanciare validate + test prima di dire "fatto".
