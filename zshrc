# Set custom prompt
setopt PROMPT_SUBST
autoload -U promptinit
promptinit
prompt ptr

# Initialize completion
autoload -U compinit
compinit -D

# Add paths
export PATH="$HOME/bin:$PATH"

# Colorize terminal
alias ls='ls -G'
alias ll='ls -lG'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

# Nicer history
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

# Use vim as the editor ...
export EDITOR=vi
# ... but use emacs mode on the command line
bindkey -e

# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'

if which hub >/dev/null ; then alias git=hub ; fi

if [[ -s ~/.zshrc.local ]] ; then source ~/.zshrc.local ; fi

if which rbenv >/dev/null ; then eval "$(rbenv init -)" ; fi
