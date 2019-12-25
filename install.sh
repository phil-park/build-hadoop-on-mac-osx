#!/bin/bash

if [ $# -ne 2 ]; then
	echo "[USAGE] $0 (password for sudo) (hadoop version x.y.z)"
	exit 1
fi

PASSWORD=$1
HADOOP_VERSION=$2

echo "Install zlib && openssl"
brew install zlib autoconf automake libtool cmake gcc

# if you need to install openssl@1.0
# delete beyond line's comment

# ./install-openssl.sh $PASSWORD


which protoc 2> /dev/null

if [[ $? -eq 0 && $(protoc --version | awk '{print $2}') == '2.5.0' ]]; then
	echo '[Info] Already installed protobuf 2.5.0'
else 
	echo "Install Protocol Buffer"
	wget https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.bz2
	tar xvf protobuf-2.5.0.tar.bz2
	cd protobuf-2.5.0
	echo "Compile Protocol Buffer"
	./configure CC=clang CXX=clang++ CXXFLAGS='-std=c++11 -stdlib=libc++ -O3 -g' LDFLAGS='-stdlib=libc++' LIBS="-lc++ -lc++abi"
	make -j 4 
	echo $PASSWORD | sudo --stdin make install
fi

cd ${HOME}
echo "Download Hadoop"
wget http://apache.mirror.cdnetworks.com/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}-src.tar.gz

echo "Extract Hadoop"
tar xzvf hadoop-${HADOOP_VERSION}-src.tar.gz
cd hadoop-${HADOOP_VERSION}-src

mvn clean install -DskipTests
mvn package -Pdist,native -DskipTests -Dtar

