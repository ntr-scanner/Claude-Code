# SCRIPT.md — Standard per scrivere script

Leggi questo file **prima di scrivere qualsiasi script** (Python, Bash, PowerShell). Vale per gli script **nuovi**: Media Loader e gli altri tool esistenti restano come sono, non vanno adattati retroattivamente.

Origine: dedotto dalla scansione di `Cybersecurity/` (198 script: Media Loader, Sentinel, IR Wizard, Scan Orchestrator, Quick Triage, dr-audit, hardening, antihammer, Passive Audit, ecc.), da `SyncThings/Programming/CLAUDE-programmazione.md` e dalle risposte dell'utente del 2026-09-30.

## 0. Cosa è dedotto e cosa è proposto (rivedere per primi in caso di divergenza)

| Sezione | Stato |
|---|---|
| 2 Struttura, 3 Interattività, 5 Conferme, 9 Sicurezza, 10 Naming | **Dedotto** dagli script esistenti |
| 4 Modalità automatica | **Parzialmente proposto**: `--yes` esiste solo nel Ransomware Simulator, `--dry-run` è diffuso, `isatty()` è usato in 7 file. `--non-interactive` e la regola "senza TTY = non interattivo" sono **decisione dell'utente**, non prassi esistente |
| 5 Default fail-safe | **Regola dell'utente, non negoziabile**. Sentinel, `pulizia_disco.py` e IR Wizard oggi fanno il contrario (operativi di default, `--dry-run` opzionale) |
| 6 Output e logging | **Decisione dell'utente**: `rich` con fallback. Oggi gli script usano ANSI a mano, colorama, `print` con prefissi `[*] [!] [OK]` o `logging` |
| 7 Errori e uscite | **Proposto**: isolamento errori per modulo è dedotto (hardening), i codici di uscita **non** emergono dagli script |
| 8 Dipendenze | **Decisione dell'utente** tra 3 comportamenti diversi trovati negli script |

## 1. Vincoli fissi

- **Interattivo di default** quando lanciato da terminale: menu o prompt chiari, mai parametri obbligatori da ricordare a memoria.
- **Utilizzabile in automatico** (cron, systemd, altri script) tramite flag e rilevamento del contesto non interattivo.
- **Stesso stile dei tool esistenti** (Media Loader, Scan Orchestrator, IR Wizard, tool server), non uno stile nuovo scollegato.
- **Fail-safe di default** per ogni script che modifica o cancella (sezione 5).

## 2. Struttura del file (Python)

- Python 3.10+. Shebang `#!/usr/bin/env python3`.
- Docstring iniziale in italiano: descrizione, blocco `Uso:` con esempi reali, avvertenze (es. "solo su sistemi autorizzati").
- `from __future__ import annotations`, poi import stdlib, poi terze parti.
- Terze parti dentro `try/except ImportError` (vedi sezione 8).
- `BASE_DIR = Path(__file__).resolve().parent`; percorsi sempre con `pathlib`.
- Costanti in testa: `VERSION`, `BASE_DIR`, nomi e soglie in `MAIUSCOLO`.
- Su Windows forza UTF-8: `sys.stdout.reconfigure(encoding="utf-8", errors="replace")` (anche stderr), in `try/except`.
- Sezioni separate da righe `# ═══ TITOLO ═══` o `# ─── titolo ───`.
- Funzioni piccole; classi per stato o moduli; tool grandi in `core/`, `reporter/`, `config.yaml`.
- `main()` con `argparse` e `if __name__ == "__main__": main()` (o `sys.exit(main())`).
- Espone sempre `--version`; `--help` con esempi (`RawDescriptionHelpFormatter`).
- Bash: `#!/usr/bin/env bash`, `set -euo pipefail`, colori come variabili, parsing flag con `case`, `--dry-run` e `--help`.

## 3. Interattività (default da terminale)

