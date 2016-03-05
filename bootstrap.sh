#!/usr/bin/env sh

set -e

VIM=$(vim --version | head -1 | cut -d' ' -f1)

case $VIM in
    NVIM)
        VIM_CONFIG_HOME=~/.config/nvim
        VIMRC=.
        ;;
    *)
        VIM_CONFIG_HOME=~/.vim
        VIMRC=~/.vimrc
        ;;
esac

echo -n "Location to bootstrap? [$VIM_CONFIG_HOME] "
read location
if [[ -n $location ]]; then
    VIM_CONFIG_HOME=$location
fi

echo -n "Bootstrap $VIM_CONFIG_HOME? [yN] "
read choice
case $choice in
    y|Y)
        ;;
    *)
        echo "No changes have been made"
        exit 0
        ;;
esac

mkdir -p $VIM_CONFIG_HOME
cd $VIM_CONFIG_HOME

if [[ $(echo * ) != '*' ]]; then
    echo "Directory not empty: [" * "]" >&2
    exit 1
fi

dirs=( bundles.d bundles.settings settings )
mkdir ${dirs[@]}
git init
echo bundle >> .gitignore
echo autoload >> .gitignore
git submodule add https://github.com/jtsymon/vim-config-framework.git framework
ln -rs framework/ftdetect .
ln -rs framework/init.vim $VIMRC
echo "Symlink files to enable them:"
for dir in "${dirs[@]}"; do
    echo "  ln -rs framework/$dir/example.vim $dir/"
done
