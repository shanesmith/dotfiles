
"TODO automatic date prefix?
function! s:NotesSave()

  exec "cd" expand(g:notes_folder)
  let name = input("Save note as: ", fnamemodify(bufname("%"), ':.:r'), "file")
  redraw
  cd -

  if name == ""
    return
  endif

  let fname = expand(g:notes_folder) . "/" . name

  if fnamemodify(fname, ":e") != "md"
    let fname .= ".md"
  endif

  if filereadable(fname)
    echohl ErrorMsg
    echomsg "File" fname "already exists!"
    echohl None
    return
  endif

  let path = fnamemodify(fname, ':h')

  if !isdirectory(path)
    call mkdir(path, 'p')
  endif

  exec "saveas" fnameescape(fname)

endfunction

function! s:NotesNew()

  if bufname('%') != ''
    vnew
  endif

  let fname = expand(g:notes_folder) . "/"  . strftime("%Y-%m-%d--%H-%M") . ".md"

  exec "saveas" fnameescape(fname)

  setf markdown

endfunction

function! s:NotesTree()

  let where = "v"

  if stridx(expand('%:p'), expand(g:notes_folder)) == 0 || (bufname('%') == '' && line('$') == 1 && getline(1) == '')
    let where = "e"
  endif

  call <SID>NERDTreeHere(where, g:notes_folder)

endfunction

let g:notes_folder = "~/Dropbox/notes"
nnoremap <Leader>nt :call <SID>NotesTree()<CR>
nnoremap <Leader>nw :call <SID>NotesSave()<CR>
nnoremap <Leader>nn :call <SID>NotesNew()<CR>
nnoremap <leader>np :exec "CtrlP" g:notes_folder<CR>
nnoremap <leader>pn :exec "CtrlP" g:notes_folder<CR>

