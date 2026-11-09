# Server locali con video, audio e immagini: regole

Si legge **insieme a `SERVER-LOCALI.md`** (domande iniziali, sicurezza, sync, backup, password, §9 download dalla
rete, §10 dipendenze e `.venv`, §11 porta occupata) ogni volta che si crea o si modifica un server o una web app
personale che mostra, legge, scarica o organizza video, musica, immagini, libri o manga.
Qui c'è solo quello che è proprio dei media. Le regole vengono da quello che ha funzionato, e dagli errori fatti, nei
progetti qui sotto.

Scritto il 2026-11-09 su richiesta dell'utente.

## 1. Progetti di riferimento

| Progetto | Dove | Porta | Da guardare per |
|---|---|---|---|
| Theca (ex Cineteca, con Anime) | `Cybersecurity/Script/Intrattenimento/Suite-Intrattenimento/theca/` | 8803 | libreria film/serie dal nome dei file, TMDB, lettore con «visto»/riprendi, sottotitoli OpenSubtitles, Online + Download (FCC), app TV |
| Cineteca-FCC (senza Anime) | `Free-Claude-Code-Regole/Cineteca-FCC/` | 8796 | come Theca, repo a sé: le correzioni comuni vanno portate in tutte e due |
| Videoteca | `Suite-Intrattenimento/videoteca/` | 8802 | libreria propria (file spostati), oshash/phash, anteprime e scene con ffmpeg, cassaforte cifrata, doppioni, AV1 |
| Musicoteca | `Suite-Intrattenimento/musicoteca/` | 8798 | tag ID3/MP4/FLAC letti nella pagina, cartella ricordata, ascolto online girato dal server (Range, HLS), karaoke |
| Galleria | `Suite-Intrattenimento/galleria/` | 8799 | EXIF e GPS, miniature ffmpeg, duplicati, riordino con Annulla |
| Biblioteca | `Suite-Intrattenimento/biblioteca/` | 8800 | EPUB fatto in casa, pdf.js, `RemoteFile` con Range |
| Suite Intrattenimento | `Suite-Intrattenimento/` (un repo) | 8798-8803 | base comune: `base.py`, `comune.js`, `base.css`, `dipendenze.py`, `menu_app.py` |
| Vivlío | `Vivlio/` e `Free-Claude-Code-Regole/Coding/Vivlio/` | 8790 | manga: download dal telefono eseguiti sul PC (§9), copertine PNG, cartelle su HDD |
| Media Loader | `Cybersecurity/Script/Media Loader/` | 8800+ | motori di download (yt-dlp, HLS, resolver), domini dei siti, pausa/ripresa, programmi esterni |

Memoria di ogni progetto: `memoria/project_<nome>.md`.

## 2. Dove stanno i media

- **I media non si copiano nel progetto.** O si leggono sul posto (Theca, Galleria, Musicoteca, Biblioteca) o stanno
  in una libreria scelta dall'utente (Videoteca, Vivlío). Mai dentro `codice/`, mai nella cartella `dati/` se è
  sincronizzata (Syncthing): i video pesano decine di GB.
- **Due modi di aprire una cartella**, da dire all'utente:
  1. selettore del browser (`<input webkitdirectory>`): i file restano nel browser, va riscelta a ogni apertura e non
     funziona dalla TV;
  2. **cartella ricordata dal server** (consigliata): il percorso si sceglie **solo dal PC** con un selettore delle
     cartelle del server (`/api/cartelle/sfoglia`, casa e dischi), si salva in `~/.cache/<app>/` (impostazione di quel
     PC, mai nella cartella sincronizzata) e i file arrivano da `/f/disco/<n>/<rel>` o `/video/<rel>`. Nella pagina un
     `RemoteFile` imita `File` (`slice` → fetch con Range) così parser, lettore e karaoke restano uguali; la chiave di un
     file è «NomeCartella/percorso», la stessa del selettore del browser (visti e playlist non si perdono).
