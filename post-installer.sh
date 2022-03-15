#!/usr/bin/env bash

progs_file="$HOME/kai/progs.txt"
HOST_NAME="$(</etc/hostname)"

is_installed (){
    command -v "$1" >/dev/null
}

bak (){
    sudo cp --backup=numbered "$1" "$1.bak" && printf "\n$1 has been safely backed up as $1.bak\n"
}

# compile yay because it is written in go so it is fast to compile
# then install a pre-compiled paru binary and remove yay
is_installed 'paru' && paru_installed=1
if [ -z "$paru_installed" ]; then
    echo 'Installing AUR helper...'
    git clone https://aur.archlinux.org/yay.git
    ( cd yay && yes | makepkg -si )
    yay -S paru-bin --noconfirm
    yay -R yay --noconfirm
    sudo rm -rf 'yay' "$HOME/.cache/yay" "$HOME/.config/yay" "$HOME/.cache/go-build"
fi

# configure pacman to support arch repositories and have parallel downloads and pretty colours
[ -f '/etc/pacman.conf.bak' ] && pacman_conf=1
if [ -z "$pacman_conf" ]; then
    # only enable 32-bit support for Ljosalfheim
    if [ "$HOST_NAME" = 'Ljosalfheim' ]; then
        arch_repos='arch-repos-no_multilib.txt'
        lib32_support='lib32-artix-archlinux-support'
    elif [ "$HOST_NAME" = 'Svartalfheim' ]; then
        arch_repos='arch-repos.txt'
    fi
    bak '/etc/pacman.conf'
    sudo sed -i -e "s/#ParallelDownloads = 5/ParallelDownloads = 20/" -e 's/#Color/Color/' /etc/pacman.conf
    [ "$HOST_NAME" = 'Ljosalfheim' ] && sudo sed -i 's/#\[lib32\]/\[lib32\]/' /etc/pacman.conf && grep -A1 -n '\[lib32\]' /etc/pacman.conf | tail -1 | cut -d'-' -f1 | \
        xargs -I% sudo sed -i '%s/#//' /etc/pacman.conf
    echo 'Enabling support for Arch Linux repositories...'
    sudo pacman -Syu artix-archlinux-support $lib32_support --noconfirm --needed && sudo pacman-key --populate archlinux
    cat "$HOME/kai/$arch_repos" | sudo tee -a /etc/pacman.conf >/dev/null
fi

# install all regular packages
echo "Installing packages from $progs_file..."
is_installed 'libxft-bgra' || yes | paru -Syu libxft-bgra # conflicts with libxft
readarray -t progs < "$progs_file" && paru -S "${progs[@]}" --noconfirm --needed
# install device specific packages
[ "$HOST_NAME" = 'Ljosalfheim' ] && echo 'Installing libvirt software, discord and signal-desktop...' && \
    sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat edk2-ovmf signal-desktop discord --noconfirm --needed
# install suckless software
echo 'Installing suckless software...'
git clone https://github.com/koalagang/suckless-koala.git
suckless=('dmenu' 'slock' 'st' 'sxiv' 'dwm' 'dwmblocks')
for package in "${suckless[@]}"; do
    if [ "$HOST_NAME" = 'Svartalfheim' ] && [[ "$package" =~ 'dwm' ]]; then
        folder="think-$package"
    else
        folder="$package"
    fi
    is_installed "$package" || sudo make install -C "suckless-koala/$folder"
done
sudo rm -rf suckless-koala

# create the file structures for the home
echo "Creating file structure inside $HOME..."
[ -d "$HOME/Downloads" ] || xdg-user-dirs-update
rm -rf "$HOME/Public" "$HOME/Templates" "$HOME/.lesshst"
sed -i -e 's#XDG_TEMPLATES_DIR="$HOME/Templates"#XDG_TEMPLATES_DIR="$HOME/Desktop"#' \
    -e 's#XDG_PUBLICSHARE_DIR="$HOME/Public"#XDG_TEMPLATES_DIR="$HOME/Desktop"#' "$HOME/.config/user-dirs.dirs"
