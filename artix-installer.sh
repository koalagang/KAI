#!/bin/sh

# As of now, the script assumes that you have formatted the disk to only have a root and a boot parititon.
# I may set the script to allow other partitions, e.g. home and swap, as well later.

lsblk
printf "\nWARNING: this script assumes that you have already partitioned your disk like this:\n/dev/sda1 = approx. 128M to 512M in size - this should be marked as bootable, it will be the boot partition\n/dev/sda2 = approx. 30 GB in size - this will be the root partition\n/dev/sda3 = the rest of the disk space - this will be the home partition\nThere will be no swap partition because we will be using a swap file.\n"
printf "\nIf you have not partitioned it like this, you MUST go back and partition it that way OR manually edit the script.\n"
read -p "AGREE AND CONTINUE? [Y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    read -p "Enter your host name: " HOST
    read -p "Retype host name: " CONFIRMHOST
    until [ "$HOST" = "$CONFIRMHOST" ]; do
        echo "Host names did not match!"
        read -p "Enter your host name: " export HOST
        read -p "Retype host name: " export CONFIRMHOST
    done
    echo
    echo "Your host name is $HOST."
    echo
    read -p "Enter your username: " export USERNAME
    read -p "Retype username: " export CONFIRMUSERNAME
    until [ "$USERNAME" = "$CONFIRMUSERNAME" ]; do
        echo "Usernames did not match!"
        read -p "Enter your username: " export USERNAME
        read -p "Retype username: " export CONFIRMUSERNAME
    done
    echo
    echo "Your username is $USERNAME."
    echo
    read -p "Enter your password: " export PASSWORD
    read -p "Retype password: " export CONFIRMPASSWORD
    until [ "$PASSWORD" = "$CONFIRMPASSWORD" ]; do
        echo "Passwords did not match!"
        read -p "Enter your password: " export PASSWORD
        read -p "Retype password: " export CONFIRMPASSWORD
    done
    echo""
    echo "Your password is $PASSWORD."
    echo""
    read -p "Enter your root password: " export ROOTPASSWORD
    read -p "Retype root password: " export ROOTCONFIRMPASSWORD
    until [ "$ROOTPASSWORD" = "$ROOTCONFIRMPASSWORD" ]; do
        echo "Root passwords did not match!"
        read -p "Enter your root password: " export ROOTPASSWORD
        read -p "Retype root password: " export ROOTCONFIRMPASSWORD
    done
    read -p "Are you dual-booting? [Y/N] " export DUAL
    read -p "Confirm your answer by typing it again: " export CONFIRMDUAL
    until [ "$DUAL" = "$CONFIRMDUAL" ]; do
        echo "Answers did not match!"
        read -p "Are you dual-booting? [Y/N] " export DUAL
        read -p "Confirm your answer by typing it again: " export CONFIRMDUAL
    done
    mkfs.ext4 /dev/sda2 # root
    mkfs.ext4 /dev/sda3 # home
    mkfs.fat -F32 /dev/sda1 # boot
    mount /dev/sda2 /mnt
    mkdir /mnt/boot
    mkdir /mnt/home
    mount /dev/sda1 /mnt/boot
    mount /dev/sda3 /mnt/home
    basestrap /mnt base base-devel runit elogind-runit linux-lts linux-firmware linux-lts-headers --noconfirm
    fstabgen -U /mnt >> /mnt/etc/fstab
    chmod +x kai/installer.sh || chmod +x KAI/installer.sh
    mv kai/installer.sh /mnt || mv KAI/installer.sh /mnt
    artix-chroot /mnt ./installer.sh
else
    echo "You may run the script again once you have partitioned your disk correctly."
fi
