#! /bin/bash

# Unofficial bash strict mode
set -euo pipefail
IFS=$'\n\t'

echo "🚀 Installing basic tools"
sudo apt install git vim zsh screen -y

echo "🚀 Changing default shell to zsh"
chsh -s /bin/zsh