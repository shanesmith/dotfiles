"Let's make sure that all the annoying bugs in VI are not displayed in VIM.
set nocompatible

"Faster ESC timeout
set timeout ttimeoutlen=100

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
set winaltkeys=no
set guioptions-=T

"Let VIM figure out the indentation neede in C-style programs - when it can.
set smartindent
set autoindent
set copyindent

"VIM will show the corresponding opening and closing curly brace, bracket or parentesis.
set showmatch
set matchtime=1

"Show incomplete command
set showcmd

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

hi CursorLine ctermbg=234 guibg=#404040
hi conflictOurs term=bold cterm=bold ctermfg=64 ctermbg=0 gui=bold guifg=#4e9a06 guibg=#000
hi conflictTheirs term=reverse cterm=bold ctermfg=74 ctermbg=0 gui=bold guifg=#729fcf guibg=#000

"Set leader character
let mapleader = "\<Space>"
let maplocalleader = "|"


"""
""" Plugin options
"""
call plug#begin('~/.vim/bundle')

Plug 'tpope/vim-abolish'

Plug 'mileszs/ack.vim'

Plug 'bling/vim-airline'

Plug 'veloce/vim-aldmeris'

Plug 'b4winckler/vim-angry'

Plug 'Chiel92/vim-autoformat'

Plug 'jiangmiao/auto-pairs'

Plug 'lilydjwg/colorizer'

Plug 'vim-scripts/ConflictDetection'

Plug 'vim-scripts/ConflictMotions'

Plug 'vim-scripts/CountJump'

Plug 'elubow/cql-vim'

Plug 'hail2u/vim-css3-syntax'

Plug 'kien/ctrlp.vim'

Plug 'tacahiroy/ctrlp-funky'

Plug 'brookhong/DBGPavim'

Plug 'tpope/vim-dispatch'

Plug 'junegunn/vim-easy-align'

Plug 'mattn/emmet-vim'

Plug 'tpope/vim-endwise'

Plug 'terryma/vim-expand-region'

Plug 'tpope/vim-fugitive'

Plug 'sjl/gundo.vim'

Plug 'honza/vim-snippets'

Plug 'othree/html5.vim'

Plug 'michaeljsmith/vim-indent-object'

Plug 'vim-scripts/ingo-library'

Plug 'pangloss/vim-javascript'

Plug 'elzr/vim-json'

Plug 'groenewege/vim-less'

Plug 'vitalk/vim-lesscss'

Plug 'vim-scripts/localvimrc'

Plug 'vim-scripts/matchit.zip'

Plug 'szw/vim-maximizer'

Plug 'vim-scripts/molokai'

Plug 'Shougo/neocomplete.vim'

Plug 'scrooloose/nerdtree'

Plug 'koron/nyancat-vim'

Plug 'StanAngeloff/php.vim'

Plug 'henrik/vim-qargs'

Plug 'chrisbra/Recover.vim'

Plug 'tpope/vim-repeat'

Plug 'vim-scripts/SearchComplete'

Plug 'kshenoy/vim-signature'

Plug 'mhinz/vim-signify'

Plug 'kana/vim-smartword'

Plug 'justinmk/vim-sneak'

Plug 'tpope/vim-speeddating'

Plug 'chrisbra/SudoEdit.vim'

Plug 'shanesmith/vim-surround'

Plug 'scrooloose/syntastic'

Plug 'majutsushi/tagbar' 

Plug 'tomtom/tcomment_vim'

Plug 'glts/vim-textobj-comment'

Plug 'machakann/vim-textobj-delimited'

Plug 'kana/vim-textobj-entire'

Plug 'kana/vim-textobj-user'

Plug 'whatyouhide/vim-textobj-xmlattr'

Plug 'tpope/vim-unimpaired'

Plug 'joonty/vdebug'

Plug 'thinca/vim-visualstar'

Plug 'wesQ3/vim-windowswap'

Plug 'sukima/xmledit'

Plug 'tommcdo/vim-exchange'

call plug#end()

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

"CtrlP options
let g:ctrlp_map = "<leader>pp"
nnoremap <leader>p  :CtrlP<cr>
nnoremap <leader>pf :CtrlPFunky<cr>
nnoremap <leader>pl :CtrlPLine<cr>
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_use_caching = 1000
let g:ctrlp_max_height = 50
let g:ctrlp_tabpage_position = 'al'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_extensions=['funky', 'line']
let g:ctrlp_reuse_window = 'nerdtree'
let g:ctrlp_prompt_mappings = {
    \ 'ToggleType(1)':        ['<c-right>'],
    \ 'ToggleType(-1)':       ['<c-left>'],
    \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-h>'],
    \ }
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\vtags|\.(exe|so|dll|DS_Store)$'
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

"Syntastic options
let g:syntastic_check_on_open = 1
let g:syntastic_objc_compiler = 'clang'
let g:syntastic_php_checkers = ['php']
let g:syntastic_javascript_checkers = ['jshint', 'jscs']
let g:syntastic_html_tidy_quiet_messages = {
      \   'regex': [
      \     '"tabindex" has invalid value "-1"',
      \     '<div> proprietary attribute "tabindex"',
      \     '<img> lacks "alt" attribute',
      \     'trimming empty <span>',
      \   ],
      \ }
let g:syntastic_html_tidy_ignore_errors = [
      \ " proprietary attribute \"ng-",
      \ " proprietary attribute \"translate",
      \ " proprietary attribute \"ui-"
      \]

"DBGPavim
let g:dbgPavimPort = 9009
let g:dbgPavimBreakAtEntry = 0
let g:dbgPavimKeyRun = "<leader>dr"
let g:dbgPavimKeyQuit = "<leader>dq"
let g:dbgPavimKeyToggleBp = "<leader>db"
let g:dbgPavimKeyHelp = "<leader>dh"
let g:dbgPavimKeyToggleBae = "<leader>de"


"Signify
highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227
let g:signify_mapping_next_hunk = ']-'
let g:signify_mapping_prev_hunk = '[-'

"Signature
" - GotoNext/PrevMarkerAny unmap due to conflict with conflictmotions
let g:SignatureMap = {
      \ 'GotoNextMarkerAny':  "",
      \ 'GotoPrevMarkerAny':  "",
      \ 'GotoNextLineAlpha':  "",
      \ 'GotoPrevLineAlpha':  "",
      \ 'GotoNextSpotAlpha':  "",
      \ 'GotoPrevSpotAlpha':  "",
      \ 'GotoNextMarker'   :  "",
      \ 'GotoPrevMarker'   :  "",
      \ }

"JSON
let g:vim_json_syntax_conceal = 0

"ACK
let g:ackhighlight = 1
nnoremap <leader>a :Ack! 
vnoremap <leader>a "hy:<C-U>Ack! <C-R>h

"Ag - The Silver Searcher
if executable('ag')

  set grepprg=ag\ --nogroup\ --nocolor
  let g:ackprg = 'ag --nogroup --nocolor --column -S'

  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

endif

"XMLEdit
let g:xmledit_enable_html = 1
let g:xml_use_xhtml = 1

"Maximizer
let g:maximizer_default_mapping_key = '<F4>'

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

"Easy Align
vnoremap <Tab> <Plug>(LiveEasyAlign)

"Sneak
let g:sneak#use_ic_scs = 1
let g:sneak#streak = 1
nnoremap ]; <Plug>SneakNext
vnoremap ]; <Plug>VSneakNext
nnoremap [; <Plug>SneakPrevious
vnoremap [; <Plug>VSneakPrevious

" TagBar
nnoremap <Leader>c :TagbarToggle<CR>

" WndowSwap
let g:windowswap_map_keys = 0
nnoremap <silent> <C-w>w :call WindowSwap#EasyWindowSwap()<CR>
nnoremap <silent> <C-w><C-w> :call WindowSwap#EasyWindowSwap()<CR>


""" 
""" Custom mappings
"""

