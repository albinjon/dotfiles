return {
  {
    event = 'BufWinEnter',
    'folke/noice.nvim',
    dependencies = {
      'rcarriga/nvim-notify',
      opts = {
        render = 'wrapped-compact',
        stages = 'slide',
        fps = 60,
        timeout = 1800,
        max_width = 80,
      },
    },
    opts = {
      lsp = {
        hover = {
          border = 'rounded',
          silent = true,
        },
        signature = {
          border = 'rounded',
          silent = true,
        },
      },
      presets = {
        lsp_doc_border = true,
      },
    },
  },
}
