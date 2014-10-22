#! /bin/bash

dotfiles="$(dirname $0)"

ln -s $dotfiles/.vimrc ~/.vimrc
ln -s $dotfiles/.vim ~/.vim
ln -s $dotfiles/.bashrc ~/.bashrc
ln -s $dotfiles/.profile ~/.profile
ln -s $dotfiles/.path ~/.path
ln -s $dotfiles/.slate ~/.slate

if [ -f ~/.ssh/authorized_keys ]; then
  cat ~/.ssh/authorized_keys $dotfiles/.ssh/authorized_keys | uniq > ~/.ssh/authorized_keys
fi

if [ -d ~/Library ]; then
  cp -a $dotfiles/Library/KeyBindings/DefaultKeyBinding.dict ~/Library/KeyBindings/
  cp -a $dotfiles/Library/Keyboard\ Layouts/fi-unkhz-mac.keylayout ~/Library/Keyboard\ Layouts/
fi