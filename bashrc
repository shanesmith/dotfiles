export NODE_PATH=$NODE_PATH:$HOME/.node/lib/node_modules

export PATH=$PATH:$HOME/.node/bin:$HOME/bin.local:$HOME/bin

if [[ -n "$(ls -A /Library/Java/JavaVirtualMachines)" ]]; then
  # macOS only?
  export JAVA_HOME=$($(dirname $(readlink $(which javac)))/java_home)
fi

if command -v brew >/dev/null && brew list nvm >/dev/null; then
  export NVM_DIR=~/.nvm
  . $(brew --prefix nvm)/nvm.sh
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

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# set shell options
shopt -s histappend cdspell checkwinsize dirspell autocd globstar

# make less more friendly for non-text input files, see lesspipe(1)
$(which lesspipe >/dev/null) && eval "$(lesspipe)"
$(which lesspipe.sh >/dev/null) && eval "$(lesspipe.sh)"

# default options for less
export LESS="-SRi"

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

  # if [ -f ~/Code/rc/misc/tmuxinator-completion.bash ]; then
  #   . ~/Code/rc/misc/tmuxinator-completion.bash
  # fi
  #
  # if [ -f ~/Code/rc/misc/vagrant-completion.bash ]; then
  #   . ~/Code/rc/misc/vagrant-completion.bash
  # fi

  if command -v grunt >/dev/null; then
    . <(grunt --completion=bash)
  fi

  if command -v npm >/dev/null; then
    . <(npm completion)
  fi

  if command -v gerrit >/dev/null; then
    . <(gerrit completion)
  fi

fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
else
  color_prompt=
fi

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=true
export GIT_PS1_DESCRIBE_STYLE=branch

save_function() {
    local ORIG_FUNC=$(declare -f $1)
    local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
    eval "$NEWNAME_FUNC"
}

if ! type -t __orig_git_ps1_show_upstream >/dev/null; then
  save_function __git_ps1_show_upstream __orig_git_ps1_show_upstream
fi

__git_ps1_show_upstream() { 
  __orig_git_ps1_show_upstream

  local upstream="$(git rev-parse --symbolic-full-name --abbrev-ref '@{upstream}' 2>/dev/null)"

  if [[ -n $upstream ]]; then
    b="$b $p$upstream"
    p=""
  fi

}

__vagrant_status() {

  local vagrantdir="$PWD"

  while [[ ! -d "$vagrantdir/.vagrant" && $vagrantdir != "/" ]]; do
    vagrantdir=$(dirname "$vagrantdir")
  done

  vagrantdir="$vagrantdir/.vagrant"

  if [[ ! -d $vagrantdir ]]; then
    return
  fi

  local -a RunningVMs=()
  local -a RunningUUIDs=()
  local -a VMs=()
  local -a DeadVMs=()

  if [[ $(uname -s) == "Darwin" ]]; then
    local proclist="$(ps -ww -o args= -p $(pgrep VBoxHeadless) 2>/dev/null)"
  else
    local proclist="$(ps h -C VBoxHeadless -o args)"
  fi

  if [[ -z $proclist ]]; then
    return
  fi

  # Gather the UUIDs of all presently running VMs.
  while read proc; do
    proc=${proc#*--startvm[[:space:]]}
    proc=${proc%%[[:space:]]*}
    RunningUUIDs+=(${proc})
  done <<< "$proclist"

  for machinedir in $vagrantdir/machines/*; do
    if [[ -d $machinedir ]]; then
      local machinename=$(basename $machinedir)
      if [[ "${RunningUUIDs[@]}" =~ $(cat "$machinedir/virtualbox/id") ]]; then
        VMs+=($machinename)
      fi
    fi
  done

  local output="${VMs[*]}"

  if [[ -n $output ]]; then
    echo " <$(echo $output | tr ' ' ',')>"
  fi
}

__nvm_status() {
  if ! type -t nvm >/dev/null; then
    return
  fi

  local current=$(nvm current)

  if [[ $current == "system" ]]; then
    return
  fi

  echo " <nvm-$current>"
}

__ssh_keys_status() {
  if ! ssh-add -l >/dev/null 2>&1; then
    return
  fi

  echo -e " {\u00A7}"
}

if command -v docker-compose >/dev/null; then

  __docker_compose_status() {
    if [[ -z "$COMPOSE_FILE" ]]; then
      return
    fi

    local status=$(echo "$COMPOSE_FILE" | sed -e 's/docker-compose\.yml/./' -e 's/docker-compose\.//' -e 's/\.yml//')

    echo " +${status}+"
  }

else

  __docker_compose_status() {
    return
  }

fi

__jobs_status() {
  local cnt=$(jobs | wc -l | awk '{print $1}')

  if [[ $cnt -eq 0 ]]; then
    return
  fi

  echo " $cnt"
}

NONE="\[\033[0m\]"    # unsets color to term's fg color

# regular colors
K="\[\033[0;30m\]"    # black
R="\[\033[0;31m\]"    # red
G="\[\033[0;32m\]"    # green
Y="\[\033[0;33m\]"    # yellow
B="\[\033[0;34m\]"    # blue
M="\[\033[0;35m\]"    # magenta
C="\[\033[0;36m\]"    # cyan
W="\[\033[0;37m\]"    # white

# empahsized (bolded) colors
EMK="\[\033[1;30m\]"
EMR="\[\033[1;31m\]"
EMG="\[\033[1;32m\]"
EMY="\[\033[1;33m\]"
EMB="\[\033[1;34m\]"
EMM="\[\033[1;35m\]"
EMC="\[\033[1;36m\]"
EMW="\[\033[1;37m\]"

SMILEY='$([[ $? -eq 0 ]] && echo ":)" || echo "'$EMR':('$NONE'")'
HAS_JOBS='$(__jobs_status)'

PS1='${debian_chroot:+($debian_chroot)}'

if [ "$color_prompt" = yes ]; then
  PS1="${PS1}${G}\u@\h${NONE}${SMILEY}${C}\w${NONE} ${W}[\!${Y}${HAS_JOBS}${W}]${NONE}"
else
  PS1="$PS1\u@\h${SMILEY}\w [\! \$?]"
fi

PS1="${PS1}\$(__vagrant_status)\$(__nvm_status)\$(__ssh_keys_status)\$(__docker_compose_status)"

if [[ $(type -t __git_ps1) == "function" ]]; then
  PS1="$PS1\$(__git_ps1 ' (%s)')"
fi

PS1="$PS1\n\\$ "

unset K R G Y B M C W
unset EMK EMR EMG EMY EMB EMM EMC EMW
unset NONE SMILEY HAS_JOBS
unset color_prompt

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Some additional evironment variables
export EDITOR=vim
export CLICOLOR=1

export MYSQL_PS1="mysql://\u@\h \d> "

title() {
  export TITLE="$*"
}
_set_title() {
  if [ "x$TITLE" = "x" ]; then
    echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"
  else
    echo -ne "\033]0;${TITLE}\007"
  fi
}
if [[ $TERM =~ xterm* ]]; then
  export PROMPT_COMMAND="_set_title"
fi

sources=(
  "${HOME}/.bash_aliases"
  "${HOME}/.bash_sshauth"
  "${HOME}/.bashrc.local"
)

for file in "${sources[@]}"; do
  if [ -f "$file" ]; then
    . "$file"
  fi
done

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# start with a happy :)
true
