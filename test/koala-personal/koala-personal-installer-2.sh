#!/usr/bin/env bash

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

sed -i "s/#en_GB.UTF-8\ UTF-8/en_GB.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#en_GB\ ISO-8859-1/en_GB\ ISO-8859-1/g" /etc/locale.gen
sed -i "s/#en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#en_US\ ISO-8859-1/en_US\ ISO-8859-1/g" /etc/locale.gen
sed -i "s/#nb_NO.UTF-8\ UTF-8/nb_NO.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#nb_NO\ ISO-8859-1/nb_NO\ ISO-8859-1/g" /etc/locale.gen
locale-gen
echo 'LANG=en_GB.UTF-8' > /etc/locale.conf

fallocate --length '4GB' /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo '/swapfile none swap defaults 0 0' >> /etc/fstab

pacman -Syy networkmanager networkmanager-runit grub efibootmgr xorg --noconfirm

pacman -S lvm2 cryptsetup --noconfirm && cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak && cp /etc/default/grub /etc/default/grub.bak &&
    sed -i "s+$(grep '^HOOKS' /etc/mkinitcpio.conf)+HOOKS=(base udev autodetect modconf block encrypt filesystems resume keyboard lvm2 fsck)+" /etc/mkinitcpio.conf && mkinitcpio -p "$KERNEL" &&
    sed -i -e "s+$(grep 'GRUB_CMDLINE_LINUX_DEFAULT' /etc/default/grub)+GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=$(blkid -s UUID -o value "$DEVICE"2):cryptlvm\"+" -e "s+$(grep 'GRUB_ENABLE_CRYPTODISK' /etc/default/grub)+GRUB_ENABLE_CRYPTODISK=y+" /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck "$DEVICE"
grub-mkconfig -o /boot/grub/grub.cfg

echo "$HOST" > /etc/hostname
printf '127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t %s.localdomain \t %s' "$HOST" "$HOST" > /etc/hosts
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default

useradd -m -G wheel "$USERNAME"
( echo "$USER_PASSWORD" ; echo "$USER_PASSWORD" ) | passwd "$USERNAME"
cp /etc/sudoers /etc/sudoers.bak
sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' -e 's/# %sudo ALL=(ALL) ALL/%sudo ALL=(ALL) ALL/' /etc/sudoers
( echo "$ROOT_PASSWORD" ; echo "$ROOT_PASSWORD" ) | passwd

printf '\n\nInstallation complete! If you wish to reboot or shutdown, simply enter "loginctl reboot" or "loginctl poweroff" respectively.\n'
rm /koala-personal-installer-2.sh
