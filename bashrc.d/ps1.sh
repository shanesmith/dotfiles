#!/bin/bash

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM="name"
export GIT_PS1_DESCRIBE_STYLE=branch

save_function() {
    local ORIG_FUNC=$(declare -f $1)
    local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
    eval "$NEWNAME_FUNC"
}

if ! type -t __orig_git_ps1_show_upstream >/dev/null; then
  save_function __git_ps1_show_upstream __orig_git_ps1_show_upstream
fi

__colorize_ps1() {
  echo -n "\[$(__ansi_color "$1")\]$2\[$(__ansi_color "[X]X")\]"
}

__git_ps1_show_upstream() { 
  __orig_git_ps1_show_upstream

  local branch="$(git rev-parse --symbolic-full-name --abbrev-ref @)"
  local upstream="$(git rev-parse --symbolic-full-name --abbrev-ref '@{upstream}' 2>/dev/null)"

  local remote="$(sed 's#/.*##' <<<"$upstream")"
  local remote_branch="$(sed 's#[^/]*/##' <<<"$upstream")"

  if [[ -n $upstream ]]; then
    if [[ $branch == $remote_branch ]]; then
      p="$p${remote}"
    else
      p="$p${upstream}"
    fi
    b="$b $p"
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
    if [[ -r "$machinedir/virtualbox/id" ]]; then
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

__ssh_keys_status() {
  if ! ssh-add -l >/dev/null 2>&1; then
    return
  fi

  echo -e " {\xC2\xA7}"
}

__docker_compose_status() {
  if ! command -v docker-compose >/dev/null || [[ -z "$COMPOSE_FILE" ]]; then
    return
  fi

  local status=$(echo "$COMPOSE_FILE" | sed -e 's/docker-compose\.yml/./' -e 's/docker-compose\.//' -e 's/\.yml//')

  echo " +${status}+"
}

if ! type __git_ps1 >/dev/null; then
  __git_ps1() {
    return
  }
fi

__jobs_status() {
  local cnt=$(jobs | awk '/^\[[0-9]+\]/ && $2 !~ /^Done/' | wc -l | awk '{print $1}')

  if [[ $cnt -eq 0 ]]; then
    return
  fi

  __colorize Y " [$cnt]"
}

__smiley() {
  if [[ $? -eq 0 ]]; then
    __colorize W ":)"
  else
    __colorize BLR ":("
  fi
}

__dev_dev() {
  if ! isdevdev; then
    return
  fi

  echo -n " "
  __colorize U_ "🔧"
}

__rosetta() {
  if os_is_mac && [[ $(sysctl -in sysctl.proc_translated) == "1" ]]; then
    echo " 🌹"
  fi
}

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
  if [ -z "${debian_chroot}" ]; then
    debian_chroot="(${debian_chroot})"
  fi
fi

HISTORY_NUMBER="$(__colorize_ps1 DW '\!')"

TIME="$(__colorize_ps1 LK '\A')"

HOST=$([[ -n $SPIN ]] && sed "s/\\..*//" < /etc/spin/machine/fqdn || echo '\h')
USER_HOST_COLOR=$([ -n "$SSH_CLIENT" ] && echo "Y" || echo "G" )
USER_HOST="$(__colorize_ps1 $USER_HOST_COLOR "\\u@$HOST")"

CWD="$(__colorize_ps1 C '\w')"

PROMPT="\$"

PS1="\
${debian_chroot}\
${USER_HOST}\
\$(__smiley)\
${CWD}\
\$(__ssh_keys_status)\
\$(__jobs_status)\
\$(__vagrant_status)\
\$(__docker_compose_status)\
\$(__git_ps1 ' (%s)')\
\$(__rosetta)\
\$(__dev_dev)\
\n\
${TIME}\
 \
${HISTORY_NUMBER}\
 \
${PROMPT}\
 \
"

unset HISTORY_NUMBER TIME HOST USER_HOST_COLOR USER_HOST CWD PROMPT
