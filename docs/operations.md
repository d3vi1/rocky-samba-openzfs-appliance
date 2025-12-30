# Operations

## Upgrade
1. Update the build inputs (kernel version, config, packages).
2. Build and push a new image tag.
3. Reboot or upgrade with bootc to the new tag.

## Rollback
Re-pin the host to a previous image tag and reboot.

## Troubleshooting
- Logs: `journalctl -u appliance-firstboot.service` and `journalctl -u smb`.
- ZFS: `zpool status` and `zfs list`.
- Network: `nmcli con show` and `nmcli device status`.
