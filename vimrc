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
set guifont=Droid_Sans_Mono_for_Powerline:h11,Ubuntu_Mono_derivative_Powerline
if has("gui_macvim")
  set macmeta
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

"Don't highlight long lines
set synmaxcol=800

"What to show in character list
set listchars=tab:>-,trail:',eol:$

hi CursorLine ctermbg=234 guibg=#404040

hi link jsParens Operator
hi link jsObjectBraces Special

"Set leader character
let mapleader = "\<Space>"
let maplocalleader = "|"

"""
""" Plugin options
"""
call plug#begin('~/.vim/bundle')

Plug 'tpope/vim-abolish'

Plug 'shanesmith/ack.vim'

Plug 'bling/vim-airline'

Plug 'veloce/vim-aldmeris'

Plug 'Chiel92/vim-autoformat'

Plug 'jiangmiao/auto-pairs'

Plug 'lilydjwg/colorizer'

Plug 'vim-scripts/ConflictDetection'

Plug 'vim-scripts/ConflictMotions'

Plug 'vim-scripts/CountJump'

Plug 'elubow/cql-vim'

Plug 'hail2u/vim-css3-syntax'

Plug 'ctrlpvim/ctrlp.vim'

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

Plug 'shanesmith/vim-javascript', {'branch': 'develop'}

Plug 'elzr/vim-json'

Plug 'groenewege/vim-less'

Plug 'vitalk/vim-lesscss'

Plug 'vim-scripts/localvimrc'

Plug 'vim-scripts/matchit.zip'

Plug 'szw/vim-maximizer'

Plug 'vim-scripts/molokai'

Plug 'scrooloose/nerdtree'

Plug 'koron/nyancat-vim'

Plug 'StanAngeloff/php.vim'

Plug 'henrik/vim-qargs'

Plug 'chrisbra/Recover.vim'

Plug 'tpope/vim-repeat'

Plug 'kshenoy/vim-signature'

Plug 'mhinz/vim-signify'

Plug 'kana/vim-smartword'

Plug 'justinmk/vim-sneak'

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

Plug 'shanesmith/xmledit'

Plug 'tommcdo/vim-exchange'

Plug 'christoomey/vim-tmux-navigator'

Plug 'Keithbsmiley/tmux.vim'

Plug 'sjl/vitality.vim'

Plug 'FelikZ/ctrlp-py-matcher'

Plug 'edkolev/tmuxline.vim'

Plug 'lfilho/cosco.vim'

Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'marijnh/tern_for_vim', { 'do': 'npm install' }
nnoremap <leader>jf :TernDef<CR>
nnoremap <leader>jd :TernDoc<CR>
nnoremap <leader>jr :TernRefs<CR>

Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }
let g:ycm_autoclose_preview_window_after_insertion = 1

Plug 'AndrewRadev/switch.vim'
nnoremap <silent> - :Switch<CR>

Plug 'Keithbsmiley/investigate.vim'

Plug 'gorkunov/smartpairs.vim'

Plug 'fisadev/vim-ctrlp-cmdpalette'

Plug 'wellle/targets.vim'

Plug 'henrik/vim-indexed-search'

Plug 'rhysd/committia.vim'

call plug#end()

augroup AldmerisColorTweaks
  au!
  au ColorScheme aldmeris call <SID>AldmerisColorTweaks()
augroup END

function! s:AldmerisColorTweaks()
  hi DiffAdd term=bold cterm=bold ctermfg=64 ctermbg=0 gui=bold guifg=#4e9a06 guibg=#000
  hi DiffText term=reverse cterm=bold ctermfg=74 ctermbg=0 gui=bold guifg=#729fcf guibg=#000
endfunction

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
vnoremap <leader>p  "hy:call <SID>CtrlPWithInput(@h)<CR>
vnoremap <leader>pp "hy:call <SID>CtrlPWithInput(@h)<CR>
nnoremap <leader>pf :CtrlPFunky<cr>
nnoremap <leader>pl :CtrlPLine<cr>
nnoremap <leader>pb :CtrlPBuffer<cr>
nnoremap <leader>pc :CtrlPCmdPalette<cr>
nnoremap <leader>pw :call <SID>CtrlPWithInput("<C-R><C-W>")<CR>
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
    \ 'ToggleType(-1)':       ['<c-left>']
    \ }
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\vtags|\.(exe|so|dll|DS_Store)$'
      \ }
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

function! s:CtrlPWithInput(input)
  let g:ctrlp_default_input = a:input
  CtrlP
  let g:ctrlp_default_input = ""
endfunction

"LocalVimrc options
let g:localvimrc_sandbox=0
let g:localvimrc_persistent=1

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
nmap ]- <plug>(signify-next-hunk)
nmap [- <plug>(signify-prev-hunk)
omap i- <plug>(signify-motion-inner-pending)
xmap i- <plug>(signify-motion-inner-visual)
omap a- <plug>(signify-motion-outer-pending)
xmap a- <plug>(signify-motion-outer-visual)

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
nnoremap <leader>a :Ack!<Space>
vnoremap <leader>a "hy:<C-U>Ack! <C-R>h

"Ag - The Silver Searcher
if executable('ag')

  set grepprg=ag\ --nogroup\ --nocolor
  let g:ackprg = 'ag --nogroup --nocolor --column -S'

  let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --hidden --ignore .git --ignore .svn --ignore .DS_Store --ignore .*.sw[a-z]'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

endif

"XMLEdit
let g:xmledit_enable_html = 1
let g:xml_use_xhtml = 1
function! HtmlAttribCallback(xml_tag)
  "disable this sort of thing
  return 0
endfunction

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
vmap <Tab> <Plug>(LiveEasyAlign)

"Sneak
let g:sneak#use_ic_scs = 1
let g:sneak#streak = 1
let g:sneak#s_next = 1
nmap ]; <Plug>SneakNext
vmap ]; <Plug>VSneakNext
nmap [; <Plug>SneakPrevious
vmap [; <Plug>VSneakPrevious

" TagBar
nnoremap <Leader>c :TagbarToggle<CR>

" WndowSwap
let g:windowswap_map_keys = 0
nnoremap <silent> <C-w>w :call WindowSwap#EasyWindowSwap()<CR>
nnoremap <silent> <C-w><C-w> :call WindowSwap#EasyWindowSwap()<CR>

" Cosco
autocmd FileType javascript,php,css,java,c,cpp nnoremap <silent> ;; :call <SID>custom_cosco()<CR>
autocmd FileType javascript,php,css,java,c,cpp vnoremap <silent> ;; :call cosco#commaOrSemiColon()<CR>
autocmd FileType javascript,php,css,java,c,cpp inoremap <silent> ;; <C-o>:call <SID>custom_cosco()<CR>
function! s:custom_cosco()
  let travel = 0
  if match(getline('.'), '^\s*$') != -1
    let travel = 1
    normal! mz
    normal! }(
  endif
  call cosco#commaOrSemiColon()
  if travel
    normal! `z
    delm z
  endif
endfunction


"""
""" Custom mappings
"""

