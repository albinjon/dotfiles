return {
  {
    'catppuccin/nvim',
    priority = 1000,
    config = function()
      require('catppuccin').setup()
      vim.cmd 'colorscheme catppuccin'
      vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#302f3f' })
      vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#302f3f' })
      vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#302f3f' })
    end,
  },
}
