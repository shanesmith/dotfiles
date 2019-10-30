export NODE_PATH=$NODE_PATH:$HOME/.node/lib/node_modules

export PATH=$PATH:$HOME/.node/bin:$HOME/bin.local:$HOME/bin

command_exists() {
  command -v $1 >/dev/null
}

if [[ -n "$(ls -A /Library/Java/JavaVirtualMachines 2>/dev/null)" ]]; then
  # macOS only?
  export JAVA_HOME=$($(dirname $(readlink $(which javac)))/java_home)
fi

if command_exists brew && [ -d $(brew --prefix)/opt/nvm ]; then
  export NVM_DIR=~/.nvm
  . $(brew --prefix)/opt/nvm/nvm.sh
fi

if command_exists docker-machine; then
  eval "$(docker-machine env 2>/dev/null)"
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

# default options for less
export LESS="-SRi"

# make less more friendly for non-text input files, see lesspipe(1)
$(which lesspipe >/dev/null) && eval "$(lesspipe)"
$(which lesspipe.sh >/dev/null) && eval "$(lesspipe.sh)"

# thefuck
$(which thefuck >/dev/null) && eval $(thefuck --alias)

if command_exists rg; then
  export FZF_DEFAULT_COMMAND='rg --files -g ""'
elif command_exists ag; then
  export FZF_DEFAULT_COMMAND='ag -g ""'
fi

export FZF_DEFAULT_OPTS="--bind ctrl-j:down,ctrl-k:up"

# needs to come before setting PS1 for __git_ps1 check
if ! shopt -oq posix; then

  export DOCKER_COMPLETION_SHOW_IMAGE_IDS="non-intermediate"

  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif command_exists brew && [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi

  for file in "${HOME}"/Code/rc/completion/*; do
    . "$file"
  done

  if [ -d /Applications/Docker.app ]; then
    . /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion
    . /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion
  fi

  if command_exists grunt; then
    . <(grunt --completion=bash)
  fi

  if command_exists gerrit; then
    . <(gerrit completion)
  fi

fi

sources=(
  "${HOME}/.bash_aliases"
  "${HOME}/.bash_ps1"
  "${HOME}/.bash_sshauth"
  "${HOME}/.bash_readline"
  "${HOME}/.bashrc.local"
  "${HOME}/.rvm/scripts/rvm"
  "${HOME}/Code/bash-sneak/sneak.bash"
)

for file in "${sources[@]}"; do
  if [ -f "$file" ]; then
    . "$file"
  fi
done

if [[ -n $SUITUP ]]; then
  unset SUITUP
  tmux setenv -gu SUITUP
  suitup
fi

# start with a happy :)
true
