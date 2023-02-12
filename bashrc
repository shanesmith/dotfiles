#!/bin/bash

# https://mdjnewman.me/2017/10/debugging-slow-bash-startup-files/
# exec 5> >(ts -i "%.s" >> /tmp/timestamps)
#
# # https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
# export BASH_XTRACEFD="5"
#
# # Enable tracing
# set -x

now_ms() {
  if command -v gdate >/dev/null; then
    gdate +%s%3N
  else
    date +%s%3N
  fi
}

_start=$(now_ms)

export GOPATH=$HOME/go
export NODE_PATH=$NODE_PATH:$HOME/.node/lib/node_modules

export PATH=$PATH:$HOME/.node/bin:$HOME/bin.local:$HOME/bin:$GOPATH/bin

export RC_INSTALL_DIR
RC_INSTALL_DIR=$(cd "$(dirname "$(readlink ~/.bashrc)")" && pwd)

export DEV_SPIN_ALLOW_UP=1

command_exists() {
  command -v "$1" >/dev/null
}

if [[ -x /usr/libexec/java_home ]]; then
  # macOS only?
  export JAVA_HOME
  JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
fi

if [[ $(uname -m) == 'arm64' && -e /opt/homebrew/bin/brew ]]; then
  brew_prefix=/opt/homebrew
  export PATH=/opt/homebrew/bin:$PATH
elif [[ -e /usr/local/bin/brew ]]; then
  brew_prefix=/usr/local

  ## 0.8s
  # if brew list git >/dev/null 2>&1; then
  #   export PATH=$PATH:"$(brew --prefix git)/share/git-core/contrib/git-jump"
  # fi
fi

if [[ -n $brew_prefix && -d $brew_prefix/opt/nvm ]]; then
  export NVM_DIR=~/.nvm
  . "${brew_prefix}/opt/nvm/nvm.sh"
fi

# If not running interactively, stop here
[ -z "$PS1" ] && return

# set shell options
shopt -s histappend cdspell checkwinsize dirspell direxpand autocd globstar no_empty_cmd_completion

# set default editor
if command_exists nvim; then
  export EDITOR=nvim
  export GIT_EDITOR=nvim # override git config core.editor
else
  export EDITOR=vim
fi

# Some additional evironment variables
export CLICOLOR=1
export MYSQL_PS1="mysql://\u@\h \d> "

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTTIMEFORMAT="%F %T> "

# default options for less
export LESS="-SRi"

# make less more friendly for non-text input files, see lesspipe(1)
$(which lesspipe >/dev/null) && eval "$(lesspipe)"
$(which lesspipe.sh >/dev/null) && eval "$(lesspipe.sh)"

## thefuck
## 0.11s
# $(which thefuck >/dev/null) && eval $(thefuck --alias)

if command_exists fd; then
  export FZF_DEFAULT_COMMAND='fd --type f --follow --strip-cwd-prefix'
  export FZF_DEFAULT_COMMAND_HIDDEN="${FZF_DEFAULT_COMMAND} --hidden"
elif command_exists rg; then
  export FZF_DEFAULT_COMMAND='rg --files -g ""'
elif command_exists ag; then
  export FZF_DEFAULT_COMMAND='ag -g ""'
fi

export FZF_DEFAULT_OPTS="--bind 'ctrl-j:down,ctrl-k:up,alt-a:toggle-all,ctrl-h:reload:$FZF_DEFAULT_COMMAND_HIDDEN {q} || true'"

# needs to come before setting PS1 for __git_ps1 check
if ! shopt -oq posix; then

  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [[ -n $brew_prefix && -f $brew_prefix/etc/bash_completion ]]; then
    . "${brew_prefix}/etc/bash_completion"
  fi

  for file in "${RC_INSTALL_DIR}"/completion/*; do
    . "$file"
  done

  if command_exists gerrit; then
    . <(gerrit completion)
  fi

fi

sources=(
  "/opt/dev/dev.sh"
  "${HOME}/.bash_aliases"
  "${HOME}/.bash_ps1"
  "${HOME}/.bash_sshauth"
  "${HOME}/.bash_help"
  "${HOME}/.bash_readline"
  "${HOME}/.bashrc.local"
  "${HOME}/.rvm/scripts/rvm"
  "${HOME}/.cargo/env"
  "${HOME}/Code/bash-sneak/sneak.bash"
)

if [[ -n $brew_prefix ]]; then
  sources+=("${brew_prefix}/etc/profile.d/z.sh")
fi

for file in "${sources[@]}"; do
  if [ -f "$file" ]; then
    . "$file"
  fi
done

# Enforced by dev
[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }
[[ -x $brew_prefix/bin/brew ]] && eval $($brew_prefix/bin/brew shellenv)

## Satisfy dev checks
# [[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
# [[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)

if [[ -n $SUITUP ]]; then
  unset SUITUP
  tmux setenv -gu SUITUP
  suitup
fi

echo "startup: " $(( $(now_ms) - _start ))

unset -f stamp now_ms
unset _start

# start with a happy :)
true
