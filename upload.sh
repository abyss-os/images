#!/bin/sh
buildarch=$(apk --print-arch)

echo "system.squashfs"
mcli cp --attr arch="${buildarch}"\;stamp="$(date +%Y%m%d)"\;tag=system system.squashfs "master/abyss/images/system-${buildarch}-$(date +%Y%m%d).squashfs"
echo "rootfs.tar.zst"
mcli cp --attr arch="${buildarch}"\;stamp="$(date +%Y%m%d)"\;tag=rootfs rootfs.tar.zst "master/abyss/images/rootfs-${buildarch}-$(date +%Y%m%d).tar.zst"