nnoremap <Leader>w :w<CR>

"Window commands
inoremap <silent> <c-h> <ESC>:TmuxNavigateLeft<cr>
inoremap <silent> <c-j> <ESC>:TmuxNavigateDown<cr>
inoremap <silent> <c-k> <ESC>:TmuxNavigateUp<cr>
inoremap <silent> <c-l> <ESC>:TmuxNavigateRight<cr>

"Search commands
""Highlight current word
nnoremap <silent> <Leader>/ :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR>
nnoremap <silent> <2-LeftMouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR>
""Clear search (and Highlight)
nnoremap <silent> <Leader>\ :let @/=""<CR>
"Search history navigation
nnoremap <silent> [/ :call <SID>search_hist('back')<CR>
nnoremap <silent> ]/ :call <SID>search_hist('forward')<CR>

let s:search_hist_index = 0
let s:search_last_nr = 0
function! s:search_hist(direction)
  if s:search_last_nr != histnr('search')
    let s:search_hist_index = 0
    let s:search_last_nr = histnr('search')
  endif
  if a:direction == 'back'
    if s:search_hist_index > histnr('search') * -1
      let s:search_hist_index = s:search_hist_index - 1
    endif
  else
    if s:search_hist_index < 0
      let s:search_hist_index = s:search_hist_index + 1
    endif
  endif
  let @/ = histget('search', s:search_hist_index - 1)
  echo s:search_hist_index @/
endfunction

"Next/Previous result
nnoremap <F3> n
nnoremap <S-F3> N

"Tab commands
nnoremap <S-Right> :tabnext<CR>
nnoremap <S-Left> :tabprevious<CR>
nnoremap [t :tabprev<CR>
nnoremap ]t :tabnext<CR>
nnoremap <C-t>n :tabnew<CR>
nnoremap <C-t>t :tabnew<CR>
nnoremap <C-t><C-t> :tabnew<CR>
nnoremap <C-t>o :tabonly<CR>
nnoremap <C-t>c :tabclose<CR>
nnoremap <C-t>q :tabclose<CR>

"Only works in GUI
nnoremap <C-Tab> :tabnext<CR>
nnoremap <C-S-Tab> :tabprev<CR>
inoremap <C-Tab> <ESC>:tabnext<CR>
inoremap <C-S-Tab> <ESC>:tabprev<CR>

