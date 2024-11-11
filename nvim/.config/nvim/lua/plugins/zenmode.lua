return {
  'folke/zen-mode.nvim',
  dependencies = {
    {
      'folke/twilight.nvim',
      opts = {
        context = 20,
      },
    },
  },
  cmd = 'ZenMode',
  keys = {
    { '<leader>zm', '<cmd>ZenMode<cr>', desc = 'Zen Mode' },
  },
  opts = {
    plugins = {
      twilight = { enabled = true },
    },
  },
}
