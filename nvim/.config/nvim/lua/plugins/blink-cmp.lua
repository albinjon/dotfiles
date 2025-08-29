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
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
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
      ['<Nul>'] = {
        function(cmp)
          cmp.show({ providers = { 'snippets' } })
        end,
      },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      menu = {
        draw = { treesitter = { 'lsp' } },
        auto_show = function(ctx)
          return ctx.mode ~= 'cmdline'
        end,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 800,
        window = {
          border = 'rounded',
        },
      },
    },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        lua = { 'lazydev', inherit_defaults = true },
        markdown = { 'buffer' },
      },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },
  },
  opts_extend = { 'sources.default' },
}
