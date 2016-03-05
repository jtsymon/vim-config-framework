if empty(glob(g:VIM_CONFIG_HOME.'/autoload/plug.vim'))
  silent execute '!curl -fLo "'.g:VIM_CONFIG_HOME.'/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Automatically install missing plugins on startup
autocmd VimEnter *
  \| if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall | q
  \| endif

call plug#begin(g:VIM_PLUGIN_HOME)

if !exists('g:bundles')
  for fpath in split(globpath(g:VIM_CONFIG_HOME.'/bundles.d/', '*.vim'), '\n')
    exe 'source' fpath
  endfor
else
  for fpath in g:bundles
    if filereadable(expand(fpath))
      exe 'source' expand(fpath)
    endif
  endfor
endif


call plug#end()
