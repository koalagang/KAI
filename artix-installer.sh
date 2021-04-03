#!/bin/sh

basestrap /mnt base base-devel runit elogind-runit linux-lts linux-firmware linux-lts-headers --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
chmod +x kai/installer.sh || chmod +x KAI/installer.sh
mv kai/installer.sh /mnt || mv KAI/installer.sh /mnt
artix-chroot /mnt ./installer.sh
