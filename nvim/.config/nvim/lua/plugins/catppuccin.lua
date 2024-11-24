return {
  {
    lazy = false,
    'catppuccin/nvim',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        integrations = {
          notify = true,
        },
        transparent_background = true,
      })
      vim.cmd('colorscheme catppuccin')
      vim.api.nvim_set_hl(0, 'Visual', { bg = '#495068', ctermbg = 'NONE', blend = 0 })
      vim.api.nvim_set_hl(0, 'VisualNOS', { bg = '#495068', ctermbg = 'NONE', blend = 0 })
      vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#45475a', ctermbg = 'NONE' })
      vim.api.nvim_set_hl(0, 'LineNr', { fg = '#9399b2' })
      vim.api.nvim_set_hl(0, 'TelescopeSelection', { fg = '#FFA01E' })
      vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#FFA01E' })
      vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#302f3f' })
      vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#302f3f' })
      vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#302f3f' })
    end,
  },
}
