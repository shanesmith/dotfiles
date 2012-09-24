#!/bin/bash

DOTFILES="bashrc bash_aliases gitconfig vimrc vim"

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
			local src="$RCPATH/$file"
			local dest="$HOME/.$file"
			if [[ -L $dest && -z $FORCE ]]; then
				if [[ $(readlink -f "$dest") == $src ]]; then
					echo "Already installed $file"
				else
					echo "Link already exists for $file"
					ret=1
				fi
			elif [[ -e $dest && -z $FORCE ]]; then
				echo "File already exists for $file"
				ret=1
			else
				echo "Installing $file"
				ln -Ts $FORCE "$src" "$dest"
			fi
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
	else
		echo "Install canceled"
	fi

fi
