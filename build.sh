#!/bin/sh
TOPDIR=$PWD

# upgrade first
apk -U upgrade -a
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
    apk add -X "$ABYSS_CORE" --allow-untrusted --initdb --root rootfs "$@"
}

# get prereqs
apk add squashfs-tools

apka abyss-base bsdtar
echo "$ABYSS_CORE" > rootfs/etc/apk/repositories
echo "$ABYSS_DEV" >> rootfs/etc/apk/repositories

# default resolv.conf
echo nameserver 1.1.1.1 > rootfs/etc/resolv.conf

# apk fix busybox, because apk broken
crun apk fix $(crun apk info)

# enable services
crun ln -s /etc/init.d/getty /etc/init.d/getty.console
crun rc-update add getty.console default
crun rc-update add dhcpcd default
crun rc-update add loopback sysinit

# NO, NOT ALLOWED
crun sed -i 's/^persistent/#persistent/' /etc/dhcpcd.conf

# cleanup
rm -rf rootfs/var/cache/apk && mkdir rootfs/var/cache/apk

# create squashfs base
echo "system.squashfs"
mksquashfs rootfs system.squashfs -all-root

# rootfs.tar.gz
echo "rootfs.tar.zst"
crun bsdtar cf - . | zstd -v -9 -c > rootfs.tar.zst
