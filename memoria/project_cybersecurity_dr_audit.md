---
name: project-cybersecurity-dr-audit
description: dr-audit.py (Python 3, file singolo, ~177 KB) con 13 moduli embedded base64 — audit DR+sicurezza cross-platform, PDF firmato, invio Telegram, auto-eliminazione. Due varianti branded (Vektora, GV).
metadata:
  node_type: memory
  type: project
  originSessionId: 6d1fbc76-e107-48ac-8bed-e78699a623c6
  modified: 2026-08-03T11:50:51.192Z
---

**Percorso:** `C:\Users\pc\Documents\Web Developer\Cybersecurity\scripts\`

**File principali:**
- `dr-audit.py` — file distribuibile (~177 KB, autogenerato da `build.py`, si auto-elimina dopo invio)
- `build.py` — genera dr-audit.py da `modules/*.py` con base64 embedding
- `make_variants.py` — genera le due varianti branded da dr-audit.py (richiede build.py eseguito prima)
- `modules/` — 13 moduli sorgente (dr_core, dr_collectors_*, dr_reporter, dr_signer, dr_delivery)
- `README.md` — documentazione completa (setup Telegram, avvio, variabili opzionali, build)

**Varianti branded (in `Audit Automatico/`):**
- `Vektora Audit (agenzia)/dr-audit-vektora.py` — logo auto `vektora-logo.png`, output `~/vektora-audit-output`, intestazione "Vektora Security Audit"
- `GV Audit (lavoro dipendente)/dr-audit-gv.py` — nessun logo, output `~/gv-audit-output`, intestazione "Security Audit"
- Ogni variante ha il proprio README (README-vektora.md, README-gv.md)

**Struttura output generata automaticamente all'avvio:**
```
BASE_DIR/
├── reports/     ← PDF e Markdown
├── logs/        ← log esecuzioni
├── signatures/  ← file firma (eliminati dopo invio)
└── tmp/         ← temporanei
```
Variabili: `AUDIT_BASE_DIR` (default `~/dr-audit-output`), `AUDIT_CLEAN_DIRS` (false), `AUDIT_LOGO` (path logo PNG/JPG), `AUDIT_TIMEOUT` (300s).

**Funzionamento:** 13 moduli base64-embedded → caricati a runtime via `exec(compile(b64decode(...)))` in `types.ModuleType` → sys.modules. Si avvia solo con privilegi admin (ctypes.windll su Windows, geteuid su Linux/macOS). Legge TELEGRAM_BOT_TOKEN e TELEGRAM_CHAT_ID da env vars (mai hardcoded).

**Bug risolti (storici):**
1. Docker ports duplicati (IPv4+IPv6) → `seen_ports` set in dr_collectors_network
2. PDF data troncata a solo anno → `ts_safe` con fallback datetime.now()
3. Pagine PDF vuote → rimosso `add_page()` esplicito prima sezione autenticità
4. pip cross-platform → `--break-system-packages` solo su Linux/macOS
5. Curly quotes (U+201C/U+201D/U+2018/U+2019) → bulk-replace con ASCII
6. SyntaxWarning `\P` in build.py → path Windows usa `\\\\`
7. PDF illeggibile: testo troncato a metà frase → limite `_s()` alzato a 200000 char (era 4000/12000/1500), `auto_page_break(margin=15)` (era 20), `multi_cell()` ovunque (già fatto)

**Why:** audit ripetibile su server Ubuntu/Coolify e Windows; zero tracce dopo l'esecuzione.
**How to apply:** per modificare → edit modules/*.py → `python build.py` → `python make_variants.py` → distribuire il file appropriato. Non usare curly quotes nei sorgenti modulo (Python 3.14 li rifiuta in exec/compile). Testare rebuild dopo ogni modifica.
