#!/usr/bin/bash

#enable multilib repository
sudo cp ~/KAI/pacman.conf /etc/
sudo pacman -Syy

pacman_packages=(
	"neofetch"
	"yay"
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
	"noto-fonts-emoji"
	"ttf-hack"
	"opendoas"
	"pulseaudio"
	"nvim"
	"youtube-dl"
	"calcurse"
	"htop"
	"bc"
	"w3m"
   	"mpv"
  	"zathura"
  	"zathura-pdf-poppler"
	#"zathura-cb"
	"sxiv"
   	"firefox"
   	"keepassxc"
 	"anki"
   	"libreoffice-still"
   	"gnome-tweaks"
   	"gimp"
   	"bleachbit"
  	"alacarte"
   	"torbrowser-launcher"
   	"fish"
   	"guake"
   	"signal-desktop"
   	#"easytag"
   	"spacefm"
	"man"
	"groff"
	"nvidia"
	"nvidia-lts"
	"nvidia-dkms"
	"nvidia-utils"
	"lib32-nvidia-utils"
	"nvidia-settings"
	"wine-staging"
	"giflib"
	"lib32-gitflib"
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
#	"systemd" # As you can see here, systemd is required for gamemode
#	"git" # Git should already be installed if you cloned this repository.
	"dbus"
	"libinih"
	"steam"
	"vifm"
	"flameshot"

)

aur_packages=(
    "newsboat"
    "protonvpn-cli-ng"
    #"thefuck"
    #"absolutely-proprietary"
    "discord"
	"papirus-folders-git"
	"spotifyd"
	"spotify-tui"
	"sc-controller-git"
	"legendary"
	"itch"
	"multimc5"
	"straw-viewer"
	"freetube-bin"
)

#installing gamemode
sudo pacman -S meson systemd git dbus libinih #NOTE: as you can see, Systemd is required so this will not work for OpenRC, Runit, etc
git clone https://github.com/FeralInteractive/gamemode.git
cd gamemode
git checkout 1.6
./bootstrap.sh
sudo cp ~/KAI/gamemode.ini /usr/share/gamemode
rm ~/gamemode

sudo pacman -S  --noconfirm --needed "${pacman_packages[@]}" # install pacman packages
yay -S --batchinstall --noconfirm --needed "${aur_packages[@]}" # install AUR packages

curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import - && yay -S --noconfirm spotify # official proprietary Spotify electron client
sudo pacman -Rs nautilus gnome-documents epiphany gnome-contacts gnome-font-viewer gnome-music gnome-photos totem gnome-screenshot # removes gnome bloat

#import configs
git clone https://github.com/koalagang/configs
rm -r ~/.config/fish && cp -r ~/configs/fish ~/.config
rm -r ~/.config/nvim && cp -r ~configs/nvim ~/.config
rm -r ~/.config/straw-viewer && cp -r ~/configs/straw-viewer ~/.config
rm -r ~/.config/spacefm && cp -r ~/configs/spacefm ~/.config
rm -r ~/.newsboat && mv ~/dotfiles/newsboat ~/.newsboat
sudo rm -r /usr/share/gamemode/gamemode.ini && cp -r ~/KAI/gamemode.ini /usr/share/gamemode # my config is the default except Overwatch is whitelisted (gamemode will only run for Overwatch)

#import Firefox profiles
cp ~/kai/firefox-profiles/008szetu.netflix ~/.mozilla/firefox
cp ~/KAI/firefox-profiles/4qdlxavn.strongkoala ~/.mozilla/firefox
cp ~/KAI/firefox-profiles/92rdblzp.strongestkoala ~/.mozilla/firefox
cp ~/KAI/firefox-profiles/installs.ini ~/.mozilla/firefox
cp ~/KAI/firefox-profiles/profiles.ini ~/.mozilla/firefox

#install Vim Plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#setup autostart
cp /usr/share/applications/guake.desktop /etc/xdg/autostart/ # guake
cp ~/kai/nvidia-force-full-compositon.desktop /etc/xdg/autostart/ # enables 'force full composition pipeline' setting automatically if Nvidia Settings is installed

cp ~/KAI/doas.conf /etc/ #enable doas

gsettings set org.gnome.desktop.background picture-uri ~/KAI/nord.jpg # sets wallpaper
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark && papirus-folders -C pink --theme Papirus-Dark # sets icon theme to Paprius Dark Pink

#install gnome extensions
cp -r ~/KAI/gnome-shell-extensions/activities-config@nls1729 /home/admin/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/alwayszoomworkspaces@jamie.thenicols.net /home/admin/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/BringOutSubmenuOfPowerOffLogoutButton@pratap.fastmail.fm /home/admin/.local/share/gnome-shell/extensions
cp -r ~/KAi/gnome-shell-extensions/dash-to-dock@micxgx.gmail.com /home/admin/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/gamemode@christian.kellner.me /home/admin/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/impatience@gfxmonk.net /home/admin/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/scroll-panel@mreditor.github.com /home/admin/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/transparent-window-moving@noobsai.github.com /home/admin/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/tray-icons@zhangkaizhao.com /home/admin/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/tweaks-system-menu@extensions.gnome-shell.fifi.org /home/admin/.local/share/gnome-shell/extensions
cp -r ~/KAI/gnome-shell-extensions/windowoverlay-icons@sustmidown.centrum.cz /home/admin/.local/share/gnome-shell/extensions
killall -SIGQUIT gnome-shell # restarts the gnome shell, do not worry if your computer stops responding for a few seconds
sudo pacman -Syu

#security improvements
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
yay -c
sudo timeshift --create --comments "Fresh install" && echo "created timeshift backup"
sudo timeshift --create --comments "Daily backup" --tags D && echo "timeshift backups set do daily"
ulimit -Hn
echo "If more than 500,000 was returned then ESYNC IS ENABLED! If not - proceed with the instructions on CTTs guide. https://christitus.com/ultimate-linux-gaming-guide/"
echo "kai.sh script complete"
