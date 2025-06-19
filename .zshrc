# ================================================================================
# ZSH CONFIGURATION
# ================================================================================

# --------------------------------------------------------------------------------
# PROMPT & THEME CONFIGURATION
# --------------------------------------------------------------------------------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# source ~/zsh_plugins/powerlevel10k/powerlevel10k.zsh-theme

# --------------------------------------------------------------------------------
# HISTORY CONFIGURATION
# --------------------------------------------------------------------------------

# Configs for command history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt share_history  
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
# setopt hist_ignore_space

# --------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES & PATH SETUP
# --------------------------------------------------------------------------------

# Source .profile for universal PATH settings
[[ -f ~/.profile ]] && source ~/.profile

# pnpm
export PNPM_HOME="/home/lpvinh/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# --------------------------------------------------------------------------------
# PACKAGE MANAGER SETUP
# --------------------------------------------------------------------------------

# Replace your current NVM setup with this lazy-loading version
export NVM_DIR="$HOME/.nvm"

# Lazy load nvm
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
}

# Lazy load npm
npm() {
    unset -f npm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm "$@"
}

# Lazy load node
node() {
    unset -f node
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    node "$@"
}

# --------------------------------------------------------------------------------
# ALIASES
# --------------------------------------------------------------------------------

# System & Docker aliases
alias start-docker="sudo systemctl start docker"
alias kill-docker="sudo systemctl stop docker.socket && sudo systemctl stop docker"
alias lazydocker='sudo lazydocker'
alias docker='sudo docker'
alias docker-compose='sudo docker compose'

# System utilities
alias rm='rm --preserve-root' 
alias ls='eza --icons=always --color=always --long --git --no-filesize --no-user --no-time --no-permissions'
alias dir='eza --icons=always --color=always --long --git --no-filesize --no-permissions'
alias restart-zsh="source ~/.zshrc"
alias drop-caches="sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'"
alias update-cursor="./Applications/cursor/update-cursor.sh"
alias mirror-android="scrcpy --no-audio &"
alias dnf='sudo dnf'

# Git aliases
alias g='git'
alias ga='git add'
alias gc='git commit -m'
alias gs='git status'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gco='git checkout'

# Navigation aliases
# Better cd
alias cd='z'
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

# --------------------------------------------------------------------------------
# FUNCTIONS
# --------------------------------------------------------------------------------

# ADB port forwarding function
adb-reverse() {
    if [ -z "$1" ]; then
        echo "Usage: adb_reverse <port_number>"
        echo "Example: adb_reverse 4000"
        return 1
    fi
    adb reverse tcp:$1 tcp:$1
}

# Set Manual/Auto Fan Speed
set-fan() {
    if [ -z "$1" ]; then
        echo "Usage: set-fan <fan_level (auto, 0 -> 7)>"
        echo "Example: set-fan 6"
        return 1
    fi 
    echo level $1 | sudo tee /proc/acpi/ibm/fan
}

# --------------------------------------------------------------------------------
# KEY BINDINGS
# --------------------------------------------------------------------------------

bindkey "^[[3~" delete-char

# Home and End keys
bindkey "^[[H" beginning-of-line    # Home key
bindkey "^[OH" beginning-of-line    # Home key (alternative)
bindkey "^[[F" end-of-line          # End key
bindkey "^[OF" end-of-line          # End key (alternative)

# Word deletion
bindkey "^[[3;5~" delete-word       # Ctrl+Delete (delete word forward)
bindkey "^H" backward-delete-word   # Ctrl+Backspace (delete word backward)

# History cycling
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# --------------------------------------------------------------------------------
# PLUGINS & INITIALIZATION
# --------------------------------------------------------------------------------

eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.json)"
eval "$(fzf --zsh)"

autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no

source ~/zsh_plugins/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'

source ~/zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/zsh_plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