nnoremap <Leader>w :w<CR>

"Window commands
noremap <C-l> <C-w><Right>
noremap <C-h> <C-w><Left>
noremap <C-j> <C-w><Down>
noremap <C-k> <C-w><Up>
noremap <Right> <C-w><Right>
noremap <Left> <C-w><Left>
noremap <Down> <C-w><Down>
noremap <Up> <C-w><Up>

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
nnoremap <S-Right> :tabnext<CR>
nnoremap <S-Left> :tabprevious<CR>

"Show whitespace characters
nnoremap <F9> :set list!<CR>

"Stop accidentaly recording
nnoremap Q q
nnoremap q <nop>

"Visual select last pasted
"http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap gp `[v`]

"Paste from system clipboard
set clipboard=unnamed,unnamedplus
nnoremap <leader>v "+p
nnoremap <leader>V "+p
nnoremap <leader>C "+yy
vnoremap <leader>v "+p
vnoremap <leader>V "+p
vnoremap <leader>c "+y

"Stamp word (replace current word with last delete/yank)
nnoremap S diw"0P

"Map U to redo
nnoremap U :redo<CR>

"Move lines up/down
nnoremap <S-Up> :call <SID>moveit('up')<CR>
nnoremap <S-Down> :call <SID>moveit('down')<CR>
vnoremap <S-Up> :move '<-2<CR>gv=gv
vnoremap <S-Down> :move '>+1<CR>gv=gv
inoremap <S-Up> <C-o>:call <SID>moveit('up')<cr>
inoremap <S-Down> <C-o>:call <SID>moveit('down')<cr>

