#!/usr/bin/env bash

#---Configure location and language data
# set local time
echo 'Setting local time to Europe/London...' && ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime && hwclock --systohc
# install locales
sed -i \
    -e 's/#en_GB.UTF-8\ UTF-8/en_GB.UTF-8\ UTF-8/g' \
    -e 's/#en_GB\ ISO-8859-1/en_GB\ ISO-8859-1/g' \
    -e 's/#en_US.UTF-8\ UTF-8/en_US.UTF-8\ UTF-8/g' \
    -e 's/#en_US\ ISO-8859-1/en_US\ ISO-8859-1/g' \
    -e 's/#nb_NO.UTF-8\ UTF-8/nb_NO.UTF-8\ UTF-8/g' \
    -e 's/#nb_NO\ ISO-8859-1/nb_NO\ ISO-8859-1/g' \
    /etc/locale.gen && locale-gen && echo 'LANG=en_GB.UTF-8' > /etc/locale.conf
mv /10-keyboard.conf /etc/X11/xorg.conf.d/10-keyboard.conf

# Enable encryption build hook
echo 'Configuring mkinitcpio...'
sed -i "s/$(grep '^HOOKS' /etc/mkinitcpio.conf)/HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)/" /etc/mkinitcpio.conf
mkinitcpio -p linux

# Configure and install GRUB
echo 'Configuring and installing grub...'
sed -i -e "s@GRUB_CMDLINE_LINUX=\"\"@GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$(blkid -s UUID -o value /dev/sda2):cryptroot root=/dev/mapper/cryptroot\"@" \
    -e 's@#GRUB_ENABLE_CRYPTODISK=y@GRUB_ENABLE_CRYPTODISK=y@' /etc/default/grub
if [ "$HOST_NAME" = 'Ljosalfheim' ]; then
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB && grub-mkconfig -o /boot/grub/grub.cfg
    sed -i 's/LAYOUT/us/' /etc/X11/xorg.conf.d/10-keyboard.conf
    SWAP_COUNT=15260 # 16GB
    SWAP_DIR='/var/swapfile'
elif [ "$HOST_NAME" = 'Svartalfheim' ]; then
    grub-install --target=i386-pc /dev/sda && grub-mkconfig -o /boot/grub/grub.cfg
    sed -i 's/LAYOUT/gb/' /etc/X11/xorg.conf.d/10-keyboard.conf
    # generate keyfile
    echo 'Generating keyfile for home directory...'
    dd bs=512 count=4 if=/dev/random of=/etc/home-keyfile iflag=fullblock
    echo "$ENCRYPTION_PASS" | cryptsetup luksAddKey /dev/sdb /etc/home-keyfile
    echo 'crypthome /dev/sdb /etc/home-keyfile' >> /etc/crypttab
    chown -c root:root /etc/home-keyfile

    # enable FSTRIM
    echo 'Enabling periodic FSTRIM...'
    printf '#!/bin/sh\n# trim all mounted filesystems which support it\n/sbin/fstrim --all || true' > /etc/cron.weekly/fstrim
    chmod a+x /etc/cron.weekly/fstrim

    SWAP_DIR='/home' # use the home for swap because the root is on an SSD and that can decrease the SSD lifespan
    SWAP_COUNT=7630 # 8GB
fi

#---Create users and file structure
echo 'Creating users...'
useradd -m -G wheel "$USERNAME"
( echo "$USER_PASSWORD" ; echo "$USER_PASSWORD" ) | passwd -q "$USERNAME"
( echo "$ROOT_PASSWORD" ; echo "$ROOT_PASSWORD" ) | passwd -q
sed -i -e 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' -e 's/# %sudo ALL=(ALL:ALL) ALL/%sudo ALL=(ALL:ALL) ALL/' /etc/sudoers
# clear these variables so that nobody can read the passwords after the script finishes
export ROOT_PASSWORD=''
export USER_PASSWORD=''
export CONFIRM_ROOT_PASSWORD=''
export CONFIRM_USER_PASSWORD=''

#---Enable services
echo 'Enabling services...'
echo "$HOST_NAME" > /etc/hostname
printf '127.0.0.1 \t localhost\n::1 \t\t localhost\n127.0.1.1 \t %s.localdomain \t %s' "$HOST_NAME" "$HOST_NAME" >> /etc/hosts
ln -s /etc/runit/sv/connmand /etc/runit/runsvdir/default
# enable cronjobs
ln -s /etc/runit/sv/cronie /etc/runit/runsvdir/default
# enable syncthing
ln -s /etc/runit/sv/syncthing /etc/runit/runsvdir/default
# enable cupsd
ln -s /etc/runit/sv/cupsd /etc/runit/runsvdir/default

# generate a swapfile
echo 'Generating swapfile...'
dd if=/dev/zero of="$SWAP_DIR/swapfile" bs=1M count=$SWAP_COUNT status=progress && chmod 600 "$SWAP_DIR/swapfile"
mkswap "$SWAP_DIR/swapfile" && swapon "$SWAP_DIR/swapfile" && printf '\n# swapfile\n%s none swap defaults 0 0' "$SWAP_DIR/swapfile" >> /etc/fstab

post_installation (){
    echo
    sudo -u "$USERNAME" git clone https://github.com/koalagang/kai.git "/home/$USERNAME/kai"
    echo './kai/post-installer.sh' | su - "$USERNAME"
}

while true; do
    printf '\nThe base installation is complete.\nYou may start the post-installation within this environment.\nIt will occasionally require entering the root password.\n\n'
    read -p 'Do you wish to start the post-installation script? [Y/n] ' yn
    case "$yn" in
        [Yy]* ) post_installation ; break ;;
        [Nn]* ) break ;;
        '') post_installation ; break ;;
        * ) echo 'Please answer "yes" or "no".'
    esac
done

printf '\n\nInstallation complete! If you wish to reboot or shutdown, simply enter "loginctl reboot" or "loginctl poweroff" respectively.\n'

# delete this script from the root (as it was moved there before chrooting)
rm /installer2.sh
