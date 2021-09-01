# Aliases
alias ls='ls -G' # colored directories for the ls command

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Something to do with the prompt theme functionality
fpath=($fpath "/Users/eric/.zfunctions")

# Set the prompt theme to typewritten: https://github.com/reobin/typewritten
# With my preferences configured
autoload -U promptinit; promptinit
prompt typewritten
export TYPEWRITTEN_PROMPT_LAYOUT="pure"
export TYPEWRITTEN_CURSOR="block"

# https://github.com/zsh-users/zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
export TERM=xterm-256color # Fixes autosuggestion color along with manually setting ANSI black bright to a light gray

# https://github.com/zsh-users/zsh-syntax-highlighting
# Must be at the end of .zshrc
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

