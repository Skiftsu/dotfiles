#!/usr/bin/env bash

N=$(tput sgr0)
cyan=$(tput setaf 5)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)

read -r rows cols < <(stty size)
function new_action() {
	for ((i=1;i<=$cols;i++)); do printf "-"; done
  printf "\n"
  printf '%s+%s:%s\n' "${cyan}" "$1" "${N}"
  sleep 0.5
}

is_installed() {
  pacman -Qi $1 &> /dev/null
  return $?
}

function pacman_install_packages() {
arr=("$@")
for paquete in "${arr[@]}"
do
  if ! is_installed $paquete; then
    sudo pacman -S $paquete --noconfirm
    printf "\n"
  else
    printf "${green}Pacman: %s is already installed\n${N}" "$paquete"
    sleep 0.3
  fi
done
}

function os_language {
if ! grep "LANG=" /etc/locale.conf >/dev/null; then
printf "${green}OS language set\n${N}"
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
fi
}

###########################################################################################

printf "Arch installer\n"
while true; do
	read -rp "Start installation? [y/n]: " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) printf "${red}Error: Write 'y' or 'n'\n${N}";;
		esac
done


new_action "Stage 1"

# Форматирование разделов
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.btrfs -f /dev/nvme0n1p2

# Монтирование разделов
mount /dev/nvme0n1p2 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/efi

# Установка ядра и других нужных пакетов
pacstrap -i /mnt base linux-zen linux-firmware linux-zen-headers amd-ucode btrfs-progs

# Вход в систему
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt


new_action "Stage 2"

# Включение возможности устанавливаеть 32 битные пакеты
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Установка нужных пакетов
pacman_install_packages base-devel neovim git networkmanager grub efibootmgr
systemctl enable NetworkManager

new_action "Localization"
sed -i "/en_US.UTF-8 UTF-8/"'s/^#//' /etc/locale.gen
sed -i "/ru_RU.UTF-8 UTF-8/"'s/^#//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Настройка времени
new_action "Time"
timedatectl set-timezone Asia/Yekaterinburg
pacman_install_packages ntp
systemctl enable ntpd


# Настройка для видеокарт nvidia
new_action "Install nvidia packages"
pacman_install_packages nvidia-dkms nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader opencl-nvidia lib32-opencl-nvidia libxnvctrl
sed -i "s|.*MODULES=(.*|MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm crc32c libcrc32c zlib_deflate btrfs)|" /etc/mkinitcpio.conf
mkinitcpio -P

touch /etc/hostname
echo "SKIPC" >> /etc/hostname
echo "127.0.0.1 localhost::1\nlocalhost127.0.0.1\nSKIPC.localdomain SKIPC" >> /etc/hosts

printf "Root password:\n"
passwd

new_action "Swap file"
btrfs subvolume create /swap
btrfs filesystem mkswapfile --size 64g /swap/swapfile
chmod 0600 /swap/swapfile
mkswap -U clear /swap/swapfile
swapon /swap/swapfile
echo "/swap/swapfile none swap defaults 0 0" >> /etc/fstab

# Настройка grub
grub-install /dev/nvme0n1
grub-mkconfig -o /boot/grub/grub.cfg

new_action "Add user"
# Включание группы wheel для выполнения sudo
sed -i "/%wheel ALL=(ALL:ALL) ALL/"'s/^#//' /etc/sudoers
useradd -m -g users -G wheel -s /bin/bash skiftsu
printf "User password:\n"
passwd skiftsu

# Завершение установки
exit
umount -R /mnt

printf "${yellow}Installation completed!\n${N}"

while true; do
	read -rp "Reboot? [y/n]: " yn
		case $yn in
			[Yy]* ) reboot;;
			[Nn]* ) exit;;
			* ) printf "${red}Error: Write 'y' or 'n'\n${N}";;
		esac
done
