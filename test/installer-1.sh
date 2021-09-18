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
printf 'Please make sure that you have root privilidges before continuing. If you have not already done so then exit by saying no to the below prompt and then just type `su`.\nAfter doing so, reinitiate the script.\n' ; continue_prompt
printf "So that you don't waste your time, I would like to say this right away: this script does not support dual-booting or MBR/BIOS systems (it may support these in the future but I'm not guaranteeing it). Also this script is for Artix runit (i.e. does not support OpenRC or s6; may support this in the future as well).\n\nThe default option for all the yes/no prompts like the one below is, as indicated by the capital Y, yes - this means that if you press return instead of inputing 'y' or 'n' then it will take your answer as a 'yes'.\n" ; continue_prompt

printf "Because I originally made this mainly for my own personal use, I've made some custom installers for myself. You should probably go and select the first option in the below prompt.\n"
select answer in 'Guided install (recommended)' "Koala's desktop install" "Koala's ThinkPad install"; do
    case "$answer" in
        'Guided install (recommended)') break ;;
        "Koala's desktop install") HOST='Alfheim' ; export HOST ; ./koala-personal/koala-personal-installer-1.sh ; exit 0 ;;
        "Koala's ThinkPad install") HOST='Asgard' ; export HOST ; ./koala-personal/koala-personal-installer-1.sh ; exit 0
    esac
done
echo

host () {
    read -p 'Enter your host name: ' HOST
    read -p 'Retype host name: ' CONFIRM_HOST
    until [ "$HOST" = "$CONFIRM_HOST" ]; do
        echo 'Host names did not match!'
        read -p 'Enter your host name: '  HOST
        read -p 'Retype host name: '  CONFIRM_HOST
    done
    echo
    echo "Your host name is $HOST." ; continue_prompt
    export HOST
}

username () {
    echo 'Your username can only contain letters and numbers, all the letters must be lowercase and the first character must be a letter.'
    read -p 'Enter your username: '  USERNAME
    read -p 'Re-type username: '  CONFIRM_USERNAME
    until [ "$USERNAME" = "$CONFIRM_USERNAME" ]; do
        echo 'Usernames did not match!'
        read -p 'Enter your username: '  USERNAME
        read -p 'Re-type username: '  CONFIRM_USERNAME
    done
    until [[ ${USERNAME:0:1} != "1" ]]; do
        echo 'Username cannot start with a number!'
        read -p 'Enter your username: '  USERNAME
        read -p 'Re-type username: '  CONFIRM_USERNAME
    done
    USERNAME="$(echo $USERNAME | tr '[:upper:]' '[:lower:]')"
    echo
    echo "Your username is $USERNAME." ; continue_prompt
    export USERNAME
}

password () {
    read -s -p 'Enter your user password: ' PASSWORD ; echo
    read -s -p 'Re-enter your user password: ' CONFIRM_PASSWORD ; echo
    until [ "$PASSWORD" = "$CONFIRM_PASSWORD" ]; do
        echo ; echo
        echo 'Passwords did not match!'
        read -s -p 'Enter your user password: ' PASSWORD ; echo
        read -s -p 'Re-enter your user password: ' CONFIRM_PASSWORD ; echo
    done
    USER_PASSWORD="$PASSWORD"
    export USER_PASSWORD

    echo
    read -s -p 'Enter your root password: ' ROOT_PASSWORD ; echo
    read -s -p 'Re-enter your root password: ' CONFIRM_ROOT_PASSWORD ; echo
    until [ "$ROOT_PASSWORD" = "$CONFIRM_ROOT_PASSWORD" ]; do
        echo ; echo
        echo 'Passwords did not match!'
        read -s -p 'Enter your root password: ' ROOT_PASSWORD ; echo
        read -s -p 'Re-enter your root password: ' CONFIRM_ROOT_PASSWORD ; echo
    done
    export ROOT_PASSWORD
}

city () {
    echo
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
}

