
"Toggle spellchecker
nnoremap <F11> :setlocal spell!<CR>

"Resync syntax
nnoremap <F12> :syntax sync fromstart<CR>

"Write
nnoremap <Leader>w :w<CR>

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
nnoremap [t :tabprev<CR>
nnoremap ]t :tabnext<CR>
nnoremap <C-t>n :tabnew<CR>
nnoremap <C-t>t :tabnew<CR>
nnoremap <C-t><C-t> :tabnew<CR>
nnoremap <C-t>o :tabonly<CR>
nnoremap <C-t>c :tabclose<CR>
nnoremap <C-t>q :tabclose<CR>
nnoremap <C-t>> :tabm +1<CR>
nnoremap <C-t>< :tabm -1<CR>

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
  if len(@q) > 0
    normal! @q
    undo
  endif
endfunction

nnoremap q <nop>
call <SID>MacroMap()


"Visual select last pasted
"http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap gp `[v`]

vnoremap gy ygv<ESC>

"Inline mode paste
inoremap <C-p> <C-\><C-o>:call <SID>InlinePaste()<cr>
function! s:InlinePaste()
  let pasteop = 'P'
  let linelength = strlen(getline('.'))
  let colpos = col('.')
  if colpos == linelength + 1
    let pasteop = 'p'
  endif
  exec 'normal! ' . pasteop
endfunction

"Smart indent pasting
nnoremap <silent> p :call <SID>smart_paste('p')<CR>
nnoremap <silent> P :call <SID>smart_paste('P')<CR>

function! s:smart_paste(cmd)
  exec 'normal! "' . v:register . a:cmd
  if getregtype(v:register) ==# 'V'
    normal! =']
  endif
endfunction

"Like it should be
nnoremap Y y$

"Save 30% keystrokes
nnoremap dw daw
nnoremap cw ciw
nnoremap yw yiw
nnoremap vw viw
nnoremap dW daW
nnoremap cW ciW
nnoremap yW yiW
nnoremap vW viW

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

  if a:mode ==? 'n'

    let line1 = getline('.')
    if match(line1, '^\s*-\s') != -1

      let line2num = -1

      if a:where ==? "up"
        let line2num = line('.') - 2
      elseif a:where ==? "down"
        let line2num = line('.') + 2
      endif

      if line2num <= 1 || line2num >= line('$')
        return
      endif

      let line2 = getline(line2num)
      if match(line2, '^\s*-\s') != -1
        call setline('.', line2)
        call setline(line2num, line1)
        call cursor(line2num, 0)
        return
      endif

    endif

  endif

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
        let targetline = line("'{")
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
        call cursor(lastline, 1)
        let targetline = line("'}") - 1
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
      call s:do_moveit(firstline, lastline, targetline)
      if a:mode ==? 'v'
        normal! gv=k==j^
      else
        normal! ==k==j^
      endif
      call s:reindent_inner()

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
  exec a:first . "," . a:last . "move" a:target
endfunction


"New space
nnoremap <Leader><Space> i<Space><ESC>l

"New lines
nnoremap <Leader><CR> i<CR><ESC>

nnoremap <silent> <Leader>O :<C-U>call <SID>InsertBlankLine('n-up', v:count1)<CR>
nnoremap <silent> <Leader>o :<C-U>call <SID>InsertBlankLine('n-down', v:count1)<CR>
vnoremap <silent> <Leader>o :call <SID>InsertBlankLine(visualmode(), v:count1)<CR>

function! s:InsertBlankLine(type, count) range
  let what = repeat([''], a:count)

  if a:type ==? 'v'

    exec "normal! `>a\<CR>\<ESC>`<i\<CR>\<ESC>" . (a:firstline+1) . "GV" .  (a:lastline+1) . "G"

  elseif a:type ==# 'n-down'

    call append(a:lastline, what)

  elseif a:type ==# 'n-up'

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
nnoremap <silent><expr> yp ':let b:silly="' . v:register . '"<CR>:set opfunc=<SID>YouPaste<CR>g@'
nnoremap <silent><expr> ypp 'V:<C-U>let b:silly="' . v:register . '"<CR>:<C-U>call <SID>YouPaste(visualmode(), 1)<CR>'
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
nnoremap <silent> [d :set opfunc=<SID>DuplicateUp<CR>g@
nnoremap <silent> ]d :set opfunc=<SID>DuplicateDown<CR>g@
nnoremap <silent> [dd V:<C-U>call <SID>DuplicateUp(visualmode())<CR>
nnoremap <silent> ]dd V:<C-U>call <SID>DuplicateDown(visualmode())<CR>
vnoremap <silent> [d :<C-U>call <SID>DuplicateUp(visualmode())<CR>
vnoremap <silent> ]d :<C-U>call <SID>DuplicateDown(visualmode())<CR>
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
nnoremap <silent> \d :set opfunc=<SID>DuplicateAndComment<CR>g@
nnoremap <silent> \dd V:<C-U>call <SID>DuplicateAndComment(visualmode())<CR>
vnoremap <silent> \d :<C-U>call <SID>DuplicateAndComment(visualmode())<CR>
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
nnoremap \q gqip

"Clear a line
nnoremap dc cc<esc>

"Swap quotes
nnoremap <leader>' :call <SID>SwapQuotes()<CR>
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

