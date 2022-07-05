#!/bin/bash

target_name="ecdar-2.3.1"

# Generate distributable zip file
./gradlew distZip

# Unzip file to temp directory
TEMPD=$(mktemp -d)

# Exit if the temp directory wasn't created successfully.
if [ ! -e "$TEMPD" ]; then
    >&2 echo "Failed to create temp directory"
    exit 1
fi

# Make sure the temp directory gets removed on script exit.
trap "exit 1"           HUP INT PIPE QUIT TERM
trap 'rm -rf "$TEMPD"'  EXIT

# Unzip to temp directory and copy Reveaal engine to resulting lib folder
unzip build/distributions/*.zip -d $TEMPD
cp lib/Reveaal $TEMPD/*/lib
cp lib/Reveaal.exe $TEMPD/*/lib

# Compile j-Ecdar zip archive, extract to tmp dir, and move executable and lib files
cd ../j-Ecdar/
./gradlew distZip

TEMPJED=$(mktemp -d)
if [ ! -e "$TEMPJED" ]; then
    >&2 echo "Failed to create temp directory for j-Ecdar compilation"
    exit 1
fi
trap 'rm -r "$TEMPJED"' EXIT

# Unzip j-Ecdar and copy to temporary Ecdar-GUI directory
unzip build/distributions/*.zip -d $TEMPJED
mv $TEMPJED/*/bin/* $TEMPD/*/lib
mv $TEMPJED/*/lib/* $TEMPD/*/lib
cp lib/* $TEMPD/*/lib
chmod u+x $TEMPD/*/lib/j-Ecdar
chmod u+x $TEMPD/*/lib/j-Ecdar.bat
chmod u+x $TEMPD/*/lib/Reveaal
chmod u+x $TEMPD/*/lib/Reveaal.exe

# Clear target directory and copy temporary directory content to target
dest="${HOME}/Documents/${target_name}"
rm -r $dest; mkdir $dest
cp -r $TEMPD/*/* $dest
