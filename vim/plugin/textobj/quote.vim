if exists('g:loaded_textobj_quote')
  finish
endif

call textobj#user#plugin('quotes', {
\   '-': {
\     'sfile': expand('<sfile>'),
\     'select-a': 'aq',
\     'select-i': 'iq',
\     'select-a-function': 's:CurrentQuoteA',
\     'select-i-function': 's:CurrentQuoteI',
\   },
\ })

xmap q iq
omap q iq

function! s:CurrentQuoteA()
  return <SID>CurrentQuote()
endfunction

function! s:CurrentQuoteI()
  let pos = <SID>CurrentQuote()
  if pos isnot 0
    let pos[1][2] = pos[1][2] + 1
    let pos[2][2] = pos[2][2] - 1
  endif
  return pos
endfunction

function! s:CurrentQuote()
  let curcol = col(".")

  let doublepos = <SID>getQuotePos('"')
  let singlepos = <SID>getQuotePos("'")
  let backtickpos = <SID>getQuotePos("`")

  let poslist = [doublepos, singlepos, backtickpos]

  let maxpos = 0

  for pos in poslist
    if pos isnot 0 && pos[0][2] <= curcol && (maxpos is 0 || pos[0][2] > maxpos[0][2])
      let maxpos = pos
    endif
  endfor

  if maxpos isnot 0
    call insert(maxpos, 'v', 0)
  endif

  return maxpos

endfunction

function! s:getQuotePos(q)
  let save_cursor = getcurpos()
  let origcol = save_cursor[2]

  exec "norm! v2i" . a:q . "o"
  exec "norm! \<Esc>"
  let pos = [getpos("'<"), getpos("'>")]

  call setpos('.', save_cursor)

  if pos[0][1] == pos[1][1] && pos[0][2] == pos[1][2]
    let pos = 0
  endif

  return pos
endfunction

let g:loaded_textobj_entire = 1
