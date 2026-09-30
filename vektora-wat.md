---
title: Agent Instructions — Vektora WAT Framework
tags: [claude-code, workflow, wat, framework, agenti, strumenti, templates, firma-vektora, immagini, dark-mode, animazioni, seo, performance]
created: 2025-06-16
updated: 2026-09-30
tipo: istruzioni-agente
stato: attivo
versione: 1.5
---

# Agent Instructions — Vektora WAT Framework

> **Scopo di questo file:** regole di lavoro per i progetti cliente Vektora (architettura WAT, footer, immagini, SEO, dark mode, animazioni, pagine obbligatorie). Vive in `Claude/`, unica fonte di riferimento: si modifica qui, non si ricrea altrove.
> I percorsi relativi citati (`workflows/`, `tools/`, `templates/`, `assets-vektora/`, `Clienti Vektora/`) sono relativi a `Vektora Site/`. Direttive per piano (Starter/Standard/Pro/Premium) → `DESIGN.md` in questa cartella, quando esiste.

Stai lavorando dentro il framework **WAT** (Workflows, Agents, Tools).
Questa architettura separa le responsabilità: l'AI gestisce il ragionamento,
il codice deterministico gestisce l'esecuzione. Questa separazione è ciò che
rende il sistema affidabile.

---

## L'architettura WAT

### Layer 1: Workflows (Le istruzioni)

- File Markdown in `workflows/`
- Ogni workflow definisce: obiettivo, input richiesti, tool da usare,
  output attesi, gestione degli edge case
- Scritti in linguaggio semplice — come briefare un collaboratore

### Layer 2: Agent (Il decisore)

Questo è il tuo ruolo. Sei responsabile del coordinamento intelligente:

- Leggi il workflow pertinente
- Esegui i tool nella sequenza corretta
- Gestisci i fallimenti in modo elegante
- Chiedi chiarimenti quando manca qualcosa di essenziale

> [!warning] Regola operativa fondamentale
> Se devi creare un componente HTML, non generarlo direttamente.
> Leggi `workflows/crea-componente.md`, verifica gli input richiesti,
> poi scrivi il codice seguendo il workflow.
> (Lo script `tools/genera_componente.py` non è ancora disponibile —
> non cercarlo, non crearlo senza autorizzazione esplicita)

### Layer 3: Tools (L'esecuzione)

- Script Python in `tools/` che fanno il lavoro concreto
- Generazione file HTML/CSS/JS, ottimizzazione immagini, deploy, operazioni su file
- Credenziali e API key in `.env` — mai altrove
- Script consistenti, testabili, veloci

> [!note] Perché questo schema funziona
> Quando l'AI gestisce ogni step direttamente, l'accuratezza crolla.
> Se ogni step ha 90% di accuratezza, dopo 5 step sei al 59%.
> Delegando l'esecuzione a script deterministici, l'AI rimane focalizzata
> su orchestrazione e decisioni — dove eccelle.

---

## Come operare

### 1. Cerca tool esistenti prima di crearne di nuovi

Prima di costruire qualcosa, controlla `tools/` in base a ciò che il workflow
richiede. Crea nuovi script solo quando non esiste nulla per quel task.

### 2. Quando qualcosa fallisce

1. Leggi l'intero messaggio di errore e il trace
2. Correggi lo script e ritesta
3. Verifica che la correzione funzioni
4. Aggiungi note o correggi dettagli tecnici nel workflow esistente
   (non creare nuovi workflow né riscrivere la struttura di uno esistente
   senza autorizzazione esplicita — vedi regola sotto)

> [!warning] Prima di rieseguire script con costi
> Se lo script usa API a pagamento (es. chiamate AI, servizi terzi),
> chiedi conferma prima di rieseguire dopo un errore.

### 3. Mantieni i workflow aggiornati

Puoi aggiungere note o correggere dettagli tecnici in workflow esistenti
dopo aver risolto un problema. Non creare nuovi workflow né riscrivere
la struttura di uno esistente senza autorizzazione esplicita.

