return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  settings = {
    css = {
      lint = {
        unknownAtRules = 'ignore',
      },
    },
  },
  filetypes = { 'css', 'html' },
  root_markers = { 'package.json' },
}
