#!/usr/bin/env bash

ln -sf /usr/share/zoneinfo/"$CITY" /etc/localtime
hwclock --systohc

cp /etc/locale.gen /etc/locale.gen.bak
sed -i "s/#$LANGUAGE.UTF-8\ UTF-8/$LANGUAGE.UTF-8\ UTF-8/" /etc/locale.gen
sed -i "s/#$LANGUAGE\ ISO-8859-1/$LANGUAGE\ ISO-8859-1/" /etc/locale.gen
langs=($(seq 1 "$lang_num" | xargs -I% -n 1 echo 'EXTRA_LANG%'))
[ -n "$lang_num" ] &&
    for i in "${langs[@]}"; do
        sed -i "s/#$EXTRA_LANGUAGE${langs[i]}.UTF-8\ UTF-8/$EXTRA_LANGUAGE${langs[i]}.UTF-8\ UTF-8/" /etc/locale.gen
        sed -i "s/#$EXTRA_LANGUAGE${langs[i]}\ ISO-8859-1/$EXTRA_LANGUAGE${langs[i]}\ ISO-8859-1/" /etc/locale.gen
    done
locale-gen
echo "LANG=$LANGUAGE.UTF-8" > /etc/locale.conf

pacman -S networkmanager networkmanager-runit grub efibootmgr xorg --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

echo "$HOST" > /etc/hostname
printf "127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t $HOST.localdomain \t $HOST" > /etc/hosts
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default

useradd -m -G wheel "$USERNAME"
( echo "$USER_PASSWORD" ; echo "$USER_PASSWORD" ) | passwd "$USERNAME"
cp /etc/sudoers /etc/sudoers.bak
sed -i "s/#\ %wheel\ ALL=(ALL)\ ALL/%wheel\ ALL=(ALL) ALL/g" /etc/sudoers
sed -i "s/#\ %sudo\ ALL=(ALL)\ ALL/%wheel\ ALL=(ALL) ALL/g" /etc/sudoers
( echo "$ROOT_PASSWORD" ; echo "$ROOT_PASSWORD" ) | passwd

pacman -Syu --noconfirm

[ "$reboot" -eq 1 2>/dev/null ] && loginctl reboot
[ "$shutdown" -eq 1 2>/dev/null ] && loginctl poweroff
echo
echo 'Installation complete! If you wish to reboot or shutdown, simply enter "loginctl reboot" or "loginctl poweroff" respectively.'
