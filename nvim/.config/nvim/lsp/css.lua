return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  settings = {
    css = {
      lint = {
        unknownAtRules = 'ignore',
      },
    },
  },
  filetypes = { 'css', 'vue', 'html' },
  root_markers = { 'package.json' },
}
