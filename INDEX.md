# Claude — Indice centrale

Punto d'ingresso per Claude Code. Leggi questo file **prima di ogni task** nella cartella `Web Developer Claude`, poi apri solo i file pertinenti al task.

Aggiornato: 2026-10-21 (riorganizzazione cartelle del workspace; plugin ufficiali claude-security, claude-code-setup, claude-md-management, agent-sdk-dev, typescript-lsp, pyright-lsp in `Repository/`)

## Regola d'oro: tutto sta in `Claude/`

- Prima di fare qualsiasi cosa leggi questo file. Non cercare istruzioni altrove.
- **Non creare nuovi file `CLAUDE.md`** o altri file di istruzioni fuori da `Claude/`. Regole, skill, note e direttive nuove si aggiungono o modificano qui dentro.
- L'unico `CLAUDE.md` del workspace è `Web Developer Claude/CLAUDE.md`: è solo un rimando, caricato in automatico da Claude Code. Si modifica solo lì. `Claude/CLAUDE.md` è la sua copia di backup nel repo: la riallinea l'hook `.git/hooks/pre-commit` a ogni commit (ogni push la contiene), non modificarla a mano. Dopo un clone o un pull: `cp Claude/CLAUDE.md CLAUDE.md`.
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
| **Qualsiasi lavoro su un progetto o codice** | `SKILLS.md` (quali skill caricare per il task), poi i file specifici sotto |
| Scrivere qualsiasi script (Python, Bash, PowerShell) | `SCRIPT.md` (obbligatorio, prima di scrivere) |
| Iniziare a programmare, nuovo dispositivo, repo esterni (OmniRoute, Headroom, MemPalace, Playwright MCP, frontend-design) | `Repository/README.md`, poi `Repository/setup_repos.sh --check` |
| Audit / sicurezza | `agents/security-auditor.md`, `memoria/project_cybersecurity_*.md` e gli altri `project_*` di cybersecurity |
| Qualsiasi altro progetto | il relativo `memoria/project_*.md` |

## Contenuto della cartella

```
Claude/
├── INDEX.md            ← questo file
├── DESIGN.md           direttive tecniche per piano (Starter/Standard/Pro/Premium)
├── SKILLS.md           quale skill esterna usare per quale task (design, TDD, debug, review, ...)
├── SCRIPT.md           standard per scrivere script (interattivo di default, --yes/--non-interactive, fail-safe)
├── Repository/         repo esterni e skill di terzi integrati in Claude Code: README.md (elenco) + setup_repos.sh; i clone non sono nel backup git
├── README.md           documentazione del repo di backup
├── vektora-wat.md      regole di lavoro sui siti cliente Vektora (framework WAT): unica copia
├── skills/             skill Vektora (`.claude/skills` è un collegamento a questa cartella)
├── agents/             sub-agent (security-auditor; `.claude/agents` è un collegamento)
└── memoria/            memoria persistente di Claude (MEMORY.md + file singoli; la cartella memoria di Claude Code è un collegamento)
```

## Mappa di `Web Developer Claude/`

Ogni cartella di primo livello è autonoma: si sincronizza da sola (Syncthing o git) senza dipendere dalle altre. Niente file sciolti nella radice, a parte `CLAUDE.md`.

| Cartella | Contenuto |
|---|---|
| `Vektora Site/` | Framework WAT dell'agenzia (regole in `vektora-wat.md`): `templates/`, `workflows/`, `tools/`, `assets-vektora/`, `Animazioni/`, `Clienti Vektora/` (cartelle esistenti in formato vecchio `Cliente N - nome`; le nuove `[anno]-[nome]-[tipo]`, es. `2026-mario-rossi-parrucchiere`), `vektora-site-main/` (sito + blog Eleventy), `Prodotti Vektora/` |
| `Cybersecurity/` | `Script/` (tool di sicurezza, ognuno nella sua cartella/repo: Compliance Tracker, Ransomware Identifier, Scan Orchestrator, RepoGuard, ecc.), `Script per server/` (hardening, backup, triage), `Audit Automatico/`, `Esportazione dati server Digital Ocean/` (export del 2026-10-07: coolify, db, n8n, volumi) |
| `Marketing/` | Costi mercato, prospecting n8n, catalogo tipologie siti, quiz |
| `Progetti/` | Progetti personali vari: `Sonar/`, `Orari Preghiera/`, `Games/` |
| `Università/` | Materiale di studio, autoverifica |
| `Work Tools/` | Tool da ufficio in HTML (repo git unico, `Dashboard.html` come ingresso) |
| `Antigravity/` | Area di lavoro di un altro agente (Antigravity) con sue regole; ha una copia vecchia della skill `vektora-web-dev`, non è quella attiva |
| `Ayanokoji/` | Ayanokoji System e Ayanokoji Tab (struttura propria, non riorganizzare) |
| `Claude/` | Questa cartella (non riorganizzare) |
| `.claude/` | Configurazione attiva di Claude Code: `skills/` e `agents/` (collegamenti a `Claude/`), `settings.local.json` (permessi), `launch.json` (server di sviluppo) |

