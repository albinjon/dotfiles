return {
  'saghen/blink.cmp',
  event = 'BufReadPost',
  -- optional: provides snippets for the snippet source
  dependencies = {
    { 'luckasRanarison/tailwind-tools.nvim' },
    { 'rafamadriz/friendly-snippets' },
    {
      'chrisgrieser/nvim-scissors',
      cmd = { 'ScissorsAddNewSnippet', 'ScissorsEditSnippet' },
      dependencies = {
        { 'ibhagwan/fzf-lua' },
        { 'stevearc/dressing.nvim', opts = {} },
      },
      opts = {
        snippetDir = vim.fn.stdpath('config') .. '/snippets',
        editSnippetPopup = {
          keymaps = {
            insertNextPlaceholder = '<C-,>',
            deleteSnippet = '<S-BS>',
            saveChanges = '<leader>ww',
          },
        },
      },
    },
  },
  version = '*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
  opts_extend = { 'sources.default' },
}