---
name: find-docs
description: Use when a task depends on external API, library, framework, CLI, or cloud-service behavior, such as usage, configuration, migrations, or a library-specific failure. Skip ordinary refactoring and business logic.
---

# Find docs

Answer from the current official docs for the version actually installed, not
from memory. Remembered APIs drift, and a confident wrong flag costs more than
the lookup.

A framework name alone is not a trigger. Look something up when the answer
depends on what the library does. When a narrower product skill fits, such as a
Cloudflare skill, use that skill instead of this one.

1. **Version.** Read it from the manifest, the lockfile, or the installed
   command.
2. **Source.** Use the vendor's official docs or its maintained repo, directly
   or through a configured docs MCP such as context7. Read the page or the
   source itself, because search snippets drop constraints.
3. **Match.** Prefer docs for the installed version. If those don't exist, use
   the nearest official version and say which one. For changed behavior, read
   the migration guide or release notes.

## Rules

- **Never put credentials, personal data, or private code in a query.** Search
  queries leave the machine.
- **Add no docs service, account, or CLI beyond the configured ones.** Every
  dependency is one more thing to keep working.
- **On a failure, decide whether it is local or the service** before retrying.
  Then try another official source.
- **If no current source is reachable, say what is unverified.** Never present
  a remembered API as checked.

Stop when the docs resolve the question, or when more lookups won't help. Cite
the link and the version, and separate what the source says from your
inference.
