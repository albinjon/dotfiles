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
        -- transparent_background = true,
      })
      vim.cmd('colorscheme catppuccin')
      vim.api.nvim_set_hl(0, 'Visual', { bg = '#495068', ctermbg = 'NONE', blend = 0 })
      vim.api.nvim_set_hl(0, 'VisualNOS', { bg = '#495068', ctermbg = 'NONE', blend = 0 })
      vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#45475a' })
      vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#FFA01E' })
      vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { link = 'Tag' })
      vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { link = 'Tag' })
      vim.api.nvim_set_hl(0, 'BlinkCmpDocSeparator', { link = 'Tag' })
      vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#45475a', ctermbg = 'NONE', blend = 0 })
      vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#45475a', ctermbg = 'NONE', blend = 0 })
      vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#45475a', ctermbg = 'NONE', blend = 80 })
    end,
  },
}
