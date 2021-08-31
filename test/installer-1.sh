#!/usr/bin/env bash

# AUTHOR: koalagang (https://github.com/koalagang)
# A bash script to simplify the process of installing Artix Linux.

continue_prompt () {
    while true; do
        echo
        read -p 'Do you wish to continue? [Y/n] ' yn
        case "$yn" in
            [Yy]* ) break ;;
            [Nn]* ) exit 0 ;;
            '') break ;;
            * ) echo 'Please answer "yes" or "no".'
        esac
    done
    echo
}

clear
printf 'Welcome to KAI!\n\nThis script is mainly intended for my own personal use but it is also available here for those who want a quick Artix install or are lazy.\nIf at any point you wish to cancel then simply press ctrl+c.\n' ; continue_prompt
printf 'Also, please make sure that you have root privilidges before continuing. If you have not already done so then exit by saying no to the below prompt and then just type `su` and enter the password: `artix`\nAfter doing so, reinitiate the script.' ; continue_prompt
printf "So that you don't waste your time, I would like to say this right away: this script does not support dual-booting or MBR/BIOS systems (it may support these in the future but I'm not guaranteeing it) Also this script is for Artix runit (i.e. does not support OpenRC or s6; may support this in the future as well).\nAlso the default option for all the yes/no prompts like the one below is, as indicated by the capital Y, yes - this means that if you press return instead of inputing 'y' or 'n' then it will take your answer as a 'yes'." ; continue_prompt

printf "Because I originally made this mainly for my own personal use I've made some custom installers for myself. You should probably go and select the first option in the below prompt.\n"
select answer in 'Guided install (recommended)' "Koala's desktop install" "Koala's ThinkPad install"; do
    case "$answer" in
        'Guided install (recommended)') break ;;
        "Koala's desktop install") HOST='Alfheim' ; export HOST ; ./koala/koala-personal-installer-1.sh ; exit 0 ;;
        "Koala's ThinkPad install") HOST='Asgard' ; export HOST ; ./koala/koala-personal-installer-1.sh ; exit 0
    esac
done
echo

host () {
    read -p 'Enter your host name: ' HOST
    read -p 'Retype host name: ' CONFIRM_HOST
    until [ "$HOST" = "$CONFIRM_HOST" ]; do
        printf 'Host names did not match!\n'
        read -p 'Enter your host name: '  HOST
        read -p 'Retype host name: '  CONFIRM_HOST
    done
    echo
    echo "Your host name is $HOST." ; continue_prompt
    export HOST
    echo
}

username () {
    read -p 'Enter your username: '  USERNAME
    read -p 'Retype username: '  CONFIRM_USERNAME
    until [ "$USERNAME" = "$CONFIRM_USERNAME" ]; do
        printf 'Usernames did not match!\n'
        read -p 'Enter your username: '  USERNAME
        read -p 'Retype username: '  CONFIRM_USERNAME
    done
    echo
    echo "Your username is $USERNAME." ; continue_prompt
    export USERNAME
    echo
}

password () {
    read -s -p 'Enter your user password: ' PASSWORD
    read -s -p 'Re-enter your user password: ' CONFIRM_PASSWORD
    until [ "$PASSWORD" = "$CONFIRM_PASSWORD" ]; do
        printf 'Passwords did not match!\n'
        read -s -p 'Enter your user password: ' PASSWORD
        read -s -p 'Re-enter your user password: ' CONFIRM_PASSWORD
    done
    export PASSWORD
    echo

    read -s -p 'Enter your root password: ' ROOT_PASSWORD
    read -s -p 'Re-enter your root password: ' CONFIRM_ROOT_PASSWORD
    until [ "$ROOT_PASSWORD" = "$CONFIRM_ROOT_PASSWORD" ]; do
        printf 'Passwords did not match!\n'
        read -s -p 'Enter your root password: ' ROOT_PASSWORD
        read -s -p 'Re-enter your root password: ' CONFIRM_ROOT_PASSWORD
    done
    export ROOT_PASSWORD
    echo
}

city () {
    read -p 'Enter your city (formatted as continent/city, e.g. Europe/London): ' CITY
    read -p 'Re-enter your city (formatted as continent/city, e.g. Europe/London): ' CONFIRM_CITY
    until [ "$CITY" = "$CONFIRM_CITY" ]; do
        echo 'Cities did not match!'
        read -p 'Enter your city (formatted as continent/city, e.g. Europe/London): ' CITY
        read -p 'Re-enter your city (formatted as continent/city, e.g. Europe/London): ' CONFIRM_CITY
    done
    echo
    echo "Your city is $CITY." ; continue_prompt
    export CITY
    echo
}

