### DISCLAIMER

This installer has been developed for MY OWN use. You are free to fork it or use it but it has been designed for my system and my preferences; I will not tailor this software to anyone's but my own needs. I AM NOT RESPONSIBLE FOR ANY DAMAGES YOU MAY ENDURE THROUGH THE USE OF THESE SCRIPTS. I personally recommend that you learn how to install Arch Linux the manual way, if you haven't already, but if you want an easy Arch installation, check out [archfi](https://github.com/MatMoul/archfi), [LARBS](https://github.com/LukeSmithxyz/LARBS) or [james-d12's arch installer](https://github.com/james-d12/arch-installer).

If you still wish to use KAI, proceed with the instructions.

### Instructions

1. Install an Arch iso from the [official Arch Linux website](https://archlinux.org/download/).
2. [Verify its signature](https://wiki.archlinux.org/index.php/Installation_guide#Verify_signature).
3. Flash it to a memory stick or CD drive and boot into it.
4. Parition your drive, format it and mount your root parition (usually /dev/sda2, so run 'mount /dev/sda2 /mnt').
5. Run 'mdkir /mnt/boot' and then mount your boot partition (usually /dev/sda1, so run 'mount /dev/sda1 /mnt/boot').
6. Run 'pacman -Syy && pacman -S git'.
7. Run 'git clone https://github.com/koalagang/KAI.git' (the capitals in 'KAI' are important).
8. Change directory into KAI and then run installer-1.sh 'cd KAI && bash installer-1.sh'.
9. Run installer-2.sh 'bash installer-2.sh'.
10. Reboot your computer 'reboot'. Depending on your BIOS settings, you may need to shutdown 'shutdown now' and remove your live boot before you turn it back on.

As of right now, it does not install any desktop environment or tiling window manager(neither does the post-installation script) so you will need to install that. If you wish to use my post-installation script (which I do not recommend because it is extremely tailored to me and, unless you use very similar software to me, it would install a lot of (what to you is) bloat), run 'cd KAI && bash post-installation.sh'. NOTE: the only user created is called 'admin'. The password to 'admin' and to root is "admin" - you should change this. You may also wish to switch to a different language and keyboard layout if you don't use the American keyboard layout or British English localisation.
