#!/usr/bin/env bash

select answer in 'Ljosalfheim (PC)' 'Svartalfheim (ThinkPad)'; do
    case "$answer" in
        'Ljosalfheim (PC)') HOST_NAME='Ljosalfheim' ; break ;;
        'Svartalfheim (ThinkPad)') HOST_NAME='Svartalfheim' ; break
    esac
done
export HOST_NAME
echo

read -p 'Enter username: ' USERNAME
read -p 'Confirm username: ' CONFIRM_USERNAME
until [ "$USERNAME" = "$CONFIRM_USERNAME" ]; do
    echo 'Usernames did not match!'
    read -p 'Enter username: ' USERNAME
    read -p 'Confirm username: ' CONFIRM_USERNAME
done
export USERNAME
echo

read -s -p 'Enter user password: ' USER_PASSWORD ; echo
read -s -p 'Confirm user password: ' CONFIRM_USER_PASSWORD ; echo
until [ "$PASSWORD" = "$CONFIRM_PASSWORD" ]; do
    echo 'Passwords did not match!'
    read -s -p 'Enter user password: ' USER_PASSWORD ; echo
    read -s -p 'Confirm user password: ' CONFIRM_USER_PASSWORD ; echo
done
export USER_PASSWORD
echo

read -s -p 'Enter root password: ' ROOT_PASSWORD ; echo
read -s -p 'Confirm root password: ' CONFIRM_ROOT_PASSWORD ; echo
until [ "$ROOT_PASSWORD" = "$CONFIRM_ROOT_PASSWORD" ]; do
    echo 'Passwords did not match!'
    read -s -p 'Enter root password: ' ROOT_PASSWORD ; echo
    read -s -p 'Confirm root password: ' CONFIRM_ROOT_PASSWORD ; echo
done
export ROOT_PASSWORD
echo

read -s -p 'Enter encryption key: ' ENCRYPTION_PASS ; echo
read -s -p 'Confirm encryption key: ' CONFIRM_ENCRYPTION_PASS ; echo
until [ "$ENCRYPTION_PASS" = "$CONFIRM_ENCRYPTION_PASS" ]; do
    echo 'Encryption keys did not match!'
    read -s -p 'Enter encryption key: ' ENCRYPTION_PASS ; echo
    read -s -p 'Confirm encryption key: ' CONFIRM_ENCRYPTION_PASS ; echo
done
export ENCRYPTION_PASS
echo

while true; do
    read -p 'Do you wish to shred device(s)? [y/N] ' yn
    case "$yn" in
        [Yy]* ) shred -fv /dev/sda
            [ "$HOST_NAME" = 'Svartalfheim' ] && shred -fv /dev/sdb
            break ;;
        [Nn]* ) break ;;
        '') break ;;
        * ) echo 'Please answer "yes" or "no".'
    esac
done
echo

if [ "$HOST_NAME" = 'Ljosalfheim' ]; then
    echo "Partitioning /dev/sda..." && printf 'g\nn\n\n\n+128M\nn\n\n\n\nw\n' | fdisk -w always -W always /dev/sda >/dev/null
elif [ "$HOST_NAME" = 'Svartalfheim' ]; then
    echo "Partitioning /dev/sda..." && printf 'o\nn\n\n\n\n+128M\nn\n\n\n\n\nw\n' | fdisk -w always -W always /dev/sda >/dev/null
    echo "Encrypting /dev/sdb..."
    echo "$ENCRYPTION_PASS" | cryptsetup luksFormat -q --force-password --type luks1 /dev/sdb
    echo "$ENCRYPTION_PASS" | cryptsetup open /dev/sdb crypthome
fi

echo "Encrypting /dev/sda2..."
echo "$ENCRYPTION_PASS" | cryptsetup luksFormat -q --force-password --type luks1 /dev/sda2
echo "$ENCRYPTION_PASS" | cryptsetup open /dev/sda2 cryptroot

if [ "$HOST_NAME" = 'Ljosalfheim' ]; then
    echo 'Formatting /dev/mapper/cryptroot...' && mkfs.ext4 -F /dev/mapper/cryptroot -L root >/dev/null
    echo 'Formatting /dev/sda1...' && mkfs.fat -F32 /dev/sda1 -n BOOT >/dev/null
    extra_pkg='efibootmgr linux-headers nvidia-dkms nvidia-utils nvidia-settings opencl-nvidia'
elif [ "$HOST_NAME" = 'Svartalfheim' ]; then
    echo 'Formatting /dev/mapper/cryptroot...' && mkfs.ext4 -F /dev/mapper/cryptroot -L root >/dev/null
    echo 'Formatting /dev/mapper/crypthome' && mkfs.ext4 -F /dev/mapper/crypthome -L home >/dev/null
    echo 'Formatting /dev/sda1...' && mkfs.ext4 -F /dev/sda1 -L BOOT >/dev/null
    extra_pkg='iwd intel-ucode smartmontools'
fi

echo 'Mounting /dev/mapper/cryptroot...' && mount /dev/mapper/cryptroot /mnt
[ "$HOST_NAME" = 'Svartalfheim' ] && echo 'Mounting /dev/mapper/crypthome...' && mkdir /mnt/home && mount /dev/mapper/crypthome /mnt/home
echo 'Mounting /dev/sda1...' && mkdir /mnt/boot && mount /dev/sda1 /mnt/boot

basestrap /mnt base base-devel runit elogind-runit linux linux-firmware cronie cronie-runit cryptsetup cryptsetup-runit connman-runit $extra_pkg \
    grub xorg xorg-xinit xdg-utils xdg-user-dirs polkit pipewire pipewire-alsa pipewire-pulse wireplumber man-db curl wget git --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
mv kai/installer2.sh /mnt && artix-chroot /mnt ./installer2.sh
