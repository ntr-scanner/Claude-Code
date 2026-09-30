# Claude — setup di riferimento per Claude Code

Repository privato che contiene **solo** la cartella `Claude/` di `Web Developer/`. Serve a ricostruire il setup di riferimento di Claude Code se si perdono i file locali: clonando questo repo si recuperano indice, skill, agent e memoria.

## Cosa contiene

| Elemento | Funzione |
|---|---|
| `INDEX.md` | Punto d'ingresso: regole generali dell'utente, tabella "task → file da leggere", mappa delle cartelle |
| `SCRIPT.md` | Standard per scrivere script: interattivo di default, modalità automatica, fail-safe, output, dipendenze. Ha una tabella che distingue regole dedotte e proposte |
| `skills/` | Skill Vektora (`vektora-web-dev` con `snippets/`, `vektora-clienti`) |
| `vektora-wat.md` | Regole di lavoro sui siti cliente Vektora (framework WAT), unica copia |
| `agents/` | Sub-agent (`security-auditor`) |
| `DESIGN.md` | Direttive tecniche per piano (Starter/Standard/Pro/Premium) |
| `memoria/` | Memoria persistente di Claude: `MEMORY.md` (indice) e i file `feedback_*` / `project_*` |
| `README.md` | Questo file |

Nota sui `CLAUDE.md`: esiste un solo `CLAUDE.md`, in `Web Developer/CLAUDE.md`, ed è solo un rimando a `Claude/INDEX.md` (non è nel backup). Le regole Vektora stanno in `vektora-wat.md`. Non vanno creati altri file di istruzioni fuori da `Claude/`.

## Come viene usato

`Web Developer/CLAUDE.md` viene caricato automaticamente da Claude Code a ogni sessione e dice di leggere `Claude/INDEX.md` prima di qualsiasi task. L'indice indirizza poi verso le skill, gli agent e la memoria pertinenti. Le regole Vektora e `DESIGN.md` stanno in `Claude/`.

## Attenzione ai percorsi

`INDEX.md` e le skill rimandano a percorsi locali come `Vektora Site/...`, `Cybersecurity/...`, `.claude/skills/`. **In questo repo quelle cartelle non esistono.** Dopo un ripristino, i rimandi restano rotti finché non si ricrea la struttura o si aggiornano i percorsi.

### Ricostruzione da zero

1. Crea `C:\Users\pc\Documents\Web Developer\` e clona qui il repo, in modo che il risultato sia `Web Developer\Claude\` (`git clone https://github.com/ntr-scanner/Claude-Code.git Claude`).
2. Ricrea accanto a `Claude/` almeno queste cartelle: `Vektora Site/` (con `Clienti Vektora/`, `templates/`, `workflows/`, `tools/`, `assets-vektora/`), `Cybersecurity/`, `Marketing/`. Se non hai più i contenuti, crea le cartelle vuote e ripristinali dai backup dei progetti; altrimenti aggiorna i percorsi in `INDEX.md` e nelle skill.
3. Ricrea le junction, così Claude Code trova skill, agent e memoria dentro `Claude/` (da PowerShell, con Claude Code chiuso; se le cartelle di destinazione esistono già vuote, eliminale prima):

   ```powershell
   New-Item -ItemType Directory -Force "C:\Users\pc\Documents\Web Developer\.claude" | Out-Null
   cmd /c mklink /J "C:\Users\pc\Documents\Web Developer\.claude\skills" "C:\Users\pc\Documents\Web Developer\Claude\skills"
   cmd /c mklink /J "C:\Users\pc\Documents\Web Developer\.claude\agents" "C:\Users\pc\Documents\Web Developer\Claude\agents"
   New-Item -ItemType Directory -Force "C:\Users\pc\.claude\projects\C--Users-pc-Documents-Web-Developer" | Out-Null
   cmd /c mklink /J "C:\Users\pc\.claude\projects\C--Users-pc-Documents-Web-Developer\memory" "C:\Users\pc\Documents\Web Developer\Claude\memoria"
   ```

   Se il percorso del progetto cambia, cambia anche il nome della cartella sotto `.claude\projects\`.
4. `Claude/vektora-wat.md` è già al posto giusto: non serve ripristinare nulla in `Vektora Site\`.
5. Ricrea `Web Developer\CLAUDE.md` con questo contenuto minimo: leggere `Claude/INDEX.md` prima di ogni task; leggere `Claude/SCRIPT.md` prima di scrivere script; aggiungere e modificare le regole solo dentro `Claude/`.
6. Ricrea `Web Developer\.claude\settings.local.json` e `launch.json` se servono (non sono nel backup).
7. Apri Claude Code in `Web Developer\` e verifica che legga `Claude/INDEX.md`.

## Cosa NON è incluso

- I progetti cliente (`Vektora Site/Clienti Vektora/`), il sito e il blog (`Vektora Site/vektora-site-main/`), `templates/`, `workflows/`, `tools/`, `assets-vektora/`.
- Gli script e i tool fuori da `Claude/` (`Cybersecurity/`, `Marketing/`, `Progetti/`, `Università/`, ecc.).
- Il `CLAUDE.md` di root (va ricreato, vedi procedura).
- `.claude/settings.local.json`, permessi, credenziali (`.credentials.json`) e file `.env`.

Questo backup copre solo configurazione e riferimento, non il lavoro. Per i progetti serve un backup a parte.

## Come tenerlo aggiornato

Non c'è più uno specchio: skill, agent e memoria attivi **sono** le cartelle di `Claude/`, collegate con junction. Ogni modifica fatta da Claude Code o a mano finisce già qui.

Prima di committare basta controllare `git status` e assicurarsi che le junction esistano (`Get-Item "Web Developer\.claude\skills"` deve mostrare `LinkType: Junction`). Aggiorna la data in `INDEX.md` quando cambia una regola.

## Sicurezza

Il repo deve restare **privato**. La memoria e le skill descrivono progetti e strategie dell'agenzia. Non aggiungere mai credenziali, token o file `.env`.
