---
id: "0001"
date: "2025-01-01"
author: "team"
model: "codex"
goal: "Introduce the Prompt Ledger structure and enforcement."
scope:
  - "prompts/"
  - "scripts/check-prompts.sh"
  - ".github/workflows/prompt-ledger.yml"
constraints:
  - "No secrets"
  - "Keep scripts POSIX-compatible"
validation:
  - "make check-prompts"
links:
  - ""
---

## Prompt

Create the Prompt Ledger system with templates, helper scripts, CI checks, and documentation.

## Notes / Outcome

Initial ledger scaffolding.

## Files changed

- [ ] prompts/
