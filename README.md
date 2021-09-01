## IMPROVED KAI VERSION IN PROGRESS
I am currently working on a revised much improved version of KAI. When I originally made KAI I was pretty bad at shell/bash (and pretty much everything else to do with Linux for that matter) so I intend to make KAI a lot better and to allow for a more customised Artix system rather than how it works at its current state where there is very little personalisation.

*Stay tuned.*

### DISCLAIMER

This installer has been developed for MY OWN convenience. You are free to fork it or use it but it has been designed for my system and my preferences; I will not tailor this software to anyone but my own needs. *I AM NOT RESPONSIBLE FOR ANY DAMAGES YOU MAY ENDURE THROUGH THE USE OF THESE SCRIPTS.* I personally recommend that you learn how to install Artix Linux the manual way. If you really want an easy Artix install then download one of the [Artix isos](https://artixlinux.org/download.php) which comes with a desktop environment.

This script installs the runit version of Artix, *not* the OpenRC or s6 version.
If you still wish to use KAI, proceed with the instructions below.

### Instructions
Any text in these instructions formatted `like this` is a command which you should execute.

1. If you find yourself stuck on an infinitely loading "Successfully initialized wpa_supplicant", simply press the enter key. Login using username: 'artix' and password: 'artix'
2. Enable root privilidges by entering `su`
3. Partition your disk like this - /dev/sda1 = approx. 128M to 512M - this should be marked as bootable, /dev/sda2 = approx. 30G, /dev/sda3 = rest of the disk space. You may do this with `fdisk` *or* `cfdisk`.
4. Download git and glibc `pacman -Syy git`
5. Clone this repo `git clone https://github.com/koalagang/kai.git`
6. Run the script `chmod +x kai/artix-installer.sh && ./kai/artix-installer.sh`
7. After answering the prompts, feel free to leave the computer until it is done. Depending on the speed of your hardware and internet connection, this may or may not take long.
8. Reboot your computer with `reboot` or `loginctl reboot`. Depending on your BIOS settings, you may need to instead shutdown with `loginctl poweroff` (or `sudo shutdown -h now`) and remove your live key before you boot up again.
