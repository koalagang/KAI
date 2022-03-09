#!/usr/bin/env bash

is_installed (){
    whereis "$1" >/dev/null
}

# compile yay because it is written in go so it is fast to compile
# then install a pre-compiled paru binary and remove yay
is_installed 'paru' && paru_installed=1
if [ -z "$paru_installed" ]; then
    git clone https://aur.archlinux.org/yay.git
    ( cd yay && yes | makepkg -si )
    yay -S paru-bin --noconfirm
    yay -R yay --noconfirm
    rm -rf "$HOME/yay" "$HOME/.cache/yay" "$HOME/.cache/go-build"
fi

# configure pacman to support lib32 and have parallel downloads and pretty colours ;)
[ -f '/etc/pacman.conf.bak' ] && pacman_conf=1
if [ -z "$pacman_conf" ]; then
    sudo cp --backup=numbered /etc/pacman.conf /etc/pacman.conf.bak && echo '/etc/pacman.conf has been safely backed up!'
    sudo sed -i -e "s/#ParallelDownloads = 5/ParallelDownloads = 20/" -e 's/#Color/Color/' /etc/pacman.conf
    sudo sed -i 's/#\[lib32\]/\[lib32\]/' /etc/pacman.conf && grep -A1 -n '\[lib32\]' /etc/pacman.conf | tail -1 | cut -d'-' -f1 | xargs -I% sudo sed -i '%s/#//' /etc/pacman.conf
    sudo pacman -Syu artix-archlinux-support lib32-artix-archlinux-support --noconfirm --needed && sudo pacman-key --populate archlinux
    cat "$HOME/kai/arch-repos.txt" | sudo tee -a /etc/pacman.conf
fi

HOST_NAME="$(</etc/hostname)"

# install all my packages
is_installed 'libxft-bgra' || yes | paru -Syu libxft-bgra # conflicts with libxft
readarray -t progs < "$HOME/kai/progs.txt" && paru -S "${progs[@]}" --noconfirm --needed
git clone https://github.com/koalagang/suckless-koala.git
# install device specific packages
if [ "$HOST_NAME" = 'Ljosalfheim' ]; then
    sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat edk2-ovmf --noconfirm --needed
    suckless=('dmenu' 'slock' 'st' 'sxiv' 'dwm' 'dwmblocks')
elif [ "$HOST_NAME" = 'Svartalfheim' ]; then
    suckless=('dmenu' 'slock' 'st' 'sxiv' 'think-dwm' 'think-dwmblocks')
fi
for package in "${suckless[@]}"; do
    is_installed "$package" && sudo make install -C "suckless-koala/$package"
done
rm -rf suckless-koala

# create the file structures for the home
xdg-user-dirs-update
rm -r "$HOME/Public" "$HOME/Templates"
sed -i -e 's#XDG_TEMPLATES_DIR="$HOME/Templates"#XDG_TEMPLATES_DIR="$HOME/Desktop"#' \
    -e 's#XDG_PUBLICSHARE_DIR="$HOME/Public"#XDG_TEMPLATES_DIR="$HOME/Desktop"#' "$HOME/.config/user-dirs.dirs"
mkdir -p "$HOME/.local/share" "$HOME/.local/bin"
git clone https://github.com/koalagang/dotfiles.git
rm -rf dotfiles/.git && cp -rv dotfiles/.* $HOME && rm -rf dotfiles
[ -f "$HOME/Desktop/git/dotfiles" ] && dotfiles=1
if [ -z "$dotfiles" ]; then
    mkdir -p "$HOME/Desktop/git/dotfiles"
    git clone --bare https://github.com/koalagang/dotfiles.git "$HOME/Desktop/git/dotfiles/dotfiles"
    git --git-dir=$HOME/Desktop/git/dotfiles/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
fi
git clone https://github.com/koalagang/suckless-koala.git "$HOME/Desktop/git/suckless-koala"
git clone https://github.com/koalagang/archive.git "$HOME/Desktop/git/archive"

root_append (){
    printf '%s' "$1" | sudo tee -a "$2" >/dev/null
}

# not sure why but directly appending these files without tee doesn't work
grep -q 'startx' /etc/profile && etc_profile_startx=1
if [ -z "$etc_profile_startx" ]; then
    [ "$HOST_NAME" = 'Ljosalfheim' ] && root_append '# startx\n[ "$(tty)" = "/dev/tty1" ] && "$HOME/.config/X11/wmselect"' '/etc/profile'
    [ "$HOST_NAME" = 'Svartalfheim' ] && root_append '# startx\n[ "$(tty)" = "/dev/tty1" ] && startx "$XDG_CONFIG_HOME/X11/xinitrc"' /etc/profile
fi
[ "$(wc -l /etc/hosts | cut -d' ' -f1)" -eq 3 ] && cat hosts | sudo tee -a /etc/hosts >/dev/null
[ "$(>/etc/doas.conf)" != 'permit persist :wheel' ] && echo 'permit persist :wheel' > /etc/doas.conf && sudo chown -c root:root '/etc/doas.conf' && sudo chmod 0444 '/etc/doas.conf'
sudo curl -sL 'https://raw.githubusercontent.com/koalagang/doasedit/main/doasedit' -o /usr/bin/doasedit && sudo chmod +x /usr/bin/doasedit
sudo pacman -R sudo --noconfirm && doas ln -s /usr/bin/doas /usr/bin/sudo

# clear cache
paru -c --noconfirm && doas paccache -r && doas paccache -ruk0

# configure shells
doas ln -sfT /bin/dash /bin/sh && cp bash2dash.hook /usr/share/libalmpm/hooks/bash2dash.hook
mkdir -p "$HOME/.cache/zsh" && touch "$HOME/.cache/zsh/history"
printf '\nCould not interactively configure login shell. Please enter the following commands:\nsudo chsh -s /bin/zsh\nrm "$HOME"/.bash*\n'

rm -rf go kai
