---
name: project-apk-android
description: Apk-TV (com.vektora.tv) e Apk-Telefono (com.vektora.mobile) in `Free Claude Code/Apk/`, client Compose di un server LAN /health, rifatti il 2026-11-07; da integrare in Cineteca più avanti
metadata:
  type: project
---

Due progetti Android indipendenti in `~/Vektora/Free Claude Code/Apk/` (percorsi con spazi, sempre tra virgolette): **Apk-TV** (Compose for TV, tv-material 1.0.0) e **Apk-Telefono** (Compose Material 3). Stesso stack: Kotlin 2.0.21, AGP 8.7.2, Gradle 8.10.2, Koin 3.5.6, Retrofit 2.11 + kotlinx.serialization, DataStore Preferences, NsdManager per mDNS. Schermate Home (placeholder + test connessione) e Impostazioni (URL server, ricerca mDNS, test, salva).

Generati da un'altra AI e non compilabili; il 2026-11-07 è stato riscritto quasi ogni file seguendo [[Apk-&-Apps.md]] (le regole stanno in `Claude/Apk-&-Apps.md`). La rimozione di RxJava/Guava/javax.inject e l'HTTP in chiaro limitato alla LAN nel codice sono stati approvati dall'utente. L'utente ha tolto il git di revisione: committa da sé ([[feedback-no-commit-git]]).

Verificato: `processDebugResources`, compilazione Kotlin manuale senza warning e 4 test JUnit di `ServerUrlTest` in entrambi. **Non** eseguiti `assembleDebug`, lint e test via Gradle, perché il PC ha solo JRE (manca `openjdk-21-jdk-headless`, va installato con sudo dall'utente). Android SDK in `~/Android/Sdk`, JDK da usare: `JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64` dopo l'installazione.

**Why:** i due progetti sono destinati a Cineteca ([[project-cineteca]]), ma l'integrazione è un task separato e non va mai fatta durante una revisione.
**How to apply:** prima di toccarli, rileggere `Claude/Apk-&-Apps.md`; per prima cosa controllare se il JDK è stato installato e poi lanciare `./gradlew assembleDebug lint test` in entrambi.
