export NODE_PATH=$NODE_PATH:$HOME/.node/lib/node_modules

export PATH=$PATH:$HOME/.node/bin:$HOME/bin.local:$HOME/bin

if [[ -n "$(ls -A /Library/Java/JavaVirtualMachines 2>/dev/null)" ]]; then
  # macOS only?
  export JAVA_HOME=$($(dirname $(readlink $(which javac)))/java_home)
fi

if command -v brew >/dev/null && [ -d $(brew --prefix)/opt/nvm ]; then
  export NVM_DIR=~/.nvm
  . $(brew --prefix)/opt/nvm/nvm.sh
fi

if command -v docker-machine >/dev/null; then
  eval "$(docker-machine env 2>/dev/null)"
fi

# If not running interactively, stop here
[ -z "$PS1" ] && return

# start with tmux if we have it
if [[ ! $TERM =~ screen ]]; then
  export TERM="xterm-256color"
  if command -v tmux >/dev/null; then
    tmux has-session && exec tmux -2 attach || exec tmux -2
  fi
fi

# set shell options
shopt -s histappend cdspell checkwinsize dirspell direxpand autocd globstar no_empty_cmd_completion

# Some additional evironment variables
export EDITOR=vim
export CLICOLOR=1

export MYSQL_PS1="mysql://\u@\h \d> "

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=1000
export HISTFILESIZE=2000

# default options for less
export LESS="-SRi"

# github allows more api hits (ex: for searches) when authenticated
export HOMEBREW_GITHUB_API_TOKEN=f9cca0a2af5001e17aa2eab63ebf78bd9599890c

# make less more friendly for non-text input files, see lesspipe(1)
$(which lesspipe >/dev/null) && eval "$(lesspipe)"
$(which lesspipe.sh >/dev/null) && eval "$(lesspipe.sh)"

# needs to come before setting PS1 for __git_ps1 check
if ! shopt -oq posix; then

  export DOCKER_COMPLETION_SHOW_IMAGE_IDS="non-intermediate"

  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif command -v brew >/dev/null && [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi

  for file in "${HOME}"/Code/rc/completion/*; do
    . "$file"
  done

  if [ -d /Applications/Docker.app ]; then
    . /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion
    . /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion
  fi

  if command -v grunt >/dev/null; then
    . <(grunt --completion=bash)
  fi

  if command -v gerrit >/dev/null; then
    . <(gerrit completion)
  fi

fi

sources=(
  "${HOME}/.bash_ps1"
  "${HOME}/.bash_aliases"
  "${HOME}/.bash_sshauth"
  "${HOME}/.bash_readline"
  "${HOME}/.bashrc.local"
  "${HOME}/.rvm/scripts/rvm"
)

for file in "${sources[@]}"; do
  if [ -f "$file" ]; then
    . "$file"
  fi
done


# start with a happy :)
true
