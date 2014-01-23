"Let's make sure that all the annoying bugs in VI are not displayed in VIM.
set nocompatible

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

"Remove toolbar from GUI vim
set guioptions-=T

"Let VIM figure out the indentation neede in C-style programs - when it can.
set smartindent

"VIM will show the corresponding opening and closing curly brace, bracket or parentesis.
set showmatch

"Display the status bar at the bottom
set ruler

"Error bell
set noerrorbells
set visualbell
set t_vb=

"Always display tab and status bar
set laststatus=2
set showtabline=2

"Match words as we type a search string. We may be able to find the word we are looking for before being done typing.
set incsearch

"Highlight matched search
set hlsearch

"Be smart about character case while searching
set ignorecase
set smartcase

"Line numbers
set number

"Backspace behaviour
set backspace=indent,eol,start

"Directories
set directory^=~/.vim/swaps//
set backupdir^=~/.vim/backups//

"Fix delete key
fixdel

"Drupal
augroup module
  autocmd BufRead,BufNewFile *.module set filetype=php
  autocmd BufRead,BufNewFile *.profile set filetype=php
  autocmd BufRead,BufNewFile *.install set filetype=php
  autocmd BufRead,BufNewFile *.inc set filetype=php
augroup end

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

"Colorscheme
if &t_Co == 256 || has("gui_running")
  let g:aldmeris_transparent = 1
  colorscheme aldmeris
else
  colorscheme desert
endif

"Set leader character
let mapleader = ","


"""
""" Plugin options
"""

"CtrlP options
let g:ctrlp_map = "<leader>pp"
nnoremap <leader>pf :CtrlPFunky<cr>
nnoremap <leader>pl :CtrlPLine<cr>
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_height = 50
let g:ctrlp_tabpage_position = 'al'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_extensions=['funky', 'line']
let g:ctrlp_prompt_mappings = {
    \ 'ToggleType(1)':        ['<c-right>'],
    \ 'ToggleType(-1)':       ['<c-left>'],
    \ }

"LocalVimrc options
let g:localvimrc_sandbox=0
let g:localvimrc_persistent=1

"NeoComplCache options
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_enable_insert_char_pre = 1
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
let g:neosnippet#snippets_directory='~/.vim/bundle/honza-snippets/snippets'
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"DelimitMate options
let g:delimitMate_expand_space = 1

"Syntastic options
let g:syntastic_check_on_open = 1
let g:syntastic_objc_compiler = 'clang'

"DBGPavim
let g:dbgPavimPort = 9009
let g:dbgPavimBreakAtEntry = 0
noremap <silent> <Leader>b :Bp<CR>

"Signify
highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227

"JSON
let g:vim_json_syntax_conceal = 0

""" 
""" Custom mappings
"""

"Window commands
nmap <Leader>w <C-w>
noremap <C-Right> <C-w><Right>
noremap <C-Left> <C-w><Left>
noremap <C-Down> <C-w><Down>
noremap <C-Up> <C-w><Up>

"Search commands
""Highlight current word
nnoremap <silent> <Leader>/ :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR>
nnoremap <silent> <2-LeftMouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR>
""Clear search (and Highlight)
nnoremap <silent> <Leader>\ :let @/=""<CR>

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

"Map U to redo
nnoremap U :redo<CR>

"Move lines up/down
nnoremap <S-Up> dd<Up>P
nnoremap <S-Down> ddp
vnoremap <S-Up> d<Up>P`[V`]
vnoremap <S-Down> dp`[V`]

"New lines
nnoremap <Leader><CR> i<CR><ESC>
nnoremap <Leader>o o<ESC>
nnoremap <Leader>O O<ESC>

"Better escape
inoremap jj <ESC>

"Text-object for matching whole-line pairs
vnoremap <silent> A{ :normal [{V%<CR>
vnoremap <silent> A} :normal [{V%<CR>
vnoremap <silent> A( :normal [(V%<CR>
vnoremap <silent> A) :normal [(V%<CR>
vnoremap <silent> A[ :call searchpair('\[', '', '\]', 'bW') \| normal V%<CR>
vnoremap <silent> A] :call searchpair('\[', '', '\]', 'bW') \| normal V%<CR>
onoremap <silent> A{ :normal [{V%<CR>
onoremap <silent> A} :normal [{V%<CR>
onoremap <silent> A( :normal [(V%<CR>
onoremap <silent> A) :normal [(V%<CR>
onoremap <silent> A[ :call searchpair('\[', '', '\]', 'bW') \| normal V%<CR>
onoremap <silent> A] :call searchpair('\[', '', '\]', 'bW') \| normal V%<CR>

"Toggle NERDTree
nnoremap <Leader>t :NERDTreeToggle<CR>
let NERDTreeMapActivateNode = '<Right>'
let NERDTreeMapCloseDir = '<Left>'
let NERDTreeMapOpenSplit = 'h'
let NERDTreeMapOpenVSplit = 'v'

"NERDCommenter
nmap \\ <Plug>NERDCommenterToggle
vmap \\ <Plug>NERDCommenterToggle
nmap \a <Plug>NERDCommenterAppend
vmap \a <Plug>NERDCommenterAppend
nmap \* <Plug>NERDCommenterMinimal
vmap \* <Plug>NERDCommenterMinimal

"NeoCompleCache mappings
function! s:neocomplcache_exists()
  return exists(":NeoComplCacheEnable") == 2
endfunction
inoremap <expr><TAB> pumvisible() && <SID>neocomplcache_exists() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() && <SID>neocomplcache_exists() ? "\<C-p>" : "\<TAB>"
inoremap <expr><CR> pumvisible() && <SID>neocomplcache_exists() ? neocomplcache#close_popup() : "\<CR>"
inoremap <expr><s-CR> pumvisible() && <SID>neocomplcache_exists() ? neocomplcache#close_popup()"\<CR>" : "\<CR>"
inoremap <expr><BS>  <SID>neocomplcache_exists() ? neocomplcache#smart_close_popup()."\<C-h>" : "\<BS>"
inoremap <expr><C-y> <SID>neocomplcache_exists() ? neocomplcache#close_popup() : "\<C-y>"
inoremap <expr><C-g> <SID>neocomplcache_exists() ? neocomplcache#undo_completion() : "\<C-g>"
inoremap <expr><C-l> <SID>neocomplcache_exists() ? neocomplcache#complete_common_string() : "\<C-l>"

"NeoSnippets
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
imap <expr><TAB> <SID>neocomplcache_exists() && neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> <SID>neocomplcache_exists() && neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

"Smartwords
map w <Plug>(smartword-w)
map b <Plug>(smartword-b)
map e <Plug>(smartword-e)
map ge <Plug>(smartword-ge)

"Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0

"""
""" Custom ex commands
"""

"Clean out trailing whitespaces
command! CleanWhitespace %s/\s\+$//g

" Big W also writes
command! W w
command! Wq wq
command! WQ wq
