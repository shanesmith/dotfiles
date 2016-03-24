nnoremap <silent> <Leader>t :call g:NERDTreeHere("e")<CR>
nnoremap <silent> <Leader>tt :call g:NERDTreeHere("e")<CR>
nnoremap <silent> <Leader>ty :call g:NERDTreeHere("t")<CR>
nnoremap <silent> <Leader>tv :call g:NERDTreeHere("v")<CR>
nnoremap <silent> <Leader>ts :call g:NERDTreeHere("s")<CR>
nnoremap <silent> <Leader>tb :only \| call g:NERDTreeHere("e") \| normal B<CR>

" based on NERDTreeFind (lib/nerdtree/ui_glue.vim)
function! g:NERDTreeHere(split, ...)

  if &modified == 1 && a:split ==? "e"
    call nerdtree#echo("Buffer has been modified.")
    return
  endif

  try
    let p = g:NERDTreePath.New(expand("%:p"))
    if p.isUnixHiddenPath()
      let showhidden = g:NERDTreeShowHidden
      let g:NERDTreeShowHidden = 1
    endif
  catch /^NERDTree.InvalidArgumentsError/
    call nerdtree#echo("Current file no longer exists.")
  endtry

  if a:0 == 0

    try
      let cwd = g:NERDTreePath.New(getcwd())
    catch /^NERDTree.InvalidArgumentsError/
      call nerdtree#echo("Current directory no longers exist.")
      if !exists("p")
        call nerdtree#echo("Too many fails! Bailing out!")
      endif
      let cwd = p.getParent()
    endtry

    if !exists("p") || p.isUnder(cwd) || p.equals(cwd)
      let where = cwd
    else
      let where = p.getParent()
    endif

  else

    let where = g:NERDTreePath.New(expand(a:1))

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

  if exists("p") && p.isUnder(where) && !p.equals(where)

    let node = b:NERDTree.root.reveal(p)
    call b:NERDTree.render()
    call node.putCursorHere(1,0)

    if exists("showhidden")
      let g:NERDTreeShowHidden = showhidden
    endif

  endif

endfunction

function! s:VimEnterNERDTreeHere()
  if !exists("s:std_ind") && argc() == 0
    call g:NERDTreeHere("e")
    if has("gui_running")
      normal B
    endif
  endif
endfunction

augroup VimEnterNERDTreeHere
  au!
  au StdinReadPre * let s:std_in=1
  au VimEnter * call <SID>VimEnterNERDTreeHere()
augroup END
