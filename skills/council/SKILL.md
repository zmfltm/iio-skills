---
name: council
description: Use when the user says "council" or asks for a council review. Four read-only lens reviewers on GPT Sol and Claude Opus review a change in a loop until they agree.
---

# Council

Get a change reviewed through four lenses, two on GPT Sol and two on Claude
Opus, and loop until every lens approves the current diff. The reviewers only
review. You check their findings and make the fixes.

Council has no merge authority. "Agreed" is a review result. It never means
merge, mark ready, enable auto-merge, or push.

Make the smallest changes that answer real findings, and push back on scope
creep.

## Lenses

| Lens | Looks for | Model |
| --- | --- | --- |
| Correctness | bugs, edge cases, races, missing tests | GPT Sol, reasoning xhigh |
| Operations | rollout, rollback, config, deploy, CI | GPT Sol, reasoning xhigh |
| Interface | user flows, API and type contracts | Claude Opus, effort high |
| Simplicity | overengineering, dead code, test bloat | Claude Opus, effort high |

Use the latest Sol and Opus unless the user names versions. With two models,
the lenses are what keep the reviews different, so give each reviewer only its
own lens.

## Budget

- Default: 3 rounds. Go to 5 only for security, permissions, auth, data loss,
  or state and concurrency, and only while a blocker or should stays open with
  evidence. Also go to 5 if the user asks.
- Round 1 runs every lens on the full diff. Later rounds check only open
  findings and changed code. Re-run a lens that already approved only when
  behavior code changed since its approval, because an approval has to cover
  the current diff.
- Stop early if a round returns only nits. Declined nits and comment-, doc-, or
  format-only fixes need no new round.
- One reviewer per lens. Reviewers must not start subagents or other reviewers.
- Keep a ledger with id, lens, severity, outcome, and each lens's score per
  round. Never guess an entry.

## 1. Scope

Follow [sol-loop](../sol-loop/SKILL.md) step 1. Scope the change cleanly, find
the base, and use one diff command for every round. To review something that
isn't a diff, such as a plan or a doc, give every lens the same file path
instead. State the intent and what is out of scope, and run the covering
checks before any lens sees the code.

## 2. Start the lenses

Route each lens as [sol-loop](../sol-loop/SKILL.md) step 2 routes Sol. Run
all four in parallel, and start one `delegate_task` per lens per round in T3.
Outside T3:

- **Sol from Claude Code:** the `sol` subagent.
- **Opus from Claude Code:** the Agent tool with `subagent_type: "Plan"`
  (read-only), `model: "opus"`, and `effort: "high"`.
- **Opus from Codex:**
  `claude -p --model claude-opus-5-5 --effort high --permission-mode plan`,
  with the brief on stdin.

- **Never substitute a model.** If no instance can run Sol or Opus, that lens
  is blocked. Do not swap in another model or a lower effort.
- **A lens that fails or times out counts as blocked.** An error or a missing
  verdict also counts, and none of these is approval. Cancel the lens, confirm
  it stopped, and restart it once with the ledger. If it fails again, it stays
  blocked.
- Do not edit scoped files while lenses run. Wait for the completion notices
  and do not poll.

Round 1 brief, one per lens: sol-loop's round 1 brief, with this line added
after its first line:

```
Lens: <lens>: <looks for>. Outside your lens, report blockers only.
```

and its `Reply:` block replaced by:

```
Reply:
VERDICT: APPROVE or CHANGES
SCORE: <n>/10
<L>1 [blocker|should|nit] <file>:<line> <claim>. Fix: <suggestion> (stable ids; L = C, O, I, or S)
```

## 3. Answer findings

Follow sol-loop step 3. A lone finding can be right and a unanimous one wrong,
so the code decides, not the count. When two lenses report the same failure,
merge them into one entry.

## 4. Next round

Start a round only if budget remains and either a blocker or should is open or
behavior changed after some lens approved. Send each lens you re-run:

- the round 1 brief
- the ledger, marked `fixed:`, `disagree:`, or `declined:` with evidence
- the same base diff
- the changes since that lens's last round

Ask it to mark each old id `resolved` or `still open: <reason>`.

## 5. Outcome

- **Agreed:** every lens returned APPROVE on the current behavior diff, no
  blocker or should is open, and you have no concern of your own.
- **Stuck:** a finding stays disputed after two replies, or the budget ran
  out. Give each side in 2-3 lines and let the user decide. Running out of
  budget is not approval.
- **Blocked:** at least one lens failed, timed out, or could not run. Name the
  lens and the reason. Three approving lenses and one blocked lens is
  Blocked, not Agreed.

Push only as sol-loop step 5 allows, and only under the repo's own rules. The
score table below replaces its `Reviewed with sol-loop` line.

## Score

If the work ends in a PR, add this section to its description, above the model
and harness line:

```markdown
## Council review

Rounds: 2

| Lens | Round 1 | Round 2 |
| --- | --- | --- |
| Correctness (GPT 6.1 Sol) | 7/10 | 9/10 |
| Operations (GPT 6.1 Sol) | 8/10 | not run |
| Interface (Opus 5.5) | 7/10 | 9/10 |
| Simplicity (Opus 5.5) | blocked | 8/10 |
```

Write `no score` when a lens gives none, `blocked` when it failed, and
`not run` when it approved earlier and was not re-run. Never invent a score.
If the PR is open, edit the description and do not post a comment. If there is
no PR, put the table in the final reply.

Report the outcome first. Then give the rounds, the findings you fixed, the
findings you declined (with reasons and follow-ups), the diff size before and
after, and the model that ran each lens.
