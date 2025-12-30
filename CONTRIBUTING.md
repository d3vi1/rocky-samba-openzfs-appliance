# Contributing

## Prompt Ledger
Use the Prompt Ledger for any meaningful change outside `docs/` or `prompts/`.

Create a prompt file:
```bash
make prompt TITLE="short-title"
```

## Commit message guidance
Add trailers to the commit message to reference the prompt:

```
Prompt: prompts/0007-YYYY-MM-DD-short-title.md
Model: codex
```

These trailers make it easy to trace changes back to the originating prompt.
