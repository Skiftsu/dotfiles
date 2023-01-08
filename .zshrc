# TMUX
if [[ -z "$TMUX" ]] && [[ $(pidof Hyprland) ]]; then
  tmux attach || tmux new-session -s "default"
fi

neofetch
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.emacs.d/bin:$PATH"

# Plugins =================================================
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# =========================================================

export EDITOR='nvim'
export VISUAL='nvim'

alias ps="sudo pacman -S --needed"
alias psa="paru -S --needed"
alias pr="sudo pacman -Rns"
alias pq="pacman -Q | grep"

alias cat="bat"
alias ls="lsd"
alias r="ranger"
alias v="nvim"
alias p="pass"
alias pi="pass insert"
alias d="docker"
alias t="tmux"
alias tc="tmux attach"

alias stable-diffusion="bash ~/StableDiffusion/webui.sh"
alias start="Hyprland"

# Include ue script
. ~/scripts/ue.sh
