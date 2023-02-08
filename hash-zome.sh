#!/bin/bash

# Script for hashing a zome wasm file

echo Executing \"$0\".
echo OSTYPE: $OSTYPE

# Check pre-conditions
if [ $# != 3 ]; then
  echo 1>&2 "$0: Aborting. Missing arguments. Required: hash_zome folder, target filepath & output filepath"
  exit 2
fi

# Get binary file extension according to platform
fileext=".exe"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        fileext=""
elif [[ "$OSTYPE" == "darwin"* ]]; then
        fileext=""
fi

binfolder=$1
target=$2
output=$3
binarypath=$binfolder/hash_zome$fileext

# Check if tool needs to be installed
if [ ! -f $binarypath ] ; then
  echo \"$binarypath\" not found. Operation aborted.
fi

echo Hashing zome \"$target\" to  \"$target\" with \"$binarypath\"

if [ ! -f $target ] ; then
  echo Target file not found. Operation aborted.
  exit 1
fi

# Compute hash of the zome
value=`$binarypath $target`
if [ "$value" == "" ]
then
  echo hash_zome failed
  exit 1
fi
echo "$value" > $output
echo
echo "ZOME HASH = $value"
