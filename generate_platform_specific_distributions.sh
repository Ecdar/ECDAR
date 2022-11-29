#!/bin/bash
read -p "The version of this release: " version

target_name="ecdar-${version}"
version_file="src/main/resources/ecdar/version"

if [ -f $version_file ]; then
    echo "version: ${version}" > $version_file
else 
    echo "The file $(pwd)/${version_file} does not exist. Make sure that you are executing this from the Ecdar-GUI repository root."
    exit 1
fi

# Generate distributable zip file with specified version
./gradlew clean # Clean build directory to prevent multiple .zip files from interfering with script
./gradlew -PecdarVersion=${version} runtimeZip

# Create temporary directory
TEMPD_LINUX=$(mktemp -d)
TEMPD_WINDOWS=$(mktemp -d)
TEMPD_macOSx86=$(mktemp -d)
TEMPD_macOSarm=$(mktemp -d)

# Exit if the temporary directory was not created successfully
if [ ! -e "$TEMPD_LINUX" ] || [ ! -e "$TEMPD_WINDOWS" ] || [ ! -e "$TEMPD_macOSx86" ] || [ ! -e "$TEMPD_macOSarm" ]; then
    >&2 echo "Failed to create one of the temp directory required for the build"
    exit 1
fi

# Make sure the temporary directory gets removed on script exit
trap "exit 1"           HUP INT PIPE QUIT TERM
trap 'rm -rf "$TEMPD"'  EXIT

# Unzip to temporary directory and copy Reveaal engine to resulting lib directory
unzip build/*linux_64.zip -d $TEMPD_LINUX
unzip build/*win_64.zip -d $TEMPD_WINDOWS
unzip build/*macOS_x86.zip -d $TEMPD_macOSx86
unzip build/*macOS_arm.zip -d $TEMPD_macOSarm
cp lib/Reveaal $TEMPD_LINUX/*/lib
cp lib/Reveaal.exe $TEMPD_WINDOWS/*/lib
cp lib/Reveaal $TEMPD_macOSx86/*/lib
cp lib/Reveaal $TEMPD_macOSarm/*/lib

# Copy examples directory
cp -r examples $TEMPD_LINUX/*
cp -r examples $TEMPD_WINDOWS/*
cp -r examples $TEMPD_macOSx86/*
cp -r examples $TEMPD_macOSarm/*

cp src/main/resources/ecdar/README.md $TEMPD_LINUX/*
cp src/main/resources/ecdar/README.md $TEMPD_WINDOWS/*
cp src/main/resources/ecdar/README.md $TEMPD_macOSx86/*
cp src/main/resources/ecdar/README.md $TEMPD_macOSarm/*

# Compile j-Ecdar zip archive
#cd ../j-Ecdar/
#./gradlew distZip

#TEMPJED=$(mktemp -d)
#if [ ! -e "$TEMPJED" ]; then
#    >&2 echo "Failed to create temporary directory for j-Ecdar compilation"
#    exit 1
#fi
#trap 'rm -r "$TEMPJED"' EXIT

# Unzip j-Ecdar and copy to temporary Ecdar-GUI directory
#unzip build/distributions/*.zip -d $TEMPJED
#mv $TEMPJED/*/bin/* $TEMPD/*/lib
#mv $TEMPJED/*/lib/* $TEMPD/*/lib
#cp lib/* $TEMPD/*/lib

# Make sure that engines can be executed by the user
#chmod u+x $TEMPD/*/lib/j-Ecdar
#chmod u+x $TEMPD/*/lib/j-Ecdar.bat
#chmod u+x $TEMPD/*/lib/Reveaal
#chmod u+x $TEMPD/*/lib/Reveaal.exe

# Clear target directory and copy the contents of the temporary directory to target
dest="${HOME}/Documents/${target_name}"
rm -r $dest &>/dev/null; mkdir $dest
cp -r $TEMPD_LINUX/* $dest
cp -r $TEMPD_WINDOWS/* $dest
cp -r $TEMPD_macOSx86/* $dest
cp -r $TEMPD_macOSarm/* $dest
