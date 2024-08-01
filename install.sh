#! /bin/bash

# Unofficial bash strict mode
set -euo pipefail
IFS=$'\n\t'

dotfiles=$(cd $(dirname $0) && pwd)
lnopts="-s"

while getopts hf OPTION; do
  case $OPTION in
  h)
    echo "Usage: install.sh"
    echo "-f Remove existing files before linking"
    exit 0
    ;;
  f)
    echo "Removing existing files before linking"
    lnopts="-fs"
    ;;
  esac
done

# oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ln $lnopts $dotfiles/.vimrc ~
ln $lnopts $dotfiles/.vim ~
ln $lnopts $dotfiles/.bashrc ~
ln $lnopts $dotfiles/.zshrc ~
ln $lnopts $dotfiles/.profile ~
ln $lnopts $dotfiles/.path ~
ln $lnopts $dotfiles/bin ~
ln $lnopts $dotfiles/.oh-my-zsh/custom/themes/unkhz.zsh-theme ~/.oh-my-zsh/custom/themes

# Git settings
git config --global user.name "Juhani Pelli"
git config --global user.email "juhani.pelli@gmail.com"
git config --global core.editor vim
git config --global pull.rebase true