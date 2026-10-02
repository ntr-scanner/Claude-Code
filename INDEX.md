# Claude — Indice centrale

Punto d'ingresso per Claude Code. Leggi questo file **prima di ogni task** nella cartella `Web Developer`, poi apri solo i file pertinenti al task.

Aggiornato: 2026-10-02 (progetto Vektora Order, server `vektora-order`)

## Regola d'oro: tutto sta in `Claude/`

- Prima di fare qualsiasi cosa leggi questo file. Non cercare istruzioni altrove.
- **Non creare nuovi file `CLAUDE.md`** o altri file di istruzioni fuori da `Claude/`. Regole, skill, note e direttive nuove si aggiungono o modificano qui dentro.
- L'unico `CLAUDE.md` del workspace è `Web Developer/CLAUDE.md`: è solo un rimando, caricato in automatico da Claude Code.
- Eccezioni fuori dal perimetro (non toccare): `Cybersecurity/Script/PentestGPT/CLAUDE.md` (istruzioni interne di quel progetto di terzi) e `Antigravity/ANTYGRAVITY.md` (regole di un altro agente, Antigravity).

## Regole generali dell'utente (sempre valide)

- Lingua: italiano.
- Niente proposte di commit git: l'utente committa manualmente.
- Nuovi file per i siti Vektora: riusa `css/styles.css`, `js/script.js`, header/nav/footer esistenti; segnala prima di deviare.
- Immagini (siti clienti e blog): mai sceglierle in autonomia, chiedi sempre. Per il blog controlla prima `blog-src/image/`.
- Prima di azioni irreversibili o esterne, chiedi conferma.
- **Backup di `Claude/`:** ogni volta che modifichi qualcosa dentro `Claude/` (anche memoria, skill, agent), fai commit e push su `origin/main` (repo privato `ntr-scanner/Claude-Code`). Su questo repo non chiedere conferma. Vale solo per `Claude/`, negli altri repo l'utente committa da sé.
- Dettagli: `memoria/feedback_*.md`.

## Quale file leggere per quale task

| Task | Leggi |
|---|---|
| Nuovo sito cliente Vektora | `DESIGN.md`, `skills/vektora-web-dev/SKILL.md` (+ `snippets/animations.md`), `vektora-wat.md` |
| Nuova cartella cliente | `skills/vektora-clienti/SKILL.md`, `memoria/project_clienti_vektora.md` |
| Sito/blog Vektora | `memoria/project_vektora.md`, `memoria/project_vektora_blog.md` |
| Scrivere qualsiasi script (Python, Bash, PowerShell) | `SCRIPT.md` (obbligatorio, prima di scrivere) |
| Audit / sicurezza | `agents/security-auditor.md`, `memoria/project_cybersecurity_*.md` e gli altri `project_*` di cybersecurity |
| Qualsiasi altro progetto | il relativo `memoria/project_*.md` |

## Contenuto della cartella

```
Claude/
├── INDEX.md            ← questo file
├── DESIGN.md           direttive tecniche per piano (Starter/Standard/Pro/Premium)
├── SCRIPT.md           standard per scrivere script (interattivo di default, --yes/--non-interactive, fail-safe)
├── README.md           documentazione del repo di backup
├── vektora-wat.md      regole di lavoro sui siti cliente Vektora (framework WAT): unica copia
├── skills/             skill Vektora (`.claude/skills` è una junction verso questa cartella)
├── agents/             sub-agent (security-auditor; `.claude/agents` è una junction)
└── memoria/            memoria persistente di Claude (MEMORY.md + file singoli; la cartella memoria di Claude Code è una junction)
```

## Mappa di `Web Developer/`