- Più cartelle (HDD, NAS): elenco ricordato, ognuna con il suo nome; **un disco staccato nasconde i suoi file senza
  errori e senza svuotare l'indice salvato** (Videoteca `ricollega()`, Vivlío `biblioteche_extra`).
- **Percorsi sicuri**: ogni file chiesto dalla pagina → `resolve()` + `is_relative_to(cartella)` + estensione ammessa,
  altrimenti 404. Niente `..`, niente percorsi assoluti, niente symlink fuori.
- Cartelle e file nascosti (`.qualcosa`) esclusi dalla lettura; anche le cartelle di lavoro dell'app (`_Duplicati/`,
  `.scaricamenti/`, `.cassaforte/`).

## 3. Riconoscere i file

- Estensioni video: mp4 m4v mov mkv webm avi wmv flv mpg mpeg ts m2ts 3gp ogv. **Estensione da video non vuol dire
  video**: escludere `._nome.mkv` (macOS), pezzi di yt-dlp a metà (`.f137.mp4`, `.temp.mp4`, `.part`, `.ytdl`,
  `-FragN`) e `.ts` sotto 1 MB (sorgenti TypeScript). Stessa regola nel server e nella pagina (Theca:
  `NOT_VIDEO`/`TS_MIN` in `server.py`, `isVideoFile` in `logica.js`).
- `sample`/`trailer` scartati. Film = «Titolo (Anno)» o «Titolo.Anno.…»; serie = `S01E02`, `1x02`, «Season 1/E02»; le
  parole tecniche (1080p, x265, ITA…) chiudono il titolo. La logica di riconoscimento sta in un file puro testato con
  Node (`node --test`), senza pagina né rete.
- Anime = genere TMDB 16 + lingua originale `ja`; i generi TMDB di film e serie hanno id diversi.
- Musica dai tag (ID3v2.2-2.4, MP4 ilst, FLAC), con ripiego sul nome del file; foto dalla data EXIF, poi dal nome.
- Impronte: **oshash** per i video (veloce, le schede restano attaccate se il file si sposta), SHA-256 solo dopo aver
  trovato la stessa dimensione (doppioni), phash per «stesso video in un'altra risoluzione».

## 4. Lettore e avanzamento

- Il server serve audio e video **a pezzi con `Range` (206)**: senza, il salto in avanti non funziona.
- Formati che il browser non legge (mkv con x265/HEVC, audio AC3/DTS): la pagina lo dice con il motivo e propone di
  aprirlo con il lettore del PC o di convertirlo; non si finge che parta.
- Sottotitoli `.srt` accanto al video (stesso nome, anche `.it.srt`) caricati da soli, convertiti in WebVTT, letti
  anche in cp1252. I sottotitoli dentro gli mkv il browser non li legge: dirlo.
- Stato per file `{t, d, v, at}` (secondi, durata, visto a mano, quando): sopra il 90% è visto, sotto il primo minuto
  non è iniziato, «Riprendi» parte 5 s prima. Salvato sul server (`Archive.update`), non solo nel browser.
- `v.onloadedmetadata` assegnato ogni volta (non `addEventListener(..., {once})` riusato), poi il salto al punto salvato.
- Sessione scaduta o PC bloccato: il media riceve 401 e `<video>`/`<audio>` lo vedono come errore. L'handler `error`
  chiede `/api/sessione`: se fuori, login e poi `load()` + stesso punto. Mai «file illeggibile» a catena.
- Il lettore è un file comune (`lettore.js`, copia identica in Theca, Cineteca-FCC e Videoteca): una correzione va in
  tutte e tre.

## 5. Immagini, copertine, miniature

- CSP `img-src 'self' data: blob:` e `media-src 'self' blob:`: **la pagina non carica mai immagini o media da altri
  siti**. Locandine (TMDB), copertine dei siti, wallpaper e audio online passano dal server, che li scarica e li tiene
  in cache (`dati/cache/` o `~/.cache/<app>/`).
