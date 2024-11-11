return {
  'nvimdev/dashboard-nvim',
  cmd = 'Dashboard',
  init = function()
    if vim.fn.argc() == 0 then
      vim.schedule(function()
        vim.cmd('Dashboard')
      end)
    end
  end,
  config = function()
    require('dashboard').setup({
      theme = 'hyper',
      disable_move = true,
      shortcut_type = 'number',
      config = {
        week_header = {
          enable = true,
        },
        project = {
          enable = true,
          limit = 4,
          action = function(path)
            local telescope = require('telescope.builtin')
            telescope.find_files({ cwd = path })
          end,
        },
        mru = { limit = 5, cwd_only = true },
        shortcut = {
          { desc = '󰊳 Quit', group = 'Number', action = 'q', key = 'q' },
          { desc = '󰊳 Lazy', group = '@property', action = 'Lazy', key = 'l' },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Find Files',
            group = 'Label',
            action = 'TelescopeFindFiles',
            key = 'f',
          },
          {
            desc = ' File Browser',
            group = 'DiagnosticHint',
            action = function()
              require('mini.files').open()
            end,
            key = 'e',
          },
          {
            desc = ' Restore session',
            group = 'Label',
            action = function()
              require('persistence').load()
            end,
            key = 's',
          },
          {
            desc = ' Config',
            group = 'Number',
            action = 'TelescopeFindConfigFiles',
            key = 'c',
          },
        },
      },
    })
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
