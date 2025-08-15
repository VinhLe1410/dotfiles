# Source .profile for universal PATH settings
[[ -f ~/.profile ]] && source ~/.profile

# ASDF shim path
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Zinit Initialization
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Oh My Posh Theming for ZSH
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.json)"

# Delete key, opposite to Backspace
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

# System & Docker aliases
alias start-docker="sudo systemctl start docker"
alias kill-docker="sudo systemctl stop docker.socket && sudo systemctl stop docker"
alias lazydocker='sudo lazydocker'
# alias docker='sudo docker'
# alias docker-compose='sudo docker compose'

# System utilities
alias rm='rm --preserve-root' 
alias ls='eza --icons=always --color=always --no-filesize --no-user --no-time --no-permissions'
alias dir='eza --icons=always --color=always --long --git --no-filesize'
alias restart-zsh="source ~/.zshrc"
alias update-cursor="./Applications/cursor/update-cursor.sh"
alias drop-caches="sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'"
alias dnf='sudo dnf'

# Navigation aliases
alias home='cd ~'

# fzf alias
alias fzf='fzf --height 40% --layout reverse --border'

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

# Zinit Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found
zinit snippet OMZP::docker

# Load Completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons=always --color=always --long --no-user --no-permissions $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --icons=always --color=always --long --no-user --no-permissions $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
# pnpm
export PNPM_HOME="/home/lpvinh/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