| Cartella | Contenuto |
|---|---|
| `Vektora Site/` | Framework WAT dell'agenzia (regole in `vektora-wat.md`): `templates/`, `workflows/`, `tools/`, `assets-vektora/`, `Clienti Vektora/` (cartelle esistenti in formato vecchio `Cliente N - nome`; le nuove `[anno]-[nome]-[tipo]`), `vektora-site-main/` (sito + blog Eleventy), `Prodotti Vektora/` |
| `Cybersecurity/` | Script e tool di sicurezza (DR audit, Compliance Tracker, Ransomware Identifier, Scan Orchestrator, ecc.) |
| `Marketing/` | Costi mercato, prospecting n8n, catalogo tipologie siti, quiz |
| `Progetti/` | Progetti vari (Sonar) |
| `Università/` | Materiale di studio, autoverifica |
| `Antigravity/` | Area di lavoro di un altro agente (Antigravity) con sue regole; ha una copia vecchia della skill `vektora-web-dev`, non è quella attiva |
| `Ayanokoji/`, `Games/` | Progetti personali |
| `Claude/` | Questa cartella |
| `.claude/` | Configurazione attiva di Claude Code: `skills/` e `agents/` (junction verso `Claude/`), `settings.local.json` (permessi), `launch.json` (server di sviluppo) |

## Server di sviluppo (`.claude/launch.json`)

| Nome | Cosa serve | Porta |
|---|---|---|
| `vektora-site-main` | `Vektora Site/vektora-site-main` (python http.server) | 8080 |
| `piccolo1929` | `start-piccolo1929.bat` | 3000 |
| `ransomware-id-demo` | `Cybersecurity/Script/Ransomware Identifier/start-demo.bat` | 7444 |
| `autoverifica` | `Università/autoverifica` | 8765 |
| `vektora-forensics` | `Vektora Site/Prodotti Vektora/vektora-forensics` | 8081 |
| `vektora-order` | `Vektora Site/Prodotti Vektora/vektora-order` (`pnpm dev`, Next.js) | 3000 |

## Fuori da `Web Developer/`

- `C:\Users\pc\Documents\SyncThings\Task Manager Ayanokoji\`: progetto ATM (vedi `memoria/project_atm.md`).
- `C:\Users\pc\Documents\SyncThings\Obsidian\`: vault Obsidian con guide (Anti-Malware, Sicurezza, ecc.).
- `C:\Users\pc\Documents\SyncThings\Programming\CLAUDE-programmazione.md`: vecchio file di regole per esercizi e automazioni. Non è più una fonte da leggere: le regole sugli script valgono in `SCRIPT.md`.

## Decisioni Vektora (autorevoli)

- **Piani:** Starter 299€ (one-page), Standard 549€ (multi-pagina), Pro 899€ (prenotazioni + CMS), Premium 1.499€ (pagamenti online, DDoS, assistenza 24h, backup giornaliero). Sostituiscono i nomi/prezzi vecchi.
- **Stack:** vanilla HTML/CSS/JS + Tailwind CDN per Starter e Standard (CMS e framework vietati); CMS/framework consentiti e raccomandati da Pro in su.
- **Naming clienti:** `[anno]-[nome-cliente]-[tipo-sito]` (es. `2026-mario-rossi-parrucchiere`). Le cartelle vecchie `Cliente N - nome` non si rinominano senza conferma.
- `DESIGN.md` (direttive per piano, con `[DA DECIDERE]` sui valori tecnici mancanti) è in `Claude/DESIGN.md` e prevale su skill e `vektora-wat.md`.

## Incoerenze ancora aperte

- Struttura interna cliente: `vektora-wat.md` usa `docs/` + `sito/`, la skill `vektora-clienti` usa `materiali/` + `sviluppo/`.
- Firma nel footer: `vektora-wat.md` ha il blocco con logo SVG, la skill `vektora-web-dev` un semplice paragrafo.
- Le animazioni per piano nella skill erano legate ai vecchi 4 livelli: la mappatura Vetrina Essenziale→Starter, Business→Standard è per posizione e va confermata.

## Junction (nessuno specchio)

- `Web Developer\.claude\skills` → `Claude\skills`, `Web Developer\.claude\agents` → `Claude\agents`, `C:\Users\pc\.claude\projects\C--Users-pc-Documents-Web-Developer\memory` → `Claude\memoria`.
- Esiste una sola copia di ogni file: modificare in `Claude/` equivale a modificare la configurazione attiva. Non ci sono copie da sincronizzare.
- Se una junction sparisce (ripristino, cancellazione), ricrearla con i comandi in `README.md`.
