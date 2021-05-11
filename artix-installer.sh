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
        read -p "Enter your host name: "  HOST
        read -p "Retype host name: "  CONFIRMHOST
    done
    echo
    echo "Your host name is $HOST."
    export HOST
    echo
    read -p "Enter your username: "  USERNAME
    read -p "Retype username: "  CONFIRMUSERNAME
    until [ "$USERNAME" = "$CONFIRMUSERNAME" ]; do
        echo "Usernames did not match!"
        read -p "Enter your username: "  USERNAME
        read -p "Retype username: "  CONFIRMUSERNAME
    done
    echo
    echo "Your username is $USERNAME."
    export USERNAME
    echo
    read -p "Enter your password: "  PASSWORD
    read -p "Retype password: "  CONFIRMPASSWORD
    until [ "$PASSWORD" = "$CONFIRMPASSWORD" ]; do
        echo "Passwords did not match!"
        read -p "Enter your password: "  PASSWORD
        read -p "Retype password: "  CONFIRMPASSWORD
    done
    echo
    echo "Your password is $PASSWORD."
    export PASSWORD
    echo
    read -p "Enter your root password: "  ROOTPASSWORD
    read -p "Retype root password: "  ROOTCONFIRMPASSWORD
    until [ "$ROOTPASSWORD" = "$ROOTCONFIRMPASSWORD" ]; do
        echo "Root passwords did not match!"
        read -p "Enter your root password: "  ROOTPASSWORD
        read -p "Retype root password: "  ROOTCONFIRMPASSWORD
    done
    echo
    echo "Your password is $ROOTPASSWORD."
    export ROOTPASSWORD
    echo
    read -p "Are you dual-booting? [Y/N] " DUAL
    read -p "Confirm your answer by typing it again: " CONFIRMDUAL
    until [ "$DUAL" = "$CONFIRMDUAL" ]; do
        echo "Answers did not match!"
        read -p "Are you dual-booting? [Y/N] " DUAL
        read -p "Confirm your answer by typing it again: " CONFIRMDUAL
    done
    export DUAL
    echo
    echo "NOTE: saying yes to the following adds 'startx /home/$USER/.config/x11/.xinitrc' to /etc/profile"
    read -p "Are you using startx? [Y/N] " STARTX
    read -p "Confirm your answer by typing it again: " CONFIRMSTARTX
    until [ "$STARTX" = "$CONFIRMSTARTX" ]; do
        echo "Answers did not match!"
        read -p "Are you using startx? [Y/N] " STARTX
        read -p "Confirm your answer by typing it again: " CONFIRMSTARTX
    done
    export STARTX
    mkfs.ext4 /dev/sda2 # root
    mkfs.ext4 /dev/sda3 # home
    mkfs.fat -F32 /dev/sda1 # boot
    mount /dev/sda2 /mnt
    mkdir /mnt/boot
    mkdir /mnt/home
    mount /dev/sda1 /mnt/boot
    mount /dev/sda3 /mnt/home
    basestrap /mnt base base-devel runit elogind-runit linux linux-firmware linux-headers --noconfirm
    fstabgen -U /mnt >> /mnt/etc/fstab
    chmod +x kai/installer.sh || chmod +x KAI/installer.sh
    mv kai/installer.sh /mnt || mv KAI/installer.sh /mnt
    artix-chroot /mnt ./installer.sh
else
    echo "You may run the script again once you have partitioned your disk correctly."
fi
