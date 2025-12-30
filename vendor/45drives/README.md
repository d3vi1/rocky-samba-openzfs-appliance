# 45Drives Cockpit modules

This directory is reserved for vendored 45Drives Cockpit modules:
- cockpit-zfs
- cockpit-file-sharing

Due to restricted network access in this environment, the upstream sources are not fetched here.
To vendor them, run:

```bash
git submodule add https://github.com/45Drives/cockpit-zfs.git vendor/45drives/cockpit-zfs
git submodule add https://github.com/45Drives/cockpit-file-sharing.git vendor/45drives/cockpit-file-sharing
git commit -m "Vendor 45Drives cockpit modules"
```

Pin to known commits and record them in `vendor/45drives/NOTICE`.
