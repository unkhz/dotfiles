#! /bin/bash

echo "🚀 Installing basic tools"
sudo apt install git vim zsh screen -y

echo "🚀 Changing default shell to zsh"
chsh -s /bin/zsh