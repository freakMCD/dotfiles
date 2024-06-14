Download Arch Linux ISO
Create a live USB using "dd" command
Boot up Arch linux from the live USB

# Set the keyeboard layout
loadkeys es

# Check your Internet connection
ping -c 3 google.com

# Enable Network Time
timedatectl set-ntp true

# Partition the Disks

    To list all available disk drives:
        fdisk-l
    Partition the drive
        fdisk /dev/sdX
    Create an EFI partition at the beginning of the disk. 
        Type n and press Enter to create a new partition.     
    Change the EFI partition type from Linux filesystem to EFI system. 
        Type t and press Enter. Read whatever it says
    Create root partition

    To quit fdisk, type q and press Enter

# Create filesystem

    Use the mkfs command to create a FAT32 filesystem for the EFI partition
        mkfs.fat -F 32 /dev/sdX1
    Create an ext4 filesystem for the bootable partition
        mkfs.ext4 /dev/sdX2

# Install Arch Linux
    mount /dev/sdX2 /mnt
    pacstrap /mnt base linux linux-firmware neovim

# Configure Arch Linux

    Generate the fstab file
        genfstab -U /mnt >> /mnt/etc/fstab
    Use Arch-Chroot 
        arch-chroot /mnt
    Set the Time Zone
        ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime
    Set the locale

# Install Grub Bootloader
    
    pacman -S grub os-prober
    grub-install /dev/sdX
    grub-mkconfig -o /boot/grub/grub.cfg

# Create a New User and Set Up Privileges
    pacman -S sudo
    useradd -m edwin
    passwd edwin
    usermod -aG wheel,audio,video,storage edwin

    EDITOR=neovim visudo
        uncomment to allow members of group wheel to execute any command

# Exit Arch Chroot environment and Reboot
    
    exit
    umount -l /mnt
    sudo reboot








