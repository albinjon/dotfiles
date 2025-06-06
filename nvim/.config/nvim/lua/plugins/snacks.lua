local function get_selected()
  local original_register = vim.fn.getreg('"')
  vim.cmd('normal! "vy')
  local selected_text = vim.fn.getreg('"')
  if original_register == selected_text then
    return
  end
  vim.fn.setreg('"', original_register)
  return selected_text
end

local function find_root_package()
  local root = vim.fs.root(0, 'package.json')
  return root
end

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
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ['<c-w>j'] = { 'edit_split', mode = { 'n' } },
            ['<c-w>l'] = { 'edit_vsplit', mode = { 'n' } },
          },
        },
      },
      formatters = {
        file = {
          truncate = 80,
          filename_first = true,
        },
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
      desc = '[s]how [n]otifications',
    },
    {
      '<leader>qb',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
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
      '<leader>dd',
      function()
        Snacks.terminal('lazydocker', { win = { border = 'rounded' } })
      end,
      desc = 'lazy[d]ocker',
      mode = { 'n' },
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
    -- Picker keys
    {
      '<leader><space>',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>,',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    -- find
    {
      '<leader>fb',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Buffers',
    },
    {
      '<leader>fc',
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath('config'), search = get_selected() })
      end,
      desc = '[f]ind [c]onfig files',
      mode = { 'v', 'n' },
    },
    {
      '<leader>fd',
      function()
        Snacks.picker.files({ cwd = '~/dotfiles', search = get_selected(), hidden = true })
      end,
      desc = '[f]ind [d]otfiles',
      mode = { 'v', 'n' },
    },
    {
      '<leader>ff',
      function()
        Snacks.picker.files({ search = get_selected(), hidden = true })
      end,
      desc = '[f]ind [f]iles',
      mode = { 'v', 'n' },
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.git_files()
      end,
      desc = 'Find Git Files',
    },
    {
      '<leader>fp',
      function()
        Snacks.picker.projects()
      end,
      desc = 'Projects',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Recent',
    },
    -- git
    -- {
    --   '<leader>gb',
    --   function()
    --     Snacks.picker.git_branches()
    --   end,
    --   desc = 'Git Branches',
    -- },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    {
      '<leader>gL',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = 'Git Log Line',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>gS',
      function()
        Snacks.picker.git_stash()
      end,
      desc = 'Git Stash',
    },
    {
      '<leader>gd',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git Diff (Hunks)',
    },
    {
      '<leader>gf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Git Log File',
    },
    -- Grep
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>sB',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Grep Open Buffers',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep({
          search = get_selected(),
          hidden = true,
          ignored = true,
          exclude = { '**/node_modules', '**/dist' },
        })
      end,
      desc = '[s]earch with [g]rep',
      mode = { 'n', 'v' },
    },
    {
      '<leader>sip',
      function()
        Snacks.picker.grep({
          search = get_selected(),
          hidden = true,
          ignored = true,
          cwd = find_root_package(),
          exclude = { '**/node_modules', '**/dist' },
        })
      end,
      desc = '[s]earch with [g]rep',
      mode = { 'n', 'v' },
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    -- search
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = 'Registers',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.search_history()
      end,
      desc = 'Search History',
    },
    {
      '<leader>sa',
      function()
        Snacks.picker.autocmds()
      end,
      desc = 'Autocmds',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.grep({ cwd = vim.fn.stdpath('config'), search = get_selected() })
      end,
      desc = '[s]earch [c]onfig',
      mode = { 'v', 'n' },
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.grep({
          cwd = '~/dotfiles',
          hidden = true,
          search = get_selected(),
        })
      end,
      mode = { 'v', 'n' },
      desc = '[s]earch selected text in [d]otfiles',
    },
    {
      '<leader>sC',
      function()
        Snacks.picker.commands()
      end,
      desc = 'Commands',
    },
    {
      '<leader>se',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Diagnostics',
    },
    {
      '<leader>sE',
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = 'Buffer Diagnostics',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Help Pages',
    },
    {
      '<leader>sH',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'Highlights',
    },
    {
      '<leader>si',
      function()
        Snacks.picker.icons()
      end,
      desc = 'Icons',
    },
    {
      '<leader>sj',
      function()
        Snacks.picker.jumps()
      end,
      desc = 'Jumps',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Keymaps',
    },
    {
      '<leader>sl',
      function()
        Snacks.picker.loclist()
      end,
      desc = 'Location List',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = 'Marks',
    },
    {
      '<leader>sM',
      function()
        Snacks.picker.man({ search = get_selected() })
      end,
      desc = '[s]earch [m]an pages',
      mode = { 'v', 'n' },
    },
    {
      '<leader>sp',
      function()
        Snacks.picker.grep({ cwd = require('lazy.core.config').options.root, search = get_selected() })
      end,
      desc = '[s]earch in [p]lugins',
      mode = { 'v', 'n' },
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = 'Quickfix List',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>su',
      function()
        Snacks.picker.undo()
      end,
      desc = 'Undo History',
    },
    {
      '<leader>uC',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = 'Colorschemes',
    },
    -- LSP
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'gD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = 'Goto Declaration',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'gI',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      'gy',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'Goto T[y]pe Definition',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
    {
      '<leader>sS',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = 'LSP Workspace Symbols',
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
