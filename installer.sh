#!/bin/sh
read -p "Enter your host name: " HOST
read -p "Retype host name: " CONFIRMHOST
until [ "$HOST" = "$CONFIRMHOST" ]; do
    echo "Host names did not match!"
    read -p "Enter your host name: " HOST
    read -p "Retype host name: " CONFIRMHOST
done
echo
echo "Your host name is $HOST."
echo

read -p "Enter your username: " USERNAME
read -p "Retype username: " CONFIRMUSERNAME
until [ "$USERNAME" = "$CONFIRMUSERNAME" ]; do
    echo "Usernames did not match!"
    read -p "Enter your username: " USERNAME
    read -p "Retype username: " CONFIRMUSERNAME
done
echo
echo "Your username is $USERNAME."
echo

read -p "Enter your password: " PASSWORD
read -p "Retype password: " CONFIRMPASSWORD
until [ "$PASSWORD" = "$CONFIRMPASSWORD" ]; do
    echo "Passwords did not match!"
    read -p "Enter your password: " PASSWORD
    read -p "Retype password: " CONFIRMPASSWORD
done
echo""
echo "Your password is $PASSWORD."
echo""

read -p "Enter your root password: " ROOTPASSWORD
read -p "Retype root password: " ROOTCONFIRMPASSWORD
until [ "$ROOTPASSWORD" = "$ROOTCONFIRMPASSWORD" ]; do
    echo "Root passwords did not match!"
    read -p "Enter your root password: " ROOTPASSWORD
    read -p "Retype root password: " ROOTCONFIRMPASSWORD
done

read -p "Are you dual-booting? [y/n] (case-sensitive) " DUAL
read -p "Confirm your answer by typing it again: " CONFIRMDUAL
until [ "$ROOTPASSWORD" = "$ROOTCONFIRMPASSWORD" ]; do
    echo "Answers did not match!"
    read -p "Are you dual-booting? [y/n] (case-sensitive) " DUAL
    read -p "Confirm your answer by typing it again: " CONFIRMDUAL
done

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
pacman -S networkmanager networkmanager-runit grub efibootmgr xorg git --noconfirm
if [ DUAL = "y" ]; then
    pacman -S os-prober ntfs-3g
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
echo "$USERNAME ALL=(ALL) ALL" >> /etc/sudoers
( echo "$ROOTPASSWORD"; echo "$ROOTPASSWORD" ) | passwd
echo "Please reboot your system with 'sudo reboot' or 'sudo shutdown -h now'."