#!bash
case $MSYSTEM in
MINGW32)
    export MINGW_PACKAGE_PREFIX=mingw-w64-i686
    export HOST=i686-w64-mingw32
    ;;
MINGW64)
    export MINGW_PACKAGE_PREFIX=mingw-w64-x86_64
    export HOST=x86_64-w64-mingw32
    ;;
esac

pacman -S --noconfirm --needed $MINGW_PACKAGE_PREFIX-gcc \
    $MINGW_PACKAGE_PREFIX-winpthreads

PREFIX=/usr/local/$HOST
CPUCOUNT=$(grep -c ^processor /proc/cpuinfo)

#c-ares
rm -rf c-ares_git
git clone --depth=1 https://github.com/c-ares/c-ares.git c-ares_git
cd c-ares_git
autoreconf -fi
./configure \
    --disable-shared \
    --enable-static \
    --without-random \
    --disable-tests \
    --prefix=/usr/local/$HOST \
    --host=$HOST

make install -j$CPUCOUNT
cd ../
rm -rf c-ares_git
#c-ares

#expat
rm -rf libexpat_git
git clone --depth=1 https://github.com/libexpat/libexpat.git libexpat_git
cd libexpat_git/expat
./buildconf.sh
./configure \
    --disable-shared \
    --enable-static \
    --prefix=/usr/local/$HOST \
    --host=$HOST
    
make install -j$CPUCOUNT
cd ../../
rm -rf libexpat_git 
#expat

#libssh2
rm -rf libssh2_git
git clone --depth=1 https://github.com/libssh2/libssh2.git libssh2_git
cd libssh2_git
autoreconf -fi
./configure \
    --disable-shared \
    --enable-static \
    --prefix=/usr/local/$HOST \
    --host=$HOST \
    --with-crypto=wincng \
    LIBS="-lws2_32"

make install -j$CPUCOUNT
cd ../
rm -rf libssh2_git
#libssh2

#sql
rm -rf sqlite_git
git clone --depth=1 https://github.com/sqlite/sqlite.git sqlite_git
cd sqlite_git
./configure \
    --disable-shared \
    --enable-static \
    --prefix=/usr/local/$HOST \
    --host=$HOST

make install -j$CPUCOUNT
cd ../
rm -rf sqlite_git 
#sql

rm -rf aria2_git
git clone --depth=1 https://github.com/aria2/aria2.git aria2_git
cd aria2_git
git apply ../patch/1.patch

autoreconf -fi || autoreconf -fiv
./configure \
    --host=$HOST \
    --prefix=$PREFIX \
    --without-included-gettext \
    --disable-nls \
    --with-libcares \
    --without-gnutls \
    --without-openssl \
    --with-sqlite3 \
    --without-libxml2 \
    --with-libexpat \
    --with-libz \
    --with-libgmp \
    --with-libssh2 \
    --without-libgcrypt \
    --without-libnettle \
    --with-cppunit-prefix=$PREFIX \
    ARIA2_STATIC=yes \
    CPPFLAGS="-I$PREFIX/include" \
    LDFLAGS="-L$PREFIX/lib -Wl,--gc-sections,--build-id=none" \
    PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"
make -j$CPUCOUNT
cd ..
cp aria2_git/src/aria2c* ./
rm -rf aria2_git
