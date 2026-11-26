---
name: project_venator
description: "Venator — knowledge base metodologica bug bounty (Obsidian), repo ntr-scanner"
metadata:
  node_type: memory
  type: project
  originSessionId: f024e815-671e-4e6f-a914-bd9ebfffb3cd
  modified: 2026-11-25T18:43:31.114Z
---

Venator (lat. "cacciatore") = knowledge base personale per bug bounty, in italiano, ottimizzata Obsidian (wikilink `[[...]]`, tag). Percorso `~/Vektora/Venator---Bug-Bounty/`, repo GitHub `ntr-scanner/Venator---Bug-Bounty`. Generata inizialmente da Groq. Contesto operativo dichiarato: Windows + VM Kali/Ubuntu, primo programma target **Arc su HackerOne** (`hackerone.com/arc-bbp`). È **documentazione**, non un tool/scanner.

2026-11-25 ristrutturato: radice = `.git` + `README.md` generale; `Bug Bounty/` (tutto il materiale sotto, con il vecchio README e 00-indice); `Cyber Security/` (README + `Active Directory/00-indice.md` e `Phishing/` per awareness session COMPLETA (9 capitoli, ~1300 righe, campi `[DA COMPILARE]` per contatti aziendali), AD COMPLETA (10 capitoli, offensiva+difensiva, GOAD/Impacket/NetExec/BloodHound/Certipy, DCSync/ADCS/delegation, Event ID e hardening, ~1330 righe); cartelle Pentesting, Forensic, Malware Analysis, Cyber Security al Lavoro con 00-indice vuoto). Wikilink path tipo `[[03-strumenti/x]]` lasciati: Obsidian risolve per suffisso. Evitare `[[README]]`/`[[00-indice]]` nudi (ambigui).

Struttura Bug Bounty: 01-fondamenta, 02-ambiente, 03-strumenti (subfinder/amass/httpx/ffuf/feroxbuster/nuclei/dalfox), 04-metodologia (recon passo-passo, analisi manuale, checklist), 05-classi-vulnerabilita, 06-reporting (CVSS 4.0, template, esempi), 07-riferimento (cheat-sheet, glossario).

2026-11-25 (Opus 4.8): revisione + espansione. **Bug corretti** (copia-incolla rotti): 87 righe `\` + commento inline (troncavano i comandi) in fuzzing/http-probing/scanning/sqli/recon-subdomain; findomain `-u .json`+jq→testo; interlace `go install`→`pipx` (è Python); dalfox `--blind-xss`→`--blind`; httpx doppio `-o` (×3); nuclei `-json`→`-jsonl`; paramspider flag `--level/--exclude/-o` rimosse (CLI nuova scrive in `results/<dom>.txt`); grep quote rotta in analisi-manuale; nuclei broad `-passive`/`-headless` tolti; nota drift amass v4. Verificato con `bash -n` su tutti i blocchi (0 errori). **Aggiunte** 12 classi vuln nuove (7→19): command-injection-rce, ssti, xxe, file-upload, path-traversal-lfi, open-redirect, csrf, request-smuggling, graphql, api-jwt, subdomain-takeover, race-condition; + gate "no automated scanning" in scanning/FASE3. Indice e README aggiornati (totale 37→ in realtà 40 .md, ~10.700 righe).

Taglio etico della guida (da mantenere): payload non distruttivi, OOB preferito (interactsh/Collaborator), stop al primo evidence, test solo su account propri, no DoS. Vedi [[feedback_no_commit_git]] (l'utente committa a mano, non proporre commit).
