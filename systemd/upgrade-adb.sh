#!/bin/bash

pkgver=$(curl -s https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=android-sdk-platform-tools |grep 'pkgver=' | cut -d '=' -f2)
wget -q -O /tmp/z.$$ https://dl.google.com/android/repository/platform-tools_r${pkgver}-linux.zip && unzip -j -o /tmp/z.$$ platform-tools/adb -d /usr/local/bin && rm /tmp/z.$$
