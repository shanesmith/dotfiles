function! MoveWindow(where)
  if !WindowSwap#HasMarkedWindow()
    echom "WindowSwap: No window marked to move! Mark a window first."
    return
  endif

  " cast to int
  let window = WindowSwap#GetMarkedWindowNum() + 0

  let buffer = winbufnr(window)

  let splitcmd = "split +buffer\\ " . buffer

  if a:where == "left" || a:where == "right"
    let splitcmd = "vertical " . splitcmd
  endif

  if a:where == "left" || a:where == "up"
    let splitcmd = "leftabove " . splitcmd
  else
    let splitcmd = "rightbelow " . splitcmd
  endif

  exe window . "hide"
  exe splitcmd

  call WindowSwap#ClearMarkedWindowNum()

endfunction

nnoremap <silent> <c-w><right>   :call MoveWindow("right")<CR>
nnoremap <silent> <c-w><left>    :call MoveWindow("left")<CR>
nnoremap <silent> <c-w><up>      :call MoveWindow("up")<CR>
nnoremap <silent> <c-w><down>    :call MoveWindow("down")<CR>
nnoremap <silent> <c-w><c-right> :call MoveWindow("right")<CR>
nnoremap <silent> <c-w><c-left>  :call MoveWindow("left")<CR>
nnoremap <silent> <c-w><c-up>    :call MoveWindow("up")<CR>
nnoremap <silent> <c-w><c-down>  :call MoveWindow("down")<CR>
