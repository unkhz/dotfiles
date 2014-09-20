#! /bin/bash

dotfiles="$(dirname $0)"

ln -s $dotfiles/.vimrc ~/.vimrc
ln -s $dotfiles/.vim ~/.vim
ln -s $dotfiles/.profile ~/.profile
ln -s $dotfiles/.path ~/.path