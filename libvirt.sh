#!/bin/sh
sed -i -e 's/sda/vda/g' -e 's/sda/vda/g' kai/installer2.sh
sed -i -e 's/sdb/vdb/g' -e 's/sdb/vdb/g' -e '/# generate a swapfile/,+3d' kai/installer2.sh

./kai/installer1.sh
