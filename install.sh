#! /bin/bash

dotfiles=$(cd $(dirname $0) && pwd)
lnopts="-s"

while getopts hf OPTION
do
  case $OPTION in
    h) echo "Usage: install.sh"
       echo "-f Remove existing files before linking"
       exit 0
       ;;
    f) echo "Removing existing files before linking"
       lnopts="-fs"
      ;;
  esac
done

# oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# nvm
if [ ! -d ~/.nvm ]; then
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
fi

ln $lnopts $dotfiles/.vimrc ~
ln $lnopts $dotfiles/.vim ~
ln $lnopts $dotfiles/.bashrc ~
ln $lnopts $dotfiles/.zshrc ~
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


#settings
git config --global user.name "Juhani Pelli"
git config --global user.email "juhani.pelli@gmail.com"
git config --global merge.tool opendiff
