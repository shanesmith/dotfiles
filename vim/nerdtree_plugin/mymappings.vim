
call NERDTreeAddKeyMap({
  \ 'key': g:NERDTreeMapActivateNode,
  \ 'scope': "FileNode",
  \ 'callback': "NERDTreeActivateWithoutReuse",
  \ 'override': 1
  \ })

function! NERDTreeActivateWithoutReuse(node)
  call a:node.open({ 'reuse': 0, 'where': "p" })
endfunction

