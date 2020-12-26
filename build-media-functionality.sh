#!/bin/bash

th=$(nproc)

git-pull-shallow() {
     git fetch --depth 1
     git reset --hard origin/master
     git clean -dfx
}

dav1d() {
  if [ -d "dav1d" ]; then
    cd dav1d
    git-pull-shallow
  else
    git clone --depth 1 https://code.videolan.org/videolan/dav1d.git
    cd dav1d
  fi
  rm -rf build
  mkdir build
  cd build/
  meson .. && \
  ninja -j$th && \
  sudo ninja install
  cd ../..
}

x264() {
  if [ -d "x264" ]; then
    cd x264
    make distclean
    git-pull-shallow
  else
    git clone --depth 1 https://code.videolan.org/videolan/x264.git
    cd x264
  fi
  PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" ./configure --prefix="/usr/local" --bindir="/usr/local/bin" --enable-lto --enable-static --enable-pic --enable-shared && \
  make -j$th && \
  sudo make install
  cd ..
}

x265() {
  if [ ! -d "x265_git" ]; then
    git clone https://bitbucket.org/multicoreware/x265_git
  fi
  cd x265_git
  git pull
  cd build/linux
  make clean
  cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/usr/local" -DENABLE_SHARED=on ../../source && \
  make -j$th && \
  sudo make install
  cd ../../..
}

fdkaac() {
  if [ ! -d "fdk-aac" ]; then
    git clone --depth 1 https://github.com/mstorsjo/fdk-aac
  fi
  cd fdk-aac
  make distclean
  git-pull-shallow
  autoreconf -fiv
  ./configure --prefix="/usr/local" --enable-shared && \
  make -j$th && \
  sudo make install
  cd ..
}

lame() {
  if [ ! -f "lame-3.100.tar.gz" ]; then
    wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
  fi
  rm -rf lame-3.100
  tar xzvf lame-3.100.tar.gz
  cd lame-3.100
  ./configure --prefix="/usr/local" --bindir="/usr/local/bin" --enable-shared --enable-nasm && \
  make -j$th && \
  sudo make install
  cd ..
}

opus() {
  if [ ! -d "opus" ]; then
    git clone --depth 1 https://github.com/xiph/opus.git
  fi
  cd opus
  make clean
  git-pull-shallow
  ./autogen.sh
  ./configure --prefix="/usr/local" --enable-shared && \
  make -j$th && \
  sudo make install
  cd ..
}

vpx() {
  if [ ! -d "libvpx" ]; then
    git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
  fi
  cd libvpx
  make clean
  git-pull-shallow
  ./configure --prefix="/usr/local" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm --enable-shared && \
  make -j$th && \
  sudo make install
  cd ..
}

ffmpeg() {
  rm -rf ffmpeg
  if [ ! -f "ffmpeg-4.3.1.tar.bz2" ]; then
    wget https://ffmpeg.org/releases/ffmpeg-4.3.1.tar.bz2
  fi
  tar xjf ffmpeg-4.3.1.tar.bz2 && \
  cd ffmpeg-4.3.1
  PATH="/usr/local/bin:$PATH" ./configure \
  --prefix="/usr/local" \
  --extra-cflags="-I/usr/local/include" \
  --extra-ldflags='-L/usr/local/lib -L/usr/local/lib64 -flto -fuse-linker-plugin' \
  --ar=gcc-ar \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --prefix="/usr/local" \
  --enable-gpl \
  --enable-libfdk_aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libdav1d \
  --enable-nonfree \
  --enable-shared \
  --enable-gnutls \
  --enable-gmp \
  --enable-libdrm \
  --enable-libxcb \
  --enable-libxml2 \
  --enable-libpulse \
  --enable-gpl \
  --enable-version3 \
  --enable-nonfree \
  --disable-podpages && \
  make -j$th && \
  sudo make install
  cd ..
  }


uchardet() {
  if [ -d "uchardet" ]; then
    cd uchardet
    make clean
    git-pull-shallow
  else
    git clone --depth 1 https://github.com/freedesktop/uchardet
    cd uchardet
  fi
  cmake . && \
  make -j$th && \
  sudo make install
  cd ..
}

