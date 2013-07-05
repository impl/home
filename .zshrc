# Terminfo/termcap are awful
export TERMINFO="${HOME}/.terminfo"

# Encoding
export LANG="en_US.UTF-8"

# oh-my-zsh configuration
# This variable (ZSH) is actually required, as unlikely as it might seem
ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${HOME}/.oh-my-zsh-custom"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=( git virtualenv-prompt )
source "${ZSH}/oh-my-zsh.sh"

# We load our theme manually because the current script doesn't pull it out of
# the custom directory like it should
source "${ZSH_CUSTOM}/themes/impl.zsh-theme"
