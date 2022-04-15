" https://github.com/plasticboy/vim-markdown/issues/462#issuecomment-694818508

function! s:link_surround(mode)
  if a:mode == 'n'
    let l:str = expand('<cword>')
    let [l:bufnum, l:lnum, l:col, l:off, _] = getcurpos()
    let l:len = strchars(l:str)
    let l:line = getline(l:lnum)
    let l:idx = strridx(l:line, l:str, l:col)
  elseif a:mode == 'v'
    let [l:bufnum, l:lnum, l:col_start, l:off] = getpos("'<")
    let [l:line_end, l:col_end] = getpos("'>")[1:2]
    if l:lnum != l:line_end
      throw 'Toggle link on multiple lines is not supported.'
    endif
    let l:idx = l:col_start - 1
    let l:len = l:col_end - l:idx
    let l:line = getline(l:lnum)
  endif
  let l:new = strcharpart(l:line, 0, l:idx)
        \ . '[' . strcharpart(l:line, l:idx, l:len) . ']()'
        \ . strcharpart(l:line, l:idx + l:len)
  call setline(l:lnum, l:new)
  call setpos('.', [l:bufnum, l:lnum, l:idx + l:len + 4, l:off])
endfunction

function! s:markdown_script_number()
  let scripts = split(execute("scriptnames"), '\n')
  let index = match(scripts, '/vim-polyglot/ftplugin/markdown.vim$')
  if index == -1
    return ""
  endif
  let snr = matchstr(scripts[index], '^\d\+')
  return snr
endfunction

function! s:get_url(snr)
  let fname = '<SNR>'.a:snr.'_Markdown_GetUrlForPosition'

  if !exists("*".fname)
    return ""
  endif

  return call(fname, [line('.'), col('.')])
endfunction

function! s:open_or_create_link()
  let snr = s:markdown_script_number()
  let l:url = s:get_url(snr)
  if l:url != ''
    call call('<SNR>'.snr.'_VersionAwareNetrwBrowseX', [l:url])
  else
    call s:link_surround('n')
  endif
endfunction

nnoremap <buffer><silent> gx :<C-u>call <SID>open_or_create_link()<CR>
vnoremap <buffer><silent> gx :call <SID>link_surround('v')<CR>
