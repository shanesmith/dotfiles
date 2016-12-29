
if &t_Co == 256 || has("gui_running")
  try
    colorscheme aldmeris
  catch
    colorscheme desert
  endtry
else
  colorscheme desert
endif

hi CursorLine ctermbg=234 guibg=#404040
hi ExtraWhitespace ctermbg=124 guibg=#af0000
hi DiffAdd term=bold cterm=bold ctermfg=64 ctermbg=0 gui=bold guifg=#4e9a06 guibg=#000000
hi DiffText term=reverse cterm=bold ctermfg=74 ctermbg=0 gui=bold guifg=#729fcf guibg=#000000
hi LineNr guibg=#222222 guifg=#888a85
" hi conflictOurs term=bold cterm=bold ctermfg=64 ctermbg=0 gui=bold guifg=#4e9a06 guibg=#000
" hi conflictTheirs term=reverse cterm=bold ctermfg=74 ctermbg=0 gui=bold guifg=#729fcf guibg=#000

