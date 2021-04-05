#!/bin/sh

lsblk
printf "\nWARNING: this script assumes that you have partitioned your disk like this\n/dev/sda1 = boot\n/dev/sda2 = root\n"
printf "\nIf you have not partitioned it like this, you MUST go back and partition it that way OR edit the script.\n"
read -p "AGREE AND CONTINUE WITH THE SCRIPT? [YES/NO]" CONTINUE
if [ CONTINUE = "YES" ]; then
    mkfs.ext4 /dev/sda2
    mkfs.fat -F32 /dev/sda1
    mount /dev/sda2 /mnt
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot
    basestrap /mnt base base-devel runit elogind-runit linux-lts linux-firmware linux-lts-headers --noconfirm
    fstabgen -U /mnt >> /mnt/etc/fstab
    chmod +x kai/installer.sh || chmod +x KAI/installer.sh
    mv kai/installer.sh /mnt || mv KAI/installer.sh /mnt
    artix-chroot /mnt ./installer.sh
else
    echo "You may run the script again once your disks are partitioned correctly."
fi