function! s:reindent_inner()
  let line = getline('.')
  if match(line, '^\s*[()\[\]{}]') != -1
    normal ^=%``
  endif
  if match(line, '[()\[\]{}]\s*$') != -1
    normal $=%``
  endif
endfunction

function! s:moveit(where) 
  if match(getline('.'), '^\s*$') != -1
    let startpos = line('.')
    let endpos = search('\S', 'nW') - 1
    exec startpos . "," . endpos . "delete _"
  endif
  if a:where ==? "up"
    move -2
    call s:reindent_inner()
    normal ==j==k^
  elseif a:where ==? "down"
    move +1
    normal ==k==j^
    call s:reindent_inner()
  endif
endfunction

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
" nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <silent> <Leader>t :call <SID>NERDTreeHere("e")<CR>
nnoremap <silent> <Leader>tt :call <SID>NERDTreeHere("e")<CR>
nnoremap <silent> <Leader>ty :call <SID>NERDTreeHere("t")<CR>
nnoremap <silent> <Leader>tv :call <SID>NERDTreeHere("v")<CR>
nnoremap <silent> <Leader>ts :call <SID>NERDTreeHere("s")<CR>
let g:NERDTreeHijackNetrw = 0
let NERDTreeMapActivateNode = 'l'
let NERDTreeMapCloseDir = 'h'
let NERDTreeMapOpenSplit = 's'
let NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeChDirMode = 2
let NERDTreeIgnore = [ '\.pyc$' ]

"TComment
nnoremap \\ :TComment<CR>
vnoremap \\ :TComment<CR>
nnoremap \* :TCommentBlock<CR>
vnoremap \* :TCommentBlock<CR>

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
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$

"Next/Previous quick fix
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>
" nnoremap <C-j> :lnext<CR>
" nnoremap <C-k> :lprevious<CR>

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

"Don't need help right now, thanks
inoremap <F1> <Nop>
nnoremap <F1> <Nop>

"ConflictTake
nnoremap <leader>x= :ConflictTake both<CR>
nnoremap <leader>x+ :ConflictTake both<CR>

nnoremap ; :
nnoremap : ;

"Better wrap navigation
nnoremap j gj
nnoremap k gk

"Insert mode hjkl
inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

"""
""" Custom ex commands
"""

"Clean out trailing whitespaces
command! CleanWhitespace call <SID>CleanWhitespace()
function! s:CleanWhitespace() 
  let lastSearch = @/ 
  %s/\s\+$//ge 
  let @/ = lastSearch
endfunction

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

"Source vimrc
command! ReloadVimrc source $MYVIMRC

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
  au FileType php,html,css inoremap <C-Y>Y <plug>(emmet-expand-abbr)
  au FileType php,html,css inoremap <C-Y><C-Y> <plug>(emmet-expand-abbr)
  au FileType php,html,css vnoremap <C-Y>Y <plug>(emmet-expand-abbr)
  au FileType php,html,css vnoremap <C-Y><C-Y> <plug>(emmet-expand-abbr)
  au FileType php,html,css nnoremap <C-Y>Y <plug>(emmet-expand-abbr)
  au FileType php,html,css nnoremap <C-Y><C-Y> <plug>(emmet-expand-abbr)
augroup END

augroup VimEnterNERDTreeHere
  au!
  au StdinReadPre * let s:std_in=1
  au VimEnter * call <SID>VimEnterNERDTreeHere()
augroup END

function! s:VimEnterNERDTreeHere()
  if !exists("s:std_ind") && argc() == 0
    call <SID>NERDTreeHere("e")
    normal B
  endif
endfunction

function! s:NERDTreeHere(split)

  if &modified == 1 && a:split ==? "e"
    call nerdtree#echo("Buffer has been modified.")
    return
  endif

  try
    let p = g:NERDTreePath.New(expand("%:p"))
  catch /^NERDTree.InvalidArgumentsError/
    call nerdtree#echo("no file for the current buffer")
    return
  endtry

  try
    let cwd = g:NERDTreePath.New(getcwd())
  catch /^NERDTree.InvalidArgumentsError/
    call nerdtree#echo("current directory does not exist.")
    let cwd = p.getParent()
  endtry

  if a:split ==? "v"
    vnew
  elseif a:split ==? "s"
    new
  elseif a:split ==? "t"
    tabnew
  else
    enew
  endif

  if p.isUnder(cwd) || p.equals(cwd)
    call g:NERDTreeCreator.CreateSecondary(cwd.str())
  else
    call g:NERDTreeCreator.CreateSecondary(p.getParent().str())
  endif

  if !p.equals(cwd) 
    call b:NERDTreeRoot.reveal(p)
  endif

endfunction