> [!danger] Regola ferrea sui workflow
> Non creare né riscrivere la struttura di workflow esistenti senza
> autorizzazione esplicita. I workflow sono istruzioni operative —
> vanno raffinati con note puntuali, non riscritti da zero.

---

## Struttura file e cartelle

```
Vektora Site/
├── (regole: Claude/vektora-wat.md)  # Questo file, fuori da questa cartella
├── .gitignore
├── assets-vektora/                # Asset di firma Vektora
│   ├── logo-firma.svg             (oro, per footer scuri)
│   └── logo-firma-mono.svg        (nero, per footer chiari)
├── templates/                     # Libreria template — letta da crea_struttura_progetto.py
│   ├── parrucchiere-base.html     ← esistente
│   ├── dentista-base.html         ← esistente
│   ├── ristorante-base.html       ← esistente
│   ├── hotel-base.html            ← esistente
│   ├── idraulico-base.html        ← esistente
│   │   [--- da creare quando serve ---]
│   ├── laboratorio-odontotecnico-base.html
│   ├── studio-legale-base.html
│   ├── palestra-fitness-base.html
│   ├── agenzia-immobiliare-base.html
│   ├── farmacia-base.html
│   └── centro-estetico-base.html
├── workflows/
│   ├── nuovo-progetto-cliente.md
│   ├── crea-componente.md
│   ├── ottimizza-immagini.md
│   ├── deploy-netlify.md
│   ├── crea-documentazione.md
│   └── audit-sito.md
├── tools/
│   ├── crea_struttura_progetto.py
│   ├── ottimizza_immagini.py
│   ├── genera_sitemap.py
│   ├── valida_html.py
│   └── esporta_obsidian.py
├── .tmp/
└── [anno]-[nome-cliente]-[tipo-sito]/
    ├── .env
    ├── .gitignore
    ├── .tmp/
    ├── docs/
    │   ├── brief-cliente.md
    │   ├── decisioni-tecniche.md
    │   └── changelog.md
    └── sito/
        ├── index.html
        ├── 404.html
        ├── grazie.html
        ├── privacy.html
        ├── sitemap.xml
        ├── robots.txt
        ├── favicon.svg
        ├── favicon-32x32.png
        ├── favicon-16x16.png
        ├── apple-touch-icon.png
        ├── favicon.ico
        ├── images/
        └── assets/
            └── vektora/
                ├── logo-firma.svg
                └── logo-firma-mono.svg
```

### Regola sulla cartella `templates/`

> [!tip] Come funziona la libreria template
> Quando crei un nuovo progetto cliente:
> 1. `crea_struttura_progetto.py` riceve il tipo (es. `parrucchiere`)
> 2. Cerca `templates/parrucchiere-base.html`
> 3. Se esiste → copia in `[progetto-cliente]/sito/index.html`
> 4. Se NON esiste → genera fallback "Sito in costruzione" con firma
>    Vektora e stampa avviso chiaro
>
> I file marcati "da creare quando serve" non esistono ancora —
> non tentare di copiarli come se fossero presenti.

---

## REGOLA OBBLIGATORIA — Firma Vektora nel footer

> [!danger] Sempre presente, nessuna eccezione
> Ogni sito cliente, qualsiasi pacchetto, deve avere nel footer
> logo Vektora + testo "Realizzato da Vektora" linkati a vektora-web.com.

### Blocco HTML della firma

```html
<div class="vektora-firma" style="margin-top: 0.75rem; display: flex; align-items: center; justify-content: center; gap: 0.4rem;">
  <a href="https://vektora-web.com" target="_blank" rel="noopener noreferrer"
     aria-label="Sito realizzato da Vektora"
     style="display: inline-flex; align-items: center; gap: 0.4rem; text-decoration: none; opacity: 0.7; transition: opacity 0.2s;"
     onmouseover="this.style.opacity='1'" onmouseout="this.style.opacity='0.7'">
    <img src="/assets/vektora/logo-firma.svg" alt="" width="14" height="14" aria-hidden="true" />
    <span style="font-size: 0.7rem; color: inherit;">Realizzato da Vektora</span>
  </a>
</div>
```

