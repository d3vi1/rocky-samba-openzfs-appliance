# Architecture

This appliance is delivered as a bootc/image-mode OS. The system is immutable at runtime; changes are applied by rebuilding and redeploying a new OCI image tag.

## Immutability boundaries
- OS packages and kernel are set at build time.
- ZFS kernel modules are built during the image build and must match the kernel.
- Runtime state is stored in `/var/lib/appliance` and `/etc/appliance`.
- Data lives in ZFS datasets (default `/tank`).

## Upgrade model
1. Update container build inputs (kernel version, config, packages).
2. Build a new image tag and push to GHCR.
3. Deploy/upgrade with bootc to the new tag.
4. Roll back by re-pinning to an older tag.
