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
    completion = {
      menu = {
        draw = { treesitter = { 'lsp' } },
        auto_show = function(ctx)
          return ctx.mode ~= 'cmdline'
        end,
      },
      documentation = {
        window = {
          border = 'rounded',
        },
      },
    },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = function()
        local success, node = pcall(vim.treesitter.get_node)
        if vim.bo.filetype == 'lua' then
          return { 'lsp', 'path' }
        elseif vim.bo.filetype == 'markdown' then
          return { 'buffer' }
        elseif success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
          return { 'buffer' }
        else
          return { 'lsp', 'path', 'snippets', 'buffer' }
        end
      end,
    },
  },
  opts_extend = { 'sources.default' },
}
