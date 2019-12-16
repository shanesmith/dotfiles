" don't load multiple times
if exists("g:loaded_nerdtree_bookmark")
    finish
endif

let g:loaded_nerdtree_bookmark = 1

" add the new menu item via NERD_Tree's API
call NERDTreeAddMenuItem({
    \ 'text': '(b)ookmark',
    \ 'shortcut': 'b',
    \ 'callback': 'NERDTreeMenuBookmark'})

function! NERDTreeMenuBookmark()
  Bookmark
endfunction

