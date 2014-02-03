"SuperSub Version 0.1
"Author Phil Miller (phil_bw)
"
"How to use:
"
"- Install supersub.vim as you would any vim script
"- Access it by :S
"- The "g" flag is optional and is automatically added
"
"Examples:
"- Replace two words at once in the same line (also works on a range of lines)
"Before: Example line with the word one and number 1
":S/one/two/1/2/g
"After: Example line with the word two and number 2
"
"- Replace one word with a series of words
"Before: The Word One
"Before: The Word One
"Before: The Word One
"Before: The Word One
":17,19S/One/;Two;Three;Four/g
"After: The Word One
"After: The Word Two
"After: The Word Three
"After: The Word Four
"
"Substitutions can be mixed as well, by adding /Word/Text to the last example
"it'd change as in the example as well as change all instances of Word to Text
"
function! s:supersub(slist,lstart,lend)
	"echo a:slist
	let delim = strpart(a:slist,0,1)
	let flist = split(a:slist,delim)
	let e = 0
	let o = 1
	if (len(flist) % 2) == 0
		let stopcount = 1
		let submod = "g"
	else
		let stopcount = 2
		let submod = flist[len(flist)-1]
	endif
	while e <= len(flist) - stopcount
		"echo flist[e]." ".flist[o]
	  if strpart(flist[o],0,1) == ';'
			let elist = split(flist[o],';')
			let cline = a:lstart
			for part in elist
				"echo part." ".cline
				execute "silent ".cline."substitute".delim.flist[e].delim.part.delim.submod
				let cline += 1
			endfor
		else
			execute "silent ".a:lstart.",".a:lend."substitute".delim.flist[e].delim.flist[o].delim.submod
		endif
		"echo flist[len(flist)-1]
		let e += 2
		let o += 2
	endwhile
endfunction

command! -nargs=1 -range S call s:supersub(<f-args>,<line1>,<line2>)
