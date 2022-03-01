#!/bin/sh
sed -i 's/sda/vda/g' kai/installer1.sh
sed -i 's/sda/vda/g' kai/installer2.sh
sed -i 's/sdb/vdb/g' kai/installer1.sh
sed -i 's/sdb/vdb/g' kai/installer2.sh
sed -i '/# generate a swapfile/,+3d' kai/installer2.sh

./kai/installer1.sh
