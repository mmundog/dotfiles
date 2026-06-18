# Language / Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Prompt
PROMPT='%1~ ❯ '

# History
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

# Completion
autoload -Uz compinit
compinit

# Aliases
alias ll="ls -lah"
alias gs="git status"
alias ..="cd .."
alias cls="clear"
alias dotfiles="cd ~/dotfiles"
