---
name: project_vektora_order
description: Vektora Order — menu QR + ordini al tavolo real-time (Next.js 16, Prisma 7, Socket.io), lavorato a step con conferma, in Prodotti Vektora/vektora-order
metadata:
  type: project
---

App "Vektora Order" in `Vektora Site/Prodotti Vektora/vektora-order/`: menu cliente PWA via QR (`/menu?table=qrToken`), gestionale `/admin`, cucina `/kitchen`. Piano in 11 step forniti dall'utente (1-8 base, 9 "Chiama cameriere", 10 statistiche, 11 i18n IT/EN/AR/ZH/ES con RTL).

Stato: Step 1-7 completati il 2026-10-02 (setup, schema+seed, gestionale, QR+sessione, PWA, Socket.io, ordini+cucina). Prossimo: Step 8 testing/polish/README (test-flow.md, icone PWA: CHIEDERE il logo all'utente, deploy Railway).

**Why:** l'utente impone un flusso rigido: uno step alla volta, a fine step elenco file, comandi di test, problemi noti e domanda "Procedo con lo step successivo?". Mai andare oltre senza conferma esplicita. Prezzi/totali sempre ricalcolati server-side dal DB.

**How to apply:**
- Stack fissato: Next 16.3 (App Router, `src/`, `proxy.ts` al posto di middleware), Prisma **7.10.0** pinnato (il tag `latest` di `prisma` è una RC 8), next-auth **4** (v5 ancora beta), Zod 4, shadcn `radix-nova` con `rtl: true`, pnpm 10 (installato globale con npm, corepack dà EPERM).
- Prima di scrivere codice Next leggere `node_modules/next/dist/docs/` (lo chiede `AGENTS.md`).
- `create-next-app` genera un `CLAUDE.md` (`@AGENTS.md`): è stato cancellato per [[feedback_claude_folder_unica_fonte]]; con `AGENTS.md` presente `next dev` non lo ricrea.
- `pnpm typecheck` = `next typegen && tsc --noEmit` (serve per i tipi globali `LayoutProps`).
- Dev server: voce `vektora-order` in `.claude/launch.json`, porta 3000 (stessa di `piccolo1929`, non avviarli insieme).
- Prisma 7: URL in `prisma.config.ts` (con `dotenv/config`), client generato in `src/generated/prisma` (gitignored, `postinstall` lo rigenera), adapter `@prisma/adapter-pg`. `migrate dev` NON lancia più il seed: serve `pnpm db:seed`.
- Schema: Table→Order e Dish→OrderItem sono `Restrict` (disattivare invece di eliminare, lo Step 3 deve gestire l'errore P2003); `Order.number` autoincrement aggiunto per la conferma ordine; allergeni come enum (14 UE). Login cucina (Step 7) non ha ancora campi nello schema.
- PostgreSQL 17 nativo (servizio `postgresql-x64-17`, porta 5432), credenziali sconosciute: per testare usare un cluster usa-e-getta con `initdb -A trust` nello scratchpad su porta 55432 (`pg_ctl start` resta agganciato a bash, il server parte lo stesso).
- Gestionale: `requireAdmin()` in `src/server/admin/session.ts` (rilegge admin da DB, `cache`), Server Action in `src/server/admin/*-actions.ts` con scoping `updateMany/deleteMany where {id, restaurantId}`. Form via hook `useFormAction` (submit da onSubmit, non `action`, perché React 19 azzera i campi). TanStack Table pinnata a **v8** (v9 ha API diversa). Ruolo `admin`/`kitchen` nel JWT (next-auth augment in `src/types/next-auth.d.ts`).
- Sessione tavolo (Step 4): modello `TableSession` (hash SHA-256 del token, `expiresAt`), `Order.tableSessionId` FK al posto del campo `sessionToken` della spec. Flusso `/menu?table=` → redirect a `/api/table-session/start` (unico punto che può settare il cookie `vo_table_session`) → `/menu` pulito. `getCurrentTableSession()` in `src/server/table-session.ts` da usare allo Step 7. QR: `/api/tables/[id]/qr`, rigenerazione chiude le sessioni del tavolo. `/menu` attuale è una versione minima da sostituire allo Step 5 (dati da `getPublicMenu`).
- PWA (Step 5): l'utente ha scelto service worker MANUALE invece di next-pwa (incompatibile con Turbopack). `public/sw.js` + `src/app/manifest.ts` + `src/app/icon.tsx` (icone provvisorie "VO", da sostituire con logo allo Step 8: chiedere all'utente). SW registrato solo in produzione: test con voce `vektora-order-prod` (porta 3001) in launch.json + `.env.production.local` temporaneo. Carrello in localStorage `vo-cart:<sessionId>` senza prezzi; limiti in `src/lib/cart-limits.ts` da riusare nello zod dell'ordine (Step 7). "Invia ordine" disattivato in `cart-drawer.tsx`.
- Real-time (Step 6): `server.ts` (tsx) = Next + Socket.io stessa porta; `pnpm dev` = `tsx watch server.ts`, `pnpm start` = cross-env NODE_ENV=production tsx server.ts (`--port`). Moduli importati da server.ts NON possono usare `server-only`/`next/headers` → `table-session-core.ts`. Socket server condiviso via globalThis (`src/server/realtime/registry.ts`), emit da Next con `emitter.ts`. Prisma condiviso via globalThis anche in prod; `prisma-errors.ts` usa duck typing (no instanceof). `order:created` emesso dal SERVER dopo il salvataggio (cliente invia via HTTP). `/api/dev/realtime` solo dev per test. `pnpm test:realtime -- --apply --yes -n` = smoke test (13 check). Handshake `auth.audience` customer/staff. Login cucina (role kitchen) ancora rifiutato in `socket-auth.ts`: da attivare allo Step 7. HOSTNAME rimosso da env.
- Ordini (Step 7): `POST /api/orders` (route handler, non Server Action) → `placeOrder` in transazione con `pg_advisory_xact_lock` per tavolo, rate limit contato nel DB (sessione = ORDER_RATE_LIMIT_MAX, tavolo = ×3), prezzi riletti dal DB. Cucina: login codice+PIN (provider NextAuth `kitchen-credentials`, ruolo kitchen, `Restaurant.kitchenCode/kitchenPinHash/kitchenSessionVersion`), guard `requireKitchen` + `kitchen-core.ts` (socket). Stati via `ORDER_TRANSITIONS` + update ottimistico con `from`. Admin → `/admin/settings` per PIN/codice. Migrazione `kitchen_access` scritta a mano (migrate dev non gira senza TTY con colonne required).
- Rimozioni con `rm` su percorsi in variabile vengono bloccate dal safety check: usare percorsi letterali o `${VAR:?}`.
- Browser pane: se `document.visibilityState` è hidden la pagina non si idrata (Suspense rimandato) e le img lazy non caricano; uno screenshot la rende visibile. Non è un bug dell'app.
- In Next 16 `error.tsx` riceve `retry()` (non `reset()`).
- Nel cluster di test i `timestamp` Prisma sono UTC senza fuso: nelle query manuali usare `now() at time zone 'utc'`.
- Test E2E fatti con fetch replay dell'header `next-action` per verificare l'isolamento cross-tenant: utile ripeterlo negli step successivi.
- Aggiornare il README del progetto a ogni step. Nessun commit: [[feedback_no_commit_git]].
