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

function install_paru {
printf "${cyan}+Installing Paru:\n${N}"
if ! command -v paru &>/dev/null;
then
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si
	cd $HOME
	rm -rf paru
  printf "${green}Paru has been installed\n${N}"
else
	printf "${green}Paru is already installed on your system\n${N}"
fi
sleep 0.5
}

# Софт для установки с aur
new_action "Install paru"
install_paru

paru -S nvidia-tweaks --noconfirm