#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-ghcr.io/d3vi1/rocky-samba-openzfs-appliance}"
IMAGE_TAG="${IMAGE_TAG:-dev}"
BASE_IMAGE="${BASE_IMAGE:-quay.io/rockylinux/rockylinux-bootc:10}"
KERNEL_VERSION="${KERNEL_VERSION:-}"

PUSH=0
if [[ "${1:-}" == "--push" ]]; then
  PUSH=1
fi

build_args=(
  --build-arg "BASE_IMAGE=${BASE_IMAGE}"
)
if [[ -n "${KERNEL_VERSION}" ]]; then
  build_args+=(--build-arg "KERNEL_VERSION=${KERNEL_VERSION}")
fi

podman build "${build_args[@]}" -t "${IMAGE_NAME}:${IMAGE_TAG}" -f "${ROOT_DIR}/Containerfile" "${ROOT_DIR}"

if [[ "${PUSH}" -eq 1 ]]; then
  podman push "${IMAGE_NAME}:${IMAGE_TAG}"
fi
