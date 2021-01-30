#!/usr/bin/bash

pacstrap /mnt base base-devel linux-lts linux-firmware --noconfirm # the LTS Linux kernel is more stable than the latest kernel
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash
