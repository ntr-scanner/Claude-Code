---
name: project-password-import-converter
description: "Tool Python per convertire un file .txt di password in chiaro in CSV import Bitwarden/Vaultwarden, con rilevamento duplicati opzionale"
metadata:
  node_type: memory
  type: project
  originSessionId: 1e5a1bb4-73f4-4fe4-ad78-7beff22778b5
  modified: 2026-09-23T11:45:52.227Z
---

Script in `Cybersecurity/Script/Password Import Converter/` (già repository git con remote `origin/main` configurato prima ancora che iniziassi a lavorarci — commit iniziale "Appena scritto, nessun tes[t]"). Ambiente: `.venv/` dedicato nel progetto (coerente con [[project_compliance_tracker]] e [[project_ransomware_identifier]]).

Cosa fa: `convert_passwords.py` legge un file `.txt` di password personale (formato non standard) e genera un CSV pronto per l'import Bitwarden. Il confronto con un export esistente del vault (`--vault-export`) è **opzionale** — funziona benissimo anche in conversione locale pura, senza duplicate detection.

Formato reale dell'utente: **modalità `block`** (default in config.yaml) — voci multi-riga separate da righe vuote: 1ª riga nome sito, ultima riga password, 1-2 righe centrali per email/username. Quando ci sono sia email che username, `parsing.block.identifier_priority` (default `username`) decide quale diventa il login effettivo; l'altro finisce nelle note, mai perso. Dominio dedotto dal nome tramite `parsing.known_domains` in config.yaml (mappa estendibile, es. "youtube" → "youtube.com").

**Why:** Il primo test reale dell'utente con la modalità `delimiter` di default ha prodotto 0 voci convertite e 318 righe non parsate, perché il suo file è a blocchi multi-riga (nome/email/[username]/password separati da righe vuote), non a righe singole delimitate. Ho aggiunto la modalità `block` proprio per questo formato.

**How to apply:** Se l'utente chiede modifiche a questo script, ricordare: (1) mai stampare o loggare password in chiaro fuori dal CSV finale — anche `--dry-run` maschera le password; (2) `--force` richiesto per sovrascrivere output/log esistenti; (3) `trim_password` in config.yaml controlla se la password viene ripulita degli spazi attorno al delimitatore (default true, utile per formati con spaziatura tipo "Sito | utente | password"); (4) [[feedback_no_commit_git]] — non proporre commit, l'utente li fa da solo.

**Aggiornamento 2026-09-29:** aggiunti `core/field_detector.py` (rilevamento email/username/password per contenuto in modalità block, confidenza certa/alta/media/da_verificare, soglie in `detection:` di config.yaml), `core/secure_io.py` (output 0600/icacls + scrittura atomica), `--layout revisione|bitwarden`, `--per-file`, log file ignorati. `ParsedEntry` ora ha `email`, `login_name`, `confidence`. Bug corretti: BOM nel nome sito, UTF-16, password che inizia con `#` scartata come commento in block, file binari letti come testo, crash se cartella output inesistente. Test: `tests/test_detection.py` (dati fittizi in tempdir). Il formato reale dei file dell'utente non è stato riesaminato in quella sessione (nessuna cartella indicata): assunto il block già documentato.

**Aggiornamento 2026-10-01 (v2.0.0):** nuovi input `.json` (export Bitwarden non cifrato o lista generica; `passwordHistory`/`fields` ignorati di proposito), `.docx` e `.xlsx` (sola stdlib, zip+XML, limiti anti zip-bomb) in `core/document_parsers.py`, `.pdf` via `pypdf[crypto]` opzionale (AES richiede `cryptography`). Logica tabelle comune in `format_parsers.parse_tables`. Aggiunti `--recursive` (salta cartelle nascoste, output `--per-file`, `*_convertito.*`, `--vault-export`), wizard senza argomenti, `--yes`, `--non-interactive`, `--version`, exit 130. Rilevamento TTY reale su Windows (`NUL` risulta `isatty()` → controllo `GetConsoleMode`). Senza TTY i conflitti `ask` → exit 2 (le risposte via pipe non valgono più). Bug trovati in test su venv pulito: spazi doppi compressi nelle celle Word (password alterata), output `--per-file` riletti in ricorsione. Test: 57 (`tests/test_documents.py` genera docx/xlsx/pdf con stdlib).
