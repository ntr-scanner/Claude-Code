# Server in locale e web app personali: regole

Da leggere **prima** di creare o modificare un server locale (Python o Node) o una web app personale: dashboard, tool,
lettori, tracciatori. Per i siti dei clienti Vektora valgono `DESIGN.md` e `vektora-wat.md`; per gli script `SCRIPT.md`.

Nato il 2026-10-27 da quello che è emerso lavorando su Ayanokoji System. **Ayanokoji è una fonte di regole, non un modello
da copiare**: niente cloni del suo server, dei suoi moduli o della sua struttura. Ogni progetto prende solo le regole
che gli servono, scelte con le domande qui sotto.

## 1. Prima di scrivere codice: le domande da fare

Le risposte si chiedono **tutte insieme, all'inizio**, e si scrivono nel README del progetto. Così il progetto si costruisce
una volta sola, senza rifarlo pezzo per pezzo a ogni richiesta. Si chiede solo quello che non si ricava dalla richiesta.

**Scopo e dati**
1. Cosa deve fare, in una frase? Chi lo usa: solo tu o anche altri?
2. Quali dati salva? Ci sono dati sensibili: salute, persone, soldi, password, posizione?
3. Quanto possono crescere i dati: decine, migliaia o milioni di voci? Servono file o un database?

**Dove gira**
4. Su quali sistemi: Windows, Ubuntu, telefono? In quale cartella? Solo su questo PC o anche dalla rete di casa?
5. Si sincronizza tra più PC (Syncthing, git)? Il server gira su un solo PC alla volta o su più insieme?
6. Va acceso a mano (lanciatore), all'avvio del PC o come servizio?

**Sicurezza**
7. Serve una password per aprirlo? Serve la cifratura dei file su disco (dati sensibili + sincronizzazione = di solito sì)?
8. Esportazioni e backup devono essere cifrati?

