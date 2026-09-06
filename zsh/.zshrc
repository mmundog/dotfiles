# Language / Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Prompt
autoload -U colors && colors

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
alias gs="git status"
alias ..="cd .."
alias reload="source ~/.zshrc"
alias ll="eza -lah --icons"
alias doctor="bash ~/dotfiles/doctor.sh"

# Extra

# Node.js (fnm)
if [[ -x "$HOME/.local/share/fnm/fnm" ]]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
fi

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{214}%b%f'
zstyle ':vcs_info:*' check-for-changes true

precmd() {
  vcs_info
}

setopt PROMPT_SUBST

PROMPT='%F{39}%1~%f${vcs_info_msg_0_} %F{250}❯%f '
