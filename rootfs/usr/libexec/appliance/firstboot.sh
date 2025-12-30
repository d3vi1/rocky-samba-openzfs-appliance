#!/usr/bin/env bash
set -euo pipefail

MARKER="/etc/appliance/firstboot.done"

if [[ -f "${MARKER}" ]]; then
  exit 0
fi

/usr/libexec/appliance/apply-config

install -d -m 755 /etc/appliance
install -m 644 /dev/null "${MARKER}"
