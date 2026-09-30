# DESIGN.md — Direttive tecniche Vektora per piano

Riferimento unico, da consultare prima di costruire qualsiasi sito cliente. Il piano acquistato decide struttura, stack, ambito e sicurezza. Se una regola qui è in conflitto con `skills/vektora-web-dev/SKILL.md` o `vektora-wat.md`, **vale questo file**.

Aggiornato: 2026-09-30

**Convenzione:** `[DA DECIDERE]` = valore tecnico non ancora stabilito dall'utente. Non inventarlo, chiedilo prima di procedere. `[PROPOSTA]` = suggerimento non confermato.

## Regole comuni a tutti i piani

- **Piano:** chiedi sempre "quale piano ha acquistato il cliente?" se non è noto; non proporre nulla di un piano superiore.
- **Deploy:** Netlify, HTTPS sempre attivo.
- **Sicurezza minima:** HTTPS + header di sicurezza base in `netlify.toml` (`X-Frame-Options`, `X-Content-Type-Options`).
- **Footer:** firma Vektora obbligatoria, blocco in `vektora-wat.md`.
- **Accessibilità e responsive:** mobile-first, WCAG AA, `alt` sulle immagini, `aria-label` sui bottoni icon-only, `prefers-reduced-motion` sempre rispettato.
- **SEO base per ogni pagina:** `<title>`, meta description, Open Graph, canonical, favicon, `robots.txt`, `sitemap.xml`, Schema.org per settore.
- **Tema chiaro/scuro:** come da `vektora-wat.md` (palette standard). `[DA DECIDERE]` se resta obbligatorio anche su Starter.
- **Immagini:** mai scegliere in autonomia, chiedi sempre (tre domande in `vektora-wat.md`).
- **Dati cliente:** mai inventati; placeholder tra `[ ]`.
- **Pagine di servizio** (`404.html`, `grazie.html`, `privacy.html`, cookie banner se servono servizi terzi): `[DA DECIDERE]` se contano nel numero di pagine del piano. Su Starter e Standard cambia il limite "one-page" / "2-4 pagine".
- **Naming cartella:** `[anno]-[nome-cliente]-[tipo-sito]`.
- **Commenti nel codice:** in italiano.
- **Performance, immagini:** `vektora-wat.md` prevede oggi WebP e `loading="lazy"` per tutti i siti. `[DA DECIDERE]` se resta così o parte da un piano superiore.

---

## Starter — 299€

1. **Pagine incluse**
   - Solo home (one-page, sezioni scorrevoli).
   - Nessuna pagina interna.
2. **Stack**
   - HTML5 semantico, Tailwind CDN, JS vanilla.
   - Vietati framework JS, WordPress/CMS, build step.
3. **Incluso**
   - Sito one-page responsive.
   - Form di contatto (Netlify Forms) `[DA DECIDERE]` se incluso.
   - SEO base, firma Vektora.
   - Animazioni: nessuna o solo hover leggero (colore/opacità).
4. **NON incluso**
   - Pagine aggiuntive.
   - Animazioni complesse.
   - Blog, prenotazioni, CMS, pagamenti, e-commerce.
   - Integrazioni custom.
5. **Sicurezza minima**
   - Regole comuni (HTTPS, header base).
6. **Performance minima**
   - Lighthouse target `[DA DECIDERE]`.
7. **Supplemento fuori piano**
   - Ogni pagina in più (si passa a Standard o si quota a parte).
   - Ogni integrazione custom.
   - Animazioni oltre l'hover.

## Standard — 549€

1. **Pagine incluse**
   - Home + 2-4 pagine interne (multi-pagina).
   - Navbar e footer condivisi.
2. **Stack**
   - Come Starter: HTML/CSS/JS vanilla + Tailwind CDN.
   - Vietati framework JS, CMS, build step.
3. **Incluso**
   - Tutto lo Starter.
   - Navigazione multi-pagina, `sitemap.xml` con tutte le pagine.
   - Form contatti.
   - Animazioni leggere in CSS puro (elenco in skill, sezione 5; mappatura ai nuovi piani da confermare).
4. **NON incluso**
   - Prenotazioni, CMS, blog gestibile, pagamenti online.
   - Animazioni con librerie esterne.
   - Integrazioni custom.
5. **Sicurezza minima**
   - Come Starter.
