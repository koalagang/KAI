#!/bin/sh

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
pacman -S networkmanager networkmanager-runit grub efibootmgr xorg xorg-xinit git --noconfirm
if [ DUAL = "y" || DUAL = "Y" ]; then
    pacman -S os-prober ntfs-3g
elif [ DUAL = "n" || DUAL = "N" ]; then
    break
fi
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
touch /etc/hostname
echo "$HOST" > /etc/hostname
printf "127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t $HOST.localdomain \t $HOST" > /etc/hosts
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default
useradd -m -G wheel $USERNAME
( echo "$PASSWORD"; echo "$PASSWORD" ) | passwd $USERNAME
cp /etc/sudoers /etc/sudoers.bak
sed -i "s/#\ %wheel\ ALL=(ALL)\ ALL/%wheel\ ALL=(ALL) ALL/g" /etc/sudoers
sed -i "s/#\ %sudo\ ALL=(ALL)\ ALL/%wheel\ ALL=(ALL) ALL/g" /etc/sudoers
( echo "$ROOTPASSWORD"; echo "$ROOTPASSWORD" ) | passwd
rm installer.sh
echo
echo "Please reboot your system with 'loginctl reboot' or 'loginctl poweroff'."
