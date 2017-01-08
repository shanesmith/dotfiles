command! -range -buffer SourceLine <line1>,<line2>call <SID>SourceLine()

function! s:SourceLine() range
  let savereg = @h

  exec a:firstline . "," . a:lastline . "yank h"

  @h

  let @h = l:savereg
endfunction

