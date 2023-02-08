#!/bin/bash

# Script for downloading prebuilt "hc" binary

echo Executing \"$0\".
echo OSTYPE: $OSTYPE

# Check pre-conditions
if [ $# != 2 ]; then
  echo 1>&2 "$0: Aborting. Missing arguments: requested version & output folder"
  exit 2
fi




platform="Windows"
fileext=".exe"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        platform="Linux"
        fileext=""
elif [[ "$OSTYPE" == "darwin"* ]]; then
        platform="macOS"
        fileext=""
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

echo platform : $platform
echo Downloading version \"$1\" to folder \"$2\"

tarfile=hc_$platform.tar.gz

hc_file=hc$fileext
hc_path=$2/$hc_file

echo hc_path: $hc_path

if test -f "$hc_path"; then
  echo \"$hc_path\" found. Download aborted.
  exit 0
fi

if [ -d "holochain" ]; then
   echo holochain subfolder found. Download aborted.
   exit 1
fi

mkdir -p $2

value=`curl -s https://api.github.com/repos/ddd-mtl/hc-prebuilt/releases/tags/$1 | grep "/$tarfile" | cut -d '"' -f 4`

if [ "$value" == "" ]; then
  echo Version not found. Download aborted.
  exit 0
fi

echo Downloading \'$value\'
wget -q $value

tar -xvzf $tarfile
rm $tarfile
mv holochain/target/release/$hc_file $2
rm -rf holochain
