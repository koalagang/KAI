### DISCLAIMER

This installer has been developed for MY OWN use. You are free to fork it or use it but it has been designed for my system and my preferences; I will not tailor this software to anyone but my own needs. *I AM NOT RESPONSIBLE FOR ANY DAMAGES YOU MAY ENDURE THROUGH THE USE OF THESE SCRIPTS.* I personally recommend that you learn how to install Artix Linux the manual way. If you really want an easy Artix install then download one of the [Artix isos](https://artixlinux.org/download.php) which comes with a desktop environment. Also note that this script sets up the timezone as Europe/London.

This script installs the runit version of Artix, *not* the OpenRC or s6 version.
If you still wish to use KAI, proceed with the instructions below.

### Instructions
Any text in these instructions formatted `like this` is a command which you should execute.

1. Login using username: 'artix' and password: 'artix'
2. Enable root privilidges by entering `su` and typing in the password: 'artix'
3. Partition your disk like this - /dev/sda1 = smallest partition (about 128M to 512M), /dev/sda2 = largest partition (the rest of the storage available)
4. Download git and glibc `pacman -Syy && pacman -S glibc git`
5. Clone this repo `git clone https://github.com/koalagang/kai.git`
6. Run the script `chmod +x kai/artix-installer.sh && ./kai/artix-installer.sh`
7. Reboot your computer with `reboot`. Depending on your BIOS settings, you may need to shutdown `loginctl poweroff` and remove your live boot before you turn it back on.
