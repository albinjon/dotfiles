require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  },
  performance = {
    debug = true,
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        -- "matchparen",
        'netrwPlugin',
        'man',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
