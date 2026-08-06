return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false, -- the main branch does not support lazy-loading
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install({
      'bash',
      'c',
      'c_sharp',
      'css',
      'styled',
      'diff',
      'http',
      'html',
      'javascript',
      'java',
      'jsdoc',
      'json',
      'lua',
      'luadoc',
      'luap',
      'markdown',
      'markdown_inline',
      'printf',
      'python',
      'prisma',
      'query',
      'regex',
      'vue',
      'go',
      'toml',
      'tsx',
      'typescript',
      'terraform',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
    })

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
      end,
    })
  end,
}
