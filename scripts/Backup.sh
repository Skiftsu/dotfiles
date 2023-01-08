# colors https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
N=$(tput sgr0)
red=$(tput setaf 1)
user_folder=$"/home/skiftsu"

function backup {
while true; do
	read -rp "Start backup files? [y/n]: " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) printf "${red}Error: Write 'y' or 'n'\n${N}";;
		esac
done

[ -d /mnt/hdd/backup ] && rm -r /mnt/hdd/backup
mkdir /mnt/hdd/backup

cp -r $user_folder/.config/chromium /mnt/hdd/backup

cp -r $user_folder/.ssh 			/mnt/hdd/backup
cp -r $user_folder/.password-store /mnt/hdd/backup
cp -r $user_folder/.gnupg 			/mnt/hdd/backup

cp -r $user_folder/Books 		/mnt/hdd/backup
cp -r $user_folder/Pictures 	/mnt/hdd/backup
cp -r $user_folder/Scripts 	/mnt/hdd/backup
cp -r $user_folder/Text 		/mnt/hdd/backup
cp -r $user_folder/Videos 		/mnt/hdd/backup
cp -r $user_folder/Курсы 		/mnt/hdd/backup
cp -r $user_folder/Other 		/mnt/hdd/backup

cp -r $user_folder/UnrealEngine/Projects /mnt/hdd/backup
exit
}

function restore {
while true; do
	read -rp "Start restore files? [y/n]: " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) printf "${red}Error: Write 'y' or 'n'\n${N}";;
		esac
done

[ -d $user_folder/.config/chromium ] && rm -r $user_folder/.config/chromium
[ -d $user_folder/.ssh ] && rm -r $user_folder/.ssh
[ -d $user_folder/.password-store ] && rm -r $user_folder/.password-store
[ -d $user_folder/.gnupg ] && rm -r $user_folder/.gnupg
[ -d $user_folder/Books ] && rm -r $user_folder/Books
[ -d $user_folder/Pictures ] && rm -r $user_folder/Pictures
[ -d $user_folder/Scripts ] && rm -r $user_folder/Scripts
[ -d $user_folder/Text ] && rm -r $user_folder/Text
[ -d $user_folder/Videos ] && rm -r $user_folder/Videos
[ -d $user_folder/Курсы ] && rm -r $user_folder/Курсы
[ -d $user_folder/Other ] && rm -r $user_folder/Other
[ -d $user_folder/UnrealEngine/Projects ] && rm -r $user_folder/UnrealEngine/Projects

cp -r /mnt/hdd/backup/chromium $user_folder/.config/

cp -r /mnt/hdd/backup/.ssh  $user_folder/
cp -r /mnt/hdd/backup/.password-store  $user_folder/
cp -r /mnt/hdd/backup/.gnupg  $user_folder/

cp -r /mnt/hdd/backup/Books  $user_folder/
cp -r /mnt/hdd/backup/Pictures  $user_folder/
cp -r /mnt/hdd/backup/Scripts  $user_folder/
cp -r /mnt/hdd/backup/Text  $user_folder/
cp -r /mnt/hdd/backup/Videos  $user_folder/
cp -r /mnt/hdd/backup/Курсы  $user_folder/
cp -r /mnt/hdd/backup/Other  $user_folder/

mkdir UnrealEngine
cp -r /mnt/hdd/backup/Projects  $user_folder/UnrealEngine/
exit
}

# ====================================================================================

if [ "$EUID" -ne 0 ]; then
  printf "${red}Use sudo to run the script\n${N}"
  exit
fi

umount /dev/sdb1
mount --mkdir /dev/sdb1 /mnt/hdd
while true; do
	read -rp "Backup[b] restore[r] exit[e]? [b/r/e]: " BREbre
		case $BREbre in
			[Bb]* ) backup;;
			[Rr]* ) restore;;
            [Ee]* ) exit;;
			* ) printf "${red}Error: Write 'b' or 'r'\n${N}";;
		esac
done