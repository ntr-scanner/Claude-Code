---
name: project-simulacrum
description: "Simulacrum, simulatore phishing aziendale fork di GoPhish, in Cybersecurity/Script/Simulacrum"
metadata:
  node_type: memory
  type: project
  originSessionId: a32620d5-260f-4995-b868-19fb3ec095bd
  modified: 2026-11-22T09:24:44.062Z
---

Simulacrum = simulatore di phishing per awareness aziendale, in `Vektora/Cybersecurity/Script/Simulacrum/` (repo GitHub `ntr-scanner/Simulacrum`). Decisione 2026-11-21: **fork di GoPhish** (Go, MIT, GORM+SQLite), non riscrittura; `Piano.md` = spec funzionale utente, `PIANO-TECNICO.md` = piano a fasi (0 legale/bootstrap → 6 localizzazione/packaging), ogni fase con conferma.

8 modifiche sopra il fork: UI italiana, cattura credenziali, classifica rischio+awareness alla 2ª click, retention 60-90gg, integrazione Homus (whitelist email test), PDF autorizzazione firmabile, avvia.sh/.bat + gate HTTPS/VPN se in rete, login email+MFA TOTP+recupero.

Decisione cattura credenziali: l'utente vuole salvare le password reali inserite; concordato di **cifrarle AES-GCM a riposo** (mai in chiaro su disco), decifrate solo nella pagina "conferma esposizione" allo sblocco admin. Aggancio: payload `r.Form` in `controllers/phish.go` → `models/result.go:createEvent` (oggi salva JSON in chiaro in events.details). RBAC già presente in GoPhish (`models/rbac.go`). Login GoPhish è username, senza MFA/email → da aggiungere in fase 4. Build frontend richiede Node+gulp. Vedi [[project-hamus]] per Homus/whitelist.

STATO (2026-11-22): **Fase 0 fatta** — fork GoPhish dentro la cartella, Go 1.27.4 installato user-local in `~/.local/go` (non nel PATH globale, lo usa `avvia.sh`), build+boot verdi (admin 127.0.0.1:3333, phish spostato a 127.0.0.1:8080 in config.json), `avvia.sh`, PDF autorizzazione+informativa HR in `autorizzazione/autorizzazione-simulacrum.html` (HTML→stampa, con clausola cattura+AES-GCM). **Fase 1a fatta** — `models/credentials.go` (AES-256-GCM, key file `simulacrum_secret.key` chmod 600 gitignored, cifra campi `(?i)pass`), hook in `HandleFormSubmit`, `DecryptCredentialPayload`+`LogCredentialUnlock`, test `models/credentials_test.go` verde (no plaintext nel JSON). **Fase 1b fatta** — pagina server-rendered `/conferma-esposizione` (route in `controllers/route.go` con `RequireLogin`, handler `ConfermaEsposizione`, template standalone `templates/conferma_esposizione.html`, voce in `templates/nav.html`). Lista campagne → dipendenti che hanno inviato credenziali → bottone "Sblocca" che decifra in chiaro + audit (`LogCredentialUnlock`), scope per owner via `GetCampaignResults(cid, user.Id)`. Smoke test: route 307→/login (protetta). Template letti a runtime da disco (no rebuild per modifiche HTML). NON testato end-to-end un submit reale. **Prossima: Fase 2** (classifica rischio per dipendente + trigger awareness alla 2ª click). Binario/DB/certs/key fuori da git. Utente committa a mano.
