#!/bin/bash

export GIT_PS1_SHOWDIRTYSTATE=
export GIT_PS1_SHOWSTASHSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=
export GIT_PS1_SHOWUPSTREAM=true
export GIT_PS1_DESCRIBE_STYLE=branch

__colorize_ps1() {
  echo -n "\[$(__ansi_color "$1")\]$2\[$(__ansi_color "[X]X")\]"
}

__git_ps1_others() {
  local status

  status=$(git status --porcelain --no-renames)

  # untrackted
  # shellcheck disable=SC2034
  [[ $status =~ (^|$'\n')\?\? ]] && u='%'

  # unstanged change
  # shellcheck disable=SC2034
  [[ $status =~ (^|$'\n').[^?\ ] ]] && w='*'

  # staged changes
  # shellcheck disable=SC2034
  [[ $status =~ (^|$'\n')[^?\ ] ]] && i='+'

  # shellcheck disable=SC2154,SC2034
  [[ -e "${g}/refs/stash" ]] && s='$'

  # from __git_ps1
  if [ -z "$short_sha" ] && [ -z "$i" ]; then
    i="#"
  fi
}

__git_ps1_show_upstream() {
  local marker result branch upstream remote remote_branch

  case "$(git rev-list --count --left-right '@{upstream}'...HEAD 2>/dev/null)" in
    "") # no upstream
      marker="" ;;
    "0	0") # equal to upstream
      marker="=" ;;
    "0	"*) # ahead of upstream
      marker=">" ;;
    *"	0") # behind upstream
      marker="<" ;;
    *)	    # diverged from upstream
      marker="<>" ;;
  esac

  readarray -t result < <(git rev-parse --symbolic-full-name --abbrev-ref '@' '@{upstream}' 2>/dev/null)
  branch="${result[0]}"
  upstream="${result[1]}"

  remote="${upstream%%/*}"
  remote_branch="${upstream#*/}"

  if [[ -n $upstream ]]; then
    if [[ $branch == "$remote_branch" ]]; then
      upstream="$remote"
    fi

    # place it next to branch
    b="$b $marker$upstream"
  fi

  __git_ps1_others
}

__ssh_keys_status() {
  if [[ $SSH_AUTH_SOCK =~ launchd ]]; then
    return
  fi

  if ! ssh-add -l >/dev/null 2>&1; then
    return
  fi

  echo -e " {\xC2\xA7}"
}

if ! type __git_ps1 >/dev/null 2>&1; then
  __git_ps1() {
    return
  }
fi

__jobs_status() {
  local cnt
  cnt=$(jobs | awk '/^\[[0-9]+\]/ && $2 !~ /^Done/ && $0 !~ /_WARP_/' | wc -l | awk '{print $1}')

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

__rosetta() {
  if os_is_mac && [[ $(sysctl -in sysctl.proc_translated) == "1" ]]; then
    echo " 🌹"
  fi
}

__dev_dev() {
  if ! command -v dev >/dev/null; then
    return
  fi

  if ! codesign -dv /opt/clio/bin/dev 2>&1 | grep -q 3289N5S57Z; then
    echo " 🛠️"
  fi
}

__git_ps1_worktree() {
  local count
  count=$(git worktree list 2>/dev/null | wc -l | bc)

  if [[ $count -gt 1 ]]; then
    local main
    main=$(git-wt main)

    if [[ "$PWD" == "$main" ]]; then
      echo -n "t(${count}) "
    else
      echo -n "t[${main##*/}] "
    fi
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

USER_HOST_COLOR=$([ -n "$SSH_CLIENT" ] && echo "Y" || echo "G" )
USER_HOST="$(__colorize_ps1 "$USER_HOST_COLOR" "\\u@\\h")"

CWD="$(__colorize_ps1 C '\w')"

PRE_PROMPT="\
\n\
${TIME}\
 \
${HISTORY_NUMBER}\
"

PROMPT="\$"

if [[ $__CFBundleIdentifier =~ dev.warp. ]]; then
  PRE_PROMPT=
fi

# Escape sequences for semantic shell promp
# to enable tmux prev/next-prompt
# https://github.com/tmux/tmux/issues/3064
PS1="\
\[\e]133;A\a\]\
${debian_chroot}\
${USER_HOST}\
\$(__smiley)\
${CWD}\
\$(__ssh_keys_status)\
\$(__jobs_status)\
\$(__git_ps1 \" (\$(__git_ps1_worktree)%s)\")\
\$(__rosetta)\
\$(__dev_dev)\
${PRE_PROMPT}\
 \
${PROMPT}\
 \
\[\e]133;B\a\]\
\[\e]133;C\a\]\
"

unset HISTORY_NUMBER TIME HOST USER_HOST_COLOR USER_HOST CWD PROMPT
