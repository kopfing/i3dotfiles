#!/bin/sh

#set -e
echo 
echo "----- Install Arch Linux ARM on block device and configure Wifi -----"
echo "====================================================================="
echo 
echo "Usage: $0 </dev/disk> <ssid> <passphase>"
echo 
echo 

if [[ $# -ne 3 ]] ; then
   exit 1
fi

#zuweisung der Variablen
DISK="$1"
if [[ "${1}" == *"mm"* ]]; then
    MNTDEV="${1}p"
else
    MNTDEV="$1"
fi
SSID="$2"
PASS="$3"

if [[ ! -b "${DISK}" ]] ; then
   echo "Not a block device: ${DISK}"
   exit 1
fi

if [[ "$(whoami)" != "root" ]] ; then
   echo "Must run as root."
   exit 1
fi

echo "Unmounting device if mounted..."
umount "${MNTDEV}?" > /dev/null 2>&1

echo "Partitioning block device..."
(
echo o # Create a new empty DOS partition table
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo +100M # 100 MB boot partition
echo t # Set the type of first partition
echo c # to W95 FAT32 (LBA)
echo n # new partition
echo p # primary partition
echo 2 # partition number 2
echo   # default, start immediately after preceding partition
echo   # default, rest of the space for root partition
echo w # Write changes
) | fdisk "${DISK}" > /dev/null 2>&1

# reload the partition table
partprobe

echo "Creating filesystems..."
# Create FAT filesystem
mkfs.vfat "${MNTDEV}1" > /dev/null
# Create ext4 filesystem
mkfs.ext4 -F "${MNTDEV}2" > /dev/null

echo "Creating folder structure..."
if [ ! -d "root" ]; then
    mkdir root
fi
if [ ! -d "boot" ]; then
    mkdir boot
fi
if [ "$(ls -A root)" ]; then
    echo "root folder not empty!"
    exit 1
fi
if [ "$(ls -A boot)" ]; then
    echo "boot folder not empty!"
    exit 1
fi

echo "Mounting filesystems..."
mount "${MNTDEV}1" boot
mount "${MNTDEV}2" root
echo 

if [ ! -e "ArchLinuxARM-rpi-2-latest.tar.gz" ]; then
    echo "Downloading alarm..."
    wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
fi

echo "Installing alarm..."
bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
mv root/boot/* boot
sync

echo 
echo "Configuring Wifi..."
cat << EOF >> root/etc/systemd/network/wlan0.network
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF

wpa_passphrase "${SSID}" "${PASS}" > root/etc/wpa_supplicant/wpa_supplicant-wlan0.conf

ln -s \
   /usr/lib/systemd/system/wpa_supplicant@.service \
   root/etc/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service

echo Unmounting...
umount root
umount boot
echo Cleaning up...
rmdir root
rmdir boot
