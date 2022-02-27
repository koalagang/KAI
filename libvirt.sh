#!/bin/sh
pacman -S glibc vim --noconfirm
sed -i 's/sda/vda/g' kai/installer1.sh
sed -i 's/sda/vda/g' kai/installer2.sh
sed -i 's/sdb/vdb/g' kai/installer1.sh
sed -i 's/sdb/vdb/g' kai/installer2.sh
