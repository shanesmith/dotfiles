#!/bin/bash

THIS="$(basename $0)"

THISDIR="$(cd $(dirname $0) && pwd)"


###
### Filters
###

unbom() {
  # removes BOM from UTF-8 files
  local file="$1"

  if [[ -f $file && $(head -c 3 $file) == $'\xEF\xBB\xBF' ]]; then
    mv $file $file.bak
    tail -c +4 $file.bak > $file
  fi
}

lowercase() {
  echo "$1" | tr '[A-Z]' '[a-z]'
}

uppercase() {
  echo "$1" | tr '[a-z]' '[A-Z]'
}

trim() {
  local var

  if [[ $# -eq 0 ]]; then
    read -r var
  else
    var="$*"
  fi

  var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters

  echo -n "$var"
}


###
### Checks
###

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

eq_regexp() {
  # compatibility replacement for [[ a =~ b ]]
  local string="$1" regexp="$2"
  echo "$string" | grep -qE "$regexp"
}

array_contains() {
  # array_contains "needle" "${haystack[@]}"
  # $1 is needle
  # #2+ is haystack
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}


###
### User prompting
###

ask() {

	local question=$1 default=$2

	if [[ -n $default ]]; then
		question="$question [$default]"
	fi

	read -rp "$question "

	if [[ -z $REPLY ]]; then
		REPLY="$default"
	fi

}

confirm() {

  local question=$1 default=$(lowercase "$2")

  if [[ $default == "y" ]]; then
    prompt="[Y/n]"
  elif [[ $default == "n" ]]; then
    prompt="[y/N]"
  else
    die "WHAT?! confirm doesn't know '$default'"
  fi

	while true; do

		ask "$question $prompt "

		REPLY=$(lowercase "$REPLY")

		if [[ $REPLY == "yes" ]]; then
			REPLY=y
		elif [[ $REPLY == "no" ]]; then
			REPLY=n
    elif [[ -z $REPLY ]]; then
      REPLY="$default"
		fi

		if [[ $REPLY =~ [yn] ]]; then
			break
		fi

	done

}

die() {
	echo -e "${@}"
	exit
}


###
### Git
###

git_in_repo() {
  # whether pwd is in a git repo
	git rev-parse --git-dir >/dev/null 2>&1
}

git_current_branch() {
  git symbolic-ref --quiet --short HEAD
}

git_branch_exists() {
  git show-ref --verify --quiet refs/heads/"$1"
}

git_current_hash() {
  git rev-list --max-count=1 HEAD
}

git_dir() {
  git rev-parse --git-dir
}


###
### OS Detection
###

os_is_mac() {
  [[ $(uname -s) == "Darwin" ]]
}

os_is_linux() {
  [[ $(uname -s) == "Linux" ]]
}

os_is_windows() {
  # MSYSGIT
  [[ $(uname -s) =~ MINGW* ]]
}


###
### SSH
###

ssh_start() {
  local host="$1"
  ssh -S "/tmp/%r@%h:%p.conn" -MNf "$host"
}

ssh_command() {
  local host="$1" command="$2"
  ssh -S "/tmp/%r@%h:%p.conn" -n "$host" "$command"
}

ssh_stop() {
  local host="$1"
  ssh -S "/tmp/%r@%h:%p.conn" -qn -O exit "$host"
}
