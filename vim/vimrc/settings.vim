
" Let's make sure that all the annoying bugs in VI are not displayed in VIM.
set nocompatible

"Faster ESC timeout
set timeout ttimeoutlen=100

set title
if &term == "screen-256color"
  set t_ts=]2;
  set t_fs=\\
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

"set autoindent
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

"set modelines enabled
set modeline
set modelines=5

"Viminfo
set viminfo+=!

"Enable mouse
set mouse=a

"Wrap at start/end of line
set whichwrap+=<,>,[,],h,l

"Don't fold... ever...
set nofoldenable

"Remove toolbar from GUI vim
set winaltkeys=no
set guioptions-=T
set guioptions+=c
if has("gui_macvim")
  set macmeta
  set guifont=Droid_Sans_Mono_for_Powerline:h11
elseif has("gui_gtk2")
  set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 10
endif

"Let VIM figure out the indentation neede in C-style programs - when it can.
set smartindent
set autoindent
set copyindent

"VIM will show the corresponding opening and closing curly brace, bracket or parentesis.
set showmatch
set matchtime=1

"Show incomplete command
set showcmd

"No preview window
set completeopt-=preview

"Display the status bar at the bottom
set ruler

"Faster drawing... apparently...
set lazyredraw

"Mostly for a better maximizer
set winminwidth=0
set winminheight=0

"Error bell
set noerrorbells
if has("gui_macvim")
  set visualbell
else
  set novisualbell
endif
set t_vb=

"Always display tab and status bar
set laststatus=2
set showtabline=2

"Show cursorline
set cursorline

"Command tab completion behaviour
set wildmode=longest,list

"Match words as we type a search string. We may be able to find the word we are looking for before being done typing.
set incsearch

"Highlight matched search
set hlsearch

"Default global substitute
set gdefault

"Be smart about character case while searching
set ignorecase
set smartcase

"Line numbers
set number

"Add matching pairs for %
set matchpairs+=<:>

"Backspace behaviour
set backspace=indent,eol,start

"Directories
set directory^=~/.vim/swaps//
set backupdir^=~/.vim/backups//
set undodir=~/.vim/undodir//

"Persistent undo file
set undofile

if !has('nvim')
  "Fix delete key
  fixdel
endif

"Syntax highlighting
syntax on

"File type detection and plugin loading
filetype plugin indent on

"Past toggle <F8>
nnoremap <F8> :set invpaste paste?<CR>
set pastetoggle=<F8>
set noshowmode

"Scroll offset
set scrolloff=5

"Split pane to right when :vsplit
set splitright

"Don't highlight long lines
set synmaxcol=800

"What to show in character list
set listchars=tab:>-,trail:',eol:$

"Paste from system clipboard
set clipboard=unnamed,unnamedplus

if has("gui_gtk2")
  set lines=999 columns=999
endif

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

"Set leader character
let mapleader = "\<Space>"
let maplocalleader = "|"
