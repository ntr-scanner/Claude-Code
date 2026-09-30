---
name: project-lead-monitor
description: "Vektora Lead Monitor — file singolo bootstrap install_lead_monitor.py, genera struttura completa per monitoraggio lead su Reddit/RSS/Google Alerts con notifiche Telegram."
metadata: 
  node_type: memory
  type: project
  originSessionId: f1ce2be3-482f-4d1d-89dc-e62586f92ec7
  modified: 2026-09-08T08:29:36.954Z
---

**Percorso installer:** `C:\Users\pc\Documents\Web Developer\Cybersecurity\Script per server\install_lead_monitor.py`

**Struttura generata** (default: `Lead Monitor/`):
- `lead_monitor.py` — entry point, daemon loop con --status/--check-now/--setup-telegram/--setup-reddit
- `config.yaml` — keyword, subreddit, feed RSS, Google Alerts, intervallo (default 45 min)
- `core/reddit_source.py` — Reddit API pubblica + OAuth script-app, rate limit 2s, `--setup-reddit`
- `core/rss_source.py` — feed RSS generici (feedparser)
- `core/google_alerts_source.py` — feed RSS Google Alerts ufficiali (feedparser)
- `core/deduplicator.py` — SQLite anti-duplicati, cleanup automatico per giorni anzianita'
- `notifier/telegram_notifier.py` — setup interattivo con getpass, .env chmod 600, stesso pattern anti-hammer
- `lead_monitor.service` — systemd (Restart=always, After=network-online.target)
- `README.md` — docs complete (credenziali Reddit, Google Alerts RSS, forum RSS, systemd, nota etica)

**Dipendenze runtime:** `praw feedparser requests pyyaml`

**Pattern bootstrap:** stesso di [[project-cybersecurity-dr-audit]] e install_antihammer.py — contenuto embedded come raw strings `r'''...'''`, `FILES` dict, `_write()`, `main()` con `--dir` e `--force`.

**Nota etica hardcoded:** nessun scraping di Facebook/LinkedIn/Instagram — solo API/RSS ufficiali.

**Why:** monitoraggio lead passivo per Vektora, fonti legittime, zero scraping ToS-violating.
**How to apply:** per aggiungere fonti toccare solo config.yaml; per nuova sorgente, aggiungere modulo in core/ e istanziarlo in run_cycle().
