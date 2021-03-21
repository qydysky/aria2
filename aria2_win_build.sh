#!/bin/bash

sudo apt-get install autopoint gettext

rm -rf aria2_git
git clone --depth=1 https://github.com/aria2/aria2.git aria2_git
cp -rf ./patch/src ./aria2_git/
cd aria2_git

autoreconf -fi


./configure \
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
    ARIA2_STATIC=yes

make
cd ..
cp aria2_git/src/aria2c ./aria2c.exe
rm -rf aria2_git