#!/bin/bash

__readline_insert() {
  local text=$1
  if [[ -z $text ]]; then
    return
  fi

  if [[ ${READLINE_POINT} -ne 0 && ${READLINE_LINE:((${READLINE_POINT} - 1)):1} != " " ]]; then
    text=" $text"
  fi
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${text}${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#text} - 1 ))
}

__readline_replace() {
  READLINE_LINE="$1"
  READLINE_POINT="${#1}"
}

__escape() {
  while read -r item; do
    printf '%q ' "$item"
  done
}

_fzf_git_lol_preview() {
  local hash

  hash=$(_fzf_git_lol_get_hash <<<"$1")

  git show --color "$hash"
}

_fzf_git_lol_get_hash() {
  __strip_ansi | sed -E 's/^[^[:alnum:]]*//' | awk '{print $1}'
}

_fzf_git_lol() {
  export -f _fzf_git_lol_preview
  export -f _fzf_git_lol_get_hash
  export -f __strip_ansi

  # TODO always describe?
  local log_command=${1:-lol}
  local preview="_fzf_git_lol_preview {}"
  local sha

  sha=$(git "$log_command" | fzf --ansi --reverse --no-sort --track --scheme=history --multi --bind ctrl-p:toggle-preview --preview-window=down --preview="$preview" \
    | _fzf_git_lol_get_hash \
    | xargs git describe --all --contains \
    | tr '\n' ' '
  )

  __readline_insert "$sha"
}

_fzf_git_lall() {
  _fzf_git_lol "lall"
}

_fzf_git_status_preview() {
  local flags=${1:0:2}
  local path=${1:3}

  if [[ -d $path ]]; then
    tree -C "$path"
  else
    if [[ $flags = "??" ]]; then
      bat --color=always -pp "$path"
    # TODO and if it's both? (eg: "MM")
    elif [[ $flags = "M " || $flags = "A " ]]; then
      git diff --color --staged -- "$path"
    else
      git diff --color -- "$path"
    fi
  fi
}

_fzf_git_status() {
  export -f _fzf_git_status_preview

  # TODO preview probably won't work with a space in the path
  local preview="_fzf_git_status_preview {}"
  local file
  file="$(git -c color.status=always status --short | fzf --ansi -m --scheme=path --preview-window=down --preview="$preview" | awk '{print $2}' | __escape)"
  __readline_insert "$file"
}

_fzf_git_status_unstaged() {
  export -f _fzf_git_status_preview

  # TODO preview probably won't work with a space in the path
  local preview="_fzf_git_status_preview {}"
  local file
  file="$(git -c color.status=always status --short | grep '^.[^ ]*\s[^ ]' | fzf --ansi -m --scheme=path --preview-window=down --preview="$preview" | awk '{print $2}' | __escape)"
  __readline_insert "$file"
}

_fzf_git_status_staged() {
  export -f _fzf_git_status_preview

  # TODO preview probably won't work with a space in the path
  local preview="_fzf_git_status_preview {}"
  local file
  file="$(git -c color.status=always status --short | grep '^[^ ]' | fzf --ansi -m --scheme=path --preview-window=down --preview="$preview" | awk '{print $2}' | __escape)"
  __readline_insert "$file"
}

_fzf_git_status_untracked() {
  export -f _fzf_git_status_preview

  # TODO preview probably won't work with a space in the path
  local preview="_fzf_git_status_preview {}"
  local file
  file="$(git -c color.status=always status --short | grep -O '^[^ ]*??[^ ]*\s' | fzf --ansi -m --scheme=path --preview-window=down --preview="$preview" | awk '{print $2}' | __escape)"
  __readline_insert "$file"
}

_fzf_git_history() {
  local branch
  branch=$(git hs | fzf -m --scheme=history --preview-window=down --preview='git lonly -n 100 {}' | __escape)
  __readline_insert "$branch"
}

_fzf_git_branch() {
  local branch
  branch=$(git for-each-ref --format="%(refname:short)" --sort=-committerdate refs/heads/ | fzf --no-sort -m --preview-window=down --preview='git lonly -n 100 {}' | __escape)
  __readline_insert "$branch"
}

_fzf_git_reflog() {
  local sha
  sha="$(git reflog --color | fzf --ansi --no-sort --track | awk '{print $1}' | __escape)"
  __readline_insert "$sha"
}

_fzf_git_worktree_preview() {
  local worktree="${1%% *}"
  echo "$worktree"
  git -C "$worktree" -c color.status=always status
}

_fzf_git_worktree() {
  export -f _fzf_git_worktree_preview

  local preview="_fzf_git_worktree_preview {}"
  local worktree
  worktree=$(git worktree list | fzf --multi --preview-window=down --preview="$preview" | awk '{print $1}' | __escape)
  __readline_insert "$worktree"
}

_fzf_history() {
  local line
  shopt -u nocaseglob nocasematch
  line=$(HISTTIMEFORMAT='' history | tac | fzf --no-sort --scheme=history --track +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r | awk '{ $1=""; print $0 }' | sed 's/^ *//')
  __readline_replace "$line"
}

_fzf_files() {
  local dir="${1:-.}"
  local file
  file="$(fd --type f . "$dir" | fzf -m --scheme=path --preview='bat --color=always -pp {}' | __escape)"
  if [[ -n $file ]]; then
    __readline_insert "$file"
  fi
}

__fzf_get_dir() {
  local dir="${1:-.}"
  fd --type d . "$dir" | fzf -m --scheme=path --preview='tree -C {} | head -200' | __escape
}

_fzf_directories() {
  local dir
  dir="$(__fzf_get_dir "$1")"
  if [[ -n $dir ]]; then
    __readline_insert "$dir"
  fi
}

_fzf_cd() {
  local dir
  dir="$(__fzf_get_dir "$1")"
  __readline_replace "cd ${dir}"
}

_fzf_ps() {
  local proc
  proc=$(command ps -e -o 'user,pid,stat,%cpu,%mem,command' | fzf -m --preview 'echo {}' --header-lines=1 --preview-window down:3:wrap --min-height 15 | awk '{print $2}' | __escape)
  __readline_insert "$proc"
}

_fzf_gerrit_patch() {
  local id
  id=$(gerrit patches | fzf --header-lines=1 --reverse | awk '{print $1}')
  __readline_insert "$id"
}

_fzf_brew_install() {
  local package
  package=$(HOMEBREW_COLOR=1 brew search "$1" | fzf --ansi --tac --no-sort --preview "HOMEBREW_COLOR=1 brew info {}")
  if [[ ! $package =~ ^[a-z] ]]; then
    return
  fi

  __readline_insert "${package}"
}

_fzf_hub_chain_get_branch() {
  awk '{print $NF}'
}

_fzf_hub_chain_preview() {
  local branch
  branch=$(_fzf_hub_chain_get_branch <<<"$1")
  git lonly -n 100 "$branch"
}

_fzf_hub_chain() {
  export -f _fzf_hub_chain_get_branch
  export -f _fzf_hub_chain_preview

  local branch
  branch=$(hub-chain \
    | fzf --no-sort --tac --multi --preview-window=down --preview='_fzf_hub_chain_preview {}' \
    | _fzf_hub_chain_get_branch \
    | __escape \
  )

  __readline_insert "$branch"
}

_fzf_p_dirs() {
  local dirs
  dirs=$(p_dirs | fzf -m --preview='tree -C {} | head -200' | __escape)
  if [[ -n $dirs ]]; then
    __readline_insert "$dirs"
  fi
}

_fzf_kubectl_context() {
  local context
  context=$(kubectl config get-contexts -o name | fzf --preview-window=down,5 --preview "kubectl config get-contexts {} | rs -Tz" | __escape)
  __readline_insert "$context"
}

_fzf_kubectl_namespace() {
  local namespace
  namespace=$(kubectl get namespaces --no-headers | awk '{print $1}' | fzf --preview-window=wrap --preview "kubectl describe namespace {}" | __escape)
  __readline_insert "$namespace"
}

_fzf_kubectl_pods() {
  local namespace
  namespace=$(kubectl get pods --no-headers | awk '{print $1}' | fzf --preview-window=wrap --preview "kubectl describe pod {}" | __escape)
  __readline_insert "$namespace"
}

_fzf_kubectl_thing() {
  local what result
  what="$1"
  result=$(kubectl get ${what} | fzf --header-lines=1 --preview "kubectl describe ${what} {1}" | awk '{print $1}' | __escape)
  __readline_insert "$result"
}

_fzf_ssh_keys() {
  local file
  file="$(fd --type f . "$HOME/.ssh" | fzf -m --scheme=path | __escape)"
  if [[ -n $file ]]; then
    __readline_insert "$file"
  fi
}

 _fzf_docker_container() {
   local container
   container=$(docker ps | fzf --header-lines=1 | awk '{print $1}' | __escape)
   __readline_insert "$container"
 }

 _fzf_docker_container_all() {
   local container
   container=$(docker ps -a | fzf --header-lines=1 | awk '{print $1}' | __escape)
   __readline_insert "$container"
 }

 _fzf_docker_image() {
   local image
   image=$(docker images | fzf --header-lines=1 | awk '{print $3}' | __escape)
   __readline_insert "$image"
 }

_fzf_word() {
  local cmd
  local args

  local mod
  local readline_up_to_point=${READLINE_LINE:0:$READLINE_POINT}
  readline_up_to_point=${readline_up_to_point%%*( )}
  READLINE_POINT=${#readline_up_to_point}
  local orig_word
  orig_word=$(awk '{print $NF}' <<<"$readline_up_to_point")

  local word="$orig_word"

  if [[ $word =~ : ]]; then
    mod=${word##*:}
    word=${word%%:*}
  fi

  case "$word" in
    f)   cmd="_fzf_files" ;;
    d)   cmd="_fzf_directories" ;;
    p)   cmd="_fzf_p_dirs" ;;
    gl)  cmd="_fzf_git_lol" ;;
    gla) cmd="_fzf_git_lall" ;;
    gs)  cmd="_fzf_git_status" ;;
    gsut)cmd="_fzf_git_status_untracked" ;;
    gsus)cmd="_fzf_git_status_unstaged" ;;
    gssg)cmd="_fzf_git_status_staged" ;;
    gh)  cmd="_fzf_git_history" ;;
    grp) cmd="_fzf_gerrit_patch" ;;
    gb)  cmd="_fzf_git_branch" ;;
    gr)  cmd="_fzf_git_reflog" ;;
    gw)  cmd="_fzf_git_worktree" ;;
    hc)  cmd="_fzf_hub_chain" ;;
    kc)  cmd="_fzf_kubectl_thing"; args=$mod ;;
    kcx) cmd="_fzf_kubectl_context" ;;
    kcn) cmd="_fzf_kubectl_namespace" ;;
    kcp) cmd="_fzf_kubectl_pods" ;;
    dkc) cmd="_fzf_docker_container" ;;
    dkca)cmd="_fzf_docker_container_all" ;;
    dki) cmd="_fzf_docker_image" ;;
    *)   cmd="_fzf_${word}" ;;
  esac

  if ! type -t "$cmd" >/dev/null; then
    dir="${word/#\~/$HOME}"
    if [[ -d $dir ]]; then
      if [[ $mod == "d" ]]; then
        cmd="_fzf_directories"
      else
        cmd="_fzf_files"
      fi
      args="'$dir'"
    else
      orig_word=
      case "$readline_up_to_point" in
        git\ @(ad?(d)|rm|remove)) cmd="_fzf_git_status_unstaged" ;;
        git\ @(co|checkout)) cmd="_fzf_git_history" ;;
        git\ @(wt|worktree)\ @(remove|rm|move|mv|repair)) cmd="_fzf_git_worktree" ;;
        git\ unstage) cmd="_fzf_git_status_staged" ;;
        kccx) cmd="_fzf_kubectl_context" ;;
        kccn) cmd="_fzf_kubectl_namespace" ;;
        @(kc|kcd|kcg|kubectl)\ *) cmd="_fzf_kubectl_thing"; args=$word ;;
        kill?( *)) cmd="_fzf_ps" ;;
        sad|ssh-add) cmd="_fzf_ssh_keys" ;;
        *) return ;;
      esac
    fi
  fi

  READLINE_LINE="${readline_up_to_point:0:(($READLINE_POINT - ${#orig_word}))}${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT="$((READLINE_POINT - ${#orig_word}))"

  eval "$cmd $args"
}

if command -v fzf >/dev/null; then
  bind -x '"\C-r": _fzf_history'
  bind -x '"\C-f": _fzf_word'
fi

export BASHELP_TERMINAL=tmux
bind -x '"\C-xh": _bash_help'
bind -x '"\C-x\C-h": _bash_help'

__git_show_popup() {
  local readline_up_to_point=${READLINE_LINE:0:$READLINE_POINT}
  readline_up_to_point=${readline_up_to_point%%*( )}
  local word
  word=$(awk '{print $NF}' <<<"$readline_up_to_point")

  tmux popup "git -C '$PWD' show $word"
}
bind -x '"\C-x\C-g": __git_show_popup'

__readline_yank() {
  echo -n "$READLINE_LINE" | pbcopy
  tmux display -d 1000 "YOINK!"
}
bind -x '"\C-x\C-y": __readline_yank' # broken in ble.sh
bind -x '"\C-x\"": __readline_yank'
