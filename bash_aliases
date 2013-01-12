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

alias h="cd ~"
alias ..="cd .."
alias ...="cd ../.."
cs() { 
  cd "$1" && ls 
}
up() { 
  local x='' 
  local num=${1:-1}
  for (( i=0; i < $num; i++ )); do 
    x="$x../" 
  done 
  cd $x 
}
mkcd() {
  mkdir "$1" && cd "$1"
}
cd() {
  if [[ $1 =~ ^-+$ ]]; then
    g ${#1}
  else
    pushd "$1" > /dev/null
  fi
}
d() {
  local num=10
  local search=

  if [[ $# -ge 1 ]]; then
    if [[ $1 =~ [0-9]+ ]]; then
      local num=$1
    else
      local search=$1
    fi

    if [[ $# -ge 2 ]]; then
      if [[ $2 =~ [0-9]+ ]]; then
        local num=$2
      else
        local search=$2
      fi
    fi
  fi

  dirs -v | sort -k 2 -u | sort --numeric -k 1 | awk -v max=$num -v search="$search" 'BEGIN { lines = 0 } search=="" || tolower($0) ~ tolower(search) { printf "%2s  %s\n", NR-1, $2; lines++ } lines == max && max != 0 { exit }'
}
g() {
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
  local dir=$(d 0 | awk -v line=$num 'NR==line+1 { print $2; exit }')
  eval cd "$dir"
}

ff() {
  local name="$1"
  find . -type f -iname "*${name}*"
}

fd() {
  local name="$1"
  find . -type d -iname "*${name}*"
}

date2timestamp() {
  date --date="$1" +%s
}

timestamp2date() {
  date --date="@$1"
}

alias apro="apropos"

alias whoareyou="uname -a"

alias svim="sudo vim"

alias hs="history"

] () {
  if [[ $(which xdg-open) ]]; then
    xdg-open "$1"
  elif [[ $(uname) == "Darwin" && $(which open) ]]; then
    open "$1"
  fi
}

alias frak="fortune -c"
alias starwars="telnet towel.blinkenlights.nl"
alias nyan="telnet miku.acm.uiuc.edu"
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
alias matrix='echo -e "\e[32m"; while :; do for i in {1..16}; do r="$(($RANDOM % 2))"; if [[ $(($RANDOM % 2)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r   "; else v+="\e[2m $r   "; fi; else v+="     "; fi; done; echo -e "$v"; v=""; sleep 0.001; done;'

alias apt-search="apt-cache search"
alias apt-show="apt-cache show"
alias apt-showpkg="apt-cache showpkg"
alias apt-install="sudo apt-get install"
alias apt-update="sudo apt-get update"
alias apt-upgrade="sudo apt-get update && sudo apt-get upgrade"
alias apt-dist-upgrade="sudo apt-get update && sudo apt-get dist-upgrade"
apt-list-ppa() {
    for APT in `find /etc/apt/ -name *.list`; do
      grep -o "^deb http://ppa.launchpad.net/[a-z0-9\-]\+/[a-z0-9\-]\+" $APT | while read ENTRY ; do
          USER=`echo $ENTRY | cut -d/ -f4`
          PPA=`echo $ENTRY | cut -d/ -f5`
          echo ppa:$USER/$PPA
      done
  done
}

alias xclip-copy="xclip -i -selection clip"
alias xclip-paste="xclip -o -selection clip"

gittop() { 
  cd $(git top)
}

alias httphp="php -S 127.0.0.1:8080"
alias httpython="python -m SimpleHTTPServer 8080"

# the space allows for aliases...
# https://wiki.archlinux.org/index.php/Sudo#Passing_aliases
alias sudo='sudo '
