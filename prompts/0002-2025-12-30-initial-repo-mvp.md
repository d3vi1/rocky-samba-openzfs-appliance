---
id: "0002"
date: "2025-12-30"
author: "assistant"
model: "codex"
goal: "Create the initial Rocky bootc NAS appliance MVP in this repo."
scope:
  - "Containerfile"
  - "rootfs/usr/libexec/appliance/*"
  - "scripts/*"
  - "docs/*"
  - ".github/workflows/*"
constraints:
  - "Idempotent scripts"
  - "No secrets"
validation:
  - "make build"
  - "make verify"
links:
  - ""
---

## Prompt

You are a senior Linux storage/SRE engineer. Populate the existing GitHub repo
https://github.com/d3vi1/rocky-samba-openzfs-appliance with a complete, working MVP
for a Rocky Linux 10.1 bootc/image-mode “NAS appliance” that provides:
- OpenZFS-based storage (10x HDD pool, raw disks)
- Samba SMB file sharing (Windows ACL-friendly defaults; performance tuning later)
- Cockpit management UI
- 45Drives Cockpit modules: cockpit-zfs and cockpit-file-sharing (vendored/included)
- IaC-style reproducible build + redeploy
- Clean upgrade/rollback story: rebuild/push new OCI image tags

IMPORTANT CONTEXT / ASSUMPTIONS
- Target OS: Rocky Linux 10.1 in bootc/image mode (OCI-based OS image).
- Ignore Samba version gaps as a “problem” for now; performance features can be upgraded later.
- Hardware baseline (for docs/examples): Dell R760, PERC H755, 2x SATA SSD (OS mirror via RAID1),
  10x 22TB NL-SAS HDDs for ZFS, 2-port Broadcom BCM5720 NIC (LACP bond).
- Provide configuration examples (YAML) for:
  - static IP/bond (LACP) via NetworkManager (nmcli) on bond0
  - DNS/gateway
  - hostname
  - admin SSH keys
  - ZFS pool name/layout
  - Samba shares & export paths
- No interactive steps required at runtime; all scripts must be idempotent.

