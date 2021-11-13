#!/bin/bash

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'
alias lld='ll -d'

alias QQ='exit'

alias cl='clear'

qrm() {
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

alias npr="npm run" # run script
alias npl="npm-run" # run with local patch
npm_upgrade() {
  for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
  do
    npm -g install "$package"
  done
}

npm_list_license() {
  npm list --depth=0 \
    | tail -n +2 \
    | awk '! /^\s*$/ {print $2}' \
    | while read package; do 
      # sed 's/@.*$//' <<<"$package" | xargs -I'{}' npm --no-progress info '{}' license
      local license=$(sed 's/@.*$//' <<<"$package" | xargs -I'{}' npm --no-progress info '{}' license)
      echo "$package ($license)"
    done
}

alias reyarn="unpm && yarn"
alias renpm="unpm && npm install"
alias unpm="find . -type d -name node_modules -prune -print0 | xargs -0 rm -rf --"

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
  local tmp=$(mktemp "_${src}.tmp.XXXX") || return 1

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
  cd -
}
cs() {
  cd "$1" && ls
}
cddir() {
  cd $(dirname "$1")
}
alias cdir="cddir"
up() {
  local x=''
  case $1 in
    ''|*[0-9]*)
      local num=${1:-1}
      for (( i=0; i < $num; i++ )); do
        x="$x../"
      done
      ;;
    *)
      x=$(pwd | perl -pe 's|(.*'$1'[^/]*)/.*|\1|i')
      ;;
  esac
  echo $x
  cd $x
}
mkcd() {
  mkdir -p "$1" && cd "$1"
}
d() {
  local num=10
  local search=

  if [[ $# -ge 1 ]]; then
    if echo "$1" | egrep -q "[0-9]+"; then
      local num=$1
    else
      local search=$1
    fi

    if [[ $# -ge 2 ]]; then
      if echo "$2" | egrep -q "[0-9]+"; then
        local num=$2
      else
        local search=$2
      fi
    fi
  fi

  dirs -v | sort -k 2 -u | sort -n -k 1 | awk -v max=$num -v search="$search" '
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
        read -p "Go to: "
        num="$REPLY"
      done
    else
      num=$1
    fi

    dir=$(d 0 | awk -v line=$num 'NR==line+1 { $1=""; print $0; exit }')

  fi

  dir=$(eval echo ${dir//>})

  cd "$dir"
}

scp-tar() {
  local args=("$@")
  local len=${#args[@]}
  local files=("${args[@]:0:$(($len-1))}")
  local dest="${args[@]:$(($len-1))}"
  local dest_host="${dest%%:*}"
  local dest_path="${dest#*:}"

  tar czf - --dereference -- "${files[@]}" | ssh "$dest_host" "tar xzvf - -C '${dest_path}'"
}

sshauth_reload() {
  . ~/.bash_sshauth
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

alias svim="sudo vim"

alias hs="history"

alias jg="jobs -l"
alias kg="kill %1"

alias dk="docker"
complete -F _docker dk

alias dkc="docker-compose"
complete -F _docker_compose dkc

docker_bash() {
  docker run --rm -it "$1" bash
}

docker-desktop-logs() {
  # https://docs.docker.com/desktop/mac/troubleshoot/#check-the-logs
  pred='process matches ".*(ocker|vpnkit).*" || (process in {"taskgated-helper", "launchservicesd", "kernel"} && eventMessage contains[c] "docker")'
  /usr/bin/log stream --style syslog --level=debug --color=always --predicate "$pred"
}

lsps() {
  ps aux | grep -i "$1" | grep -v grep
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
    muxit
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

  cat "$suitup_file" | while read -r line; do
    tmuxinator "$line"
  done

  exit
}

muxit() {
  if ! command -v tmux >/dev/null || [[ -n $TMUX ]]; then
    return
  fi

  tmux has-session 2>/dev/null && exec tmux -2 attach || exec tmux -2
}

alias kill-tmux="tmux kill-session -a && tmux kill-session"

] () {
  if [[ $(which xdg-open) ]]; then
    xdg-open "$1"
  elif [[ $(uname) == "Darwin" && $(which open) ]]; then
    open "$1"
  fi
}

alias starwars="curl https://asciitv.fr"
alias busy="cat /dev/urandom | hexdump -C | grep --color 'ca fe'"
alias matrix='echo -e "\e[32m"; while :; do for i in {1..16}; do r="$(($RANDOM % 2))"; if [[ $(($RANDOM % 2)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r   "; else v+="\e[2m $r   "; fi; else v+="     "; fi; done; echo -e "$v"; v=""; sleep 0.001; done;'
sing() {
  cat /dev/urandom | hexdump -v -e '/1 "%u\n"' | awk '{ split("0,2,4,5,7,9,11,12",a,","); for (i = 0; i < 1; i+= 0.0001) printf("%08X\n", 100*sin(1382*exp((a[$1 % 8]/12)*log(2))*i)) }' | xxd -r -p | sox -v 0.05 -traw -r44100 -b16 -e unsigned-integer - -tcoreaudio
}


alias apt-search="apt-cache search"
alias apt-show="apt-cache show"
alias apt-showpkg="apt-cache showpkg"
alias apt-install="sudo apt-get install"
alias apt-update="sudo apt-get update"
alias apt-upgrade="sudo apt-get update && sudo apt-get upgrade"
alias apt-dist-upgrade="sudo apt-get update && sudo apt-get dist-upgrade"
apt-list-ppa() {
  for APT in `find /etc/apt/ -name *.list`; do
    grep -o "^deb http://ppa.launchpad.net/[a-z0-9-]\+/[a-z0-9.-]\+" $APT | while read ENTRY ; do
      USER=`echo $ENTRY | cut -d/ -f4`
      PPA=`echo $ENTRY | cut -d/ -f5`
      echo ppa:$USER/$PPA
    done
  done
}
remove-old-kernels() {
  local OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')
  local CURKERNEL=$(uname -r|sed 's/-*[a-z]//g'|sed 's/-386//g')
  local LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
  local METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
  local OLDKERNELS=$(dpkg -l|awk '{print $2}'|grep -E $LINUXPKG |grep -vE $METALINUXPKG|grep -v $CURKERNEL)

  echo "Removing old config files..."
  sudo apt-get purge $OLDCONF

  echo "Removing old kernels..."
  sudo apt-get purge $OLDKERNELS
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

gittop() {
  cd $(git top)
}

httphp() {
  php -S 0.0.0.0:${1:-8080} >> httphp.log 2>&1 &
}
httpython() {
  python -m SimpleHTTPServer ${1:-8080} >> httpython.log 2>&1 &
}

# the space allows for aliases...
# https://wiki.archlinux.org/index.php/Sudo#Passing_aliases
alias sudo='sudo '
alias plz='sudo '
alias please='sudo '

alias vimrc='cd ~/Code/rc && vim vimrc'
alias bashrc='cd ~/Code/rc && vim bashrc'

git_remove-merged-branches() {
  local branches=$(git branch --merged | sed -e '/^*/d' -e '/master/d')
  echo "Finding candidate branches..."
  echo "$branches"
  read -p "Remove these branches? "
  if [[ $REPLY == "y" || $REPLY == "Y" ]]; then
    git branch -d $branches
  fi
}

git_whitespace_fix() {
  for FILE in $(exec git diff-index --check HEAD -- | sed '/^[+-]/d' | cut -d: -f1 | uniq); do
    sed -i 's/[[:space:]]*$//' "$FILE"
  done
}

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

alias devdev='dev use dev --backend && . ~/.bash_ps1'
alias undevdev='dev use system --backend && . ~/.bash_ps1'
alias isdevdev='[[ $__dev_source_dir != "/opt/dev" && -n $__dev_source_dir ]]'

P_PATH=~/Code:~/src/github.com/Shopify
p() {
  CDPATH="$P_PATH" cd $@
}
p_dirs() {
  readarray -td ':' paths < <(echo -n "$P_PATH")

  for p in "${paths[@]}"; do
    fd --type d -d1 . "$p"
  done
}
_p_comp() {
  local cur="${COMP_WORDS[COMP_CWORD]}"

  COMPREPLY=()

  readarray -td ':' paths < <(echo -n "$P_PATH")

  for dir in "${paths[@]}"; do
    COMPREPLY=( "${COMPREPLY[@]}" $(cd "$dir" && compgen -d -- "$cur") )
  done
}
complete -F _p_comp p

__ansi_color() {
  local code

  local light

  local attr=""
  local color="$1"

  while [[ "${#color}" -gt 1 ]]; do

    code=

    case "${color:0:1}" in
      B) code="1" ;; # Bright / Bold
      D) code="2" ;; # Dimmed
      U) code="4" ;; # Underlined
      I) code="7" ;; # Inverted
      L) light=1  ;; # Light
      "[")           # Background
        code=$(__color_code "${color:1:1}")
        if [[ "$code" -eq 0 ]]; then
          code="49"
        else
          code=$(( "$code" + 10 ))
        fi
        color="${color:2}"
        ;;
    esac

    if [[ -n "$code" ]]; then
      attr="${attr}${code};"
    fi

    color="${color:1}"

  done

  if [[ "$color" = "_" ]]; then
    code=""
    attr="${attr%%;}"

  else
    code=$(__color_code "$color")

    if [[ "$light" -eq 1 && "$code" -ne 0 ]]; then
      code=$(( $code + 60 ))
    fi
  fi

  echo "\e[${attr}${code}m"
}

__color_code() {
  local code

  case "$1" in
    K) code="30" ;; # Black
    R) code="31" ;; # Red
    G) code="32" ;; # Green
    Y) code="33" ;; # Yellow
    B) code="34" ;; # Blue
    M) code="35" ;; # Magenta
    C) code="36" ;; # Cyan
    W) code="37" ;; # White (Light gray)
    X) code="0"  ;; # Reset
  esac

  echo "$code"
}

