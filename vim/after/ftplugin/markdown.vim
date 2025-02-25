" https://github.com/plasticboy/vim-markdown/issues/462#issuecomment-694818508

function! s:link_surround(mode, type)
  let l:link = getreg("*")
  if l:link !~ '^https\?://'
    let l:link = ""
  endif
  if a:mode == 'n'
    let l:str = expand('<cWORD>')
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
  if a:type ==# 'x'
    let l:new = strcharpart(l:line, 0, l:idx)
          \ . '[' . strcharpart(l:line, l:idx, l:len) . '](' . l:link . ')'
          \ . strcharpart(l:line, l:idx + l:len)
    call setline(l:lnum, l:new)
  elseif a:type ==# 'X'
    let l:eof_lnum = search('^# -\{24\} >8 -\{24\}', 'nW')
    if l:eof_lnum != 0
      let l:eof_lnum -= 1
    else
      let l:eof_lnum = line('$')
    endif

    call cursor(l:eof_lnum, 0)
    let l:prev_lnum = search('^\[\d\+\]: ', 'bcnW')
    if l:prev_lnum != 0
      let l:prev_num = matchstr(getline(l:prev_lnum), '^\[\zs\d\+\ze\]')
    else
      let l:prev_lnum = l:eof_lnum
      let l:prev_num = 0

      if getline(l:prev_lnum) !~ '^\s*$'
        call append(l:prev_lnum, '')
        let l:prev_lnum += 1
      endif
    endif
    let l:next_num = l:prev_num + 1

    call append(l:prev_lnum, '[' . l:next_num . ']: ' . l:link)

    let l:new = strcharpart(l:line, 0, l:idx)
          \ . '[' . strcharpart(l:line, l:idx, l:len) . '][' . l:next_num . ']'
          \ . strcharpart(l:line, l:idx + l:len)
    call setline(l:lnum, l:new)
  endif
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

function! s:open_or_create_link(type)
  let l:snr = s:markdown_script_number()
  let l:url = s:get_url(snr)
  if a:type ==# 'X' && l:url =~ '^https\?://github\.com/\(.*\)/\(issues\|pull\)/\(.*\)$'
    let [l:bufnum, l:lnum, l:col, l:off, _] = getcurpos()
    let l:len = strchars(l:url)
    let l:line = getline(l:lnum)
    let l:idx = strridx(l:line, l:url, l:col)
    let l:sub = substitute(l:url, '^https\?://github\.com/\(.*\)/\(issues\|pull\)/\(.*\)$', '\1#\3', '')
    let l:new = strcharpart(l:line, 0, l:idx)
          \ . l:sub
          \ . strcharpart(l:line, l:idx + l:len)
    call setline(l:lnum, l:new)
    call setpos('.', [l:bufnum, l:lnum, l:idx + strchars(l:sub), l:off])
  elseif l:url != ''
    call call('<SNR>'.l:snr.'_VersionAwareNetrwBrowseX', [l:url])
  else
    call s:link_surround('n', a:type)
  endif
endfunction

nnoremap <buffer><silent> gx :<C-u>call <SID>open_or_create_link('x')<CR>
vnoremap <buffer><silent> gx :call <SID>link_surround('v', 'x')<CR>
nnoremap <buffer><silent> gX :<C-u>call <SID>open_or_create_link('X')<CR>
vnoremap <buffer><silent> gX :call <SID>link_surround('v', 'X')<CR>
