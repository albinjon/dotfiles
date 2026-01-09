return {
  cmd = { 'prisma-language-server', '--stdio' },
  filetypes = { 'prisma' },
  root_markers = { 'package.json' },
  settings = {
    prisma = {
      enableDiagnostics = true,
    },
  },
}
