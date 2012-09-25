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

"Always display status bar
set laststatus=2

"Match words as we type a search string. We may be able to find the word we are looking for before being done typing.
set incsearch

"Be smart about character case while searching
set ignorecase
set smartcase

"Line numbers
set number

"Backspace behaviour
set backspace=indent,eol,start

"Fix delete key
fixdel

"Pathogen plugin loading
call pathogen#infect()

"Syntax highlighting
syntax on

"File type detection and plugin loading
filetype plugin indent on

"Past toggle <F8>
nnoremap <F8> :set invpaste paste?<CR>
set pastetoggle=<F8>
set showmode

"Scroll offset
set scrolloff=5

"Split pane to right when :vsplit
set splitright

"Fix CommandT esc not working
let g:CommandTCancelMap = [ '<ESC>', '<C-c>' ]
let g:CommandTSelectNextMap = [ '<C-n>', '<C-j>', '<ESC>OB' ]
let g:CommandTSelectPreviousMap = [ '<C-p>', '<C-k>', '<ESC>OA' ]

"What to show in character list
set listchars=tab:>-,trail:',eol:$

"Custom leader commands
let mapleader = ","
nnoremap <Leader>w <C-w>
nmap <Leader>s :set nolist!<CR>
nnoremap Q q
nmap q <nop>
