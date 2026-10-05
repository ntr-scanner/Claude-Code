---
name: project-vektora-prodotti
description: Catalogo prodotti Vektora su prodotti.vektora-web.com (Eleventy 3, CSS custom, font self-hosted), in Prodotti Vektora/vektora-prodotti, lavorato a fasi con conferma
metadata:
  type: project
---

Sito statico separato da vektora-site-main: `Vektora Site/Prodotti Vektora/vektora-prodotti/`, dominio **prodotti.vektora-web.com** (scelto dall'utente il 2026-10-05). Dev server `vektora-prodotti` in launch.json, porta 8082 (`npm run dev`).

Decisioni dell'utente (2026-10-05): prodotto QR si chiama **Vektora Order** (modalità contatto, B2B); Katharsis in-arrivo, Sonar in-sviluppo, entrambi lista d'attesa; contatti = vektora.web@gmail.com / +39 379 127 6390. **Lista d'attesa rimandata**: l'utente pensa di lasciare Netlify (problema crediti) e ospitare tutto sul proprio server; per ora CTA "Avvisami" via mailto, partial isolato da sostituire. **Hosting scelto: Vercel** (2026-10-05, "per adesso"). Header di sicurezza da `src/_data/sicurezza.js` → `vercel.json` generato da `scripts/genera-vercel.js` (`npm run vercel:config`; `npm run build` fa `--check` e si ferma se disallineato) e `_headers` per Netlify (escluso dal build se `VERCEL` è impostata). `trailingSlash: true`. Anteprima rifiutata anche con `VERCEL`.

Architettura: registro `src/_data/registro.json` + `src/prodotti/<slug>/prodotto.json` validati da `src/_data/prodotti.js`; CSS d'accento generato (`prodotti-css.njk`); `site.config.json` validato da `src/_data/sito.js` (stringa vuota = build fallisce; null solo per capitaleSociale; anteprima con `npm run dev` o `ANTEPRIMA=1`, rifiutata se NETLIFY/CONTEXT/CI). Unico script inline (tema) autorizzato in CSP via hash (`src/_data/inline.js`). Light theme: `--oro-testo` portato a #7D5F17 (il #8A6A1C del sito principale scende a 4.3:1 sulle schede).

Fasi: tutte e 5 completate il 2026-10-05 (scheletro, prodotti, legali, security.txt/sitemap/robots, verifica-build.js + Lighthouse + README). Lighthouse 100/100/100/100 su 4 pagine mobile+desktop (Edge headless, CHROME_PATH=msedge, Chrome non installato), servito con header reali; CSP ha connect-src self (senza, Lighthouse non scarica robots.txt). Il build reale fallisce finché l utente non compila site.config.json (P.IVA non ancora aperta). Aperti: backend lista d attesa, og:image, revisione legale, testi extra prodotti da confermare.

**Why:** l'utente vuole conferma tra una fase e l'altra e nessun testo segnaposto; Katharsis è un fork di Tron (vedi [[project-katharsis]]): non citare "Tron" sul sito e segnalare la verifica delle licenze dei tool inclusi prima della vendita.
**How to apply:** fermarsi a fine fase con riepilogo; niente riferimenti ad AI/strumenti nel codice/README; nessun commit ([[feedback_no_commit_git]]).
