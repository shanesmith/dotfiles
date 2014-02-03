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

"Command tab completion behaviour
set wildmode=longest,list

"Match words as we type a search string. We may be able to find the word we are looking for before being done typing.
set incsearch

"Highlight matched search
set hlsearch

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
set noshowmode

"Scroll offset
set scrolloff=5

"Split pane to right when :vsplit
set splitright

"What to show in character list
set listchars=tab:>-,trail:',eol:$

"Colorscheme
if &t_Co == 256 || has("gui_running")
  let g:aldmeris_transparent = 1
  try 
    colorscheme aldmeris
  catch
    colorscheme desert
  endtry
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
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_extensions=['funky', 'line']
let g:ctrlp_prompt_mappings = {
    \ 'ToggleType(1)':        ['<c-right>'],
    \ 'ToggleType(-1)':       ['<c-left>'],
    \ }
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\v\.(exe|so|dll|DS_Store)$'
      \ }

"LocalVimrc options
let g:localvimrc_sandbox=0
let g:localvimrc_persistent=1

"NeoComplete options
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#enable_auto_select = 1
let g:neocomplete#enable_insert_char_pre = 1
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"DelimitMate options
au FileType html let b:delimitMate_matchpairs = '(:),[:],{:}'
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

"ACK
nnoremap <leader>a :Ack! 
vnoremap <leader>a "hy:<C-U>Ack! <C-R>h

"XMLEdit
let g:xmledit_enable_html = 1

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

"Next/Previous result
nnoremap <F3> n
nnoremap <S-F3> N

"Tab commands
nnoremap <C-t> :tabnew<CR>
nnoremap <S-Right> :tabnext<CR>
nnoremap <S-Left> :tabprevious<CR>

"Show whitespace characters
nmap <Leader>s :set nolist!<CR>

"Stop accidentaly recording
nnoremap Q q
nmap q <nop>

"Visual select last pasted
"http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap gp `[v`]

"Paste from system clipboard
nnoremap <leader>v o<ESC>"+p
nnoremap <leader>V O<ESC>"+p
nnoremap <leader>C "+yy
vnoremap <leader>v "+p
vnoremap <leader>V "+p
vnoremap <leader>c "+y

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
inoremap jk <ESC>

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
nnoremap <Leader>t :NERDTreeToggle<CR> :NERDTreeMirror<CR>
let NERDTreeMapActivateNode = '<Right>'
let NERDTreeMapCloseDir = '<Left>'
let NERDTreeMapOpenSplit = 'h'
let NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeChDirMode = 2

"NERDCommenter
nmap \\ <Plug>NERDCommenterToggle
vmap \\ <Plug>NERDCommenterToggle
nmap \a <Plug>NERDCommenterAppend
vmap \a <Plug>NERDCommenterAppend
nmap \* <Plug>NERDCommenterMinimal
vmap \* <Plug>NERDCommenterMinimal

"NeoComplete mappings
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#close_popup()
inoremap <expr><C-e> neocomplete#cancel_popup()
inoremap <expr><C-l> neocomplete#complete_common_string()

"Smartwords
map w <Plug>(smartword-w)
map b <Plug>(smartword-b)
map e <Plug>(smartword-e)
map ge <Plug>(smartword-ge)

"Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0


"Colorizer
let g:colorizer_startup = 1
let g:colorizer_nomap = 1

"""
""" Custom ex commands
"""

"Clean out trailing whitespaces
command! CleanWhitespace %s/\s\+$//g

" Big W also writes
command! W w
command! Wq wq
command! WQ wq
command! Q q
cmap wQ wq

"""
""" AutoCmd
"""

" Auto load vimrc on save
" http://www.bestofvim.com/tip/auto-reload-your-vimrc/
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC,~/Code/rc/vimrc source $MYVIMRC
augroup END " }

" Close vim if NERDTree is the last window
augroup nerdtree_vimrc
  autocmd!
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup END
