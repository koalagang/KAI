#!/usr/bin/bash

pacman -Syy
timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
cp /etc/locale.gen /etc/locale.gen.bak
sed -i "s/#en_GB.UTF-8\ UTF-8/en_GB.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#en_GB ISO-8859-1/en_GB ISO-8859-1/g" /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
#export "LANG=en_GB.UTF-8"
printf "127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t Alfheim.localdomain \t arch" > /etc/hostname
pacman -S networkmanager efibootmgr grub --noconfirm
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager

# creates an admin account with the password 'admin'
# this parts of this section was taken from James-d12's script
useradd -m -G wheel admin
( echo "admin"; echo "admin" ) | passwd
cp /etc/sudoers /etc/sudoers.bak
echo "admin ALL=(ALL) ALL" >> /etc/sudoers

echo "Unmount everything with 'umount -a'"
echo "To shutdown, enter 'shutdown now'. To reboot, enter just that - 'reboot'. If your BIOS options are set to autoboot into your Arch live key, shutdown and unplug it before you turn your computer back on."
exit
