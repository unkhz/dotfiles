#! /bin/bash

echo "🚀 Installing basic tools"
apt install git vim zsh -y

echo "🚀 Changing default shell to zsh"
chsh -s /bin/zsh