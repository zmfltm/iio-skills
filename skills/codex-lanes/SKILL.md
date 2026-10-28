---
name: codex-lanes
description: Run parallel Codex lanes for implementation or audit work, including launch, monitoring, and collecting results. Use when a task asks for Codex, Astra, or Sol lanes. A Sol review loop is sol-loop or council instead.
---

# Codex lanes

A lane is one Codex run with one bounded brief in its own checkout. You launch
the lanes, then review and ship what they return. Each lane only does the work
in its brief. Implementation lanes run `gpt-6-astra` and audit lanes run
`gpt-6.1-sol`, unless the user or the project's `AGENTS.md` names others.

## Route

Call `orchestrator_capabilities`. If a Codex instance can run child tasks, use
`delegate_task` with it. Otherwise use the CLI below. Both routes follow the
rules after this.

- Either Codex account works: GX (`codex_codex_personal`,
  `CODEX_HOME="$HOME/.codex_personal"`) or the default (`codex`,
  `~/.codex`). When one is down or limited, use the other.
- **At most five lanes at once, across both accounts.** Queue the rest in
  waves.

## Launch

```bash
codex exec -m <slug> -c model_reasoning_effort="<effort|max>" \
  -s workspace-write -C <checkout> -o <lane>/last.md "$(cat <lane>/brief.md)" > <lane>/log.jsonl 2>&1
```

Audit lanes use `-s read-only` and report only through `-o <lane>/last.md`,
since they can't write files. After a CLI upgrade, check the first lane's log
for a rejected setting.

- Give each lane its own worktree from a fresh base, in a lanes directory
  outside `/tmp`. The `workspace-write` sandbox cannot write the main repo's
  `.git`, so lanes never commit. You review, commit, and open PRs.
- Launch each lane detached (`setsid nohup <lane>/run.sh &`), with `run.sh`
  writing its exit code to `<lane>/done`. Record each PID at launch. Wait on
  the `done` files. The Bash tool stops at 10 minutes, and a PID you find
  later with `ps` is one you may not kill.
- A brief states the outcome, the files or area, the constraints, the checks
  to run, and where to write the report. It also sets the limits: no commits,
  pushes, or external writes.

## Collect

Read each `last.md` and its checkout's diff. Check the claims against the
source and run the checks yourself. A lane's own pass is not proof. Stop any
preview server a lane started.

## Recover

T3 can fail GX with "Cannot create Codex shadow home entry … already exists
and is not a symlink". A Codex config edit that writes a real file into
`~/.codex_personal`, often with `.bak-*` copies, causes it.

1. Run `find ~/.codex_personal -maxdepth 1 ! -type l`. Only `auth.json`,
   `models_cache.json`, `log`, and `tmp` should be real files.
2. Check `lsof` on each extra file. Move each one to a backup directory, then
   run `ln -s ~/.codex/<entry> ~/.codex_personal/<entry>`.
3. Ask the owner to toggle the GX provider off and on in T3 settings. T3
   caches the failure. Restarting T3 also works but kills running lanes.
