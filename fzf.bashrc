# Setup fzf function
# ------------------
unalias fzf 2> /dev/null
fzf() {
  /usr/bin/ruby --disable-gems /Users/ssmith/Code/fzf/fzf "$@"
}
export -f fzf > /dev/null

# Auto-completion
# ---------------
# source /Users/ssmith/Code/fzf/fzf-completion.bash

