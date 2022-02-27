#!/bin/sh
pacman -S glibc vim --noconfirm
sed -i 's/sda/vda/g' kai/installer1.sh
sed -i 's/sda/vda/g' kai/installer2.sh
sed -i 's/sdb/vdb/g' kai/installer1.sh
sed -i 's/sdb/vdb/g' kai/installer2.sh

sed '@
# generate a swapfile
echo 'Generating swapfile...'
dd if=/dev/zero of="$SWAP_DIR/swapfile" bs=1M count=$SWAP_COUNT status=progress && chmod 600 "$SWAP_DIR/swapfile"
mkswap "$SWAP_DIR/swapfile" && swapon "$SWAP_DIR/swapfile" && printf '\n# swapfile\n%s none swap defaults 0 0' "$SWAP_DIR/swapfile" >> /etc/fstab@d
'

./kai/installer1.sh