__colorize() {
  echo -ne $(__ansi_color "$1")

  if [[ $# -gt 1 ]]; then
    echo -n "$2"
    echo -ne $(__ansi_color "[X]X")
  fi
}

__colorize_ps1() {
  echo -n "\[$(__ansi_color "$1")\]$2\[$(__ansi_color "[X]X")\]"
}

__webcam_files=(
  "/System/Library/Frameworks/CoreMediaIO.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC"
  "/System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/AVC.plugin/Contents/MacOS/AVC"
  "/System/Library/QuickTime/QuickTimeUSBVDCDigitizer.component/Contents/MacOS/QuickTimeUSBVDCDigitizer"
  "/Library/CoreMediaIO/Plug-Ins/DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera"
  "/Library/CoreMediaIO/Plug-Ins/FCP-DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera"
)

macos_disable_webcam() {
  sudo chmod a-r "${__webcam_files[@]}"
}

macos_enable_webcam() {
  sudo chmod a+r "${__webcam_files[@]}"
}

alias path="tr ':' '\n' <<<\$PATH"

alias be="bundle exec "

alias ibrew="arch -x86_64 /usr/local/bin/brew"
alias abrew="arch -arm64 /opt/homebrew/bin/brew"

alias ibash="arch -x86_64 /opt/homebrew/bin/bash"
alias abash="arch -arm64 /opt/homebrew/bin/bash"

i2abrew() {
  local pkgs="$@"
  ibrew uninstall $pkgs && abrew install $pkgs
}


a2ibrew() {
  local pkgs="$@"
  abrew uninstall $pkgs && ibrew install $pkgs
}

alias lctl='launchctl'

podman-fw-list() {
  curl http://localhost:7777/services/forwarder/all
}

podman-fw-expose() {
  curl http://localhost:7777/services/forwarder/expose -X POST -d "$(cat <<EOS
{
  "local": "$1",
  "remote": "$2"
}
EOS
)"
}


podman-fw-unexpose() {
  curl http://localhost:7777/services/forwarder/unexpose -X POST -d "$(cat <<EOS
{
  "local": "$1"
}
EOS
)"
}


