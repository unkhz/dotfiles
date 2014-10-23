#! /bin/bash

dotfiles="$(dirname $0)"
lnopts='-s'

while getopts hf OPTION
do
  case $OPTION in
    h) echo "Usage: install.sh"
       echo "-f Remove existing files before linking"
       exit 0
       ;;
    f) echo "Removing existing files before linking"
       lnopts= '-fs'
      ;;
  esac
done

ln $lnopts $dotfiles/.vimrc ~
ln $lnopts $dotfiles/.vim ~
ln $lnopts $dotfiles/.bashrc ~
ln $lnopts $dotfiles/.profile ~
ln $lnopts $dotfiles/.path ~
ln $lnopts $dotfiles/.slate ~

if [ -f ~/.ssh/authorized_keys ]; then
  cat ~/.ssh/authorized_keys $dotfiles/.ssh/authorized_keys | uniq > ~/.ssh/authorized_keys
fi

if [ -d ~/Library ]; then
  # Make fn-left and fn-right properly jump to start and end of line
  mkdir -p ~/Library/KeyBindings
  cp -a $dotfiles/Library/KeyBindings/DefaultKeyBinding.dict ~/Library/KeyBindings/

  # Add Fi-Unkhz programming layout
  cp -a $dotfiles/Library/Keyboard\ Layouts/fi-unkhz-mac.keylayout ~/Library/Keyboard\ Layouts/

  # Repair keyhold feature
  defaults write -g ApplePressAndHoldEnabled -bool false
fi