HIGH-LEVEL DELIVERABLES (repo content)
1) Containerfile (or Dockerfile) that builds the bootc OS image.
   - Start from a Rocky 10 bootc base image if viable; if not, document and use AlmaLinux 10 bootc
     as the build base but keep the project name Rocky-oriented and leave a clearly isolated
     “base image switch” section.
   - Install: cockpit + cockpit-ws, samba packages, openssh-server, NetworkManager, firewalld,
     zfs userspace + kernel module build pipeline.
   - Enable: cockpit.socket, sshd, firewalld (with cockpit and samba allowed), zfs services,
     samba services.
   - Add a small “appliance” layer: /usr/libexec/appliance/* scripts, /etc/appliance/* defaults.

2) OpenZFS integration for EL10 image-mode
   - Use the official OpenZFS packaging approach for EL (zfs-release RPM).
   - Because ZFS is an out-of-tree kernel module, ensure the built OS image contains
     both the kernel and the matching ZFS module for that kernel version.
   - Approach: in the Containerfile, install a pinned kernel package and matching kernel-devel,
     install zfs (DKMS) and build the module for that pinned kernel at image-build time.
   - Add a build script that extracts the kernel version inside the image and runs
     dkms autoinstall for that exact version, verifying that:
       /usr/lib/modules/<kver>/extra/zfs/zfs.ko (or equivalent) exists
   - Add a note in docs: upgrades occur by rebuilding a new image tag that includes
     the new kernel + rebuilt ZFS module; never “dnf upgrade” on the host.

3) Appliance configuration & first boot
   - Provide /etc/appliance/config.yml schema with clear documentation and an example file.
   - Implement /usr/libexec/appliance/apply-config (bash) that is idempotent and can be run multiple times.
     It should:
     a) Configure NetworkManager bond (LACP / 802.3ad) + static IP if configured.
     b) Configure hostname/timezone (Europe/Bucharest by default, configurable).
     c) Configure firewalld for cockpit and samba.
     d) Ensure cockpit.socket and sshd are enabled/running.
     e) Configure Samba:
        - Generate smb.conf from a template using config.yml (shares, paths, options).
        - Include sane baseline options and log rotation.
        - Provide share examples for ZFS dataset mountpoints.
     f) Configure ZFS:
        - Import existing pool if present; else create pool if explicitly enabled in config.yml.
        - Use stable /dev/disk/by-id paths; never /dev/sdX.
        - Set baseline ZFS properties:
          atime=off, xattr=sa, acltype=nfs4, aclinherit=passthrough, normalization=formD,
          casesensitivity=mixed (where appropriate for SMB; document caveats),
          compression=lz4, dnodesize=auto.
        - Create datasets and mountpoints as declared in config.yml.
     g) Optionally create a local admin user (non-root) and install SSH keys (configurable).
   - Add a systemd unit appliance-firstboot.service that runs apply-config on first boot
     (ConditionPathExists=/etc/appliance/firstboot.done) and then writes that file.

4) 45Drives Cockpit modules
   - Vendor the plugin sources into the repo (e.g., vendor/45drives/cockpit-zfs and vendor/45drives/cockpit-file-sharing),
     pinned to known commits, preferably as git submodules OR vendored copies with a NOTICE file.
   - Install these into /usr/share/cockpit/<module> as part of image build.
   - Add a small compatibility note: “community-supported on EL10; verify on target.”

5) Build tooling
   - Provide a Makefile with targets:
     make build          (build OCI image locally with podman)
     make push           (push to GHCR; use env vars)
     make iso            (generate an installer ISO via bootc-image-builder in a container)
     make run-qemu       (optional: run in qemu if feasible; otherwise omit)
     make lint           (shellcheck, yamllint, markdownlint if included)
   - Provide scripts/ directory with:
     - build-image.sh
     - generate-iso.sh (using bootc-image-builder, with clear prerequisites)
     - verify-image.sh (checks kernel pinned, zfs module present, services enabled)

6) GitHub Actions CI/CD
   - Add a workflow that:
     - builds the image on push to main
     - runs basic verification (verify-image.sh)
     - pushes to ghcr.io/d3vi1/rocky-samba-openzfs-appliance:<tag> when on main
   - If ISO generation is too heavy for CI, provide a separate manual workflow_dispatch for ISO,
     or document that ISO is built locally.

7) Documentation
   - README.md with:
     - what the appliance is / is not
     - prerequisites (podman; on macOS use podman machine)
     - build & push instructions
     - how to generate ISO
     - install instructions for Dell R760 (OS on RAID1 SSD VD; HDDs in HBA or 1-disk RAID0 if needed)
     - first boot config: where to place /etc/appliance/config.yml (baked vs mounted)
     - how to create/import zpool and datasets
     - how to rollback (bootc image tag rollback conceptually)
   - docs/ directory:
     - architecture.md (bootc model, immutability boundaries)
     - config-reference.md (schema and examples)
     - zfs-layout.md (recommended pool/dataset layout for film archival workloads)
     - samba.md (baseline smb.conf + notes)
     - operations.md (upgrade, rollback, troubleshooting, logs)

QUALITY / ENGINEERING REQUIREMENTS
- All shell scripts must be bash with “set -euo pipefail” and be idempotent.
- Do not hardcode secrets. Use config.yml for non-secret settings and support reading
  SSH keys from files.
- Keep “state” in /var/lib/appliance and /etc/appliance. ZFS data stays on /tank (or configurable).
- Avoid fragile assumptions about interface names. Allow config to declare NIC members for the bond.
- Provide safe “dry-run” mode for apply-config where possible.
- Make sure the image boots and does not block if ZFS pool is absent (it should log and continue),
  unless pool creation is explicitly enabled.

OUTPUT EXPECTATIONS
- Commit all files into the repo with a clean structure.
- Add a CHANGELOG.md for versions/tags.
- Include sample /etc/appliance/config.example.yml.
- Ensure the repo is immediately usable by running:
  make build
  make iso
  then installing from ISO and placing config.yml.

If you must choose between “perfect ZFS module automation” and “a working MVP”, prefer
 a working MVP with clear docs and a stable pinned kernel+zfs build strategy.

Proceed to implement now.

## Notes / Outcome

Captured the initial MVP prompt that generated the repo.

## Files changed

- [ ] prompts/0002-2025-12-30-initial-repo-mvp.md
