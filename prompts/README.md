# Prompt Ledger

The Prompt Ledger captures the LLM prompts that drive meaningful changes to this repository. Every substantial change (IaC, build, config, code) should have a matching prompt file so we can reproduce and audit intent over time.

## Workflow
1. Create a new prompt file:
   ```bash
   make prompt TITLE="add-storage-metrics"
   ```
2. Fill in the template fields and the **Prompt** section with the exact prompt text used.
3. Reference the prompt file in your PR and commit trailer.

## Policy
If a change modifies files outside `docs/` or `prompts/`, at least one prompt file in `prompts/` must be added or updated in the same change set. CI enforces this via `scripts/check-prompts.sh`.
