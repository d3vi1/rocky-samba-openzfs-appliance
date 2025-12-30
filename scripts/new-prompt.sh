#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPTS_DIR="${ROOT_DIR}/prompts"
TEMPLATE="${PROMPTS_DIR}/template.md"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 \"short-title\"" >&2
  exit 1
fi

title="$1"

date_str="$(date +%Y-%m-%d)"

slug=$(printf '%s' "${title}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')

max_id=0
if [[ -d "${PROMPTS_DIR}" ]]; then
  while IFS= read -r file; do
    base="$(basename "${file}")"
    id_prefix="${base%%-*}"
    if [[ "${id_prefix}" =~ ^[0-9]{4}$ ]]; then
      id_num=$((10#${id_prefix}))
      if [[ ${id_num} -gt ${max_id} ]]; then
        max_id=${id_num}
      fi
    fi
  done < <(find "${PROMPTS_DIR}" -maxdepth 1 -type f -name "*.md")
fi

next_id=$((max_id + 1))
next_id_formatted=$(printf '%04d' "${next_id}")

output_file="${PROMPTS_DIR}/${next_id_formatted}-${date_str}-${slug}.md"

if [[ -e "${output_file}" ]]; then
  echo "Prompt file already exists: ${output_file}" >&2
  exit 1
fi

if [[ ! -f "${TEMPLATE}" ]]; then
  echo "Missing template: ${TEMPLATE}" >&2
  exit 1
fi

sed \
  -e "s/{{id}}/${next_id_formatted}/g" \
  -e "s/{{date}}/${date_str}/g" \
  -e "s/{{author}}/your-name/g" \
  -e "s/{{model}}/codex/g" \
  -e "s/{{goal}}/describe goal/g" \
  -e "s/{{scope}}/areas or files/g" \
  -e "s/{{constraints}}/constraints/g" \
  -e "s/{{validation}}/commands or tests/g" \
  -e "s/{{links}}/optional links/g" \
  -e "s/{{prompt}}/paste prompt text here/g" \
  -e "s/{{notes}}/post-run notes/g" \
  -e "s/{{files_changed}}/list files or sections/g" \
  "${TEMPLATE}" > "${output_file}"

echo "Created ${output_file}"
