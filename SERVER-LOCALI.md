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
- **Riavvia e Spegni nella pagina** (regola dell'utente, 2026-10-31): due bottoni nelle impostazioni, solo dal PC del server (mai dalla rete, nemmeno con PIN), con token. Spegni chiede conferma nella pagina (secondo clic), mai `confirm()` del browser. Riavvia riparte con il codice sul disco nello **stesso terminale** (`os.execv` su Linux/macOS, nuovo processo su Windows), stessa porta e PIN, senza riaprire il browser; la pagina aspetta il server e si ricarica da sola.
- **Voce nel menu delle app** (regola dell'utente, 2026-11-01): ogni server locale si apre da un'icona tra le app di Ubuntu (`~/.local/share/applications/<nome>.desktop`) **e** di Windows (collegamento `.lnk` nel menu Start, creato con PowerShell `WScript.Shell`, icona `.ico` accanto alla `.svg`). L'icona lancia `--apri` senza terminale (`pythonw` su Windows; con `pythonw` `sys.stdout`/`stderr`/`stdin` sono `None`: rimetterli su `os.devnull` prima di stampare): server acceso → apre solo la pagina; spento → lo accende staccato (output in un file di log) e poi la apre. Si crea con `--icona` (o `--collegamento`) e si **toglie o rimette dalle impostazioni del server nella pagina** (solo dal PC del server), oltre che con `--togli-icona`. Codice comune in `menu_app.py`, copia identica nei progetti (Intrattenimento e Ayanokoji System `server/`).
- **Avviso «codice aggiornato»**: `/api/ping` restituisce la versione in memoria e quella scritta nel file sul disco; se sono diverse la pagina mostra una barra «riavvia per le novità» con il bottone Riavvia (controllo all'apertura e quando la finestra torna in primo piano). Senza, le funzioni nuove della pagina ricevono «API sconosciuta» dal server vecchio. Ogni modifica al server alza `VERSION`.
- **Controlli su ogni richiesta**: Host esatto (contro il DNS rebinding), Origin e `Sec-Fetch-Site` uguali alla propria origine, token di sessione per le API, nessun CORS. Intestazioni: CSP senza `unsafe-inline`, `frame-ancestors 'none'`, `nosniff`, `no-referrer`.
- **Scritture atomiche**: file temporaneo, fsync, rename. Un `.tmp` rimasto da un crash si recupera all'avvio, non si butta.
- **Conflitti**: revisione + `If-Match` → 409 se un'altra scheda ha salvato prima; la pagina offre «Unisci». Nessuna scrittura cieca.
- **Codice e dati separati**: il codice in un repo git, i dati e i log in una cartella accanto, fuori dal repo (`.gitignore` di sicurezza).
- **Registro dei moduli o delle sezioni** in un file solo, letto a caldo; regole di validazione anche lato server (il browser non è una garanzia).
- **Log senza contenuti**: solo tipo di evento e motivo tecnico.
- **Contenuti da siti esterni passano dal server** (Musicoteca Online, 2026-11-03): con la CSP `media-src`/`img-src 'self'` la pagina non parla mai con i siti; il server gira audio e copertine (`/f/online?u=`, `/f/copertina?u=`) inoltrando `Range`, e accetta **solo URL https di host in una lista fissa** (niente SSRF verso la rete di casa). Download e altre azioni che scrivono su disco solo dal PC del server.
- **Audio e video da YouTube/SoundCloud** (Musicoteca 1.2.1): girarli con la rete di yt-dlp (`ydl.urlopen`, stesso `YoutubeDL` dell'estrazione), mai con `urllib` (googlevideo risponde 403); scegliere il formato provando 1 KB per formato dal migliore in giù (alcuni client danno indirizzi che rispondono 403); chiedere a googlevideo pezzi da 10 MB, mai `bytes=0-` (si blocca). HLS (SoundCloud) si gira pezzo per pezzo mentre arriva, con cache per i salti. I contenuti con DRM non si aggirano: messaggio chiaro e si passa oltre. Ogni errore di yt-dlp diventa un messaggio per la pagina (un'eccezione non presa chiude la connessione senza risposta).
- **Sezioni Online con contenuti per adulti** (Videoteca): chiave API dell'utente chiesta al primo ingresso (solo dal PC, file con permessi 600, mai mandata alla pagina) ed esclusione nella query dei tag che indicano minori (loli, shota, child, school, teen, petite…), sempre, anche per i «reali».
- **Codice online condiviso**: un modulo usato da più app (es. `online_wall.py` in Galleria e Videoteca) è una copia identica come la base comune: si cambia in tutte e si controlla con `sha256sum`.
- **File letti dal server dentro una cartella scelta**: percorso relativo → `resolve()` + `is_relative_to(cartella)` + estensione ammessa, altrimenti errore; risposte a pezzi con `Range` (206) per audio e video.

## 3. Dati e sincronizzazione tra PC

- Se la cartella si sincronizza (Syncthing), **un solo server per volta sulla stessa cartella dati**. Il server lascia un «battito» (file con PC, PID e ora, aggiornato ogni 30 s) e avvisa se ne vede un altro.
- Tra PC diversi meglio **Pull e Push espliciti**: ogni PC scrive solo nella sua casella; l'altro la legge e unisce. Le impostazioni «solo di questo PC» non stanno in un file che si sincronizza.
- Le unioni non perdono nulla: tombstone per le cancellazioni, il più recente vince per campo, mai una somma di contatori.
- Le copie arrivate da fuori diventano **copie in sospeso** che la pagina unisce; mai sovrascrivere i dati di qui.
- Ogni impostazione modificabile dalla pagina si salva subito e **resta uguale ai riavvii**. Quando un'impostazione si riscrive, si conservano le altre (`{...vecchie, nuova}`), mai un oggetto nuovo da zero.
- Letture e scritture dello stesso file di impostazioni da più thread passano da un lock.
- **Solo fonti legali nelle sezioni Online**: niente siti pirata (StreamingCommunity e simili, LibGen, Anna's Archive) né aggiramento di DRM o protezioni anti-bot; per libri e film: Gutenberg, Internet Archive (escludendo i prestiti `access-restricted-item`), contenuti pubblicati dai titolari.
- **Una cartella scelta dall'utente si ricorda** (regola dell'utente, 2026-11-03): mai far riscegliere la cartella a ogni apertura. Il selettore del browser non può ricordarla, quindi il percorso si scrive nelle impostazioni (solo dal PC del server) e il server lo salva in `~/.cache/<app>/` (di quel PC, fuori dalla cartella sincronizzata) e la rilegge a ogni apertura. Le chiavi dei file restano quelle di prima (percorso relativo), così ascolti, preferiti e playlist non si perdono.

## 4. Backup

- Un backup al giorno; uno prima di ogni operazione rischiosa (import, ripristino, migrazione, cifratura, cambio password).
- A fine mese i giornalieri diventano **un solo archivio mensile compresso e incrementale** in una cartella propria (`backup/mensili/`); i giornalieri si cancellano solo dopo che il mensile è stato scritto e **riletto**.
- Ogni giorno resta ripristinabile. Un archivio illeggibile non si cancella mai.
- Prova vera prima di dire «funziona»: simulare il cambio di mese su una **copia** dei backup reali e controllare che ogni giorno si ricostruisca identico.

## 5. Protezione con password e cifratura

**Regole della password = quelle di Ayanokoji System** (regola dell'utente, 2026-11-01), per ogni server con password
(oggi: Ayanokoji, Ruota, Musicoteca, Galleria, Biblioteca, Serata, Videoteca):

- **Almeno 12 caratteri** per le password nuove o cambiate; una più corta creata prima resta valida (niente cambio forzato).
- Impronta `scrypt` con **n=2^15**, r=8, p=1 (maxmem 64 MB) e sale casuale; il fattore `n` sta nel file accanto all'impronta, così le impronte vecchie (n=2^14) si verificano ancora.
- Ogni password sbagliata: **1 secondo di attesa** prima di rispondere e un messaggio unico («password sbagliata», con username «username o password sbagliati»); mai dire quale parte è sbagliata. Nei progetti di Intrattenimento in più 5 errori = 60 s di blocco per quell'indirizzo.
- **Blocco dopo 5, 10, 15, 30 o 60 minuti senza usare la pagina** (scelta nelle impostazioni, predefinito 10): attività (puntatore, tasti, rotella, tocco) condivisa tra le schede con `localStorage`, controllo ogni 20 s; scaduto il tempo la pagina chiude la sessione e mostra la finestra della password. Il server dimentica una sessione dopo 30 minuti senza richieste (o il tempo di blocco, se più lungo).
- **Blocco quando si blocca il PC** (casella nelle impostazioni, attiva di default): il server guarda lo schermo ogni 5 s (Linux `loginctl … LockedHint`, Windows `LogonUI.exe`) e chiude tutte le sessioni; dove non si sa leggere, la casella è disattivata e lo dice.
- **Sessioni solo in memoria**: dopo un riavvio del server si rimette la password. Cambiare la password chiude tutte le altre sessioni.
- Password creata dalla pagina al primo avvio **solo dal PC del server**, oppure da terminale (`--password`, che la reimposta anche se dimenticata). Cambio password, impostazioni del blocco e menu delle app solo dal PC del server.
- Impostazioni del blocco in un file a parte (`.blocco.json` / `.sicurezza.json` in Ayanokoji): non sono un segreto e si riscrivono conservando gli altri campi.
- Username e 2FA (TOTP) e cifratura dei file restano di Ayanokoji: negli altri progetti solo se l'utente li chiede.

- Se ci sono dati sensibili e i file si sincronizzano, il blocco della pagina **non basta**: servono i file cifrati su disco.
- Crittografia collaudata, mai inventata: AES-256-GCM (libreria `cryptography`), chiave da `scrypt(password, sale)`. Sul disco solo sale e una «prova» per verificare la password, mai la password.
- Ogni file cifrato porta il suo sale e una firma iniziale (`AYK1` in Ayanokoji): un file in chiaro si legge com'è, così l'attivazione a metà non rende nulla illeggibile.
- La password si normalizza sempre allo stesso modo (spazi ai lati tolti, Unicode NFC): niente falsi «password sbagliata».
- Cambio password: le chiavi vecchie restano leggibili con la nuova (avvolte nel file di configurazione), poi si ricifra tutto. Un'interruzione non rende nulla illeggibile.
- Blocco: cookie `HttpOnly` + `SameSite=Strict` che scade dopo N minuti di inattività (vedi le regole sopra); la password si chiede **in una finestra sopra la pagina**, senza cambiare pagina, così le modifiche non salvate restano.
- Finché la password non è stata inserita **lo schermo resta tutto scuro** (regola dell'utente, 2026-11-01): sfondo della finestra pieno (`::backdrop` opaco, mai trasparente o sfocato), niente sfondi/wallpaper, ruota o dati visibili dietro; anche all'apertura la pagina parte oscurata. Il server non dà né dati né immagini (sfondi compresi) senza sessione.
- Sempre l'avviso: **senza password i dati non si recuperano**, tenerla in Bitwarden.
- **Finestra della password compatibile con Bitwarden** (regola dell'utente, 2026-11-03): quando Bitwarden riempie un campo lo ingrandisce per 0,2 s (`scale(1.2)`); se il campo è largo quanto la finestra, nella `<dialog>` compare per un attimo una barra di scorrimento orizzontale. Ogni `dialog` ha `overflow-x: hidden` (fatto in Intrattenimento `base.css` e Cineteca, Scaffale Mangawa, Ayanokoji System). Prova: `input.style.transform = "scale(1.2)"` e controllare che `dialog.offsetHeight - dialog.clientHeight` resti uguale ai soli bordi.

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
- **Nessun bottone esce dal suo riquadro né va a capo da solo** (regola dell'utente, 2026-11-07), su desktop e a 390 px:
  - Campo + bottone sulla stessa riga: `display: flex` **senza** `flex-wrap`, il campo `flex: 1 1 auto; min-width: 0` (si stringe lui), il bottone `flex: none`. Bottone di aggiunta corto («+» con `aria-label` «Aggiungi»), quadrato e alto quanto il campo (44×44).
  - Mai `flex-basis: 100%` (o `width: 100%`) insieme a un margine laterale: la larghezza diventa 100% + margine ed esce. Usare `calc(100% - margine)` o togliere il margine.
  - Testi lunghi vanno a capo (`overflow-wrap: anywhere`), non spingono fuori i bottoni.
  - Prova: test nel browser che confronta `getBoundingClientRect()` del bottone con il riquadro che lo contiene, a 1280, 900 e 390 px, **con le parti richiudibili aperte** (sottoattività, dettagli): a 390 px i margini spesso sono 0 e l'errore non si vede.
- **Moduli di inserimento**: dopo «Aggiungi» riuscito i campi si svuotano per la voce successiva; con un errore il testo resta. Se la pagina ridisegna e ricopia i campi scritti (bozze), i campi si svuotano **prima** del ridisegno: `const err = azione(...); if (!err) campo.value = ''; salvaERidisegna(err)`. Mai `if (salvaERidisegna(...)) campo.value = ''`: svuota il campo vecchio, già tolto dalla pagina. Un test statico lo controlla.
- Stati vuoti chiari («Ancora nessuna voce: aggiungila da …»), mai un riquadro vuoto o nascosto senza spiegazione.
- **Sezioni «Online» con una vetrina** (regola dell'utente, 2026-11-03): aprendo la sezione, e a ogni cambio di fonte o filtro (es. «Classica»), si vede subito cosa c'è sui siti collegati (classifiche, più ascoltati, ultimi aggiornati) senza dover scrivere; la ricerca restringe. In fondo «Mostra altri» per le pagine dopo.

## 7. Import ed export

- Import tollerante: CSV (anche col `;` e il BOM di Excel), JSON (nomi dei campi anche in inglese), tabella Markdown, testo; quiz a scelta multipla se il dominio lo prevede.
- Un pulsante **«Prompt per AI»** con il testo pronto da dare a un'altra AI per produrre il file nel formato giusto.
- Prima di importare: riepilogo (quante voci, quante scartate e perché) e conferma; doppioni saltati; backup prima.
- Un messaggio d'errore dice **perché** (es. «colonna risposta non trovata»), non solo «non valido».

## 8. Verifica prima di dire «fatto»

- Test della logica (Node `node:test` o `unittest`) e nel browser (Playwright con Edge o Brave), su **dati di prova o una copia**, mai sui dati veri.
- Dopo una modifica all'interfaccia: aprire la pagina, guardarla a 390 px e su desktop, nessun errore in console.
- Test su Windows: i `subprocess.run(..., text=True)` leggono con `encoding="utf-8"` (altrimenti cp1252 fallisce su `═`, `⚙`). Dalla shell Git Bash un percorso `/c/...` passato a Python va convertito con `cygpath -w`, se no diventa `C:\c\...`.
- Le modifiche al server arrivano al server acceso solo dopo il riavvio: dirlo sempre all'utente (e indicare il bottone Riavvia della pagina).

## 9. Download dalla rete locale (regola dell'utente, 2026-11-07)

**Regola.** I download avviati da qualsiasi dispositivo della rete locale (telefono, tablet, altro PC) vengono eseguiti
sul PC host del server; i file vengono salvati nella libreria del PC; l'archivio è unico e deriva dal server, quindi dopo
il download la serie compare nell'archivio sia del telefono sia del PC senza ricaricare la pagina.
Implementazione di riferimento: Vivlío 3.1 (`Free Claude Code/Vivlos/codice/`).

- **Avvio per la rete**: il server ascolta su `0.0.0.0` solo se scelto (domanda all'avvio, `--rete` o `"rete_locale": true`
  in `dati/impostazioni.json`) e stampa nel terminale l'indirizzo da aprire dal telefono, `http://IP-DEL-PC:PORTA/`
  (es. `http://192.168.1.20:8790/`). L'IP si aggiunge all'elenco degli Host ammessi; il telefono entra con la password.
- **Firewall**: se il telefono non apre l'indirizzo, la porta è bloccata. Ubuntu: `sudo ufw status`, poi
  `sudo ufw allow <porta>/tcp`. Windows: «Consenti accesso» per Python sulle reti private, oppure da PowerShell
  amministratore `New-NetFirewallRule -DisplayName <app> -Direction Inbound -Protocol TCP -LocalPort <porta> -Action Allow -Profile Private`.
  macOS: Impostazioni → Rete → Firewall → Opzioni. Mai cambiare il firewall senza dirlo all'utente.
- **Dove vanno i file**: nella stessa cartella e struttura di quando si scarica dal PC (Vivlío: pagine parziali in
  `dati/caricati/.scarica-<hash>/`, poi importate in `dati/biblioteca/<serie>/capitoli/`).
- **Lavoro in background**: il server crea un job (id, stato `in_corso`/`ok`/`errore`/`fermato`, avanzamento) in un thread
  suo; il client chiede solo di avviarlo e ne legge lo stato. Telefono bloccato, disconnesso o pagina chiusa: il download
  continua. Al massimo 2 download in parallelo (semaforo), gli altri «In coda».
- **Tempo reale**: ogni pagina aperta chiede l'elenco dei job ogni 10 s (ogni 2 s con download attivi) e, quando cambia
  l'insieme dei download attivi o uno finisce, ricarica l'archivio dal server. La serie compare subito «In download» con
  l'avanzamento, poi completa con i capitoli, su tutti i dispositivi. Polling e non SSE/WebSocket: il server è
  `http.server` della libreria standard e il polling basta; passare a SSE solo se servono aggiornamenti sotto il secondo.
- **Duplicati**: controllo «stesso URL già in corso» e creazione del job sotto lo stesso lock; da due dispositivi insieme
  parte uno solo, l'altro riceve «questa serie si sta già scaricando».
- **Errori**: un capitolo rotto non ferma gli altri; un errore lascia le pagine già scaricate e il job mostra **Riprova**,
  che riparte senza riscaricarle. Spazio libero sotto 500 MB: errore «spazio su disco insufficiente», poi Riprova.
- **Riavvio o crash del server**: la richiesta del download si salva su disco appena accettata (anche se resta in coda);
  all'avvio i job non finiti ricompaiono «Interrotto» con Riprendi. Mai persi in silenzio.
- **Elaborazione sul PC host**: anche le conversioni (es. copertine in PNG con Pillow) si fanno sul server, così funzionano
  allo stesso modo dal PC e dal telefono, senza dipendere da funzioni del browser.

**Da non rompere**
- Niente `localhost` o `127.0.0.1` scritti nel client: solo URL relativi (`/api/...`, `/media/...`), anche per immagini,
  pagine dei capitoli e copertine.
- Niente archivio salvato solo nel browser (localStorage, IndexedDB, cache): il browser tiene solo preferenze di vista;
  una cache, se c'è, è solo di velocità e si riallinea al server.
- Niente download eseguiti dal client: il browser non scarica le pagine, non deve restare aperto e non salva file.
- Niente blocchi «solo da questo computer» sui download: restano solo per spegni, riavvia, password e installazioni.
