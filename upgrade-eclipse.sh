#!/bin/bash

#echo "https://ftp.fau.de/eclipse/technology/epp/downloads/release/2020-12/R/eclipse-cpp-2020-12-R-linux-gtk-x86_64.tar.gz"
release=$(curl -s https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=eclipse | rg '_release=' | cut -d '=' -f2)
if ! rg -q $release /opt/eclipse/version.txt; then
  echo New Eclipse Version: $release  Upgrading...
  link=https://ftp.fau.de/eclipse/technology/epp/downloads/release/${release}/eclipse-cpp-${release//\//-}-linux-gtk-x86_64.tar.gz
  sudo rm -rf /opt/eclipse
  curl -s $link | sudo tar xvz -C /opt  && \
  echo $release | sudo tee /opt/eclipse/version.txt
else
  echo "Eclipse is up-to-date"
fi