- **Senza argomenti → menu o wizard** (come Media Loader, Scan Orchestrator, IR Wizard). Gli argomenti sono scorciatoie, non obbligo.
- Un valore mancante si **chiede** (es. Quick Triage chiede il path, Passive Audit il dominio) invece di fallire.
- Menu numerati; `0` = annulla/esci; prompt con `▶`; opzioni con default indicato (Enter = default).
- Helper standard per i prompt (modello IR Wizard): `ask_yesno(prompt, default)`, `ask_text(...)`, `wait_enter()`, con gestione di `EOFError` e `KeyboardInterrupt` (si torna al default, mai traceback).
- Input validato e richiesto di nuovo se non valido ("Risposta non valida — digitare 's' o 'n'").
- Segreti con `getpass.getpass("... (nascosto): ")`.
- Flusso a step numerati con intestazione (`STEP n — titolo`) per operazioni lunghe.

## 4. Modalità automatica / non interattiva

- Flag: `--yes` / `-y` (salta le conferme `[s/N]`) e `--non-interactive` (mai `input()`).
- **Rilevamento contesto:** se `not sys.stdin.isatty()` lo script si comporta come `--non-interactive`.
- In non interattivo:
  - mai `input()` né `getpass`; i valori arrivano da flag, variabili d'ambiente o `.env`;
  - un valore obbligatorio mancante → errore chiaro con codice 2, non blocco in attesa;
  - il default resta fail-safe (sezione 5): `--yes` **non** attiva le modifiche, serve `--apply`.
- Configurazioni di servizio (Telegram, credenziali) in interattivo si chiedono; in non interattivo si logga "non configurato — esegui in modalità interattiva" (come hardening/antihammer).
- Unit systemd e cron passano esplicitamente `--apply --non-interactive`.
- Gli stessi flag valgono per gli script Bash e PowerShell.

## 5. Conferme e fail-safe (non negoziabile)

- **Default = sola lettura.** Ogni script che scrive, cancella, installa o cambia lo stato del sistema parte in `--audit-only` / dry-run. Le modifiche partono solo con `--apply`.
- `--dry-run` stampa i comandi esatti senza eseguirli e non scrive nulla; l'output dice chiaramente "SIMULAZIONE".
- Prima di modificare: backup preventivo in cartella con timestamp, poi pattern anti-lockout (mai chiudere SSH/rete senza verifica).
- In modalità apply: banner ben visibile ("MODALITA' APPLY — verranno apportate modifiche") e log dell'elenco delle azioni.
- **Livelli di conferma:**
  - azione normale → `[s/N]`, default **No**;
  - azione irreversibile o ad alto impatto → digitare `CONFERMO` (o frase esplicita, es. `CONFERMO CONSENSO FIRMATO`);
  - i nuovi script usano `s/n`, non `yes/no`.
- Cancellazioni: solo su percorsi validati e circoscritti; mostrare cosa verrà eliminato prima di farlo.
- Scansioni e strumenti offensivi: solo con autorizzazione (gate di consenso come in Scan Orchestrator), hard-block fuori scope, nessun override.
- Gli strumenti di incident response lavorano su copie/evidenze in sola lettura e registrano hash e catena di custodia.

## 6. Output e logging

- Output a schermo con `rich` **se disponibile, altrimenti testo semplice** (modello `stampa(msg, stile)` di Scan Orchestrator): import in `try/except`, flag `RICH_AVAILABLE`.
- Stili e prefissi: `[OK]` verde, `[ERR]` rosso, `[!]` giallo (avviso), `>>` ciano (info), pannello per i titoli.
- Colori solo se `sys.stdout.isatty()`; su pipe o file testo pulito.
- `logging` standard: formato `%(asctime)s [%(levelname)s] %(message)s`, console + file (`RotatingFileHandler`, es. 1 MB × 5 backup) per gli script che girano non presidiati.
- `--verbose` porta il livello a DEBUG. Mai `print` per messaggi di servizio negli script non presidiati.
- Messaggi all'utente in italiano.
- Mai segreti in log, console, report o codice.

## 7. Errori e codici di uscita

