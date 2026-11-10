# Repository — repo esterni integrati in Claude Code

Cartella dei repo di terzi che l'utente integra in Claude Code. I clone **non** finiscono nel backup git di `Claude/` (sono in `.gitignore`, ~1,1 GB): nel backup restano solo questo file e `setup_repos.sh`, che li ricrea.

Aggiornato: 2026-11-10 (aggiunto plugin rea da morluto/rea: reverse engineering)

## Repo integrati

| Cartella | Sorgente | Integrazione in Claude Code | Come si usa |
|---|---|---|---|
| `omni-route/` | [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute) | CLI `omniroute` (npm in `~/.local/share/claude-repos/npm`). **Non** attivo di default | Su richiesta: `omniroute` avvia il gateway su `localhost:20128`, `omniroute run claude` lancia Claude Code attraverso il gateway |
| `frontend-design/` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) (sparse: `plugins/{frontend-design,claude-security,claude-code-setup,claude-md-management,agent-sdk-dev,typescript-lsp,pyright-lsp}`) | Plugin `<nome>@claude-plugins-official` (scope utente, marketplace da GitHub) | `frontend-design` in automatico sulla UI; `/claude-security` (scan sicurezza); `claude-code-setup` e `claude-md-management` (configurazione e CLAUDE.md); `/new-sdk-app` (agent-sdk-dev); `typescript-lsp` e `pyright-lsp` danno a Claude il language server |
| `headroom/` | [chopratejas/headroom](https://github.com/chopratejas/headroom) | CLI `headroom` (venv) + server MCP `headroom` (`headroom mcp install --agent claude`) | Tool MCP `headroom_compress`/`headroom_retrieve`; oppure `headroom wrap claude` per lanciare Claude Code con il proxy di compressione |
| `mempalace/` | [mempalace/mempalace](https://github.com/mempalace/mempalace) | CLI `mempalace` (venv) + plugin `mempalace@mempalace` (MCP `mempalace-mcp`, hook Stop/SessionEnd/PreCompact, skill) | `mempalace init <cartella>`, poi ricerca con i tool MCP o `/mempalace:search` |
| (npm) language server | `typescript-language-server` + `typescript`, `pyright` | CLI in `~/.local/share/claude-repos/npm`, link in `~/.local/bin` | Usati in automatico dai plugin `typescript-lsp` e `pyright-lsp` |
| `playwright-mcp/` | [microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp) | Server MCP `playwright` (scope utente, `npx @playwright/mcp@latest --executable-path /snap/bin/brave`: Chrome non c'è) | Tool MCP per pilotare il browser (test e screenshot dei siti). Al posto di «browse» di gstack, scartato il 2026-10-24: richiedeva tutto gstack + Bun + una sezione in CLAUDE.md |
| `harvey/` | [ethanplusai/harvey](https://github.com/ethanplusai/harvey) | CLI `harvey` (venv, installato `--editable`: legge `.env`, `harvey.yaml`, `data/` dalla cartella del clone). **Non** attivo di default | Agente di vendita: trova attività, scrive cold email, gestisce le risposte. Configurazione da fare: `cd harvey && cp .env.example .env` (casella su dominio secondario), `harvey train <sito>`, `harvey signals`, `harvey discover`, `harvey dashboard` (127.0.0.1:5555), `harvey run`. Contiene un suo `CLAUDE.md` (wizard di setup del progetto, fuori dal perimetro come PentestGPT) |
| `free-claude-code/` | [Alishahryar1/free-claude-code](https://github.com/Alishahryar1/free-claude-code) | CLI `fcc-server`, `fcc-claude`, … (`uv tool install --python 3.14.9` dal clone; `uv` nel venv `uv`). **Non** attivo di default | Su richiesta: `fcc-server` apre l'Admin UI (chiave NVIDIA NIM o OpenRouter), poi `fcc-claude` lancia Claude Code verso quei modelli. Imposta le variabili solo per quel processo, non tocca la configurazione |

## Skill integrate

Quando usarle: `Claude/SKILLS.md`. Ogni repo con `marketplace.json` è registrato come marketplace **locale** (il clone qui sotto): `setup_repos.sh --apply` fa `git pull` del clone, poi `claude plugin marketplace update <nome>` aggiorna il plugin.

| Cartella | Sorgente | Integrazione in Claude Code |
|---|---|---|
| `emil-skills/` | [emilkowalski/skills](https://github.com/emilkowalski/skills) | Solo `skills/apple-design`, link in `~/.claude/skills/apple-design` |
| `ui-ux-pro-max/` | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | Plugin `ui-ux-pro-max@ui-ux-pro-max-skill` (7 skill di design) |
| `ponytail/` | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | Plugin `ponytail@ponytail` (hook: modalità sempre attiva + statistiche locali) |
| `anthropic-skills/` | [anthropics/skills](https://github.com/anthropics/skills) | Plugin `document-skills`, `example-skills`, `claude-api` @`anthropic-agent-skills` (nome riservato: marketplace da GitHub `anthropics/skills`, non dal clone) |
| `karpathy-skills/` | [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) | Plugin `andrej-karpathy-skills@karpathy-skills` |
| `mattpocock-skills/` | [mattpocock/skills](https://github.com/mattpocock/skills) | Plugin `mattpocock-skills@mattpocock` |
| `superpowers/` | [obra/superpowers](https://github.com/obra/superpowers) | Plugin `superpowers@superpowers-dev` (hook SessionStart) |
| `taste-skill/` | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | Plugin `taste-skill@taste-skill` |
| `agent-skills/` | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | Plugin `agent-skills@addy-agent-skills` (il marketplace scarica da GitHub) |
| `caveman/` | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | Plugin `caveman@caveman` (hook: modalità compressa attiva di default) |
| `llm-council/` | [gcpdev/llm-council-skill](https://github.com/gcpdev/llm-council-skill) | Skill `llm-council`, link in `~/.claude/skills/llm-council` | «Consult the council: …». Serve un `.env` nella cartella di lavoro con `OPENAI_API_KEY` e `GEMINI_API_KEY` (a pagamento per chiamata) |
| `claude-mem/` | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | Plugin `claude-mem@thedotmack` (marketplace locale; hook SessionStart/PostToolUse/Stop + worker in background) | Memoria automatica tra sessioni: osserva ogni uso di tool, la comprime con l'Agent SDK (consuma utilizzo Claude) e la reinietta all'avvio. Licenza AGPL-3.0 |
| `awesome-claude-skills/` | [composiohq/awesome-claude-skills](https://github.com/composiohq/awesome-claude-skills) | Solo `lead-research-assistant`, link in `~/.claude/skills/lead-research-assistant` |
| `animate/` | [delphi-ai/animate-skill](https://github.com/delphi-ai/animate-skill) | Skill `animate`, link in `~/.claude/skills/animate` (CSS + Framer Motion per React/Next.js) |
| `graphify/` | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | CLI `graphify` (venv, pacchetto `graphifyy`) + `graphify install --platform claude` → skill in `~/.claude/skills/graphify` e blocco in `~/.claude/CLAUDE.md` |
| `rea/` | [morluto/rea](https://github.com/morluto/rea) | Plugin `rea@rea` (marketplace locale, ma il plugin arriva dal pacchetto npm `rea-agents`, versione fissata nel `marketplace.json` del clone): server MCP `rea` (Node) + skill `reverse-engineer-anything` | Reverse engineering di binari nativi, .NET, Electron/JS, APK, firmware e siti senza sorgente. L’analisi nativa usa Ghidra/Hopper/IDA se installati (`npx rea-agents setup` o `rea doctor`); il JS statico no. Non serve per una codebase di cui hai il sorgente |

## Dove stanno i tool installati

- Virtualenv Python: `~/.local/share/claude-repos/venvs/{headroom,mempalace,graphify}` (niente `--break-system-packages`).
- uv (Python 3.14.9 e tool free-claude-code): `~/.local/share/claude-repos/uv/{python,tools}`. Su Windows non in `%APPDATA%\uv`: l'app Claude (MSIX) virtualizza `%APPDATA%` e la junction di uv verso Python si rompe.
- npm: `~/.local/share/claude-repos/npm` (niente `sudo`): omniroute, typescript-language-server, pyright.
- Link agli eseguibili: `~/.local/bin/` (`headroom`, `mempalace`, `mempalace-mcp`, `omniroute`, `graphify`, `typescript-language-server`, `pyright-langserver`). Deve stare nel `PATH`: su Ubuntu lo aggiunge `~/.profile` al login. Serve agli hook di MemPalace.
- Configurazione Claude Code: `~/.claude.json` (server MCP) e `~/.claude/` (plugin), scope utente: valgono in ogni progetto.

## Verifica e ripristino (nuovo dispositivo)

```bash
cd "Claude/Repository"
./setup_repos.sh --check     # cosa manca (sola lettura)
./setup_repos.sh --dry-run   # comandi che verrebbero eseguiti
./setup_repos.sh --apply     # clona, installa, integra (chiede conferma per ogni passo)
```

Dopo `--apply` riavvia Claude Code. Su Windows lo script va eseguito da Git Bash (dalla v1.2.0 lo supporta in modo nativo):

- i venv usano `Scripts/` invece di `bin/`; il CLI `claude` nativo sta in `~/.local/bin`, che lo script aggiunge da sé al PATH;
- i symlink richiedono Developer Mode, quindi `apple-design` si collega con una junction e i tool in `~/.local/bin` sono shim (`nome` per Git Bash + `nome.cmd` per cmd/PowerShell/hook);
- `--apply` aggiunge `C:\Users\<utente>\.local\bin` al PATH utente di Windows (serve agli hook di MemPalace).

## Avvertenze

- **OmniRoute** instrada le richieste verso provider terzi e può far passare per il gateway anche l'abbonamento Claude: va usato solo su richiesta esplicita, mai impostato come `ANTHROPIC_BASE_URL` globale. Leggere i suoi avvisi sui provider con `tos: avoid` prima di collegarne uno.
- **Plugin con hook** (ponytail, superpowers, caveman, agent-skills, claude-security): eseguono codice del repo a ogni sessione. Installarli è una scelta dell'utente: Claude non li attiva da solo, si fa con `setup_repos.sh --apply`.
- **rea** avvia un server MCP Node a ogni sessione e può lanciare decompilatori sui file indicati: analizzare solo software su cui si ha diritto (EULA, `DISCLAIMER.md` del repo).
- **free-claude-code** come OmniRoute: manda codice e prompt a fornitori terzi (NVIDIA NIM, OpenRouter). Solo su richiesta, mai come `ANTHROPIC_BASE_URL` globale.
- **claude-mem** registra ogni uso di tool (anche contenuti di file letti) in un SQLite locale e lo riassume con chiamate a Claude: occhio ai progetti con dati sensibili. Si spegne con `claude plugin disable claude-mem@thedotmack`.
- **Harvey** invia email a terzi dalla casella configurata e usa l'abbonamento Claude in loop. In Italia le email commerciali non richieste a indirizzi nominativi richiedono il consenso (art. 130 Codice Privacy, anche B2B): tenerlo in approvazione manuale (outbox) e verificare la base giuridica prima di inviare. `.env` e `data/harvey.db` (dati dei prospect) stanno nel clone: se `Claude/` è sincronizzata con Syncthing, viaggiano anche loro.
- **MemPalace** scrive con gli hook a ogni fine sessione e prima della compattazione: i dati restano in locale.

## Aggiungere un repo

1. Clona in `Claude/Repository/<nome>`.
2. Aggiungi la riga nella tabella sopra e le funzioni corrispondenti in `setup_repos.sh` (clone, installazione, integrazione).
3. Verifica con `./setup_repos.sh --check` e fai commit/push di `Claude/`.
