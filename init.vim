" http://stackoverflow.com/questions/9990219/vim-whats-the-difference-between-let-and-set
" Borrows from https://github.com/terryma/dotfiles/blob/master/.vimrc
" Borrows from https://github.com/klen/.vim

"" -------------------
" Look and Feel
" -------------------

if has('nvim')
  let g:VIM_CONFIG_HOME = $HOME.'/.config/nvim'
else
  let g:VIM_CONFIG_HOME = $HOME.'/.vim'
endif
let g:VIM_PLUGIN_HOME   = g:VIM_CONFIG_HOME . '/bundle'

let g:SESSION_DIR       = $HOME.'/.cache/vim/sessions'


" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
        silent function! FREEBSD()
          let s:uname = system("uname -s")
          return (match(s:uname, 'FreeBSD') >= 0)
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          execute 'set runtimepath=' . g:VIM_CONFIG_HOME . ',' . $VIM . '/vimfiles,' . $VIMRUNTIME . ','. $VIM . '/vimfiles/after,' . g:VIM_CONFIG_HOME . '/after'
        endif
    " }

" }

" Function to source only if file exists {
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
" }

" Function to source all .vim files in directory {
function! SourceDirectory(file)
  for s:fpath in split(globpath(a:file, '*.vim'), '\n')
    exe 'source' s:fpath
  endfor
endfunction

" Use before config if available {
    call SourceIfExists(g:VIM_CONFIG_HOME .'/before.vim')
" }

" Don't reset twice on reloading - 'compatible' has SO many side effects.
if !exists('s:loaded_my_vimrc')
  call SourceDirectory(g:VIM_CONFIG_HOME  .'/quirks')

  call SourceIfExists(g:VIM_CONFIG_HOME   .'/ignore.vim')
  call SourceIfExists(g:VIM_CONFIG_HOME   .'/rice.vim')

  call SourceDirectory(g:VIM_CONFIG_HOME  .'/settings')


  call SourceIfExists(g:VIM_CONFIG_HOME   .'/bundle_loader.vim')
  call SourceDirectory(g:VIM_CONFIG_HOME  .'/bundles.settings')
endif


"===============================================================================
" Local Settings
"===============================================================================

call SourceIfExists(g:VIM_CONFIG_HOME     .'/colors.vim')

" Use fork vimrc if available {
    call SourceIfExists(g:VIM_CONFIG_HOME .'/fork.vim')
" }

" Use local vimrc if available {
    call SourceIfExists(g:VIM_CONFIG_HOME .'/local.vim')
" }

" FreeBSD-specific terminal fixes
if FREEBSD()
  call SourceIfExists(g:VIM_CONFIG_HOME   .'/compat/freebsd.vim')
  call SourceIfExists('/usr/src/tools/tools/editing/freebsd.vim')
end

" Use local gvimrc if available and gui is running {
  if has('gui_running')
    call SourceIfExists(g:VIM_CONFIG_HOME .'/local.gvim')
  endif
" }

if !exists('s:loaded_my_vimrc')
  let s:loaded_my_vimrc = 1
endif
