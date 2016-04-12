call plug#begin('~/.vim/bundle')

"""
""" File Navigation and Search
"""

Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'thinca/vim-visualstar'

Plug 'shanesmith/ack.vim'
command! -nargs=* MyAck call <SID>MyAck(0, <f-args>)
command! -nargs=* MyAckRegEx call <SID>MyAck(1, <f-args>)
function! s:MyAck(regex, ...)
  let args = ""
  if !a:regex
    let args .= " -Q"
  endif
  if a:0 == 0
    let what = expand("<cword>")
  else
    let what = join(a:000, ' ')
  endif
  let args .= " \"" . what . "\""
  call ack#Ack('grep!', args)
endfunction
nnoremap <leader>aa :MyAck<space>
nnoremap <leader>aq :MyAckRegEx<space>
vnoremap <leader>aa "hy:<C-U>MyAck <C-R>h
vnoremap <leader>aq "hy:<C-U>MyAckRegEx <C-R>h
if executable('ag')
  let g:ackprg = 'ag --nogroup --column -S $* \| grep -v -e "^.*\.min\.js:" -e "^.*\.min\.css:"'
endif
let g:ackhighlight = 1
let g:ack_mappings = {
      \ "<C-t>": "<C-W><CR><C-W>T",
      \ "<C-s>": "<C-W><CR>:exe 'wincmd ' (&splitbelow ? 'J' : 'K')<CR><C-W>p<C-W>J<C-W>p",
      \ "<C-v>": "<C-W><CR>:exe 'wincmd ' (&splitright ? 'L' : 'H')<CR><C-W>p<C-W>J<C-W>p",
      \ "v":     "<C-W><CR>:exe 'wincmd ' (&splitright ? 'L' : 'H')<CR><C-W>p<C-W>J<C-W>p",
      \ "<CR>":  ":let ack_qf_line=line('.')<CR><C-w>p:exec ack_qf_line . 'cc'<CR>"
      \ }

Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = "<leader>pp"
nnoremap <leader>p  :CtrlP<cr>
vnoremap <leader>p  "hy:call <SID>CtrlPWithInput(@h)<CR>
vnoremap <leader>pp "hy:call <SID>CtrlPWithInput(@h)<CR>
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
    \ 'ToggleType(1)':        ['<c-right>'],
    \ 'ToggleType(-1)':       ['<c-left>']
    \ }
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\vtags|\.(exe|so|dll|DS_Store)$'
      \ }
function! s:CtrlPWithInput(input)
  let g:ctrlp_default_input = a:input
  CtrlP
  let g:ctrlp_default_input = ""
endfunction
if executable('ag')
  let g:ctrlp_user_command = 'ag $(python -c "import os.path; print os.path.relpath(%s,''${PWD}'')") -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

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
let NERDTreeIgnore = [ '\.pyc$' ]

Plug 'henrik/vim-qargs'

Plug 'chrisbra/Recover.vim'


"""
""" Utilities
"""

Plug 'diepm/vim-rest-console'
let g:vrc_trigger = '<F5>'
command! RestTab tabnew | setf rest


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

Plug 'fisadev/vim-ctrlp-cmdpalette'

Plug 'lfilho/cosco.vim'
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

Plug 'tpope/vim-unimpaired'

Plug 'KabbAmine/lazyList.vim'

" Plug 'majutsushi/tagbar'
" nnoremap <Leader>c :TagbarToggle<CR>

Plug 'tpope/vim-surround'
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

Plug 'vim-scripts/localvimrc'
let g:localvimrc_sandbox=0
let g:localvimrc_persistent=1

Plug 'szw/vim-maximizer'
let g:maximizer_default_mapping_key = '<F4>'

Plug 'koron/nyancat-vim'

" Plug 'tpope/vim-fugitive'

" Plug 'sjl/gundo.vim'
" nnoremap <leader>u :GundoToggle<CR>

Plug 'dohsimpson/vim-macroeditor'


"""
""" Display
"""

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

Plug 'veloce/vim-aldmeris'
let g:aldmeris_transparent = 1
let g:aldmeris_css = 0

Plug 'chrisbra/Colorizer'
let g:colorizer_auto_filetype='css,scss,sass'
let g:colorizer_auto_color = 0
let g:colorizer_colornames = 0

Plug 'vim-scripts/ConflictDetection'
let g:ConflictDetection_WarnEvents = ''
highlight conflictOursMarker term=bold ctermfg=16 gui=bold guifg=#000 cterm=bold ctermbg=102
highlight conflictBaseMarker term=bold ctermfg=16 gui=bold guifg=#000 cterm=bold ctermbg=102
highlight conflictTheirsMarker term=bold ctermfg=16 gui=bold guifg=#000 cterm=bold ctermbg=102
highlight conflictSeparatorMarkerSymbol term=bold ctermfg=16 gui=bold guifg=#000 cterm=bold ctermbg=102

Plug 'kshenoy/vim-signature'
" GotoNext/PrevMarkerAny unmap due to conflict with conflictmotions
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


Plug 'airblade/vim-gitgutter'
highlight GitGutterAdd    cterm=bold ctermbg=237  ctermfg=119
highlight GitGutterDelete cterm=bold ctermbg=237  ctermfg=167
highlight GitGutterChange cterm=bold ctermbg=237  ctermfg=227
nmap ]- <plug>GitGutterNextHunk
nmap [- <plug>GitGutterPrevHunk
nmap <leader>-s <plug>GitGutterStageHunk
nmap <leader>-r <plug>GitGutterRevertHunk
nmap <leader>-p <plug>GitGutterPreviewHunk

Plug 'vim-scripts/SyntaxRange'


"""
""" Motions
"""

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