lang () {
    read -p 'Enter your language and region (formatted as language_region, e.g. en_GB): ' LANGUAGE
    read -p 'Re-nter your language and region (formatted as language_region, e.g. en_GB): ' CONFIRM_LANGUAGE
    until [ "$LANGUAGE" = "$CONFIRM_LANGUAGE" ]; do
        echo 'Languages did not match!'
        read -p 'Enter your language and region (formatted as language_region, e.g. en_GB): ' LANGUAGE
        read -p 'Re-nter your language and region (formatted as language_region, e.g. en_GB): ' CONFIRM_LANGUAGE
    done
    echo
    echo "Your language is $LANGUAGE." ; continue_prompt
    export LANGUAGE
    echo

    while true; do
        echo
        echo 'It is recommended that you enable en_US in addition to any other languages because some applications only support enUS.'
        read -p 'Would you like to add additional languages? [Y/n] ' yn
        case "$yn" in
            [Yy]* ) read -p 'How many extra languages would you like to add? ' lang_num ; break ;;
            [Nn]* ) break ;;
            '') read -p 'How many extra languages would you like to add? ' lang_num ;;
            * ) echo 'Please answer "yes" or "no".'
        esac
    done
    echo

    [ -n "$lang_num" ] &&
        orig_lang_num="$lang_num" ; export orig_lang_num
        until [ "$lang_num" -eq 1 ]; do
            read -p 'Enter your language and region (formatted as language_region, e.g. en_GB): ' EXTRA_LANGUAGE"$lang_num"
            read -p 'Re-nter your language and region (formatted as language_region, e.g. en_GB): ' EXTRA_CONFIRM_LANGUAGE"$lang_num"
            until [ $EXTRA_LANGUAGE"$lang_num" = $EXTRA_CONFIRM_LANGUAGE"$lang_num" ]; do
                echo 'Languages did not match!'
                read -p 'Enter your language and region (formatted as language_region, e.g. en_GB): ' EXTRA_LANGUAGE"$lang_num"
                read -p 'Re-nter your language and region (formatted as language_region, e.g. en_GB): ' EXTRA_CONFIRM_LANGUAGE"$lang_num"
            done
            echo
            echo "Your extra language is $EXTRA_LANGUAGE"$lang_num"." ; continue_prompt ; export EXTRA_LANGUAGE"$lang_num" ; $((lang_num - 1))
            echo
        done
}

kernel () {
    echo 'Which kernel would you like to use?'
    select answer in 'linux' 'linux-lts' 'linux-zen' 'linux-hardened'; do
        case "$answer" in
            'linux') KERNEL='linux' ; break ;;
            'linux-ltd') KERNEL='linux-lts' ; break ;;
            'linux-zen') KERNEL='linux-zen' ; break ;;
            'linux-hardened') KERNEL='linux-hardened' ; break
        esac
    done
    echo "Your kernel is $KERNEL." ; continue_prompt
    export KERNEL
    echo
}

host ; username ; password ; city ; lang ; kernel

# Check if all the information is correct
which_wrong () {
    echo 'Which field is wrong?'
    select answer in 'Host' 'Username' 'City' 'Language' 'Kernel' "I changed my mind. They're all correct."; do
        case "$answer" in
            'Host') host ; check_correct ; break ;;
            'Username') username ; check_correct ; break ;;
            'City') city ; check_correct ; break ;;
            'Language') lang ; check_correct ; break ;;
            'Kernel') kernel ; check_correct ; break ;;
            "I changed my mind. They're all correct.") check_correct ; break
        esac
    done
    continue_prompt ; echo
}

check_correct () {
    printf "HOST: $HOST\nUSERNAME: $USERNAME\nCITY: $CITY\nMAIN LANGUAGE: $LANGUAGE\nKERNEL: $KERNEL\n"
    while true; do
        read -p 'Is this correct? [Y/n] ' yn
        case "$yn" in
            [Yy]* ) break ;;
            [Nn]* ) which_wrong ;;
            '') break ;;
            * ) echo 'Please answer "yes" or "no".'
        esac
    done
    echo
}
check_correct

