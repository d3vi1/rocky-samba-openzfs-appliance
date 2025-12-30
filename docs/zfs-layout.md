# ZFS layout recommendations

For 10x 22TB NL-SAS disks, a `raidz2` layout balances resiliency and capacity.

## Suggested layout for film archival workloads
- Pool: `tank` (raidz2)
- Datasets:
  - `tank/media` (large sequential media)
  - `tank/projects` (active work, separate ACLs)
  - `tank/backups` (snapshots and backups)

## Baseline properties
Applied during pool creation in `apply-config`:
- `atime=off`
- `xattr=sa`
- `acltype=nfs4`
- `aclinherit=passthrough`
- `normalization=formD`
- `casesensitivity=mixed`
- `compression=lz4`
- `dnodesize=auto`

These defaults are SMB-friendly. Review `casesensitivity` behavior for application-specific needs.
