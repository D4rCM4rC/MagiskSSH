An SSH server for Android devices having Magisk (build system)
==============================================================

This is my WIP for a fully functional system-daemon-like SSH server for Android devices.

Its core is a version of OpenSSH modified to be usable on Android. It also includes rsync (which actually was my main motivation for this project). It will be available for devices using the architectures arm, arm64, x86, x86_64, mips or mips64.

This repository is a collection of build scripts for simply building an installable Magisk module. It can not be installed itself. Once I have a working installable package, I will link it here.

It should run on all devices with Android API version 21 or higher (Android 5.0 Lollipop and higher) that have [Magisk](https://github.com/topjohnwu/Magisk) installed. It includes binaries for arm, arm64, x86, x86_64, mips and mips64. However I only tested it on my arm64 Xiaomi Redmi Note 4.


## Used Packages And Included Resources

* [OpenSSL 1.0.2l](https://www.openssl.org/) (only needed for its libcrypto)
* [OpenSSH 7.5p1](https://www.openssh.com/)
* [Rsync 3.1.2](https://rsync.samba.org/)
* [Magisk Module Template v1400](https://github.com/topjohnwu/magisk-module-template)

Some changes to OpenSSH are used from [Arachnoid's SSHelper](https://arachnoid.com/android/SSHelper/). Also I have to partially ship a version of `resolv.h` from my system. It is, as far as I can tell, an 'internal-only' header and not included in the Android NDK. Still OpenSSH somehow needs it to compile.


## How To Build

    <clone or download>
    cd <source dir>
    mkdir build
    cd build
    make -f ../all_arches.mk -j8 zip

A zip file will be created in the build-directory. It can be copied to the Android device and installed via the Magisk Manager app.

On my i7-6700k a full build takes about 150s.
The Android-NDK path is set to `/opt/android-ndk` per default. It can be changed by passing `ANDROID_ROOT=/path/to/ndk` to make.

## Build Dependencies

* Recent GNU/Linux system on amd64
* Make. Only tested using GNU Make 4.2.1
* Wget. Only tested using GNU Wget 1.19.1
* Android NDK. Only tested using version 14.1.3816874

Newer versions generally should work. Older versions may work or may not.


## License

This program is under the GPLv3. It downloads and bundles software with different licenses:

* OpenSSL [OpenSSL License](https://www.openssl.org/source/license.html)
* OpenSSH [BSD License](https://www.openbsd.org/policy.html)
* Rsync [GPL v3](https://rsync.samba.org/GPL.html)