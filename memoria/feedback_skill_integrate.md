---
name: feedback-skill-integrate
description: Ogni repo/skill scaricato in Claude/Repository va integrato e verificato subito, o eliminato; skill di repo grandi collegate su richiesta
metadata:
  type: feedback
---

Un repo o una skill scaricata in `Claude/Repository/` deve essere integrata nella stessa sessione (plugin o `~/.claude/skills/<nome>/SKILL.md`, `setup_repos.sh`, README, SKILLS.md, CLAUDE.md) e verificata in una sessione nuova con `claude -p`; altrimenti si elimina. Dei repo con molte skill (scientific-agent-skills) si collegano solo le utili, le altre al volo quando un task le richiede.

**Why:** il 2026-11-15 l'utente ha trovato agentmemory, browser-use e scientific-agent-skills scaricati ma mai usati da Claude, e ha chiesto una regola perché non ricapiti.

**How to apply:** prima di programmare `setup_repos.sh --check` (segnala «Clone NON integrato»); regola completa in `SKILLS.md`. Vedi [[feedback-claude-folder-unica-fonte]].
