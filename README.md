### DISCLAIMER

This installer has been developed for MY OWN convenience. You are free to fork it or use it but it has been designed for my system and my preferences; I will not tailor this software to anyone but my own needs. *I AM NOT RESPONSIBLE FOR ANY DAMAGES YOU MAY ENDURE THROUGH THE USE OF THESE SCRIPTS.* I personally recommend that you learn how to install Artix Linux the manual way. If you really want an easy Artix install then download one of the [Artix isos](https://artixlinux.org/download.php) which comes with a desktop environment.

This script installs the runit version of Artix, *not* the OpenRC or s6 version.
If you still wish to use KAI, proceed with the instructions below (not recommended).

### Instructions
Any text in these instructions formatted `like this` is a command which you should execute.

1. If you find yourself stuck on an infinitely loading "Successfully initialized wpa_supplicant", simply press the enter key. Login using username: 'artix' and password: 'artix'
2. Enable root privilidges by entering `su`
3. Install git `pacman -Syy git`
4. Clone this repo `git clone https://github.com/koalagang/kai.git`
5. Run the first script `./kai/koala-personal-installer-1.sh`
6. Answer any prompts
7. Reboot with `loginctl reboot` or shutdown with `loginctl poweroff`
8. Login to the new system
9. Run the post-installation script `./kai/koala-personal-post-installation.sh`
