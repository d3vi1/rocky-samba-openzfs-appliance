# Rocky Samba OpenZFS Appliance (bootc)

Rocky Linux 10.1 bootc/image-mode NAS appliance image with OpenZFS, Samba, Cockpit, and 45Drives Cockpit modules.

## What this is
- Immutable bootc OS image for Rocky/EL10
- OpenZFS storage on raw disks
- SMB file sharing with Windows ACL-friendly defaults
- Cockpit management UI with cockpit-zfs and cockpit-file-sharing modules

## What this is not
- A turn-key installer with interactive steps
- A place to run `dnf upgrade` on the host (rebuild and redeploy instead)

## Prerequisites
- Podman 4.x+ (macOS: use `podman machine`)
- bootc-image-builder container for ISO generation

## Build
```bash
make build
```

## Push
```bash
IMAGE_TAG=2025.01.0 make push
```

## Generate ISO
```bash
make iso
```

The ISO is created in `./artifacts`.

## Install (Dell R760 guidance)
- Configure the PERC H755 for an OS mirror on the 2x SATA SSDs (RAID1 virtual disk).
- Present the 10x 22TB NL-SAS HDDs as HBA/JBOD if possible.
  - If not possible, create 10 single-disk RAID0 virtual disks.
- Boot the ISO and install to the OS mirror.

## First boot configuration
Provide `/etc/appliance/config.yml` with the desired settings. You can:
- Bake it into the image (copy into `rootfs/etc/appliance/config.yml` before build), or
- Mount it at runtime and allow `appliance-firstboot.service` to apply it.

An example config is in `rootfs/etc/appliance/config.example.yml`.

## ZFS pools and datasets
- If `zfs.enabled` and `zfs.pool.create` are true, the pool will be created on first boot.
- Otherwise, any existing pool is imported if present.
- Datasets defined in the config are created if missing.

## Upgrade and rollback
- Build a new image tag (new kernel + rebuilt ZFS module) and redeploy.
- To roll back, re-pin to a previous image tag with bootc.

## 45Drives modules
The repository uses git submodules for the 45Drives Cockpit modules. Initialize them after clone:
```bash
git submodule update --init --recursive
```

## Quick commands
```bash
make build
make verify
make iso
```

## Notes
- The base image can be switched via `BASE_IMAGE` if Rocky bootc is not available; see `Containerfile`.
- ZFS module build is pinned to the kernel installed during image build.

## Prompt Ledger
This repo tracks LLM prompts in `prompts/` so changes are reproducible and auditable.

Create a prompt file before or during your change:
```bash
make prompt TITLE="short-title"
```

CI enforces that changes outside `docs/` or `prompts/` include an updated prompt file.
