#!/bin/bash

# Script for downloading prebuilt "hc" binary

echo Executing \"$0\".
echo OSTYPE: $OSTYPE
ARCH=$(uname -m)
echo arch: $ARCH

# Check pre-conditions
if [ $# != 3 ]; then
  echo 1>&2 "$0: Aborting. Missing arguments: requested bin-name, version and output folder"
  exit 2
fi

# 1. Abort if the file exists
if [ -f "$2/$1" ]; then
    echo "Error: Binary file '$1' already exists in '$2'. Aborting script." >&2
    exit 1
fi

binName=$1
binFolder=$2
version=$3

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
echo Downloading \"$binName\" version \"$version\" to folder \"$binFolder\"

### DOWNLOADING hc

hc_file=$binName-$ARCH-$platform
hc_file_ext=$hc_file$fileext
hc_path=$binFolder/$hc_file

echo hc_path: $hc_path
echo hc_file_ext: $hc_file_ext

if test -f "$hc_path"; then
  echo \"$hc_path\" found. Download aborted.
  exit 0
fi


#tarfile=$exename-$platform-$ARCH.tar.gz
#value=`curl -s https://api.github.com/repos/ddd-mtl/hc-prebuilt/releases/tags/$version | grep "/$tarfile" | cut -d '"' -f 4`

ASSET_URL=`curl -s https://api.github.com/repos/holochain/holochain/releases/tags/holochain-$version | grep "$hc_file_ext" -A 10 | grep "browser_download_url" | sed -E 's/.*"browser_download_url": "([^"]*)".*/\1/'`

if [ "$ASSET_URL" == "" ]; then
  echo Version not found for file \"$binName\". Download aborted.
  exit 0
fi

mkdir -p $binFolder

echo Downloading \'$ASSET_URL\'
wget -q $ASSET_URL

#tar -xvzf $tarfile
#rm $tarfile
chmod +x $hc_file_ext
mv $hc_file_ext $binFolder/$binName
#rm -rf holochain
