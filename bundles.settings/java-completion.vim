autocmd FileType java set omnifunc=javacomplete#Complete

function! s:JavaImport()
  JCimportsRemoveUnused
  JCimportsAddMissing
endfunction
command! -nargs=0 JavaImport call s:JavaImport()
