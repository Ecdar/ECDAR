# ECDAR
Ecdar is an abbreviation of Environment for Compositional Design and Analysis of Real Time Systems. This repo offers the graphical user interface, j-Ecdar engine, and Reveaal engine bundled in a single Zip archive for Linux and Windows. The bundle includes a custom JRE that alleviates the need to install a specific Java version on the target machine.

## How to run
First, download the Zip archive and extract it to where you want the project to reside. Then execute the binary (_ecdar_ on Linux or Mac and _ecdar.bat_ on Windows). You are now running ECDAR!

## Build process
The folder contained in the zip file was generated using the build script contained in this repository (only tested on Ubuntu 22.04 LTS).

### Requirements
The script requires the following:
- A cloned version of the _Ecdar-GUI_ repository
- Compiled versions (both UNIX and Windows) of the _j-Ecdar_ and _Reveaal_ engines placed in the _lib_ directory of the cloned _Ecdar-GUI_ repository
- A copy of the Script contained in this repository

### Step 1
Execute the script included in this repository from inside the cloned _Ecdar-GUI_ root directory.

> Ex. (bold text represents user input):\
> <span style="color:green">~/Documents/gitHub/Ecdar-GUI/$</span> **./../ECDAR/generate_platform_specific_distributions.sh**

### Step 2
Provide a version for the generated distributions

> Ex. (bold text represents user input):\
> <span style="color:green">~/Documents/gitHub/Ecdar-GUI/$</span> **./../ECDAR/generate_platform_specific_distributions.sh**\
> The version of this release: **2.3.4**

### Result
This will generate a directory called _ecdar-x.y.z_ in the _/home/[USER]/Documents_ directory, where _x.y.z_ is the version.
The directory will contain a versioned directory for each supported operating systems.
These directories contain all required dependencies and both the _j-Ecdar_ and _Reveaal_ engines, which can be automatically picked up from the interface as default backends.
