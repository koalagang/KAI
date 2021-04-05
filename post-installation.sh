#!/bin/env bash
# This has script bashisms so do not run it with another shell


read -p "Enter your username: " USER

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
sudo rm -r paru

git clone https://github.com/koalagang/dotfiles.git
sudo cp dotfiles/pacman.conf /etc/
sudo pacman -Syu

official=(
    "neofetch"
    "ueberzug"
    "cronie"
    "wget"
    "curl"
    "ffmpeg"
    #"unzip"
    "make"
    "openvpn"
    "ufw"
    "adobe-source-han-sans-otc-fonts"
    "adobe-source-han-serif-otc-fonts"
    "gnu-free-fonts"
    "ttf-liberation"
    "ttf-linux-libertine"
    "ttf-ubuntu-font-family"
    "noto-fonts-emoji"
    "python-fontawesome"
    "opendoas"
    "pulseaudio"
    "youtube-dl"
    #"calcurse"
    "htop"
    "bashtop"
    "libqalculate"
    "mpv"
    "zathura"
    "zathura-pdf-poppler"
    "mupdf"
    "pandoc"
    "unoconv"
    "sxiv"
    "keepassxc"
    #"pass"
    "anki"
    "libreoffice-still"
    "gimp"
    "dash"
    "zsh"
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
    "pkgfile"
    "signal-desktop"
    #"easytag"
    "groff"
    #"nvidia"
    "nvidia-lts"
    "nvidia-dkms"
    "nvidia-utils"
    "lib32-nvidia-utils"
    "nvidia-settings"
    "wine-staging"
    "giflib"
    "lib32-giflib"
    "libpng"
    "lib32-libpng"
    "libldap"
    "lib32-libldap"
    "gnutls"
    "lib32-gnutls"
    "mpg123"
    "lib32-mpg123"
    "openal"
    "lib32-openal"
    "v4l-utils"
    "lib32-v4l-utils"
    "libpulse"
    "lib32-libpulse"
    "libgpg-error"
    "lib32-libgpg-error"
    "alsa-plugins"
    "lib32-alsa-lib"
    "libjpeg-turbo"
    "lib32-libjpeg-turbo"
    "sqlite"
    "lib32-sqlite"
    "libxcomposite"
    "lib32-libxcomposite"
    "libxinerama"
    "lib32-xinerama"
    "lib32-libgcrypt"
    "libgcrypt"
    "ncurses"
    "lib32-ncurses"
    "opencl-icd-loader"
    "lib32-opencl-icd-loader"
    "libxslt"
    "lib32-libxslt"
    "libva"
    "lib32-libva"
    "gtk3"
    "lib32-gtk3"
    "gst-plugins-base-libs"
    "lib32-gst-plugins-base-libs"
    "vulkan-icd-loader"
    "lib32-vulkan-icd-loader"
    "lutris"
    "meson"
    "dbus"
    "libinih"
    "steam"
    "vifm"
    "maim"
    "pacman-contrib"
    "unclutter"
    "neovim"
    "alacritty"
    "hsetroot"
    "sxhkd"
    "xdotool"
    "xclip"
    "fd"
    "bat"
    "ripgrep"
    "exa"
    "virtualbox"
    "python-psutil"
    "lm_sensors"
    "alsa-utils"
    "lxsession"
    "newsboat"
    #"sc-controller-git"
    #"legendary"
    #"itch"
    #"multimc5"
    #"sent"
    #"farbfeld"
    #"buku-git"
    "starship"
    "network-manager-applet"
    "picom"
    "dunst"
    "trash-cli"
    "xorg-xinit"
    "xdg-user-dirs"
    "mpd"
    "ncmpcpp-git"
    "playerctl"
    "lollypop"
    #"udisks2" # I'm considering using Luke Smith's dmenu script instead
    "translate-shell"
    "arch-wiki-docs"
    #"ytmdl"
    "github-cli"
    "lynx"
    "streamlink"
    "shellcheck"
    #"gallery-dl"
)