lang () {
    read -p 'Enter your language and region (formatted as language_region, e.g. en_GB): ' LANGUAGE
    read -p 'Re-enter your language and region (formatted as language_region, e.g. en_GB): ' CONFIRM_LANGUAGE
    until [ "$LANGUAGE" = "$CONFIRM_LANGUAGE" ]; do
        echo 'Languages did not match!'
        read -p 'Enter your language and region (formatted as language_region, e.g. en_GB): ' LANGUAGE
        read -p 'Re-enter your language and region (formatted as language_region, e.g. en_GB): ' CONFIRM_LANGUAGE
    done
    echo
    echo "Your language is $LANGUAGE." ; continue_prompt
    export LANGUAGE

#    while true; do
#        echo 'It is recommended that you enable en_US in addition to any other languages because some applications only support en_US.'
#        read -p 'Would you like to add additional languages? [Y/n] ' yn
#        case "$yn" in
#            [Yy]* ) read -p 'How many extra languages would you like to add? ' lang_num
#                # ensure that the input is an integer
#                until [ "$lang_num" -eq "$lang_num" 2>/dev/null ]; do
#                    echo 'That is not an integer!'
#                    read -p 'How many extra languages would you like to add? ' lang_num
#                done
#                break ;;
#            [Nn]* ) break ;;
#            '') read -p 'How many extra languages would you like to add? ' lang_num ; break ;;
#            * ) echo 'Please answer "yes" or "no".'
#        esac
#    done
#
#    langs=($(seq 1 5 | xargs -I% -n 1 echo '%'))
#    echo ; echo "The below prompt will repeat $lang_num times so that you can enter every language."
#    [ -n "$lang_num" ] &&
#        for i in "${langs[@]}"; do
#            read -p 'Enter your language and region (formatted as language_region, e.g. en_GB): ' EXTRA_LANGUAGE$i
#            read -p 'Re-enter your language and region (formatted as language_region, e.g. en_GB): ' CONFIRM_"${langs[i]}"
#            echo
#            until [ "${langs[i]}" = $CONFIRM_"${langs[i]}" ]; do
#                echo 'Languages did not match!'
#                read -p 'Enter your language and region (formatted as language_region, e.g. en_GB): ' "${langs[i]}"
#                read -p 'Re-enter your language and region (formatted as language_region, e.g. en_GB): ' "${langs[i]}"
#            done
#            export "${langs[i]}"
#        done
#        export lang_num
}

kernel () {
    printf '\nWhich kernel would you like to use?\nlinux-lts is recommended for users of the Nvidia proprietary drivers.\n'
    select answer in 'linux' 'linux-lts' 'linux-zen' 'linux-hardened'; do
        case "$answer" in
            'linux') KERNEL='linux' ; break ;;
            'linux-lts') KERNEL='linux-lts' ; break ;;
            'linux-zen') KERNEL='linux-zen' ; break ;;
            'linux-hardened') KERNEL='linux-hardened' ; break
        esac
    done
    echo
    echo "Your kernel is $KERNEL." ; continue_prompt
    export KERNEL
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
    continue_prompt
}

check_correct () {
    printf "\nHOST: $HOST\nUSERNAME: $USERNAME\nCITY: $CITY\nMAIN LANGUAGE: $LANGUAGE\nKERNEL: $KERNEL\n\n"
    while true; do
        read -p 'Is this correct? [Y/n] ' yn
        case "$yn" in
            [Yy]* ) break ;;
            [Nn]* ) which_wrong ;;
            '') break ;;
            * ) echo 'Please answer "yes" or "no".'
        esac
    done
}
check_correct