**Interfaccia**
9. Quante sezioni avrà? Quali sono le pagine principali (da mettere come pulsanti in alto fin dall'inizio)?
10. Si usa anche dal telefono (390 px)? Tema chiaro, scuro o tutti e due?

**Backup e manutenzione**
11. Quanti backup tenere e per quanto? Un archivio mensile?
12. Import da file (quali formati, anche fatti da altre AI)? Export?
13. Test automatici: solo logica o anche nel browser?

## 2. Regole del server

- **Ascolta su 127.0.0.1** salvo richiesta esplicita. Con la rete: avviso chiaro in pagina e controllo dell'host.
- **Una sola istanza**: lockfile nella cartella temporanea del PC, mai in quella sincronizzata. Lanciatore con `--stato`, `--spegni`, `--riavvio`.
- **Controlli su ogni richiesta**: Host esatto (contro il DNS rebinding), Origin e `Sec-Fetch-Site` uguali alla propria origine, token di sessione per le API, nessun CORS. Intestazioni: CSP senza `unsafe-inline`, `frame-ancestors 'none'`, `nosniff`, `no-referrer`.
- **Scritture atomiche**: file temporaneo, fsync, rename. Un `.tmp` rimasto da un crash si recupera all'avvio, non si butta.
- **Conflitti**: revisione + `If-Match` → 409 se un'altra scheda ha salvato prima; la pagina offre «Unisci». Nessuna scrittura cieca.
- **Codice e dati separati**: il codice in un repo git, i dati e i log in una cartella accanto, fuori dal repo (`.gitignore` di sicurezza).
- **Registro dei moduli o delle sezioni** in un file solo, letto a caldo; regole di validazione anche lato server (il browser non è una garanzia).
- **Log senza contenuti**: solo tipo di evento e motivo tecnico.

## 3. Dati e sincronizzazione tra PC

- Se la cartella si sincronizza (Syncthing), **un solo server per volta sulla stessa cartella dati**. Il server lascia un «battito» (file con PC, PID e ora, aggiornato ogni 30 s) e avvisa se ne vede un altro.
- Tra PC diversi meglio **Pull e Push espliciti**: ogni PC scrive solo nella sua casella; l'altro la legge e unisce. Le impostazioni «solo di questo PC» non stanno in un file che si sincronizza.
- Le unioni non perdono nulla: tombstone per le cancellazioni, il più recente vince per campo, mai una somma di contatori.
- Le copie arrivate da fuori diventano **copie in sospeso** che la pagina unisce; mai sovrascrivere i dati di qui.
- Ogni impostazione modificabile dalla pagina si salva subito e **resta uguale ai riavvii**. Quando un'impostazione si riscrive, si conservano le altre (`{...vecchie, nuova}`), mai un oggetto nuovo da zero.
- Letture e scritture dello stesso file di impostazioni da più thread passano da un lock.

## 4. Backup

- Un backup al giorno; uno prima di ogni operazione rischiosa (import, ripristino, migrazione, cifratura, cambio password).
- A fine mese i giornalieri diventano **un solo archivio mensile compresso e incrementale** in una cartella propria (`backup/mensili/`); i giornalieri si cancellano solo dopo che il mensile è stato scritto e **riletto**.
- Ogni giorno resta ripristinabile. Un archivio illeggibile non si cancella mai.
- Prova vera prima di dire «funziona»: simulare il cambio di mese su una **copia** dei backup reali e controllare che ogni giorno si ricostruisca identico.

## 5. Protezione con password e cifratura

- Se ci sono dati sensibili e i file si sincronizzano, il blocco della pagina **non basta**: servono i file cifrati su disco.
- Crittografia collaudata, mai inventata: AES-256-GCM (libreria `cryptography`), chiave da `scrypt(password, sale)`. Sul disco solo sale e una «prova» per verificare la password, mai la password.
- Ogni file cifrato porta il suo sale e una firma iniziale (`AYK1` in Ayanokoji): un file in chiaro si legge com'è, così l'attivazione a metà non rende nulla illeggibile.
- La password si normalizza sempre allo stesso modo (spazi ai lati tolti, Unicode NFC): niente falsi «password sbagliata».
- Cambio password: le chiavi vecchie restano leggibili con la nuova (avvolte nel file di configurazione), poi si ricifra tutto. Un'interruzione non rende nulla illeggibile.
- Blocco: cookie `HttpOnly` + `SameSite=Strict` che scade dopo N minuti di inattività; la password si chiede **in una finestra sopra la pagina**, senza cambiare pagina, così le modifiche non salvate restano.
- Sempre l'avviso: **senza password i dati non si recuperano**, tenerla in Bitwarden.

## 6. Interfaccia

- **Pagine con pulsanti in alto** (non una pagina lunghissima): la prima è quella che si usa ogni giorno (es. «In lettura», «Stai giocando», «Ripasso di oggi»); la pagina scelta resta nell'indirizzo (`#pagina`). I vecchi collegamenti a un riquadro aprono la sua pagina.
- I pulsanti delle pagine dentro il contenuto sono **staccati sopra e sotto**, mai incollati ai riquadri.
- **Pochi pulsanti in testata** (2-4). Una pagina con tanti gruppi (es. 7 gruppi di regole) non diventa 7 pulsanti in alto: resta un pulsante solo, e dentro la pagina i gruppi sono **schede sottolineate** (una barra di schede come in Galanteria), con un gruppo visibile alla volta.
- Un elemento nuovo ha tutto quello che hanno i suoi simili (stessa disposizione, stessi controlli): prima si guarda come lo fa una sezione già esistente che l'utente indica.
- **Elenchi lunghi compatti**: una riga per gruppo (nome, numeri, barra di avanzamento); aperto, una riga per voce che si apre per leggerla o modificarla. Mai tutte le voci aperte con tutti i pulsanti.
- **Tabelle «piano»**: colonne raggruppate per periodo, riga corrente evidenziata, stati come piccole etichette (fatto / mancato), testo secondario sotto il titolo.
- «Prossimo consigliato» in cima alla pagina principale quando c'è un piano da seguire, con il criterio modificabile dall'utente (es. piattaforme, generi).
- Testo sempre con `textContent`, mai `innerHTML` con dati dell'utente o dei file importati.
- Mobile a 390 px senza scorrimento orizzontale (attenzione ai testi lunghi in griglie: `minmax(0, 1fr)` e `min-width: 0`), pulsanti alti almeno 44 px, colori da variabili del tema (chiaro e scuro).
- **Moduli di inserimento**: dopo «Aggiungi» riuscito i campi si svuotano per la voce successiva; con un errore il testo resta. Se la pagina ridisegna e ricopia i campi scritti (bozze), i campi si svuotano **prima** del ridisegno: `const err = azione(...); if (!err) campo.value = ''; salvaERidisegna(err)`. Mai `if (salvaERidisegna(...)) campo.value = ''`: svuota il campo vecchio, già tolto dalla pagina. Un test statico lo controlla.
- Stati vuoti chiari («Ancora nessuna voce: aggiungila da …»), mai un riquadro vuoto o nascosto senza spiegazione.

## 7. Import ed export

- Import tollerante: CSV (anche col `;` e il BOM di Excel), JSON (nomi dei campi anche in inglese), tabella Markdown, testo; quiz a scelta multipla se il dominio lo prevede.
- Un pulsante **«Prompt per AI»** con il testo pronto da dare a un'altra AI per produrre il file nel formato giusto.
- Prima di importare: riepilogo (quante voci, quante scartate e perché) e conferma; doppioni saltati; backup prima.
- Un messaggio d'errore dice **perché** (es. «colonna risposta non trovata»), non solo «non valido».

## 8. Verifica prima di dire «fatto»

- Test della logica (Node `node:test` o `unittest`) e nel browser (Playwright con Edge o Brave), su **dati di prova o una copia**, mai sui dati veri.
- Dopo una modifica all'interfaccia: aprire la pagina, guardarla a 390 px e su desktop, nessun errore in console.
- Le modifiche al server arrivano al server acceso solo dopo il riavvio: dirlo sempre all'utente.
