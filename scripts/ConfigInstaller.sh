# colors https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
N=$(tput sgr0)
cyan=$(tput setaf 5)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

read -r rows cols < <(stty size)
function new_action() {
	for ((i=1;i<=$cols;i++)); do printf "-"; done
  printf "\n"
  printf '%s+%s:%s\n' "${cyan}" "$1" "${N}"
  sleep 0.5
}

function install_paru {
if ! command -v paru &>/dev/null;
then
  cd $HOME
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

is_installed() {
  pacman -Qi $1 &> /dev/null
  return $?
}

function paru_install_packages() {
arr=("$@")
for paquete in "${arr[@]}"
do
  if ! is_installed $paquete; then
    paru -S $paquete --noconfirm
    printf "\n"
  else
    printf "${green}Paru: %s is already installed\n${N}" "$paquete"
    sleep 0.3
  fi
done
}

function terminal_plugins {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    printf "${green}Install ohmyzsh\n${N}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
  else
    printf "${green}ZSH Plugins: ohmyzsh is already installed\n${N}"
  fi

  if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    printf "${green}Install powerlevel10k\n${N}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  else
    printf "${green}ZSH Plugins: powerlevel10k is already installed\n${N}"
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    printf "${green}Install zsh-syntax-highlighting\n${N}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  else
    printf "${green}ZSH Plugins: zsh-syntax-highlighting is already installed\n${N}"
  fi

  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    printf "${green}Install zsh-autosuggestions\n${N}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  else
    printf "${green}ZSH Plugins: zsh-autosuggestions is already installed\n${N}"
  fi
}

function ranger_plugins {
  if [ ! -d "$HOME/.config/ranger/plugins/ranger_devicons" ]; then
    printf "${green}Install icons for ranger\n${N}"
    git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
    echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf
  else
    printf "${green}Ranger Plugins: icons is already installed\n${N}"
  fi

  if ! grep "set preview_images true" $HOME/.config/ranger/rc.conf > /dev/null
  then
    printf "${green}Ranger plugins: Set show images in ranger(only for kitty)\n${N}"
    paru_install_packages python-pillow
    echo "set preview_images true" >> $HOME/.config/ranger/rc.conf
    echo "set preview_images_method kitty" >> $HOME/.config/ranger/rc.conf
  else
    printf "${green}Ranger Plugins: images is already configured\n${N}"
  fi
}

function copy_config_files {
  [ -d ~/.config/bspwm ] && sudo rm -r $HOME/.config/bspwm 
  [ -d ~/.config/dunst ] && sudo rm -r $HOME/.config/dunst
  [ -d ~/.config/hypr ] && sudo rm -r $HOME/.config/hypr
  [ -d ~/.config/kitty ] && sudo rm -r $HOME/.config/kitty
  [ -d ~/.config/neofetch ] && sudo rm -r $HOME/.config/neofetch
  [ -d ~/.config/nitrogen ] && sudo rm -r $HOME/.config/nitrogen
  [ -d ~/.config/polybar ] && sudo rm -r $HOME/.config/polybar
  [ -d ~/.config/resources ] && sudo rm -r $HOME/.config/resources
  [ -d ~/.config/rofi ] && sudo rm -r $HOME/.config/rofi
  [ -d ~/.config/sxhkd ] && sudo rm -r $HOME/.config/sxhkd
  [ -d ~/.config/waybar ] && sudo rm -r $HOME/.config/waybar 
  cp -Rf $SCRIPT_DIR/../.config/* $HOME/.config/

  [ -d ~/.zshrc ] && sudo rm -r $HOME/.zshrc
  [ -d ~/.xinitrc ] && sudo rm -r $HOME/.xinitrc
  cp $SCRIPT_DIR/../.zshrc $HOME/
  cp $SCRIPT_DIR/../.xinitrc $HOME/
}

function keyboard_and_mouse_X11conf {
  [ -d /etc/X11/xorg.conf.d/00-keyboard.conf ] && sudo rm /etc/X11/xorg.conf.d/00-keyboard.conf
  [ -d /etc/X11/xorg.conf.d/50-mouse-acceleration.conf ] && sudo rm /etc/X11/xorg.conf.d/50-mouse-acceleration.conf

  sudo cp $SCRIPT_DIR/../00-keyboard.conf /etc/X11/xorg.conf.d/
  sudo cp $SCRIPT_DIR/../50-mouse-acceleration.conf /etc/X11/xorg.conf.d/
}

#==================================================================================

printf 'BSPWM config\n'
while true; do
	read -rp "Start installation? [y/n]: " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) printf "${red}Error: Write 'y' or 'n'\n${N}";;
		esac
done

new_action "Installing Paru"
install_paru

new_action "Installing fonts"
paru_install_packages ttf-jetbrains-mono-nerd ttf-apple-emoji ttf-material-design-icons-git

new_action "Installing packages"
paru_install_packages neofetch rofi-lbonn-wayland-git kitty zsh ranger dunst polkit-gnome p7zip ntfs-3g deluge-gtk network-manager-applet networkmanager-openvpn

new_action "Installing sound packages"
paru_install_packages pulseaudio pulseaudio-alsa alsa-utils alsa-oss

new_action "Installing BSPWM (and X11 packages)"
paru_install_packages xorg xorg-xinit bspwm sxhkd polybar nitrogen
keyboard_and_mouse_X11conf

new_action "Installing Hyprland (and wayland packages)"
paru_install_packages hyprland hyprpaper waybar-hyprland-git slurp grim wl-clipboard
#slurp grim wl-clipboard для скринов

new_action "Installing terminal plugins"
terminal_plugins
paru_install_packages cava typioca htop btop man

new_action "Installing soft"
paru_install_packages code code-icons telegram-desktop discord-canary steam chromium vlc figma-linux eam-git lutris gnome-multi-writer

new_action "Installing ranger plugins"
ranger_plugins

new_action "Installing grub theme"
sudo bash $SCRIPT_DIR/GrubThemeInstaller.sh

new_action "Copy dotfiles"
copy_config_files

new_action "For unreal engine"
paru_install_packages python-pip
pip3 install ue4cli

printf "${yellow}Installation completed!\n${N}"