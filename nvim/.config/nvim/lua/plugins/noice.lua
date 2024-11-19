return {
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
  config = function()
    require('noice').setup({
      presets = {
        lsp_doc_border = true, -- adds a border to hover docs and signature help
      },
      routes = {
        {
          filter = {
            event = 'notify',
            find = 'No information available',
          },
          opts = {
            skip = true,
          },
        },
      },
      lsp = {
        progress = {
          enabled = true,
          --- @type NoiceFormat|string
          format = 'lsp_progress',
          --- @type NoiceFormat|string
          format_done = 'lsp_progress_done',
          throttle = 1000 / 30, -- frequency to update lsp progress message
          view = 'mini',
        },
        override = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        hover = {
          ---@type NoiceViewOptions
          opts = {
            border = 'rounded',
          },
        },
        signature = {
          ---@type NoiceViewOptions
          opts = { border = 'rounded' },
        },
      },
    })
  end,
}
