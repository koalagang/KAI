#!/usr/bin/env bash

select answer in 'Alfheim (PC)' 'Asgard (ThinkPad)'; do
    case "$answer" in
        'Alfheim (PC)') HOST_NAME='Alfheim' ; export HOST_NAME ; break ;;
        'Asgard (ThinkPad)') HOST_NAME='Asgard' ; export HOST_NAME ; break
    esac
done

echo
read -p 'Enter username: ' USERNAME
read -p 'Confirm username: ' CONFIRM_USERNAME
until [ "$PASSWORD" = "$CONFIRM_PASSWORD" ]; do
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
echo

while true; do
    printf '\nWARNING: shredding devices will wipe ALL data!\n'
    read -p 'Do you wish to shred device(s)? [y/N] ' yn
    case "$yn" in
        [Yy]* ) shred -fv /dev/sda
            [ "$HOST_NAME" = 'Asgard' ] && shred -fv /dev/sdb
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
    grub efibootmgr xorg xdg-utils xdg-user-dirs polkit pipewire pipewire-alsa pipewire-pulse wireplumber curl wget git --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
mv kai/installer2.sh /mnt && artix-chroot /mnt ./installer2.sh
