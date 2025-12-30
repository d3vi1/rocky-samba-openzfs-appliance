#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

base_ref="${BASE_REF:-}"

if [[ -z "${base_ref}" ]]; then
  if [[ -n "${GITHUB_BASE_REF:-}" ]]; then
    git fetch origin "${GITHUB_BASE_REF}" >/dev/null 2>&1 || true
    base_ref="origin/${GITHUB_BASE_REF}"
  elif git rev-parse --verify origin/main >/dev/null 2>&1; then
    base_ref="origin/main"
  elif git rev-parse --verify main >/dev/null 2>&1; then
    base_ref="main"
  else
    base_ref="HEAD~1"
  fi
fi

changed_files=$(git diff --name-only "${base_ref}"...HEAD)

if [[ -z "${changed_files}" ]]; then
  echo "No changes detected."
  exit 0
fi

non_doc_changes=$(printf '%s\n' "${changed_files}" | awk '!/^docs\// && !/^prompts\//')

if [[ -z "${non_doc_changes}" ]]; then
  echo "Only docs/ or prompts/ changes detected."
  exit 0
fi

prompt_changes=$(printf '%s\n' "${changed_files}" | awk '/^prompts\//')

if [[ -z "${prompt_changes}" ]]; then
  echo "Prompt Ledger check failed: changes outside docs/ or prompts/ detected, but no prompt file updates found." >&2
  echo "Add or update a prompt in prompts/ using: make prompt TITLE=\"short-title\"" >&2
  exit 1
fi

echo "Prompt Ledger check passed."
