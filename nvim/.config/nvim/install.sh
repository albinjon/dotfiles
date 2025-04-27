#!/bin/bash

# Check if mise is installed, if not install it
if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl https://mise.run | sh
    # Add mise to shell
    echo 'eval "$(mise activate)"' >> ~/.bashrc
    echo 'eval "$(mise activate)"' >> ~/.zshrc
    echo 'eval "$(mise activate)"' >> ~/.config/fish/config.fish
fi

# Install tools with mise first
echo "Installing tools with mise..."
mise install \
  deno@latest \
  fzf@latest \
  go@latest \
  lazygit@latest \
  lua-language-server@latest \
  node@lts \
  ripgrep@latest \
  stylua@latest \

# Install Go tools
echo "Installing Go tools..."
go install golang.org/x/tools/gopls@latest
# go install github.com/mgechev/revive@latest
# go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Install npm packages
echo "Installing npm packages..."
npm install -g \
  @fsouza/prettierd \
  @tailwindcss/language-server \
  pnpm \
  prettier \
  typescript-language-server \
  typescript \
  vscode-langservers-extracted  \
  @vue/language-server \
  @prisma/language-server \
  @volar/language-server \
  @styled/typescript-styled-plugin \
  neovim

echo "All tools have been installed successfully!"
