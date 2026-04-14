# Source secrets (tokens, keys) from a restricted file
[[ -f ~/.secrets ]] && source ~/.secrets
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="/Users/lpvinh/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="nicoulaj"

plugins=(
    git
    asdf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

alias ls='lsd --group-dirs first'
alias l='lsd -l --group-dirs first'
alias la='lsd -a --group-dirs first'
alias lla='lsd -la --group-dirs first'
alias lt='lsd --tree --group-dirs first'

eval "$(zoxide init zsh --cmd cd)"