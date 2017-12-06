
" Settings {{{
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

" formatoptions
" https://stackoverflow.com/questions/16030639/vim-formatoptions-or/23326474#23326474
augroup formatoptions
  au!
  autocmd BufEnter * setlocal formatoptions-=o formatoptions+=nj
augroup END

"set autoindent
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

"set spell language
set spelllang=en_ca

"set modelines enabled
set modeline
set modelines=5

"Viminfo
set viminfo+=!

"Session options
set sessionoptions=blank,buffers,curdir,folds,globals,help,tabpages,winsize

"Enable mouse
set mouse=a

"Wrap at start/end of line
set whichwrap+=<,>,[,],h,l

"Custom Fold Text
set foldtext=CustomFoldText()
fu! CustomFoldText()
  "modified from http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
  let fs = v:foldstart

  while getline(fs) =~ '^\s*$'
    let fs = nextnonblank(fs + 1)
  endwhile

  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . foldSize . " lines "
  let foldLevelStr = repeat("+--", v:foldlevel)
  let lineCount = line("$")
  let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let expansionString = ' ' . repeat(foldchar, w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage) - 1)
  return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endf

function! NeatFoldText()
  " http://dhruvasagar.com/2013/03/28/vim-better-foldtext
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

"Remove toolbar from GUI vim
set winaltkeys=no
set guioptions-=T
set guioptions+=c
if has("gui_macvim")
  set macmeta
  set guifont=Droid_Sans_Mono_for_Powerline:h10
elseif exists('neovim_dot_app')
  call MacSetFont('Droid Sans Mono for Powerline', 10)
elseif has("gui_gtk2")
  set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 9
endif

"Let VIM figure out the indentation neede in C-style programs - when it can.
set smartindent
set autoindent
set copyindent

"VIM will show the corresponding opening and closing curly brace, bracket or parentesis.
set matchtime=1

"Show incomplete command
set showcmd

"No preview window
set completeopt-=preview

"Display the status bar at the bottom
set ruler

if !exists('neovim_dot_app')
  "Faster drawing... apparently...
  set lazyredraw

  set showmatch
endif

"Mostly for a better maximizer
set winminwidth=0
set winminheight=0

"Error bell
set noerrorbells
set visualbell
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

"Don't wrap to top/bottom of file when searching
set nowrapscan

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
let maplocalleader = "\\"

"}}} Settings

" Plugins {{{

call plug#begin('~/.vim/bundle')

