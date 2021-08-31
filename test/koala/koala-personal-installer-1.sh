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

read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS
read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS
until [ "$ENCRYPTION_PASS" = "$CONFIRM_ENCRYPTION_PASS" ]; do
    printf 'Encryption keys did not match!\n'
    read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS
    read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS
done
echo "THE CONTENTS OF $DEVICE IS ABOUT TO BE DELETED. YOU WILL LOSE ALL DATA ON $DEVICE AND THERE WILL BE NO GOING BACK!" ; continue_prompt
echo "Wiping $DEVICE..." && sfdisk --delete "$DEVICE" && echo "$DEVICE successfully wiped."
echo "Partitioning $DEVICE..." && printf 'n\n\n\n+128M\nn\n\n\n\nw' | fdisk "$DEVICE" && echo "Successfully partitioned $DEVICE."
echo "Encrypting $DEVICE..." && echo "$ENCRYPTION_PASS" | cryptsetup luksFormat "$DEVICE"2 -q --force-password &&
    cryptsetup open "$DEVICE"2 cryptlvm &&
    pvcreate /dev/mapper/cryptlvm &&
    vgcreate encrypted_volumes &&
    vgcreate encrypted_volumes /dev/mapper/cryptlvm &&
    lvcreate -L 30G encrypted_volumes -n root &&
    lvcreate -L 100%FREE encrypted_volumes -n home &&
    encryption_success=1
[ "$encryption_success" -eq 1 ] && echo "Successfully encrypted $DEVICE."
[ "$encryption_success" -ne 1 ] && echo "error: failed to encrypt $DEVICE." && exit 0
echo "Formatting $DEVICE..." &&
    mkfs.ext4 /dev/encrypted_volumes/root -L root && mkfs.ext4 /dev/encrypted_volumes/home -L home && mkfs.fat -F32 "$DEVICE"1 && format_success=1
[ "$format_success" -eq 1 ] && echo "Successfully formatted $DEVICE."
[ "$format_sucess" -ne 1 ] && echo "error: failed to format $DEVICE." && exit 0
echo "Mounting $DEVICE..." && mount "$DEVICE"2 /mnt && mkdir /mnt/boot && mount "$DEVICE"1 /mnt/boot && mount_succcess=1
[ "$mount_success" -eq 1 ] && "Successfully mounted $DEVICE."
[ "$mount_success" -ne 1 ] && "error: failed to mount $DEVICE." && exit 0

basestrap /mnt base base-devel runit elogind-runit linux-lts linux-lts-headers linux-firmware --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
artix-chroot /mnt ./koala-personal-installer-2.sh
