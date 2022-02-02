#!/usr/bin/env bash

# these should already be installed but let's just double-check that we have them all
sudo pacman git curl base base-devel -Syu --noconfirm --needed

# install paru (using baph so that we don't have to compile it)
curl -sL 'https://raw.githubusercontent.com/PandaFoss/baph/master/baph' -o baph && chmod +x baph
./baph -nN -i paru-bin

# configure pacman to support lib32 and have parallel downloads and pretty colours ;)
sudo cp --backup=numbered /etc/pacman.conf /etc/pacman.conf.bak && echo '/etc/pacman.conf has been safely backed up!'
sudo sed -i 's/#\[lib32\]/\[lib32\]/' /etc/pacman.conf && grep -A1 -n '\[lib32\]' /etc/pacman.conf | tail -1 | cut -d'-' -f1 | xargs -I% sudo sed -i '%s/#//' /etc/pacman.conf
sudo pacman -Syu artix-archlinux-support lib32-artix-archlinux-support --noconfirm && sudo pacman-key --populate archlinux
cat arch-repos.txt | sudo tee -a /etc/pacman.conf >/dev/null
sudo sed -i -e "s/#ParralelDownloads = 5/ParallelDownloads = 20/" -e 's/#Color/Color/' /etc/pacman.conf

# install all my packages
readarray -t progs < 'progs.txt'
paru -Syu "${progs[@]}" --noconfirm --needed
git clone https://github.com/koalagang/suckless-koala.git
if [ "$HOSTNAME" = 'Alfheim' ]; then
    sudo make install -C suckless-koala/dwm
    sudo make install -C suckless-koala/dwmblocks
elif [ "$HOSTNAME" = 'Asgard' ]; then
    sudo make install -C suckless-koala/think-dwm
    sudo make install -C suckless-koala/think-dwmblocks
fi
sudo make install -C suckless-koala/dmenu
sudo make install -C suckless-koala/slock
sudo make install -C suckless-koala/st
sudo make install -C suckless-koala/sxiv

# configure shells
sudo ln -sfT /bin/dash /bin/sh && cp bash2dash.hook /usr/share/libalmpm/hooks/bash2dash.hook
sudo chsh -s /bin/zsh
rm "$HOME"/.bash*

# set up file structure
git clone https://github.com/koalagang/dotfiles.git
mv dotfiles/* $HOME
mkdir -p "$HOME/Desktop/git/dotfiles"
git clone --bare https://github.com/koalagang/dotfiles.git "$HOME/Desktop/git/dotfiles/dotfiles"
git --git-dir=$HOME/Desktop/git/dotfiles/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
git clone https://github.com/koalagang/suckless-koala.git "$HOME/Desktop/git/suckless-koala"
git clone https://github.com/koalagang/archive.git "$HOME/Desktop/git/archive"

# not sure why but directly appending these files without tee doesn't work
cat hosts | sudo tee -a /etc/hosts >/dev/null
echo 'permit persist :wheel' | sudo tee -a /etc/doas.conf >/dev/null && sudo chown -c root:root '/etc/doas.conf' && sudo chmod 0444 '/etc/doas.conf'
sudo curl -sL 'https://raw.githubusercontent.com/koalagang/doasedit/main/doasedit' -o /usr/bin/doasedit && sudo chmod +x /usr/bin/doasedit
sudo pacman -R sudo --noconfirm && doas ln -s /usr/bin/doas /usr/bin/sudo

# clear cache
paru -c && doas paccache -r && doas paccache -ruk0

cd
rm -rf kai