Versione logo da usare:
- Footer scuro → `logo-firma.svg` (oro)
- Footer chiaro → `logo-firma-mono.svg` (nero)

La firma va SOTTO il copyright del cliente, visivamente secondaria.
Se il footer ha colori non previsti da queste due varianti, segnala
all'utente e chiedi come procedere — anche la creazione di una
nuova variante logo richiede conferma esplicita (vedi regola immagini).

> [!danger] Blocco se mancano gli asset logo
> Se `assets-vektora/logo-firma.svg` o `logo-firma-mono.svg` non
> esistono, segnalare e non procedere. È l'unica condizione che
> blocca la generazione di un nuovo sito.

---

## REGOLA OBBLIGATORIA — Conferma prima di qualsiasi immagine

> [!danger] Non scegliere mai un'immagine in autonomia
> Prima di inserire, aggiungere o sostituire QUALSIASI immagine
> (hero, galleria, sfondi, icone fotografiche, varianti logo),
> fermati e chiedi sempre all'utente. Non procedere mai in autonomia.

### Le tre domande da fare sempre

1. "Hai già un'immagine reale, o servo un placeholder temporaneo?"
2. Se serve placeholder: "Foto realistica (Unsplash), texture astratta,
   o sfondo colore senza immagine?" (in italiano, come da standard)
3. "Come deve essere posizionata?" (piena larghezza con overlay /
   riquadro affiancato al testo / sfondo leggero)

### Dopo la risposta

- Immagine reale fornita → usala con commento `<!-- immagine definitiva -->`
- Placeholder scelto → aggiungi commento
  `<!-- PLACEHOLDER — sostituire con foto reale del cliente -->`

---

## Standard tecnici obbligatori

### HTML / Tailwind / JS vanilla

- **Mobile-first** — scrivi sempre per mobile prima, poi desktop
- **Accessibilità** — `alt` su tutte le immagini, `aria-label` sui
  bottoni icon-only, contrasti WCAG AA minimi, navigazione da tastiera
- **Performance** — immagini in WebP, `loading="lazy"` sulle immagini
  non hero, font precaricati con `<link rel="preload">`
- **Tailwind** — usa solo classi predefinite CDN
- **Variabili CSS** — colori e font sempre in `:root`
- **Firma Vektora** — presente nel footer di ogni pagina (vedi regola)
- **Immagini** — mai inserite senza conferma esplicita (vedi regola)

### SEO e file obbligatori

Ogni sito prodotto deve avere questi file e tag:

**Tag HTML in ogni pagina:**
- `<title>` univoco e descrittivo
- `<meta name="description">` con parole chiave locali
- Tag Open Graph (`og:title`, `og:description`, `og:type`, `og:url`)
- `<link rel="canonical">` con URL assoluto HTTPS
- `<meta name="viewport">`

**File nella root del sito:**
- `sitemap.xml` — generato con `tools/genera_sitemap.py`
- `robots.txt` — permette tutto tranne `.env` e `/.tmp/`
- `favicon.svg` + `favicon-32x32.png` + `favicon-16x16.png`
  + `apple-touch-icon.png` + `favicon.ico`

**Tag `<head>` favicon da inserire in ogni pagina:**
```html
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
<link rel="icon" type="image/x-icon" href="/favicon.ico">
```

**Schema.org** — markup JSON-LD appropriato per tipo di attività:
- Parrucchiere → `HairSalon`
- Dentista → `Dentist`
- Ristorante → `Restaurant`
- Hotel → `Hotel`
- Idraulico → `Plumber`
- Laboratorio odontotecnico → `MedicalBusiness`
- Studio legale → `LegalService`
- Palestra → `SportsActivityLocation`
- Agenzia immobiliare → `RealEstateAgent`
- Farmacia → `Pharmacy`
- Centro estetico → `BeautySalon`

### Pagine obbligatorie in ogni sito cliente

Oltre all'`index.html` principale, ogni sito deve avere:

**`404.html` — pagina errore personalizzata**
Non la pagina bianca generica del browser. Deve avere:
- Stile coerente con il sito (navbar + footer)
- Messaggio semplice ("Pagina non trovata")
- Link alla homepage e ai contatti
- Nessun riferimento tecnico all'errore

