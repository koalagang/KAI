#!/usr/bin/env bash

read -p 'What is the name of the device you wish to install Artix on? (e.g. /dev/sda, /dev/sdb/, /dev/sdx, etc) ' DEVICE

USERNAME = 'gabriel' && export USERNAME

read -s -p 'Enter your user password: ' PASSWORD
read -s -p 'Re-enter your user password: ' CONFIRM_PASSWORD
until [ "$PASSWORD" = "$CONFIRM_PASSWORD" ]; do
    echo 'Passwords did not match!'
    read -s -p 'Enter your user password: ' PASSWORD
    read -s -p 'Re-enter your user password: ' CONFIRM_PASSWORD
done
export PASSWORD
echo

read -s -p 'Enter your root password: ' ROOT_PASSWORD
read -s -p 'Re-enter your root password: ' CONFIRM_ROOT_PASSWORD
until [ "$ROOT_PASSWORD" = "$CONFIRM_ROOT_PASSWORD" ]; do
    echo 'Passwords did not match!'
    read -s -p 'Enter your root password: ' ROOT_PASSWORD
    read -s -p 'Re-enter your root password: ' CONFIRM_ROOT_PASSWORD
done
export ROOT_PASSWORD
echo

read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS
read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS
until [ "$ENCRYPTION_PASS" = "$CONFIRM_ENCRYPTION_PASS" ]; do
    echo 'Encryption keys did not match!'
    read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS
    read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS
done
export ENCRYPTION_PASS
echo

echo
read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS ; echo
read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS ; echo
until [ "$ENCRYPTION_PASS" = "$CONFIRM_ENCRYPTION_PASS" ]; do
    echo 'Encryption keys did not match!'
    read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS ; echo
    read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS ; echo
done
echo
echo "THE CONTENTS OF $DEVICE IS ABOUT TO BE DELETED. YOU WILL LOSE ALL DATA ON $DEVICE AND THERE WILL BE NO GOING BACK!" ; continue_prompt
echo "Partitioning $DEVICE..." && printf 'o\nn\np\n1\n\n+128M\nn\np\n2\n\n\nw' | fdisk "$DEVICE" && echo "Successfully partitioned $DEVICE."
echo "Encrypting $DEVICE..." && echo "$ENCRYPTION_PASS" | cryptsetup luksFormat -q --force-password --type luks1 "$DEVICE"2 &&
    echo "$ENCRYPTION_PASS" | cryptsetup open "$DEVICE"2 cryptlvm &&
    pvcreate /dev/mapper/cryptlvm &&
    vgcreate lvmSystem /dev/mapper/cryptlvm &&
    lvcreate -l 100%FREE lvmSystem -n root && encryption_success=1
if [ -n "$encryption_success" ]; then
    echo "Successfully encrypted $DEVICE."
else
    echo "error: failed to encrypt $DEVICE" && exit 0
fi

echo "Formatting $DEVICE..." &&
    mkfs.ext4 /dev/lvmSystem/root -L root && mkfs.fat -F32 "$DEVICE"1 && format_success=1
if [ -n "$format_success" ]; then
    echo "Successfully formatted $DEVICE."
else
    echo "error: failed to format $DEVICE" && exit 0
fi

echo "Mounting $DEVICE..." && mount /dev/lvmSystem/root /mnt &&
    mkdir -p /mnt/boot && mount "$DEVICE"1 /mnt/boot && mount_success=1
if [ -n "$mount_success" ]; then
    echo "Successfully mounted $DEVICE."
else
    echo "error: failed to mount $DEVICE" && exit 0
fi

encrypt=1 && export encrypt && export DEVICE

basestrap /mnt base base-devel runit elogind-runit linux-lts linux-lts-headers linux-firmware --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
artix-chroot /mnt ./koala-personal-installer-2.sh
mv koala-personal/koala-personal-installer-2.sh /mnt && artix-chroot /mnt ./koala-personal-installer-installer-2.sh
