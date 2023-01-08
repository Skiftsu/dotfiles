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

is_installed() {
  pacman -Qi $1 &> /dev/null
  return $?
}

function install_packages() {
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

##############################################

while true; do
	read -rp "Start installation? [y/n]: " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) printf "${red}Error: Write 'y' or 'n'\n${N}";;
		esac
done

sudo pacman-key --init               # Инициализация
sudo pacman-key --populate archlinux # Получить ключи из репозитория
sudo pacman-key --refresh-keys       # Проверить текущие ключи на актуальность
sudo pacman -Sy                      # Обновить ключи для всей системы

# Утилита Reflector отсортирует доступные зеркала по скорости
install_packages reflector rsync curl
sudo reflector --verbose --country 'Germany' -l 25 --sort rate --save /etc/pacman.d/mirrorlist

# Ananicy — это демон для распределения приоритета задач, его установка сильно повышает отклик системы.
install_packages ananicy
sudo systemctl enable --now ananicy

# Haveged — это демон, что следит на энтропией системы. Необходим для ускорения запуска системы при высоких показателях_ systemd-analyze blame_ (Больше 1 секунды).
install_packages haveged
sudo systemctl enable haveged

# Включаем TRIM — очень полезно для SSD.
sudo systemctl enable fstrim.timer
sudo fstrim -va

# Dbus-broker — это реализация шины сообщений в соответствии со спецификацией D-Bus. Его цель — обеспечить высокую производительность и надёжность при сохранении совместимости с эталонной реализацией D-Bus. Быстрее будет общение с видеокартой через PCI-E.
install_packages dbus-broker
sudo systemctl enable --now dbus-broker.service

sudo systemctl mask NetworkManager-wait-online.service