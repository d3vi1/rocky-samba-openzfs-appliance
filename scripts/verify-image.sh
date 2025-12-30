#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-ghcr.io/d3vi1/rocky-samba-openzfs-appliance}"
IMAGE_TAG="${IMAGE_TAG:-dev}"

podman run --rm "${IMAGE_NAME}:${IMAGE_TAG}" bash -euo pipefail -c '
  kver="$(rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}\n" kernel | head -n1)"
  if [[ -z "${kver}" ]]; then
    echo "Kernel not installed" >&2
    exit 1
  fi
  if [[ ! -e "/usr/lib/modules/${kver}/extra/zfs/zfs.ko" ]]; then
    echo "ZFS module missing for ${kver}" >&2
    exit 1
  fi
  systemctl --root / is-enabled cockpit.socket
  systemctl --root / is-enabled sshd
  systemctl --root / is-enabled firewalld
  systemctl --root / is-enabled zfs-mount
  systemctl --root / is-enabled smb
'
