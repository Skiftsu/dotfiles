N=$(tput sgr0)
green=$(tput setaf 2)

# Terminal Plugins =============================================================================================================
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