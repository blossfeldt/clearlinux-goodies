#!/bin/bash

th=$(nproc)

git-pull-shallow() {
     git fetch --depth 1
     git reset --hard origin/master
     git clean -dfx
}

ninja_build() {
  dir=$1
  remote=$2
  if [ -d "$dir" ]; then
    cd $dir
    git-pull-shallow
  else
    git clone --depth 1 $remote
    cd $dir
  fi
  rm -rf build
  meson build $OPTS && \
  ninja -j$th -C build && \
  sudo ninja -C build install
  cd ..
}

make_build() {
  dir=$1
  remote=$2
  if [ -d "$dir" ]; then
    cd $dir
    git-pull-shallow
  else
    git clone --depth 1 $remote
    cd $dir
  fi
  make clean
  make -j$th $OPTS && \
  sudo make PREFIX=/usr/local $INSTALL install
  cd ..
}

build_ydotool() {
  dir=ydotool
  remote=https://github.com/ReimuNotMoe/ydotool.git
  if [ -d "$dir" ]; then
    cd $dir
    git-pull-shallow
  else
    git clone --depth 1 $remote
    cd $dir
  fi
  rm -rf build
  mkdir build
  cd build
  cmake .. && \
  make -j$th && \
  sudo make PREFIX=/usr/local  install
  cd ../..
}

build_wofi() {
  dir=wofi
  remote=https://hg.sr.ht/~scoopta/wofi
  if [ -d "$dir" ]; then
    cd $dir
    hg pull
  else
    hg clone $remote
    cd $dir
  fi
  rm -rf build
  meson build && \
  ninja -j$th -C build && \
  sudo ninja -C build install
  cd ..
}

build_foot() {
  dir=foot
  remote=https://codeberg.org/dnkl/foot.git
  if [ -d "$dir" ]; then
    cd $dir
    git pull 
  else
    git clone $remote
    cd $dir
  fi
  rm -rf bld
  mkdir -p bld/release && cd bld/release
  meson --buildtype=release --prefix=/usr/local -Db_lto=true ../..
  ninja -j$th
  ninja test
  sudo ninja install
  cd ../../..
}

#rustup update stable
#cargo install alacritty
#cargo install wl-clipboard-rs
#cargo install broot
#cargo install fd
#cargo install persway
#build_foot
#build_ydotool
#build_wofi
#make_build microbright https://github.com/blossfeldt/microbright.git
#make_build microbat https://github.com/blossfeldt/microbat.git
#make_build pamixer https://github.com/cdemoulins/pamixer.git
#OPTS="ENABLE_SYSTEMD=1" INSTALL="INSTALL_UDEV_RULES=0" make_build brightnessctl https://github.com/Hummer12007/brightnessctl.git
#OPTS="clients wayland" make_build bemenu https://github.com/Cloudef/bemenu.git
#ninja_build wob https://github.com/francma/wob.git
#ninja_build mako https://github.com/emersion/mako.git
#OPTS=". -Dwindows=wayland" ninja_build imv https://github.com/eXeC64/imv.git
#ninja_build grim https://github.com/emersion/grim.git
#ninja_build slurp https://github.com/emersion/slurp.git
#ninja_build nwg-launchers https://github.com/nwg-piotr/nwg-launchers.git
#ninja_build Waybar https://github.com/Alexays/Waybar.git
