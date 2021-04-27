#!/bin/sh

# As of now, the script assumes that you have formatted the disk to only have a root and a boot parititon.
# I may set the script to allow other partitions, e.g. home and swap, as well later.

lsblk
printf "\nWARNING: this script assumes that you have already partitioned your disk like this:\n/dev/sda1 = approx. 128M to 512M in size - this should be marked as bootable, it will be the boot partition\n/dev/sda2 = approx. 30 GB in size - this will be the root partition\n/dev/sda3 = the rest of the disk space - this will be the home partition\nThere will be no swap partition because we will be using a swap file.\n"
printf "\nIf you have not partitioned it like this, you MUST go back and partition it that way OR manually edit the script.\n"
read -p "AGREE AND CONTINUE? [Y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    mkfs.ext4 /dev/sda2 # root
    mkfs.ext4 /dev/sda3 # home
    mkfs.fat -F32 /dev/sda1 # boot
    mount /dev/sda2 /mnt
    mkdir /mnt/boot
    mkdir /mnt/home
    mount /dev/sda1 /mnt/boot
    mount /dev/sda3 /mnt/home
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
	sed -i '36s/Server/#Server/g' /etc/pacman.d/mirrorlist
	sed -i '37s/Server/#Server/g' /etc/pacman.d/mirrorlist
	sed -i '38s/Server/#Server/g' /etc/pacman.d/mirrorlist
	sed -i '39s/Server/#Server/g' /etc/pacman.d/mirrorlist
    pacman -Syy
    basestrap /mnt base base-devel runit elogind-runit linux-lts linux-firmware linux-lts-headers --noconfirm
    fstabgen -U /mnt >> /mnt/etc/fstab
    chmod +x kai/installer.sh || chmod +x KAI/installer.sh
    mv kai/installer.sh /mnt || mv KAI/installer.sh /mnt
    artix-chroot /mnt ./installer.sh
else
    echo "You may run the script again once you have partitioned your disk correctly."
fi
