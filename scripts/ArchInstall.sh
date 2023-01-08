N=$(tput sgr0)
red=$(tput setaf 1)

printf "Arch installer\n"
while true; do
	read -rp "Start installation? [y/n]: " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) printf "${red}Error: Write 'y' or 'n'\n${N}";;
		esac
done

echo "1/3 Enter root password: "
read -s ROOT_PASSWORD 
echo "2/3 Enter your username: "
read USER 
echo "3/3 Enter your password: "
read -s PASSWORD 

# ----------------------------------------------------------------------------------------------

echo "------------------------------------------"
echo "-- Format and mount the partitions 1/13 --"
echo "------------------------------------------"
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.btrfs -f /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot/efi

echo "----------------------------"
echo "-- INSTALLING kernel 2/13 --"
printf "${red}It will take a lot of time\n${N}"
echo "----------------------------"
pacstrap /mnt base linux-zen linux-zen-headers linux-firmware --noconfirm

echo "---------------------------"
echo "-- Fstab generation 3/13 --"
echo "---------------------------"
genfstab -U /mnt >> /mnt/etc/fstab

cat <<REALEND > /mnt/next.sh
N=$(tput sgr0)
red=$(tput setaf 1)

echo "-------------------------------"
echo "-- Pacman configuration 4/13 --"
echo "-------------------------------"
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sed -i "/Color/"'s/^#//' /etc/pacman.conf
sed -i "/ParallelDownloads/"'s/^#//' /etc/pacman.conf
sed -i -e '/Misc options/a ILoveCandy' /etc/pacman.conf
pacman -Syyu

echo "------------------------------"
echo "-- INSTALLING Packages 5/13 --"
printf "${red}It will take a lot of time\n${N}"
echo "------------------------------"
pacman -S base-devel --noconfirm
pacman -S btrfs-progs networkmanager neovim git ntp --noconfirm
pacman -S grub efibootmgr --noconfirm
pacman -S amd-ucode --noconfirm
pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader opencl-nvidia lib32-opencl-nvidia --noconfirm
pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-audio pipewire-jack --noconfirm

echo "----------------------------------"
echo "-- Enabling NetworkManager 6/13 --"
echo "----------------------------------"
systemctl enable NetworkManager

echo "---------------"
echo "-- GRUB 7/13 --"
echo "---------------"
grub-install /dev/nvme0n1
grub-mkconfig -o /boot/grub/grub.cfg

echo "----------------------------------"
echo "-- Hostname and hosts file 8/13 --"
echo "----------------------------------"
echo "SKIPC" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1	localhost
::1			localhost
127.0.1.1	SKIPC.localdomain	SKIPC
EOF

echo "------------------------"
echo "-- Adding a user 9/13 --"
echo "------------------------"
useradd -m $USER
usermod -aG wheel,docker,input $USER
echo $USER:$PASSWORD | chpasswd
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
echo "root:$ROOT_PASSWORD" | chpasswd

echo "---------------------------"
echo "-- Setup Languages 10/13 --"
echo "---------------------------"
sed -i "/en_US.UTF-8 UTF-8/"'s/^#//' /etc/locale.gen
sed -i "/ru_RU.UTF-8 UTF-8/"'s/^#//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "----------------"
echo "-- Time 11/13 --"
echo "----------------"
timedatectl set-timezone Asia/Yekaterinburg
systemctl enable ntpd
timedatectl set-ntp true

echo "------------------------------"
echo "-- NVIDIA and Modules 12/13 --"
echo "------------------------------"
sed -i "s|.*MODULES=(.*|MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm btrfs)|" /etc/mkinitcpio.conf
mkinitcpio -P
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia-drm.modeset=1"/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

echo "---------------------"
echo "-- Swap file 13/13 --"
echo "---------------------"
btrfs subvolume create /mnt/swap
btrfs filesystem mkswapfile --size 64g /mnt/swap/swapfile
chmod 0600 /mnt/swap/swapfile
mkswap -U clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile
echo "/mnt/swap/swapfile none swap defaults 0 0" >> /etc/fstab


echo "-------------------------------------------------"
echo ""
echo ""
echo ""
echo ""
printf "${red}Install Complete, You can reboot now"\n${N}"

rm /mnt/next.sh
REALEND


arch-chroot /mnt sh next.sh
