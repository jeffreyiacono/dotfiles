#!/bin/bash
#
# Paul Rosania <http://paul.rosania.org>

# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------

test -z "$BASH_COMPLETION" && {
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    test -n "$PS1" && test $bmajor -gt 1 && {
        # search for a bash_completion file to source
        for f in /usr/local/etc/bash_completion \
                 /usr/pkg/etc/bash_completion \
                 /opt/local/etc/bash_completion \
                 /etc/bash_completion
        do
            test -f $f && {
                . $f
                break
            }
        done
    }
    unset bash bmajor bminor
}

# override and disable tilde expansion
_expand() { return 0; }
__expand_tilde_by_ref() { return 0; }

export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

export GIT_PS1_SHOWDIRTYSTATE=1

# terminal columns are worth something, dammit!
function __my_git_ps1 {
  if [ "x`type -t __git_ps1`" = "xfunction" ]; then
    local g=`__git_ps1 "(%s)" | tr -d " "`
    echo "${g:+ $g}"
  fi
}

export PS1='\u@\h:\w$(__my_git_ps1)\$ '
export PS2="> "
export PS4="+ "

export FLEX_HOME="/opt/flex3" # ($PATH depends on this)
alias fdb="rlwrap fdb" # life is better this way

export PATH="~/bin:/usr/local/bin:/usr/local/mysql/bin:/usr/local/share/npm/bin:$FLEX_HOME/bin:$PATH"
export NODE_PATH="/usr/local/lib/node"

alias ll="ls -l"
alias grep="grep -i --mmap --color=auto"

if which hub >/dev/null ; then alias git=hub ; fi

if [[ -s ~/.bashrc.local ]] ; then source ~/.bashrc.local ; fi

if which rbenv >/dev/null ; then eval "$(rbenv init -)" ; fi
