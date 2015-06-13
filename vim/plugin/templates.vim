let g:templates_folder = "~/.vim/templates/"

function! s:LoadTemplate(path)
  let fullpath = expand(g:templates_folder) . a:path
  exec "read" fullpath
endfunction

function! s:LoadTemplateComplete(ArgLead, CmdLine, CursorPos)
  return join(map(globpath(g:templates_folder, '*', 0, 1), 'strpart(v:val, ' . strlen(expand(g:templates_folder)) . ')'), "\n")
endfunction

command! -nargs=1 -complete=custom,s:LoadTemplateComplete TemplateLoad call s:LoadTemplate(<f-args>)

command! Test echo s:LoadTemplateComplete(1,2,3)

