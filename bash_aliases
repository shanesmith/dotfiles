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

alias :q='exit'
alias :Q='exit'
alias QQ='exit'

alias cl='clear'

alias ag='ag -S --pager="less"'

alias ion='ionic'

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

alias reyarn="rm -rf node_modules && yarn"
alias renpm="rm -rf node_modules && npm install"

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

alias h="cd ~"
alias ..="cd .."
alias ...="cd ../.."
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
cd() {
  pushd "$1" > /dev/null
  # if echo "$1" | egrep -q "^-+$"; then
  #   g ${#1}
  # else
  #   pushd "$1" > /dev/null
  # fi
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

ff() {
  local name="$1"
  shift
  local args="$@"
  find . -type f -iname "*${name}*" $@
}

fd() {
  local name="$1"
  shift
  local args="$@"
  find . -type d -iname "*${name}*" $@
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

alias apro="apropos"

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

docker_clean_images() {
  docker rmi $(docker images -q -f dangling=true)
}

docker_clean_containers() {
  docker rm $(docker ps -f status=dead -f status=exited -aq)
}

docker_clean_all() {
  docker_clean_containers
  docker_clean_images
}

docker_launch_machine() {
  docker-machine start
  eval "$(docker-machine env)"
  echo "Environment set."
}

lsps() {
  ps aux | grep -i "$1" | grep -v grep
}

lshs() {
  history | grep -i "$1" | grep -v lshs
}

suitup() {
  local suitup_file="$HOME/.tmuxinator/suitup/${HOSTNAME%%.*}"

  if [[ ! -f "$suitup_file" ]]; then
    echo "Suitup file does not exist: $suitup_file"
    return 1
  fi

  while read -r line; do
    mux "$line"
  done < "$suitup_file"

  exit
}

alias kill-tmux="tmux kill-session -a && tmux kill-session"

] () {
  if [[ $(which xdg-open) ]]; then
    xdg-open "$1"
  elif [[ $(uname) == "Darwin" && $(which open) ]]; then
    open "$1"
  fi
}

alias frak="fortune -c"
alias starwars="telnet towel.blinkenlights.nl"
alias nyan="telnet nyancat.dakko.us"
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


xclip-copy() {
  if os_is_mac; then
    pbcopy -pboard general
  else
    xclip -i -selection clip
  fi
}

xclip-paste() {
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
  sudo lsof -nP -sTCP:LISTEN -i"TCP:$1"
}

rebash() {
  exec bash -l
}

cask() {
  brew cask "$@"
}

icanhazip() {
  ifconfig | awk '
    /^[^[:space:]]/ { name = substr($1, 0, length($1) - 1) }
    /^[[:space:]]+inet / && name != "lo0" { print name " " $2 }
  '
  echo "external $(curl -s http://icanhazip.com/s)"
}

man() {
  local what="$(type -t "$1")"
  if [[ "$what" == "builtin" ]]; then
    help "$1"
  else
    /usr/bin/man "$1"
  fi
}

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