encrypt () {
    read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS
    read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS
    until [ "$ENCRYPTION_PASS" = "$CONFIRM_ENCRYPTION_PASS" ]; do
        printf 'Encryption keys did not match!\n'
        read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS
        read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS
    done
    echo "THE CONTENTS OF $DEVICE IS ABOUT TO BE DELETED. YOU WILL LOSE ALL DATA ON $DEVICE AND THERE WILL BE NO GOING BACK!" ; continue_prompt
    echo "Wiping $DEVICE..." && sfdisk --delete "$DEVICE" && echo "$DEVICE successfully wiped."
    echo "Partitioning $DEVICE..." && printf 'n\n\n\n+128M\nn\n\n\n\nw' | fdisk "$DEVICE" && echo "Successfully partitioned $DEVICE."
    echo "Encrypting $DEVICE..." && echo "$ENCRYPTION_PASS" | cryptsetup luksFormat "$DEVICE"2 -q --force-password &&
        cryptsetup open "$DEVICE"2 cryptlvm &&
        pvcreate /dev/mapper/cryptlvm &&
        vgcreate encrypted_volumes &&
        vgcreate encrypted_volumes /dev/mapper/cryptlvm &&
        lvcreate -L 30G encrypted_volumes -n root &&
        lvcreate -L 100%FREE encrypted_volumes -n home &&
        encryption_success=1
    [ "$encryption_success" -eq 1 ] && echo "Successfully encrypted $DEVICE."
    [ "$encryption_success" -ne 1 ] && echo "error: failed to encrypt $DEVICE." && exit 0
    echo "Formatting $DEVICE..." &&
        mkfs.ext4 /dev/encrypted_volumes/root -L root && mkfs.ext4 /dev/encrypted_volumes/home -L home && mkfs.fat -F32 "$DEVICE"1 && format_success=1
    [ "$format_success" -eq 1 ] && echo "Successfully formatted $DEVICE."
    [ "$format_sucess" -ne 1 ] && echo "error: failed to format $DEVICE." && exit 0
    echo "Mounting $DEVICE..." && mount "$DEVICE"2 /mnt && mkdir /mnt/boot && mount "$DEVICE"1 /mnt/boot && mount_succcess=1
    [ "$mount_success" -eq 1 ] && "Successfully mounted $DEVICE."
    [ "$mount_success" -ne 1 ] && "error: failed to mount $DEVICE." && exit 0
}

printf '\nWhen it comes to partitioning, we are going for 128M for the bootloader, 30G for the root and the rest of the free space should go towards the home partition. There is no need for a swap partition because swap files are far superior. You can see the currently existing paritions above.\n\nWARNING: you are responsible for any loss of data.\nFor this reason, I cannot stress it enough that you should backup anything you wish to keep before continuing!\n' ; continue_prompt
echo 'Do you wish to encrypt the drive?'
partition_format_encrypt_mount () {
    lsblk
    read -p 'Enter the name of the device you wish to install Artix on? (e.g. /dev/sda, /dev/sdb, etc) ' DEVICE
    while true; do
        echo
        echo 'It is recommended that you enable en_US in addition to any other languages because some applications only support enUS.'
        read -p 'Would you like to encrypt your drive? [Y/n] ' yn
        case "$yn" in
            [Yy]* ) encrypt ; break ;;
            [Nn]* ) echo "THE CONTENTS OF $DEVICE IS ABOUT TO BE DELETED. YOU WILL LOSE ALL DATA ON $DEVICE AND THERE WILL BE NO GOING BACK!" ; continue_prompt
                sfdisk --delete "$DEVICE"
                printf 'n\n\n\n+128M\nn\n\n\n+1G\nn\n\n\n\nw' | fdisk "$DEVICE"
                mkfs.fat -F32 "$DEVICE"1 -n boot
                mkfs.ext4 "$DEVICE"2 -L root
                mkfs.ext4 "$DEVICE"3 -L home
                mount "$DEVICE"2 /mnt
                mkdir -p /mnt/boot ; mkdir -p /mnt/home
                mount "$DEVICE"1 /mnt/boot ; mount "$DEVICE"3 /mnt/home
                break ;;
            '') encrypt ; break ;;
            * ) echo 'Please answer "yes" or "no".'
        esac
    done
    echo
}

swap_yes () {
    echo 'The recommended swap size is the size of your RAM +1GB.' ; read -p 'Enter swap size: ' SWAP_SIZE
    echo "Creating $SWAP_SIZE swapfile..." && dd if=/dev/zero of=/swapfile bs=1M count=$SWAPS_SIZE status=progress &&
        chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && echo '/swapfile none swap defaults 0 0' >> /etc/fstab && swap_success=1
    [ "$swap_success" -eq 1 ] && echo "Successfully created a $SWAP_SIZE swapfile."
    [ "$swap_success" -ne 1 ] && echo 'error: failed to create swap.' && exit 0
}

swap () {
    while true; do
        echo
        read -p 'Would you like to create a swap partition? [Y/n] ' yn
        case "$yn" in
            [Yy]* ) swap_yes ; break ;;
            [Nn]* ) break ;;
            '') swap_yes ; break ;;
            * ) echo 'Please answer "yes" or "no".'
        esac
    done
    echo
}

what_next () {
    printf 'Last question! Would you like to reboot or shutdown your machine once complete or just do nothing and leave the system on?'
    select answer in 'Reboot' 'Shutdown' 'Do nothing'; do
        case "$answer" in
            'Reboot') reboot=1 ; break ;;
            'Shutdown') shutdown=1 ; break ;;
            'Do nothing') break
        esac
    done
    echo
}

partition_format_encrypt_mount ; swap ; what_next

basestrap /mnt base base-devel runit elogind-runit "$KERNEL" "$KERNEL"-headers linux-firmware --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
artix-chroot /mnt ./installer-2.sh