"Show whitespace characters
nnoremap <F7> :set list!<CR>

"Stop accidentaly recording
noremap ! q
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

"Inline mode paste
inoremap <C-p> <C-o>p

"Like it should be
nnoremap Y y$

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
    normal! ^=%``
  endif
  if match(line, '[()\[\]{}]\s*$') != -1
    normal! $=%``
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
    normal! ==j==k^
  elseif a:where ==? "down"
    move +1
    normal! ==k==j^
    call s:reindent_inner()
  endif
endfunction

"New lines
nnoremap <Leader><CR> i<CR><ESC>
nnoremap <Leader>o mzo<ESC>g`z:delm z<CR>
nnoremap <Leader>O mzO<ESC>g`z:delm z<CR>
vnoremap <Leader>o "zdi<CR><CR><ESC>k"z]P`[=`]`[v`]

"Better escape
inoremap jk <ESC>

"Text-object for matching whole-line pairs
vnoremap <silent> A{ :normal! [{V%<CR>
vnoremap <silent> A} :normal! [{V%<CR>
vnoremap <silent> A( :normal! [(V%<CR>
vnoremap <silent> A) :normal! [(V%<CR>
vnoremap <silent> A[ :call searchpair('\[', '', '\]', 'bW') \| normal! V%<CR>
vnoremap <silent> A] :call searchpair('\[', '', '\]', 'bW') \| normal! V%<CR>
onoremap <silent> A{ :normal! [{V%<CR>
onoremap <silent> A} :normal! [{V%<CR>
onoremap <silent> A( :normal! [(V%<CR>
onoremap <silent> A) :normal! [(V%<CR>
onoremap <silent> A[ :call searchpair('\[', '', '\]', 'bW') \| normal! V%<CR>
onoremap <silent> A] :call searchpair('\[', '', '\]', 'bW') \| normal! V%<CR>
nnoremap <silent> dS{ :call <SID>delete_surrounding_lines("{}")<CR>
nnoremap <silent> dS} :call <SID>delete_surrounding_lines("{}")<CR>
nnoremap <silent> dS[ :call <SID>delete_surrounding_lines("[]")<CR>
nnoremap <silent> dS] :call <SID>delete_surrounding_lines("[]")<CR>
nnoremap <silent> dS( :call <SID>delete_surrounding_lines("()")<CR>
nnoremap <silent> dS) :call <SID>delete_surrounding_lines("()")<CR>

function! s:delete_surrounding_lines(pair)
  let syng_strcom = 'string\|regex\|comment\c'
  let skip_expr = "synIDattr(synID(line('.'),col('.'),1),'name') =~ '".syng_strcom."'"

  let char = map(split(a:pair, '\zs'), '"\\V" . v:val')

  normal! mz

  let startline = searchpair(char[0], '', char[1], 'bW', skip_expr)

  delete _

  let endline = searchpair(char[0], '', char[1], '', skip_expr)

  delete _

  let numlines = endline - startline

  exec startline . "," . endline . "normal! =="

  normal! `z

  delm z

endfunction

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
let NERDTreeMapJumpNextSibling = ''
let NERDTreeMapJumpPrevSibling = ''
let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeChDirMode = 2
let NERDTreeIgnore = [ '\.pyc$' ]

" TComment
nnoremap \\ :TComment<CR>
vnoremap \\ :TComment<CR>
nnoremap \* :TCommentBlock<CR>
vnoremap \* :TCommentBlock<CR>
nmap \  <Plug>TComment-gc

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
nnoremap <leader>q :copen<CR>
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
let g:airline#extensions#tmuxline#enabled = 0

"Colorizer
let g:colorizer_startup = 1
let g:colorizer_nomap = 1

"Gundo
nnoremap <leader>u :GundoToggle<CR>

"Don't need help right now, thanks
inoremap <F1> <Nop>
nnoremap <F1> <Nop>

"ConflictDetection
let g:ConflictDetection_WarnEvents = ''
highlight  conflictOursMarker term=bold ctermfg=16 gui=bold guifg=#000 cterm=bold ctermbg=102
highlight  conflictBaseMarker term=bold ctermfg=16 gui=bold guifg=#000 cterm=bold ctermbg=102
highlight  conflictTheirsMarker term=bold ctermfg=16 gui=bold guifg=#000 cterm=bold ctermbg=102
highlight  conflictSeparatorMarkerSymbol term=bold ctermfg=16 gui=bold guifg=#000 cterm=bold ctermbg=102

"ConflictTake
let g:ConflictMotions_ConflictMapping = 'X'
let g:ConflictMotions_SectionMapping = '='
nnoremap <leader>x= :ConflictTake both<CR>
nnoremap <leader>x+ :ConflictTake both<CR>

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

"Better wrap navigation
nmap <expr> j (v:count == 0 ? 'gj' : 'j')
nmap <expr> k (v:count == 0 ? 'gk' : 'k')

"Insert mode hjkl
inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

"Easier substitute
nnoremap <leader>r :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <leader>r "hy:<C-\>e<SID>subsub()<CR>
function! s:subsub()
  let numlines = strlen(substitute(@h, "[^\\n]", "", "g"))
  if numlines == 0
    let cmd = "%s/" . @h . "/" . @h
  else
    let cmd = "'<,'>s/"
  endif
  return cmd
endfunction

"Quick Quit
nnoremap Q <nop>
nnoremap QQ :quit<CR>
nnoremap Q!! :quit!<CR>

"""
""" Custom ex commands
"""

"Clean out trailing whitespaces
command! -rang=% CleanWhitespace <line1>,<line2>call <SID>CleanWhitespace()
function! s:CleanWhitespace() range
  let lastSearch = @/
  exec a:firstline . "," . a:lastline . "s/\\s\\+$//ge"
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
  au FileType php,html,css imap <C-Y>Y <plug>(emmet-expand-abbr)
  au FileType php,html,css imap <C-Y><C-Y> <plug>(emmet-expand-abbr)
  au FileType php,html,css vmap <C-Y>Y <plug>(emmet-expand-abbr)
  au FileType php,html,css vmap <C-Y><C-Y> <plug>(emmet-expand-abbr)
  au FileType php,html,css nmap <C-Y>Y <plug>(emmet-expand-abbr)
  au FileType php,html,css nmap <C-Y><C-Y> <plug>(emmet-expand-abbr)
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

function! s:NERDTreeHere(split, ...)

  if &modified == 1 && a:split ==? "e"
    call nerdtree#echo("Buffer has been modified.")
    return
  endif

  try
    let p = g:NERDTreePath.New(expand("%:p"))
  catch /^NERDTree.InvalidArgumentsError/
    call nerdtree#echo("Current file no longer exists.")
  endtry

  if a:0 == 0

    try
      let cwd = g:NERDTreePath.New(getcwd())
    catch /^NERDTree.InvalidArgumentsError/
      call nerdtree#echo("Current directory no longers exist.")
      if !exists("p")
        call nerdtree#echo("Too many fails! Bailing out!")
      endif
      let cwd = p.getParent()
    endtry

    if !exists("p") || p.isUnder(cwd) || p.equals(cwd)
      let where = cwd
    else
      let where = p.getParent()
    endif

  else

    let where = g:NERDTreePath.New(expand(a:1))

  endif

  if a:split ==? "v"
    vnew
  elseif a:split ==? "s"
    new
  elseif a:split ==? "t"
    tabnew
  else
    enew
  endif

  call g:NERDTreeCreator.CreateSecondary(where.str())

  if exists("p") && p.isUnder(where) && !p.equals(where)
    call b:NERDTreeRoot.reveal(p)
  endif

endfunction

"TODO automatic date prefix?
function! s:NotesSave()

  let name = input("Save note as: ")
  redraw

  if name == ""
    return
  endif

  let fname = expand(g:notes_folder) . "/" . name . ".md"

  if filereadable(fname)
    echohl ErrorMsg
    echomsg "File" fname "already exists!"
    echohl None
    return
  endif

  let path = fnamemodify(fname, ':h')

  if !isdirectory(path)
    call mkdir(path, 'p')
  endif

  exec "saveas" fnameescape(fname)

endfunction

function! s:NotesNew()

  if bufname('%') != ''
    vnew
  endif

  set ft=markdown

endfunction

function! s:NotesTree()

  let where = "v"

  if stridx(expand('%:p'), expand(g:notes_folder)) == 0 || (bufname('%') == '' && line('$') == 1 && getline(1) == '')
    let where = "e"
  endif

  call <SID>NERDTreeHere(where, g:notes_folder)

endfunction

let g:notes_folder = "~/Dropbox/notes"
nnoremap <Leader>nt :call <SID>NotesTree()<CR>
nnoremap <Leader>nw :call <SID>NotesSave()<CR>
nnoremap <Leader>nn :call <SID>NotesNew()<CR>
nnoremap <leader>np :exec "CtrlP" g:notes_folder<CR>
nnoremap <leader>pn :exec "CtrlP" g:notes_folder<CR>

augroup TitleString
  au!
  auto BufEnter * let &titlestring = "Vim@" . hostname() . "/" . expand("%:p")
augroup END
