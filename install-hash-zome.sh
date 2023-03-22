#!/bin/bash

# Script for dowloading hash_zome binary to local folder

echo Executing \"$0\".
echo OSTYPE: $OSTYPE
ARCH=$(uname -m)
echo arch: $ARCH

# Check pre-conditions
if [ $# != 1 ]; then
  echo 1>&2 "$0: Aborting. Missing argument: output folder path"
  exit 2
fi

platform="pc-windows-msvc"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        platform="unknown-linux-gnu"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        platform="apple-darwin"
#elif [[ "$OSTYPE" == "cygwin" ]]; then
#        # POSIX compatibility layer and Linux environment emulation for Windows
#elif [[ "$OSTYPE" == "msys" ]]; then
#        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
#elif [[ "$OSTYPE" == "win32" ]]; then
#        # I'm not sure this can happen.
#elif [[ "$OSTYPE" == "freebsd"* ]]; then
#        platform="linux"
#else
        # Unknown.
fi


echo platform: $platform
echo output folder set to \"$1\"

mkdir -p $1

value=`curl -s https://api.github.com/repos/ddd-mtl/hash_zome/releases/latest | grep "/hash_zome-$ARCH-$platform.tar.gz" | cut -d '"' -f 4`
echo Donwloading \'$value\'
wget -q $value

tar -xvzf hash_zome-$ARCH-$platform.tar.gz -C $1
rm hash_zome-$ARCH-$platform.tar.gz

