#!/bin/bash

# Script for downloading prebuilt "hc" binary

echo Executing \"$0\".
echo OSTYPE: $OSTYPE
ARCH=$(uname -m)
echo arch: $ARCH

# Check pre-conditions
if [ $# != 2 ]; then
  echo 1>&2 "$0: Aborting. Missing arguments: requested version & output folder"
  exit 2
fi

binFolder=$1
version=$2

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
echo Downloading version \"$version\" to folder \"$binFolder\"

### DOWNLOADING hc.exe

exename=hc

hc_file=$exename$fileext
hc_path=$binFolder/$hc_file

echo hc_path: $hc_path

if test -f "$hc_path"; then
  echo \"$hc_path\" found. Download aborted.
  exit 0
fi

if [ -d "holochain" ]; then
   echo holochain subfolder found. Download aborted.
   exit 1
fi

tarfile=$exename-$platform-$ARCH.tar.gz

value=`curl -s https://api.github.com/repos/ddd-mtl/hc-prebuilt/releases/tags/$version | grep "/$tarfile" | cut -d '"' -f 4`

if [ "$value" == "" ]; then
  echo Version not found for file \"$tarfile\". Download aborted.
  exit 0
fi

mkdir -p $binFolder

echo Downloading \'$value\'
wget -q $value

tar -xvzf $tarfile
rm $tarfile
mv holochain/target/release/$hc_file $binFolder
rm -rf holochain


### DOWNLOADING hc-sandbox.exe

exename=hc_sandbox

hc_file=$exename$fileext
hc_path=$binFolder/$hc_file

echo hc_path: $hc_path

if test -f "$hc_path"; then
  echo \"$hc_path\" found. Download aborted.
  exit 0
fi

if [ -d "holochain" ]; then
   echo holochain subfolder found. Download aborted.
   exit 1
fi

tarfile=$exename-$platform-$ARCH.tar.gz

value=`curl -s https://api.github.com/repos/ddd-mtl/hc-prebuilt/releases/tags/$version | grep "/$tarfile" | cut -d '"' -f 4`

if [ "$value" == "" ]; then
  echo Version not found for file \"$tarfile\". Download aborted.
  exit 0
fi

mkdir -p $binFolder

echo Downloading \'$value\'
wget -q $value

tar -xvzf $tarfile
rm $tarfile
mv holochain/target/release/hc-sandbox$fileext $binFolder
#rm -rf holochain
