#! /bin/bash

# Unofficial bash strict mode
set -euo pipefail
IFS=$'\n\t'

if [ -d ~/Library ]; then
  echo "🚀 Installing nvm"
  if [ ! -d ~/.nvm ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi

  echo "🚀 Installing configurations"
  mkdir -p ~/Library/Application\ Support/lazygit
  ln $lnopts $dotfiles/.lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml

  ln $lnopts $dotfiles/.slate ~

  ln $lnopts $dotfiles/.hammerspoon ~

  mkdir -p ~/.config/karabiner/assets/complex_modifications
  ln $lnopts $dotfiles/.config/karabiner/assets/complex_modifications/unkhz.json ~/.config/karabiner/assets/complex_modifications/unkhz.json

  # Make fn-left and fn-right properly jump to start and end of line
  mkdir -p ~/Library/KeyBindings
  cp -a $dotfiles/Library/KeyBindings/DefaultKeyBinding.dict ~/Library/KeyBindings/

  # Add Fi-Unkhz programming layout
  cp -a $dotfiles/Library/Keyboard\ Layouts/fi-unkhz-mac.keylayout ~/Library/Keyboard\ Layouts/

  # Repair keyhold feature
  defaults write -g ApplePressAndHoldEnabled -bool false

  echo "🚀 Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "🚀 Installing lazygit"
  brew install lazygit

  echo "🚀 Installing git-delta"
  brew install git-delta
  git config --global core.pager delta
else
  echo "❓ This does not seem to be MacOS. Are you sure you're running the correct thing?"
fi
