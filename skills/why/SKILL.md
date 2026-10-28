---
name: why
description: Use when asked why a specific design exists, what it replaced, or which alternatives were rejected. Not for how current code works.
---

# Why

Find the evidence for why a design exists, and say plainly where the evidence
runs out. Current code shows how the design works, not why it exists.

1. Anchor the question in a current file, symbol, or behavior.
2. Follow its history: blame through renames, the commit that introduced it,
   its tests and comments, and the linked PR or issue discussion. Read another
   source only to close a gap that matters.
3. Answer with labels:
   - **Stated:** the author said why. Cite the commit, PR, or line.
   - **Inferred:** your reading of the evidence. Say what it rests on.
   - **Unknown:** say where you searched and found nothing.

## Rules

- **Report contradictions and access gaps as they are.** A tidy story that
  fills a gap is worse than "unknown", because the next change will trust it.
- **Keep competing explanations open** until the evidence picks one.
- **End with the constraints** a future change should preserve.
