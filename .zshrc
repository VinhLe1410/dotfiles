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
alias docker="sudo docker"
alias start-docker="sudo systemctl start docker"
alias kill-docker="sudo systemctl stop docker.socket && sudo systemctl stop docker"
alias lazydocker='sudo lazydocker'

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
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

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

# HELP-PROFILE: Display all custom commands, aliases, and keybinds
HELP-PROFILE() {
    echo "\n🚀 \033[1;36mPersonal Profile Help\033[0m 🚀\n"
    
    echo "\033[1;33m📋 ALIASES\033[0m"
    echo "├─ \033[1;32mDocker & System:\033[0m"
    echo "│  ├─ docker          → sudo docker"
    echo "│  ├─ start-docker    → sudo systemctl start docker"
    echo "│  ├─ kill-docker     → stop docker socket & service"
    echo "│  └─ lazydocker      → sudo lazydocker"
    echo "│"
    echo "├─ \033[1;32mSystem Utilities:\033[0m"
    echo "│  ├─ rm              → rm --preserve-root"
    echo "│  ├─ ls              → eza with icons & colors"
    echo "│  ├─ dir             → eza long format with git info"
    echo "│  ├─ restart-zsh     → source ~/.zshrc"
    echo "│  ├─ update-cursor   → run cursor update script"
    echo "│  ├─ drop-caches     → clear system caches"
    echo "│  └─ dnf             → sudo dnf"
    echo "│"
    echo "├─ \033[1;32mNavigation:\033[0m"
    echo "│  ├─ home            → cd ~"
    echo "│  ├─ ..              → cd .."
    echo "│  ├─ ...             → cd ../.."
    echo "│  └─ ....            → cd ../../.."
    echo "│"
    echo "└─ \033[1;32mTools:\033[0m"
    echo "   └─ fzf             → fzf with custom layout\n"
    
    echo "\033[1;33m⚡ CUSTOM FUNCTIONS\033[0m"
    echo "├─ \033[1;35madb-reverse <port>\033[0m    → ADB port forwarding"
    echo "│  └─ Example: adb-reverse 4000"
    echo "│"
    echo "├─ \033[1;35mset-fan <level>\033[0m       → Set ThinkPad fan speed"
    echo "│  └─ Example: set-fan 6 (auto, 0-7)"
    echo "│"
    echo "└─ \033[1;35mHELP-PROFILE\033[0m          → Show this help (you're here!)\n"
    
    echo "\033[1;33m⌨️  KITTY KEYBINDS\033[0m"
    echo "├─ \033[1;32mTabs & Windows:\033[0m"
    echo "│  ├─ Alt+T           → New tab (in current directory)"
    echo "│  ├─ Alt+D           → Previous tab"
    echo "│  ├─ Alt+F           → Next tab"
    echo "│  ├─ Alt+J           → Previous window"
    echo "│  └─ Alt+L           → Next window"
    echo "│"
    echo "├─ \033[1;32mClipboard:\033[0m"
    echo "│  ├─ Ctrl+Shift+C    → Copy to clipboard"
    echo "│  └─ Ctrl+V          → Paste from clipboard"
    echo "│"
    echo "└─ \033[1;32mConfig:\033[0m"
    echo "   ├─ F5              → Reload kitty config"
    echo "   └─ F12             → Edit kitty config\n"
    
    echo "\033[1;33m🔧 SHELL INTEGRATIONS\033[0m"
    echo "├─ \033[1;36mfzf\033[0m                   → Fuzzy finder (Ctrl+R for history)"
    echo "├─ \033[1;36mzoxide\033[0m                → Smart cd replacement"
    echo "├─ \033[1;36moh-my-posh\033[0m            → Custom prompt theme"
    echo "└─ \033[1;36mzinit plugins\033[0m         → syntax highlighting, completions, suggestions\n"
    
    echo "\033[1;90m💡 Tip: Type any command name for usage info\033[0m"
    echo "\033[1;90m📁 Config files: ~/.zshrc, ~/.config/kitty/kitty.conf\033[0m\n"
}

# Startup welcome message

echo "\033[1;33mType\033[0m \033[1;32mHELP-PROFILE\033[0m \033[1;33mto learn more\033[0m"
