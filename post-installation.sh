#!/usr/bin/bash

#enable multilib repository
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
sudo cp ~/KAI/pacman.conf /etc/
sudo pacman -Syu

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si PKGBUILD
cd
rm -r paru

packages=(
    "paru-bin" # I prefer using binaries over compiling
	"neofetch"
    "ueberzug"
	"timeshift"
	"cronie"
	"ntfs-3g"
	"wget"
	"curl"
	"ffmpeg"
	#"unzip"
	"make"
	"openvpn"
	"ufw"
	"adobe-source-han-sans-otc-fonts"
	"adobe-source-han-serif-otc-fonts"
	"ttf-liberation"
	"noto-fonts-emoji"
	"opendoas"
	"pulseaudio"
	"youtube-dl"
    "ytfzf"
    "pipe-viewer-git"
	#"calcurse"
	"htop"
    "bashtop"
	"libqalculate"
   	"mpv"
  	"zathura"
  	"zathura-pdf-poppler"
	"sxiv"
   	"keepassxc"
    #"pass"
 	"anki"
   	"libreoffice-still"
   	"gimp"
   	"bleachbit"
   	"fish"
   	"signal-desktop"
   	#"easytag"
    "id3"
   	"spacefm"
	"man"
	"groff"
    "grap"
	"nvidia"
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
	#"meson"
	"git"
	#"dbus"
	#"libinih"
	"steam"
	"vifm"
	"maim"
	"pacman-contrib"
	"unclutter"
	"neovim"
	"alacritty"
	"nitrogen"
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
    "newsboat"
    "protonvpn-cli-ng"
	"papirus-folders-git"
	#"sc-controller-git"
	#"legendary"
	#"itch"
	#"multimc5"
	"sc-im"
	#"sent"
	#"farbfeld"
	#"buku-git"
	"brave-bin"
	"starship-bin"
    "nodejs-nativefier"
    "spotify"
    "betterlockscreen"
    "redshift-minimal"
    "simple-mtpfs"
    "devour"
    "tuxi-git"
    "archiver"
    "networkmanager-applet"
    "picom"
    "dunst"
    "trash-cli"
    "xorg-xset"
    "xorg-setxkbmap"
    "xorg-xrandr"
	"xorg-xmodmap"
    "ucollage"
    "mpd"
    "ncmcpp"
    "mpDris2"
    "playerctl"
	"lollypop"
    "udisks2" # I'm considering using Luke Smith's dmenu script instead
    "translate-shell"
    "arch-wiki-docs"
    "colorpicker"
    "spotdl"
    #"ytmdl"
    "github-cli"
    "lynx"
    "python-readability-lxml"
    "so-git"
    "streamlink"
    #"gallery-dl"
)

paru -S --noconfirm --needed "${packages[@]}"
# add redyt as well

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
# To remove them, you do not run the usual 'pacman -Rs', instead, just delete their folder and all of the contents.

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
cp ~/dotfiles/zathura ~/.config
cp ~/dotfiles/mpv ~/.config
cp ~/dotfiles/paru ~/.config
mv -r ~/dotfiles/newsboat ~/.newsboat
cp ~/dotfiles/fish ~/.config

touch /etc/doas.conf
echo "permit admin as root" > /etc/doas.conf
rm .bash_logout
rm .bash_history
chsh -s /bin/fish # sets fish as the login shell
cd /usr/share/doc/arch-wiki/html
shopt -s extglob
sudo rm -r !("en"|"ArchWikiOffline.css")
paru -c
sudo paccache -r && sudo paccache -ruk0
sudo timeshift --create --comments "Fresh install" && echo "created timeshift backup"
#ulimit -Hn
#printf "If more than 500,000 was returned then ESYNC IS ENABLED! If not - proceed with the instructions on CTTs guide: https://christitus.com/ultimate-linux-gaming-guide/\npost-installation script is complete!\nYou may now delete ~/KAI if you wish."
