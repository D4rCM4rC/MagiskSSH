An SSH server for Android devices having Magisk
===============================================

This is an SSH server running as root using the great Magisk systemless root suite. It includes binaries for arm, arm64, x86, x86_64, mips and mips64. However, only arm64 has been tested at all. It requires Android API version 21 or higher (Android 5.0 Lollipop and higher).

## Installation

Download the zip file and install it via the Magisk Manager app. Once this module is available in the Magisk module repository, you can just install it from there.

## Configuration

SSH keys can be put into `/data/ssh/root/.ssh/authorized_keys` and `/data/ssh/shell/.ssh/authorized_keys` using your favorite method of editing files.

The sshd configuration file in `/data/ssh/sshd_config` can be edited as well, but please be aware that some features usually present in an OpenSSH installation may be missing. Most importantly, password login is not possible using this package.

The ssh daemon automatically starts on device boot. If this is undesired, you can create a file `/data/ssh/no-autostart`. It will not start the service then.

## Usage

Once you have written a valid SSH public key into an `authorized_keys` file (see section 'Configuration' above), you can connect to the device using `ssh shell@<device_ip>` or `ssh root@<device_ip>`, while supplying the correct private key. You will drop into a shell on the device. sftp and rsync should work as usual.

If you want to manually start/stop the sshd-service, you may do so using `/magisk/ssh/opensshd.init start` and `/magisk/ssh/opensshd.init stop`. This is usually not necessary but may be useful if you use the `no-autostart` file described earlier.

## Uninstallation

Uninstalling the module via the Magisk Manager does not fully remove all data that has been installed or created during execution. You may want to delete the `/data/ssh` folder from your device to remove all traces of this module.