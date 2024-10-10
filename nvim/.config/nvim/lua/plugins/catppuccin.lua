return {
  {
    'catppuccin/nvim',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        integrations = {
          notify = true,
        },
      })
      vim.cmd('colorscheme catppuccin')
      -- vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#495068', blend = 0 })
      vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#302f3f' })
      vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#302f3f' })
      vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#302f3f' })
    end,
  },
}
