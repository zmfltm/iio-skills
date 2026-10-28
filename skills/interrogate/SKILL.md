---
name: interrogate
description: Use when the user asks for competing candidates, a bake-off, or several isolated attempts at one technical decision. UI variants behind a picker are ui-prototype (Pivot: prototype); review of an existing change is council.
---

# Interrogate

Settle one decision by having several agents build complete, structurally
different candidates, then pick one base and import only what fits it. Votes
are not proof. The candidate you can check wins.

## Before launching

Settle the decision, the success rubric, and the constraints. Ask only about
an ambiguity that would change the winner. If the constraints already fix the
structure, say that no real competition is left, and compare only the choices
that remain.

Give every candidate the same compact brief:

- the outcome
- the exact files
- the minimum context
- the constraints and exclusions
- the rubric

Run candidates on the session model unless the user names others; Sol
candidates go through `codex-lanes`. Size the count to the decision.

## Rules

- **Each candidate works in its own worktree or scratch dir.** Shared files
  turn the comparison into a merge conflict.
- **Each candidate takes a different structure.** Three variations of one
  idea answer nothing.
- **Each candidate returns** the artifact, its rationale, the options it
  rejected, the checks it ran, and its weaknesses. You can't judge a
  candidate without those.

## Judge

Score every candidate against the rubric. When the call is close or the user
asks, use a read-only judge that sees neutral labels.

Pick one coherent base. On a tie, prefer the one with clearer ownership, fewer
parts, and a safer migration. Import only specific strengths that fit the
base. Never merge whole candidates or keep two mechanisms for one job. Check
the combined result yourself, then delete the disposable candidates.

Report:

- the models that finished, and any requested route that failed
- the chosen base and why
- the imports and the strongest rejected alternative
- the checks you ran and their results

Then build the chosen base into the original task, unless the user asked only
for the comparison.
