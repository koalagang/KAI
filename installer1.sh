#!/usr/bin/env bash

select answer in 'Alfheim (PC)' 'Asgard (ThinkPad)'; do
    case "$answer" in
        'Alfheim (PC)') HOST_NAME='Alfheim' ; export HOST_NAME ;;
        'Asgard (ThinkPad)') HOST_NAME='Asgard' ; export HOST_NAME
    esac
done

echo
read -s -p 'Enter your username: ' USERNAME ; echo
read -s -p 'Re-enter your user password: ' CONFIRM_USERNAME ; echo
until [ "$PASSWORD" = "$CONFIRM_PASSWORD" ]; do
    echo 'Passwords did not match!'
    read -s -p 'Enter your user password: ' USERNAME ; echo
    read -s -p 'Re-enter your user password: ' CONFIRM_USERNAME ; echo
done
export USERNAME
echo

echo
read -s -p 'Enter your user password: ' USER_PASSWORD ; echo
read -s -p 'Re-enter your user password: ' CONFIRM_USER_PASSWORD ; echo
until [ "$PASSWORD" = "$CONFIRM_PASSWORD" ]; do
    echo 'Passwords did not match!'
    read -s -p 'Enter your user password: ' USER_PASSWORD ; echo
    read -s -p 'Re-enter your user password: ' CONFIRM_USER_PASSWORD ; echo
done
export USER_PASSWORD
echo

read -s -p 'Enter your root password: ' ROOT_PASSWORD ; echo
read -s -p 'Re-enter your root password: ' CONFIRM_ROOT_PASSWORD ; echo
until [ "$ROOT_PASSWORD" = "$CONFIRM_ROOT_PASSWORD" ]; do
    echo 'Passwords did not match!'
    read -s -p 'Enter your root password: ' ROOT_PASSWORD ; echo
    read -s -p 'Re-enter your root password: ' CONFIRM_ROOT_PASSWORD ; echo
done
export ROOT_PASSWORD
echo

read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS ; echo
read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS ; echo
until [ "$ENCRYPTION_PASS" = "$CONFIRM_ENCRYPTION_PASS" ]; do
    echo 'Encryption keys did not match!'
    read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS ; echo
    read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS ; echo
done
echo

while true; do
    printf '\nWARNING: shredding your devices will wipe ALL data!\n'
    read -p 'Do you wish to shred your device(s)? [y/N] ' yn
    case "$yn" in
        [Yy]* ) shred -f /dev/sda
            [ "$HOST_NAME" = 'Asgard' ] && shred -f /dev/sdb
            break ;;
        [Nn]* ) break ;;
        '') break ;;
        * ) echo 'Please answer "yes" or "no".'
    esac
done
echo

echo "Partitioning /dev/sda..." && printf 'g\nn\np\n1\n\n+128M\nn\np\n2\n\n\nw' | fdisk /dev/sda
echo "Encrypting /dev/sda2..."
# cryptsetup defaults to using a 512-bit key
# see https://security.stackexchange.com/a/40218 for why I choose to use a 256-bit key
echo "$ENCRYPTION_PASS" | cryptsetup luksFormat -s 256 -q --force-password --type luks1 /dev/sda2
echo "$ENCRYPTION_PASS" | cryptsetup open /dev/sda2 cryptroot

if [ "$HOST_NAME" = 'Asgard' ]; then
    echo "Partitioning /dev/sdb..." && printf 'g\nn\n\n\nw' | fdisk /dev/sda
    echo "Encrypting /dev/sdb1..."
    echo "$ENCRYPTION_PASS" | cryptsetup luksFormat -s 256 -q --force-password --type luks1 /dev/sdb1
    echo "$ENCRYPTION_PASS" | cryptsetup open /dev/sdb1 crypthome
fi

echo 'Formatting /dev/mapper/cryptroot...' && mkfs.ext4 -F /dev/mapper/cryptroot -L root
[ "$HOST_NAME" = 'Asgard' ] && echo 'Formatting /dev/mapper/crypthome' && mkfs.ext4 -F /dev/mapper/crypthome -L home
echo 'Formatting /dev/sda1...' && mkfs.fat -F32 /dev/sda1 -n BOOT

echo 'Mounting /dev/mapper/cryptroot...' && mount /dev/mapper/cryptroot /mnt
[ "$HOST_NAME" = 'Asgard' ] && echo 'Mounting /dev/mapper/crypthome' && mkdir /mnt/home && mount /dev/mapper/crypthome
echo 'Mounting /dev/sda1' && mkdir /mnt/boot && mount /dev/sda1 /mnt/boot

# I only need wifi on my laptop
[ "$HOST_NAME" = 'Asgard' ] && wifi_pkg='iwd'

basestrap /mnt base base-devel runit elogind-runit linux linux-headers linux-firmware cronie cronie-runit cryptsetup cryptsetup-runit cups cups-runit connman-runit $wifi_pkg \
    grub efibootmgr xorg xdg-utils xdg-user-dirs polkit pipewire pipewire-alsa pipewire-pulse wireplumber git --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
mv kai/installer2.sh /mnt && artix-chroot /mnt ./installer2.sh
