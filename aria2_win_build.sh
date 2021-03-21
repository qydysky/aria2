#!/bin/bash

sudo apt-get install autopoint gettext build-essential flex libelf-dev libc6-dev-amd64 binutils-dev libdwarf-dev

rm -rf aria2_git
git clone --depth=1 https://github.com/aria2/aria2.git aria2_git
cp -rf ./patch/src ./aria2_git/
cd aria2_git

autoreconf -fi

HOST=x86_64-w64-mingw32
PREFIX=/usr/x86_64-w64-mingw32

./configure \
    --host=$HOST \
    --prefix=$PREFIX \
    --without-included-gettext \
    --disable-nls \
    --with-libcares \
    --without-gnutls \
    --without-wintls \
    --with-openssl \
    --with-sqlite3 \
    --without-libxml2 \
    --with-libexpat \
    --with-libz \
    --without-libgmp \
    --with-libssh2 \
    --without-libgcrypt \
    --without-libnettle \
    --with-cppunit-prefix=$PREFIX \
    ARIA2_STATIC=yes \
    CPPFLAGS="-I$PREFIX/include" \
    LDFLAGS="-L$PREFIX/lib" \
    PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"

make
cd ..
cp aria2_git/src/aria2c ./aria2c.exe
rm -rf aria2_git