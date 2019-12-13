
call NERDTreeAddKeyMap({
  \ 'key': g:NERDTreeMapActivateNode,
  \ 'scope': "FileNode",
  \ 'callback': "SS_NERDTreeActivateWithoutReuse",
  \ 'override': 1
  \ })

call NERDTreeAddKeyMap({
  \ 'key': 'yy',
  \ 'scope': "Node",
  \ 'callback': "SS_NERDTreeCopyNodeName",
  \ 'quickhelpText': 'Copy name',
  \ 'override': 1
  \ })

call NERDTreeAddKeyMap({
  \ 'key': 'yY',
  \ 'scope': "Node",
  \ 'callback': "SS_NERDTreeCopyNodePath",
  \ 'quickhelpText': 'Copy path',
  \ 'override': 1
  \ })

function! SS_NERDTreeActivateWithoutReuse(node)
  call a:node.open({ 'reuse': 0, 'where': "p" })
endfunction

function! SS_NERDTreeCopyNodeName(node)
  let @* = a:node.path.getLastPathComponent(0)
endfunction

function! SS_NERDTreeCopyNodePath(node)
  let @* = a:node.path.str()
endfunction

