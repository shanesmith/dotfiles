" Settings {{{

" Let's make sure that all the annoying bugs in VI are not displayed in VIM.
set nocompatible

"Faster ESC timeout
set timeout ttimeoutlen=100

"Faster CursorHold and swap file writes
set updatetime=100

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

"Disable folding by default
set foldmethod=manual
set foldlevel=999

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
set visualbell
set t_vb=

"Show cursorline
set cursorline

"Command tab completion behaviour
set wildmode=longest:full,full

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
set relativenumber

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

"Syntax highlighting
syntax on

"File type detection and plugin loading
filetype plugin indent on

"Mode is shown in status bar
set noshowmode

"Scroll offset
set scrolloff=5

"Split pane to right when :vsplit
set splitright

"Don't highlight long lines
set synmaxcol=800

"What to show in character list
set list
set listchars=tab:▸\ ,extends:❯,precedes:❮
set showbreak=↪

if has('nvim')
  " preview of commands
  set inccommand=split

  " Alpha blending for pum and floating windows
  set pumblend=20
  set winblend=20

  "Allow up to 3 characters for the sign column
  set signcolumn=auto:3
endif

"Paste from system clipboard
set clipboard=unnamed,unnamedplus

"Auto read file changes
set autoread

"Set leader character
let mapleader = "\<Space>"
let maplocalleader = "\\"

"Default filetype=sh to bash syntax
let is_bash=1

"}}} Settings

" Plugins {{{

call plug#begin('~/.vim/bundle')

