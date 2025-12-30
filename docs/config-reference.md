# Configuration reference

The appliance reads `/etc/appliance/config.yml`.

```yaml
system:
  hostname: rocky-nas
  timezone: Europe/Bucharest
network:
  bond:
    enabled: true
    name: bond0
    mode: 802.3ad
    members: [eno1, eno2]
    ipv4:
      address: 192.168.10.50/24
      gateway: 192.168.10.1
      dns: 192.168.10.53
admin:
  username: storageadmin
  shell: /bin/bash
  ssh_keys_file: /etc/appliance/admin_authorized_keys
zfs:
  enabled: true
  pool:
    name: tank
    create: true
    devices:
      - /dev/disk/by-id/wwn-0x5000c500e1234567
  datasets:
    - name: media
      mountpoint: /tank/media
samba:
  enabled: true
  workgroup: WORKGROUP
  server_string: Rocky ZFS Appliance
  shares:
    - name: media
      path: /tank/media
      browseable: true
      writable: true
      guest_ok: false
      options:
        - "valid users = @smbusers"
```

## Notes
- `network.bond.members` should list interface names to add to the bond.
- ZFS pool creation only occurs when `zfs.enabled` and `zfs.pool.create` are true.
- Use `/dev/disk/by-id` paths for disks.
