---
name: project_jarvis
description: Jarvis (assistente locale llama.cpp + whisper/piper + agent LangGraph) e Grok (pipeline video) spostati in ~/Vektora il 2026-11-22
metadata:
  type: project
---

Jarvis sta in `~/Vektora/Jarvis/` (agent/, llm/llama.cpp + llm/models, voce/whisper.cpp + voce/piper, venv/, jarvis-llm.service, README.md). Grok sta in `~/Vektora/Grok/` e usa `Jarvis/venv`. Prima erano sciolti in `/home/joyboy` (messi lì da un'altra AI).

**Why:** spostando, i binari llama.cpp/whisper.cpp hanno RUNPATH assoluto (vanno ricompilati) e il venv ha shebang assoluti (corretti con sed, non ricreato: contiene torch/whisper). Il servizio systemd `/etc/systemd/system/jarvis-llm.service` richiede sudo: la versione aggiornata (host 127.0.0.1, prima 0.0.0.0 senza chiave) è in `Jarvis/jarvis-llm.service`.

**How to apply:** se si sposta ancora, seguire «Se sposti la cartella» nel README di Jarvis. Gli script `organize_*.py` sono finiti in `Cybersecurity/Script/Organizza Video/`. Collegato a [[project_ayanokoji_system]] solo come vicino di cartella.