####################
## Hub Chain
####################

git-branch-name() {
  local ref=${1:-HEAD}
  git symbolic-ref --quiet --short $ref
}

hub-pr-info() {
  local branch=${1:-$(git-branch-name)}

  # pr-number state base newline
  hub pr list --state all -f "%I %pS %B %n" --head $branch
}

hub-pr-info-up() {
  local branch=${1:-$(git-branch-name)}

  # up-pr-number up-state up-branch newline
  hub pr list --state all -f "%I %pS %H %n" --base $branch
}

hub-chain() {
  local branch=$(git-branch-name)

  hub-chain-up $branch | tac | sed -e '$d' -e 's/^/  /'
  hub-chain-down $branch | sed -e '1s/^/* /' -e '2,$s/^/  /'
}

hub-chain-down() {
  local branch=$(git-branch-name)

  while [[ $branch != "master" ]]; do
    local pr_info=$(hub-pr-info $branch)

    hub-print-pr $(awk -v branch=$branch '{$3=branch; print}' <<< $pr_info)

    # local pr_number=$(awk '{print $1}' <<< $pr_info)
    # local state=$(awk '{print $2}' <<< $pr_info)
    branch=$(awk '{print $3}' <<< $pr_info)
    #
    # echo "#$pr_number [$state] $branch"

    # branch=$base
  done

  echo "master"
}

