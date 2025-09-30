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

# 1. Abort if the file exists
if [ -f "$1/hc" ]; then
    echo "Error: hc binary file already exists. Aborting script." >&2
    exit 1
fi

binFolder=$1
version=$2

platform="windows-msvc"
fileext=".exe"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        platform="unknown-linux-gnu"
        fileext=""
elif [[ "$OSTYPE" == "darwin"* ]]; then
        platform="apple-darwin"
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

### DOWNLOADING hc

namestuff=v$version-$ARCH-$platform
hc_file=hc-$namestuff

hc_file_ext=$hc_file$fileext
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

#tarfile=$exename-$platform-$ARCH.tar.gz
#value=`curl -s https://api.github.com/repos/ddd-mtl/hc-prebuilt/releases/tags/$version | grep "/$tarfile" | cut -d '"' -f 4`

ASSET_URL=`curl -s https://api.github.com/repos/matthme/holochain-binaries/releases/tags/hc-binaries-$version | grep "$hc_file_ext" -A 10 | grep "browser_download_url" | sed -E 's/.*"browser_download_url": "([^"]*)".*/\1/'`

if [ "$ASSET_URL" == "" ]; then
  echo Version not found for file \"$tarfile\". Download aborted.
  exit 0
fi

mkdir -p $binFolder

echo Downloading \'$ASSET_URL\'
wget -q $ASSET_URL

#tar -xvzf $tarfile
#rm $tarfile
chmod +x $hc_file_ext
mv $hc_file_ext $binFolder/hc
#rm -rf holochain
