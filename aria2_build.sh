#!/bin/bash

sudo apt-get install autopoint gettext

cat '/etc/ssl/certs/ca-certificates.crt' > /dev/null
if [ "$?" -eq 0 ] ; then
CRT='/etc/ssl/certs/ca-certificates.crt'
else
CRT='./certs/ca-certificates.crt'
fi

rm -rf aria2_git
git clone --depth=1 https://github.com/aria2/aria2.git aria2_git
cd aria2_git
git apply ../patch/1.patch

autoreconf -fi

## BUILD ##
./configure \
    --without-libxml2 \
    --without-libgcrypt \
    --with-openssl \
    --without-libnettle \
    --without-gnutls \
    --without-libgmp \
    --with-libssh2 \
    --with-sqlite3 \
    --with-ca-bundle=$CRT \
    ARIA2_STATIC=yes \
    --enable-shared=no

make
cd ..
cp aria2_git/src/aria2c ./aria2c
rm -rf aria2_git