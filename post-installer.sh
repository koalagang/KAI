#!/usr/bin/env bash

# these should already be installed but let's just double-check that we have them all
sudo pacman git curl base base-devel -Syu --noconfirm --needed

# install paru (using baph so that we don't have to compile it)
curl -sL 'https://raw.githubusercontent.com/PandaFoss/baph/master/baph' -o "$HOME/baph" && chmod +x baph
./baph -nN -i paru-bin
rm "$HOME/baph"

# configure pacman to support lib32 and have parallel downloads and pretty colours ;)
sudo cp --backup=numbered /etc/pacman.conf /etc/pacman.conf.bak && echo '/etc/pacman.conf has been safely backed up!'
if [ "$HOST" = 'Alfheim' ]; then
    sudo cat arch-repos.txt >> /etc/pacman.conf
    sudo sed -i 's/#[lib32]/[lib32]/' /etc/pacman.conf && grep -A1 -n '\[lib32\]' /etc/pacman.conf | tail -1 | cut -d'-' -f1 | xargs -I% sudo sed -i '%s/#//' /etc/pacman.conf
    sudo pacman -Syu lib32-artix-archlinux-support --noconfirm
fi
sudo sed -i -e "s/#ParralelDownloads = 5/ParallelDownloads = 20/" -e 's/#Color/Color/' /etc/pacman.conf

# install all my packages
readarray -t progs < 'progs.txt'
paru -S "${progs[@]}" --noconfirm --needed
git clone https://github.com/koalagang/suckless-koala.git
if [ "$HOST" = 'Alfheim' ]; then
    sudo make install -C suckless-koala/dwm
    sudo make install -C suckless-koala/dwmblocks
elif [ "$HOST" = 'Asgard' ]; then
    sudo make install -C suckless-koala/think-dwm
    sudo make install -C suckless-koala/think-dwmblocks
fi
sudo make install -C suckless-koala/dmenu
sudo make install -C suckless-koala/slock
sudo make install -C suckless-koala/st
sudo make install -C suckless-koala/sxiv
sudo rm -rf suckless-koala

# configure shells
sudo ln -sfT /bin/dash /bin/sh && cp bash2dash.hook /usr/share/libalmpm/hooks/bash2dash.hook
sudo chsh -s /bin/zsh

# set up file structure
git clone https://github.com/koalagang/dotfiles.git
mv dotfiles/* $HOME
rm -rf dotfiles
mkdir -p "$HOME/Desktop/git/dotfiles"
git clone --bare https://github.com/koalagang/dotfiles.git "$HOME/Desktop/git/dotfiles/dotfiles"
git --git-dir=$HOME/Desktop/git/dotfiles/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
git clone https://github.com/koalagang/suckless-koala.git "$HOME/Desktop/git/suckless-koala"
git clone https://github.com/koalagang/archive.git "$HOME/Desktop/git/archive"

sudo cat hosts >> /etc/hosts
echo 'permit persist :wheel' > /etc/doas.conf && chown -c root:root '/etc/doas.conf' && chmod 0444 '/etc/doas.conf'
sudo curl -sL 'https://raw.githubusercontent.com/koalagang/doasedit/main/doasedit' -o /usr/bin/doasedit && chmod +x /usr/bin/doasedit
sudo pacman -R sudo --noconfirm && doas ln -s /usr/bin/doas /usr/bin/sudo

# clear cache
paru -c && doas paccache -r && doas paccache -ruk0
