#!/bin/sh
# test
sudo pacman -S xdg-user-dirs qtile --noconfirm
xdg-user-dirs-update
mkdir /home/admin/.config/X11
touch /home/admin/.config/X11/xinitrc
echo "exec qtile" > /home/admin/.config/X11/xinitrc
echo "" > /etc/profile
echo "startx /home/admin/.config/X11/xinitrc" > /etc/profile
