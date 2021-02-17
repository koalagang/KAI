#!/usr/bin/bash

#enable multilib repository
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
sudo cp ~/KAI/pacman.conf /etc/
sudo pacman -Syy

git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si PKGBUILD
cd
rm -r paru-bin

pacman_packages=(
	"neofetch"
	"timeshift"
	"cronie"
	"ntfs-3g"
	"wget"
	"curl"
	"fail2ban"
	"ffmpeg"
	"unzip"
	"make"
	"openvpn"
	"ufw"
	"grub-customizer"
	"adobe-source-han-sans-otc-fonts"
	"adobe-source-han-serif-otc-fonts"
	"ttf-liberation"
	"noto-fonts-emoji"
	"opendoas"
	"pulseaudio"
	"youtube-dl"
	"calcurse"
	"htop"
    "bashtop"
	"libqalculate"
   	"mpv"
  	"zathura"
  	"zathura-pdf-poppler"
	"sxiv"
   	"keepassxc"
 	"anki"
   	"libreoffice-still"
   	"gimp"
   	"bleachbit"
   	"fish"
   	"signal-desktop"
   	"easytag"
   	"spacefm"
	"man"
	"groff"
	"nvidia"
	"nvidia-lts"
	"nvidia-dkms"
	"nvidia-utils"
	#"lib32-nvidia-utils"
	"nvidia-settings"
	#"wine-staging"
	#"giflib"
	#"lib32-giflib"
	#"libpng"
	#"lib32-libpng"
	#"libldap"
	#"lib32-libldap"
	#"gnutls"
	#"lib32-gnutls"
	#"mpg123"
	#"lib32-mpg123"
	#"openal"
	#"lib32-openal"
	#"v4l-utils"
	#"lib32-v4l-utils"
	#"libpulse"
	#"lib32-libpulse"
	#"libgpg-error"
	#"lib32-libgpg-error"
	#"alsa-plugins"
	#"lib32-alsa-lib"
	#"libjpeg-turbo"
	#"lib32-libjpeg-turbo"
	#"sqlite"
	#"lib32-sqlite"
	#"libxcomposite"
	#"lib32-libxcomposite"
	#"libxinerama"
	#"lib32-xinerama"
	#"lib32-libgcrypt"
	#"libgcrypt"
	#"ncurses"
	#"lib32-ncurses"
	#"opencl-icd-loader"
	#"lib32-opencl-icd-loader"
	#"libxslt"
	#"lib32-libxslt"
	#"libva"
	#"lib32-libva"
	#"gtk3"
	#"lib32-gtk3"
	#"gst-plugins-base-libs"
	#"lib32-gst-plugins-base-libs"
	#"vulkan-icd-loader"
	#"lib32-vulkan-icd-loader"
	#"lutris"
	#"meson"
	"git"
	#"dbus"
	#"libinih"
	#"steam"
	#"vifm"
	"maim"
	"xorg-xmodmap"
	"pacman-contrib"
	"unclutter"
	"neovim"
	"alacritty"
	"nitrogen"
	"lollypop"
	"sxhkd"
	"xdotools"
	"xclip"
	"plocate"
    "bat"
    "ripgrep"
    "exa"
    "virtualbox"
    "python-psutil"
    "lm-sensors"
    "alsa-utils"
    "lxsession"

)

aur_packages=(
    "newsboat"
    "protonvpn-cli-ng"
	"papirus-folders-git"
	#"sc-controller-git"
	#"legendary"
	#"itch"
	"multimc5"
	"straw-viewer-git"
	"sc-im"
	#"sent"
	#"farbfeld"
	"buku"
	"brave-bin"
	"starship-bin"
    "nodejs-nativefier"
    "spotify"
    "betterlockscreen"
    "redshift-minimal"
    "simple-mtpfs"
)

sudo pacman -S --noconfirm --needed "${pacman_packages[@]}" # install pacman packages
sudo paru -S --batchinstall --noconfirm --needed "${aur_packages[@]}" # install AUR packages

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
sudo pacman -Rs nodejs-nativefier --noconfirm # Uninstalling nativefier which I no longer need
# NOTE: these electron clients are not technically installed onto your computer - They are simply executables (kind of like appimages).
# To remove them, you do not run the usual 'pacman -Rs', instead, just delete their folder and all of their contents.

# install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#import configs
git clone https://github.com/koalagang/dotfiles.git
cp ~/dotfiles/alacritty ~/.config
cp ~/dotfiles/keepassxc ~/.config
cp ~/dotfiles/neofetch ~/.config
cp ~/dotfiles/nvim ~/.config
cp ~/dotfiles/spacefm ~/.config
cp ~/dotfiles/sxhkd ~/.config
cp ~/dotfiles/ytmdl ~/.config
cp ~/dotfiles/zathura ~/.config
cp ~/dotfiles/mpv ~/.config
cp ~/dotfiles/paru ~/.config
mv -r ~/dotfiles/newsboat ~/.newsboat
cp ~/dotfiles/fish ~/.config

sudo cp ~/KAI/doas.conf /etc/ # enable doas

rm .bash_logout
rm .bash_history

chsh -s /bin/fish # sets fish as the default shell
sudo timeshift --create --comments "Fresh install" && echo "created timeshift backup"
sudo timeshift --create --comments "Daily backup" --tags D && echo "timeshift backups set do daily"
paru -c
ulimit -Hn
printf "If more than 500,000 was returned then ESYNC IS ENABLED! If not - proceed with the instructions on CTTs guide: https://christitus.com/ultimate-linux-gaming-guide/\npost-installation script is complete!\nYou may now delete ~/KAI if you wish."
