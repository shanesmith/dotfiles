
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

augroup AldmerisColorTweaks
  au!
  au ColorScheme aldmeris call <SID>AldmerisColorTweaks()
augroup END

function! s:AldmerisColorTweaks()
  hi DiffAdd term=bold cterm=bold ctermfg=64 ctermbg=0 gui=bold guifg=#4e9a06 guibg=#000
  hi DiffText term=reverse cterm=bold ctermfg=74 ctermbg=0 gui=bold guifg=#729fcf guibg=#000
  hi ExtraWhitespace ctermbg=124 guibg=#af0000
endfunction

