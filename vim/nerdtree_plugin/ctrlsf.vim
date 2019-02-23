" don't load multiple times
if exists("g:loaded_nerdtree_ctrlsf")
    finish
endif

let g:loaded_nerdtree_ctrlsf = 1

" add the new menu item via NERD_Tree's API
call NERDTreeAddMenuItem({
    \ 'text': '(s)earch directory',
    \ 'shortcut': 's',
    \ 'callback': 'NERDTreeCtrlSF' })

function! NERDTreeCtrlSF()
    " get the current dir from NERDTree
    let cd = g:NERDTreeDirNode.GetSelected().path.str()

    " get the pattern
    let pattern = input("Enter the pattern and arguments: ")
    if pattern == ''
        echo 'Maybe another time...'
        return
    endif

    " CtrlSF it!
    exec "CtrlSF ".pattern." '".cd."'"
endfunction
