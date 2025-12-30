# Samba baseline configuration

The `apply-config` script renders `/etc/samba/smb.conf` using `render-smb-conf`.

## Baseline settings
- `vfs objects = acl_xattr`
- `map acl inherit = yes`
- `store dos attributes = yes`
- `inherit acls = yes`
- `inherit permissions = yes`

These defaults are aligned for Windows ACL use on ZFS.

## Share definitions
Shares are defined in `config.yml` under `samba.shares` with `path`, `browseable`, `writable`, and optional `options`.
