"Let's make sure that all the annoying bugs in VI are not displayed in VIM.
set nocompatible

"set autoindent
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

"Viminfo
set viminfo+=!

"Enable mouse
set mouse=a

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
let g:CommandTAcceptSelectionMap = ['<C-o>', '<C-M>']
let g:CommandTAcceptSelectionVSplitMap = ['<CR>']

"LocalVimrc options
let g:localvimrc_sandbox=0
let g:localvimrc_persistent=1

"What to show in character list
set listchars=tab:>-,trail:',eol:$

""" 
""" Custom leader commands
"""

let mapleader = ","

"Window commands
nmap <Leader>w <C-w>
noremap <C-Right> <C-w><Right>
noremap <C-Left> <C-w><Left>
noremap <C-Down> <C-w><Down>
noremap <C-Up> <C-w><Up>

"Tab commands
nmap <C-t> :tabnew<CR>

"Show whitespace characters
nmap <Leader>s :set nolist!<CR>

"Stop accidentaly recording
nnoremap Q q
nmap q <nop>

"Visual select last pasted
"http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

"Stamp word (replace current word with last delete/yank)
nnoremap S diw"0P

"""
""" Custom ex commands
"""

"Clean out trailing whitespaces
command! CleanWhitespace %s/\s\+$//g
