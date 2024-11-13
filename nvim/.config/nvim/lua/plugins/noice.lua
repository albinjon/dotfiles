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
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        lsp_doc_border = true,
      },
    })
  end,
}
