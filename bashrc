#!/bin/bash

# ----------------------------------------------------------------------
# PLATFORM DETECTION
# ----------------------------------------------------------------------

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
  platform='freebsd'
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='darwin'
fi

# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------

test -z "$BASH_COMPLETION" && {
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    test -n "$PS1" && test $bmajor -gt 1 && {
        # search for a bash_completion file to source
        for f in /usr/local/etc/bash_completion \
                 /usr/local/etc/bash_completion.d/* \
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

export GREP_OPTIONS='-i -n --color=auto' GREP_COLOR='1;32'
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

export GIT_PS1_SHOWDIRTYSTATE=1

export PS1='\u@\h:\w$(__git_ps1)\$ '
export PS2="> "
export PS4="+ "
export PROMPT_DIRTRIM=2

if command -v vim > /dev/null 2>&1; then
  export EDITOR=vim

  # if vim is available, always use it
  alias vi=vim
else
  export EDITOR=vi
fi

export PATH="$HOME/bin:$PATH"

if [[ $platform == 'linux' ]] ; then alias ls="ls --color=auto" ; fi
alias ll="ls -l"
alias be="bundle exec"

if which hub >/dev/null ; then alias git=hub ; fi

if [[ -s ~/.bashrc.local ]] ; then source ~/.bashrc.local ; fi

if type -P rbenv >/dev/null ; then eval "$(rbenv init -)" ; fi
