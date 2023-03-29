#!/bin/bash

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM="name"
export GIT_PS1_DESCRIBE_STYLE=branch

if ! type -t __orig_git_ps1_show_upstream >/dev/null; then
  __save_function() {
    local ORIG_FUNC NEWNAME_FUNC

    ORIG_FUNC=$(declare -f "$1")
    NEWNAME_FUNC="$2${ORIG_FUNC#"$1"}"

    eval "$NEWNAME_FUNC"
  }

  __save_function __git_ps1_show_upstream __orig_git_ps1_show_upstream

  unset -f __save_function
fi

__colorize_ps1() {
  echo -n "\[$(__ansi_color "$1")\]$2\[$(__ansi_color "[X]X")\]"
}

__git_ps1_show_upstream() { 
  __orig_git_ps1_show_upstream

  local branch upstream remote remote_branch

  branch="$(git rev-parse --symbolic-full-name --abbrev-ref @)"
  upstream="$(git rev-parse --symbolic-full-name --abbrev-ref '@{upstream}' 2>/dev/null)"
  remote="${upstream%%/*}"
  remote_branch="${upstream#*/}"

  if [[ -n $upstream ]]; then
    if [[ $branch == "$remote_branch" ]]; then
      p="$p${remote}"
    else
      p="$p${upstream}"
    fi
    b="$b $p"
    p=""
  fi
}

__ssh_keys_status() {
  if ! ssh-add -l >/dev/null 2>&1; then
    return
  fi

  echo -e " {\xC2\xA7}"
}

if ! type __git_ps1 >/dev/null; then
  __git_ps1() {
    return
  }
fi

__jobs_status() {
  local cnt
  cnt=$(jobs | awk '/^\[[0-9]+\]/ && $2 !~ /^Done/' | wc -l | awk '{print $1}')

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
USER_HOST="$(__colorize_ps1 "$USER_HOST_COLOR" "\\u@$HOST")"

CWD="$(__colorize_ps1 C '\w')"

PROMPT="\$"

PS1="\
${debian_chroot}\
${USER_HOST}\
\$(__smiley)\
${CWD}\
\$(__ssh_keys_status)\
\$(__jobs_status)\
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
