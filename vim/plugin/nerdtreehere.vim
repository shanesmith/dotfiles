nnoremap <silent> <C-t> :call g:NERDTreeHere("e")<CR>
nnoremap <silent> <Leader>tt :call g:NERDTreeHere("e")<CR>
nnoremap <silent> <Leader>ty :call g:NERDTreeHere("t")<CR>
nnoremap <silent> <Leader>tv :call g:NERDTreeHere("v")<CR>
nnoremap <silent> <Leader>ts :call g:NERDTreeHere("s")<CR>
nnoremap <silent> <Leader>tb :only \| call g:NERDTreeHere("e") \| normal B<CR>

" based on NERDTreeFind (lib/nerdtree/ui_glue.vim)
function! g:NERDTreeHere(split, ...)

  let base_path = get(a:, '1', "")
  let reveal_path = get(a:, '2', "")

  if base_path == ""
    let base_path = getcwd()
  endif

  if reveal_path == ""
    let reveal_path = expand("%:p")
  endif

  if &modified == 1 && a:split ==? "e" && len(win_findbuf(bufnr("%"))) < 2
    call nerdtree#echo("Buffer has been modified.")
    return
  endif

  try
    let reveal_path = g:NERDTreePath.New(reveal_path)
    if reveal_path.isUnixHiddenPath()
      let showhidden = g:NERDTreeShowHidden
      let g:NERDTreeShowHidden = 1
    endif
  catch /^NERDTree.InvalidArgumentsError/
    call nerdtree#echo("Current file no longer exists.")
    let reveal_path = {}
  endtry

  try
    let cwd = g:NERDTreePath.New(base_path)
  catch /^NERDTree.InvalidArgumentsError/
    call nerdtree#echo("Current directory no longers exist.")
    if !reveal_path
      call nerdtree#echo("Too many fails! Bailing out!")
    endif
    let cwd = p.getParent()
  endtry

  if reveal_path == {} || reveal_path.isUnder(cwd) || reveal_path.equals(cwd)
    let where = cwd
  else
    let where = reveal_path.getParent()
  endif

  if a:split ==? "v"
    vnew
  elseif a:split ==? "s"
    new
  elseif a:split ==? "t"
    tabnew
  else
    enew
  endif

  call g:NERDTreeCreator.CreateWindowTree(where.str())

  if reveal_path != {} && reveal_path.isUnder(where) && !reveal_path.equals(where)

    let node = b:NERDTree.root.reveal(reveal_path)
    call b:NERDTree.render()
    call node.putCursorHere(1,0)

    if exists("showhidden")
      let g:NERDTreeShowHidden = showhidden
    endif

  endif

endfunction

function! s:VimEnterNERDTreeHere()

  if exists("s:std_ind")
    return
  endif

  if argc() != 0

    if isdirectory(argv(0))
      exec "cd" argv(0)
    else
      return
    endif

  endif

  call g:NERDTreeHere("e")

  call b:NERDTree.ui.toggleShowBookmarks()

endfunction

augroup VimEnterNERDTreeHere
  au!
  au StdinReadPre * let s:std_in=1
  au VimEnter * call <SID>VimEnterNERDTreeHere() " TODO profile me!
augroup END
