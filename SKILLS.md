# SKILLS.md — quale skill usare per quale lavoro

Leggi questo file **prima di lavorare su qualsiasi progetto o codice** e carica le skill pertinenti al task (tool `Skill`), senza aspettare che l'utente le nomini. Elenco, sorgenti e installazione: `Repository/README.md` e `Repository/setup_repos.sh`.

Aggiornato: 2026-11-15 (coach corpo/mente, marketing, investimenti); 2026-11-14 (skill di design: emil-skills, diagram-design, gstack)

## Regola: niente skill scaricate e non usate

1. **Mai un clone senza integrazione.** Chi scarica un repo in `Repository/` lo integra nella stessa sessione: plugin installato o cartella `~/.claude/skills/<nome>/SKILL.md` (maiuscolo), riga `clone_repo` + integrazione in `setup_repos.sh`, riga in `Repository/README.md`, riga in questa tabella, nome nell'elenco di `CLAUDE.md`. Se non va integrato, si elimina il clone.
2. **Verifica obbligatoria** prima di dire «fatto»: `setup_repos.sh --check` senza «Manca» e una sessione nuova (`cd /tmp && claude -p "Senza tool: quali di queste skill hai? <nomi>"`) che risponde sì.
3. **Controllo automatico:** `setup_repos.sh --check` segnala in rosso ogni cartella di `Repository/` che lo script non gestisce («Clone NON integrato»). Va eseguito prima di programmare (lo dice `CLAUDE.md`); se compare, dillo all'utente e proponi di integrarlo o eliminarlo.
4. **Repo con molte skill** (es. scientific-agent-skills, 177): si collegano solo quelle utili, elencate in `SKILLS_SCIENTIFIC` in `setup_repos.sh`. **Su richiesta:** se un task chiede una competenza che c'è in `Repository/scientific-agent-skills/skills/` (o in un altro clone parziale) ma non è collegata, collegala subito con `ln -sfn <clone>/skills/<nome> ~/.claude/skills/<nome>` (Claude Code la vede nella stessa sessione), usala, poi aggiungila a `SKILLS_SCIENTIFIC` e alla riga qui sotto, senza aspettare che l'utente lo chieda.
5. Plugin di memoria con hook: ne bastano claude-mem e MemPalace. Un terzo (es. agentmemory, eliminato il 2026-11-15) non si integra senza chiedere.

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
| **Fare un'app** (web, Android, desktop, con Claude) | sempre `karpathy-guidelines`; progetto: engineering `system-design`; UI: `ui-ux-pro-max`, ui-ux-pro-max `ui-styling`, `frontend-design`, taste-skill `design-taste-frontend`, `animate`, `apple-design`, `mobile-native` (app web sul telefono), `animate-expo` (React Native/Expo); test: anthropic `webapp-testing`; bug: superpowers `systematic-debugging`; velocità: addy `performance-optimization`; app con Claude: `claude-api`, agent-sdk-dev `/new-sdk-app`. Il plugin `engineering` arriva dall'account claude.ai (`~/.claude/plugins/synced/`), non da `Repository/` |
| Implementazione incrementale | addy `incremental-implementation`; superpowers `subagent-driven-development` per piani lunghi |
| Test / TDD | superpowers `test-driven-development`; mattpocock `tdd`; anthropic `webapp-testing` (Playwright) per app web |
| Bug e debugging | superpowers `systematic-debugging`; mattpocock `diagnosing-bugs`; addy `debugging-and-error-recovery` |
| Prima di dire "fatto" | superpowers `verification-before-completion`; caveman `verify-and-stop` |
| Code review | superpowers `requesting-code-review` / `receiving-code-review`; mattpocock `code-review`; addy `code-review-and-quality`; ponytail `ponytail-review` (over-engineering) |
| Refactoring, architettura, debito tecnico | mattpocock `improve-codebase-architecture`, `codebase-design`, `domain-modeling`; addy `code-simplification`; ponytail `ponytail-audit`, `ponytail-debt`; caveman `safe-refactor` |
| Capire un codebase grande / esistente | `graphify` (`/graphify .` crea il grafo, poi `graphify query`); caveman `caveman-explore`, `investigate-first` |
| Decisione tecnica con seconde opinioni (solo se l'utente lo chiede) | `llm-council` («consult the council»: ChatGPT + Gemini via API, serve `.env` con le chiavi) |
| Allenamento fisico e alimentazione | personal-trainer `exercise-science` (programmazione, progressione, recupero), comandi `/workout-program`, `/nutrition-plan`, `/progress-report`. Dolori, infortuni o patologie: consiglia un medico o un fisioterapista |
| Mente, emozioni, «psicologo» | `cognitive-toolkit` (`/cbt`: thought record, opposite action, DEAR MAN, TIPP, wise mind). È esercizio guidato, non terapia né diagnosi. **Correzioni per l'utente:** sessioni salvate solo se l'utente lo chiede (non in `~/Brains/`); in caso di crisi o pensieri suicidi ferma l'esercizio e dai i numeri italiani: **112** (emergenza), **Telefono Amico Italia 02 2327 2327**; per un percorso vero suggerisci uno psicologo |
| Marketing (Vektora e prodotti) | marketing-skills: `copywriting`, `copy-editing`, `seo-audit`, `ai-seo`, `programmatic-seo`, `marketing-plan`, `marketing-ideas`, `content-strategy`, `pricing`, `offers`, `launch`, `cro`, `ads`, `ad-creative`, `social`, `emails`, `competitors`, `customer-research`. Siti Vektora: `DESIGN.md` e `vektora-web-dev` prevalgono. `cold-email`/`prospecting`: solo bozze, vedi art. 130 Codice Privacy in `Repository/README.md` |
| Investimenti (azioni, ETF, portafoglio) | us-stock-analysis: `stock-eval`, `fundamental-analysis`, `dcf-valuation`, `stock-valuation`, `etf-analysis`, `portfolio-review`, `risk-stress-test`, `dividend-analysis`, `bear-case`, `thesis-tracker`, `learning-coach`. Mercato USA e fisco USA (`tax-lens` non vale in Italia). Solo analisi, mai ordini; non è consulenza finanziaria. Progetto PAC: `memoria/project_aurum.md` |
| Ricerca, articoli scientifici, dati | scientific-agent-skills (link singoli): `literature-review`, `paper-lookup`, `citation-management`, `peer-review`, `market-research-reports` (dimensione del mercato, TAM/SAM/SOM), `markitdown` (documenti → Markdown), `polars`, `matplotlib`, `exploratory-data-analysis`. Altre 168 nel clone: collegale su richiesta (regola 4 sopra) |
| Pilotare il browser locale (automazione, scraping, screenshot) | `browser-use` (CLI `browser-use`, Chrome/Brave locale via CDP); `open-source` per scrivere codice con la libreria `browser_use`. Per i test resta prima scelta il server MCP `playwright`. Escluse `qa`, `cloud`, `remote-browser`, `x402`: browser cloud a pagamento, chiave API auto-registrata o wallet crypto |
| Trovare clienti / lead per Vektora | `lead-research-assistant` (ricerca aziende target e strategia di contatto, nessun invio); `harvey` (CLI, invio cold email: solo su richiesta, vedi avvertenze in `Repository/README.md`) |
| Test e screenshot nel browser | server MCP `playwright` (su Brave) |
| UI, siti, landing page (design) | `ui-ux-pro-max` (stili, palette, font, UX per stack); taste-skill `design-taste-frontend` (art direction, anti-“AI slop”); anthropic `frontend-design`; `apple-design` per interfacce stile Apple (HIG, materiali, motion); `mobile-native` per app web e PWA sul telefono (100vh, notch, tap, zoom degli input) |
| Design system di un prodotto nuovo | gstack `design-consultation` (estetica, font, colori, spazi, motion + anteprima); ui-ux-pro-max `design-system` |
| Piano con parte grafica, prima di scrivere codice | gstack `plan-design-review` (le varianti grafiche vogliono la chiave OpenAI, vedi sotto) |
| Varianti grafiche da confrontare / mockup → HTML | gstack `design-shotgun` (varianti + tavola di confronto), poi `design-html` (HTML/CSS di produzione dal mockup scelto). Tutte e due vogliono la chiave OpenAI |
| Controllo visivo di una pagina esistente (spaziature, gerarchia, “AI slop”) e redesign | gstack `design-review` (apre la pagina con `browse` e corregge); ui-ux-pro-max `design-system` |
| App iOS su iPhone vero | gstack `ios-design-review` |
| Animazioni | da zero: `animate` (React/Next, CSS, Framer Motion); più elementi insieme (stagger, entrate, cambi di vista): `choreograph`; scatti e frame persi: `animation-performance`; dove aggiungerle: `find-animation-opportunities`; troppe: `remove-animations`; piano di miglioramento di tutto il codice: `improve-animations`; revisione di un diff: `review-animations` (*); nome di un effetto: `animation-vocabulary`; React Native/Expo: `animate-expo` |
| Diagrammi | `diagram-design` (architettura, flowchart, ER, sequenza, Gantt, … in HTML/SVG/PNG con brand); gstack `diagram` (da testo o Mermaid a .excalidraw + SVG/PNG) |
| Correzioni di design dell'utente da non ripetere | `learn-taste` (*): le trasforma in regole; nei progetti Vektora scrivile in `Claude/` (DESIGN.md o memoria), non in file nuovi |
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

(*) `learn-taste` e `review-animations` hanno `disable-model-invocation: true` (scelta dell'autore): il tool Skill non le carica. Quando servono, Claude legge `~/.claude/skills/<nome>/SKILL.md` con Read e la segue; l'utente può anche scrivere `/learn-taste` o `/review-animations`.

**gstack** (7 skill di design): chiamano `~/.claude/skills/gstack/bin/*` e i programmi `design` e `browse` compilati con Bun (`setup_repos.sh` li prepara, Chromium di Playwright incluso). `design-shotgun`, `design-html` e le varianti di `plan-design-review` generano immagini con l'API OpenAI, a pagamento: senza chiave si fermano. La chiave si salva con `~/.claude/skills/gstack/design/dist/design setup` (`~/.gstack/openai.json`) o con la variabile `OPENAI_API_KEY`; chiedi all'utente prima di usarla. Dove una skill gstack propone `codex` (seconda opinione), saltalo: non è installato. Stato e preferenze di gstack in `~/.gstack/`.

## Note sui plugin con hook

- **superpowers**: all'avvio sessione inietta `using-superpowers` (ricorda di cercare la skill giusta prima di agire).
- **caveman**: all'avvio attiva la modalità compressa; `/caveman status` mostra la modalità, `/caveman off` (o "stop caveman") la spegne, `/ultracave` e `/megacave` comprimono di più; spenta per sempre con `CAVEMAN_DEFAULT_MODE=off`.
- **ponytail**: modalità "lazy senior dev" sempre attiva; dopo ogni turno scrive una riga di statistiche in `~/.config/ponytail/band/<progetto>.csv` (solo locale, webhook vuoto).
- **claude-security**: banner all'apertura di `/claude-security`, contatori d'uso locali dopo i suoi script, chiude dopo 60 s la domanda di conferma prima di uno scan se resta senza risposta, suggerisce uno scan dopo `git push` / `gh pr create` (disattiva con `CLAUDE_SECURITY_SCAN_TIP=off`). Serve `python3` ≥ 3.9 nel PATH.
- **graphify**: `graphify install` aggiunge un blocco `# graphify` in `~/.claude/CLAUDE.md` (file utente, fuori dal workspace).
- **claude-mem**: hook a ogni sessione e a ogni uso di tool + worker in background; riassume con chiamate a Claude e reinietta il contesto all'avvio. Si spegne con `claude plugin disable claude-mem@thedotmack`. **Disattivato il 2026-11-18 su richiesta dell'utente** (consumava la quota settimanale in background): non riattivarlo senza chiedere. Clone e dati `~/.claude-mem` restano.
