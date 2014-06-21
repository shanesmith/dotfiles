#!/bin/bash

DOTFILES="bashrc bash_aliases bashrc-sshlogin gitconfig gitignore vimrc vim gvimrc ackrc inputrc colordiffrc fzf npmrc agignore"

is_linux=
is_mac=
is_windows=

case $(uname) in
  Linux)
    is_linux="yes"
    ;;
  Darwin)
    is_mac="yes"
    ;;
  MINGW*)
    is_windows="yes"
    ;;
esac

RCPATH="$(cd `dirname $0` && pwd)"

FORCE=

set_force() {
  FORCE='-f'
}

unset_force() {
  FORCE=
}

get_src() {
  case "$file" in

    bashrc)
      if [[ "$is_windows" ]]; then
        echo "$RCPATH/bashrc_msys"
        exit
      fi
      ;;

    fzf)
      echo "$RCPATH/fzf/fzf"
      exit
      ;;

  esac

  echo "$RCPATH/$file"
}

get_dest() {
  local file="$1"
  if [[ "$is_windows" ]]; then
    case "$file" in
      vim)
        echo "$HOME/vimfiles"
        exit
        ;;
    esac
  fi

  echo "$HOME/.$file";
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

is_link_to() {

  local from="$1"
  local to="$2"
  
  if [[ -n $is_mac ]]; then
    if command_exists "greadlink"; then
      [[ $(greadlink -f "$from") == $src ]]
    else
      [[ $(readlink "$from") == $src ]]
    fi
    return $?
  else
    [[ $(readlink -f "$from") == $src ]]
    return $?
  fi

}

do_install() {
  local ret=0
  for file in $DOTFILES; do
    local src=$(get_src "$file")
    local dest=$(get_dest "$file")
    if [[ -L $dest && -z $FORCE ]]; then
      if is_link_to "$dest" "$src"; then
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
      install_file "$src" "$dest"
    fi
  done
  return $ret
}

install_file() {
  local src="$1"
  local dest="$2"
  if [[ "$is_windows" ]]; then
    rm -rf "$dest"
    cp -r "$src" "$dest"
  else
    ln -ns $FORCE "$src" "$dest"
  fi
}

while [[ $# > 0 ]]; do
  case $1 in
    -f) set_force;;
  esac
  shift
done

if [[ -n $is_mac ]] && ! command_exists "greadlink"; then
  echo "Mac detected without \`greadlink\`, if this install does something wrong you might need to \`brew install coreutils\`."
fi

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
