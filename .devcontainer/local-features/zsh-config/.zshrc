export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 13

DISABLE_MAGIC_FUNCTIONS="true"

HIST_STAMPS="yyyy-mm-dd"

plugins=(git docker kubectl minikube fluxcd)

source $ZSH/oh-my-zsh.sh

source /usr/local/share/copy-kube-config.sh

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh