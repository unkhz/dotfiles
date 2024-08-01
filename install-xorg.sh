#!/bin/bash

# Unofficial bash strict mode
set -euo pipefail
IFS=$'\n\t'

# console
localectl set-keymap --no-convert $HOME/.dotfiles/xkb/kbd/unkhz.map

# xorg
sudo mkdir -p /usr/share/X11/xkb/symbols
sudo rm -f /usr/share/X11/xkb/symbols/fi
sudo ln -s /home/unkhz/.dotfiles/xkb/symbols/unkhz /usr/share/X11/xkb/symbols/fi