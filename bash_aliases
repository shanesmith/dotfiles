#!/bin/bash

# some more ls aliases
alias ls='ls --color=auto'
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'
alias lld='ll -d'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias QQ='exit'

alias cl='clear'

qrm() {
  local emptydir
  emptydir=$(mktemp -d)
  rsync -rd --delete "${emptydir}/" "${1}/"
  # rmdir "${1}"
  rmdir "${emptydir}"
}

os_is_mac() {
  [[ $(uname -s) == "Darwin" ]]
}

os_is_linux() {
  [[ $(uname -s) == "Linux" ]]
}

bak() {
  local src=${1%/}
  local dest=$src.bak$2

  if [[ -e $dest ]]; then
    echo "Already exists: $dest"
    return
  fi

  cp -ai "$src" "$dest"
}

mvbak() {
  local src=${1%/}
  local dest=$src.bak$2

  if [[ -e $dest ]]; then
    echo "Already exists: $dest"
    return
  fi

  mv -i "$src" "$dest"
}

unmvbak() {
  local src=${1%/}
  local dest=${src%.bak}

  if [[ -e $dest ]]; then
    echo "Already exists: $dest"
    return
  fi

  mv -i "$src" "$dest"
}

swapbak() {
  local src=${1%/}
  local dest=$src.bak$2
  local tmp
  tmp=$(mktemp "_${src}.tmp.XXXX") || return 1

  if [[ ! -e $dest ]]; then
    echo "Does not exist: $dest"
    return
  fi

  rm -rf "$tmp"

  mv "$src"  "$tmp"  || return 1
  mv "$dest" "$src"  || return 1
  mv "$tmp"  "$dest" || return 1
}

