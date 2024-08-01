#!/bin/bash

# rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf /usr/local/bin/nvim
rm -rf ./plugin/packer_compiled.lua

brew install neovim ripgrep
