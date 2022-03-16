#!/usr/bin/env bash

select answer in 'Ljosalfheim (PC)' 'Svartalfheim (ThinkPad)'; do
    case "$answer" in
        'Ljosalfheim (PC)') HOST_NAME='Ljosalfheim' ; break ;;
        'Svartalfheim (ThinkPad)') HOST_NAME='Svartalfheim' ; break
    esac
done
export HOST_NAME
echo

select_username (){
    read -p 'Enter username: ' USERNAME
    read -p 'Confirm username: ' CONFIRM_USERNAME
    until [ "$USERNAME" = "$CONFIRM_USERNAME" ]; do
        printf '\nUsernames did not match!\n\n'
        read -p 'Enter username: ' USERNAME
        read -p 'Confirm username: ' CONFIRM_USERNAME
    done
}
select_username
while [[ "$USERNAME" =~ [0-9] ]]; do
    printf '\nUsername may not contain numbers!\n'
    select_username
done
[[ "$USERNAME" =~ ^[A-Z] ]] && USERNAME="$(echo $USERNAME | tr '[:upper:]' '[:lower:]')" && printf "\nUsername may not contain uppercase letters.\nUsername set to '%s'.\n" "$USERNAME"
export USERNAME
echo

read -s -p 'Enter user password: ' USER_PASSWORD ; echo
read -s -p 'Confirm user password: ' CONFIRM_USER_PASSWORD ; echo
until [ "$PASSWORD" = "$CONFIRM_PASSWORD" ]; do
    printf '\nPasswords did not match!\n\n'
    read -s -p 'Enter user password: ' USER_PASSWORD ; echo
    read -s -p 'Confirm user password: ' CONFIRM_USER_PASSWORD ; echo
done
export USER_PASSWORD
echo

read -s -p 'Enter root password: ' ROOT_PASSWORD ; echo
read -s -p 'Confirm root password: ' CONFIRM_ROOT_PASSWORD ; echo
until [ "$ROOT_PASSWORD" = "$CONFIRM_ROOT_PASSWORD" ]; do
    printf '\nPasswords did not match!\n\n'
    read -s -p 'Enter root password: ' ROOT_PASSWORD ; echo
    read -s -p 'Confirm root password: ' CONFIRM_ROOT_PASSWORD ; echo
done
export ROOT_PASSWORD
echo

read -s -p 'Enter encryption key: ' ENCRYPTION_PASS ; echo
read -s -p 'Confirm encryption key: ' CONFIRM_ENCRYPTION_PASS ; echo
until [ "$ENCRYPTION_PASS" = "$CONFIRM_ENCRYPTION_PASS" ]; do
    printf '\nEncryption keys did not match!\n\n'
    read -s -p 'Enter encryption key: ' ENCRYPTION_PASS ; echo
    read -s -p 'Confirm encryption key: ' CONFIRM_ENCRYPTION_PASS ; echo
done
export ENCRYPTION_PASS
echo

while true; do
    printf 'This is your FINAL chance to make sure all your important data is BACKED UP.\nThe following steps will involve DELETING ALL DATA from your device(s).\n\n'
    read -p 'Do you wish to continue and WIPE ALL devices? [y/N] ' yn
    case "$yn" in
        [Yy]* ) break ;;
        [Nn]* ) printf '\nscript cancelled: exiting...\n' && exit ;;
        '') printf '\nscript cancelled: exiting...\n' && exit ;;
        * ) echo 'Please answer "yes" or "no".'
    esac
done
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
    echo "Partitioning /dev/sda..." && printf 'g\nn\n\n\n+128M\nn\n\n\n\nw\n' | fdisk -w always -W always /dev/sda >/dev/null 2>&1
elif [ "$HOST_NAME" = 'Svartalfheim' ]; then
    echo "Partitioning /dev/sda..." && printf 'o\nn\n\n\n\n+128M\nn\n\n\n\n\nw\n' | fdisk -w always -W always /dev/sda >/dev/null 2>&1
    wipefs -af /dev/sdb >/dev/null
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
    extra_pkg='efibootmgr nvidia-dkms nvidia-utils nvidia-settings opencl-nvidia'
elif [ "$HOST_NAME" = 'Svartalfheim' ]; then
    echo 'Formatting /dev/mapper/cryptroot...' && mkfs.ext4 -F /dev/mapper/cryptroot -L root >/dev/null
    echo 'Formatting /dev/mapper/crypthome' && mkfs.ext4 -F /dev/mapper/crypthome -L home >/dev/null
    echo 'Formatting /dev/sda1...' && mkfs.ext4 -F /dev/sda1 -L BOOT >/dev/null
    extra_pkg='iwd intel-ucode smartmontools'
fi

echo 'Mounting /dev/mapper/cryptroot...' && mount /dev/mapper/cryptroot /mnt
[ "$HOST_NAME" = 'Svartalfheim' ] && echo 'Mounting /dev/mapper/crypthome...' && mkdir /mnt/home && mount /dev/mapper/crypthome /mnt/home
echo 'Mounting /dev/sda1...' && mkdir /mnt/boot && mount /dev/sda1 /mnt/boot

sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 20/' /etc/pacman.conf && echo 'ParallelDownloads set to 20.'

basestrap /mnt base base-devel runit elogind-runit linux linux-headers linux-firmware cronie-runit cryptsetup-runit connman-runit syncthing-runit cups-runit $extra_pkg \
    grub xorg xorg-xinit xdg-utils xdg-user-dirs polkit pipewire pipewire-alsa pipewire-pulse wireplumber man-db curl wget git --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
mv kai/10-keyboard.conf /mnt # for configuring keyboard layout in the installer2.sh script
mv kai/installer2.sh /mnt && artix-chroot /mnt ./installer2.sh
