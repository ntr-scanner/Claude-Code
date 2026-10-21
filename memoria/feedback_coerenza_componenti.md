---
name: feedback-coerenza-componenti
description: "Before coding, read how the existing program does it; a new card/element must have everything its siblings have"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 93711ddb-d12b-423e-b426-ee6a7a4e2738
  modified: 2026-10-21T07:41:32.162Z
---

When adding a new element (card, page, section) to an existing interface, first read how the existing ones are built and give the new one the same features. If all cards have hover details (description, metrics, Stato, Ultima revisione), the new one must have them too.

**Why:** in Ayanokoji System (2026-10-21) I made the section card without the hover details all other cards have; the user had to ask. Earlier (2026-10-20) I removed hover details nobody asked to remove.
**How to apply:** before writing UI code, list the features of the sibling components and replicate them; never drop or skip a shared feature without being asked. Related: [[feedback-dettagli-hover]].
