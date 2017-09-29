An SSH server for Android devices having Magisk (build system)
==============================================================

This is my WIP for a fully functional system-daemon-like SSH server for Android devices.

Its core is a version of OpenSSH modified to be usable on Android. It also includes rsync (which actually was my main motivation for this project). It will be available for devices using the architectures arm, arm64, x86, x86_64, mips or mips64.

This repository is a collection of build scripts for simply building an installable Magisk module. It can not be installed itself. Once I have a working installable package, I will link it here.


## Used Packages And Included Resources

* OpenSSL 1.0.2l (only needed for its libcrypto)
* OpenSSH 7.5p1
* Rsync 3.1.2

Some changes to OpenSSH are used from [Arachnoid's SSHelper](https://arachnoid.com/android/SSHelper/). Also I have to partially ship a version of `resolv.h` from my system, as it is somehow needed to compile OpenSSH and, as far as I can tell, as 'internal-only' header not included in the Android NDK.

Of course it will use the Magisk module template.


## Build Dependencies

(versions TBD)

* Recent GNU/Linux system
* Make
* Wget
* Android NDK


## How To Build

(preliminary)

    mkdir build
    cd build
    make -f ../all_arches.mk -j8 all

## License

This program is under the GPLv3. It includes software with different licenses.