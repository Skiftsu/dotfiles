N=$(tput sgr0)
green=$(tput setaf 2)

if grep "GRUB_THEME=/usr/share/grub/themes/tartarus/theme.txt" /etc/default/grub >/dev/null; then
printf "${green}Grub theme is already installed 1\n${N}"
exit
fi


if grep "GRUB_THEME=" /etc/default/grub >/dev/null; then
    sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=/usr/share/grub/themes/tartarus/theme.txt|" /etc/default/grub
else
    echo "GRUB_THEME=/usr/share/grub/themes/tartarus/theme.txt" >> /etc/default/grub
fi

if [ ! -d "/usr/share/grub/themes/tartarus" ]; then
   cd $HOME
   git clone https://github.com/AllJavi/tartarus-grub.git
   cd tartarus-grub
   cp tartarus -r /usr/share/grub/themes/
   grub-mkconfig -o /boot/grub/grub.cfg
   rm -rf tartarus-grub
   printf "${green}Grub theme has been installed\n${N}"
 else
   printf "${green}Grub theme is already installed 2\n${N}"
 fi