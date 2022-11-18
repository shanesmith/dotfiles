#!/bin/bash

DOTFILES="
  bashrc
  bash_help
  bash_ps1
  bash_aliases
  bash_sshauth
  bash_readline
  bash_profile
  gitconfig
  gitconfig.shopify
  gitconfig.podman
  gitignore
  gitmessage
  vimrc
  vim
  ackrc
  inputrc
  colordiffrc
  ignore
  tmux.conf
  tmux
  bin
  tmuxinator
  tern-config
  lftprc
  pryrc
  irbrc
  config/alacritty
  config/karabiner
  config/nvim
  config/coc/extensions/package.json
  config/coc/extensions/yarn.lock
  config/gh/config.yml
"

LINUX_DOTFILES="Xmodmap"

is_linux=
is_mac=
is_windows=

case $(uname) in
  Linux)
    is_linux="yes"
    DOTFILES="$DOTFILES $LINUX_DOTFILES"
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

  esac

  echo "$RCPATH/$file"
}

get_dest() {
  local file="$1"

  case "$file" in 

    vim)
      if [[ "$is_windows" ]]; then
        echo "$HOME/vimfiles"
        exit
      fi
      ;;

    bin)
      echo "$HOME/bin"
      exit
      ;;

  esac

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

install_fonts() {
  if [[ -n $is_mac ]]; then
    cp "${RCPATH}"/fonts/* /Library/Fonts
  fi
}

link_dotfiles() {
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
    mkdir -p $(dirname $dest)
    ln -ns $FORCE "$src" "$dest"
  fi
}

update_git_submodules() {
  git submodule update --init --recursive
}

install_vim_plugins() {
  if command_exists "nvim"; then
    nvim --headless +PlugInstall +qall
  fi
}

chsh_bash() {
  if [[ -n $SPIN ]]; then
    sudo chsh -s /usr/bin/bash spin
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

update_git_submodules

install_fonts

link_dotfiles

install_vim_plugins

chsh_bash
