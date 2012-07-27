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

alias frak="fortune -c"

alias apt-search="apt-cache search"
alias apt-show="apt-cache show"
alias apt-showpkg="apt-cache showpkg"
alias apt-install="sudo apt-get install"
alias apt-update="sudo apt-get update"
alias apt-upgrade="sudo apt-get upgrade"

alias xclip-copy="xclip -i -selection clip"
alias xclip-paste="xclip -o -selection clip"

gittop() { 
	cd $(git top)
}
