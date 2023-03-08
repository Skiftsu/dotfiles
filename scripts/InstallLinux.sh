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

printf "Arch installer\n"
while true; do
	read -rp "Start installation? [y/n]: " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) printf "${red}Error: Write 'y' or 'n'\n${N}";;
		esac
done

new_action "Formatting Partitions"
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.btrfs -f /dev/nvme0n1p2

new_action "Mounting Partitions"
mount /dev/nvme0n1p2 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/efi

new_action "Installing the kernel and other packages"
pacstrap -i /mnt base linux-zen linux-firmware linux-zen-headers amd-ucode btrfs-progs --noconfirm

new_action "arch-chroot"
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# После выхода
umount -R /mnt

printf "${yellow}Installation completed! Reboot pls!\n${N}"