**`grazie.html` — pagina di ringraziamento post-form**
Mostrata dopo l'invio del form contatti (redirect da Netlify Forms).
Permette di tracciare le conversioni. Deve avere:
- Conferma che il messaggio è stato ricevuto
- Tempo di risposta atteso (es. "Ti risponderemo entro 24 ore")
- Link per tornare alla homepage
- NON un nuovo form (non invitare a ri-inviare)

**`privacy.html` — Privacy Policy**
Obbligatoria per legge (GDPR). Placeholder con struttura base:
chi raccoglie i dati, quali dati, perché, per quanto tempo,
contatto del titolare. Avvisare sempre il cliente che va
fatta revisionare da un professionista legale prima della
pubblicazione.

> [!warning] Mai pubblicare il sito senza privacy.html
> Un sito con form di contatto senza Privacy Policy visibile
> e linkabile viola il GDPR. Il link va nel footer di ogni pagina.

**Cookie banner**
Se il sito usa Google Analytics, Google Maps embed, o altri
servizi terzi che impostano cookie: aggiungere un banner
di consenso cookie minimo (accetta / rifiuta).
Se il sito non usa nessun servizio terzo con cookie traccianti,
il banner non è necessario — specificare nel codice con un
commento quale scelta è stata fatta e perché.

### Conferma email automatica al form

Quando viene implementato un form di contatto con Netlify Forms:
- Configurare una notifica automatica a Netlify verso l'email
  del titolare (si imposta in Project → Forms → Notifications)
- Configurare anche una email di conferma automatica all'utente
  che ha compilato il form, se Netlify lo supporta nel piano attivo
- In alternativa, fare redirect a `grazie.html` dopo l'invio

### Sistema tema chiaro/scuro (Dark/Light Mode)

Ogni sito prodotto deve supportare il tema chiaro/scuro:

**Variabili CSS in `:root` (tema scuro, default):**
```css
:root {
  /* I colori specifici variano per template — questi sono gli slot */
  --sfondo:       [colore scuro principale];
  --sfondo-card:  [colore scuro secondario];
  --bordo:        [colore bordi];
  --testo:        [colore testo principale];
  --testo-soft:   [colore testo secondario];
  --accento:      [colore brand — invariato tra i temi];
}
```

**Variabili CSS in `:root[data-theme="light"]` (tema chiaro):**
```css
:root[data-theme="light"] {
  --sfondo:       [colore chiaro caldo — NO bianco puro #FFFFFF];
  --sfondo-card:  [colore chiaro secondario];
  --bordo:        [colore bordi chiari];
  --testo:        [colore testo scuro caldo — NO nero puro #000000];
  --testo-soft:   [colore testo secondario chiaro];
  --accento:      [stesso valore del tema scuro — invariato];
}
```

**Supporto automatico via media query:**
```css
@media (prefers-color-scheme: light) {
  :root:not([data-theme]) {
    /* Stesse variabili del tema chiaro */
  }
}
```

**Transizione fluida al cambio tema:**
```css
*, *::before, *::after {
  transition: background-color 0.3s ease, color 0.3s ease,
              border-color 0.3s ease;
}
```
(Non applicare a elementi che hanno già `transition` proprie
per evitare conflitti)

**Bottone toggle nel navbar:**
- Forma: cerchio 36px, bordo `var(--accento)`, sfondo trasparente
- Icona: SVG inline sole (tema scuro attivo) / luna (tema chiaro attivo)
- `aria-label="Cambia tema"` per accessibilità
- Logica: salva preferenza in `localStorage` con chiave
  `[nome-progetto]-theme`, applicata al caricamento pagina

**Palette standard per sito Vektora:**
- Scuro: sfondo `#0D0D0D`, card `#1A1A1A`, testo `#E8E0D0`
- Chiaro: sfondo `#FAFAFA`, card `#F0EDE8`, testo `#1A1510`
- Accento oro `#C9A84C` — invariato in entrambi i temi

### Animazioni

**Scroll animations (Intersection Observer):**

