#!/bin/sh

sudo pacman -S --needed --noconfirm base-devel
git clone https://aur.archlinux.org/paru.git initparu
sh -c "cd 'initparu' && makepkg -si --noconfirm"
sudo rm -r initparu

# Stuff I may or may not wish to install:
#"udisks2" # I'm considering using Luke Smith's dmenu script instead
#"calcurse"
#"pass"
#"ufw"
#"neofetch"
#"pfetch"
#"libresprite" # probably won't use this because I have Aseprite on Steam
#"godot-mono-bin" # probably not yet because it's still in alpha
#'pipewire'
#'pipewire-alsa'
#'pipewire-pulseaudio'
#'pipewire-jack'

sudo pacman -Syu --noconfirm
# I am well aware that `paru -S $(cat 'packages') --noconfirm --needed`
# would be more efficient but it outputs some errors for some reason.
for i in `cat packages`; do
    paru -S $i --noconfirm --needed
done

echo "post-installation script complete!"
printf "\nTo switch to a binary version of paru, you must manually enter:\n'paru -S paru-bin'\nYou may also wish to logout or restart for certain changes to take affect.\n"