alias cd="pushd >/dev/null"
alias h="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias recd="cd .. && cd -"
--() {
  # shellcheck disable=2164
  cd -
}
cddir() {
  # shellcheck disable=2164
  cd "$(dirname "$1")"
}
alias cdir="cddir"
up() {
  local x=''
  case $1 in
    ''|*[0-9]*)
      local num=${1:-1}
      for (( i=0; i < num; i++ )); do
        x="$x../"
      done
      ;;
    *)
      x="$(pwd | perl -pe 's|(.*'"$1"'[^/]*)/.*|\1|i')"
      ;;
  esac
  echo "$x"
  # shellcheck disable=2164
  cd "$x"
}
mkcd() {
  # shellcheck disable=2164
  mkdir -p "$1" && cd "$1"
}
d() {
  local num=10
  local search=

  if [[ $# -ge 1 ]]; then
    if grep -E -q "[0-9]+" <<<"$1"; then
      local num=$1
    else
      local search=$1
    fi

    if [[ $# -ge 2 ]]; then
      if grep -E -q "[0-9]+" <<<"$2"; then
        local num=$2
      else
        local search=$2
      fi
    fi
  fi

  dirs -v | sort -k 2 -u | sort -n -k 1 | awk -v max="$num" -v search="$search" '
    function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
    function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
    function trim(s) { return rtrim(ltrim(s)); }
    BEGIN {
      lines = 0
    }
    search=="" || tolower($0) ~ tolower(search) {
      $1="";
      printf "%2s  %s\n", NR-1, trim($0);
      lines++
    }
    lines == max && max != 0 {
      exit
    }
  '
}
g() {
  local dir

  if command -v fzf >/dev/null; then

    dir="$(d 0 | fzf | awk '{print $2}')"

  else

    local show=0
    local num="+"

    if [[ $# -eq 0 ]]; then
      while [[ $num == "+" ]]; do
        (( show += 10 ))
        d "$show"
        read -rp "Go to: "
        num="$REPLY"
      done
    else
      num=$1
    fi

    dir=$(d 0 | awk -v line="$num" 'NR==line+1 { $1=""; print $0; exit }')

  fi

  dir=$(eval echo "${dir//>}")

  # shellcheck disable=2164
  cd "$dir"
}

scp-tar() {
  local args=("$@")
  local len=${#args[@]}
  local files=("${args[@]:0:$((len-1))}")
  local dest="${args[-1]}"
  local dest_host="${dest%%:*}"
  local dest_path="${dest#*:}"

  # shellcheck disable=2029
  tar czf - --dereference -- "${files[@]}" | ssh "$dest_host" "tar xzvf - -C '${dest_path}'"
}

alias sad=ssh-add

alias cpsync="rsync -vahP"

date2timestamp() {
  if os_is_mac; then
    date -j "$1" +%s
  else
    date --date="$1" +%s
  fi
}

timestamp2date() {
  if os_is_mac; then
    date -j -r "$1"
  else
    date --date="@$1"
  fi
}

alias now="date +%s"

alias whoareyou="uname -a"

alias vim="nvim"

alias hs="history"

alias jg="jobs -l"
alias kg="kill %1"

lsps() {
  ps -e -o 'user,pid,stat,%cpu,%mem,command' | awk -v pattern="$1" 'NR==1 || $0 ~ pattern && $6 != "awk"'
}

lshs() {
  history | grep -i "$1" | grep -v lshs
}

suitup() {
  if ! command -v tmux >/dev/null; then
    return
  fi

  if [[ -z $TMUX ]]; then
    export SUITUP=1
    exec tmux new -A
    return
  fi

  if [[ -n $SUITUP ]]; then
    echo "Loop protections."
    return
  fi

  local suitup_file="$HOME/.tmuxinator/suitup/${HOSTNAME%%.*}"

  if [[ ! -f "$suitup_file" ]]; then
    echo "Suitup file does not exist: $suitup_file"
    return 1
  fi

  while read -r line; do
    tmuxinator "$line"
  done < "$suitup_file"

  exit
}

function ] {
  if [[ $(which xdg-open) ]]; then
    xdg-open "$1"
  elif [[ $(uname) == "Darwin" && $(which open) ]]; then
    open "$1"
  fi
}


xcopy() {
  if os_is_mac; then
    if [ $# -gt 0 ]; then
      echo -n "$@" | pbcopy -pboard general
    else
      pbcopy -pboard general
    fi
  else
    xclip -i -selection clip
  fi
}

xpaste() {
  if os_is_mac; then
    pbpaste -pboard general
  else
    xclip -o -selection clip
  fi
}

alias vv="vagrant"
complete -F _vagrant vv

alias rr="ranger"

httpython() {
  python3 -m http.server "${1:-8080}" >> httpython.log 2>&1 &
}

# the space allows for aliases...
# https://wiki.archlinux.org/index.php/Sudo#Passing_aliases
alias sudo='sudo '
alias plz='sudo '
alias please='sudo '

alias vimrc='cd ~/Code/rc && vim vimrc'
alias bashrc='cd ~/Code/rc && vim bashrc'

relative_path() {
  # also available on non-OSX systems as
  #   realpath --relative-to="$file1" "$file2"
  python -c "import os.path; print os.path.relpath('$1', '${2:-$PWD}')"
}

port_holder() {
  if os_is_mac; then
    sudo lsof -nP -sTCP:LISTEN -i"TCP${1:+:$1}"
  else
    sudo netstat -tnlp | grep ":${1:-.*} "
  fi
}

rebash() {
  if [[ $__dev_source_dir != "/opt/dev" && -n $__dev_source_dir ]]; then
    # keep the space in front of devdev!
    exec bash -li <<<' devdev; exec</dev/tty'
  fi

  exec bash -l
}
alias rbb=rebash

alias upbrew="brew update && echo && brew outdated"

icanhazip() {
  ifconfig | awk '
    /^[^[:space:]]/ { name = substr($1, 0, length($1) - 1) }
    /^[[:space:]]+inet / && name != "lo0" { print name " " $2 }
  '
  echo "external $(curl -s http://icanhazip.com/s)"
}

man() {
  if [[ $# -eq 1 && $(type -t "$1") == "builtin" ]]; then
    help "$1"
  else
    /usr/bin/man "$@"
  fi
}

alias devdev='dev use dev --backend'
alias undevdev='dev use system --backend'
alias isdevdev='[[ $__dev_source_dir != "/opt/dev" && -n $__dev_source_dir ]]'
alias dev-tst='dev tc && dev style && dev test'
alias updev='eval "$(curl -sS https://up.dev)"'

P_PATH=~/Code:~/src/github.com/Shopify:~/src/github.com/ShopifyUS:~/src/github.com/Shopify/spin/containers
p() {
  # shellcheck disable=SC2164
  CDPATH="$P_PATH" cd "$@"
}
p_dirs() {
  local paths
  readarray -td ':' paths <<<"$P_PATH"

  for p in "${paths[@]}"; do
    fd --type d -d1 . "$p"
  done
}
_p_comp() {
  local paths
  local cur="${COMP_WORDS[COMP_CWORD]}"

  COMPREPLY=()

  readarray -td ':' paths <<<"$P_PATH"

  for dir in "${paths[@]}"; do
    [[ ! -d "$dir" ]] && continue
    readarray -t -O"${#COMPREPLY[@]}" COMPREPLY < <(cd "$dir" && compgen -d -- "$cur")
  done
}
complete -F _p_comp p

alias path="tr ':' '\n' <<<\$PATH"

alias lctl='launchctl'

alias journalctl="/usr/bin/journalctl --no-hostname"
alias sc=systemctl
alias jc=journalctl