Classi CSS obbligatorie in ogni stylesheet:
```css
.fade-in {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.fade-in.visible { opacity: 1; transform: translateY(0); }
.fade-in-delay-1 { transition-delay: 0.1s; }
.fade-in-delay-2 { transition-delay: 0.2s; }
.fade-in-delay-3 { transition-delay: 0.3s; }

@media (prefers-reduced-motion: reduce) {
  .fade-in { opacity: 1; transform: none; transition: none; }
}
```

Inizializzazione JS:
```js
function initScrollAnimations() {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15 });
  document.querySelectorAll('.fade-in').forEach(el => observer.observe(el));
}
```

Elementi da animare: card servizi, sezioni statistiche, casi studio
portfolio, valori "chi siamo", form contatti. Per card in griglia:
prima `.fade-in`, seconda `.fade-in .fade-in-delay-1`, terza
`.fade-in .fade-in-delay-2`.

**Hover transitions:**
- Bottoni: `transform: translateY(-1px)` su hover, `translateY(0)`
  su active
- Card: `border-color` e `transform: translateY(-4px)` già presenti
  — verificare che siano fluidi (0.25-0.3s ease)
- Link navbar: sottolineatura che si espande da sinistra con `::after`

**Regole generali animazioni:**
- Solo CSS transitions e Intersection Observer — niente GSAP, AOS
  o librerie esterne senza autorizzazione esplicita
- Anima solo `transform` e `opacity` — mai `width`, `height`,
  `top`, `left` (costosi per il browser)
- Delay massimo: 0.3s — oltre sembra lento
- Durata entrata: 0.5-0.7s ease
- `prefers-reduced-motion` sempre rispettato

### Qualità del codice

- Commenti in italiano per le sezioni principali
- Placeholder tra `[ ]` per tutti i dati del cliente
  (`[NOME CLIENTE]`, `[TELEFONO]`, `[CITTÀ]`, ecc.)
- Nessuna credenziale o dato sensibile nel codice

> [!warning] Bug noto — tag script nei commenti JS
> Se un commento JS multi-riga contiene la stringa `</script>`
> nel testo, il browser la interpreta come chiusura tag anche
> dentro un commento — tutto il codice successivo diventa testo
> visibile in pagina. Scrivere sempre `<\/script>` con il backslash
> nei commenti JavaScript che menzionano questo tag.

### Quando crei un nuovo template in `templates/`

- Nome file: `[tipo-attivita]-base.html` (es. `palestra-fitness-base.html`)
- Copre il piano Starter per quel tipo di attività
- Contiene fin dalla creazione:
  - Firma Vektora nel footer
  - Sistema dark/light mode con variabili `:root` e `:root[data-theme]`
  - Classi `.fade-in` sugli elementi principali
  - `sitemap.xml`, `robots.txt`, favicon tag nel `<head>`
  - Link a `privacy.html` nel footer
  - Schema.org appropriato per il settore
  - Pagine `404.html` e `grazie.html` nella stessa cartella
- Tutti i dati del cliente sono placeholder tra `[ ]`
- Va testato visivamente (dark e light mode, mobile e desktop)
  prima di essere considerato pronto

---

## Workflow disponibili

```
workflows/
├── nuovo-progetto-cliente.md    # Setup cartelle, git, Netlify
├── crea-componente.md           # Genera componente HTML/Tailwind
├── ottimizza-immagini.md        # Compressione WebP con Pillow
├── deploy-netlify.md            # Push GitHub → deploy automatico
├── crea-documentazione.md       # Genera nota Obsidian da codice
└── audit-sito.md                # Checklist SEO, accessibilità, performance
```

---

## Tool disponibili

```
tools/
├── crea_struttura_progetto.py   # Crea cartelle + copia template + genera file base
│                                 # --nome, --anno, --tipo, --pacchetto (tutti obbligatori)
├── ottimizza_immagini.py        # Comprime in WebP con Pillow
├── genera_sitemap.py            # Crea sitemap.xml dalla struttura del sito
├── valida_html.py               # Controlla HTML con W3C validator API
└── esporta_obsidian.py          # Formatta documentazione per Obsidian
```

