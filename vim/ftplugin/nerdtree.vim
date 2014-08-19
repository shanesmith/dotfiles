"https://github.com/scrooloose/nerdtree/issues/49

vnoremap <buffer> <CR> :call <SID>OpenMultiple()<cr>

function! s:OpenMultiple() range
  let curLine = a:firstline
  while curLine <= a:lastline

    call cursor(curLine, 1)

    let node = g:NERDTreeFileNode.GetSelected()

    if !empty(node) && !node.path.isDirectory
      call node.open({'where': 'v', 'stay': 1})
    endif

    let curLine += 1

  endwhile
endfunction
