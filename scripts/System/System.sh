# Enable OS PROBER in grub
file_path="/etc/default/grub"
sed -i 's/GRUB_DISABLE_OS_PROBER=true/GRUB_DISABLE_OS_PROBER=false/g' "$file_path"
sed -i '/#GRUB_DISABLE_OS_PROBER=false/s/^#//' "$file_path"

grub-mkconfig -o /boot/grub/grub.cfg
