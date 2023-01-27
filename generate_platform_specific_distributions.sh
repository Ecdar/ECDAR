#!/bin/bash
read -rp "The version of this release: " version

TARGET_NAME="ecdar-${version}"
DEST="${HOME}/Documents/${TARGET_NAME}"

VERSION_FILE="src/main/resources/ecdar/version"

if [ -f $VERSION_FILE ]; then
    echo "version: ${version}" > $VERSION_FILE
else 
    echo "The file $(pwd)/${VERSION_FILE} does not exist. Make sure that you are executing this from the Ecdar-GUI repository root."
    exit 1
fi

# Generate distributable zip file with specified version
./gradlew clean # Clean build directory to prevent multiple .zip files from interfering with script
./gradlew -PecdarVersion=${version} runtimeZip

# Create temporary directory
TEMPD_LINUX=$(mktemp -d)
TEMPD_WINDOWS=$(mktemp -d)
TEMPD_MACOS_x86=$(mktemp -d)
TEMPD_MACOS_ARM=$(mktemp -d)

# Exit if the temporary directory was not created successfully
if [ ! -e "$TEMPD_LINUX" ] || [ ! -e "$TEMPD_WINDOWS" ] || [ ! -e "$TEMPD_MACOS_x86" ] || [ ! -e "$TEMPD_MACOS_ARM" ]; then
    >&2 echo "Failed to create one of the temp directory required for the build"
    exit 1
fi

# Make sure the temporary directory gets removed on script exit
trap "exit 1"           HUP INT PIPE QUIT TERM
trap 'rm -rf "$TEMPD"'  EXIT

# Unzip to temporary directory and copy the j-Ecdar and Reveaal engines to the resulting lib directories
unzip build/*linux_64.zip -d $TEMPD_LINUX
unzip build/*win_64.zip -d $TEMPD_WINDOWS
unzip build/*macOS_x86.zip -d $TEMPD_MACOS_x86
unzip build/*macOS_arm.zip -d $TEMPD_MACOS_ARM

cp lib/Reveaal $TEMPD_LINUX/*/lib
cp lib/Reveaal.exe $TEMPD_WINDOWS/*/lib
cp lib/Reveaal $TEMPD_MACOS_x86/*/lib
cp lib/Reveaal $TEMPD_MACOS_ARM/*/lib

cp lib/j-Ecdar $TEMPD_LINUX/*/lib
cp lib/j-Ecdar.exe $TEMPD_WINDOWS/*/lib
cp lib/j-Ecdar $TEMPD_MACOS_x86/*/lib
cp lib/j-Ecdar $TEMPD_MACOS_ARM/*/lib

# Copy examples directory
cp -r examples $TEMPD_LINUX/*
cp -r examples $TEMPD_WINDOWS/*
cp -r examples $TEMPD_MACOS_x86/*
cp -r examples $TEMPD_MACOS_ARM/*

# Copy README
cp src/main/resources/ecdar/README.md $TEMPD_LINUX/*
cp src/main/resources/ecdar/README.md $TEMPD_WINDOWS/*
cp src/main/resources/ecdar/README.md $TEMPD_MACOS_x86/*
cp src/main/resources/ecdar/README.md $TEMPD_MACOS_ARM/*

# Make sure that the engines can be executed by the user
chmod u+x $TEMPD/*/lib/j-Ecdar
chmod u+x $TEMPD/*/lib/j-Ecdar.exe
chmod u+x $TEMPD/*/lib/Reveaal
chmod u+x $TEMPD/*/lib/Reveaal.exe

# Clear target directory and copy the contents of the temporary directory to target
rm -r $DEST &>/dev/null; mkdir $DEST
cp -r $TEMPD_LINUX/* $DEST
cp -r $TEMPD_WINDOWS/* $DEST
cp -r $TEMPD_MACOS_x86/* $DEST
cp -r $TEMPD_MACOS_ARM/* $DEST
