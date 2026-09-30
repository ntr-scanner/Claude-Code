---
name: project-vektora-blog
description: "Blog Eleventy aggiunto al sito Vektora vero e proprio (vektora-site-main), scoped a /blog, con paginazione e categorie"
metadata: 
  node_type: memory
  type: project
  originSessionId: 866739fb-b82e-4b77-a206-b96dd02cbb2c
  modified: 2026-07-21T08:28:40.874Z
---

Il repo **`Vektora Site/vektora-site-main/`** (collegato a Netlify via GitHub,
remote `ntr-scanner/vektora-web`) è il sito Vektora **vero e proprio**, diverso
dai progetti clienti generati con il framework WAT descritto in [[project-vektora]].
Resta HTML statico puro (Tailwind CDN, JS vanilla, no build) per tutte le pagine
esistenti.

Aggiunto (2026-07-21) un blog generato con **Eleventy 3**, scoped SOLO a `/blog`:

- `blog-src/` — sorgente markdown (dove n8n scriverà le bozze future), con
  `_includes/layout.njk` (shell HTML condivisa: stesso head/header/footer/
  script del resto del sito), `_includes/articolo.njk` (layout articolo),
  `_includes/macros.njk` (card riutilizzabile), `index.njk` (indice paginato,
  9/pagina), `tag.njk` (pagine categoria non paginate)
- `.eleventy.js` — `dir.input: "blog-src"`, `dir.output: "blog"` — Eleventy
  non può scrivere fuori da `/blog`, quindi il resto del sito è strutturalmente
  al sicuro da questo build
- `netlify.toml` — build command `npx @11ty/eleventy`, publish resta `.`
  (root, invariato) — il build genera `/blog` che si unisce alle pagine
  statiche esistenti nella stessa publish dir
- Front matter articoli: `layout: articolo.njk`, `tags: [articolo, <Categoria>]`,
  `categoria`, `titolo` (non `title` — collide con la variabile Eleventy usata
  per il tag `<title>`), `date`, `estratto`, `copertina` (opzionale)

**Why:** il nome front matter `titolo` invece di `title` è deliberato — Eleventy
espone il front matter direttamente come variabili di template, quindi usare
`title` in un articolo sovrascrive silenziosamente ciò che il layout esterno
si aspetta di leggere per il tag `<title>` della pagina.

**Why (bug non ovvio):** con `dir.output: "blog"`, tutti gli `url` calcolati
automaticamente da Eleventy (`post.url`, `pagination.hrefs`, ecc.) sono relativi
a quella cartella e NON includono il prefisso `/blog` che hanno una volta
pubblicati. Esiste un filtro `bloglink` in `.eleventy.js` che va sempre usato
per costruire `href` visibili nell'HTML a partire da url calcolati da Eleventy
(vedi `macros.njk`, `index.njk`). I path scritti a mano (breadcrumb, pillole
categoria, CTA) restano invece letterali con `/blog/...` e non vanno filtrati.

**Why (altro bug non ovvio):** i valori dinamici nel front matter (es.
`title: "{{ titolo }} — Blog Vektora"`) NON vengono renderizzati da Eleventy
per default — solo `permalink` ha pre-processing speciale. Serve
`eleventyComputed:` nel front matter per qualsiasi valore che deve dipendere
da altri campi (vedi `articolo.njk` e `tag.njk`).

**Aggiornamento (2026-07-21):** aggiunta gestione copertine articoli.
`blog-src/image/` contiene le immagini (nomi leggibili con spazi/apostrofi,
es. "3 errori di sicurezza nelle PMI.png"), copiate via
`addPassthroughCopy({"blog-src/image": "image"})` in `.eleventy.js` verso
`blog/image/`. Front matter articolo: `copertina: "/blog/image/<nome file>"`
(path con spazi non codificato a mano — il filtro `encodeUri` lo fa in
ogni punto di rendering). Vedi [[feedback-blog-immagini-copertina]] per la
regola su come/quando collegare le immagini ai nuovi articoli.

**How to apply:** quando si aggiungono nuovi articoli reali (o li scrive n8n),
basta droppare un `.md` in `blog-src/` con quel front matter — build e
paginazione si aggiornano da soli. Se in futuro serve paginare anche le
pagine categoria (oggi mostrano tutti gli articoli di quella categoria senza
limite), è un'estensione volontariamente rimandata per non overengineerare
prematuramente.
