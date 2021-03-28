#!/usr/bin/sh

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
sed -i "s/#en_GB.UTF-8\ UTF-8/en_GB.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#en_GB\ ISO-8859-1/en_GB\ ISO-8859-1/g" /etc/locale.gen
sed -i "s/#en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#en_US\ ISO-8859-1/en_US\ ISO-8859-1/g" /etc/locale.gen
sed -i "s/#nb_NO.UTF-8\ UTF-8/nb_NO.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#nb_NO\ ISO-8859-1/nb_NO\ ISO-8859-1/g" /etc/locale.gen
locale-gen
touch /etc/locale.conf
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
pacman -S networkmanager networkmanager-runit grub os-prober efibootmgr nvidia-lts xorg xorg-xinit --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
touch /etc/hostname
echo "Alfheim" > /etc/hostname
printf "127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t Alfheim.localdomain \t Alfheim" > /etc/hosts
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default
passwd "passwd"
printf "Please enter the folowing:\nexit\numount -R /mnt\nreboot\n"
