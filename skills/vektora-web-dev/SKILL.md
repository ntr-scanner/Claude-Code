---
name: vektora-web-dev
description: >
  Workflow completo per sviluppare siti per clienti Vektora (Starter, Standard, Pro, Premium).
  Codifica stack, piani, regole obbligatorie e gestione animazioni per
  piano. Da invocare con /vektora-web-dev a inizio di ogni nuovo progetto
  sito Vektora.
triggers:
  - nuovo sito Vektora
  - sito cliente Vektora
  - vektora-web-dev
---

# Skill: vektora-web-dev

Stai sviluppando un sito per un cliente di **Vektora**, agenzia digitale
specializzata in siti vetrina per PMI italiane locali. Segui TUTTE le
regole di questa skill senza eccezioni.

---

## 1. Stack tecnico (fisso, non negoziabile)

| Tecnologia | Versione/modalità |
|---|---|
| HTML | HTML5 semantico |
| CSS | Tailwind CSS via CDN (no build step) |
| JavaScript | Vanilla JS |
| Deploy | Netlify |

**Divieti per Starter e Standard (stack vanilla):**
- Niente React, Vue, Angular o altri framework JS
- Niente WordPress o CMS
- Niente build step / bundler

**Da Pro in su:** un CMS (prenotazioni + CMS) è incluso nel piano, quindi CMS leggero o framework più strutturato sono **consentiti/raccomandati**. Il CMS o framework preciso e l'eventuale build step si decidono con l'utente e si fissano in `DESIGN.md` prima di iniziare. Anche da Pro in su restano validi Tailwind CDN dove possibile e le regole obbligatorie della sezione 3.

**Divieto per tutti i piani:**
- Niente jQuery (Tailwind è già caricato)

---

## 2. Piani disponibili

| Piano | Prezzo | Pagine | Caratteristiche |
|---|---|---|---|
| Starter | €299 | sito one-page | Design responsive |
| Standard | €549 | multi-pagina (home + 2-4 pagine interne) | Sito multi-pagina |
| Pro | €899 | da definire in `DESIGN.md` | Sistema di prenotazioni + CMS |
| Premium | €1.499 | da definire in `DESIGN.md` | Pagamenti online, protezione DDoS, assistenza 24h, backup giornaliero |

I dettagli per piano (pagine, stack, incluso/escluso, sicurezza, performance, supplementi) stanno in `DESIGN.md`, che prevale su questa tabella in caso di dubbio.

---

## 3. Regole obbligatorie (sempre, senza chiedere conferma)

### 3.1 Firma Vektora nel footer
Ogni sito **deve** contenere nel footer:

```html
<!-- Firma Vektora — obbligatoria, non rimuovere -->
<p>Realizzato da <a href="https://vektora-web.com" target="_blank" rel="noopener">Vektora</a></p>
```

Non è opzionale. Non va rimossa anche se il cliente lo chiede.

### 3.2 Immagini — chiedere sempre prima
**Mai** inserire immagini nel codice senza conferma preventiva.
Prima di ogni immagine chiedere:
1. È disponibile una foto reale del cliente, o serve un placeholder?
2. Se placeholder: che tipo? (colore piatto, pattern, testo descrittivo, servizio esterno tipo picsum?)

### 3.3 Mobile-first e accessibilità (WCAG AA minimo)
- Progettare prima per mobile, poi per desktop (breakpoint Tailwind: `sm:`, `md:`, `lg:`)
- Attributo `alt` descrittivo su **tutte** le immagini
- `aria-label` su tutti i bottoni icon-only
- Contrasti colore minimi WCAG AA (4.5:1 per testo normale, 3:1 per testo grande)

### 3.4 Dati mancanti del cliente
I dati specifici del cliente non vanno **mai** inventati.
Se mancano, usare placeholder tra parentesi quadre:

```
[NOME AZIENDA], [INDIRIZZO], [TELEFONO], [EMAIL], [SETTORE], [ANNO FONDAZIONE]
```

### 3.5 Commenti nel codice
I commenti HTML/JS per le sezioni principali vanno scritti **in italiano**:

```html
<!-- Sezione hero -->
<!-- Sezione servizi -->
<!-- Footer -->
```

### 3.6 Bug noto: tag `</script>` nei commenti JS
Il tag di chiusura `</script>` dentro un commento JavaScript rompe il
rendering HTML. Scriverlo **sempre** con backslash:

```js
// Usare sempre <\/script> nei commenti, mai </script>
```

### 3.7 prefers-reduced-motion (obbligatorio, nessuna eccezione)
Qualsiasi animazione deve rispettare la preferenza di sistema dell'utente.
Includere **sempre** nel CSS globale:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

Non richiedere conferma per questa regola — è accessibilità, non estetica.

---

## 4. Gestione animazioni — procedura obbligatoria

**Non scrivere MAI animazioni senza aver completato questi passaggi in ordine.**

### Passo 1 — Chiedere il piano
Se non è già noto, chiedere:
> "Qual è il piano acquistato dal cliente? (Starter / Standard / Pro / Premium)"

