N=$(tput sgr0)
green=$(tput setaf 2)
cyan=$(tput setaf 5)

is_installed() {
  pacman -Qi $1 &> /dev/null
  return $?
}

function install_packages() {
arr=("$@")
for pkg in "${arr[@]}"
do
  if ! is_installed $pkg; then
    paru -S $pkg --noconfirm
    printf "\n"
  else
    printf "${green}Paru: %s is already installed\n${N}" "$pkg"
    sleep 0.3
  fi
done
}

read -r rows cols < <(stty size)
function print_category() {
	for ((i=1;i<=$cols;i++)); do printf "-"; done
  printf "\n"
  printf '%s+%s:%s\n' "${cyan}" "$1" "${N}"
  sleep 0.5
}
#==================================================================================

print_category "Rust and Paru(AUR helper)"
# Rust https://rustup.rs/
bash curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

print_category "System"
# Filesystem utils
install_packages ntfs2btrfs exfat-utils
install_packages qt5-wayland qt5ct libva libva-nvidia-driver-git
install_packages hyprland hyprpaper waybar polkit-gnome
install_packages autofs darkman hyprshot
# Уведомления, меню, лаунчер
install_packages swaync eww-wayland rofi-lbonn-wayland

print_category "Soft"
# ЧтениеФайлов, PDF Rreader, торрент, image viewer, video viewer, file explorer, для работы с дисками
install_packages evince zathura qbittorrent eog kitty vlc nautilus gnome-disk-utility
install_packages telegram-desktop discord
install_packages lutris steam chromium obsidian
install_packages etcher-bin gimp 
install_packages pass qtpass
install_packages figma-linux obs-studio

print_category "Terminal"
# python-pillow - для Ranger 
install_packages python-pillow
install_packages zsh tk ranger man fzf
install_packages zfxtop btop htop
install_packages lazygit lazydocker
install_packages neofetch cava typioca
install_packages lsd bat
install_packages tmux tpm
install_packages clipboard
# Image in tmux
install_packages ueberzugpp

print_category "Fonts"
install_packages noto-fonts ttf-jetbrains-mono-nerd noto-fonts-cjk
# Twitter emoji, icons
install_packages ttf-twemoji ttf-material-design-icons-git

print_category "Dev"
# mb: code code-icons
install_packages vscodium-bin
# REST запросы
install_packages httpie filezilla
install_packages docker docker-compose
install_packages intellij-idea-community-edition
install_packages postgresql pgcli
