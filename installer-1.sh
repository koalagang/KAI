#!/usr/bin/sh

pacstrap /mnt base base-devel linux-lts linux-firmware linux-lts-headers --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt #/bin/bash
