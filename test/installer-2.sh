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

[ -n "$SWAP_SIZE" ] && fallocate --length "$SWAP_SIZE" /swapfile && chmod 600 /swapfile && SWAP_UUID="$(mkswap /swapfile | tail -1 | cut -d'=' -f2)" && swapon /swapfile && cp /etc/fstab /etc/fstab.bak echo '/swapfile none swap defaults 0 0' >> /etc/fstab

pacman -Syy networkmanager networkmanager-runit grub efibootmgr xorg wget git --noconfirm
[ -n "$encrypt" ] && pacman -S lvm2 cryptsetup --noconfirm && sed -i "s/$(grep '^HOOKS' /etc/mkinitcpio.conf)/HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard lvm2 fsck)/" /etc/mkinitcpio.conf && sed -i -e "s+$(grep '^GRUB_CMDLINE_LINUX_DEFAULT' /etc/default/grub)+GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=$(blkid -s UUID -o value "$DEVICE"2):lvm-system loglevel=3 quiet resume=UUID=yyy net.ifnames=0\"+" -e "s+$(grep 'GRUB_ENABLE_CRYPTODISK' /etc/default/grub)+GRUB_ENABLE_CRYPTODISK=y+" /etc/default/grub && [ -n "$SWAP_SIZE" ] && sed -i "s/yyy/$SWAP_UUID/"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

echo "$HOST" > /etc/hostname
# shellcheck disable=SC2183
printf "127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t %s.localdomain \t %s" "$HOST" > /etc/hosts
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default

useradd -m -G wheel "$USERNAME"
( echo "$USER_PASSWORD" ; echo "$USER_PASSWORD" ) | passwd "$USERNAME"
cp /etc/sudoers /etc/sudoers.bak
sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' -e 's/# %sudo ALL=(ALL) ALL/%sudo ALL=(ALL) ALL/' /etc/sudoers
( echo "$ROOT_PASSWORD" ; echo "$ROOT_PASSWORD" ) | passwd

printf '\n\nInstallation complete! If you wish to reboot or shutdown, simply enter "loginctl reboot" or "loginctl poweroff" respectively.\n'
