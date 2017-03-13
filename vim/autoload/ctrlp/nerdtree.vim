if exists('g:loaded_ctrlp_nerdtree') && g:loaded_ctrlp_nerdtree
  finish
endif

let g:loaded_ctrlp_nerdtree = 1

call add(g:ctrlp_ext_vars, {
      \ 'lname': 'nerdtree',
      \ 'sname': 'nerdtree',
      \ 'type': 'path',
      \ 'init': 'ctrlp#nerdtree#init()',
      \ 'accept': 'ctrlp#nerdtree#accept'
      \ })

function! ctrlp#nerdtree#init()
  " return split(system("rg . --files --color=never --glob '' --null | xargs -0 -L1 dirname | sort | uniq | tail -n+2"), "\n")
  return ctrlp#files()
endfunction

function! ctrlp#nerdtree#accept(mode, str)
  call ctrlp#exit()
  call g:NERDTreeHere('e', "", a:str)
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#nerdtree#id()
  return s:id
endfunction