aur=(
    "timeshift-bin"
    "so"
    "mpdris2"
    "zsh-abbr"
    "zsh-you-should-use"
    "vim-plug"
    "betterlockscreen"
    "ytfzf"
    "grap"
    "spacefm"
    "simple-mtpfs"
    "devour"
    "ucollage"
    "colorpicker"
    "python-readability-lxml"
    "nodejs-nativefier"
    "python-spotdl"
    "redshift-minimal"
    "tuxi-git"
    "spotify"
    "librewolf-bin"
    "sc-im"
    "id3"
    "protonvpn-cli-ng"
    "pipe-viewer-git"
    "papirus-folders-git"
    "glow"
    "dragon-drag-and-drop"
    #"zsh-abbr"
)

sudo pacman -S --noconfirm --needed "${offical[@]}"
paru -S --noconfirm --needed "${aur[@]}"

cp dotfiles/user-dirs.dirs $HOME/.config
xdg-user-dirs-update

nativefier --widevine netflix.com ~/Desktop # Creates a Netflix client
nativefier crunchyroll.com ~/Desktop # Creates a Crunchyroll client
nativefier discord.com/app ~/Desktop # Creates a Discord client
# Giving the files and folders better names
mv ~/Desktop/Netflix* ~/Desktop/.netflix
mv ~/Desktop/.netflix/Netflix* ~/Desktop/.netflix/netflix
mv ~/Desktop/APP-linux-x64 ~/Desktop/.crunchyroll
mv ~/Desktop/.crunchyroll/APP ~/Desktop/.crunchyroll/crunchyroll
mv ~/Desktop/Discord* ~/Desktop/.discord
mv ~/Desktop/.discord/Discord* ~/Desktop/.discord/discord
sudo pacman -R nodejs-nativefier --noconfirm # Uninstalling nativefier which I no longer need
rm -r ~/.npm
# NOTE: these electron clients are not technically installed onto your computer - They are simply executables (kind of like appimages).
# To remove them, you do not run the usual 'pacman -R', instead, just delete their folder and all of the contents.

#import dotfiles
mv -r dotfiles/alacritty ~/.config
mv -r dotfiles/dunst ~/.config
mv -r dotfiles/gtk-3.0 ~/.config
mv -r dotfiles/gtk-4.0 ~/.config
mv -r dotfiles/mpd ~/.config
mv -r dotfiles/mpv ~/.config
mv -r dotfiles/ncmpcpp ~/.config
mv -r dotfiles/neofetch ~/.config
mv -r dotfiles/newsboat ~/.config
mv -r dotfiles/nvim ~/.config
mv -r dotfiles/paru ~/.config
mv -r dotfiles/qtile ~/.config
mv -r dotfiles/qutebrowser ~/.config
mv -r dotfiles/spacefm ~/.config
mv -r dotfiles/sxhkd ~/.config
mv -r dotfiles/vifm ~/.config
mv -r dotfiles/zathura ~/.config
mv -r dotfiles/zsh ~/.config
mv dotfiles/.zprofile ~
mv dotfiles/.bashrc ~
mv dotfiles/macros ~/Documents/Groff
mv dotfiles/starship.toml ~/.config
sudo mv dotfiles/hosts /etc/
sudo mv dotfiles/lynx.cfg /etc/
sudo touch /etc/doas.conf
sudo echo "permit $USER as root" > /etc/doas.conf
rm .bash_logout
rm .bash_history

sudo pkgfile --update
sudo mandb
sudo chsh -s /bin/zsh # sets zsh as the login shell (interactive shell)
sudo ln -sfT /bin/dash /bin/sh # sets dash as the default shell (the shell used by '#!/bin/sh' scripts)
mv dotfiles/bash2dash.hook /usr/share/libalpm/hooks
mkdir $HOME/.cache/zsh
mkdir $HOME/.local/share/virtualbox # change the default machine folder to this
rm -r $HOME/.cargo
sudo rm -r /kai || sudo rm -r /KAI
rm -r dotfiles
cd /usr/share/doc/arch-wiki/html
shopt -s extglob
sudo rm -r /usr/share/doc/arch-wiki/html/!("en"|"ArchWikiOffline.css")
paru -c
sudo paccache -r -q && sudo paccache -ruk0 -q
sudo timeshift --create --comments "Fresh install" && echo "created timeshift backup"
echo "post-installation script complete!"
printf "\nTo switch to a binary version of paru, you must manually enter:\n`paru -S paru-bin`\nYou may also wish to logout or restart for certain changes to take affect.\n"
