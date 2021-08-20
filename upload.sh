#!/bin/sh
buildarch=$(apk --print-arch)

mcli cp --attr arch="${buildarch}"\;stamp="$(date +%Y%m%d)"\;tag=system system.squashfs "master/abyss/images/system-${buildarch}-$(date +%Y%m%d).squashfs"
