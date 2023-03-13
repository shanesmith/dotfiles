command! -range -buffer SourceLine call execute(getline(<line1>, <line2>)) | echo "Sourced!"

command! -range -buffer SourceLineLua exec "lua" join(getline(<line1>, <line2>), "\n") | echo "Sourced!"
