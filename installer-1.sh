#!/usr/bin/bash

pacstrap /mnt base base-devel linux-lts linux-firmware linux-headers-lts --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash
