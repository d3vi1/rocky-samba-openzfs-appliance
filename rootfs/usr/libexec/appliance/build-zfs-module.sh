#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[build-zfs-module] $*"
}

kver="$(rpm -q --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' kernel | head -n1)"
if [[ -z "${kver}" ]]; then
  log "Unable to determine kernel version."
  exit 1
fi

log "Building ZFS DKMS module for ${kver}."
/usr/sbin/dkms autoinstall -k "${kver}"

if [[ ! -e "/usr/lib/modules/${kver}/extra/zfs/zfs.ko" ]]; then
  log "ZFS module not found for ${kver}."
  exit 1
fi

log "ZFS module present for ${kver}."
