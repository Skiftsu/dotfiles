SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo rm -r $SCRIPT_DIR/../.config
mkdir $SCRIPT_DIR/../.config
cp -Rf $HOME/.config/hypr $SCRIPT_DIR/../.config/
cp -Rf $HOME/.config/eww $SCRIPT_DIR/../.config/
cp -Rf $HOME/.config/kitty $SCRIPT_DIR/../.config/
cp -Rf $HOME/.config/neofetch $SCRIPT_DIR/../.config/
cp -Rf $HOME/.config/rofi $SCRIPT_DIR/../.config/
cp -Rf $HOME/.config/waybar $SCRIPT_DIR/../.config/
cp -Rf $HOME/.config/zathura $SCRIPT_DIR/../.config/
cp -Rf $HOME/.config/ranger $SCRIPT_DIR/../.config/
cp -Rf $HOME/.config/nvim $SCRIPT_DIR/../.config/


mkdir $SCRIPT_DIR/../.config/other
cp -Rf $HOME/scripts $SCRIPT_DIR/../.config/other/
cp -Rf $HOME/.config/Code/User/settings.json $SCRIPT_DIR/../.config/other/

rm $SCRIPT_DIR/../.zshrc
cp $HOME/.config/code-flags.conf $SCRIPT_DIR/../.config

rm $SCRIPT_DIR/../.zshrc
cp $HOME/.zshrc $SCRIPT_DIR/../

rm $SCRIPT_DIR/../.tmux.conf
cp $HOME/.tmux.conf $SCRIPT_DIR/../
