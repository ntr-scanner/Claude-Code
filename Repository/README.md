# Repository — repo esterni integrati in Claude Code

Cartella dei repo di terzi che l'utente integra in Claude Code. I clone **non** finiscono nel backup git di `Claude/` (sono in `.gitignore`, ~1,1 GB): nel backup restano solo questo file e `setup_repos.sh`, che li ricrea.

Aggiornato: 2026-10-13

## Repo integrati

| Cartella | Sorgente | Integrazione in Claude Code | Come si usa |
|---|---|---|---|
| `omni-route/` | [diegosouzapw/OmniRoute](https://github.com/diegosouzapw/OmniRoute) | CLI `omniroute` (npm in `~/.local/share/claude-repos/npm`). **Non** attivo di default | Su richiesta: `omniroute` avvia il gateway su `localhost:20128`, `omniroute run claude` lancia Claude Code attraverso il gateway |
| `frontend-design/` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) (sparse: `plugins/frontend-design`) | Plugin `frontend-design@claude-plugins-official` (scope utente) | Skill caricata in automatico quando si costruisce UI |
| `headroom/` | [chopratejas/headroom](https://github.com/chopratejas/headroom) | CLI `headroom` (venv) + server MCP `headroom` (`headroom mcp install --agent claude`) | Tool MCP `headroom_compress`/`headroom_retrieve`; oppure `headroom wrap claude` per lanciare Claude Code con il proxy di compressione |
| `mempalace/` | [mempalace/mempalace](https://github.com/mempalace/mempalace) | CLI `mempalace` (venv) + plugin `mempalace@mempalace` (MCP `mempalace-mcp`, hook Stop/SessionEnd/PreCompact, skill) | `mempalace init <cartella>`, poi ricerca con i tool MCP o `/mempalace:search` |
| `playwright-mcp/` | [microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp) | Server MCP `playwright` (scope utente, `npx @playwright/mcp@latest`) | Tool MCP per pilotare il browser (test e screenshot dei siti) |

## Dove stanno i tool installati

- Virtualenv Python: `~/.local/share/claude-repos/venvs/{headroom,mempalace}` (niente `--break-system-packages`).
- npm: `~/.local/share/claude-repos/npm` (niente `sudo`).
- Link agli eseguibili: `~/.local/bin/` (`headroom`, `mempalace`, `mempalace-mcp`, `omniroute`). Deve stare nel `PATH`: su Ubuntu lo aggiunge `~/.profile` al login. Serve agli hook di MemPalace.
- Configurazione Claude Code: `~/.claude.json` (server MCP) e `~/.claude/` (plugin), scope utente: valgono in ogni progetto.

## Verifica e ripristino (nuovo dispositivo)

```bash
cd "Claude/Repository"
./setup_repos.sh --check     # cosa manca (sola lettura)
./setup_repos.sh --dry-run   # comandi che verrebbero eseguiti
./setup_repos.sh --apply     # clona, installa, integra (chiede conferma per ogni passo)
```

Dopo `--apply` riavvia Claude Code. Su Windows lo script va eseguito da WSL o Git Bash.

## Avvertenze

- **OmniRoute** instrada le richieste verso provider terzi e può far passare per il gateway anche l'abbonamento Claude: va usato solo su richiesta esplicita, mai impostato come `ANTHROPIC_BASE_URL` globale. Leggere i suoi avvisi sui provider con `tos: avoid` prima di collegarne uno.
- **MemPalace** scrive con gli hook a ogni fine sessione e prima della compattazione: i dati restano in locale.

## Aggiungere un repo

1. Clona in `Claude/Repository/<nome>`.
2. Aggiungi la riga nella tabella sopra e le funzioni corrispondenti in `setup_repos.sh` (clone, installazione, integrazione).
3. Verifica con `./setup_repos.sh --check` e fai commit/push di `Claude/`.
