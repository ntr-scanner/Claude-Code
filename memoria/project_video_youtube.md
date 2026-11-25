---
name: project-video-youtube
description: "Motore video Vektora senza registrazione (Grok/motore: Chatterbox + scena.html catturata con Playwright + controllo Whisper); obiettivo utente: video YouTube e lead Jarvis automatici con approvazione minima"
metadata:
  node_type: memory
  type: project
  originSessionId: 34a64a27-a425-4422-ad43-8e6210767a73
  modified: 2026-11-24T22:47:59.124Z
---

Dal 2026-11-24 i video si fanno con `Grok/motore/genera.py <progetto>` usando `Grok/.venv-tts` (Python 3.11 via uv: chatterbox-tts, playwright+chromium, faster-whisper, pyyaml, setuptools<80). Ogni progetto ha solo `Grok/projects/<nome>/scene.yaml` (scene titolo/punti/email, voce a blocchi che svelano elementi, `pronuncia`, `descrizione`, `tag`, `miniatura`). Output `Grok/output/longform/<nome>/` (video.mp4, sottotitoli.srt, miniatura.png, descrizione.md con capitoli). Video 002 «Non Abboccare» 6:38.

L'utente ha bocciato la v1 (slide PIL + Piper): voce «albanese», «email» detto «eail», «si vede che non è reale», slide fuori moda. Ha scelto: voce clonata gratis (Chatterbox, MIT) + demo webmail; vuole che Claude faccia i video e che Jarvis trovi clienti per Vektora mentre lui studia e lavora. Concordato: approvazione umana minima (video caricato non in elenco, lead approvati da Telegram); chiamate a caldo rimandate «più avanti».

**Why:** l'utente non ha tempo per YouTube + Vektora + lavoro + università.

**How to apply:**
- GPU RTX 3050 4 GB: Chatterbox va in OOM, `_genera` ripiega su una copia CPU (~9x tempo reale). Lanciare render lunghi con `setsid nohup` (un render è morto con la sessione).
- Voce: `voce_campione.wav` nel progetto o `Grok/assets/voce/campione.wav`; senza, voce predefinita Chatterbox. Cache in `<progetto>/.cache_voce`. Ogni frase ritrascritta con faster-whisper (CPU, libcublas 12 manca) e rigenerata se somiglianza < 0.8.
- `scena.html`: render(t) deterministico; insidia: trasformazioni di una scena restano su #palco se non resettate in costruisci().
- Piper vecchio binario non legge it_IT-paola; `whisper` nel venv Jarvis è un pacchetto omonimo sbagliato.
- Prossime fasi: lead Jarvis (`Jarvis/agent/agent_sales.py` ha SMTP+Twilio+scraping email: rischio art. 130 / RPO, usare bozze + approvazione) e cron settimanale. Vedi [[project-jarvis]], [[project-lead-monitor]].
