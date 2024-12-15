return {
  'm4xshen/hardtime.nvim',
  event = 'InsertEnter',
  dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
  opts = {
    max_count = 5,
    disable_mouse = false,
    disabled_keys = {
      ['<Up>'] = {},
      ['<Down>'] = {},
    },
  },
}
