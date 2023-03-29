#!/bin/bash

# TODO
# - Install bash-sneak

DOTFILES=(
  bashrc
  bashrc.d
  bash_aliases
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
  lftprc
  pryrc
  irbrc
  config/alacritty
  config/karabiner
  config/nvim
  config/coc/extensions/package.json
  config/coc/extensions/yarn.lock
  config/gh/config.yml
)

LINUX_DOTFILES=(
  Xmodmap
)

if [[ $0 =~ (^|/)install\.sh$ ]]; then
  RCPATH="$(cd "$(dirname "$0")" && pwd)"
else
  RCPATH="${1:~$HOME/Code/rc}"
fi

is_linux() {
  [[ $(uname) == "Linux" ]]
}

is_mac() {
  [[ $(uname) == "Darwin" ]]
}

is_windows() {
  [[ $(uname) == MINGW.* ]]
}

is_spin() {
  [[ -n $SPIN ]]
}

get_src() {
  case "$file" in
    bashrc)
      if is_windows; then
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
      if is_windows; then
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

readlink_f() {
  # https://stackoverflow.com/a/24572274/1333402
  perl -MCwd -le 'print Cwd::abs_path shift' "$1"
}

install_fonts() {
  if is_mac; then
    cp "${RCPATH}"/fonts/* /Library/Fonts
  fi
}

link_dotfiles() {
  local src dest
  local all_files=( "${DOTFILES[@]}" )

  if is_linux; then
    all_files+=( "${LINUX_DOTFILES[@]}" )
  fi

  for file in "${all_files[@]}"; do
    src=$(get_src "$file")
    dest=$(get_dest "$file")

    if [[ -L $dest ]]; then
      if [[ $(readlink_f "$dest") == "$src" ]]; then
        echo "Already installed $file"
      else
        echo "Bad link location for $file"
        exit 1
      fi
    elif [[ -e $dest ]]; then
      echo "File already exists for $file"
      exit 1
    else
      echo "Installing $file"
      install_file "$src" "$dest"
    fi
  done
}

install_file() {
  local src="$1"
  local dest="$2"

  if is_windows; then
    rm -rf "$dest"
    cp -r "$src" "$dest"
  else
    mkdir -p "$(dirname "$dest")"
    ln -ns "$src" "$dest"
  fi
}

update_git_submodules() {
  git submodule update --init --recursive
}

install_vim_plugins() {
  command_exists pip && pip install neovim
  command_exists gem && gem install neovim
  command_exists npm && npm install -g neovim
  command_exists nvim && nvim --headless +PlugInstall +qall
}

chsh_bash() {
  local shell="/usr/bin/bash"

  if is_mac; then
    shell="$(brew --prefix)/bin/bash"
    grep -q "$shell" /etc/shells && sudo tee -a /etc/shells <<<"$shell" >/dev/null
  fi

  sudo chsh -s "$shell" "$USER"
}

install_homebrew() {
  local prefix

  if ! is_mac; then
    return
  fi

  if ! command_exists "brew"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ -e /opt/homebrew ]]; then
    prefix=/opt/homebrew
  else
    prefix=/usr/local
  fi

  # shellcheck source=/dev/null
  . <($prefix/bin/brew shellenv)
}

install_self() {
  if [[ -e $RCPATH/install.sh ]]; then
    return
  fi

  mkdir -p "$(dirname "$RCPATH")"
  git clone https://github.com/shanesmith/dotfiles.git "$RCPATH"
  git -C "$RCPATH" remote set-url origin git@github.com:shanesmith/dotfiles.git
}

install_brew_bundle() {
  if ! is_mac; then
    return
  fi

  brew bundle install
}

# install homebrew before self so that it
# also installs xclt for git
install_homebrew

install_self

install_brew_bundle

update_git_submodules

install_fonts

link_dotfiles

install_vim_plugins

chsh_bash
