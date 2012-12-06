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

"What to show in character list
set listchars=tab:>-,trail:',eol:$

"""
""" Plugin options
"""

"CtrlP options
let g:ctrlp_map = "<leader>p"
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 50
let g:ctrlp_tabpage_position = 'al'
let g:ctrlp_working_path_mode = 'rwa'
let g:ctrlp_prompt_mappings = {
    \ 'ToggleType(1)':        ['<c-right>'],
    \ 'ToggleType(-1)':       ['<c-left>'],
    \ }


"LocalVimrc options
let g:localvimrc_sandbox=0
let g:localvimrc_persistent=1

"NeoComplCache options]
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"DelimitMate options
let g:delimitMate_expand_space = 1

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
nnoremap gp `[v`]

"Stamp word (replace current word with last delete/yank)
nnoremap S diw"0P


"""
""" Custom ex commands
"""

"Clean out trailing whitespaces
command! CleanWhitespace %s/\s\+$//g
