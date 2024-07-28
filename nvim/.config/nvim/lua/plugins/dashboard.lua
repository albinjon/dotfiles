return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup({
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          { desc = '󰊳 Quit', group = 'Number', action = 'q', key = 'q' },
          { desc = '󰊳 Lazy', group = '@property', action = 'Lazy', key = 'l' },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Find Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            desc = ' File Browser',
            group = 'DiagnosticHint',
            action = function()
              require('telescope').extensions.file_browser.file_browser({
                select_buffer = true,
                cwd = vim.fn.expand('%:p:h'),
                respect_gitignore = false,
                hidden = true,
              })
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
            action = 'Telescope find_files cwd=' .. vim.fn.stdpath('config'),
            key = 'c',
          },
        },
      },
    })
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
