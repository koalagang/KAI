### DISCLAIMER

This installer has been developed for MY OWN use. You are free to fork it or use it but it has been designed for my system and my preferences; I will not tailor this software to anyone's but my own needs. I AM NOT RESPONSIBLE FOR ANY DAMAGES YOU MAY ENDURE THROUGH THE USE OF THESE SCRIPTS. I personally recommend that you learn how to install Arch Linux the manual way, if you haven't already, but if you want an easy Arch installation, check out [archfi](https://github.com/MatMoul/archfi), [LARBS](https://github.com/LukeSmithxyz/LARBS) or [james-d12's arch installer](https://github.com/james-d12/arch-installer). 

If you still wish to use KAI, proceed with the instructions.

### Instructions

1. Install an Arch iso from the [official Arch Linux website](https://archlinux.org/download/).
2. Flash it to a memory stick or CD drive and boot into it.
3. Run 'fdisk' or 'cfdisk' to partition your disk with fdisk or cfdisk respectively (Arch's guide recommends fdisk but I have found cfdisk to be much easier to use).
4. Format your partitions (visit the [Arch Wiki](https://wiki.archlinux.org/index.php/Installation_guide#Format_the_partitions) to see how if you do not know how to).
3. Run 'pacman -Syy && pacman -S git'.
4. Run 'git clone https://github.com/koalagang/KAI.git'.
5. Run 'cd KAI && bash installation.sh'. Give it some time to install Arch.

As of right now, it does not install any desktop environment or tiling window manager(neither does the post-installation script) so you will need to install that. If you wish to use my post-installation script (which I do not recommend because it is extremely tailored to me and, unless you use very similar software to me, it would install a lot of (what to you is) bloat), run 'cd KAI && bash post-installation.sh'. NOTE: the only user created is called 'admin'. The password to 'admin' and to root is "admin" - you should change this. You may also wish to switch to a different language and keyboard layout if you don't use the American keyboard layout or British English localisation.
