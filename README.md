# Koala's Artix Installer (KAI)
## DISCLAIMER

This installer has been developed for MY OWN convenience. You are free to fork it or use it but it has been designed for my system and my preferences; I will not tailor this software to anyone but my own needs.\ **Any breakages are on you.**\ I personally recommend that you learn how to install Artix Linux the manual way. If you really want an easy Artix install then download one of the [Artix isos](https://artixlinux.org/download.php) which comes with a desktop environment.

This script installs the runit version of Artix.\
If you still wish to use KAI, proceed with the instructions below (not recommended).

## Instructions
Any text in these instructions formatted `like this` is a command which you should execute.

1. If you find yourself stuck on an infinitely loading "Successfully initialized wpa_supplicant", simply press the enter key.
2. Login using username: 'artix' and password: 'artix'
3. Enable root privilidges by entering `su`
4. Install git `pacman -Syy git`
5. Clone this repo `git clone https://github.com/koalagang/kai.git`
6. Run the first script `./kai/installer1.sh`
7. Answer any prompts
8. Reboot with `loginctl reboot` or shutdown with `loginctl poweroff`
9. Login to the new system
10. Run the post-installation script `./kai/post-installer.sh`
