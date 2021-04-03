#!/bin/sh

basestrap /mnt base base-devel runit elogind-runit linux-lts linux-firmware linux-lts-headers --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
chmod +x kai/artix/test/installer.sh || chmod +x KAI/artix/test/installer.sh
mv kai/artix/test/installer.sh /mnt || mv KAI/artix/test/installer.sh /mnt
artix-chroot /mnt ./installer.sh
