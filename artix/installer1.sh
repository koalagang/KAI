#!/usr/bin/bash

basestrap /mnt base base-devel runit elogind-runit linux-lts linux-firmware linux-lts-headers grub os-prober efibootmgr
fstabgen -U /mnt >> /mnt/etc/fstab
artools-chroot /mnt
