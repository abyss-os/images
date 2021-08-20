#!/bin/sh
rm -rf rootfs

ARCH=$(apk --print-arch)
ABYSS_CORE=https://mirror.abyss.run/abyss/core
ABYSS_DEV=https://mirror.abyss.run/abyss/devel

# chroot inside rootfs
crun() {
    chroot rootfs "$@"
}
# create base rootfs
apka() {
    apk add -X "$ABYSS_CORE" --no-cache --allow-untrusted --initdb --root rootfs "$@"
}

# get prereqs
apk add squashfs-tools

apka abyss-base
echo "$ABYSS_CORE" > rootfs/etc/apk/repositories
echo "$ABYSS_DEV" >> rootfs/etc/apk/repositories

# default resolv.conf
echo nameserver 1.1.1.1 > rootfs/etc/resolv.conf

# enable services
crun ln -s /etc/init.d/getty /etc/init.d/getty.console
crun rc-update add getty.console default
crun rc-update add dhcpcd default
crun rc-update add loopback sysinit

# NO, NOT ALLOWED
crun sed -i 's/^persistent/#persistent/' /etc/dhcpcd.conf

# create squashfs base
echo "system.squashfs"
mksquashfs rootfs system.squashfs -all-root