### Argomenti `crea_struttura_progetto.py`

| Argomento | Obbligatorio | Esempio | Effetto |
|---|---|---|---|
| `--nome` | sì | `"Mario Rossi"` | → `mario-rossi` |
| `--anno` | sì | `2026` | Validato 4 cifre |
| `--tipo` | sì | `parrucchiere` | Cerca `templates/parrucchiere-base.html` |
| `--pacchetto` | sì | `Starter` | Compila frontmatter del brief (Starter / Standard / Pro / Premium) |

> [!warning] Edge case del tool
> Template mancante → avviso + fallback "Sito in costruzione" con firma,
> non bloccare la generazione.
> Asset logo mancanti → avviso + BLOCCA — la firma è non negoziabile.
> Campo `--pacchetto` sempre nel frontmatter, mai `TBD` se fornito.

---

## Gestione clienti

Naming convention cartelle:
```
[anno]-[nome-cliente]-[tipo-sito]/
Esempio: 2026-mario-rossi-parrucchiere/
```

Frontmatter Obsidian di ogni progetto:
```yaml
---
title: [Nome Cliente] — [Tipo Sito]
tags: [cliente, [categoria], [pacchetto]]
created: [data]
pacchetto: Starter / Standard / Pro / Premium
stato: in-sviluppo / consegnato / manutenzione
prezzo: €XXX
manutenzione: €XX/mese
---
```

---

## Bottom line

Stai tra quello che voglio (workflows) e quello che viene fatto (tools).
Il tuo compito: leggere le istruzioni, prendere decisioni intelligenti,
chiamare i tool giusti, recuperare dagli errori, e migliorare il sistema
nel tempo.

**Rimani pragmatico. Rimani affidabile. Continua a imparare.**

---

## Changelog

**v1.0 (2026-06-17)** — Prima versione con architettura WAT, struttura
cartelle e standard tecnici base.

**v1.1 (2026-06-17)** — Aggiunta cartella `templates/` mancante.
`crea_struttura_progetto.py` generava placeholder vuoto invece di
copiare il template esistente. Risolto definendo `templates/` come
libreria centrale.

**v1.2 (2026-06-17)** — Aggiunta regola obbligatoria firma Vektora
nel footer di ogni sito cliente (logo + testo, tutti i pacchetti,
nessuna eccezione).

**v1.3 (2026-06-17)** — Aggiunta regola di conferma obbligatoria
prima di qualsiasi immagine. Claude Code non sceglie mai immagini
in autonomia.

**v1.4 (2026-06-17)** — Aggiornamento esteso:
- Sistema dark/light mode obbligatorio per tutti i siti
- Standard animazioni scroll (Intersection Observer) + hover
- SEO: sitemap.xml, robots.txt, favicon, Schema.org per settore
- Pagine obbligatorie: 404.html, grazie.html, privacy.html
- Cookie banner quando necessario
- Immagini in WebP con lazy loading
- Font preload
- Conferma email automatica al form
- Nuove tipologie template: laboratorio odontotecnico, studio legale,
  palestra fitness, agenzia immobiliare, farmacia, centro estetico
- Corretta ambiguità A1/A2: rimosso riferimento a `genera_componente.py`
  inesistente, corretto nome workflow `crea-componente.md`
- Corretta contraddizione C1: varianti logo richiedono conferma utente
- Corretta contraddizione C2: edge case tool separati visivamente
- Spostato [!tip] Layer 2 a [!warning] per peso corretto
- Changelog spostato in fondo al file

---

**v1.5 (2026-09-30)** — Piani allineati a Starter (299€) / Standard (549€) /
Pro (899€) / Premium (1.499€), che sostituiscono "Base". Il file vive ora in
`Claude/vektora-wat.md`. Naming clienti confermato `[anno]-[nome]-[tipo]`.

---

## File correlati

- [[sito-vektora-brief]]
- [[template-parrucchiere-base]]
- [[template-dentista-base]]
- [[deploy-netlify-procedura]]
- [[procedura-gestione-file-netlify]]
- [[toolkit-servizi-vektora]]
