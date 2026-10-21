# SKILLS.md — quale skill usare per quale lavoro

Leggi questo file **prima di lavorare su qualsiasi progetto o codice** e carica le skill pertinenti al task (tool `Skill`), senza aspettare che l'utente le nomini. Elenco, sorgenti e installazione: `Repository/README.md` e `Repository/setup_repos.sh`.

Aggiornato: 2026-10-17

## Priorità in caso di conflitto

1. Regole dell'utente in `INDEX.md` e `memoria/feedback_*.md` (italiano, niente commit proposti, immagini mai scelte in autonomia).
2. Siti Vektora: `DESIGN.md`, `vektora-wat.md` e la skill `vektora-web-dev` prevalgono su qualsiasi skill di design esterna (stack, piani, header/footer).
3. Skill esterne, nell'ordine della tabella sotto.

- **Niente commit/PR proposti:** le skill che chiudono con commit, branch o PR (superpowers `finishing-a-development-branch`, mattpocock `pr`, caveman `caveman-commit`, agent-skills `git-workflow-and-versioning`) si usano fino al diff pronto, poi ci si ferma. Eccezione: backup di `Claude/` (vedi `INDEX.md`).
- **Lingua:** le risposte restano in italiano anche con caveman attivo (stile compresso, lingua dell'utente).
- **Proporzione:** su task piccoli valgono ponytail e karpathy (minimo indispensabile); il processo completo di superpowers (brainstorming → plan → esecuzione) solo per feature nuove o modifiche ampie.

## Mappa task → skill

| Task | Skill da usare |
|---|---|
| Qualsiasi modifica al codice (sempre) | `karpathy-guidelines` (pensa prima, semplicità, modifiche chirurgiche); `ponytail` (soluzione più corta che funziona, YAGNI) |
| Nuova feature / progetto nuovo | superpowers `brainstorming` → `writing-plans` → `executing-plans`; addy `spec-driven-development`, `planning-and-task-breakdown`; mattpocock `to-spec`, `to-tickets`, `grill-me` per chiarire i requisiti |
| Implementazione incrementale | addy `incremental-implementation`; superpowers `subagent-driven-development` per piani lunghi |
| Test / TDD | superpowers `test-driven-development`; mattpocock `tdd`; anthropic `webapp-testing` (Playwright) per app web |
| Bug e debugging | superpowers `systematic-debugging`; mattpocock `diagnosing-bugs`; addy `debugging-and-error-recovery` |
| Prima di dire "fatto" | superpowers `verification-before-completion`; caveman `verify-and-stop` |
| Code review | superpowers `requesting-code-review` / `receiving-code-review`; mattpocock `code-review`; addy `code-review-and-quality`; ponytail `ponytail-review` (over-engineering) |
| Refactoring, architettura, debito tecnico | mattpocock `improve-codebase-architecture`, `codebase-design`, `domain-modeling`; addy `code-simplification`; ponytail `ponytail-audit`, `ponytail-debt`; caveman `safe-refactor` |
| Capire un codebase grande / esistente | `graphify` (`/graphify .` crea il grafo, poi `graphify query`); caveman `caveman-explore`, `investigate-first` |
| UI, siti, landing page (design) | `ui-ux-pro-max` (stili, palette, font, UX per stack); taste-skill `taste-skill` (art direction, anti-“AI slop”); anthropic `frontend-design`; `apple-design` per interfacce stile Apple (HIG, materiali, motion) |
| Redesign di una pagina esistente | taste-skill `redesign-skill`; ui-ux-pro-max `design-system` |
| Da immagine/mockup a codice | taste-skill `image-to-code-skill` |
| Brand, design system, banner, slide | ui-ux-pro-max `brand`, `design-system`, `banner-design`, `slides`; anthropic `brand-guidelines`, `theme-factory` |
| API e interfacce | addy `api-and-interface-design`; anthropic `mcp-builder` per server MCP |
| App con Claude API | anthropic `claude-api`; `agent-sdk-dev` (`/new-sdk-app` crea un progetto Agent SDK, agent verifier Python/TS) |
| Sicurezza | `claude-security` (`/claude-security`: scan del codebase o delle modifiche, report SARIF, patch suggerite); addy `security-and-hardening` (+ `agents/security-auditor.md`) |
| Performance | addy `performance-optimization`, `browser-testing-with-devtools` |
| CI/CD, rilascio | addy `ci-cd-and-automation`, `shipping-and-launch`; `observability-and-instrumentation` |
| Documentazione, ADR | addy `documentation-and-adrs`; anthropic `doc-coauthoring` |
| File Office/PDF | anthropic `docx`, `xlsx`, `pptx`, `pdf` |
| Risparmio token / sessioni lunghe | `caveman` (attivo di default, `/caveman off` per disattivarlo), `caveman-compress` per comprimere file di memoria |
| Creare o migliorare una skill | anthropic `skill-creator`; superpowers `writing-skills` |
| Configurare Claude Code su un progetto (hook, MCP, skill, agent consigliati) | `claude-code-setup` (`claude-automation-recommender`) |
| Revisionare file di istruzioni (CLAUDE.md, `Claude/*.md`) | `claude-md-management` (`claude-md-improver`, `/revise-claude-md`): nel workspace le regole stanno in `Claude/`, non creare altri CLAUDE.md |
| Navigazione del codice TS/JS e Python (definizioni, riferimenti, errori) | `typescript-lsp`, `pyright-lsp`: language server automatici, nessun comando |

## Note sui plugin con hook

- **superpowers**: all'avvio sessione inietta `using-superpowers` (ricorda di cercare la skill giusta prima di agire).
- **caveman**: all'avvio attiva la modalità compressa; `/caveman status` mostra la modalità, `/caveman off` (o "stop caveman") la spegne, `/ultracave` e `/megacave` comprimono di più; spenta per sempre con `CAVEMAN_DEFAULT_MODE=off`.
- **ponytail**: modalità "lazy senior dev" sempre attiva; dopo ogni turno scrive una riga di statistiche in `~/.config/ponytail/band/<progetto>.csv` (solo locale, webhook vuoto).
- **claude-security**: banner all'apertura di `/claude-security`, contatori d'uso locali dopo i suoi script, chiude dopo 60 s la domanda di conferma prima di uno scan se resta senza risposta, suggerisce uno scan dopo `git push` / `gh pr create` (disattiva con `CLAUDE_SECURITY_SCAN_TIP=off`). Serve `python3` ≥ 3.9 nel PATH.
- **graphify**: `graphify install` aggiunge un blocco `# graphify` in `~/.claude/CLAUDE.md` (file utente, fuori dal workspace).
