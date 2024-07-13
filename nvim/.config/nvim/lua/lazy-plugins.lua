-- If starting by Firenvim, skip plugin installation
require('lazy').setup({
  'tpope/vim-sleuth',
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  require('kickstart/plugins/gitsigns'),

  require('kickstart/plugins/vim-kitty-nav'),

  require('kickstart/plugins/which-key'),

  require('kickstart/plugins/telescope'),

  require('kickstart/plugins/lspconfig'),

  require('kickstart/plugins/conform'),

  require('kickstart/plugins/cmp'),

  require('kickstart/plugins/todo-comments'),

  require('kickstart/plugins/mini'),

  require('kickstart/plugins/treesitter'),

  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require('kickstart.plugins.debug'),

  require('kickstart.plugins.lint'),

  require('kickstart.plugins.autopairs'),

  require('kickstart.plugins.neo-tree'),

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