"" File Navigation and Search {{{

Plug 'kkoomen/gfi.vim'

Plug 'thinca/vim-visualstar'

Plug 'dyng/ctrlsf.vim'
let g:ctrlsf_auto_close = 0
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_populate_qflist = 1
let g:ctrlsf_indent = 2
let g:ctrlsf_winsize = "30%"
let g:ctrlsf_compact_winsize = "30%"
let g:ctrlsf_auto_focus = {
      \ "at": "start",
      \ }
let g:ctrlsf_mapping = {
      \ "split": [ "<C-S>" ],
      \ "vsplit": [ "<C-V>" ],
      \ "tab": { "key": [ "<C-T>" ], "suffix": ":CtrlSFOpen<CR>" },
      \ "next": "n",
      \ "prev": "N"
      \ }
nmap <leader>c <Plug>CtrlSFPrompt
nnoremap <expr> <leader>C ':CtrlSF ' . ctrlsf#opt#GetOpt("pattern")
vmap <leader>c <Plug>CtrlSFVwordPath
nnoremap <silent> <leader>/c :call <SID>CtrlSFSetSearch()<CR>

function! s:CtrlSFSetSearch()
  let  @/=ctrlsf#pat#Regex()
  call histadd('search', @/)
endfunction

function! g:CtrlSFAfterMainWindowInit()
  nnoremap <silent><buffer> <CR> :call <SID>CtrlSFOpenWithPreviousWindow()<CR>
  nnoremap <silent><buffer> <C-CR> :call <SID>CtrlSFChooseWindowOpen()<CR>
  nnoremap <silent><buffer> <C-E> :call <SID>CtrlSFNextFile('')<CR>
  nnoremap <silent><buffer> <C-Y> :call <SID>CtrlSFNextFile('b')<CR>
  nnoremap <silent><buffer> n :call <SID>CtrlSFNextMatch(1)<CR>
  nnoremap <silent><buffer> N :call <SID>CtrlSFNextMatch(0)<CR>
endfunction

function! s:CtrlSFNextMatch(forward)
  if @/ == ""
    call ctrlsf#NextMatch(a:forward)
    return
  endif

  exec "normal! " . 'Nn'[a:forward]
endfunction

function! s:CtrlSFNextFile(flags)
  let curline = getline('.')
  let curfile = strpart(curline, 0, stridx(curline, '|'))

  call search('^\%(' . curfile . '\)\@!', a:flags)
endfunction

function! s:CtrlSFOpenWithPreviousWindow()
    let [file, line, match] = ctrlsf#view#Locate(line('.'))

    if empty(file) || empty(line)
      return
    endif

    if g:ctrlsf_confirm_unsaving_quit && !ctrlsf#buf#WarnIfChanged()
      return
    endif

    wincmd p

    if bufname('%') !=# file
      if &modified && !&hidden
          exec 'silent vertical split ' . fnameescape(file)
      else
        exec 'silent edit ' . fnameescape(file)
      endif
    endif

    let lnum = line.lnum
    let col  = empty(match)? 0 : match.col

    call ctrlsf#win#MoveCursorCentral(lnum, col)

    if g:ctrlsf_selected_line_hl =~ 'o'
      call ctrlsf#hl#HighlightSelectedLine()
    endif
endfunction

function! s:CtrlSFChooseWindowOpen()
    let [file, line, match] = ctrlsf#view#Locate(line('.'))

    if empty(file) || empty(line)
      return
    endif

    if g:ctrlsf_confirm_unsaving_quit && !ctrlsf#buf#WarnIfChanged()
      return
    endif

    let winnr = input("Window: ")

    if !winnr
      return
    endif

    execute winnr . "wincmd w"

    if bufname('%') !=# file
      if &modified && !&hidden
          exec 'silent vertical split ' . fnameescape(file)
      else
        exec 'silent edit ' . fnameescape(file)
      endif
    endif

    let lnum = line.lnum
    let col  = empty(match)? 0 : match.col

    call ctrlsf#win#MoveCursorCentral(lnum, col)

    if g:ctrlsf_selected_line_hl =~ 'o'
      call ctrlsf#hl#HighlightSelectedLine()
    endif
endfunction

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
nnoremap <C-p> :Files<CR>
nnoremap <leader>g<C-p> :GFiles?<CR>

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

let g:fzf_layout = { 
      \ 'window': 'call FloatingFZF()'
      \ }

fun! FloatingFZF()
  let width = float2nr(&columns * 0.8)
  let height = float2nr(&lines * 0.4)
  let opts = {
        \     'relative': 'editor',
        \     'row': (&lines - height) / 5,
        \     'col': (&columns - width) / 2,
        \     'width': width,
        \     'height': height,
        \     'style': 'minimal'
        \ }
  call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
endf

" TODO port these over to FZF?

" function! s:CtrlPEnter()
"   nnoremap <buffer> <c-y> :call <SID>CtrlPYank()<CR>
"   nnoremap <buffer> <c-p> :call <SID>CtrlPPaste()<CR>
" endfunction
"
" function! s:CtrlPYank()
"   let lines = <SID>CtrlPGetLines()
"
"   if empty(lines)
"     return
"   endif
"
"   let @* = join(lines, "\n")
" endfunction
"
" function! s:CtrlPPaste()
"   let lines = <SID>CtrlPGetLines()
"
"   if empty(lines)
"     return
"   endif
"
"   exec "normal! a" . join(lines, "\n")
" endfunction
"
" function! s:CtrlPGetLines()
"   echo "What modifier? (a|r|i)"
"
"   let modify = nr2char(getchar())
"
"   if modify == nr2char(27) "escape
"     call feedkeys("\<c-e>") " redraw CtrlP prompt
"     return
"   endif
"
"   let lines = []
"   let marked = ctrlp#getmarkedlist()
"
"   if !empty(marked)
"     let lines = values(marked)
"   else
"     let lines = [ctrlp#getcline()]
"   en
"
"   cal ctrlp#exit()
"
"   call map(lines, {idx, val -> <SID>CtrlPYankFormat(val, modify)})
"
"   return lines
" endfunction
"
" let g:ctrlp_yank_path = ''
"
" function! s:CtrlPYankFormat(val, mod)
"   if a:mod == "a" || a:mod == "\<c-a>"
"     return fnamemodify(a:val, ':p')
"   elseif a:mod == "r" || a:mod == "\<c-r>"
"     let g:ctrlp_yank_path = fnamemodify(a:val, ':p')
"     return <SID>PyEval("os.path.relpath(vim.eval('g:ctrlp_yank_path'), os.path.dirname(vim.current.buffer.name))")
"   elseif a:mod == "i" || a:mod == "\<c-i>"
"     let g:ctrlp_yank_path = fnamemodify(a:val, ':p')
"     let path = <SID>PyEval("os.path.relpath(vim.eval('g:ctrlp_yank_path'), os.path.dirname(vim.current.buffer.name))")
"     if path !~ '^\.\.\/'
"       let path = "./" . path
"     endif
"     return fnamemodify(path, ':r')
"   endif
"
"   return a:val
" endfunction
"
" function! s:PyEval(script)
"   if has('python3')
"     return py3eval(a:script)
"   endif
"
"   return pyeval(a:script)
" endfunction

" Plug 'mattn/ctrlp-register'
" nnoremap <leader>pr :CtrlPRegister<CR>

" Plug 'shanesmith/ctrlp-filetype'
" nnoremap <leader>pf :CtrlPFiletype<CR>

" Plug 'nixprime/cpsm', { 'do': 'brew install cmake boost && ./install.sh' }

" Plug 'fisadev/vim-ctrlp-cmdpalette'

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern-mapping-git.vim'
Plug 'LumaKernel/fern-mapping-fzf.vim'
let g:fern#renderer#default#leaf_symbol = "  "
let g:fern#renderer#default#collapsed_symbol = "▸ "
let g:fern#renderer#default#expanded_symbol = "▾ "
let g:fern#disable_default_mappings = 1
let g:fern#scheme#file#show_absolute_path_on_root_label = 1
highlight link FernGitStained  Special
highlight link FernGitModified Special
highlight link FernGitUnmerged Special
highlight link FernGitStaged   Type
highlight link FernGitCleaned  Type
nnoremap <silent> <C-t> :Fern . -reveal=%<CR>
nnoremap <silent> <leader>tf :Fern . -reveal=%<CR>
nnoremap <silent> <leader>tv :Fern . -reveal=% -opener=vsplit<CR>
nnoremap <silent> <leader>ts :Fern . -reveal=% -opener=split<CR>
nnoremap <silent> <leader>ty :Fern . -reveal=% -opener=tabedit<CR>
nnoremap <silent> <Leader>tr :Fern ~/Code/rc -opener=tabedit<CR>

function! s:init_fern() abort
  nmap <buffer> h <Plug>(fern-action-collapse)
  nmap <buffer> l <Plug>(fern-action-open-or-expand)
  nmap <buffer> I <Plug>(fern-action-hidden:toggle)
  nmap <buffer> u <Plug>(fern-action-leave)
  nmap <buffer> C <Plug>(fern-action-enter)
  nmap <buffer> c <Plug>(fern-action-cd)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> t <Plug>(fern-action-open:tabedit)

  nmap <buffer> A <Plug>(fern-action-new-path)

  nmap <buffer> dd <Plug>(fern-action-remove)
  nmap <buffer> yy <Plug>(fern-action-clipboard-copy)
  nmap <buffer> xx <Plug>(fern-action-clipboard-move)
  nmap <buffer> p <Plug>(fern-action-clipboard-paste)

  nmap <buffer> m <Plug>(fern-action-mark)j
  nmap <buffer> M <Plug>(fern-action-mark)k

  nmap <buffer> << <Plug>(fern-action-git-stage)
  nmap <buffer> >> <Plug>(fern-action-git-unstage)

  nmap <buffer> <C-c> <Plug>(fern-action-cancel)
  nmap <buffer> <C-g> <Plug>(fern-action-reveal)

  vmap <buffer> m <Plug>(fern-action-mark)
  vmap <buffer> dd <Plug>(fern-action-mark)<Plug>(fern-action-remove)
  vmap <buffer> yy <Plug>(fern-action-mark)<Plug>(fern-action-clipboard-copy)
  vmap <buffer> xx <Plug>(fern-action-mark)<Plug>(fern-action-clipboard-move)

  nmap <buffer> ff <Plug>(fern-action-fzf-files)
  nmap <buffer> fd <Plug>(fern-action-fzf-dirs)
  nmap <buffer> fa <Plug>(fern-action-fzf-both)
endfunction

function! s:VimEnterFern()

  if exists("s:std_in")
    return
  endif

  if argc() != 0
    if isdirectory(argv(0))
      exec "cd" argv(0)
    else
      return
    endif
  endif

  Fern . -wait

endfunction

augroup my-fern
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

augroup VimEnterFern
  au!
  au StdinReadPre * let s:std_in=1
  au VimEnter * ++nested call <SID>VimEnterFern()
augroup END

Plug 'henrik/vim-qargs'

Plug 'chrisbra/Recover.vim'

Plug 'francoiscabrol/ranger.vim'
nnoremap <C-f> :Ranger<CR>

Plug 'rbgrouleff/bclose.vim'

Plug 'tpope/vim-projectionist'
nnoremap <leader>aa :A<CR>
nnoremap <leader>av :AV<CR>
nnoremap <leader>as :AS<CR>

function! s:alternates() abort
  let alternates = projectionist#query_file('alternate', {})
  let source = []
  for path in alternates
    call add(source, fnamemodify(path, ':~:.'))
  endfor
  let options = { 'source': source }
  call fzf#run(fzf#wrap('Alternates', options))
endfunction
comm! Alternates :call s:alternates()

"}}}

"" Utilities {{{

Plug 'axvr/zepl.vim'
augroup zepl
  autocmd!
  autocmd FileType python     let b:repl_config = { 'cmd': 'python3' }
  autocmd FileType javascript let b:repl_config = { 'cmd': 'node' }
  autocmd FileType clojure    let b:repl_config = { 'cmd': 'clj' }
  autocmd FileType scheme     let b:repl_config = { 'cmd': 'rlwrap csi' }
  autocmd FileType lisp       let b:repl_config = { 'cmd': 'sbcl' }
  autocmd FileType julia      let b:repl_config = { 'cmd': 'julia' }
  autocmd FileType ruby       let b:repl_config = { 'cmd': 'pry' }
augroup END

Plug 'metakirby5/codi.vim'
let g:codi#rightalign = 0

command! REPL call <SID>repl_tab("javascript")
function! s:repl_tab(type)
  tabnew
  exe 'setf' a:type
  setlocal bt=nofile
  exe 'Codi' a:type
endfunction

Plug 'roxma/python-support.nvim'
let g:python_support_python3_venv = 0
let g:python_support_python2_venv = 0
let g:python_host_prog = "/usr/local/bin/python2"
let g:python3_host_prog = "/usr/local/bin/python3"
" PythonSupportInitPython3

Plug 'lambdalisue/gina.vim'

Plug 'tpope/vim-fugitive'
nnoremap <leader>g :vert G
nnoremap <leader>gg :vert G<CR>
command! GResolve Gwrite | Git mergetool

Plug 'rhysd/git-messenger.vim'

Plug 'tpope/vim-rhubarb'

Plug 'vim-utils/vim-husk'
cnoremap <expr> <M-Left> husk#left()
cnoremap <expr> <M-Right> husk#right()

Plug 'tyru/restart.vim'

Plug 'diepm/vim-rest-console'
let g:vrc_trigger = '<C-R>'
let g:vrc_show_command = 1
let g:vrc_curl_opts = {
      \ '--include': '',
      \ '--silent': '',
      \ '--show-error': ''
      \ }
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
        \ "#",
        \ "# Ctrl-R to run the query",
        \ ""
        \ ])
endfunction


"TODO deprecated, check out https://github.com/mg979/vim-visual-multi
" Plug 'terryma/vim-multiple-cursors'
let g:multi_cursor_exit_from_visual_mode = 0
let g:multi_cursor_exit_from_insert_mode = 0

Plug 'mg979/vim-visual-multi'

Plug 'tpope/vim-eunuch'

Plug 'rhysd/committia.vim'
let g:committia_open_only_vim_starting = 0

Plug 'AndrewRadev/switch.vim'
let g:switch_mapping = "-"

" TODO handle generics
"          const xyzzy = <T>(foo: T): baz => qq
"          function xyzzy<T>(foo: T): baz => qq
let g:switch_custom_definitions =
      \ [
      \   ['left', 'right'],
      \   ['top', 'bottom'],
      \   ['padding', 'margin'],
      \   ['absolute', 'relative', 'fixed'],
      \   ['public', 'private', 'protected'],
      \   {
      \     '\(async \)\?function\s*\(\k\+\)\s*(\([^()]\{-}\))\s*:\s*\([^{]\{-1,}\)\s*{':                        'const \2 = \1(\3): \4 => {',
      \     '\%(var \|let \|const \)\?\(\k\+\)\s*=\s*\(async \)\?(\([^()]\{-}\))\s*:\s*\([^}]\{-1,}\)\s*=>\s*{': '\2function \1(\3): \4 {',
      \   },
      \ ]

autocmd FileType ruby let b:switch_definitions =
      \ [
      \   g:switch_builtins.ruby_hash_style,
      \   g:switch_builtins.ruby_oneline_hash,
      \   g:switch_builtins.ruby_lambda,
      \   g:switch_builtins.rspec_should,
      \   g:switch_builtins.rspec_expect,
      \   g:switch_builtins.rspec_to,
      \   g:switch_builtins.rspec_be_truthy_falsey,
      \   g:switch_builtins.ruby_string,
      \   g:switch_builtins.ruby_short_blocks,
      \   g:switch_builtins.ruby_array_shorthand,
      \   g:switch_builtins.ruby_fetch,
      \   g:switch_builtins.ruby_assert_nil,
      \   ['if', 'unless'],
      \ ]

autocmd FileType javascript,typescript,javascriptreact,typescriptreact let b:switch_custom_definitions =
      \ [
      \   ['test.only(', 'test.skip(', 'test('],
      \   ['it.only(', 'it.todo(', 'it('],
      \ ]

Plug 'lfilho/cosco.vim'
autocmd FileType javascript,typescript.tsx,typescript,typescriptreact,php,css,scss,java,c,cpp nnoremap <buffer> <silent> ;; :call <SID>custom_cosco()<CR>
autocmd FileType javascript,typescript.tsx,typescript,typescriptreact,php,css,scss,java,c,cpp vnoremap <buffer> <silent> ;; :call cosco#commaOrSemiColon()<CR>
autocmd FileType javascript,typescript.tsx,typescript,typescriptreact,php,css,scss,java,c,cpp inoremap <buffer> <silent> ;; <C-o>:call <SID>custom_cosco()<CR>
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

" TODO update unimpaired plugin?
if exists(":cabove")
  nnoremap ]l :<C-u>exec (v:count ? v:count : "")."lbelow"<CR>zv
  nnoremap [l :<C-u>exec (v:count ? v:count : "")."labove"<CR>zv
  nnoremap ]q :<C-u>exec (v:count ? v:count : "")."cbelow"<CR>zv
  nnoremap [q :<C-u>exec (v:count ? v:count : "")."cabove"<CR>zv
endif

" UnconditionalPaste style character or line wise forced paste
function! s:CharPaste(p, ...)
  let register = a:0 ? a:1 : v:register
  let l:original_reg = getreg(register)
  let l:original_reg_type = getregtype(register)
  let l:stripped_reg = substitute(l:original_reg, '\v^%(\n|\s)*(.{-})%(\n|\s)*$', '\1', '')
  call setreg(register, l:stripped_reg, 'c')
  exe 'normal "' . register . a:p
  call setreg(register, l:original_reg, l:original_reg_type)
endfunction
function! s:LinePaste(p, ...)
  let register = a:0 ? a:1 : v:register
  let l:original_reg = getreg(register)
  let l:original_reg_type = getregtype(register)
  call setreg(register, l:original_reg, 'l')
  exe 'normal "' . register . a:p
  call setreg(register, l:original_reg, l:original_reg_type)
endfunction
nnoremap <silent> zp :<c-u>call <SID>CharPaste('p')<cr>
nnoremap <silent> zP :<c-u>call <SID>CharPaste('P')<cr>
nnoremap <silent> Zp :<c-u>call <SID>LinePaste('p')<cr>
nnoremap <silent> ZP :<c-u>call <SID>LinePaste('P')<cr>

Plug 'KabbAmine/lazyList.vim'

Plug 'machakann/vim-sandwich'
" disables ib,ab, is and as object mappings so that the tagets plugin can handle them
let g:textobj_sandwich_no_default_key_mappings = 1
" disables sdb and srb, but also sd and sr so we need to redefine them
let g:sandwich_no_default_key_mappings = 1
let g:sandwich#recipes = [
      \   {
      \     'buns':         ['(', ')'],
      \     'nesting':      1,
      \     'match_syntax': 1,
      \     'input':        ['(', 'b'],
      \   },
      \   {
      \     'buns':         ['{', '}'],
      \     'nesting':      1,
      \     'match_syntax': 1,
      \     'skip_break':   1,
      \     'input':        ['{', 'B'],
      \   },
      \ ]
    " \   {
    " \     'buns':         ['{\', '\}'],
    " \     'nesting':      1,
    " \     'match_syntax': 1,
    " \     'skip_break':   1,
    " \     'input':        ['}'],
    " \   },
    " \   {
    " \     'buns':         ['[\', '\]'],
    " \     'nesting':      1,
    " \     'match_syntax': 1,
    " \     'input':        [']'],
    " \   },
    " \   {
    " \     'buns':         ['(\', '\)'],
    " \     'nesting':      1,
    " \     'match_syntax': 1,
    " \     'input':        [')'],
    " \   },

silent! nmap <unique><silent> sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
silent! nmap <unique><silent> sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)

Plug 'tpope/vim-abolish'

Plug 'tpope/vim-endwise'
let g:endwise_no_mappings = 1

Plug 'vim-scripts/ingo-library'

Plug 'embear/vim-localvimrc'
let g:localvimrc_sandbox=0
let g:localvimrc_persistent=1

Plug 'szw/vim-maximizer'
let g:maximizer_default_mapping_key = '<F4>'

Plug 'sjl/gundo.vim'

Plug 'dohsimpson/vim-macroeditor'

Plug 'machakann/vim-highlightedyank'
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif

Plug 'Konfekt/vim-alias'

Plug 'meain/vim-package-info', { 'do': 'npm install' }

Plug 'kassio/neoterm'
let g:neoterm_default_mod = 'vertical'

Plug 'Shopify/shadowenv.vim'

"}}}

"" LOLz {{{

Plug 'koron/nyancat-vim'

Plug 'shanesmith/hackertyper.vim'

Plug 'uguu-org/vim-matrix-screensaver'

Plug 'mattn/vim-starwars'

"}}}

"" Display {{{

Plug 'arcticicestudio/nord-vim'

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'gf3/molotov'

Plug 'jeffkreeftmeijer/vim-dim', { 'branch': 'main' }

Plug 'vim-scripts/molokai'

Plug 'aonemd/kuroi.vim'

Plug 'gosukiwi/vim-atom-dark'

Plug 'dunstontc/vim-vscode-theme'

Plug 'romainl/Apprentice'

Plug 'RRethy/vim-illuminate'

" Plug 'TaDaa/vimade'

Plug 'gcmt/taboo.vim'
let g:taboo_tab_format = "%P%m"

Plug 'vim-airline/vim-airline'
let g:airline_inactive_collapse = 0
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ""
let g:airline_right_sep = ""
let g:airline#extensions#tabline#alt_sep = 1
let g:airline#extensions#tabline#left_sep = ""
let g:airline#extensions#tabline#left_alt_sep = "|"
let g:airline#extensions#tabline#right_sep = ""
let g:airline#extensions#tabline#right_alt_sep = ""
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#tmuxline#enabled = 0
let g:airline_section_b = '%{winnr()}'
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

let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
  let a:palette.inactive.airline_b[0] = "#CCCCCC"
  let a:palette.inactive.airline_c[0] = "#CCCCCC"
endfunction

Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = 'hard'

"TODO use https://github.com/RRethy/vim-hexokinase ?
Plug 'chrisbra/Colorizer'
let g:colorizer_auto_filetype='css,scss,sass'
let g:colorizer_auto_color = 0
let g:colorizer_colornames = 0
let g:colorizer_use_virtual_text = 1

Plug 'vim-scripts/ConflictDetection'
let g:ConflictDetection_WarnEvents = ''

Plug 'kshenoy/vim-signature'
" GotoNext/PrevMarkerAny unmap due to conflict with conflictmotions
nnoremap m <nop>
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
let g:gitgutter_preview_win_floating = 0
nmap ]- <Plug>(GitGutterNextHunk)
nmap [- <Plug>(GitGutterPrevHunk)
nnoremap <leader>- <nop>
nmap <leader>-s <Plug>(GitGutterStageHunk)
nmap <leader>-r <Plug>(GitGutterUndoHunk)
nmap <leader>-p <Plug>(GitGutterPreviewHunk)
omap i- <Plug>(GitGutterTextObjectInnerPending)
omap a- <Plug>(GitGutterTextObjectOuterPending)
xmap i- <Plug>(GitGutterTextObjectInnerVisual)
xmap a- <Plug>(GitGutterTextObjectOuterVisual)

Plug 'vim-scripts/SyntaxRange'

Plug 'lfv89/vim-interestingwords'
nmap <leader>k <Plug>InterestingWords
vmap <leader>k <Plug>InterestingWords
nmap <leader>K <Plug>InterestingWordsClear

Plug 'shanesmith/matchtag'

Plug 'Yggdroot/indentLine'

"}}}

"" Motions {{{

Plug 'justinmk/vim-sneak'
let g:sneak#use_ic_scs = 1
let g:sneak#streak = 1
let g:sneak#s_next = 1
let g:sneak#label = 1
nmap ]; <Plug>SneakNext
vmap ]; <Plug>VSneakNext
nmap [; <Plug>SneakPrevious
vmap [; <Plug>VSneakPrevious

"TODO replace this and ConflictDetection with https://github.com/rhysd/conflict-marker.vim ?
Plug 'vim-scripts/ConflictMotions'
" avoid conflict with vim-textobj-xmlattr
let g:ConflictMotions_ConflictMapping = 'X'
let g:ConflictMotions_SectionMapping = '='
nnoremap <leader>x= :ConflictTake both<CR>
nnoremap <leader>x+ :ConflictTake both<CR>
" prevent accidental character deletion
nnoremap <leader>x <nop>

Plug 'vim-scripts/CountJump'

Plug 'andymass/vim-matchup'
let g:matchup_matchparen_status_offscreen = 0

Plug 'machakann/vim-columnmove'
let g:columnmove_no_default_key_mappings = 1
let g:columnmove_strict_wbege = 0
nmap ]c <Plug>(columnmove-E)
xmap ]c <Plug>(columnmove-E)
omap ]c <Plug>(columnmove-E)
nmap [c <Plug>(columnmove-B)
xmap [c <Plug>(columnmove-B)
omap [c <Plug>(columnmove-B)
nmap ]C <Plug>(columnmove-W)
xmap ]C <Plug>(columnmove-W)
omap ]C <Plug>(columnmove-W)
nmap [C <Plug>(columnmove-gE)
xmap [C <Plug>(columnmove-gE)
omap [C <Plug>(columnmove-gE)


"}}}

"" Formatting {{{

Plug 'editorconfig/editorconfig-vim'

Plug 'ntpeters/vim-better-whitespace'
let g:current_line_whitespace_disabled_soft = 1
let g:better_whitespace_filetypes_blacklist = ["ctrlsf", "help", "diff"]
command! WhitespaceStrip StripWhitespace

Plug 'Chiel92/vim-autoformat', { 'do': 'npm install -g js-beautify' }
command! Format Autoformat

Plug 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutJump = ''
let g:AutoPairsMultilineClose = 0

Plug 'junegunn/vim-easy-align'
vmap <Tab> <Plug>(LiveEasyAlign)

Plug 'tomtom/tcomment_vim'
let g:tcomment_maps = 0
nnoremap <silent> \\ :TComment<CR>
vnoremap <silent> \\ :TCommentMaybeInline<CR>
nnoremap <silent> \** :TCommentBlock<CR>
vnoremap <silent> \* :TCommentBlock<CR>
nmap \ <Plug>TComment_gc
nmap \* <Plug>TComment_Commentb
nnoremap <silent> \p :exe "normal \<Plug>unimpairedPutAbove"<CR>=`]`[v`]:TCommentMaybeInline<CR>

"}}}

"" File Types {{{

Plug 'sheerun/vim-polyglot'
let g:jsx_ext_required = 1
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:javascript_plugin_jsdoc = 1

Plug 'gisphm/vim-gitignore'

Plug 'heavenshell/vim-jsdoc'
let g:jsdoc_enable_es6 = 1
let g:jsdoc_param_description_separator = '-'
command! JSDoc JsDoc

Plug 'alvan/vim-closetag'
let g:closetag_filetypes = 'html,xhtml,xml,javascript.jsx,typescript.tsx,typescriptreact'
let g:closetag_xhtml_filetypes = 'xhtml,xml,javascript.jsx,typescript.tsx,typescriptreact'
let g:closetag_regions =  {
      \ 'typescriptreact': 'jsxRegion,tsxRegion',
      \ 'javascriptreact': 'jsxRegion',
      \ }

Plug 'suan/vim-instant-markdown', { 'do': 'npm install -g instant-markdown-d' }
let g:instant_markdown_autostart = 0

"}}}

"" Debugging {{{

Plug 'neoclide/coc.nvim', {'branch': 'release'}

inoremap <silent><expr> <CR> (pumvisible() ? "\<C-y>" : "\<CR>\<Plug>DiscretionaryEnd")
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> <leader>yd <Plug>(coc-diagnostic-info)
nmap <silent> <leader>yy <Plug>(coc-type-definition)
nmap <silent> <leader>yi <Plug>(coc-implementation)
nmap <silent> <leader>yr <Plug>(coc-references)
noremap <silent> <leader>ya :CocAction<CR>
nnoremap <silent> K :call CocAction('doHover')<CR>

nnoremap <expr> <C-]> CocHasProvider('definition') ? ':call CocAction("jumpDefinition")<CR>' : '<C-]>'
nnoremap <expr> <C-W><C-]> CocHasProvider('definition') ? ':call CocAction("jumpDefinition", "split")<CR>' : '<C-]>'

" }}}

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

Plug 'sirver/ultisnips'
let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsExpandTrigger = '<C-y>'
let g:UltiSnipsJumpForwardTrigger = "<nop>"
let g:UltiSnipsJumpBackwardTrigger = "<nop>"

let g:snippet_prefs = {
      \ "quote": '"',
      \ "semicolon": ';',
      \ }

function! GetSnippetPref(name)
  let buffer_snippet_prefs = get(b:, 'snippet_prefs', {})

  if has_key(buffer_snippet_prefs, a:name)
    return buffer_snippet_prefs[a:name]
  endif

  return g:snippet_prefs[a:name]
endfunction

function! s:PumOrUltisnips(forward)
  if pumvisible() == 1
    return a:forward ? "\<C-n>" : "\<C-p>"
  elseif a:forward
    call UltiSnips#JumpForwards()
    if get(g:, 'ulti_jump_forwards_res', 0) == 0
      return "\<tab>"
    endif
  else
    call UltiSnips#JumpBackwards()
    if get(g:, 'ulti_jump_backwards_res', 0) == 0
      return "\<s-tab>"
    endif
  endif
  return ""
endfunction
function! s:IsFoldable()
  let curline = line('.')

  " wrong......
  return foldlevel(curline-1) < foldlevel(curline) || foldlevel(curline+1) < foldlevel(curline)
endfunction
inoremap <silent> <tab> <C-R>=<SID>PumOrUltisnips(1)<CR>
inoremap <silent> <s-tab> <C-R>=<SID>PumOrUltisnips(0)<CR>
snoremap <silent> <tab> <Esc>:call UltiSnips#JumpForwards()<CR>
snoremap <silent> <s-tab> <Esc>:call UltiSnips#JumpBackwards()<CR>
nnoremap <expr> <silent> <tab> <SID>PumOrUltisnips(1)
nnoremap <expr> <silent> <s-tab> <SID>PumOrUltisnips(0)


"}}}

"" Text Objects {{{

Plug 'wellle/targets.vim'
" Prefer multiline targets around cursor over distant targets within cursor line:
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA'

" quote handled by plugin/textobj-quote.vim
autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'b': {'pair': [{'o':'(', 'c':')'}]},
      \ 'q': {}
      \ })

Plug 'gorkunov/smartpairs.vim'

Plug 'michaeljsmith/vim-indent-object'

Plug 'glts/vim-textobj-comment'

Plug 'machakann/vim-textobj-delimited'

Plug 'shanesmith/vim-textobj-entire'

Plug 'kana/vim-textobj-user'

Plug 'inside/vim-textobj-jsxattr'

Plug 'kana/vim-textobj-function'

Plug 'thinca/vim-textobj-function-javascript'

Plug 'vimtaku/vim-textobj-keyvalue'

Plug 'nelstrom/vim-textobj-rubyblock'

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

Plug 'ericpruitt/tmux.vim'

Plug 'sjl/vitality.vim'

Plug 'edkolev/tmuxline.vim'

Plug 't9md/vim-choosewin'
let g:choosewin_overlay_enable = 1
let g:choosewin_overlay_shade = 1
map <c-w>- <Plug>(choosewin)

Plug 'AndrewRadev/undoquit.vim'

"}}}

"" Operations {{{

Plug 'tommcdo/vim-exchange'

Plug 'AndrewRadev/sideways.vim', { 'branch': 'main' }
nnoremap <leader><left> :SidewaysLeft<CR>
nnoremap <leader><right> :SidewaysRight<CR>

Plug 'AndrewRadev/splitjoin.vim', { 'branch': 'main' }
let g:splitjoin_trailing_comma = 1
let g:splitjoin_ruby_hanging_args = 0
let g:splitjoin_ruby_curly_braces = 0

"}}}

call plug#end()

" }}}

" Post plug-end ops {{{

"Markdown
let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json', 'ruby', 'sass', 'xml', 'html']

" Required to be after plug#end()

" Colorscheme
if has("nvim")
  set termguicolors
endif

if &t_Co == 256 || has("gui_running") || has("nvim")
  try
    colorscheme aldmeris
  catch
    colorscheme desert
  endtry
else
  colorscheme desert
endif

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes) + g:sandwich#recipes

"}}}

" Mappings {{{

"Resync syntax
nnoremap <F12> :syntax sync fromstart<CR>

"Write
nnoremap <Leader>w :w<CR>

"Close Tab
nnoremap <C-w>X :tabclose<CR>

""Consistent next/prev result
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

""Show count of matches
nnoremap <silent> <Leader>// :%s///rn<CR>

""Clear search (and Highlight)
nnoremap <silent> <Leader>\ :call <SID>clear_search()<CR>

"Search history navigation
" TODO add vmap *
nnoremap <silent> [/ :call <SID>search_hist('back')<CR>
nnoremap <silent> ]/ :call <SID>search_hist('forward')<CR>
nnoremap <silent> *  :call <SID>search_cword(1, 1)<CR>
" TODO repurpose #
nnoremap <silent> #  :call <SID>search_cword(1, 0)<CR>
nnoremap <silent> g* :call <SID>search_cword(0, 1)<CR>
nnoremap <silent> g# :call <SID>search_cword(0, 0)<CR>
nnoremap <silent> <2-LeftMouse> :call <SID>search_cword(1, 1)<CR>

function! s:search_cword(word_bound, forwards)
  let pre = ""
  let post = ""

  if a:word_bound
    let pre = '\<'
    let post = '\>'
  endif

  let search='\V' . pre . escape(expand('<cword>'), '\') . post

  if search ==# @/
    if a:forwards
      normal! n
    else
      normal! N
    endif
    return
  endif

  let @/=search

  call histadd('search', @/)
endfunction

function! s:clear_search()
  let @/=""
  let s:search_hist_index = 0
endfunction

let s:search_hist_index = 0
let s:search_last_nr = 0
function! s:search_hist(direction)
  if s:search_last_nr != histnr('search')
    let s:search_hist_index = -1
    let s:search_last_nr = histnr('search')
  endif
  if a:direction == 'back'
    if s:search_hist_index > histnr('search') * -1
      let s:search_hist_index = s:search_hist_index - 1
    endif
  else
    if s:search_hist_index < -1
      let s:search_hist_index = s:search_hist_index + 1
    endif
  endif
  let @/ = histget('search', s:search_hist_index)
  echo s:search_hist_index @/
endfunction

"Tab switching
nnoremap <expr> gr ':<C-U>' . (v:count ? v:count . 'tabnext' : 'tabprev') . '<CR>'
nnoremap <expr> gt ':<C-U>' . (v:count ? v:count : '') . 'tabnext<CR>'
nnoremap gR :tabfirst<CR>
nnoremap gT :tablast<CR>
nmap <C-q> gr
nmap <S-C-q> gR
nmap <S-C-e> gT
nmap <C-e> gt
nmap <C-Tab> gt
nmap <S-C-Tab> gr

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
nnoremap q; q:
nnoremap q/ q/
nnoremap q? q?
call <SID>MacroMap()

nnoremap @@ @q
vnoremap @@ :normal! @@<CR>
" TODO complete this...
" vnoremap @x

"Visual select last pasted
"http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap gp `[v`]

vnoremap gy ygv<ESC>

"Like it should be
nmap Y y$

"Save 30% keystrokes
vnoremap w iw
vnoremap gw w
onoremap gw w
onoremap <silent> <expr> w ':<C-U>normal! v' . v:count1 . 'iw<CR>'

vnoremap <silent> W aW
vnoremap gW W
onoremap gW W
onoremap <silent> <expr> W ':<C-U>normal! v' . v:count1 . 'aW<CR>'

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
nnoremap <silent> <C-Up>    :<C-u>call <SID>moveit('up',    v:count1, 'n')<CR>
nnoremap <silent> <C-Down>  :<C-u>call <SID>moveit('down',  v:count1, 'n')<CR>
nnoremap <silent> <C-Left>  :<C-u>call <SID>moveit('left',  v:count1, 'n')<CR>
nnoremap <silent> <C-Right> :<C-u>call <SID>moveit('right', v:count1, 'n')<CR>
vnoremap <silent> <C-Up>    :call      <SID>moveit('up',    v:count1, visualmode())<CR>
vnoremap <silent> <C-Down>  :call      <SID>moveit('down',  v:count1, visualmode())<CR>
vnoremap <silent> <C-Left>  :call      <SID>moveit('left',  v:count1, visualmode())<CR>
vnoremap <silent> <C-Right> :call      <SID>moveit('right', v:count1, visualmode())<CR>
inoremap <silent> <C-Up>    <C-o>:call <SID>moveit('up',    1,        'i')<cr>
inoremap <silent> <C-Down>  <C-o>:call <SID>moveit('down',  1,        'i')<cr>
inoremap <silent> <C-Left>  <C-o>:call <SID>moveit('left',  1,        'i')<CR>
inoremap <silent> <C-Right> <C-o>:call <SID>moveit('right', 1,        'i')<CR>

nnoremap <silent> <S-Up>    :<C-u>call <SID>moveit('up',    v:count1, 'n')<CR>
nnoremap <silent> <S-Down>  :<C-u>call <SID>moveit('down',  v:count1, 'n')<CR>
nnoremap <silent> <S-Left>  :<C-u>call <SID>moveit('left',  v:count1, 'n')<CR>
nnoremap <silent> <S-Right> :<C-u>call <SID>moveit('right', v:count1, 'n')<CR>
vnoremap <silent> <S-Up>    :call      <SID>moveit('up',    v:count1, visualmode())<CR>
vnoremap <silent> <S-Down>  :call      <SID>moveit('down',  v:count1, visualmode())<CR>
vnoremap <silent> <S-Left>  :call      <SID>moveit('left',  v:count1, visualmode())<CR>
vnoremap <silent> <S-Right> :call      <SID>moveit('right', v:count1, visualmode())<CR>
inoremap <silent> <S-Up>    <C-o>:call <SID>moveit('up',    1,        'i')<cr>
inoremap <silent> <S-Down>  <C-o>:call <SID>moveit('down',  1,        'i')<cr>
inoremap <silent> <S-Left>  <C-o>:call <SID>moveit('left',  1,        'i')<CR>
inoremap <silent> <S-Right> <C-o>:call <SID>moveit('right', 1,        'i')<CR>

function! s:moveit(where, count, mode) range

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

  if is_prev_line_blank && is_next_line_blank && a:count != 1 && a:where !=? "left" && a:where !=? "right"

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
      let targetline = firstline - a:count - 1
      call s:do_moveit(firstline, lastline, targetline)
      call s:reindent_inner()
      if a:mode ==? 'v'
        normal! gv=j==k^
      else
        normal! ==j==k^
      endif

    elseif a:where ==? "down"
      let targetline = lastline + a:count
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
" TODO delete only up until a closing bracket on top line or opening bracket
" on last line in order to handle `} else {`
vnoremap <silent> A{ :normal! [{V%<CR>
vnoremap <silent> A} :normal! [{V%<CR>
vnoremap <silent> AB :normal! [{V%<CR>
vnoremap <silent> A( :normal! [(V%<CR>
vnoremap <silent> A) :normal! [(V%<CR>
vnoremap <silent> Ab :normal! [(V%<CR>
vnoremap <silent> A[ :call searchpair('\[', '', '\]', 'bW') \| normal! V%<CR>
vnoremap <silent> A] :call searchpair('\[', '', '\]', 'bW') \| normal! V%<CR>
onoremap <silent> A{ :normal! [{V%<CR>
onoremap <silent> A} :normal! [{V%<CR>
onoremap <silent> AB :normal! [{V%<CR>
onoremap <silent> A( :normal! [(V%<CR>
onoremap <silent> A) :normal! [(V%<CR>
onoremap <silent> Ab :normal! [(V%<CR>
onoremap <silent> A[ :call searchpair('\[', '', '\]', 'bW') \| normal! V%<CR>
onoremap <silent> A] :call searchpair('\[', '', '\]', 'bW') \| normal! V%<CR>

"TODO sandwich recipes?
nnoremap <silent> sD{ :call <SID>delete_surrounding_lines("{}")<CR>
nnoremap <silent> sD} :call <SID>delete_surrounding_lines("{}")<CR>
nnoremap <silent> sD[ :call <SID>delete_surrounding_lines("[]")<CR>
nnoremap <silent> sD] :call <SID>delete_surrounding_lines("[]")<CR>
nnoremap <silent> sD( :call <SID>delete_surrounding_lines("()")<CR>
nnoremap <silent> sD) :call <SID>delete_surrounding_lines("()")<CR>

nnoremap <silent> sDr :call <SID>delete_surrounding_object("ar")<CR>

function! s:delete_surrounding_lines(pair)
  let syng_strcom = 'string\|regex\|comment\c'
  let skip_expr = "synIDattr(synID(line('.'),col('.'),1),'name') =~ '".syng_strcom."'"

  let char = map(split(a:pair, '\zs'), '"\\V" . v:val')

  let win = winsaveview()
  let ind = indent('.')

  let startline = searchpair(char[0], '', char[1], 'bW', skip_expr)

  delete _

  let endline = searchpair(char[0], '', char[1], '', skip_expr)

  delete _

  exec startline . "," . (endline-1) . "normal! =="

  let win.lnum -= 1
  let win.col -= ind - indent(win.lnum)

  call winrestview(win)
endfunction

function! s:delete_surrounding_object(object)
  let win = winsaveview()
  let ind = indent('.')

  exe "normal v" . a:object . "\<ESC>"

  " mark '> could have invalid line number if at end of buffer
  let lastline = getpos("'>")[1]

  '>delete _
  '<delete _

  exe "'<," . (lastline-2) . "normal! =="

  let win.lnum -= 1
  let win.col -= ind - indent(win.lnum)

  call winrestview(win)
endfunction

" nnoremap <silent> sDr :call <SID>delete_surrounding_object("ar")<CR>
" function! s:delete_surrounding_object(object)
"   let win = winsaveview()
"   let ind = indent('.')
"
"   exe "normal v" . a:object . "\<ESC>"
"
"   let startline = line("'<")
"   let endline = line("'>")
"
"   '>delete _
"   '<delete _
"
"   exec startline . "," . (endline-2) . "normal! =="
"
"   let win.lnum -= 1
"   let win.col -= ind - indent(win.lnum)
"
"   call winrestview(win)
" endfunction

"Easier line start/end movement
nnoremap H ^
vnoremap H ^
onoremap H ^
nnoremap L g_
vnoremap L g_
onoremap L g_
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

nnoremap <silent> j :<C-u>call <SID>tiptap('j')<CR>
nnoremap <silent> k :<C-u>call <SID>tiptap('k')<CR>

let s:tiptap_count = 0
let s:tiptap_reltime = reltime()
let s:tiptap_last_key = ''
function! s:tiptap(key)
  let diff = str2float(split(reltimestr(reltime(s:tiptap_reltime)))[0])

  let s:tiptap_reltime = reltime()
  let s:tiptap_count += 1

  if diff > 1 || a:key == s:tiptap_last_key
    let s:tiptap_count = 0
    let s:tiptap_last_key = ''
  elseif s:tiptap_count == 10
    split +Nyancat2
    let s:tiptap_count = 0
    return
  endif

  let s:tiptap_last_key = a:key

  " Better wrap navigation
  let exe_key = v:count == 0 ? 'g'.a:key : v:count.a:key

  exe 'normal!' exe_key
endfunction

"Insert mode hjkl
inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

"Easier substitute
"TODO use https://stackoverflow.com/a/6271254/1333402
nnoremap <leader>r :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <leader>r "hy:<C-\>e<SID>subsub()<CR>
function! s:subsub()
  let delimiters = "/#@+,"
  let numlines = strlen(substitute(@h, "[^\\n]", "", "g"))
  if numlines == 0
    let delim = ""

    for c in split(delimiters, '\zs')
      if match(@h, c) == -1
        let delim = c
        break
      endif
    endfor

    if delim == ""
      echo "Could not find a valid delimiter!"
      return
    endif

    let cmd = "%s" . delim . @h . delim . @h
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
nnoremap <silent> _ :let b:silly=v:register<CR>:set opfunc=<SID>PasteOver<CR>g@
vnoremap <silent> _ :<C-U>let b:silly=v:register<CR>:<C-U>call <SID>PasteOver(visualmode(), 1)<CR>
nnoremap <silent> __ :<C-U>let b:silly=v:register<CR>V:<C-U>call <SID>PasteOver(visualmode(), 1)<CR>
function! s:PasteOver(type, ...)
  if a:0
    let [mark1, mark2] = ['`<', '`>']
  else
    let [mark1, mark2] = ['`[', '`]']
  endif

  let pastecmd = (col("']") == col("$")-1) ? "p" : "P"

  exec 'normal! ' . mark1 . 'v' . mark2 . '"_d'

  if a:type == 'char' || a:type ==# 'v'
    call <SID>CharPaste(pastecmd, b:silly)
  else
    call <SID>LinePaste(pastecmd, b:silly)
  endif

  normal! =']
endfunction

" This supports "rp that permits to replace the visual selection with the contents of @r
" https://github.com/LucHermitte/lh-misc/blob/master/plugin/repl-visual-no-reg-overwrite.vim
" xnoremap <silent> <expr> _ <sid>Replace()
"
" function! s:Replace()
"   let s:restore_reg = @"
"   return "p@=RestoreRegister()\<cr>"
" endfunction
"
" function! RestoreRegister()
"   if &clipboard =~ 'unnamed'
"     let @* = s:restore_reg
"   elseif &clipboard == 'unnamedplus'
"     let @+ = s:restore_reg
"   elseif &clipboard == 'unnamed,unnamedplus' || &clipboard == 'unnamedplus,unnamed'
"     let @* = s:restore_reg
"     let @+ = s:restore_reg
"   endif
"   let @" = s:restore_reg
"   return ''
" endfunction

"Duplicate
" :copy only does lines, this is arbitrary selection
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

nnoremap <silent> \Q :<C-U>call <SID>QuickWrap(v:count)<CR>
function! s:QuickWrap(count)
  " if a:type ==? 'v'
  "   let [mark1, mark2] = ['`<', '`>']
  " else
  "   let [mark1, mark2] = ['`[', '`]']
  " endif

  let save_textwidth = &textwidth

  if v:count != 0
    let &textwidth = a:count
  endif

  " let vselect = a:type
  " if vselect == 'char'
  "   let vselect = 'v'
  " elseif vselect == 'line' || vselect == 'block'
  "   let vselect = 'V'
  " endif
  " let vselect = mark1 . vselect . mark2

  normal! gwip

  let &textwidth = save_textwidth
endfunction

vnoremap <silent> \Q :<C-U>echo "v:count " . v:count<CR>

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
    norm sr'"
  else
    norm sr"'
  endif
endfunction

"Factor out
" vnoremap <silent> <leader>f :call inputsave()<CR>gvc<C-R>=input("variable name: ")<CR><ESC>:call inputrestore()<CR>Ovar <C-R>. = ;<ESC>PA<CR><ESC>kWVjj:MultipleCursorFind __factored__<CR>c
vnoremap <silent> <C-X>vv :call <SID>ExtractVariable(visualmode(), "var")<CR>
vnoremap <silent> <C-X>vl :call <SID>ExtractVariable(visualmode(), "let")<CR>
vnoremap <silent> <C-X>vc :call <SID>ExtractVariable(visualmode(), "const")<CR>
function! s:ExtractVariable(mode, decl) range

  call inputsave()
  let name = input("Name: ")
  call inputrestore()

  if name == ""
    return
  endif

  exec "normal! `<v`>".(a:mode ==# 'V' ? "h" : "")."\"hd"

  let @h = matchstr(@h, '^\v\_s*\zs.{-}\ze\_s*$')

  exec "normal! i".name."\<ESC>O".a:decl." ".name." = \<C-R>h;\<CR>\<ESC>k^W"

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

"Switch case of first letter and insert
nnoremap gi g~li

nnoremap <silent> [[ :call searchpair('\[', '', '\]', 'bW')<CR>
nnoremap <silent> ]] :call searchpair('\[', '', '\]', 'W')<CR>

"Quick jump to window
for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
  exec 'nnoremap <silent> <C-w>' . i . ' :' . i . 'wincmd w<CR>'
endfor

"Open file under cusror in split window
nnoremap gF :vertical wincmd f<CR>

"Previous command line but with prefix matching
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

nnoremap <silent> <C-W>z :call <SID>GoToThing()<ESC>
nnoremap <silent> <C-W>Z :call <SID>CloseThing()<ESC>

function! s:CloseThing()
  let thing = <SID>FindThing()

  if thing != 0
    exec thing . "close"
  endif
endfunction

function! s:GoToThing()
  let thing = <SID>FindThing()

  if thing != 0
    exec thing . 'wincmd w'
  endif
endfunction

" TODO include floating windows
" fun! s:close_floats() abort
"   for win in nvim_tabpage_list_wins(tabpagenr())
"     if !empty(get(nvim_win_get_config(win), 'relative', ''))
"       call nvim_win_close(win, v:true)
"     endif
"   endfor
" endf
function! s:FindThing()
  let qfnum = 0
  let helpnum = 0
  let ctrlsfnum = 0
  let previewnum = 0
  let fugitive = 0

  for winnum in range(1, winnr('$'))
    let ft = getwinvar(winnum, "&filetype")
    if ft == "qf"
      let qfnum = winnum
    elseif ft == "ctrlsf"
      let ctrlsfnum = winnum
    elseif ft == "help"
      let helpnum = winnum
    elseif ft == "fugitive"
      let fugitive = winnum
    elseif getwinvar(winnum, "&previewwindow")
      let previewnum = winnum
    endif
  endfor

  let thing = 0

  if previewnum != 0
    let thing = previewnum
  elseif helpnum != 0
    let thing = helpnum
  elseif fugitive != 0
    let thing = fugitive
  elseif qfnum != 0
    let thing = qfnum
  elseif ctrlsfnum != 0
    let thing = ctrlsfnum
  endif

  return thing
endfunction

noremap! <C-R><C-R>% <C-R>=expand('%:t')<CR>

"}}}

" Commands {{{

"Super ReTab
command! -range=% -nargs=0 Tab2Space execute '<line1>,<line2>s#^\t\+#\=repeat(" ", len(submatch(0))*' . &ts . ')'
command! -range=% -nargs=0 Space2Tab execute '<line1>,<line2>s#^\( \{'.&ts.'\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')'

"Source vimrc
command! ReloadVimrc source $MYVIMRC

"ONLY
command! ONLY silent only | silent tabonly
nnoremap <C-w>O :ONLY<CR>

command! SyntaxGroup call <SID>SyntaxGroup()
function! s:SyntaxGroup()
  let id = synID(line('.'), col('.'), 1)
  let name = synIDattr(id, 'name')
  let transName = synIDattr(synIDtrans(id), 'name')
  echo  name . ' -> ' . transName
  exec "verb hi" transName
endfunction

nnoremap <leader>s :Scratch<CR>
command! -nargs=? -complete=syntax Scratch call <SID>NewScratch(<f-args>)
function! s:NewScratch(...)
  let type = a:0 ? a:1 : 'markdown'

  if &ft == 'fern'
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

command! TigBlame split +terminal\ tig\ blame\ %

command! NewBash call <SID>NewBash()
function! s:NewBash()
  call setline(1, "#!/bin/bash")
  Chmod +x
endfunction

command! DealWithIt args `git status --porcelain=v2 \| awk '/^(UU\|AA)/ { print $2 }'`

command! VimrcEdit tabe ~/.vimrc

command! FixClipboard set clipboard=unnamed,unnamedplus

command! -nargs=1 NewPlug call append(line('.'), "Plug '" . <args> . "'") | exe "Plug '" . <args> . "'" | PlugInstall

command! CopyFilePathToClipboard let @+ = expand("%")
command! CopyFileAbsoluePathToClipboard let @+ = expand("%:p")
command! CopyFileNameToClipboard let @+ = expand("%:t")

" TODO steal completion from https://github.com/Shopify/vim-devilish/blob/master/plugin/devilish.vim#L57
command! -nargs=1 -complete=custom,<SID>ProjComp P call <SID>Proj(<f-args>)
command! -nargs=1 -complete=custom,<SID>ProjComp TP tabnew | call <SID>Proj(<f-args>)

let g:proj_dirs="~/Code/,~/src/github.com/Shopify/"

function! s:Proj(dir)
  let save_cdpath = &cdpath

  let &cdpath = join(map(split(g:proj_dirs, ","), "expand(v:val)"), ",")

  exe 'cd' a:dir

  Fern .

  let &cdpath = save_cdpath
endfunction

function! s:ProjComp(ArgLead, CmdLine, CursorPos)
  let dirs = split(globpath(g:proj_dirs, '*'), '\n') 

  let dirs = filter(dirs, {_, val -> isdirectory(val) })

  let dirs = map(dirs, {_, val -> fnamemodify(val, ':t') })
  
  return join(dirs, "\n")
endfunction

"}}}

" AutoCommands {{{

" " http://www.bestofvim.com/tip/auto-reload-your-vimrc/
" augroup reload_vimrc
"   autocmd!
"   autocmd BufWritePost $MYVIMRC,~/Code/rc/vimrc,~/Code/rc/vim/* nested source $MYVIMRC
" augroup END

" Settings for currently focused window
augroup FocusedWindow
  au!
  au VimEnter,WinEnter,BufWinEnter * call FocusedWindow()
  au WinLeave * call UnFocusedWindow() 
augroup END

function! FocusedWindow()
  setlocal cursorline

  if &number
    setlocal relativenumber
  endif
endfunction

function! UnFocusedWindow()
  setlocal nocursorline
  setlocal norelativenumber
endfunction

"Load opend file on last known position
augroup LoadLastKnownPosition
  au!
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

tnoremap <C-\><C-\> <C-\><C-N>
augroup term
  autocmd!
  if exists("##TermOpen")
    autocmd TermOpen * startinsert
  endif
augroup END

augroup checktime
  autocmd!
  " https://stackoverflow.com/a/26035664/1333402
  autocmd FocusGained,CursorHold * if getcmdwintype() == '' | checktime | endif
augroup END

augroup syntax_sync
  autocmd!
  " large files sometimes loose syntax colouring
  autocmd WinEnter * syntax sync fromstart
augroup END

"}}}

" vim: set fdm=marker fdl=999:
