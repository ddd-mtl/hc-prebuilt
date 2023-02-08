#!/bin/bash

# Script for copying holochain-runner binary to electron bin folder (used for distributing electron app)

echo "copy-binaries.sh" os-type: $OSTYPE

# Check pre-conditions
if [ $# != 1 ]; then
  echo 1>&2 "$0: Aborting. Missing argument: bin folder path"
  exit 2
fi


binFolder=$1
moduleFolder="node_modules/@lightningrodlabs/electron-holochain/binaries"

echo binFolder set to $binFolder

mkdir -p $binFolder

if [[ $OSTYPE == 'darwin'* ]]; then
  cp $moduleFolder/holochain-runner $binFolder/holochain-runner
elif [[ $OSTYPE == 'linux-gnu'* ]]; then
  cp $moduleFolder/holochain-runner $binFolder/holochain-runner
elif [[ $OSTYPE == "cygwin" ]]; then
  # POSIX compatibility layer and Linux environment emulation for Windows
  cp $moduleFolder/holochain-runner.exe $binFolder/holochain-runner.exe
elif [[ $OSTYPE == "msys" ]]; then
  # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
  cp $moduleFolder/holochain-runner.exe $binFolder/holochain-runner.exe
fi

echo "copy-binaries.sh" DONE
