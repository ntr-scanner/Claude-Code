---
name: project_vektora_order
description: Vektora Order — menu QR + ordini al tavolo real-time (Next.js 16, Prisma 7, Socket.io), lavorato a step con conferma, in Prodotti Vektora/vektora-order
metadata:
  type: project
---

App "Vektora Order" in `Vektora Site/Prodotti Vektora/vektora-order/`: menu cliente PWA via QR (`/menu?table=qrToken`), gestionale `/admin`, cucina `/kitchen`. Piano in 11 step forniti dall'utente (1-8 base, 9 "Chiama cameriere", 10 statistiche, 11 i18n IT/EN/AR/ZH/ES con RTL).

Stato: Step 1 completato il 2026-10-02 (setup). Step 2 = schema Prisma + seed.

**Why:** l'utente impone un flusso rigido: uno step alla volta, a fine step elenco file, comandi di test, problemi noti e domanda "Procedo con lo step successivo?". Mai andare oltre senza conferma esplicita. Prezzi/totali sempre ricalcolati server-side dal DB.

**How to apply:**
- Stack fissato: Next 16.3 (App Router, `src/`, `proxy.ts` al posto di middleware), Prisma **7.10.0** pinnato (il tag `latest` di `prisma` è una RC 8), next-auth **4** (v5 ancora beta), Zod 4, shadcn `radix-nova` con `rtl: true`, pnpm 10 (installato globale con npm, corepack dà EPERM).
- Prima di scrivere codice Next leggere `node_modules/next/dist/docs/` (lo chiede `AGENTS.md`).
- `create-next-app` genera un `CLAUDE.md` (`@AGENTS.md`): è stato cancellato per [[feedback_claude_folder_unica_fonte]]; con `AGENTS.md` presente `next dev` non lo ricrea.
- `pnpm typecheck` = `next typegen && tsc --noEmit` (serve per i tipi globali `LayoutProps`).
- Dev server: voce `vektora-order` in `.claude/launch.json`, porta 3000 (stessa di `piccolo1929`, non avviarli insieme).
- Aggiornare il README del progetto a ogni step. Nessun commit: [[feedback_no_commit_git]].
