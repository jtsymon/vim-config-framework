function! StartFuzzyFinder()
  fun! s:fzf_root()
    let path = finddir(".git", expand("%:p:h").";")
    return fnamemodify(substitute(path, ".git", "", ""), ":p:h")
  endfun

  " Like :GitFiles, but shows all non-ignored files
  " (including new files which aren't tracked)
  command! -nargs=0 FilesIgnore call fzf#run(
  \ {'source': 'ag -g ""', 'sink': 'e', 'options': '-m', 'dir': <SID>fzf_root()})

  nnoremap <silent> <c-p> :exe 'FilesIgnore'<CR>
endfunction

call StartFuzzyFinder()
