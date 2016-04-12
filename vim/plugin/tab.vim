" https://github.com/shanesmith/vim-tab

if !exists("g:PreTabNr")
	let g:PreTabNr = 1
endif

if !exists("g:LastTabPages")
	let g:LastTabPages = 1 "origin as 1 tab exists
endif

if !exists("g:TabDirs")
	let g:TabDirs = ["","","","","","","","","","",""] "index 0 not use
endif

if !exists("s:TabAutocmdLoaded")
	let s:TabAutocmdLoaded = 1
	autocmd TabEnter * call s:TabCallEnterFunc()
	autocmd TabLeave * call s:TabCallLeaveFunc()
endif

"if a tab enter, check if some new tab create
func! s:TabCallEnterFunc()
	"echo "tab enter:" tabpagenr()
	let TabPages = tabpagenr('$')
	if g:LastTabPages != TabPages
		if g:LastTabPages < TabPages
			if TabPages >= 9
				echo "tab.vim don't support more than 9 tabs"
				return
			endif
			"echo "one page add"
			let nr = tabpagenr()
			if g:TabDirs[nr] != ""
				"echo "page nr dir not empty"
				let saveTabDirs = g:TabDirs[:]
				let g:TabDirs[nr] = <SID>GetTabWorkingDir() 
				let g:TabDirs[nr+1 : ] = saveTabDirs[nr : ]
			else
				"echo "page nr dir empty"
				"XXX can't get cwd when tab enter
				"leave it blank, rely on tableave
			endif
			let g:LastTabPages = TabPages
		else
			"echo "one page close:" g:PreTabNr
			let nr = g:PreTabNr
			if nr > TabPages
				"the last page close
				"echo "last page close"
				let g:TabDirs[nr] = ""
			else
				"echo "not the last page close"
				let saveTabDirs = g:TabDirs[:]
				let g:TabDirs[nr : TabPages] = saveTabDirs[nr+1 : TabPages+1]
				let g:TabDirs[TabPages+1] = ""
			endif
			let g:LastTabPages = TabPages
			let tabdir = g:TabDirs[tabpagenr()]
			exec "silent cd " . tabdir
		endif
	else
		let tabdir = g:TabDirs[tabpagenr()]
		exec "silent cd " . tabdir
	endif
	let nr = tabpagenr()
endfunc

"if a tab leave, check if some tab close
func! s:TabCallLeaveFunc()
	"remember previous tab nr
	"echo "tab leave:" tabpagenr()
	let TabPages = tabpagenr('$')
	let nr = tabpagenr()
	if g:LastTabPages != TabPages
		"XXX this don't work, pagenr not imedietely reduce in here
		"do it in tabenter
		"echo "some page close"
	else
		"echo "page the same"
		let g:TabDirs[nr] = <SID>GetTabWorkingDir() "save dir
	endif
	let g:PreTabNr = nr
	let nr = tabpagenr()
endfunc

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
