# colors https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
N=$(tput sgr0)
cyan=$(tput setaf 5)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)

read -r rows cols < <(stty size)
function new_action() {
	for ((i=1;i<=$cols;i++)); do printf "="; done
  printf "\n"
  printf '%s+%s:%s\n' "${yellow}" "$1" "${N}"
  sleep 0.5
}

new_action "1/4 Installing packages"
bash $SCRIPT_DIR/System/Packages.sh

new_action "2/4 Installing configs"
bash $SCRIPT_DIR/System/ConfigInstaller.sh

new_action "3/4 Terminal setup"
bash $SCRIPT_DIR/System/TerminalSetup.sh

new_action "4/4 Installing grub theme"
sudo bash $SCRIPT_DIR/System/GrubTheme.sh

sudo usermod -aG wheel,docker,input $USER
printf "${yellow}Installation completed!\n${N}"
