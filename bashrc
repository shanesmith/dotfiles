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
  ruby -e 'print Time.now.to_f.round(3).*(1000).to_i'
}

_start=$(now_ms)

export RC_INSTALL_DIR
RC_INSTALL_DIR=$(cd "$(dirname "$(readlink ~/.bashrc)")" && pwd)

[[ $- == *i* ]] && source "${RC_INSTALL_DIR}"/blesh/ble.sh --noattach

export GOPATH=$HOME/go
export NODE_PATH=$NODE_PATH:$HOME/.node/lib/node_modules

export PATH=$PATH:$HOME/.node/bin:$HOME/bin.local:$HOME/bin:$GOPATH/bin

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
elif [[ -e /usr/local/bin/brew ]]; then
  brew_prefix=/usr/local

  ## 0.8s
  # if brew list git >/dev/null 2>&1; then
  #   export PATH=$PATH:"$(brew --prefix git)/share/git-core/contrib/git-jump"
  # fi
fi

if [[ -x "${brew_prefix}/bin/brew" ]]; then
  # shellcheck source=/dev/null
   . <("${brew_prefix}/bin/brew" shellenv)
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

# LS colors
if command_exists dircolors; then
  eval "$(dircolors -b)"
else
  export CLICOLOR=1
fi

# MySQL prompt
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
command_exists lesspipe.sh && export LESSOPEN="|lesspipe.sh %s"

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

# export FZF_DEFAULT_OPTS="--bind 'ctrl-j:down,ctrl-k:up,alt-a:toggle-all,ctrl-h:reload:$FZF_DEFAULT_COMMAND_HIDDEN {q} || true'"
export FZF_DEFAULT_OPTS="--bind 'ctrl-j:down,ctrl-k:up,alt-a:toggle-all'"

# needs to come before setting PS1 for __git_ps1 check
if ! shopt -oq posix; then

  # source brew bash completion early to support other completions
  if [[ -f "${brew_prefix}/etc/profile.d/bash_completion.sh" ]]; then
    # shellcheck source=/dev/null
    . "${brew_prefix}/etc/profile.d/bash_completion.sh"
  elif [[ -f /usr/share/bash-completion/bash_completion ]]; then
    # shellcheck source=/dev/null
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    # shellcheck source=/dev/null
    . /etc/bash_completion
  fi

  for file in "${RC_INSTALL_DIR}"/completion/*; do
    # shellcheck source=/dev/null
    . "$file"
  done

  if command_exists gerrit; then
    # shellcheck source=/dev/null
    . <(gerrit completion)
  fi

  if command_exists ng; then
    # shellcheck source=/dev/null
    . <(ng completion script)
  fi

  if command_exists dev && [[ -e ~/.devrc ]]; then
    eval "$(dev _hook)"
    . <(dev completion bash)
  fi

  if command_exists terraform; then
    complete -C terraform terraform
  fi

  if command_exists git-lfs; then
    # shellcheck source=/dev/null
    . <(git-lfs completion bash)
  fi

fi

sources=()

if [[ -n $brew_prefix ]]; then
  sources+=(
    "${brew_prefix}/etc/profile.d"/[!bash_completion.sh]*
    "${brew_prefix}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
  )
fi

sources+=(
  "${HOME}/.bash_aliases"
  "${HOME}/.bashrc.d"/*
  "${HOME}/.bashrc.local"
  "${HOME}/.rvm/scripts/rvm"
  "${HOME}/.cargo/env"
  "${HOME}/Code/bash-sneak/sneak.bash"
)

for file in "${sources[@]}"; do
  if [ -f "$file" ]; then
    # shellcheck source=/dev/null
    . "$file"
  fi
done

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

[[ ${BLE_VERSION-} ]] && ble-attach
