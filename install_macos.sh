#!/bin/bash

# rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf /usr/local/bin/nvim
rm -rf ./plugin/packer_compiled.lua

curl -sSfL https://golangci-lint.run/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.7.2

brew install neovim ripgrep
