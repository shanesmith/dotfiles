" Big W also writes
command! W w
command! Wq wq
command! WQ wq
command! Q q
command! Qa qa
command! QA qa

"Super ReTab
command! -range=% -nargs=0 Tab2Space execute '<line1>,<line2>s#^\t\+#\=repeat(" ", len(submatch(0))*' . &ts . ')'
command! -range=% -nargs=0 Space2Tab execute '<line1>,<line2>s#^\( \{'.&ts.'\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')'

"Source vimrc
command! ReloadVimrc source $MYVIMRC

command! -nargs=? -complete=syntax Scratch call <SID>NewScratch(<f-args>)
function! s:NewScratch(...)
  let type = a:0 ? a:1 : 'markdown'
  vnew
  exec "setf" type
endfunction

" http://www.bestofvim.com/tip/auto-reload-your-vimrc/
" augroup reload_vimrc " {
"     autocmd!
"     autocmd BufWritePost $MYVIMRC,~/Code/rc/vimrc,~/Code/rc/vim/* source $MYVIMRC | if (exists('g:loaded_airline') && g:loaded_airline) | call airline#load_theme() | endif
" augroup END " }

" Close vim if NERDTree is the last window
augroup nerdtree_vimrc
  autocmd!
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" Show cursorline only on current window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

"Load opend file on last known position
augroup LoadLastKnownPosition
  au!
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup TitleString
  au!
  auto BufEnter * let &titlestring = "Vim@" . hostname() . "/" . expand("%:p")
augroup END

augroup JSONRC
  au!
  auto BufNewFile,BufRead .jscsrc,.jshintrc setf json
augroup END

augroup js
  au!
  au FileType javascript UltiSnipsAddFiletypes javascript.javascript-angular.javascript-jasmine
augroup END
