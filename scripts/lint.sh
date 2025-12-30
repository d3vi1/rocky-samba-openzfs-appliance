#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck "${ROOT_DIR}/scripts"/* "${ROOT_DIR}/rootfs/usr/libexec/appliance"/*
else
  echo "shellcheck not installed; skipping" >&2
fi

if command -v yamllint >/dev/null 2>&1; then
  yamllint "${ROOT_DIR}/rootfs/etc/appliance"/*.yml "${ROOT_DIR}/docs"/*.md
else
  echo "yamllint not installed; skipping" >&2
fi

if command -v markdownlint >/dev/null 2>&1; then
  markdownlint "${ROOT_DIR}/README.md" "${ROOT_DIR}/docs"/*.md
else
  echo "markdownlint not installed; skipping" >&2
fi
