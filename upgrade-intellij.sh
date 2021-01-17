#!/bin/bash

#jre=-no-jbr
jre=""
pkgver=$(curl https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=intellij-idea-ce | rg 'pkgver=' | cut -d '=' -f2)
file=ideaIC-${pkgver}${jre}.tar.gz
dlLink=https://download.jetbrains.com/idea/${file}

dlDir=/tmp/intellij_download
iJdir=/opt/intelliJ/

if ! rg -q $pkgver /opt/intelliJ/version.txt; then
  echo New intelliJ Version. Upgrading...
  mkdir $dlDir && cd $dlDir
  echo -e $dlLink'\n'"$dlLink".sha256 | aria2c -i -
  if sha256sum -c *gz.sha256; then
    sudo tar xf $file -C /opt/ && \
    sudo rm -rf $iJdir && \
    sudo mv /opt/idea-IC* $iJdir && \
    echo "New Version is "
    echo $pkgver | sudo tee ${iJdir}/version.txt && \
    rm -rf $dlDir
  else
    rm -rf $dlDir
    echo "Checksum mismatch."
  fi
else
   echo intelliJ is up-to-date.
fi
