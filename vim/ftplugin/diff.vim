" Based on https://github.com/sgeb/vim-diff-fold

if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

setlocal foldmethod=expr foldexpr=DiffFoldLevel()

function! DiffFoldLevel()
    let l:line=getline(v:lnum)

    if l:line =~# '^\(diff\|Index\)'     " file
        return '>1'
    elseif l:line =~# '^\(@@\|\d\)'  " hunk
        return '>2'
    elseif l:line =~# '^\*\*\* \d\+,\d\+ \*\*\*\*$' " context: file1
        return '>2'
    elseif l:line =~# '^--- \d\+,\d\+ ----$'     " context: file2
        return '>2'
    else
        return '='
    endif
endfunction
