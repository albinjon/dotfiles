#!/bin/bash
if [[ $OSTYPE == 'linux-gnu' ]]; then
   sudo pacman -S go stylua deno fzf lazygit lua-language-server nodejs ripgrep nvm --needed
elif [[ $OSTYPE == 'darwin' ]]; then
  brew install \
    go@latest \
    stylua \
    deno@latest \
    fzf@latest \
    go@latest \
    lazygit@latest \
    lua-language-server@latest \
    node@lts \
  ripgrep@latest \
  vtsls@latest
fi

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
  @vue/language-server \
  @styled/typescript-styled-plugin \
  @emmetio/css-parser

echo "All tools have been installed successfully!"
