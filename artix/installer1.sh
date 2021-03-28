#!/usr/bin/bash

basestrap /mnt base base-devel runit elogind-runit linux-lts linux-firmware linux-lts-headers --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
artix-chroot /mnt
