" au TabEnter * if exists("t:wd") | exe 'cd' t:wd | endif
" au TabLeave * let t:wd = getcwd(-1, -1)
