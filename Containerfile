# syntax=docker/dockerfile:1
# Base image switch section
# Use Rocky Linux bootc if available; fallback to AlmaLinux bootc for EL10 compatibility.
ARG BASE_IMAGE=quay.io/rockylinux/rockylinux-bootc:10
FROM ${BASE_IMAGE}

ARG KERNEL_VERSION=
ARG ZFS_RELEASE_RPM=https://zfsonlinux.org/epel/zfs-release.el10_1.noarch.rpm

ENV LANG=C.UTF-8

RUN set -euxo pipefail; \
    dnf -y install dnf-plugins-core; \
    if [ -n "${KERNEL_VERSION}" ]; then \
      dnf -y install kernel-${KERNEL_VERSION} kernel-devel-${KERNEL_VERSION}; \
    else \
      dnf -y install kernel kernel-devel; \
    fi; \
    dnf -y install \
      cockpit cockpit-ws cockpit-system cockpit-storaged \
      samba samba-client samba-common \
      openssh-server \
      NetworkManager \
      firewalld \
      python3 python3-pyyaml \
      jq \
      dkms \
      make gcc elfutils-libelf-devel \
      wget curl ca-certificates; \
    dnf -y install ${ZFS_RELEASE_RPM}; \
    dnf -y install zfs zfs-dkms zfs-dracut zfs-dracut; \
    dnf -y clean all

COPY rootfs/ /
COPY vendor/45drives/cockpit-zfs /usr/share/cockpit/cockpit-zfs
COPY vendor/45drives/cockpit-file-sharing /usr/share/cockpit/cockpit-file-sharing

RUN set -euxo pipefail; \
    /usr/libexec/appliance/build-zfs-module.sh; \
    systemctl enable cockpit.socket sshd firewalld zfs-import-cache zfs-mount zfs-zed; \
    systemctl enable smb nmb; \
    systemctl enable appliance-firstboot.service; \
    firewall-offline-cmd --add-service=cockpit; \
    firewall-offline-cmd --add-service=samba
