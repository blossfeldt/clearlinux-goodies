#!/bin/bash

#jre=-no-jbr
jre=""
ver=$(lynx -dump https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=intellij-idea-community-edition-no-jre | grep pkgver=)
dlLink=https://download.jetbrains.com/idea/ideaIC-${ver:7}$jre.tar.gz
file=ideaIC-${ver:7}$jre.tar.gz
dlDir=/tmp/intellij_download
iJdir=/opt/intelliJ/

if ! grep -q $dlLink /opt/intelliJ/version.txt; then
  echo New intelliJ Version. Upgrading...
  mkdir $dlDir && cd $dlDir
  echo -e $dlLink'\n'"$dlLink".sha256 | aria2c -i -
  if sha256sum -c *gz.sha256; then
    sudo tar xf $file -C /opt/ && \
    sudo rm -rf $iJdir && \
    sudo mv /opt/idea-IC* $iJdir && \
    printf $dlLink > version.txt && \
    sudo mv version.txt $iJdir
    rm -rf $dlDir
  else
    rm -rf $dlDir
    echo "Checksum mismatch."
  fi
else
   echo intelliJ is up-to-date.
fi
