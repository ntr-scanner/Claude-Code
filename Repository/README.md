# Repository — repo esterni integrati in Claude Code

Cartella dei repo di terzi che l'utente integra in Claude Code. I clone **non** finiscono nel backup git di `Claude/` (sono in `.gitignore`, ~1,1 GB): nel backup restano solo questo file e `setup_repos.sh`, che li ricrea.

Aggiornato: 2026-10-17 (aggiunte le 11 skill: emil apple-design, ui-ux-pro-max, ponytail, anthropic skills, karpathy, mattpocock, superpowers, taste-skill, addy agent-skills, caveman, graphify)

## Repo integrati

| Cartella | Sorgente | Integrazione in Claude Code | Come si usa |
|---|---|---|---|
| `omni-route/` | [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute) | CLI `omniroute` (npm in `~/.local/share/claude-repos/npm`). **Non** attivo di default | Su richiesta: `omniroute` avvia il gateway su `localhost:20128`, `omniroute run claude` lancia Claude Code attraverso il gateway |
| `frontend-design/` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) (sparse: `plugins/frontend-design`) | Plugin `frontend-design@claude-plugins-official` (scope utente) | Skill caricata in automatico quando si costruisce UI |
| `headroom/` | [chopratejas/headroom](https://github.com/chopratejas/headroom) | CLI `headroom` (venv) + server MCP `headroom` (`headroom mcp install --agent claude`) | Tool MCP `headroom_compress`/`headroom_retrieve`; oppure `headroom wrap claude` per lanciare Claude Code con il proxy di compressione |
| `mempalace/` | [mempalace/mempalace](https://github.com/mempalace/mempalace) | CLI `mempalace` (venv) + plugin `mempalace@mempalace` (MCP `mempalace-mcp`, hook Stop/SessionEnd/PreCompact, skill) | `mempalace init <cartella>`, poi ricerca con i tool MCP o `/mempalace:search` |
| `playwright-mcp/` | [microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp) | Server MCP `playwright` (scope utente, `npx @playwright/mcp@latest`) | Tool MCP per pilotare il browser (test e screenshot dei siti) |

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
| `graphify/` | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | CLI `graphify` (venv, pacchetto `graphifyy`) + `graphify install --platform claude` → skill in `~/.claude/skills/graphify` e blocco in `~/.claude/CLAUDE.md` |

## Dove stanno i tool installati

- Virtualenv Python: `~/.local/share/claude-repos/venvs/{headroom,mempalace,graphify}` (niente `--break-system-packages`).
- npm: `~/.local/share/claude-repos/npm` (niente `sudo`).
- Link agli eseguibili: `~/.local/bin/` (`headroom`, `mempalace`, `mempalace-mcp`, `omniroute`, `graphify`). Deve stare nel `PATH`: su Ubuntu lo aggiunge `~/.profile` al login. Serve agli hook di MemPalace.
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
- **Plugin con hook** (ponytail, superpowers, caveman, agent-skills): eseguono codice del repo a ogni sessione. Installarli è una scelta dell'utente: Claude non li attiva da solo, si fa con `setup_repos.sh --apply`.
- **MemPalace** scrive con gli hook a ogni fine sessione e prima della compattazione: i dati restano in locale.

## Aggiungere un repo

1. Clona in `Claude/Repository/<nome>`.
2. Aggiungi la riga nella tabella sopra e le funzioni corrispondenti in `setup_repos.sh` (clone, installazione, integrazione).
3. Verifica con `./setup_repos.sh --check` e fai commit/push di `Claude/`.