- `try/except` su ogni operazione di I/O, rete, file system, subprocess.
- Con più moduli/controlli: un errore in un modulo viene loggato (`exc_info=True`) e **non blocca gli altri**; il riepilogo finale lo segnala.
- Eccezioni dedicate per errori di dominio (`ProfileError`, `LoginError`, ...) e messaggio comprensibile all'utente.
- Uscite: `0` ok, `1` errore di esecuzione, `2` uso errato o input mancante, `130` interruzione con Ctrl+C.
- Ctrl+C gestito: messaggio pulito, nessun traceback, stato lasciato coerente.
- Un errore che richiede di rilanciare a pagamento (API, servizi terzi) chiede conferma prima di riprovare.

## 8. Dipendenze

- Controllo all'avvio. Se manca una dipendenza obbligatoria: **esci con messaggio chiaro e il comando esatto**, es. `Dipendenza mancante (yaml). Installa: pip install -r requirements.txt`. Modello: bikini-bottom-safe.
- **Nessuna installazione automatica** e nessun `--break-system-packages` (dr-audit fa così ma non è lo standard).
- Dipendenze davvero opzionali: import in `try/except ImportError` con `None` e messaggio solo se la funzione viene usata.
- `requirements.txt` sempre presente e allineato; virtualenv consigliato (`python -m venv .venv`).
- Installer/bootstrap: solo stdlib, contenuti incorporati, idempotenti (non sovrascrivono config senza conferma), `--dir`, `--force`, `--dry-run`.

## 9. Sicurezza

- Credenziali: `getpass`, variabili d'ambiente o `.env` (`python-dotenv`); mai nel codice, mai nei log.
- File con segreti o report sensibili: permessi 600 dove possibile (`os.chmod(path, 0o600)`), `.env` in `.gitignore`.
- Se servono privilegi, controllarli **all'inizio** (`geteuid() == 0` / `IsUserAnAdmin()`) ed uscire con messaggio chiaro.
- Validare ogni input esterno (domini con regex, URL, percorsi, numeri); normalizzare BOM e spazi.
- `subprocess` con lista di argomenti; `shell=True` solo se indispensabile e mai con input non validato.
- Nomi file ripuliti (`sanitize_filename`) quando derivano da input o da rete.
- Solo librerie e chiamate di rete strettamente necessarie; niente rete negli installer.
- Tool consegnati su macchine cliente: possono auto-eliminarsi a fine lavoro (Quick Triage, dr-audit), sempre con `--no-self-destruct` per il debug. Non è una regola generale.

## 10. Naming e commenti

- Commenti, docstring e messaggi in **italiano**.
- `snake_case` per variabili e funzioni, `PascalCase` per classi, `MAIUSCOLO` per costanti.
- Docstring su funzioni non banali; commento breve su ogni sezione principale.
- Placeholder e segnaposto espliciti (`DA_VERIFICARE`, `[NOME CLIENTE]`).
- Nomi file descrittivi: `install_*.py` per bootstrap, `*_report` per report, versione in `VERSION`.
- Progetti multi-file: `README.md` con uso e requisiti.

## 11. Checklist prima di consegnare

- [ ] Senza argomenti da terminale si apre menu/wizard.
- [ ] `--yes` e `--non-interactive` funzionano; senza TTY non compare nessun `input()`.
- [ ] Il default non modifica nulla; `--apply` e `--dry-run` esistono se lo script scrive o cancella.
- [ ] Conferme `[s/N]` o `CONFERMO` nei punti giusti.
- [ ] Nessuna credenziale nel codice o nei log.
- [ ] Dipendenze controllate all'avvio con messaggio chiaro; `requirements.txt` presente.
- [ ] `try/except` sulle operazioni critiche; Ctrl+C gestito; codici di uscita corretti.
- [ ] Docstring `Uso:` con esempi; commenti in italiano.
- [ ] Testato: dry-run, esecuzione reale su dati di prova e modalità non interattiva.
