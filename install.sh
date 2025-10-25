#!/bin/bash

# TODO
# - Install bash-sneak
# - Accept target (link files, brew bundle...)
# - Open newly installed apps (BTT, Karabiner, Ferdium...)

set -eo pipefail

DOTFILES=(
  bashrc
  bashrc.d
  bash_aliases
  bash_profile
  blerc
  gitconfig
  gitconfig.clio
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
  rbenv/version
  Library/Application\ Support/Cursor/User/settings.json
)

LINUX_DOTFILES=(
  Xmodmap
)

RCPATH="$HOME/Code/rc"

is_linux() {
  [[ $(uname) == "Linux" ]]
}

is_mac() {
  [[ $(uname) == "Darwin" ]]
}

is_windows() {
  [[ $(uname) == MINGW.* ]]
}

get_src() {
  case "$file" in
    bashrc)
      if is_windows; then
        echo "$RCPATH/bashrc_msys"
        return
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
        return
      fi
      ;;
    bin)
      echo "$HOME/bin"
      return
      ;;
    Library/*)
      echo "$HOME/$file"
      return
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
  if ! is_mac; then
    return
  fi

  echo "👾 Installing fonts..."
  cp "${RCPATH}"/fonts/* /Library/Fonts
}

link_dotfiles() {
  local src dest
  local all_files=( "${DOTFILES[@]}" )

  echo "👾 Linking dotfiles..."

  if is_linux; then
    all_files+=( "${LINUX_DOTFILES[@]}" )
  fi

  for file in "${all_files[@]}"; do
    src=$(get_src "$file")
    dest=$(get_dest "$file")
    orig_bk="${dest}.orig"

    if [[ -L $dest ]]; then
      if [[ $(readlink_f "$dest") == "$src" ]]; then
        echo "Already installed $file"
        continue
      else
        echo "Bad link location for $file, backing up to $orig_bk"
        mv "$dest" "$orig_bk"
      fi
    elif [[ -e $dest ]]; then
      echo "File already exists for $file, backing up to $orig_bk"
      mv "$dest" "$orig_bk"
    fi

    echo "Installing $file"
    install_file "$src" "$dest"
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

install_vim_plugins() {
  echo "👾 Installing VIM Plugins..."

  [[ -e ~/.venv/bin/pip ]] && ~/.venv/bin/pip install pynvim
  command_exists gem && gem install neovim
  command_exists npm && npm install -g neovim
  command_exists nvim && nvim --headless +PlugInstall +qall
}

chsh_bash() {
  local shell="/usr/bin/bash"

  echo "👾 Changing shell to BASH..."

  if is_mac; then
    shell="$(brew --prefix)/bin/bash"
    grep -q "$shell" /etc/shells || sudo tee -a /etc/shells <<<"$shell" >/dev/null
  fi

  sudo chsh -s "$shell" "$USER"
}

install_homebrew() {
  local prefix

  if ! is_mac; then
    return
  fi

  echo "👾 Installing Homebrew..."

  if [[ $(uname -m) == "arm64" ]]; then
    prefix=/opt/homebrew
  else
    prefix=/usr/local
  fi

  if ! [[ -e ${prefix}/bin/brew ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "👾 ...Homebrew already exists!"
  fi

  # shellcheck source=/dev/null
  eval "$($prefix/bin/brew shellenv)"
}

install_self() {
  if [[ -e $RCPATH/install.sh ]]; then
    return
  fi

  echo "👾 Installing self..."

  mkdir -p "$(dirname "$RCPATH")"
  git clone https://github.com/shanesmith/dotfiles.git "$RCPATH"
}

install_brew_bundle() {
  if ! is_mac; then
    return
  fi

  echo "👾 Installing Brew Bundles..."

  brew bundle install
}

install_ruby() {
  echo "👾 Installing Ruby..."
  rbenv install --skip-existing $(cat $RCPATH/rbenv/version)
  eval "$(rbenv init -)"
}

install_python_venv() {
  echo "👾 Installing Python VENV..."
  python3 -m venv ~/.venv
}

create_common_dirs() {
  echo "👾 Creating common dirs..."
  mkdir -p ~/.ssh ~/tmp ~/Code/tmp
  chmod 700 ~/.ssh
}

set_preferences() {
  if ! is_mac; then
    return
  fi

  echo "👾 Setting macOS Preferences..."

  "$RCPATH"/mac-prefs.sh
}

# install homebrew before self so that it
# also installs xclt for git
install_homebrew

install_self

cd "$RCPATH"

install_brew_bundle

install_fonts

link_dotfiles

install_ruby

install_python_venv

install_vim_plugins

create_common_dirs

chsh_bash

set_preferences

echo "👾 DONE! 👾"
