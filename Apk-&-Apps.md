# Apk-&-Apps.md — Regole per app Android (APK telefono e TV)

Leggi questo file **prima di creare, controllare o correggere qualsiasi app Android** (APK per telefono, Android TV, tablet).
Origine: richiesta dell'utente del 2026-11-07 (revisione di `Free Claude Code/Apk/Apk-TV` e `Apk-Telefono`) e dagli errori trovati in quei due progetti, generati da un'altra AI e non compilabili.

## 1. Perimetro

- Si lavora **solo dentro la cartella del progetto indicato**. Mai aprire o modificare altri progetti, anche se il progetto è destinato a esservi integrato (es. Cineteca): l'integrazione è un task a parte, qui si scrivono solo note.
- Più progetti nella stessa richiesta: **uno alla volta**, senza mescolarli e senza codice condiviso (niente moduli comuni, niente link simbolici). Se la stessa correzione serve a entrambi, si applica a ciascuno come copia indipendente.
- Si correggono **solo errori e bug reali**. Non si cambiano architettura, stack, nomi di package o struttura delle cartelle, e non si aggiungono funzioni. Il resto va nel report come «miglioramenti consigliati, non applicati».
- Eccezione: una libreria o un pezzo di stack che **non funziona affatto** (API inesistenti, dipendenze mai dichiarate) si può sostituire con la sua versione standard (es. RxJava/`datastore-rxjava3` → DataStore con Flow), ma solo **dopo aver chiesto all'utente** e indicandolo nel report.
- Git: l'utente committa da sé. Si crea un repo o si fanno commit solo se lo chiede esplicitamente; se chiede di togliere il `.git` creato per la revisione, lo si toglie.

## 2. Ambiente (verificare prima di tutto)

