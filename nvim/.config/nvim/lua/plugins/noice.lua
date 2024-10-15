return {
  {
    'folke/noice.nvim',
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