"""
""" Formatting
"""

Plug 'ntpeters/vim-better-whitespace'
let g:current_line_whitespace_disabled_soft = 1
command! WhitespaceStrip StripWhitespace

Plug 'Chiel92/vim-autoformat'

Plug 'jiangmiao/auto-pairs'

Plug 'junegunn/vim-easy-align'
vmap <Tab> <Plug>(LiveEasyAlign)

Plug 'tomtom/tcomment_vim'
nnoremap \\ :TComment<CR>
vnoremap \\ :TComment<CR>
nnoremap \* :TCommentBlock<CR>
vnoremap \* :TCommentBlock<CR>
nmap \  <Plug>TComment_gc


"""
""" File Types
"""

Plug 'mustache/vim-mustache-handlebars'

Plug 'marijnh/tern_for_vim', { 'do': 'npm install' }
nnoremap <leader>jf :TernDef<CR>
nnoremap <leader>jd :TernDoc<CR>
nnoremap <leader>jr :TernRefs<CR>

Plug 'shanesmith/xmledit'
let g:xmledit_enable_html = 1
let g:xml_use_xhtml = 1
function! HtmlAttribCallback(xml_tag)
  "disable this sort of thing
  return 0
endfunction

Plug 'StanAngeloff/php.vim'

Plug 'elubow/cql-vim'

Plug 'hail2u/vim-css3-syntax'

Plug 'othree/html5.vim'

Plug 'shanesmith/vim-javascript', {'branch': 'develop'}
hi link jsParens Operator
hi link jsObjectBraces Special

Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

Plug 'groenewege/vim-less'

Plug 'suan/vim-instant-markdown'
let g:instant_markdown_autostart = 0

Plug 'kchmck/vim-coffee-script'


"""
""" Debugging
"""

" Plug 'joonty/vdebug'

Plug 'scrooloose/syntastic'
let g:syntastic_check_on_open = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_objc_compiler = 'clang'
let g:syntastic_php_checkers = ['php']
let g:syntastic_javascript_checkers = ['jshint', 'jscs']
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_html_tidy_quiet_messages = {
      \   'regex': [
      \     '"tabindex" has invalid value "-1"',
      \     '<div> proprietary attribute "tabindex"',
      \     '<img> lacks "alt" attribute',
      \     'trimming empty <span>',
      \   ],
      \ }
let g:syntastic_html_tidy_ignore_errors = [
      \   " proprietary attribute \"ng-",
      \   " proprietary attribute \"translate",
      \   " proprietary attribute \"ui-"
      \ ]

Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --tern-completer' }
let g:ycm_autoclose_preview_window_after_insertion = 1

" Plug 'brookhong/DBGPavim'
" let g:dbgPavimPort = 9009
" let g:dbgPavimBreakAtEntry = 0
" let g:dbgPavimKeyRun = "<leader>dr"
" let g:dbgPavimKeyQuit = "<leader>dq"
" let g:dbgPavimKeyToggleBp = "<leader>db"
" let g:dbgPavimKeyHelp = "<leader>dh"
" let g:dbgPavimKeyToggleBae = "<leader>de"


"""
""" Snippets
"""

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
let g:UltiSnipsExpandTrigger = '<C-y>'
let g:UltiSnipsJumpForwardTrigger = "<nop>"
let g:UltiSnipsJumpBackwardTrigger = "<nop>"

function! s:PumOrUltisnips(forward)
    if pumvisible() == 1
        return a:forward ? "\<C-n>" : "\<C-p>"
    else if a:forward
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
inoremap <silent> <tab> <C-R>=PumOrUltisnips(1)<CR>
inoremap <silent> <s-tab> <C-R>=PumOrUltisnips(0)<CR>
snoremap <silent> <tab> <Esc>:call UltiSnips#JumpForwards()<CR>
snoremap <silent> <s-tab> <Esc>:call UltiSnips#JumpBackwards()<CR>

" Plug 'honza/vim-snippets'


"""
""" Text Objects
"""

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

Plug 'coderifous/textobj-word-column.vim'


"""
""" Windows
"""

Plug 'wesQ3/vim-windowswap'
let g:windowswap_map_keys = 0
nnoremap <silent> <C-w>w :call WindowSwap#EasyWindowSwap()<CR>
nnoremap <silent> <C-w><C-w> :call WindowSwap#EasyWindowSwap()<CR>

Plug 'christoomey/vim-tmux-navigator'
inoremap <silent> <c-h> <ESC>:TmuxNavigateLeft<cr>
inoremap <silent> <c-j> <ESC>:TmuxNavigateDown<cr>
inoremap <silent> <c-k> <ESC>:TmuxNavigateUp<cr>
inoremap <silent> <c-l> <ESC>:TmuxNavigateRight<cr>

Plug 'Keithbsmiley/tmux.vim'

Plug 'sjl/vitality.vim'

Plug 'edkolev/tmuxline.vim'


"""
""" Operations
"""

Plug 'tommcdo/vim-exchange'

Plug 'AndrewRadev/splitjoin.vim'

call plug#end()

"Markdown
let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json', 'ruby', 'sass', 'xml', 'html']

" Required to be after plug#end()
function! airline#extensions#tabline#title(n)
  let title = g:TabDirs[a:n]
  if empty(title)
    let title = getcwd()
  endif
  return substitute(fnamemodify(title, ':~'), '\v\w\zs.{-}\ze(\\|/)', '', 'g')
endfunction
