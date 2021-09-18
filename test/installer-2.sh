#!/usr/bin/env bash

ln -sf /usr/share/zoneinfo/"$CITY" /etc/localtime
hwclock --systohc

cp /etc/locale.gen /etc/locale.gen.bak
sed -i "s/#$LANGUAGE.UTF-8\ UTF-8/$LANGUAGE.UTF-8\ UTF-8/" /etc/locale.gen
sed -i "s/#$LANGUAGE\ ISO-8859-1/$LANGUAGE\ ISO-8859-1/" /etc/locale.gen
#langs=($(seq 1 $lang_num | xargs -I% -n 1 echo '%'))
#[ -n "$lang_num" ] &&
#    for i in "${langs[@]}"; do
#        sed -i "s/#${langs[i]}.UTF-8\ UTF-8/${langs[i]}.UTF-8\ UTF-8/" /etc/locale.gen
#        sed -i "s/#${langs[i]}\ ISO-8859-1/${langs[i]}\ ISO-8859-1/" /etc/locale.gen
#    done
locale-gen
echo "LANG=$LANGUAGE.UTF-8" > /etc/locale.conf

[ -n "$SWAP" ] && echo 'Creating swapfile...' &&
    dd if=/dev/zero of=/swapfile bs=1M count="$(free -m | awk 'NR==2 {print $NF}')" status=progress && chmod 600 /swapfile &&
    mkswap /swapfile && swapon /swapfile && cp /etc/fstab /etc/fstab.bak && echo '/swapfile none swap defaults 0 0' >> /etc/fstab && echo 'Successfully created swapfile!'

pacman -Syy networkmanager networkmanager-runit grub efibootmgr xorg --noconfirm
# there's no need to install amd-ucode manually for amd users because it comes as a part of linux-firmware but intel-ucode does not so we need to manually install that for intel users
[[ "$(lscpu | grep 'Model name:')" =~ 'Intel' ]] && pacman -S intel-ucode --noconfirm

[ -n "$encrypt" ] && echo 'Configuring mkinitcpio...' && pacman -S lvm2 cryptsetup --noconfirm && cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak && cp /etc/default/grub /etc/default/grub.bak &&
    sed -i "s+$(grep '^HOOKS' /etc/mkinitcpio.conf)+HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard lvm2 fsck)+" /etc/mkinitcpio.conf &&
    mkinitcpio -p "$KERNEL" && echo 'Successfully configured mkinitcpio!' && echo 'Configuring grub...' && cp /etc/default/grub /etc/default/grub.bak &&
    sed -i -e "s+$(grep -w 'GRUB_CMDLINE_LINUX' /etc/default/grub)+GRUB_CMDLINE_LINUX=\"cryptdevice=/dev/sda2:cryptlvm\"+" -e "s+$(grep 'GRUB_ENABLE_CRYPTODISK' /etc/default/grub)+GRUB_ENABLE_CRYPTODISK=y+" /etc/default/grub &&
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck "$DEVICE" &&
grub-mkconfig -o /boot/grub/grub.cfg && echo 'Successfully configured grub!'

echo "$HOST" > /etc/hostname
printf '127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t %s.localdomain \t %s' "$HOST" "$HOST" > /etc/hosts
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default

useradd -m -G wheel "$USERNAME"
( echo "$USER_PASSWORD" ; echo "$USER_PASSWORD" ) | passwd "$USERNAME"
cp /etc/sudoers /etc/sudoers.bak
sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' -e 's/# %sudo ALL=(ALL) ALL/%sudo ALL=(ALL) ALL/' /etc/sudoers
( echo "$ROOT_PASSWORD" ; echo "$ROOT_PASSWORD" ) | passwd

printf '\n\nInstallation complete! If you wish to reboot or shutdown, simply enter "loginctl reboot" or "loginctl poweroff" respectively.\n'
rm /installer-2.sh
