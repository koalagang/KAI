#!/bin/sh

# This script is just a personal thing. Don't bother using this.

# Stuff I may or may not wish to install:
#"udisks2" # I'm considering using Luke Smith's dmenu script instead
#"calcurse"
#"pass"
#"ufw"
#"libresprite" # probably won't use this because I have Aseprite on Steam
#"godot-mono-bin" # probably not yet because it's still in alpha
#'pipewire'
#'pipewire-alsa'
#'pipewire-pulseaudio'
#'pipewire-jack'
#'syncthing'
#'itch'
#'mpd'
#'mpd-runit'
#'ncmpcpp'
#'lollypop'
#'neofetch'

sudo pacman -Syu --noconfirm
paru -S $(cat packages) --noconfirm --needed

echo "post-installation script complete!"
