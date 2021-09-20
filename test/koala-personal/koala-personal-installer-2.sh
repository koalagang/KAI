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

[ "$HOST" = 'Asgard' ] && COUNT=7630
[ "$HOST" = 'Alfheim' ] && COUNT=15260
echo 'Creating swapfile...' &&
    dd if=/dev/zero of=/swapfile bs=1M count=$COUNT status=progress && chmod 600 /swapfile &&
    mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo '/swapfile none swap defaults 0 0' >> /etc/fstab && echo 'Successfully created swapfile!'

pacman -Syy networkmanager networkmanager-runit grub efibootmgr xorg git --noconfirm

# there's no need to install amd-ucode manually for amd users because it comes as a part of linux-firmware but intel-ucode does not so we need to manually install that for intel users
[ "$HOST" = 'Asgard' ] && pacman -S intel-ucode --noconfirm

echo 'Configuring mkinitcpio...' && pacman -S lvm2 cryptsetup --noconfirm && cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak && cp /etc/default/grub /etc/default/grub.bak &&
    sed -i "s+$(grep '^HOOKS' /etc/mkinitcpio.conf)+HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard lvm2 fsck)+" /etc/mkinitcpio.conf &&
    mkinitcpio -p linux-lts && echo 'Successfully configured mkinitcpio!' &&
    echo 'Configuring grub...' && cp /etc/default/grub /etc/default/grub.bak &&
    sed -i -e "s+$(grep -w 'GRUB_CMDLINE_LINUX' /etc/default/grub)+GRUB_CMDLINE_LINUX=\"cryptdevice=/dev/sda2:cryptlvm\"+" \
    -e "s+$(grep 'GRUB_ENABLE_CRYPTODISK' /etc/default/grub)+GRUB_ENABLE_CRYPTODISK=y+" /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck "$DEVICE" &&
grub-mkconfig -o /boot/grub/grub.cfg && echo 'Successfully installed grub!'

echo "$HOST" > /etc/hostname
printf '127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t %s.localdomain \t %s' "$HOST" "$HOST" > /etc/hosts
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default

useradd -m -G wheel "$USERNAME"
( echo "$USER_PASSWORD" ; echo "$USER_PASSWORD" ) | passwd "$USERNAME"
cp /etc/sudoers /etc/sudoers.bak
sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' -e 's/# %sudo ALL=(ALL) ALL/%sudo ALL=(ALL) ALL/' /etc/sudoers
( echo "$ROOT_PASSWORD" ; echo "$ROOT_PASSWORD" ) | passwd

git clone https://github.com/koalagang/kai.git /home/"$USERNAME"/kai

printf '\n\nInstallation complete! If you wish to reboot or shutdown, simply enter "loginctl reboot" or "loginctl poweroff" respectively.\n'
echo 'KAI has been cloned into your home directory so that you can install extra packages using paru without being root.'
rm /koala-personal-installer-2.sh
