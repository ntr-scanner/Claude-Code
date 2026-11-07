# Web Developer — istruzioni per Claude Code

> **Unico file CLAUDE.md del workspace.** Serve solo perché Claude Code lo carica in automatico: contiene rimandi, nessuna regola. Non creare altri CLAUDE.md o file di istruzioni altrove.

**Prima di fare qualsiasi cosa, leggi `Claude/INDEX.md`** e poi i file che indica come pertinenti. Tutto ciò che Claude deve sapere (regole, skill, agent, memoria, standard script, direttive Vektora) sta nella cartella `Claude/`.

**Prima di iniziare a programmare (anche su un dispositivo nuovo)**, verifica che i repo esterni elencati in `Claude/Repository/README.md` (omni-route, frontend-design, headroom, mempalace, playwright-mcp e le skill di terzi: apple-design, ui-ux-pro-max, ponytail, anthropic skills, karpathy, mattpocock, superpowers, taste-skill, agent-skills, caveman, graphify, free-claude-code, llm-council, claude-mem) siano clonati e integrati in Claude Code: esegui `Claude/Repository/setup_repos.sh --check`. Se manca qualcosa, segnalalo all'utente e proponi `setup_repos.sh --apply` prima di procedere.

**Prima di lavorare su qualsiasi progetto o codice**, leggi `Claude/SKILLS.md` e carica le skill adatte al task (design, pianificazione, TDD, debug, review, refactoring, ...), senza aspettare che l'utente le nomini.

**Prima di scrivere qualsiasi script**, leggi `Claude/SCRIPT.md` e attieniti alle sue convenzioni.

**Nuove regole, skill, note o direttive: aggiungile o modificale dentro `Claude/`, mai in file nuovi fuori da lì.**
