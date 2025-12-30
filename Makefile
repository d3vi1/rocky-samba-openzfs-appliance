IMAGE_NAME ?= ghcr.io/d3vi1/rocky-samba-openzfs-appliance
IMAGE_TAG ?= dev
KERNEL_VERSION ?=
BASE_IMAGE ?= quay.io/rockylinux/rockylinux-bootc:10

.PHONY: build push iso lint verify prompt check-prompts

build:
	./scripts/build-image.sh

push:
	./scripts/build-image.sh --push

iso:
	./scripts/generate-iso.sh

lint:
	./scripts/lint.sh

verify:
	./scripts/verify-image.sh

prompt:
	./scripts/new-prompt.sh "$(TITLE)"

check-prompts:
	./scripts/check-prompts.sh
