command! -range -buffer SourceLine <line1>,<line2>call <SID>SourceLine()

function! s:SourceLine() range
  let savereg = @h

  silent exec a:firstline . "," . a:lastline . "yank h"

  let @h = substitute(@h, "\n\\s*\\\\\\s*", " ", "g")

  @h

  let @h = l:savereg

  echo "Sourced!"
endfunction

