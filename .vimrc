"set autoindent
set tabstop=2
set shiftwidth=2
"Let's make sure that all the annoying bugs in VI are not displayed in VIM.
set nocompatible
"Let VIM figure out the indentation neede in C-style programs - when it can.
set smartindent
"VIM will show the corresponding opening and closing curly brace, bracket or parentesis.
set showmatch
"Display the status bar at the bottom
set ruler
"Match words as we type a search string. We may be able to find the word we are looking for before being done typing.
set incsearch
syntax on
set backspace=indent,eol,start
fixdel
filetype plugin on
"au BufNewFile BufRead *.j set filetype=js