6. **Performance minima**
   - Lighthouse target `[DA DECIDERE]`.
   - Immagini ottimizzate `[DA DECIDERE]`.
7. **Supplemento fuori piano**
   - Pagine interne oltre la quarta.
   - Integrazioni custom.
   - Qualsiasi funzione dei piani superiori (prenotazioni, CMS).

## Pro — 899€

1. **Pagine incluse**
   - Numero pagine `[DA DECIDERE]`.
2. **Stack**
   - CMS leggero o framework più strutturato: consentito/raccomandato da qui in su.
   - Quale CMS/framework e se serve build step: `[DA DECIDERE]` prima di iniziare.
   - Tailwind CDN dove possibile.
3. **Incluso**
   - Sistema di prenotazioni.
   - CMS per gestire i contenuti.
   - Tutto lo Standard.
   - Animazioni: Intersection Observer nativo e micro-interazioni.
4. **NON incluso**
   - Pagamenti online, protezione DDoS, assistenza 24h, backup giornaliero (sono Premium).
   - Integrazioni custom extra.
5. **Sicurezza minima**
   - Regole comuni.
   - Protezione del CMS (accesso admin) e dei dati di prenotazione: `[DA DECIDERE]`.
   - Da ricordare: le prenotazioni raccolgono dati personali, privacy policy da far revisionare al cliente.
6. **Performance minima**
   - Lighthouse target `[DA DECIDERE]`.
   - Ottimizzazione immagini obbligatoria `[DA DECIDERE]`.
7. **Supplemento fuori piano**
   - Integrazioni custom (calendari esterni, gestionali, ecc.).
   - Pagine oltre il numero incluso.
   - Pagamenti online (passa a Premium).

## Premium — 1.499€

1. **Pagine incluse**
   - Numero pagine `[DA DECIDERE]`.
2. **Stack**
   - Come Pro (CMS leggero o framework strutturato).
   - Provider di pagamento `[DA DECIDERE]`.
3. **Incluso**
   - Pagamenti online.
   - Protezione DDoS.
   - Assistenza 24h.
   - Backup giornaliero.
   - Include prenotazioni e CMS del Pro? `[DA DECIDERE]` (probabile sì).
4. **NON incluso**
   - Integrazioni custom non concordate.
   - `[DA DECIDERE]` altre esclusioni.
5. **Sicurezza minima**
   - Regole comuni.
   - Hardening esteso e backup automatizzato (solo da Premium).
   - Servizio DDoS `[DA DECIDERE]`.
   - Gestione backup: dove, retention, test di ripristino `[DA DECIDERE]`.
   - `[PROPOSTA]` I dati di carta non transitano dal sito, li gestisce il provider di pagamento.
6. **Performance minima**
   - Lighthouse target `[DA DECIDERE]`.
   - Ottimizzazione immagini obbligatoria `[DA DECIDERE]`.
7. **Supplemento fuori piano**
   - Integrazioni custom.
   - Pagine oltre il numero incluso.
   - Assistenza oltre i limiti dello SLA `[DA DECIDERE]`.

---

## Tabella comparativa

| Voce | Starter 299€ | Standard 549€ | Pro 899€ | Premium 1.499€ |
|---|---|---|---|---|
| Pagine | Solo home | Home + 2-4 interne | `[DA DECIDERE]` | `[DA DECIDERE]` |
| Stack | Vanilla + Tailwind CDN | Vanilla + Tailwind CDN | CMS/framework consentito | CMS/framework consentito |
| Prenotazioni | No | No | Sì | `[DA DECIDERE]` (probabile sì) |
| CMS | No | No | Sì | `[DA DECIDERE]` (probabile sì) |
| Pagamenti online | No | No | No | Sì |
| Protezione DDoS | No | No | No | Sì |
| Assistenza 24h | No | No | No | Sì |
| Backup giornaliero | No | No | No | Sì |
| Sicurezza | HTTPS + header base | HTTPS + header base | + `[DA DECIDERE]` | + hardening esteso e backup |
| Animazioni | Hover leggero | CSS leggero | Scroll + micro-interazioni | Avanzate (pesi da segnalare) |
| Lighthouse target | `[DA DECIDERE]` | `[DA DECIDERE]` | `[DA DECIDERE]` | `[DA DECIDERE]` |
