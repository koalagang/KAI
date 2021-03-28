# test
sudo pacman -S xdg-user-dirs qtile
xdg-user-dirs-update
useradd -m -G wheel admin
( echo "admin"; echo "admin" ) | passwd
cp /etc/sudoers /etc/sudoers.bak
echo "admin ALL=(ALL) ALL" >> /etc/sudoers
mkdir /home/admin/.config/X11
touch /home/admin/.config/X11/xinitrc
echo "exec qtile" > /home/admin/.config/X11/xinitrc
echo "" > /etc/profile
echo "startx /home/admin/.config/X11/xinitrc" > /etc/profile