Riorganizzata il 2026-10-21: `Games/` → `Progetti/Games/`, `Vektora Site/2026-mario-rossi-parrucchiere/` → `Vektora Site/Clienti Vektora/`, `Esportazione dati server Digital Ocean/` → `Cybersecurity/`, `Web dev da adesso in poi/RepoGuard/` → `Cybersecurity/Script/RepoGuard/` (la cartella `Web dev da adesso in poi/` è eliminata).

## Server di sviluppo (`.claude/launch.json`)

| Nome | Cosa serve | Porta |
|---|---|---|
| `vektora-site-main` | `Vektora Site/vektora-site-main` (python http.server) | 8080 |
| `piccolo1929` | `Vektora Site/Clienti Vektora/Cliente 1 - piccolo1929/Cliente 1 - piccolo1929` (`npm run dev`, Next) | 3000 |
| `autoverifica` | `Università/autoverifica` | 8765 |
| `vektora-forensics` | `Vektora Site/Prodotti Vektora/vektora-forensics` | 8081 |
| `vektora-prodotti` | `Vektora Site/Prodotti Vektora/vektora-prodotti` (`npm run dev`, Eleventy) | 8082 |
| `vektora-order` | `Vektora Site/Prodotti Vektora/vektora-order` (`pnpm dev`, custom server Next + Socket.io) | 3000 |
| `vektora-order-prod` | stesso progetto, `pnpm start` dopo `pnpm build` (serve `.env.production.local`) | 3001 |

## Fuori da `Web Developer Claude/`

- `C:\Users\pc\Documents\SyncThings\Task Manager Ayanokoji\`: progetto ATM (vedi `memoria/project_atm.md`).
- `C:\Users\pc\Documents\SyncThings\Obsidian\`: vault Obsidian con guide (Anti-Malware, Sicurezza, ecc.).
- `C:\Users\pc\Documents\Scaffale\Scaffale Mangawa\`: lettore manga con `codice/` separato da `dati/` (`dati/biblioteca` è una cartella Syncthing).
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

## Collegamenti (nessuno specchio)

- Windows (junction): `Web Developer Claude\.claude\skills` → `Claude\skills`, `Web Developer Claude\.claude\agents` → `Claude\agents`, `C:\Users\pc\.claude\projects\C--Users-pc-Documents-Web-Developer-Claude\memory` → `Claude\memoria` (ricreate il 2026-10-20: dopo il rinomino della cartella in `Web Developer Claude` mancavano, e al loro posto c'erano `.claude\_backup_claude_skills` e `_backup_claude_agents`, copie vecchie).
- Esiste una sola copia di ogni file: modificare in `Claude/` equivale a modificare la configurazione attiva. Non ci sono copie da sincronizzare.
- Linux (dispositivo attuale): symlink `Web Developer Claude/.claude/skills` → `../Claude/skills`, `.claude/agents` → `../Claude/agents`, `~/.claude/projects/-home-joyboy-Web-Developer-Claude/memory` → `Claude/memoria` (ricreati il 2026-10-17: col passaggio da Windows erano diventate cartelle vuote e skill, agent e memoria non venivano caricati).
- Se un collegamento sparisce (ripristino, cancellazione, nuovo dispositivo), ricrearlo con i comandi in `README.md`. Verifica: `ls -la .claude` deve mostrare `skills -> ../Claude/skills`.
