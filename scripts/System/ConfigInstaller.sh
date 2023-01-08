SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

[ -d ~/.config/hypr ] &&      sudo rm -r $HOME/.config/hypr
[ -d ~/.config/darkman ] &&   sudo rm -r $HOME/.config/darkman
[ -d ~/.config/eww ] &&       sudo rm -r $HOME/.config/eww
[ -d ~/.config/kitty ] &&     sudo rm -r $HOME/.config/kitty
[ -d ~/.config/neofetch ] &&  sudo rm -r $HOME/.config/neofetch
[ -d ~/.config/rofi ] &&      sudo rm -r $HOME/.config/rofi
[ -d ~/.config/waybar ] &&    sudo rm -r $HOME/.config/waybar
[ -d ~/.config/zathura ] &&   sudo rm -r $HOME/.config/zathura
[ -d ~/.config/ranger ] &&    sudo rm -r $HOME/.config/ranger 
cp -Rf $SCRIPT_DIR/../../.config/* $HOME/.config/

[ -d ~/.zshrc ] && sudo rm $HOME/.zshrc
cp $SCRIPT_DIR/../../.zshrc $HOME/

[ -d ~/.tmux.conf ] && sudo rm $HOME/.tmux.conf
cp $SCRIPT_DIR/../../.tmux.conf $HOME/
