#!/usr/bin/bash

#enable multilib repository
#sudo cp ~/KAI/pacman.conf /etc/
sudo pacman -Syy

git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si PKGBUILD
rm -r paru-bin

pacman_packages=(
	"neofetch"
	"timeshift"
	"cronie"
	#"ntfs-3g"
	"wget"
	"curl"
	"fail2ban"
	"ffmpeg"
	"unzip"
	"make"
	"openvpn"
	"ufw"
	"grub-customizer"
	"apparmor"
	"firejail"
	"adobe-source-han-sans-otc-fonts"
	"adobe-source-han-serif-otc-fonts"
	"gnu-free-fonts"
	"ttf-liberation"
	"noto-fonts-emoji"
	"opendoas"
	"pulseaudio"
	"youtube-dl"
	"calcurse"
	"htop"
	"libqalculate"
   	"mpv"
  	"zathura"
  	"zathura-pdf-poppler"
	"sxiv"
   	#"firefox"
   	"keepassxc"
 	"anki"
   	"libreoffice-still"
   	"gnome-tweaks"
   	"gimp"
   	"bleachbit"
  	#"alacarte"
   	#"torbrowser-launcher"
   	"fish"
   	#"guake"
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
	#"lib32-gitflib"
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
	"xdo"
	"xdotools"
	"xclip"
	"plocate"
    "bat"
    "ripgrep"
    "exa"
	"gnu-netcat"
    "virtualbox"

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
)

curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -
sudo pacman -S --noconfirm --needed "${pacman_packages[@]}" # install pacman packages
sudo paru -S --batchinstall --noconfirm --needed "${aur_packages[@]}" # install AUR packages

sudo pacman -Rs gnome-books sushi evince nautilus gnome-documents epiphany gnome-contacts gnome-font-viewer gnome-music gnome-photos totem gnome-screenshot gnome-boxes gnome-characters # removes unwanted gnome applications

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
sudo pacman -Rs nodejs-nativefier --noconfirm # Deleting nativefier which I no longer need
# NOTE: these electron clients are not technically installed onto your computer - They are simply executables (kind of like appimages).
# To remove them, you do not run the usual 'pacman -Rs', instead, just delete the folder and all of its contents.

# install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#import configs
git clone https://github.com/koalagang/dotfiles.git
cp ~/dotfiles/autostart ~/.config
cp ~/dotfiles/alacritty ~/.config
cp ~/dotfiles/albert ~/.config
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

gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark && papirus-folders -C pink --theme Papirus-Dark # sets icon theme to Paprius Dark Pink

#install gnome extensions
cp -r ~/KAI/gnome-shell-extensions/activities-config@nls1729 ~/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/alwayszoomworkspaces@jamie.thenicols.net ~/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/BringOutSubmenuOfPowerOffLogoutButton@pratap.fastmail.fm ~/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/impatience@gfxmonk.net ~/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/scroll-panel@mreditor.github.com ~/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/transparent-window-moving@noobsai.github.com ~/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/tray-icons@zhangkaizhao.com ~/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/tweaks-system-menu@extensions.gnome-shell.fifi.org ~/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/windowoverlay-icons@sustmidown.centrum.cz ~/.local/share/gnome-shell/extensions
killall -SIGQUIT gnome-shell # restarts the gnome shell, do not worry if your computer stops responding for a few seconds
sudo pacman -Syu

rm .bash_logout
rm .bash_history

# security improvements
restrict_kernel_log_access() {
    echo "kernel.dmesg_restrict = 1" >> /etc/sysctl.d/51-dmesg-restrict.conf
}
increase_user_login_timeout() {
    echo "auth optional pam_faildelay.so delay=4000000" >> /etc/pam.d/system-login
}
deny_ip_spoofs(){
    printf "order bind, hosts\n multi on" >> /etc/host.conf
}

configure_apparmor_and_firejail(){
    command -v firejail > /dev/null && command -v apparmor > /dev/null &&
    firecfg && sudo apparmor_parser -r /etc/apparmor.d/firejail-default
}

configure_firewall(){
    if command -v ufw > /dev/null; then
        sudo ufw limit 22/tcp
        sudo ufw limit ssh
        sudo ufw allow 80/tcp
        sudo ufw allow 443/tcp
        sudo ufw default deny
        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        sudo ufw allow from 192.168.0.0/24
        sudo ufw allow Deluge
        sudo ufw enable
    fi
}

configure_sysctl(){
    if command -v sysctl > /dev/null; then
        sudo sysctl -a
        sudo sysctl -A
        sudo sysctl mib
        sudo sysctl net.ipv4.conf.all.rp_filter
        sudo sysctl -a --pattern 'net.ipv4.conf.(eth|wlan)0.arp'
    fi
}

configure_fail2ban(){
    if command -v fail2ban > /dev/null; then
        sudo cp fail2ban.local /etc/fail2ban/
        sudo systemctl enable fail2ban
        sudo systemctl start fail2ban
    fi
}

harden_security(){
    restrict_kernel_log_access
    increase_user_login_timeout
    deny_ip_spoofs
    configure_firewall
    configure_sysctl
    configure_fail2ban
    configure_apparmor_and_firejail
}

harden_security

sudo systemctl disable geoclue.service && sudo systemctl mask geoclue.service # breaks location services

chsh -s /bin/fish # sets fish as the default shell
sudo timeshift --create --comments "Fresh install" && echo "created timeshift backup"
sudo timeshift --create --comments "Daily backup" --tags D && echo "timeshift backups set do daily"
paru -c
ulimit -Hn
printf "If more than 500,000 was returned then ESYNC IS ENABLED! If not - proceed with the instructions on CTTs guide: https://christitus.com/ultimate-linux-gaming-guide/\npost-installation script is complete!\nYou may now delete ~/KAI if you wish."
