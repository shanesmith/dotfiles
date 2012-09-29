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
	local x=''; for i in $(seq ${1:-1}); do x="$x../"; done; cd $x; 
}
mkcd() {
    mkdir "$1" && cd "$1"
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

alias apt-search="apt-cache search"
alias apt-show="apt-cache show"
alias apt-showpkg="apt-cache showpkg"
alias apt-install="sudo apt-get install"
alias apt-update="sudo apt-get update"
alias apt-upgrade="sudo apt-get update && sudo apt-get upgrade"
alias apt-dist-upgrade="sudo apt-get update && sudo apt-get dist-upgrade"

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