mpv() {
  if [ -d "mpv" ]; then
    cd mpv
    ./waf clean
    ./waf distclean
    git-pull-shallow
  else
    git clone --depth 1 https://github.com/mpv-player/mpv.git
    cd mpv
  fi
  ./bootstrap.py
  ./waf configure --disable-alsa --disable-x11 --disable-xv --disable-vaapi-x11 --disable-vdpau-gl-x11 --disable-egl-x11 --disable-vaapi-x11 --disable-vaapi-x-egl --disable-javascript --disable-debug-build && \
  ./waf -j$th && \
  sudo ./waf install
  cd ..
}

uninstall_builds() {
  cd codecs
  cd dav1d/build ; sudo ninja uninstall ; cd ../..
  cd x264 ; sudo make uninstall ; cd ..
  cd x265_git/build/linux ; sudo make uninstall ; cd ../../..
  cd fdk-aac ; sudo make uninstall ; cd ..
  cd lame-3.100 ; sudo make uninstall ; cd ..
  cd opus ; sudo make uninstall ; cd ..
  cd libvpx ; sudo make uninstall ; cd ..
  cd ..
  cd ffmpeg ; sudo make uninstall ; cd ..
  cd uchardet ; sudo make uninstall ; cd ..
  cd mpv ; sudo ./waf uninstall ; cd ..
}

install_builds() {
   cd codecs
   cd dav1d/build && sudo ninja install && cd ../..
   cd x264 && sudo make install && cd ..
   cd x265_git/build/linux && sudo make install && cd ../../..
   cd fdk-aac && sudo make install && cd ..
   cd lame-3.100 && sudo make install && cd ..
   cd opus && sudo make install && cd ..
   cd libvpx && sudo make install && cd ..
   cd ..
   cd ffmpeg && sudo make install && cd ..
   cd uchardet && sudo make install && cd ..
   cd mpv && sudo ./waf install && cd ..
}


build_deps() {
  sudo swupd bundle-add #insert build dependencies here
}

codecs() {
  mkdir codecs
  cd codecs
  dav1d
  x264
  x265
  fdkaac
  lame
  opus
  vpx
  cd ..
}

build_ffmpeg() {
  codecs
  ffmpeg
}

build_mpv() {
  #sudo swupd bundle-remove  mpv
  uchardet
  mpv
}

upgrade_ytdl() {
  sudo pip3 uninstall youtube-dl
  sudo pip3 install youtube-dl
}

finishing_touches() {
sudo touch /etc/ld.so.conf
sudo mkdir -p /etc/environment.d/
sudo touch /etc/environment.d/10-codecs.conf
touch ${HOME}/.config/firefox.conf
if ! grep -q /usr/local/lib /etc/ld.so.conf; then
  echo /usr/local/lib | sudo tee -a /etc/ld.so.conf
fi
if ! grep -q /usr/local/lib64 /etc/ld.so.conf; then
  echo /usr/local/lib64 | sudo tee -a /etc/ld.so.conf
fi
if ! grep -q "LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib" /etc/environment.d/10-codecs.conf; then
  echo LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib | sudo tee -a /etc/environment.d/10-codecs.conf
fi
if ! grep -q "export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64" ${HOME}/.config/firefox.conf; then
  echo "export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64" >> ${HOME}/.config/firefox.conf
fi
sudo ldconfig
}

case "$1" in
        all)
            build_ffmpeg
	    build_mpv
	    upgrade_ytdl
	    finishing_touches
            ;;
	bdeps)
	    build_deps
	    ;;
        ffmpeg)
            ffmpeg
            ;;
        mpv)
            build_mpv
            ;;
	ytdl)
	    upgrade_ytdl
	    ;;
	finish)
	    finishing_touches
	    ;;
	uninstall)
	    uninstall_builds
	    ;;         
        *)
            echo $"Usage: $0 {all|bdeps|ffmpeg|mpv|ytdl|finish|uninstall}"
            exit 1
esac
