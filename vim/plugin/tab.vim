au TabEnter * if exists("t:wd") | exe 'cd' t:wd | endif
au TabLeave * let t:wd = <SID>GetTabWorkingDir()

func! s:GetTabWorkingDir()

  let cwd = getcwd()

  if haslocaldir()

    let i = 1

    while i <= winnr('$')
      if !haslocaldir(i)
        let cwd = getcwd(i)
        break
      endif
      let i += 1
    endwhile

  endif

  return cwd

endfunc