- Il server accetta solo URL `https` di **host in una lista fissa** (o usciti da una sua ricerca), misure in una lista
  (TMDB `w342`…), niente SVG da fuori, e solo indirizzi IP pubblici (anti-SSRF verso la rete di casa). Alcuni CDN
  vogliono il `Referer` del sito, altrimenti 403.
- Miniature con ffmpeg (320 px, `-noautorotate` + rotazione da EXIF Orientation) in `~/.cache/<app>/mini/`; la pagina
  chiede la miniatura con un parametro diverso dall'immagine intera, così la cache del browser non le confonde.
- Copertine salvate in un formato solo (Vivlío: `cover.png`, lato massimo 1200), convertite sul server così sono uguali
  da PC e telefono.
- **EXIF GPS è un dato personale**: indice con le posizioni solo in `~/.cache` del PC, mai nella cartella sincronizzata,
  niente mappa online (link OSM a richiesta).

## 6. Contenuti dai siti (Online)

- Ricerca e «novità» fatte dal server; la pagina riceve titoli, copertine (girate dal server) e link interni.
- **Domini dei siti** che cambiano spesso: tracker (`AstraeLabs/Domains`, quello di VibraVid) + cache in `~/.cache/<app>/`,
  dominio manuale da ⚙ → Siti, «↻ Ricontrolla i domini». I domini noti si provano **in parallelo** (uno morto non fa
  aspettare il suo timeout). Siti irraggiungibili ricordati e saltati.
- **Pagina vuota = motivo scritto**: ogni sito tiene l'ultimo errore (`ultimi_errori`), la risposta porta `errori` e la
  pagina mostra «Motivo: …» (dominio morto, timeout, chiave mancante). Mai una griglia vuota senza spiegazione.
- Dipendenze di rete complete nella `.venv` (`SERVER-LOCALI` §10): se si chiede `br` serve `brotli`; yt-dlp con
  `yt-dlp[default]` (o `[default,curl-cffi]`) e un runtime JS (deno/node) passato in `js_runtimes`.
- yt-dlp, YouTube, SoundCloud, HLS: regole in `SERVER-LOCALI` §2 («Audio e video da YouTube/SoundCloud»).
- **Non si aggirano**: DRM, sfide Cloudflare, verifiche dell'età con account, blocchi del provider. Messaggio chiaro e si
  passa oltre; un'eccezione (es. DNS alternativo) solo su richiesta esplicita dell'utente, informato del rischio.
- Contenuti per adulti: esclusione dei tag e dei titoli che indicano minori, sempre (`SERVER-LOCALI` §2).
- Solo fonti legali dove l'utente l'ha scelto (Biblioteca: Gutendex e Archive, niente LibGen).

## 7. Download e file sul disco

- Download dal telefono eseguiti sul PC: `SERVER-LOCALI` §9 (job in thread, coda di 2, richiesta salvata subito,
  Riprova, 500 MB liberi, polling).
- Si scarica in una **cartella di lavoro nascosta** (`.scaricamenti/<sha1>`, `dati/.parziali/<sha1>`), poi si sposta
  nella libreria con il nome finale: la libreria non vede mai file a metà. Annulla cancella `.part`, frammenti e cartella
  di lavoro; Pausa li tiene; i resti più vecchi di 14 giorni si tolgono all'avvio.
- Doppioni in coda rifiutati (stessa sorgente), badge «Già scaricato» con «Scarica di nuovo».
- yt-dlp: `%` → `%%` nel modello del nome, `skip_unavailable_fragments: False` con più tentativi, pezzi da 10 MB.
- **Spostamenti e riordini**: anteprima, registro scritto prima, nessuna sovrascrittura (`foto (2).jpg`), **Annulla**,
  `EXDEV` tra dischi = copia + rename + cancella. Su Windows: riprovare il rename sul `PermissionError` (miniature o
  antivirus che leggono il file) e fermare ffmpeg prima di spostare. Solo dal PC del server.

## 8. Programmi esterni (ffmpeg, ffprobe, mp4decrypt…)

