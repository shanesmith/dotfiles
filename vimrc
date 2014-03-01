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

"Wrap at start/end of line
set whichwrap+=<,>,[,],h,l

"Remove toolbar from GUI vim
set guioptions-=T

"Let VIM figure out the indentation neede in C-style programs - when it can.
set smartindent
set autoindent

"VIM will show the corresponding opening and closing curly brace, bracket or parentesis.
set showmatch

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
  let g:aldmeris_css = 0
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
let maplocalleader = "|"


"""
""" Plugin options
"""

"CtrlP options
let g:ctrlp_map = "<leader>pp"
nnoremap <leader>p  :CtrlP<cr>
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
let g:neocomplete#enable_auto_select = 0
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
let g:syntastic_html_tidy_quiet_messages = {
      \   'regex': [
      \     '"tabindex" has invalid value "-1"',
      \     '<div> proprietary attribute "tabindex"',
      \     '<img> lacks "alt" attribute',
      \     'trimming empty <span>',
      \   ],
      \ }

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

"Maximizer
let g:maximizer_default_mapping_key = '<F4>'

"Notes
let g:notes_directories = ['~/Dropbox/notes']
let g:notes_suffix = ".txt"

function! s:emmet_expand_glyph(name)
  return "<span class='glyphicon ".a:name."'></span>"
endfunction

"Emmet
let g:emmet_html5 = 0
let g:user_emmet_settings = {
      \   'custom_expands': {
      \     '^glyphicon-\S\+$': function("<SID>emmet_expand_glyph")
      \   },
      \ }


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
nnoremap <S-Up> :move -2<CR>
nnoremap <S-Down> :move +1<CR>
vnoremap <S-Up> :move '<-2<CR>gv
vnoremap <S-Down> :move '>+1<CR>gv

"New lines
nnoremap <Leader><CR> i<CR><ESC>
nnoremap <Leader>o o<ESC>k
nnoremap <Leader>O O<ESC>j
vnoremap <Leader>o <ESC>`<dv`>i<CR><CR><ESC>kp`[v`]

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
nnoremap <Leader>t :NERDTreeToggle<CR>
let NERDTreeMapActivateNode = '<Right>'
let NERDTreeMapCloseDir = '<Left>'
let NERDTreeMapOpenSplit = 'h'
let NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeChDirMode = 2

"TComment
nmap \\ :TComment<CR>
vmap \\ :TComment<CR>
nmap \* :TCommentBlock<CR>
vmap \* :TCommentBlock<CR>

"NeoComplete mappings
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? neocomplete#smart_close_popup() : "\<CR>"
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

"Bash style command line
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

"Easier line start/end movement
nnoremap H ^
vnoremap H ^
onoremap H ^
nnoremap L $
vnoremap L $
onoremap L $

"Next/Previous quick fix
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>

"Toggle relative line numbers
nnoremap <leader>l :set relativenumber!<CR>

"Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#branch#enabled = 0

"Colorizer
let g:colorizer_startup = 1
let g:colorizer_nomap = 1

"Gundo
nnoremap <leader>u :GundoToggle<CR>

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
command! Qa qa
command! QA qa

"Super ReTab
command! -range=% -nargs=0 Tab2Space execute '<line1>,<line2>s#^\t\+#\=repeat(" ", len(submatch(0))*' . &ts . ')'
command! -range=% -nargs=0 Space2Tab execute '<line1>,<line2>s#^\( \{'.&ts.'\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')'

"""
""" AutoCmd
"""

" Auto load vimrc on save
" http://www.bestofvim.com/tip/auto-reload-your-vimrc/
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC,~/Code/rc/vimrc source $MYVIMRC | if (exists('g:loaded_airline') && g:loaded_airline) | call airline#load_theme() | endif
augroup END " }

" Close vim if NERDTree is the last window
augroup nerdtree_vimrc
  autocmd!
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup END

" Show cursorline only on current window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

augroup EmmetMappings
  au!
  au FileType html,css imap <C-Y>Y <plug>(EmmetExpandAbbr)
  au FileType html,css imap <C-Y><C-Y> <plug>(EmmetExpandAbbr)
  au FileType html,css vmap <C-Y>Y <plug>(EmmetExpandAbbr)
  au FileType html,css vmap <C-Y><C-Y> <plug>(EmmetExpandAbbr)
  au FileType html,css nmap <C-Y>Y <plug>(EmmetExpandAbbr)
  au FileType html,css nmap <C-Y><C-Y> <plug>(EmmetExpandAbbr)
augroup END
