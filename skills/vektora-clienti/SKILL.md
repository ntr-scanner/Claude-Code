---
name: vektora-clienti
description: >
  Gestisce la struttura cartelle dei clienti Vektora dentro "Clienti Vektora"
  (root del progetto Vektora Site): naming fisso "[anno]-[nome-cliente]-[tipo-sito]",
  README.md, /materiali, /sviluppo. Da invocare con /vektora-clienti ogni volta che si
  aggiunge un nuovo cliente Vektora.
triggers:
  - nuovo cliente Vektora
  - aggiungi cliente Vektora
  - vektora-clienti
---

# Skill: vektora-clienti

Gestisci la struttura cartelle dei clienti dell'agenzia **Vektora** dentro
`Vektora Site/Clienti Vektora/`. Segui queste regole senza eccezioni, senza
chiedere conferma sulla struttura stessa (è fissa) — chiedi conferma solo sui
dati mancanti del cliente specifico.

---

## 1. Percorso base

```
Vektora Site/
└── Clienti Vektora/          ← crea se non esiste ancora
    └── [anno]-[nome-cliente]-[tipo-sito]/
```

Se `Vektora Site/Clienti Vektora/` non esiste, creala prima di procedere.
Non chiedere conferma per questo — è la struttura fissa del progetto.

---

## 2. Naming della cartella cliente

Standard unico (lo stesso di `vektora-wat.md`):

```
[anno]-[nome-cliente]-[tipo-sito]
Esempio: 2026-mario-rossi-parrucchiere
```

- `[anno]`: 4 cifre, anno di inizio lavori.
- `[nome-cliente]` e `[tipo-sito]`: minuscolo, parole separate da trattino, senza accenti né caratteri speciali (`Delizie del Maghreb` → `delizie-del-maghreb`).
- Nessuna numerazione progressiva: non esiste più il formato `Cliente [N] - ...`.
- Se esiste già una cartella con lo stesso nome, segnalalo e chiedi come procedere; non sovrascrivere.
- Le cartelle create con il vecchio formato (`Cliente 1 - piccolo1929`, `Cliente 2 - vektora-ct-search`) non si rinominano senza conferma dell'utente.

---

## 3. Dati richiesti prima di creare la cartella

Se non forniti esplicitamente nella richiesta dell'utente, chiedi sempre:
1. Nome esatto del cliente
2. Tipo di sito / settore di lavoro (es. parrucchiere, dentista) e piano acquistato (Starter / Standard / Pro / Premium)

Non procedere alla creazione senza questi due dati. Non inventarli mai.

---

## 4. Struttura interna di ogni cartella cliente

Alla creazione, genera automaticamente:

```
[anno]-[nome-cliente]-[tipo-sito]/
├── README.md
├── materiali/      (vuota — testi/foto/loghi ricevuti dal cliente)
└── sviluppo/       (vuota — file del sito/progetto)
```

### Template `README.md`

```markdown
# [Nome Cliente]

- **Settore:** [Settore di lavoro]
- **Piano:** [Starter / Standard / Pro / Premium]
- **Data inizio lavori:** [data odierna, formato YYYY-MM-DD]
- **Stato:** in corso

## Note

```

Il campo Note resta vuoto (solo l'intestazione `## Note`), salvo istruzioni
esplicite dell'utente per quel cliente specifico (es. cliente pro-bono).

---

## 5. Comportamento

- Non chiedere l'anno all'utente: usa l'anno corrente salvo indicazione diversa
- Non chiedere conferma sulla struttura di cartelle/file (è fissa) — chiedi
  conferma solo sui dati mancanti del cliente (nome, settore)
- Applica questa stessa logica ogni volta che l'utente chiede di aggiungere
  un nuovo cliente Vektora, senza bisogno che le regole vengano ripetute