encrypt () {
    echo
    read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS ; echo
    read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS ; echo
    until [ "$ENCRYPTION_PASS" = "$CONFIRM_ENCRYPTION_PASS" ]; do
        echo 'Encryption keys did not match!'
        read -s -p 'Enter your encryption key: ' ENCRYPTION_PASS ; echo
        read -s -p 'Re-enter your encryption key: ' CONFIRM_ENCRYPTION_PASS ; echo
    done
    echo
    echo "THE CONTENTS OF $DEVICE IS ABOUT TO BE DELETED. YOU WILL LOSE ALL DATA ON $DEVICE AND THERE WILL BE NO GOING BACK!" ; continue_prompt
    echo "Partitioning $DEVICE..." && printf 'o\nn\np\n1\n\n+128M\nn\np\n2\n\n\nw' | fdisk "$DEVICE" && echo "Successfully partitioned $DEVICE."
    echo "Encrypting $DEVICE..." && echo "$ENCRYPTION_PASS" | cryptsetup luksFormat -q --force-password --type luks1 "$DEVICE"2 &&
        echo "$ENCRYPTION_PASS" | cryptsetup open "$DEVICE"2 cryptlvm &&
        pvcreate /dev/mapper/cryptlvm &&
        vgcreate lvmSystem /dev/mapper/cryptlvm &&
        lvcreate -l 100%FREE lvmSystem -n root && encryption_success=1
    if [ -n "$encryption_success" ]; then
        echo "Successfully encrypted $DEVICE."
    else
        echo "error: failed to encrypt $DEVICE" && exit 0
    fi

    echo "Formatting $DEVICE..." &&
        mkfs.ext4 /dev/lvmSystem/root -L root && mkfs.fat -F32 "$DEVICE"1 && format_success=1
    if [ -n "$format_success" ]; then
        echo "Successfully formatted $DEVICE."
    else
        echo "error: failed to format $DEVICE" && exit 0
    fi

    echo "Mounting $DEVICE..." && mount /dev/lvmSystem/root /mnt &&
        mkdir -p /mnt/boot && mount "$DEVICE"1 /mnt/boot && mount_success=1
    if [ -n "$mount_success" ]; then
        echo "Successfully mounted $DEVICE."
    else
        echo "error: failed to mount $DEVICE" && exit 0
    fi

    encrypt=1 && export encrypt && export DEVICE
}

printf '\nWhen it comes to partitioning, we are going for 128M for the bootloader and the rest will be allocated to the root. There is no need for a swap partition because swap files are far superior. You can see the currently existing paritions above.\n\nWARNING: you are responsible for any loss of data.\nFor this reason, I cannot stress it enough that you should backup anything you wish to keep before continuing!\n' ; continue_prompt
partition_format_encrypt_mount () {
    lsblk
    read -p 'Enter the name of the device you wish to install Artix on? (e.g. /dev/sda, /dev/sdb, etc): ' DEVICE
    while true; do
        echo
        read -p 'Would you like to encrypt your drive? [Y/n] ' yn
        case "$yn" in
            [Yy]* ) encrypt ; break ;;
            [Nn]* ) echo "THE CONTENTS OF $DEVICE IS ABOUT TO BE DELETED. YOU WILL LOSE ALL DATA ON $DEVICE AND THERE WILL BE NO GOING BACK!" ; continue_prompt
                printf 'o\nn\np\n1\n\n+128M\nn\np\n2\n\n\nw' | fdisk "$DEVICE"
                mkfs.fat -F32 "$DEVICE"1 -n boot
                mkfs.ext4 "$DEVICE"2 -L root
                mount "$DEVICE"2 /mnt
                mkdir -p /mnt/boot
                mount "$DEVICE"1 /mnt/boot
                break ;;
            '') encrypt ; break ;;
            * ) echo 'Please answer "yes" or "no".'
        esac
    done
    echo
}

swap () {
    while true; do
        read -p 'Would you like to create a swap file? [Y/n] ' yn
        case "$yn" in
            [Yy]* ) SWAP=1 ; break ;;
            [Nn]* ) break ;;
            '') SWAP=1 ; break ;;
            * ) echo 'Please answer "yes" or "no".'
        esac
    done
    [ -n "$SWAP" ] && export SWAP
    echo
}

partition_format_encrypt_mount ; swap

printf '\nStarting Artix Linux installation.' && sleep 1 && printf '.' && sleep 1 && printf '.' && sleep 1 && printf ' NOW!\n' && sleep 0.5

basestrap /mnt base base-devel runit elogind-runit "$KERNEL" "$KERNEL"-headers linux-firmware --noconfirm
fstabgen -U /mnt >> /mnt/etc/fstab
mv installer-2.sh /mnt && artix-chroot /mnt ./installer-2.sh