### Passo 2 — Proporre solo le animazioni coerenti con il piano

Consultare la tabella seguente e proporre **solo** le opzioni della fascia
corrispondente al piano. Non proporre mai animazioni di fasce superiori,
anche se tecnicamente fattibili.

Per ogni opzione fornire una breve descrizione di cosa fa.

### Passo 3 — Attendere conferma esplicita
Chiedere esplicitamente quali animazioni tra quelle proposte includere.
**Non procedere all'implementazione** finché non si riceve conferma.

---

## 5. Libreria animazioni per piano

### Piano: Starter (€299)
Nessuna animazione, oppure al massimo:

| Opzione | Descrizione |
|---|---|
| `hover-color` | Cambio colore/opacità su hover — CSS puro, zero movimento |
| `hover-opacity` | Leggera variazione di opacità su hover (es. link nel nav) |

Nessuna libreria esterna consentita.

---

### Piano: Standard (€549)
Animazioni leggere, CSS puro, nessuna libreria:

| Opzione | Codice riferimento | Descrizione |
|---|---|---|
| `fade-in-load` | vedi `snippets/animations.md` | Gli elementi principali appaiono in dissolvenza al caricamento della pagina (CSS puro) |
| `button-hover-scale` | vedi `snippets/animations.md` | I bottoni si ingrandiscono leggermente al passaggio del mouse (scale + ombra) |
| `smooth-scroll` | `scroll-behavior: smooth` nel CSS | Lo scroll verso le ancore avviene con scorrimento fluido nativo |

Nessuna libreria esterna consentita.

---

### Piano: Pro (€899)
Animazioni allo scroll + micro-interazioni. Valutare sempre Intersection
Observer nativo **prima** di aggiungere librerie.

| Opzione | Libreria richiesta | Descrizione |
|---|---|---|
| `reveal-on-scroll` | Nessuna (Intersection Observer nativo) | Le sezioni appaiono con dissolvenza o slide mentre l'utente scrolla verso il basso |
| `aos-library` | AOS via CDN (chiedere conferma prima di aggiungerla) | Animazioni allo scroll più ricche tramite libreria AOS — richiede approvazione esplicita come dipendenza esterna |
| `form-micro` | Nessuna | Feedback visivo sugli input del form (focus, validazione, stato invio) |
| `nav-micro` | Nessuna | Indicatore attivo nel nav che si sposta tra le voci al click/scroll |

Se si sceglie `aos-library`, avvisare che aggiunge una dipendenza CDN esterna
e chiedere conferma prima di procedere.

---

### Piano: Premium (€1.499)
Tutto quanto sopra, più opzioni elaborate. Per queste chiedere **sempre**
se il cliente prioritizza velocità di caricamento o ricchezza visiva
(sono in tensione — non si possono massimizzare entrambe).

| Opzione | Libreria | Nota performance |
|---|---|---|
| `parallax-light` | Nessuna (CSS transform + scroll event) | Effetto parallasse leggero sullo hero — impatto moderato |
| `section-transitions` | Nessuna o AOS | Transizioni fluide tra sezioni al cambio pagina o allo scroll |
| `gsap-animations` | GSAP via CDN (~70 KB gzip) | Animazioni complesse e timeline — segnalare esplicitamente il peso prima di procedere |

**Regola GSAP:** Se si valuta GSAP o qualsiasi libreria con peso > 30 KB,
segnalare esplicitamente: "Questa libreria aggiunge circa X KB al peso della
pagina, il che può influire sui tempi di caricamento su mobile. Vuoi procedere
ugualmente o preferisci un approccio più leggero?"

---

## 6. Struttura progetto consigliata

```
[anno]-[nome-cliente]-[tipo-sito]/
├── index.html
├── [pagina-2].html        # solo Standard e piani superiori
├── css/
│   └── custom.css         # sovrascritture Tailwind + prefers-reduced-motion
├── js/
│   └── main.js
├── img/
│   └── [immagini cliente]
└── netlify.toml           # redirect, header sicurezza
```

---

## 7. Checklist prima di consegnare

- [ ] Firma Vektora presente e linkata nel footer di ogni pagina
- [ ] Nessun dato cliente inventato (tutti i placeholder tra `[PARENTESI QUADRE]`)
- [ ] Tutte le immagini hanno `alt` descrittivo
- [ ] Tutti i bottoni icon-only hanno `aria-label`
- [ ] `prefers-reduced-motion` incluso nel CSS
- [ ] Nessun `</script>` nudo nei commenti JS
- [ ] Animazioni coerenti con il piano acquistato
- [ ] Test su mobile (viewport 375px minimo)
- [ ] Contrasti colore verificati (WCAG AA)
- [ ] `netlify.toml` con header di sicurezza di base (`X-Frame-Options`, `X-Content-Type-Options`)

---

## 8. Riferimenti rapidi

- Snippet animazioni → [`snippets/animations.md`](snippets/animations.md)
- Sito Vektora → [vektora-web.com](https://vektora-web.com)
