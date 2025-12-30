#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-ghcr.io/d3vi1/rocky-samba-openzfs-appliance}"
IMAGE_TAG="${IMAGE_TAG:-dev}"
OUTPUT_DIR="${OUTPUT_DIR:-${ROOT_DIR}/artifacts}"

mkdir -p "${OUTPUT_DIR}"

podman run --rm -it \
  -v "${OUTPUT_DIR}:/output" \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type iso \
  --output /output \
  "${IMAGE_NAME}:${IMAGE_TAG}"