hub-chain-up() {
  local output=""

  local branch=${1:-$(git-branch-name)}

  local pr_info=$(hub-pr-info $branch)

  output+=$(hub-print-pr $(awk -v branch=$branch '{$3=branch; print}' <<< $pr_info))
  # tail -n1 <<<"$output"

  # local pr_number=$(awk '{print $1}' <<< $pr_info)
  # local state=$(awk '{print $2}' <<< $pr_info)
  # local pr_branch=$(awk '{print $3}' <<< $pr_info)
  #
  # output+="#$pr_number [$state] $branch \n"

  while true; do
    pr_info=$(hub-pr-info-up $branch)

    local pr_count=$(wc -l <<<"$pr_info")

    if [[ -z $pr_info ]]; then
      break
    elif [[ $pr_count -gt 1 ]]; then
      echo "$output"
      local i=0
      while read line; do
        ((i++))
        local prefix=$(printf '|%.0s' $(seq 1 $i))
        hub-chain-up $(awk '{print $3}' <<<"$line") | sed "s/^/$prefix /"
      done <<<"$pr_info"
      return
    fi

    output+=$'\n'$(hub-print-pr $pr_info)
    # tail -n1 <<<"$output"

    # pr_number=$(awk '{print $1}' <<< $pr_info)
    # state=$(awk '{print $2}' <<< $pr_info)
    branch=$(awk '{print $3}' <<< $pr_info)
    #
    # output+="#${pr_number} [$state] $pr_branch \n"

    # branch=$pr_branch
  done

  echo "$output"
  # echo "DONE!"
}

hub-print-pr() {
  local pr_number=$1
  local state=$2
  local branch=$3

  echo "#${pr_number} [$state] $branch"
}

hub-bob() {
  local branch=${1:-$(git-branch-name)}

  hub pr list --state all -f "%H %n" --base $branch
}

hub-base() {
  local branch=${1:-$(git-branch-name)}

  hub pr list --state all -f "%B %n" --head $branch
}

hub-set-base() {
  local base=${1}

  if [[ ! $base ]]; then
    echo "Need a base!"
    return 1
  fi

  local pr_number=$(awk '{print $1}' <<< $(hub-pr-info))

  hub api "repos/{owner}/{repo}/pulls/${pr_number}" --flat --field base=$base >/dev/null

  hub-chain
}
