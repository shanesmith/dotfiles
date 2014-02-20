setlocal colorcolumn=80

nnoremap <buffer> \= :call <SID>Underline("=")<CR>
nnoremap <buffer> \- :call <SID>Underline("-")<CR>

function! s:Underline(char)

  let posline = line(".")
  let poscol = col(".")

  execute "normal yypVr".a:char

  let nextline = getline(line(".") + 1)

  if match(nextline, "^[-=]\\+$") != -1
    normal jdd
  endif

  call cursor(posline, poscol)

endfunction

function! s:UpdateUnderline()

  let nextline = getline(line(".") + 1)

  let match = matchstr(nextline, '^\([-=]\)\ze\1\+\s*$')

  if !empty(match)
    call <SID>Underline(match)
  endif

endfunction

augroup markdown
  au!
  au CursorMovedI <buffer> call <SID>UpdateUnderline()
augroup END
