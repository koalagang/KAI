#!/usr/bin/bash

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
sed -i "s/#en_GB.UTF-8\ UTF-8/en_GB.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#en_GB\ ISO-8859-1/en_GB\ ISO-8859-1/g" /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
pacman -S networkmanager networkmanager-runit
ln -s /etc/runit/sv/NetworkManager /etc/runit/sdvir/current
echo "Alfheim" > /etc/hostname
printf "127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t Alfheim.localdomain \t arch" > /etc/hostname
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m -G wheel admin
( echo "admin"; echo "admin" ) | passwd
cp /etc/sudoers /etc/sudoers.bak
echo "admin ALL=(ALL) ALL" >> /etc/sudoers
