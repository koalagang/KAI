#!/usr/bin/env bash

echo 'Setting local time to Europe/London...' && ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime && hwclock --systohc

sed -i "s/#en_GB.UTF-8\ UTF-8/en_GB.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#en_GB\ ISO-8859-1/en_GB\ ISO-8859-1/g" /etc/locale.gen
sed -i "s/#en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#en_US\ ISO-8859-1/en_US\ ISO-8859-1/g" /etc/locale.gen
sed -i "s/#nb_NO.UTF-8\ UTF-8/nb_NO.UTF-8\ UTF-8/g" /etc/locale.gen
sed -i "s/#nb_NO\ ISO-8859-1/nb_NO\ ISO-8859-1/g" /etc/locale.gen
locale-gen
echo 'LANG=en_GB.UTF-8' > /etc/locale.conf

echo 'Configuring mkinitcpio...'
sed -i "s/$(grep '^HOOKS' /etc/mkinitcpio.conf)/HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)/" /etc/mkinitcpio.conf
mkinitcpio -p linux

echo 'Configuring and installing grub...'
sed -i -e "s@GRUB_CMDLINE_LINUX=\"\"@GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$(blkid -s UUID -o value /dev/sda2):cryptroot root=/dev/mapper/cryptroot\"@" \
    -e 's@#GRUB_ENABLE_CRYPTODISK=y@GRUB_ENABLE_CRYPTODISK=y@' /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB && grub-mkconfig -o /boot/grub/grub.cfg

echo 'Enabling connman...'
echo "$HOST_NAME" > /etc/hostname
printf '127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t %s.localdomain \t %s' "$HOST_NAME" "$HOST_NAME" > /etc/hosts
ln -s /etc/runit/sv/connmand /etc/runit/runsvdir/default

echo 'Creating users...'
useradd -m -G wheel "$USERNAME"
( echo "$USER_PASSWORD" ; echo "$USER_PASSWORD" ) | passwd -q "$USERNAME"
sed -i -e 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' -e 's/# %sudo ALL=(ALL:ALL) ALL/%sudo ALL=(ALL:ALL) ALL/' /etc/sudoers
( echo "$ROOT_PASSWORD" ; echo "$ROOT_PASSWORD" ) | passwd -q
# clear these variables so that nobody can read the passwords after the script finishes
export ROOT_PASSWORD=''
export USER_PASSWORD=''
export CONFIRM_ROOT_PASSWORD=''
export CONFIRM_USER_PASSWORD=''
# create the file structures for the home
sudo -u "$USERNAME" 'xdg-user-dirs-update'
rm -r "/home/$USERNAME/Public" "/home/$USERNAME/Templates"
sed -i -e '/XDG_TEMPLATES_DIR/d' -e '/XDG_PUBLICSHARE_DIR/d' "/home/$USERNAME/.config/user-dirs.dirs"
mkdir -p "/home/$USERNAME/.local/share"
mkdir -p "/home/$USERNAME/.local/bin"

if [ "$HOST_NAME" = 'Asgard' ]; then
    # generate keyfile
    echo 'Generating keyfile for home directory...'
    dd bs=512 count=4 if=/dev/random of=/var/home-keyfile iflag=fullblock
    chmod 400 /var/home-keyfile
    echo "$ENCRYPTION_PASS" | cryptsetup luksAddKey /dev/sdb /var/home-keyfile
    echo 'crypthome /dev/sdb /var/home-keyfile' >> /etc/crypttab

    # enable FSTRIM
    echo 'Enabling periodic FSTRIM...'
    printf '#!/bin/sh\n# trim all mounted file systems which support it\n/sbin/fstrim --all || true' > /etc/cron.weekly/fstrim
    chmod a+x /etc/cron.weekly/fstrim

    SWAP_COUNT=7630 # 8GB
    SWAP_DIR="/home/$USERNAME/.local/share" # use the home for swap because the root is on an SSD
elif [ "$HOST_NAME" = 'Alfheim' ]; then
    SWAP_COUNT=15260 # 16GB
    SWAP_DIR='/var/swapfile'
fi

# generate a swapfile
echo 'Generating swapfile...'
cp /etc/fstab /etc/fstab.bak
dd if=/dev/zero of="$SWAP_DIR" bs=1M count=$SWAP_COUNT status=progress && chmod 600 "$SWAP_DIR"
mkswap "$SWAP_DIR" && swapon "$SWAP_DIR" && printf '\n# swapfile\n%s none swap defaults 0 0' "$SWAP_DIR" >> /etc/fstab

sudo -u "$USERNAME" git clone https://github.com/koalagang/kai.git "/home/$USERNAME/kai"

printf '\n\nInstallation complete! If you wish to reboot or shutdown, simply enter "loginctl reboot" or "loginctl poweroff" respectively.\n'
echo 'KAI has been cloned into your home directory so that you can install extra packages using paru without being root.'
rm /installer2.sh
