#!/bin/bash

if [ $# -ne 1 ]; then
	echo "[USAGE] <$0 password for sudo>"
	exit 1
fi

PASSWORD=$1

brew install cmake gcc autoconf automake libtool zlib git

git clone https://github.com/openssl/openssl.git
cd openssl
git checkout OpenSSL_1_0_2-stable
./Configure darwin64-x86_64-cc shared no-md2 no-mdc2 no-rc5 no-rc4 --prefix=/usr/local
make depend
make
make test
echo $PASSWORD | sudo --stdin make install

