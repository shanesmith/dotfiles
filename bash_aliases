#!/bin/bash
#
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

bak() {
  cp -ai $1{,.bak$2}
}

mvbak() {
  mv -i $1{,.bak$2}
}

alias h="cd ~"
alias ..="cd .."
alias ...="cd ../.."
cs() {
  cd "$1" && ls
}
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
  if echo "$1" | egrep -q "^-+$"; then
    g ${#1}
  else
    pushd "$1" > /dev/null
  fi
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
  local dir=$(d 0 | awk -v line=$num 'NR==line+1 { $1=""; print $0; exit }')
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

alias jg="jobs"
alias kg="kill %1"

lsps() {
  ps aux | grep -i $1 | grep -v grep
}

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
alias busy="cat /dev/urandom | hexdump -C | grep --color 'ca fe'"
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
  grep -o "^deb http://ppa.launchpad.net/[a-z0-9-]\+/[a-z0-9.-]\+" $APT | while read ENTRY ; do
  USER=`echo $ENTRY | cut -d/ -f4`
  PPA=`echo $ENTRY | cut -d/ -f5`
  echo ppa:$USER/$PPA
done
  done
}
remove-old-kernels() {
local KEEP=1
local PURGE=
local CANDIDATES=$(ls -tr /boot/vmlinuz-* | grep -v "$(uname -r)$" | head -n -1 | cut -d- -f2- | awk '{print "linux-image-" $0}')
for c in $CANDIDATES; do
  dpkg-query -s "$c" >/dev/null 2>&1 && PURGE="$PURGE $c"
done

if [ -z "$PURGE" ]; then
  echo "No kernels are eligible for removal"
  exit 0
fi

sudo apt-get $APT_OPTS remove --purge $PURGE
}

alias xclip-copy="xclip -i -selection clip"
alias xclip-paste="xclip -o -selection clip"

alias vv="vagrant"

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

fzf() {
  ruby --disable-gems ~/.fzf "$@"
}

fd() {
  DIR=$(find ${1:-*} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf) && cd "$DIR"
}

fda() {
  DIR=$(find ${1:-.} -type d 2> /dev/null | fzf) && cd "$DIR"
}

fh() {
  eval $(history | fzf +s | sed 's/ *[0-9]* *//')
}

__fsel() {
  find * -path '*/\.*' -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | fzf -m | while read item; do printf '%q ' "$item"; done
  echo
}

# FZF Key bindings
# ----------------
if [[ $- =~ i ]]; then

  # Required to refresh the prompt after fzf
  bind '"\er": redraw-current-line'

  # CTRL-T - Paste the selected file path into the command line
  bind '"\C-t": " \C-u \C-a\C-d$(__fsel)\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er"'

  # CTRL-R - Paste the selected command from history into the command line
  bind '"\C-r": " \C-e\C-u$(HISTTIMEFORMAT= history | fzf +s | sed \"s/ *[0-9]* *//\")\e\C-e\er"'

fi