"" File Navigation and Search {{{

Plug 'Xuyuanp/nerdtree-git-plugin'
let g:NERDTreeShowIgnoredStatus = 0

Plug 'thinca/vim-visualstar'

Plug 'dyng/ctrlsf.vim'
let g:ctrlsf_auto_close = 0
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_populate_qflist = 1
let g:ctrlsf_indent = 2
let g:ctrlsf_mapping = {
      \ "split": [ "<C-S>" ],
      \ "vsplit": [ "<C-V>" ],
      \ "tab": [ "<C-T>" ],
      \ "next": "n",
      \ "prev": "N"
      \ }
if executable('rg')
  let g:ctrlsf_ackprg  = 'rg'
elseif executable('ag')
  let g:ctrlsf_ackprg  = 'ag'
endif
nmap <leader>c <Plug>CtrlSFPrompt
vmap <leader>c <Plug>CtrlSFVwordPath

Plug 'shanesmith/ack.vim'
command! -nargs=* MyAck call <SID>MyAck(0, <f-args>)
command! -nargs=* MyAckRegEx call <SID>MyAck(1, <f-args>)
function! s:MyAck(regex, ...)
  let args = ""
  if !a:regex
    let args .= " " . g:ack_literal_flag
  endif
  if a:0 == 0
    let what = expand("<cword>")
  else
    let what = join(a:000, ' ')
  endif
  let args .= " -- \"" . what . "\""
  call ack#Ack('grep!', args)
endfunction
nnoremap <leader>aa :MyAck<space>
nnoremap <leader>aq :MyAckRegEx<space>
vnoremap <leader>aa "hy:<C-U>MyAck <C-R>h
vnoremap <leader>aq "hy:<C-U>MyAckRegEx <C-R>h
if executable('rg')
  let g:ackprg = 'rg --vimgrep --no-heading'
  let g:ack_literal_flag = "-F"
elseif executable('ag')
  let g:ackprg = 'ag --vimgrep $* \| grep -v -e "^.*\.min\.js:" -e "^.*\.min\.css:"'
  let g:ack_literal_flag = "-Q"
endif
let g:ackhighlight = 1
let g:ack_mappings = {
      \ "<C-t>": "<C-W><CR><C-W>T",
      \ "<C-s>": "<C-W><CR>:exe 'wincmd ' (&splitbelow ? 'J' : 'K')<CR><C-W>p<C-W>J<C-W>p",
      \ "s": "<C-W><CR>:exe 'wincmd ' (&splitbelow ? 'J' : 'K')<CR><C-W>p<C-W>J<C-W>p",
      \ "<C-v>": "<C-W><CR>:exe 'wincmd ' (&splitright ? 'L' : 'H')<CR><C-W>p<C-W>J<C-W>p",
      \ "v":     "<C-W><CR>:exe 'wincmd ' (&splitright ? 'L' : 'H')<CR><C-W>p<C-W>J<C-W>p",
      \ "<CR>":  ":let ack_qf_line=line('.')<CR><C-w>p:exec ack_qf_line . 'cc'<CR>"
      \ }

Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = ""
nnoremap <c-p> :CtrlP<cr>
vnoremap <c-p> "hy:call <SID>CtrlPWithInput(@h)<CR>
inoremap <c-p> <esc>:CtrlP<cr>
nnoremap <leader>p  :CtrlP<cr>
nnoremap <leader>pb :CtrlPBuffer<cr>
nnoremap <leader>pc :CtrlPCmdPalette<cr>
nnoremap <leader>pw :call <SID>CtrlPWithInput("<C-R><C-W>")<CR>
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_use_caching = 1000
let g:ctrlp_max_height = 101
let g:ctrlp_tabpage_position = 'al'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_reuse_window = 'nerdtree'
let g:ctrlp_prompt_mappings = {
    \ 'ToggleType(1)':   ['<c-right>'],
    \ 'ToggleType(-1)':  ['<c-left>'],
    \ 'PrtHistory(1)':   [],
    \ 'PrtHistory(-1)':  [],
    \ 'CreateNewFile()': [],
    \ }
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\vtags|\.(exe|so|dll|DS_Store)$'
      \ }
let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}

function! s:CtrlPEnter()
  nnoremap <buffer> <c-y> :call <SID>CtrlPYank()<CR>
  nnoremap <buffer> <c-p> :call <SID>CtrlPPaste()<CR>
endfunction

function! s:CtrlPYank()
  let lines = <SID>CtrlPGetLines()

  if empty(lines)
    return
  endif

  let @* = join(lines, "\n")
endfunction

function! s:CtrlPPaste()
  let lines = <SID>CtrlPGetLines()

  if empty(lines)
    return
  endif

  exec "normal! a" . join(lines, "\n")
endfunction

function! s:CtrlPGetLines()
  echo "What modifier? (a|r|i)"

  let modify = nr2char(getchar())

  if modify == nr2char(27) "escape
    call feedkeys("\<c-e>") " redraw CtrlP prompt
    return
  endif

  let lines = []
  let marked = ctrlp#getmarkedlist()

  if !empty(marked)
    let lines = values(marked)
  else
    let lines = [ctrlp#getcline()]
  en

  cal ctrlp#exit()

  call map(lines, {idx, val -> <SID>CtrlPYankFormat(val, modify)})

  return lines
endfunction

function! s:CtrlPYankFormat(val, mod)
  if a:mod == "a" || a:mod == "\<c-a>"
    return fnamemodify(a:val, ':p')
  elseif a:mod == "r" || a:mod == "\<c-r>"
    let path = fnamemodify(a:val, ':p')
    return pyeval("os.path.relpath(vim.eval('path'), os.path.dirname(vim.current.buffer.name))")
  elseif a:mod == "i" || a:mod == "\<c-i>"
    let path = fnamemodify(a:val, ':p')
    let path = pyeval("os.path.relpath(vim.eval('path'), os.path.dirname(vim.current.buffer.name))")
    if path !~ '^\.\.\/'
      let path = "./" . path
    endif
    return fnamemodify(path, ':r')
  endif

  return a:val
endfunction

let g:ctrlp_buffer_func = {
      \ 'enter': function("s:CtrlPEnter")
      \ }
function! s:CtrlPWithInput(input)
  let g:ctrlp_default_input = a:input
  CtrlP
  let g:ctrlp_default_input = ""
endfunction
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
elseif executable('ag')
  let g:ctrlp_user_command = 'ag $(python -c "import os.path; print os.path.relpath(%s,''${PWD}'')") -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

Plug 'mattn/ctrlp-register'
nnoremap <leader>pr :CtrlPRegister<CR>

Plug 'nixprime/cpsm', { 'do': 'brew install cmake boost && ./install.sh' }

Plug 'scrooloose/nerdtree'
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
let g:NERDTreeNaturalSort = 1
let NERDTreeIgnore = [ '\.pyc$' ]

Plug 'henrik/vim-qargs'

Plug 'chrisbra/Recover.vim'

"}}}

"" Utilities {{{

Plug 'tyru/restart.vim'

Plug 'diepm/vim-rest-console'
let g:vrc_trigger = '<C-R>'
let g:vrc_show_command = 1
let g:vrc_curl_opts = {
      \ '--include': '',
      \ '--silent': '',
      \ '--show-error': ''
      \ }
command! RestTab call <SID>rest_tab()
command! RESTTab call <SID>rest_tab()
function! s:rest_tab()
  tabnew
  setf rest
  setlocal buftype=nofile
  call append(0, [
        \ "# http://example.com",
        \ "# Content-Type: application/json",
        \ "# POST /foo/bar",
        \ "# {\"key\": \"value\"}",
        \ ""
        \ ])
endfunction


Plug 'terryma/vim-multiple-cursors'
let g:multi_cursor_exit_from_visual_mode = 0
let g:multi_cursor_exit_from_insert_mode = 0

Plug 'tpope/vim-eunuch'

Plug 'rhysd/committia.vim'

Plug 'AndrewRadev/switch.vim'
let g:switch_mapping = "-"
let g:switch_custom_definitions =
      \ [
      \   ['left', 'right'],
      \   ['top', 'bottom'],
      \   ['padding', 'margin'],
      \   ['absolute', 'relative', 'fixed']
      \ ]

autocmd FileType typescript let b:switch_custom_definitions =
      \[
      \   ['public', 'protected', 'private'],
      \   ['var', 'let', 'const']
      \]

Plug 'fisadev/vim-ctrlp-cmdpalette'

Plug 'lfilho/cosco.vim'
autocmd FileType javascript,php,css,scss,java,c,cpp nnoremap <buffer> <silent> ;; :call <SID>custom_cosco()<CR>
autocmd FileType javascript,php,css,scss,java,c,cpp vnoremap <buffer> <silent> ;; :call cosco#commaOrSemiColon()<CR>
autocmd FileType javascript,php,css,scss,java,c,cpp inoremap <buffer> <silent> ;; <C-o>:call <SID>custom_cosco()<CR>
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

Plug 'tpope/vim-unimpaired'
nmap <silent> [p =P
nmap <silent> ]p =p

function! ZeroPaste(p)
  let l:original_reg = getreg(v:register)
  let l:original_reg_type = getregtype(v:register)
  let l:stripped_reg = substitute(l:original_reg, '\v^%(\n|\s)*(.{-})%(\n|\s)*$', '\1 ', '')
  call setreg(v:register, l:stripped_reg, 'c')
  exe 'normal "' . v:register . a:p
  call setreg(v:register, l:original_reg, l:original_reg_type)
endfunction
nnoremap <silent> zp :<c-u>call ZeroPaste('p')<cr>
nnoremap <silent> zP :<c-u>call ZeroPaste('P')<cr>

Plug 'KabbAmine/lazyList.vim'

" Plug 'majutsushi/tagbar'
" nnoremap <Leader>c :TagbarToggle<CR>

Plug 'shanesmith/vim-surround'
nnoremap dsf :call <SID>SurroundingFunction('d')<CR>
nnoremap csf :call <SID>SurroundingFunction('c')<CR>
function! s:SurroundingFunction(op)
  normal! [(
  call search('\v%(%(\i|\.)@<!).', 'bW')
  normal! "_dt(
  if a:op ==? 'c'
    startinsert
  elseif a:op ==? 'd'
    exec "normal \<Plug>Dsurround("
  endif
endfunction

Plug 'tpope/vim-repeat'

Plug 'tpope/vim-abolish'

Plug 'tpope/vim-endwise'

Plug 'vim-scripts/ingo-library'

Plug 'embear/vim-localvimrc'
let g:localvimrc_sandbox=0
let g:localvimrc_persistent=1

Plug 'szw/vim-maximizer'
let g:maximizer_default_mapping_key = '<F4>'

" Plug 'tpope/vim-fugitive'

Plug 'sjl/gundo.vim'
nnoremap <leader>u :GundoToggle<CR>

Plug 'dohsimpson/vim-macroeditor'

Plug 'machakann/vim-highlightedyank'
map y <Plug>(highlightedyank)

"}}}

"" LOLz {{{

Plug 'koron/nyancat-vim'

Plug 'shanesmith/hackertyper.vim'

Plug 'uguu-org/vim-matrix-screensaver'

"}}}

"" Display {{{

Plug 'vim-scripts/molokai'

Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#tmuxline#enabled = 0
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }

Plug 'morhetz/gruvbox'

Plug 'chrisbra/Colorizer'
let g:colorizer_auto_filetype='css,scss,sass'
let g:colorizer_auto_color = 0
let g:colorizer_colornames = 0

Plug 'vim-scripts/ConflictDetection'
let g:ConflictDetection_WarnEvents = ''

Plug 'kshenoy/vim-signature'
" GotoNext/PrevMarkerAny unmap due to conflict with conflictmotions
let g:SignatureMap = {
      \ 'Leader': "<leader>m",
      \ "ListBufferMarks": "<leader>m/",
      \ "ListBufferMarkers": "<leader>m?",
      \ 'GotoNextMarkerAny':  "",
      \ 'GotoPrevMarkerAny':  "",
      \ 'GotoNextLineAlpha':  "",
      \ 'GotoPrevLineAlpha':  "",
      \ 'GotoNextSpotAlpha':  "",
      \ 'GotoPrevSpotAlpha':  "",
      \ 'GotoNextMarker'   :  "",
      \ 'GotoPrevMarker'   :  "",
      \ }


Plug 'airblade/vim-gitgutter'
let g:gitgutter_map_keys = 0
nmap ]- <plug>GitGutterNextHunk
nmap [- <plug>GitGutterPrevHunk
nmap <leader>-s <plug>GitGutterStageHunk
nmap <leader>-r <plug>GitGutterUndoHunk
nmap <leader>-p <plug>GitGutterPreviewHunk
omap i- <Plug>GitGutterTextObjectInnerPending
omap a- <Plug>GitGutterTextObjectOuterPending
xmap i- <Plug>GitGutterTextObjectInnerVisual
xmap a- <Plug>GitGutterTextObjectOuterVisual

Plug 'vim-scripts/SyntaxRange'

Plug 'lfv89/vim-interestingwords'

Plug 'shanesmith/matchtag'

"}}}

"" Motions {{{

Plug 'rhysd/clever-f.vim'

" Plug 'kana/vim-smartword'
" map qw <Plug>(smartword-w)
" map qb <Plug>(smartword-b)
" map qe <Plug>(smartword-e)
" map qge <Plug>(smartword-ge)

Plug 'justinmk/vim-sneak'
let g:sneak#use_ic_scs = 1
let g:sneak#streak = 1
let g:sneak#s_next = 1
nmap ]; <Plug>SneakNext
vmap ]; <Plug>VSneakNext
nmap [; <Plug>SneakPrevious
vmap [; <Plug>VSneakPrevious

Plug 'vim-scripts/ConflictMotions'
let g:ConflictMotions_ConflictMapping = 'X'
let g:ConflictMotions_SectionMapping = '='
nnoremap <leader>x= :ConflictTake both<CR>
nnoremap <leader>x+ :ConflictTake both<CR>

Plug 'vim-scripts/CountJump'

Plug 'vim-scripts/matchit.zip'

Plug 'machakann/vim-columnmove'
let g:columnmove_no_default_key_mappings = 1
let g:columnmove_strict_wbege = 0
nmap ]c <Plug>(columnmove-W)
xmap ]c <Plug>(columnmove-W)
omap ]c <Plug>(columnmove-W)
nmap [c <Plug>(columnmove-gE)
xmap [c <Plug>(columnmove-gE)
omap [c <Plug>(columnmove-gE)


"}}}

"" Formatting {{{

Plug 'editorconfig/editorconfig-vim'

Plug 'ntpeters/vim-better-whitespace'
let g:current_line_whitespace_disabled_soft = 1
let g:better_whitespace_filetypes_blacklist = ["ctrlsf", "help", "diff"]
command! WhitespaceStrip StripWhitespace

Plug 'Chiel92/vim-autoformat'

Plug 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutJump = ''


Plug 'junegunn/vim-easy-align'
vmap <Tab> <Plug>(LiveEasyAlign)

Plug 'tomtom/tcomment_vim'
let g:tcommentMaps = 0
nnoremap <silent> \\ :TComment<CR>
vnoremap <silent> \\ :TCommentMaybeInline<CR>
nnoremap <silent> \** :TCommentBlock<CR>
vnoremap <silent> \* :TCommentBlock<CR>
nmap \ <Plug>TComment_gc
nmap \* <Plug>TComment_Commentb


"}}}

"" File Types {{{

Plug 'sheerun/vim-polyglot'
let g:jsx_ext_required = 1
let g:vim_json_syntax_conceal = 0

Plug 'marijnh/tern_for_vim', { 'do': 'npm install' }
nnoremap <leader>jf :TernDef<CR>
nnoremap <leader>jd :TernDoc<CR>
nnoremap <leader>jr :TernRefs<CR>

Plug 'heavenshell/vim-jsdoc'

Plug 'shanesmith/xmledit'
let g:xmledit_enable_html = 1
let g:xml_use_xhtml = 1
let g:xml_no_tag_map = 1
let g:xml_no_comment_map = 1
let g:xml_no_jump_map = 1
function! HtmlAttribCallback(xml_tag)
  "disable this sort of thing
  return 0
endfunction

Plug 'suan/vim-instant-markdown', { 'do': 'npm install -g instant-markdown-d' }
let g:instant_markdown_autostart = 0

"}}}

"" Debugging {{{

" Plug 'joonty/vdebug'

Plug 'w0rp/ale'
let g:ale_open_list = 'nope'
let g:ale_linters = {
      \ 'html': []
      \ }

" Plug 'scrooloose/syntastic'
let g:syntastic_check_on_open = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_objc_compiler = 'clang'
let g:syntastic_php_checkers = ['php']
let g:syntastic_javascript_checkers = []
let g:syntastic_typescript_checkers = ['tslint']
let g:syntastic_scss_checkers = ['scss_lint']

" TODO wrapper script to use local is exists
let g:syntastic_typescript_tslint_exe = "npm-run tslint"

let g:syntastic_html_tidy_quiet_messages = {
      \   'regex': [
      \     '"tabindex" has invalid value "-1"',
      \     '<div> proprietary attribute "tabindex"',
      \     '<img> lacks "alt" attribute',
      \     'trimming empty <span>'
      \   ],
      \ }
let g:syntastic_html_tidy_ignore_errors = [
      \   "> proprietary attribute \"",
      \   "trimming empty <",
      \   "> attribute name \"(",
      \   "> attribute name \"*",
      \   "> attribute name \"[",
      \   "> attribute name \"#"
      \ ]

let g:syntastic_html_tidy_blocklevel_tags = [
      \   "ion-view",
      \   "ion-nav-view",
      \   "ion-nav-bar",
      \   "ion-nav-title",
      \   "ion-nav-buttons",
      \   "ion-nav-back-button",
      \   "ion-content",
      \   "ion-toggle",
      \   "ion-spinner",
      \   "ion-header-bar",
      \   "ion-footer-bar",
      \   "ion-side-menu",
      \   "ion-side-menus",
      \   "ion-side-menu-content",
      \   "ion-list",
      \   "ion-item",
      \   "ion-popover-view",
      \   "ion-tabs",
      \   "ion-tab",
      \   "ion-modal-view",
      \
      \   "ion-header",
      \   "ion-navbar",
      \   "ion-title",
      \   "ion-buttons",
      \   "ion-row",
      \   "ion-label",
      \   "ion-input"
      \ ]

let g:ale_html_tidy_options = "-q -q -language en --new-blocklevel-tags '" . join(g:syntastic_html_tidy_blocklevel_tags, ",") . "'"

augroup SyntasticJS
  au!
  auto FileType javascript call <SID>SetJavascriptCheckers(expand("<afile>:p:h"))
augroup END

function! s:SetJavascriptCheckers(dir)
  let checkers = []

  let cfg = findfile(".eslintrc.json", escape(a:dir, ' ') . ';')
  if cfg !=# ''
    call add(checkers, "eslint")
  endif

  let cfg = findfile(".jscsrc", escape(a:dir, ' ') . ';')
  if cfg !=# ''
    call add(checkers, "jscs")
  endif

  let cfg = findfile(".jshintrc", escape(a:dir, ' ') . ';')
  if cfg !=# ''
    call add(checkers, "jshint")
  endif

  let b:syntastic_checkers = checkers
endfunction


Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --tern-completer' }
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_open_loclist_on_ycm_diags = 0
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_key_list_stop_completion = ["<CR>"]

nnoremap <leader>yd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>yr :YcmCompleter GoToReferences<CR>
nnoremap <leader>yt :YcmCompleter GetType<CR>
nnoremap <leader>yc :YcmCompleter GetDoc<CR>

" Plug 'brookhong/DBGPavim'
" let g:dbgPavimPort = 9009
" let g:dbgPavimBreakAtEntry = 0
" let g:dbgPavimKeyRun = "<leader>dr"
" let g:dbgPavimKeyQuit = "<leader>dq"
" let g:dbgPavimKeyToggleBp = "<leader>db"
" let g:dbgPavimKeyHelp = "<leader>dh"
" let g:dbgPavimKeyToggleBae = "<leader>de"


"}}}

"" Snippets {{{

Plug 'mattn/emmet-vim'
let g:emmet_html5 = 0
let g:user_emmet_complete_tag = 1
let g:emmet_install_only_plug = 1
augroup EmmetMappings
  au!
  au FileType php,html,html.handlebars,css imap <buffer> <C-Y> <plug>(emmet-expand-abbr)
  au FileType php,html,html.handlebars,css vmap <buffer> <C-Y> <plug>(emmet-expand-abbr)
  au FileType php,html,html.handlebars,css nmap <buffer> <C-Y> <plug>(emmet-expand-abbr)
augroup END
function! s:emmet_expand_glyph(name)
  return "<span class='glyphicon ".a:name."'></span>"
endfunction
let g:user_emmet_settings = {
      \   'custom_expands': {
      \     '^glyphicon-\S\+$': function("<SID>emmet_expand_glyph")
      \   },
      \ }

Plug 'sirver/ultisnips'
let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsExpandTrigger = '<C-y>'
let g:UltiSnipsJumpForwardTrigger = "<nop>"
let g:UltiSnipsJumpBackwardTrigger = "<nop>"

function! s:PumOrUltisnips(forward)
  if pumvisible() == 1
    return a:forward ? "\<C-n>" : "\<C-p>"
  elseif a:forward
    call UltiSnips#JumpForwards()
    if g:ulti_jump_forwards_res == 0
      return "\<tab>"
    endif
  else
    call UltiSnips#JumpBackwards()
    if g:ulti_jump_backwards_res == 0
      return "\<s-tab>"
    endif
  endif
  return ""
endfunction
inoremap <silent> <tab> <C-R>=<SID>PumOrUltisnips(1)<CR>
inoremap <silent> <s-tab> <C-R>=<SID>PumOrUltisnips(0)<CR>
snoremap <silent> <tab> <Esc>:call UltiSnips#JumpForwards()<CR>
snoremap <silent> <s-tab> <Esc>:call UltiSnips#JumpBackwards()<CR>
nnoremap <expr> <silent> <tab> <SID>PumOrUltisnips(1)
nnoremap <expr> <silent> <s-tab> <SID>PumOrUltisnips(0) 

" Plug 'honza/vim-snippets'


"}}}

"" Text Objects {{{

Plug 'wellle/targets.vim'
let g:targets_quotes = ""

Plug 'gorkunov/smartpairs.vim'

Plug 'michaeljsmith/vim-indent-object'

Plug 'glts/vim-textobj-comment'

Plug 'machakann/vim-textobj-delimited'

Plug 'shanesmith/vim-textobj-entire'

Plug 'kana/vim-textobj-user'

Plug 'whatyouhide/vim-textobj-xmlattr'

Plug 'kana/vim-textobj-function'

Plug 'thinca/vim-textobj-function-javascript'

" Plug 'coderifous/textobj-word-column.vim'

"}}}

"" Windows {{{

Plug 'wesQ3/vim-windowswap'
let g:windowswap_map_keys = 0
nnoremap <silent> <C-w>w :call WindowSwap#EasyWindowSwap()<CR>
nnoremap <silent> <C-w><C-w> :call WindowSwap#EasyWindowSwap()<CR>

Plug 'christoomey/vim-tmux-navigator'
let g:tmux_navigator_disable_when_zoomed = 1
inoremap <silent> <c-h> <ESC>:TmuxNavigateLeft<cr>
inoremap <silent> <c-j> <ESC>:TmuxNavigateDown<cr>
inoremap <silent> <c-k> <ESC>:TmuxNavigateUp<cr>
inoremap <silent> <c-l> <ESC>:TmuxNavigateRight<cr>

Plug 'Keithbsmiley/tmux.vim'

Plug 'sjl/vitality.vim'

Plug 'edkolev/tmuxline.vim'

Plug 't9md/vim-choosewin'
let g:choosewin_overlay_enable = 1
let g:choosewin_overlay_shade = 1
map <c-w>- <Plug>(choosewin)


"}}}

"" Operations {{{

Plug 'tommcdo/vim-exchange'

Plug 'AndrewRadev/sideways.vim'
nnoremap <leader><left> :SidewaysLeft<CR>
nnoremap <leader><right> :SidewaysRight<CR>

Plug 'AndrewRadev/splitjoin.vim'

call plug#end()

au! filetypedetect BufNewFile,BufRead *.ts
au filetypedetect BufNewFile,BufRead *.ts set filetype=typescript

"Markdown
let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json', 'ruby', 'sass', 'xml', 'html']

" Required to be after plug#end()

" TODO use t:title?
function! airline#extensions#tabline#title(n)

  if a:n == tabpagenr()

    let cwd = getcwd()

    if haslocaldir()

      let i = 1

      while i <= winnr('$')
        if !haslocaldir(i)
          let cwd = getcwd(i)
          break
        endif
        let i += 1
      endwhile

    endif

  else

    let cwd = gettabvar(a:n, 'wd')

  endif

  return substitute(fnamemodify(cwd, ':~'), '\v\w\zs.{-}\ze(\\|/)', '', 'g')

endfunction

"}}}

" }}}

" Colorscheme {{{

if &t_Co == 256 || has("gui_running")
  try
    colorscheme aldmeris
  catch
    colorscheme desert
  endtry
else
  colorscheme desert
endif


"}}}

" Mappings {{{

if has("nvim")
  " quick fix for https://github.com/neovim/neovim/issues/2048
  nnoremap <silent> <BS> :<C-U>TmuxNavigateLeft<CR>
endif

"Toggle spellchecker
nnoremap <F11> :setlocal spell!<CR>

"Resync syntax
nnoremap <F12> :syntax sync fromstart<CR>

"Write
nnoremap <Leader>w :w<CR>

"Search commands
""Consistent next/prev result
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]
""Highlight current word
nnoremap <silent> <Leader>/ :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR>
nnoremap <silent> <2-LeftMouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<CR>
""Clear search (and Highlight)
nnoremap <silent> <Leader>\ :let @/=""<CR>
"Search history navigation
nnoremap <silent> [/ :call <SID>search_hist('back')<CR>
nnoremap <silent> ]/ :call <SID>search_hist('forward')<CR>
nnoremap * /\<<C-R>=expand('<cword>')<CR>\><CR>
nnoremap # ?\<<C-R>=expand('<cword>')<CR>\><CR>
nnoremap g* /<C-R>=expand('<cword>')<CR><CR>
nnoremap g# ?<C-R>=expand('<cword>')<CR><CR>

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

"Only works in GUI
nnoremap <C-Tab> :tabnext<CR>
nnoremap <C-S-Tab> :tabprev<CR>
inoremap <C-Tab> <ESC>:tabnext<CR>
inoremap <C-S-Tab> <ESC>:tabprev<CR>

"Show whitespace characters
nnoremap <F7> :set list!<CR>

"Stop accidentaly recording
function! s:MacroMap()
  nnoremap ! q
  nnoremap !! :call <SID>RecordMacro()<cr>
endfunction
function! s:MacroUnmap()
  nunmap !
  nunmap !!
endfunction
function! s:RecordMacro()
  call <SID>MacroUnmap()
  nnoremap ! :call <SID>StopRecordMacro()<cr>
  normal! qq
endfunction
function! s:StopRecordMacro()
  call <SID>MacroMap()
  normal! q
  let @q = substitute(@q, "!$", "", "")
endfunction

let s:regnames = "\"*+~-.:1234567890abcdefghijklmnopqrstuvwxyz"

fun! s:Contains(str, char)
  for c in split(a:str, '\zs')
    if c ==# a:char
      return 1
    endif
  endfor
  return 0
endfun

fun! s:GetRegName()
  let input = getchar()
  if input == 27 || input == 3
    return
  endif
  let char = nr2char(input)
  if !s:Contains(s:regnames, char)
    echo 'macrorepeat: Invalid register name!'
    return ''
  endif
  return char
endfun

nnoremap q <nop>
call <SID>MacroMap()

vnoremap @@ :normal! @@<CR>
" TODO complete this...
" vnoremap @x  

"Visual select last pasted
"http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap gp `[v`]

vnoremap gy ygv<ESC>

"Smart indent pasting
" nnoremap <silent> p :call <SID>smart_paste('p')<CR>
" nnoremap <silent> P :call <SID>smart_paste('P')<CR>
"
" function! s:smart_paste(cmd)
"   exec 'normal! "' . v:register . a:cmd
"   if getregtype(v:register) ==# 'V'
"     normal! =']
"   endif
" endfunction

"Like it should be
nnoremap Y y$

"Save 30% keystrokes
vnoremap <silent> w :<C-U>normal! viw<CR>
omap <silent> w :normal vw<CR>

vnoremap <silent> W :<C-U>normal! vaW<CR>
omap <silent> W :normal vW<CR>

" vnoremap p :<C-U>normal! vip<CR>
" omap p :normal vip<CR>

" vnoremap P :<C-U>normal! vap<CR>
" omap P :normal vap<CR>

"Map U to redo
nnoremap U :redo<CR>

"Squash blank lines
nnoremap <silent> <leader><BS> :call <SID>squash_blank_lines()<CR>

function! s:squash_blank_lines(...)
  let leaveblanklines = a:0 ? a:1 : 1
  let linenum = a:0 > 1 ? a:2 : '.'
  let delstart = prevnonblank(linenum) + 1
  let delend = nextnonblank(linenum) - (leaveblanklines+1)
  if delend - delstart >= 0
    exec delstart . "," . delend . "delete _"
  endif
endfunction

"Move lines up/down
nnoremap <silent> <C-Up>    :call      <SID>moveit('up',    'n')<CR>
nnoremap <silent> <C-Down>  :call      <SID>moveit('down',  'n')<CR>
nnoremap <silent> <C-Left>  :call      <SID>moveit('left',  'n')<CR>
nnoremap <silent> <C-Right> :call      <SID>moveit('right', 'n')<CR>
vnoremap <silent> <C-Up>    :call      <SID>moveit('up',    visualmode())<CR>
vnoremap <silent> <C-Down>  :call      <SID>moveit('down',  visualmode())<CR>
vnoremap <silent> <C-Left>  :call      <SID>moveit('left',  visualmode())<CR>
vnoremap <silent> <C-Right> :call      <SID>moveit('right', visualmode())<CR>
inoremap <silent> <C-Up>    <C-o>:call <SID>moveit('up',    'i')<cr>
inoremap <silent> <C-Down>  <C-o>:call <SID>moveit('down',  'i')<cr>
inoremap <silent> <C-Left>  <C-o>:call <SID>moveit('left',  'i')<CR>
inoremap <silent> <C-Right> <C-o>:call <SID>moveit('right', 'i')<CR>

nnoremap <silent> <S-Up>    :call      <SID>moveit('up',    'n')<CR>
nnoremap <silent> <S-Down>  :call      <SID>moveit('down',  'n')<CR>
nnoremap <silent> <S-Left>  :call      <SID>moveit('left',  'n')<CR>
nnoremap <silent> <S-Right> :call      <SID>moveit('right', 'n')<CR>
vnoremap <silent> <S-Up>    :call      <SID>moveit('up',    visualmode())<CR>
vnoremap <silent> <S-Down>  :call      <SID>moveit('down',  visualmode())<CR>
vnoremap <silent> <S-Left>  :call      <SID>moveit('left',  visualmode())<CR>
vnoremap <silent> <S-Right> :call      <SID>moveit('right', visualmode())<CR>
inoremap <silent> <S-Up>    <C-o>:call <SID>moveit('up',    'i')<cr>
inoremap <silent> <S-Down>  <C-o>:call <SID>moveit('down',  'i')<cr>
inoremap <silent> <S-Left>  <C-o>:call <SID>moveit('left',  'i')<CR>
inoremap <silent> <S-Right> <C-o>:call <SID>moveit('right', 'i')<CR>

function! s:moveit(where, mode) range

  let firstline = a:firstline
  let lastline = a:lastline

  if a:mode !=? 'v' && match(getline('.'), '^\s*$') != -1
    call s:squash_blank_lines(0)
    let firstline = line('.')
    if a:where ==? "up" || a:where ==? "left"
      let firstline = firstline - 1
    endif
    let lastline = firstline
  endif

  let is_prev_line_blank = (match(getline(firstline-1), '^\s*$') != -1)
  let is_next_line_blank = (match(getline(lastline+1), '^\s*$') != -1)

  if is_prev_line_blank && is_next_line_blank

    if a:where ==? "left"
      call s:squash_blank_lines(0, firstline-1)

    elseif a:where  ==? "right"
      call s:squash_blank_lines(0, lastline+1)
      normal k

    elseif a:where ==? "up"
      exec (firstline-1) . "delete _"

    elseif a:where ==? "down"
      exec (lastline+1) . "delete _"
      normal k

    endif

  else

    if a:where ==? "left"

      if is_prev_line_blank
        let targetline = prevnonblank(firstline-1)

      else 
        let match_end_brace = match(getline(firstline-1), '}\(.*}\)\@!')

        if match_end_brace != -1 
          call cursor(firstline-1, match_end_brace)
          normal! %
          let targetline = line('.') - 1

        else
          let targetline = line("'{")
          if targetline == 1
            let targetline = 0
          endif

        endif
      endif

      call s:do_moveit(firstline, lastline, targetline)
      call s:reindent_inner()

      if a:mode ==? 'v'
        normal! gv=
      else
        normal! ==
      endif
      exec "normal =}\<C-o>"

    elseif a:where ==? "right"
      if is_next_line_blank
        let targetline = nextnonblank(lastline+1) - 1
      else
        let match_start_brace = match(getline(lastline+1), '{')

        if match_start_brace != -1 
          call cursor(lastline+1, match_start_brace)
          normal! %
          let targetline = line('.')

        else
          call cursor(lastline, 1)
          let targetline = line("'}")
          if targetline != line('$')
            let targetline = targetline - 1
          endif

        endif
      endif

      call s:do_moveit(firstline, lastline, targetline)
      exec "normal ={\<C-o>"

      if a:mode ==? 'v'
        normal! gv=
      else
        normal! ==
      endif

      call s:reindent_inner()

    elseif a:where ==? "up"
      let targetline = (firstline-2)
      call s:do_moveit(firstline, lastline, targetline)
      call s:reindent_inner()
      if a:mode ==? 'v'
        normal! gv=j==k^
      else
        normal! ==j==k^
      endif

    elseif a:where ==? "down"
      let targetline = (lastline+1)
      if targetline <= line('$')
        call s:do_moveit(firstline, lastline, targetline)
        if a:mode ==? 'v'
          normal! gv=k==j^
        else
          normal! ==k==j^
        endif
        call s:reindent_inner()
      endif

    endif

  endif

  if a:mode ==? 'v'
    normal! gv^
  endif

endfunction

function! s:reindent_inner()
  let line = getline('.')
  if match(line, '^\s*[()\[\]{}]') != -1
    normal! ^=%``
  endif
  if match(line, '[()\[\]{}]\s*$') != -1
    normal! $=%``
  endif
endfunction

function! s:do_moveit(first, last, target)
  " https://github.com/vim/vim/issues/536
  let saveFoldMethod = &fdm
  let &fdm = "manual"

  exec a:first . "," . a:last . "move" a:target

  let &fdm = saveFoldMethod
endfunction


"New space
nnoremap <Leader><Space> i<Space><ESC>l

"New lines
nnoremap <Leader><CR> i<CR><ESC>

nnoremap <silent> <Leader>O :<C-U>call <SID>InsertBlankLine('n-up', v:count1)<CR>
nnoremap <silent> <Leader>o :<C-U>call <SID>InsertBlankLine('n-down', v:count1)<CR>

vnoremap <silent> <Leader>o :call <SID>InsertBlankLine(visualmode(), v:count1)<CR>

inoremap <silent> <C-o><C-o> <C-\><C-o>:call <SID>InsertBlankLine('n-both', 1)<CR>
inoremap <silent> <C-o><C-i> <C-o>"_cc

function! s:InsertBlankLine(type, count) range
  let what = repeat([''], a:count)

  if a:type ==? 'v'
    exec "normal! `>a\<CR>\<ESC>`<i\<CR>\<ESC>" . (a:firstline+1) . "GV" .  (a:lastline+1) . "G"
  endif

  if a:type ==# 'n-down' || a:type ==# 'n-both'
    call append(a:lastline, what)
  endif

  if a:type ==# 'n-up' || a:type ==# 'n-both'
    call append(a:firstline-1, what)
  endif
endfunction


"Indent visual
vnoremap > >gv
vnoremap < <gv
vnoremap = =gv

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

"Bash style command line
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

"Easier line start/end movement
nnoremap H ^
vnoremap H ^
onoremap H ^
nnoremap L g_
vnoremap L g_
onoremap L g_
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$

"Toggle relative line numbers
nnoremap <leader>l :set relativenumber!<CR>

"Don't need help right now, thanks
inoremap <F1> <Nop>
nnoremap <F1> <Nop>

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

"You Paste
nnoremap <silent><expr> _ ':let b:silly="' . v:register . '"<CR>:set opfunc=<SID>YouPaste<CR>g@'
nnoremap <silent><expr> __ 'V:<C-U>let b:silly="' . v:register . '"<CR>:<C-U>call <SID>YouPaste(visualmode(), 1)<CR>'
vnoremap <silent><expr> p ':<C-U>let b:silly="' . v:register . '"<CR>:<C-U>call <SID>YouPaste(visualmode(), 1)<CR>'
function! s:YouPaste(type, ...)
  if a:0
    let [mark1, mark2] = ['`<', '`>']
  else
    let [mark1, mark2] = ['`[', '`]']
  endif
  exec 'normal! ' . mark1 . 'v' . mark2 . '"_d"' . b:silly . 'P'
endfunction

"Duplicate
nnoremap <silent> + :set opfunc=<SID>DuplicateDown<CR>g@
nnoremap <silent> ++ V:<C-U>call <SID>DuplicateDown(visualmode())<CR>
vnoremap <silent> + :<C-U>call <SID>DuplicateDown(visualmode())<CR>
function! s:DuplicateUp(type)
  call <SID>Duplicate(a:type, 'up')
endfunction
function! s:DuplicateDown(type)
  call <SID>Duplicate(a:type, 'down')
endfunction
function! s:Duplicate(type, direction)
  let vselect = a:type
  if a:type ==? 'v'
    let [mark1, mark2] = ['`<', '`>']
  else
    let [mark1, mark2] = ['`[', '`]']
  endif
  if a:type == 'char'
    let vselect = 'v'
  elseif vselect == 'line' || vselect == 'block'
    let vselect = 'V'
  endif
  let vselect = mark1 . vselect . mark2
  exec 'normal! ' . vselect . '"hy'
  if a:direction ==? 'up'
    normal! `<"hP
  else
    normal! `>"hp
  endif
endfunction

"Duplicate and comment
nnoremap <silent> \+ :set opfunc=<SID>DuplicateAndComment<CR>g@
nnoremap <silent> \++ V:<C-U>call <SID>DuplicateAndComment(visualmode())<CR>
vnoremap <silent> \+ :<C-U>call <SID>DuplicateAndComment(visualmode())<CR>
function! s:DuplicateAndComment(type)
  if a:type ==? 'v'
    let [mark1, mark2] = ['`<', '`>']
  else
    let [mark1, mark2] = ['`[', '`]']
  endif
  let vselect = a:type
  if vselect == 'char'
    let vselect = 'v'
  elseif vselect == 'line' || vselect == 'block'
    let vselect = 'V'
  endif
  let vselect = mark1 . vselect . mark2
  exec 'normal! ' . vselect . '"hy' . vselect . ":TComment\<CR>"
  '>put h
  if match(getline(line("'<")-1), '^\s*$') != -1
    call append(line("'>"), '')
  endif
endfunction

"Quick formatting
nnoremap \q gwip
vnoremap \q gw

"Clear a line
nnoremap dc cc<esc>

"Swap quotes
nnoremap <silent> <leader>' :call <SID>SwapQuotes()<CR>
function! s:SwapQuotes()
  let origline = line('.')
  let origcol = col('.')
  exec "norm! va'o"
  exec "norm! \<Esc>"
  let singlecol = col('.')
  if singlecol == origcol && getline('.')[singlecol-1] != "'" || singlecol > origcol
    let singlecol = -1
  endif
  call cursor(origline, origcol)
  exec "norm! va\"o"
  exec "norm! \<Esc>"
  let doublecol = col('.')
  if doublecol == origcol && getline('.')[doublecol-1] != '"' || doublecol > origcol
    let doublecol = -1
  endif
  call cursor(origline, origcol)
  if singlecol > doublecol
    norm cs'"
  else
    norm cs"'
  endif
endfunction

"Factor out
" vnoremap <silent> <leader>f :call inputsave()<CR>gvc<C-R>=input("variable name: ")<CR><ESC>:call inputrestore()<CR>Ovar <C-R>. = ;<ESC>PA<CR><ESC>kWVjj:MultipleCursorFind __factored__<CR>c
vnoremap <silent> <C-X>v :call <SID>ExtractVariable(visualmode())<CR>
function! s:ExtractVariable(mode) range

  call inputsave()
  let name = input("Name: ")
  call inputrestore()

  if name == ""
    return
  endif

  exec "normal! `<v`>".(a:mode ==# 'V' ? "h" : "")."\"hd"

  let @h = matchstr(@h, '^\v\_s*\zs.{-}\ze\_s*$')

  exec "normal! i".name."\<ESC>Ovar ".name." = \<C-R>h;\<CR>\<ESC>k^W"

endfunction

vnoremap <silent> <C-X>f :call <SID>ExtractFunction(visualmode())<CR>
function! s:ExtractFunction(mode) range

  call inputsave()
  let name = input("Name: ")
  call inputrestore()

  if name == ""
    return
  endif

  exec "normal! `<v`>".(a:mode ==# 'V' ? "h" : "")."\"hd"

  let @h = matchstr(@h, '^\v\_s*\zs.{-}\ze\_s*$')

  exec "normal! i".name."()\<ESC>ofunction ".name."() {\<CR>\<C-R>h\<CR>}\<ESC>V%"

endfunction

"Uppercase first letter and insert
nnoremap gi gUli

nnoremap <silent> [[ :call searchpair('\[', '', '\]', 'bW')<CR>
nnoremap <silent> ]] :call searchpair('\[', '', '\]', 'W')<CR>

"}}}

" Commands {{{

nnoremap <silent> <C-W>z :call <SID>CloseThing()<ESC>
function! s:CloseThing()
  let qfnum = 0
  let ctrlsfnum = 0
  let previewnum = 0

  for winnum in range(1, winnr('$'))
    let ft = getwinvar(winnum, "&filetype")
    if ft == "qf"
      let qfnum = winnum
    elseif ft == "ctrlsf"
      let ctrlsfnum = winnum
    elseif getwinvar(winnum, "&previewwindow")
      let previewnum = winnum
    endif
  endfor

  let closenum = 0

  if previewnum != 0
    let closenum = previewnum
  elseif qfnum != 0
    let closenum = qfnum
  elseif ctrlsfnum != 0
    let closenum = ctrlsfnum
  endif

  if closenum != 0
    exec closenum . "close"
  endif
endfunction

command! CountMatches %s///rn

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

"ONLY
command! ONLY only | tabonly

command! SyntaxGroup call <SID>SyntaxGroup()
function! s:SyntaxGroup()
  let id = synID(line('.'), col('.'), 1)
  let name = synIDattr(id, 'name')
  let transName = synIDattr(synIDtrans(id), 'name')
  echo  name . ' -> ' . transName
  exec "verb hi" transName
endfunction

nnoremap <F10> :Scratch<CR>
command! -nargs=? -complete=syntax Scratch call <SID>NewScratch(<f-args>)
function! s:NewScratch(...)
  let type = a:0 ? a:1 : 'markdown'

  if &ft == 'nerdtree'
    enew
  else
    vnew
  endif

  exec "setf" type
endfunction

command! CountPlugins echo len(keys(g:plugs))

command! -range MakeRelative call <SID>MakeRelative()
function! s:MakeRelative()
  let [line1, col1] = getpos("'<")[1:2]
  let [line2, col2] = getpos("'>")[1:2]

  if line1 != line2
    echoerr "This won't work over multiple lines...."
    return
  endif

  let path = getline(line1)[col1 - 1 : col2 - 1]

  if path == ""
    let path = getcwd()
  endif

  python import vim
  python import os.path
  let relpath = pyeval("os.path.relpath(vim.eval('path'), os.path.dirname(vim.current.buffer.name))")

  echo relpath
endfunction
"}}}

" AutoCommands {{{

" " http://www.bestofvim.com/tip/auto-reload-your-vimrc/
" augroup reload_vimrc
"   autocmd!
"   autocmd BufWritePost $MYVIMRC,~/Code/rc/vimrc,~/Code/rc/vim/* nested source $MYVIMRC
" augroup END

" Close vim if NERDTree is the last window
augroup nerdtree_vimrc
  autocmd!
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" Show cursorline only on current window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

"Load opend file on last known position
augroup LoadLastKnownPosition
  au!
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup JSONRC
  au!
  auto BufNewFile,BufRead .jscsrc,.jshintrc setf json
augroup END

augroup js
  au!
  au FileType javascript UltiSnipsAddFiletypes javascript.javascript-angular.javascript-jasmine
augroup END

augroup folds
  au!
  au CursorHold,BufWinEnter * call CheckFolds()
augroup END

fu! CheckFolds()
  let hasfolds = 0

  if foldlevel('.') > 0
    let hasfolds = 1

  else
    let view = winsaveview()
    let currentline = line('.')

    normal! zk

    if line('.') != l:currentline
      let hasfolds = 1
    else

      normal! zj

      if line('.') != l:currentline
        let hasfolds = 1
      endif

    endif

    call winrestview(l:view)
  endif

  let &foldcolumn = l:hasfolds
endfu

"}}}

" vim: set fdm=marker fdl=999:
