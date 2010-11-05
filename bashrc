#!/bin/bash
#
# Paul Rosania <http://paul.rosania.org>
export PATH="~/bin:/usr/local/bin:/usr/local/mysql/bin:/usr/local/share/npm/bin:$PATH"
export NODE_PATH="/usr/local/lib/node"

alias ll="ls -l"
alias git=hub

if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi
