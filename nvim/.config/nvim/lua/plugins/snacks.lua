return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    zen = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 100 },
        easing = 'linear',
      },
    },
    dashboard = {
      preset = {
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = ' ', key = 'o', desc = 'Find Obsidian Files', action = ':ObsidianSearchAll' },
          { icon = '󰊕 ', key = 'L', desc = 'LeetCode', action = ':Leet' },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'G', desc = 'Git', action = ':lua Snacks.lazygit()' },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = ' ',
            key = 'c',
            desc = 'Config',
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
        header = require('dashboard-ascii'),
      },
    },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        border = 'rounded',
        zindex = 100,
        ft = 'markdown',
        wo = {
          winblend = 0,
          wrap = true,
          conceallevel = 2,
          colorcolumn = '',
        },
        bo = { filetype = 'snacks_notif' },
      },
      scratch = {
        width = 160,
        height = 40,
        bo = { buftype = '', buflisted = false, bufhidden = 'hide', swapfile = false },
        minimal = false,
        noautocmd = false,
        -- position = "right",
        zindex = 20,
        wo = { winhighlight = 'NormalFloat:Normal' },
        border = 'rounded',
        title_pos = 'center',
        footer_pos = 'center',
      },
    },

    scratch = {
      win_by_ft = {
        javascript = {
          keys = {
            ['source'] = {
              '<cr>',
              require('repl').run,
              desc = 'Run',
              mode = { 'n', 'x' },
            },
          },
        },
        typescript = {
          keys = {
            ['source'] = {
              '<cr>',
              require('repl').run,
              desc = 'Run',
              mode = { 'n', 'x' },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<leader>sn',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>qb',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>cR',
      function()
        Snacks.rename.rename_file()
      end,
      desc = 'Rename File',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
    },
    {
      '<leader>gb',
      function()
        Snacks.git.blame_line()
      end,
      desc = 'Git Blame Line',
    },
    {
      '<leader>gf',
      function()
        Snacks.lazygit.log_file()
      end,
      desc = 'Lazygit Current File History',
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit.log()
      end,
      desc = 'Lazygit Log (cwd)',
    },
    {
      '<leader>zm',
      function()
        Snacks.zen.zen()
      end,
      desc = 'Zen Mode',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
    {
      '<M-t>',
      function()
        Snacks.terminal('fish', { win = { border = 'rounded' } })
      end,
      desc = 'Toggle Terminal',
      mode = { 'n', 't' },
    },
    {
      '<M-u>',
      function()
        Snacks.terminal('btop', { win = { border = 'rounded' } })
      end,
      desc = '[t]oggle [b]top',
      mode = { 'n', 't' },
    },
    {
      '<M-q>',
      function()
        Snacks.terminal('lazysql', { win = { border = 'rounded' } })
      end,
      desc = '[t]oggle lazys[q]l',
      mode = { 'n', 't' },
    },
    {
      '<M-r>',
      function()
        Snacks.terminal('posting', { win = { border = 'rounded' } })
      end,
      desc = '[t]oggle posting',
      mode = { 'n', 't' },
    },
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
    {
      '<leader>N',
      desc = 'Neovim News',
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        })
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesActionRename',
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
  end,
}