- **JDK 17 o 21 completo, con `javac`.** Su questo PC (Ubuntu) ci sono solo i JRE `openjdk-21-jre` e `openjdk-25-jre`, senza `javac`: AGP non configura nemmeno la compilazione Kotlin (`Toolchain installation ... does not provide the required capabilities: [JAVA_COMPILER]`). Serve `sudo apt install openjdk-21-jdk-headless` (lo fa l'utente: sudo non è disponibile a Claude e il download di un JDK è stato negato dai permessi). Con JDK 25 Gradle 8.10 non parte.
- **Windows** (dal 2026-11-10): JDK 21 installato con `winget install Microsoft.OpenJDK.21` in
  `C:\Program Files\Microsoft\jdk-21.0.13.21-hotspot` (in Git Bash: `export JAVA_HOME="/c/Program Files/Microsoft/jdk-21.0.13.21-hotspot"`
  e `PATH="$JAVA_HOME/bin:$PATH"`), SDK in `%LOCALAPPDATA%\Android\Sdk` (`sdk.dir` in `local.properties`).
  Emulatori: `CinetecaTV` (Android TV 14) e `telefono` (Android 14 google_apis x86_64). L'immagine TV **non ha
  DocumentsUI**: `OpenDocumentTree`/`OpenDocument` non si aprono, le app con cartella SAF si provano sull'AVD telefono.
- **Android SDK** in `~/Android/Sdk` (installato il 2026-11-07): `cmdline-tools/latest`, `platforms;android-35`, `build-tools;34.0.0`, `platform-tools`. Esportare `ANDROID_HOME=~/Android/Sdk` (oppure `sdk.dir` in `local.properties`, che non va nel repo).
- **Gradle wrapper ufficiale**: `gradlew`, `gradlew.bat`, `gradle/wrapper/gradle-wrapper.jar` e `.properties`. Un `gradlew` scritto a mano o senza il `.jar` non parte: si rigenera con `gradle wrapper --gradle-version <x>` in una cartella vuota (così i file di build rotti del progetto non bloccano) e si copiano i file.
- Disco: il PC è al 97%. SDK + Gradle + cache occupano circa 4-6 GB: dirlo prima di scaricare.
- Se manca qualcosa per compilare, **dirlo con i passaggi necessari**, non aggirarlo e non dichiarare compilato ciò che non lo è.

### Verifica parziale senza JDK (solo se il JDK manca)

Con il solo JRE si possono comunque verificare:
1. manifest e risorse: `./gradlew :app:processDebugResources`;
2. compilazione Kotlin: classpath di debug estratto con un init script (`android.applicationVariants` → `getCompileClasspath(null)`), poi `K2JVMCompiler` di `kotlin-compiler-embeddable` (gira su JRE) con `-Xplugin` per il compilatore Compose e per kotlinx.serialization, contro `android.jar`; senza `-Xjdk-release` (il JRE non ha `ct.sym`);
3. test unitari JVM: compilati allo stesso modo ed eseguiti con `org.junit.runner.JUnitCore`.

Nel report va scritto chiaramente che `assembleDebug`, `lint` e `test` via Gradle **non** sono stati eseguiti.

## 3. Procedura per ogni progetto

1. Ambiente (sezione 2).
2. Scansione: struttura, `libs.versions.toml`, `build.gradle.kts`, `settings.gradle.kts`, `gradle.properties`, manifest, risorse, **ogni** file Kotlin letto per intero (non solo con grep).
3. `./gradlew assembleDebug`; errori risolti uno alla volta dal primo. Poi `./gradlew lint` e `./gradlew test`.
4. Ricerca attiva di bug anche se la build passa (sezioni 4-7).
5. Nuova build dopo ogni gruppo di correzioni; alla fine `assembleDebug` deve passare.
6. README in italiano aggiornato se non è più coerente con il codice.
7. Report in italiano (sezione 8).

## 4. Build e configurazione Gradle

- Root `build.gradle.kts`: solo `plugins { alias(libs.plugins.x) apply false }`. Mai `buildscript { classpath(libs.plugins...) }` (non valido) né `allprojects { repositories }` insieme a `FAIL_ON_PROJECT_REPOS` (errore).
- `settings.gradle.kts`: niente `resolutionStrategy.eachPlugin` scritto a mano e niente `versionCatalogs { create("libs") { from(files("gradle/libs.versions.toml")) } }`: quel file Gradle lo carica già da solo, e ricrearlo dà errore.
- `gradle.properties` deve esistere, con almeno `android.useAndroidX=true`.
- Kotlin 2.x + Compose: plugin `org.jetbrains.kotlin.plugin.compose` con la stessa versione di Kotlin; **niente** `composeOptions.kotlinCompilerExtensionVersion`.
- Manifest: niente attributo `package=` (con AGP 8 si usa `namespace` nel `build.gradle.kts`).
- `packagingOptions` → `packaging`; `rootProject.buildDir` è deprecato.
- Dipendenze: ogni libreria deve **esistere** in quella versione (es. `androidx.nsd:nsd` non esiste: si usa `android.net.nsd.NsdManager` della piattaforma; `tv-foundation:1.0.0` non esiste), le librerie Compose prendono la versione dalla BOM (non `1.0.0` a mano), nessuna dipendenza inutilizzata, nessun import di librerie non dichiarate (`javax.inject`, `kotlinx.coroutines.rx3`).
- Retrofit 2.11+: convertitore ufficiale `com.squareup.retrofit2:converter-kotlinx-serialization` con import `retrofit2.converter.kotlinx.serialization.asConverterFactory`.
- Le risorse citate nel manifest devono esistere (`@mipmap/ic_launcher` mancante = build rotta). I vector drawable **non supportano** `<text>`: le scritte si fanno con `<path>`.
- Temi XML: i genitori devono esistere nel framework (`android:Theme.Material3.DayNight` **non esiste**; usare `android:Theme.Material.Light.NoActionBar` / `android:Theme.Material.NoActionBar` in `values-night`), e il tema di Compose dà i colori veri.
- Una volta compilato: zero warning del compilatore sul codice del progetto.

## 5. Rete e sicurezza

- **Permessi minimi**: per un client HTTP + mDNS basta `INTERNET`. `NsdManager` non richiede `ACCESS_WIFI_STATE` né `CHANGE_WIFI_MULTICAST_STATE`; `ACCESS_NETWORK_STATE` solo se il codice lo usa davvero.
- **HTTP in chiaro solo verso la LAN.** `network_security_config.xml` **non accetta intervalli IP**: `<domain>192.168.0.0/16</domain>` è letto come nome host e blocca proprio la LAN. Soluzione adottata: `cleartextTrafficPermitted="true"` nel `base-config`, con un commento che rimanda al codice, e limite applicato nel codice:
  - validazione dell'URL: `http://` accettato solo per IP privati (10/8, 172.16/12, 192.168/16), link-local (169.254/16, fe80::/10), IPv6 ULA (fc00::/7), loopback, `localhost`, `*.local`; nessuna risoluzione DNS (`InetAddress.getByName` solo su IP letterali);
  - stesso controllo in un **network interceptor** di OkHttp, così vale anche sui redirect;
  - `https://` verso qualunque host.
- **Client API**: un solo `OkHttpClient`; Retrofit ricreato solo quando cambia l'URL base (cache chiave URL → servizio). L'URL base finisce sempre con `/` (Retrofit lancia un'eccezione altrimenti): normalizzare, togliere query e frammento. Endpoint relativi (`@GET("health")`), così funzionano anche con un percorso base (`/api/`).
- Nessuna costruzione di Retrofit nell'`init` con un URL non validato (crash all'avvio).
- Timeout espliciti (5 s connessione/lettura/scrittura sulle chiamate brevi).
- Errori tradotti in un messaggio per l'utente: timeout, server non raggiungibile (`ConnectException`), host sconosciuto o rete assente (`UnknownHostException`), HTTP non 2xx (`HttpException`), JSON non valido (`SerializationException`), risposta vuota o inattesa. Nessun crash su risposte vuote o inattese.
- Nei `try/catch` dentro le coroutine: rilanciare sempre `CancellationException`.
- **mDNS (NsdManager)**: tipo di servizio `_http._tcp.` (non `_http._tcp.local.`); un `ResolveListener` **nuovo per ogni risoluzione** (riusarlo dà «listener already in use»); prima di Android 14 si risolve un servizio alla volta → coda; `stopServiceDiscovery` solo se la ricerca è attiva, e prendendo `IllegalArgumentException`; ricerca fermata dopo un timeout e in `onCleared()` del ViewModel. Host IPv6 tra parentesi quadre nell'URL.

## 6. Architettura e Compose

- DI con Koin: **ViewModel registrati** nel modulo (`viewModel { ... }`) e presi con `koinViewModel()`; mai `by viewModels()` senza factory per ViewModel con parametri (crash). Niente annotazioni Hilt/`javax.inject` se Hilt non c'è.
- DataStore: `preferencesDataStore` + Flow, `catch` su `IOException` → `emptyPreferences()`; niente getter sincroni alimentati da `GlobalScope`.
- Niente `GlobalScope`; coroutine in `viewModelScope`; nessuna chiamata di rete sul main thread (Retrofit `suspend` va bene).
- Funzioni `suspend` chiamate solo da coroutine.
- **Impostazioni**: il campo di testo è collegato al ViewModel (stato che sopravvive alla rotazione); «Testa connessione» prova **l'indirizzo scritto**, non quello salvato; «Salva» valida, normalizza, salva e conferma, oppure mostra il motivo del rifiuto; al primo avvio c'è un valore di default chiaro.
- Un solo tipo di stato condiviso per l'esito della connessione (es. `ui/common/ConnectionStatus.kt`), non copie identiche in ogni ViewModel.
- **Media3**: le API marcate `@UnstableApi` (`ExoPlayer.audioSessionId`, `MediaItemsWithStartPosition`,
  `onPlaybackResumption`) sono un **errore** di lint (`UnsafeOptInUsageError`): `@OptIn(UnstableApi::class)` di
  `androidx.annotation` sulla classe, con un commento. Lettori musicali: stato del lettore (coda, indice, posizione)
  salvato dal servizio e ripreso in `onCreate` + `onPlaybackResumption` con `MediaButtonReceiver` nel manifest.
- **Lavori lunghi (lettura di una cartella, indici)**: mai bloccare la schermata; i dati già noti restano visibili,
  i nuovi arrivano a blocchi (StateFlow aggiornato ogni N elementi, `debounce` sui calcoli derivati), indicatore sottile.
- **Righe di pulsanti**: mai `OutlinedButton` con testo in una `Row` stretta (il testo va a capo lettera per lettera):
  pulsanti con `Modifier.weight(1f)`, icona sopra e nome sotto con `maxLines = 1`.
- Compose: le API devono esistere nella versione della BOM (es. `TvMaterialTheme`, `TvLazyColumn`, `ButtonColors(a, b)`, `ListItem(onClick)`, `outlinedTextFieldColors`, `foundation.layout.CardDefaults` non esistono o non sono più così); niente liste lazy annidate nello stesso verso; `TopAppBar` richiede `@OptIn(ExperimentalMaterial3Api::class)`; un solo tema applicato nell'Activity, non di nuovo dentro ogni schermata.

## 7. Specifiche per tipo di dispositivo

### Android TV
- Manifest: `android.software.leanback` required, `android.hardware.touchscreen` **non** required, intent `LEANBACK_LAUNCHER`, `android:banner` 320x180 e icona presenti.
- Componenti `androidx.tv:tv-material` (`Button`, `Surface(onClick)`, `MaterialTheme`) che hanno già lo stato di focus; liste con `LazyColumn` di foundation.
- **Focus**: ogni elemento interattivo ha un focus visibile (bordo, colore, scala); un solo punto di focus per controllo (non avvolgere un `Button` in un altro elemento cliccabile: due fermate del D-pad); focus iniziale richiesto all'apertura di ogni schermata; **niente pulsanti disabilitati** sotto il focus (perdono il focus del telecomando: lasciarli abilitati e gestire il doppio clic nel ViewModel).
- Campo di testo: `BasicTextField` con bordo che cambia al focus; nessun elemento raggiungibile solo col tocco.
- Padding generosi per l'overscan (circa 48-64 dp).

### Telefono
- `enableEdgeToEdge()` **prima** di `super.onCreate`; `Scaffold` per gli insets delle barre; nelle schermate con campi di testo `consumeWindowInsets(innerPadding)` + `imePadding()` e `adjustResize` nel manifest.
- Verticale e orizzontale: contenuto con scroll e larghezza massima (es. `widthIn(max = 600.dp)`) centrata.
- Tema chiaro/scuro: `isSystemInDarkTheme()` in Compose più temi XML `values` / `values-night` per la finestra di avvio.
- Navigazione indietro sia col tasto di sistema sia con la freccia nella `TopAppBar`.

## 8. Aggiornamenti senza disinstallare (regola dell'utente, 2026-11-09)

**Regola.** Ogni app si aggiorna da sola dal PC, senza disinstallarla e senza perdere i dati: dopo una modifica si
compila sul PC e l'app, collegandosi al server, scarica e installa l'APK nuovo. Si installa a mano solo la prima
versione che ha l'aggiornamento.

Due casi, secondo da dove arriva l'app:
- **App senza server (Galleria Android, Musicoteca Android)**: sul PC si accende `aggiorna.py` (nella cartella dell'app)
  solo quando c'è un APK nuovo (chiede se compilare se l'APK è più vecchio dei sorgenti); nell'app «Cerca aggiornamenti»
  (Galleria: Strumenti; Musicoteca: ⚙ Impostazioni) manda l'impronta e il server si spegne dopo l'invio, dopo «uguale» o
  dopo 15 minuti. **Una porta per app**, uguale in `aggiorna.py` e in `PORTA_PC` dell'app: Galleria 8803, Musicoteca
  8806 (con la stessa porta un'app riceverebbe l'APK dell'altra). Solo client con IP privato.
- **App installata dal sito del server (Theca TV, Cineteca-FCC TV)**: l'aggiornamento arriva **dallo stesso server**.
  `./gradlew nelServer` mette l'APK in `dati/<app>-tv.apk`; all'apertura l'app chiama `/api/apk-tv?sha=<impronta>`
  (libero dal PIN come l'APK, nessun dato privato) e, se l'APK del server è diverso, chiede «Installa / Più tardi»
  (fuoco su Installa per il telecomando). Una volta per apertura dell'app.

Come si fa (codice di riferimento: `galleria-android/.../data/Aggiornamento.kt`, `theca/codice/apk-tv/.../Aggiornamento.kt`):
- Confronto con l'**impronta SHA-256 dell'APK installato** (`applicationInfo.sourceDir`), non con `versionCode`: ogni
  build nuova è un aggiornamento anche senza cambiare versione (Android accetta lo stesso `versionCode`). Alzare comunque
  `versionName` quando cambia qualcosa che l'utente vede.
- L'APK si scarica **dentro la sessione di `PackageInstaller`** (nessun file in giro), controllando dimensione e impronta
  prima del `commit`; impronta diversa = `abandon()` e messaggio. Redirect non seguiti.
- Manifest: `REQUEST_INSTALL_PACKAGES` + receiver non esportato per l'esito; su `STATUS_PENDING_USER_ACTION` si apre la
  finestra di Android (la prima volta «Installa app sconosciute» per l'app). Android 12+: `USER_ACTION_NOT_REQUIRED`,
  che vale solo quando l'app è già stata installata da se stessa: la prima volta (installata con adb o dal browser)
  Android chiede comunque «Aggiorna questa app?».
- **Google Play Protect** può bloccare l'aggiornamento di un'app non dello Store («App blocked to protect your device»,
  visto sull'emulatore Android TV 14): «Altri dettagli → Installa comunque» lo fa l'utente sul dispositivo. Non si
  disattiva Play Protect al posto suo.
- Stessa firma: Android sostituisce l'app solo con un APK firmato con la stessa chiave → compilare sempre sullo stesso PC
  (build debug con la chiave di quel PC: vedi il commento `shortcut` in `build.gradle.kts`).
- Errori tradotti per l'utente: server spento = «nessun aggiornamento» (non un errore), timeout, APK rovinato,
  installazione rifiutata (con il motivo di Android).
- Prova: emulatore con la versione A installata, versione B sul server, `adb reverse tcp:<porta> tcp:<porta>` e indirizzo
  `127.0.0.1:<porta>` (la NAT dell'emulatore su Windows tronca le risposte grandi), poi controllare
  `dumpsys package <id> | grep versionName`.

## 9. Report finale (in italiano, per ogni progetto)

- Problemi divisi in: errori di build, bug di runtime, problemi di configurazione; per ciascuno file e riga, causa, correzione.
- Cosa è stato verificato davvero (build, lint, test) e cosa no, con il motivo.
- Miglioramenti consigliati ma non applicati.
- Note per integrazioni future (es. Cineteca), solo come note.
