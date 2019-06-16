" don't load multiple times
if exists("g:loaded_nerdtree_ranger")
    finish
endif

let g:loaded_nerdtree_ranger = 1

" add the new menu item via NERD_Tree's API
call NERDTreeAddMenuItem({
    \ 'text': '(v)iew in ranger',
    \ 'shortcut': 'v',
    \ 'callback': 'NERDTreeRanger' })

function! NERDTreeRanger()
    " get the current dir from NERDTree
    let cd = g:NERDTreeDirNode.GetSelected().path.str()

    enew

    call termopen("ranger " . cd, { "on_exit": function("s:OnExit") })

endfunction

function! s:OnExit(job_id, data, event) dict
  let buf = bufnr("")

  edit #

  exe "bdelete!" buf
endfunction