mkdir -p "$HOME/.local/share" "$HOME/.local/bin"
[ -f "$HOME/.zshenv" ] || git clone https://github.com/koalagang/dotfiles.git
[ -d 'dotfiles' ] && rm -rf dotfiles/.git && cp -rv dotfiles/.* $HOME && rm -rf dotfiles
[ -d "$HOME/Desktop/git/dotfiles" ] && dotfiles=1
if [ -z "$dotfiles" ]; then
    mkdir -p "$HOME/Desktop/git/dotfiles"
    git clone --bare https://github.com/koalagang/dotfiles.git "$HOME/Desktop/git/dotfiles/dotfiles"
    git --git-dir=$HOME/Desktop/git/dotfiles/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
fi
[ -d "$HOME/Desktop/git/suckless-koala" ] || git clone https://github.com/koalagang/suckless-koala.git "$HOME/Desktop/git/suckless-koala"
[ -d "$HOME/Desktop/git/archive" ] || git clone https://github.com/koalagang/archive.git "$HOME/Desktop/git/archive"
echo 'Installing PhotoGIMP...' && \
curl -L https://github.com/Diolinux/PhotoGIMP/releases/download/1.0/PhotoGIMP.by.Diolinux.v2020.for.Flatpak.zip -o ~/Downloads/PhotoGIMP.zip && \
    unzip ~/Downloads/PhotoGIMP.zip -d ~/Downloads && mv ~/Downloads/PhotoGIMP\ by\ Diolinux\ v2020\ for\ Flatpak/.var/app/org.gimp.GIMP/config/GIMP ~/.config

# configure shells
command -v dash >/dev/null && \
    echo 'Symlinking /bin/dash to /bin/sh...' && doas ln -sfT /bin/dash /bin/sh && cp "$HOME/kai/bash2dash.hook" /usr/share/libalmpm/hooks/bash2dash.hook
command -v zsh >/dev/null && \
    echo 'Making zsh default interactive shell...' && mkdir -p "$HOME/.cache/zsh" && touch "$HOME/.cache/zsh/history" && sudo chsh -s /bin/zsh "$USER" && rm "$HOME"/.bash*

# weirdly, anything in /etc can only be edited with tee
# and linebreaks with printf are not interpreted correctly
startx_add (){
    echo | sudo tee -a "$3" >/dev/null
    echo "$1" | sudo tee -a "$3" >/dev/null
    echo "$2" | sudo tee -a "$3" >/dev/null
}

# not sure why but directly appending these files without tee doesn't work
grep -q 'startx' /etc/profile && etc_profile_startx=1
if [ -z "$etc_profile_startx" ]; then
    [ "$HOST_NAME" = 'Ljosalfheim' ] && startx_add '# startx' '[ "$(tty)" = "/dev/tty1" ] && "$HOME/.config/X11/wmselect"' '/etc/profile'
    [ "$HOST_NAME" = 'Svartalfheim' ] && startx_add '# startx' '[ "$(tty)" = "/dev/tty1" ] && export WM="dwm" && startx "$XDG_CONFIG_HOME/X11/xinitrc"' '/etc/profile'
fi
[ "$(wc -l /etc/hosts | cut -d' ' -f1)" -eq 3 ] && echo 'Editing hosts file...' && cat hosts | sudo tee -a /etc/hosts >/dev/null

sudo rm -rf "$HOME/go" "$HOME/.cargo"

[ -f '/etc/doas.conf' ] && doas_conf=1
[ -z "$doas_conf" ] && echo 'Installing doas and doasedit...' && \
    echo 'permit persist :wheel' | sudo tee -a /etc/doas.conf >/dev/null && sudo chown -c root:root '/etc/doas.conf' && sudo chmod 0444 '/etc/doas.conf' && \
    sudo curl -sL 'https://raw.githubusercontent.com/koalagang/doasedit/main/doasedit' -o /usr/bin/doasedit && sudo chmod +x /usr/bin/doasedit # install doasedit
# remove sudo and replace it with a symlink to doas to avoid issues with hardcoded software
bak '/etc/sudoers' # backup sudoers file in case user ever wishes to revert back to using sudo
echo 'Replacing sudo with doas...' && sudo pacman -R sudo --noconfirm && doas ln -s /usr/bin/doas /usr/bin/sudo && doas rm /etc/sudoers.pacsave*

# clear cache
echo 'Performing post-installation cleanup...' && paru -Syu --noconfirm && paru -c --noconfirm && doas paccache -ruk0

rm -rf "$HOME/kai" dotfiles

git clone https://github.com/koalagang/firefox-config.git && echo 'To complete your setup, start an X server and then run the Firefox configuration script.'