- Prima quelli di sistema (`shutil.which`); se mancano, «Scarica» dalla pagina in una cartella dell'app
  (`dati/strumenti/` o `~/.local/share/<app>/strumenti/`) con il checksum ufficiale (BtbN `checksums.sha256`), messa in
  testa al PATH all'avvio. Mai `sudo`, mai installazioni di sistema: per quelle si mostra il comando (apt/winget).
- Compaiono nella tabella ⚙ → Server → Dipendenze come «trovato» / «non installato».
- Lavori lunghi (conversioni, anteprime) in un thread con avanzamento e Annulla; mai dentro la richiesta HTTP.

## 9. Chiavi API dei servizi

- TMDB, OpenSubtitles, StashDB, Wallhaven: **le crea l'utente**, Claude lo guida e non le procura. Si incollano solo dal
  PC del server, si salvano in `dati/<servizio>.key` con permessi 600, non vanno mai alla pagina né nel repo
  (`.gitignore`: `*.key`).
- OpenSubtitles: si usa **opensubtitles.com** (API REST v1), non .org. Il consumer va creato con «Allow anonymous
  downloads» (senza, il download dà 401 senza login) e «Under dev» (100 download al giorno invece di 5).
- Senza chiave l'app funziona lo stesso (titolo dal nome del file) e la pagina dice dove inserirla.

## 10. TV e telefono

- Rete di casa solo se scelta (`--lan`/`--rete`), con PIN o password; regole in `SERVER-LOCALI` §5 e §9.
- App per Android TV = WebView sulla stessa pagina (`Apk-&-Apps.md`): `/api/ping` è libero dal PIN ma senza dati
  privati, l'app cerca il server sulla **porta di default del suo progetto** nella /24, avvisa se è spento e riprova.
  Due progetti con app TV hanno `applicationId`, porta e nome di `/api/ping` diversi, così si installano insieme.
- Telecomando: ↑/↓ escono dai campi di testo, Indietro chiude lettore e schede, il fuoco si vede sempre.

## 11. Copie identiche tra progetti

Un file comune si cambia in tutte le copie e si controlla con `sha256sum`:

| File | Copie |
|---|---|
| `base.py`, `app/comune.js`, `app/base.css` | biblioteca, galleria, musicoteca, serata, videoteca |
| `dipendenze.py` | le sei app della Suite (Theca compresa), Cineteca-FCC, Compliance Tracker |
| `menu_app.py` | Suite, Ruota, Ayanokoji `server/` |
| `app/lettore.js` | Theca, Cineteca-FCC, Videoteca |
| `online_wall.py` | Galleria, Videoteca |
| `app/ruota.js` | Theca, Videoteca (copia) |

Theca e Cineteca-FCC sono due progetti diversi (nome, porta, aspetto, Anime solo in Theca) ma condividono il motore:
una correzione al lettore, alla ricerca sui siti, al download o al server si porta in tutte e due, se l'utente non dice
altrimenti.

## 12. Verifica

- Dati di prova o una copia, mai i dati veri: server di prova con `--dati <cartella temporanea>` e una porta sua
  (`.claude/launch.json`: `theca-prova` 8893, `musicoteca-prova` 8897, `galleria-prova` 8896…). Dal browser di prova
  non scegliere la cartella vera: scrive in `~/.cache/<app>/`.
- Video di prova generati con ffmpeg (`testsrc2`, `-t 3`), immagini con EXIF finti; niente download reali nei test
  automatici (siti e TMDB sostituiti da funzioni finte).
- Playwright: Brave non accetta cartelle con `setFiles` → si iniettano `File` con `webkitRelativePath` via
  `DataTransfer`. Guardare la pagina a 390 px e su desktop, in tema chiaro e scuro, e il lettore con un video vero.
- Le funzioni di rete si provano anche **nella `.venv`** (§10 di SERVER-LOCALI), non solo con il Python di sistema.
- Windows: `encoding="utf-8"` nei subprocess, `normcase` nei confronti di percorsi, file aperti che bloccano `rmtree`
  nei test (riprovare).
