# ECDAR
Ecdar is an abbreviation of Environment for Compositional Design and Analysis of Real Time Systems. This repo offers the graphical user interface, j-Ecdar engine, and Reveaal engine as a Zip archive.

## How to run
First, download the Zip archive and extract it to where you want the project to reside. Then execute the binary (_ecdar_ on Linux or Mac and _ecdar.bat_ on Windows). You are now running ECDAR!

## Build process
The folder contained in the zip file was generated using the build script contained in this repository and has only been tested on a Linux system (Ubuntu 22.04 LTS).

The script requires the following:
- A local version of the _Ecdar-GUI_ repository
- Combiled versions (both UNIX and Windows) of the _Reveaal_ engine placed in the _lib_ directory of the _Ecdar-GUI_ repository
- A local version of the _j-Ecdar_ repository and the directory name MUST be _j-Ecdar_ (for a guide on how to clone the _j-Ecdar_ please read [the related README.md](https://github.com/Ecdar/j-Ecdar#readme))
- The two repositories (Ecdar-GUI and j-Ecdar) must be placed in the same directory
- The script must be executed from the _Ecdar-GUI_ directory

This will generate a directory called _ecdar-x.y.z_, where _x.y.z_ is the version. The directory will contain all the required dependencies and both the _j-Ecdar_ and _Reveaal_ engines, which can be automatically picked up from the interface as default backends.
