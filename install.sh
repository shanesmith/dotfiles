#!/bin/bash

DOTFILES="bashrc bash_aliases gitconfig vimrc"

RCPATH="$(cd `dirname $0` && pwd)"

FORCE=

set_force() {
	FORCE='-f'
}

unset_force() {
	FORCE=
}

do_install() {
	local ret=0
	for file in $DOTFILES; do
			ln -s $FORCE "$RCPATH/$file" "$HOME/.$file"
			(( ret = ret || $? ))
	done
	return $ret
}

while [[ $# > 0 ]]; do
	case $1 in
		-f) set_force;;
	esac
	shift
done

do_install

SUCCESS=$?

if [[ ! $FORCE  ]] && [[ $SUCCESS != 0 ]]; then

	read -p "Some installations have failed since files already exist. Force? "

	if [[ $REPLY == "y" ]] || [[ $REPLY == "yes" ]]; then
		echo "Force installing..."
		set_force
		do_install
	fi

fi
