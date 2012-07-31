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

"Be smart about character case while searching
set ignorecase
set smartcase

"Syntax highlighting
syntax on

"Line numbers
set number

"Backspace behaviour
set backspace=indent,eol,start

"Fix delete key
fixdel

"File type detection and plugin loading
filetype plugin on

"Past toggle <F8>
nnoremap <F8> :set invpaste paste?<CR>
set pastetoggle=<F8>
set showmode

"Scroll offset
set scrolloff=5

"Split pane to right when :vsplit
set splitright
