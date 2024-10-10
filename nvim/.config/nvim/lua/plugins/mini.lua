return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup({
        mappings = {
          add = 'sa',
          -- Add surrounding in Normal and Visual modes
          delete = 'sd', -- Delete surrounding
          find = '', -- Find surrounding (to the right)
          find_left = '', -- Find surrounding (to the left)
          highlight = '', -- Highlight surrounding
          replace = 'sr', -- Replace surrounding
          update_n_lines = '', -- Update `n_lines`

          suffix_last = '', -- Suffix to search with "prev" method
          suffix_next = '', -- Suffix to search with "next" method
        },
      })

      local files = require('mini.files')
      files.setup({
        options = {
          permanent_delete = false,
        },
        mappings = {
          close = 'q',
          go_in_plus = '<cr>',
          go_in = '',
          go_out_plus = '<bs>',
          go_out = '',
          mark_goto = "'",
          mark_set = 'm',
          reset = '',
          reveal_cwd = '@',
          show_help = 'g?',
          synchronize = '=',
          trim_left = '<',
          trim_right = '>',
        },
        windows = {
          preview = true,
          width_preview = 120,
        },
      })

      local set_window_options = function(win_id)
        vim.wo[win_id].winblend = 8
        local config = vim.api.nvim_win_get_config(win_id)
        config.border, config.title_pos = 'rounded', 'center'
        config.style = 'minimal'
        vim.api.nvim_win_set_config(win_id, config)
      end

      -- det som behövs:
      -- när man stänger, eller när man kopierat eller deletat så vill jag att det ska skrivas till samma mapp
      -- när man sedan öppnar, eller kanske rättare när man försöker klistra in något, så ska man titta i den
      -- mappen efter saker att klistra in. Mappen behöver rensas, en fråga är när det bästa tillfället för det är.
      -- Man kommer få full file path i antingen from / to. Eftersom det inte kommer genomföras en faktiskt kopiering
      -- kommer jag behöva spara alla kopieringar till samma mapp som alla deletions hamnar på, om jag vill kunna kopiera överallt. Det jag kanske letar efter är egentligen bara smidigare navigation i repot.

      -- fortsätt här:
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionDelete',
        callback = function(args)
          vim.notify(args.data.to)
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowOpen',
        callback = function(args)
          local win_id = args.data.win_id
          set_window_options(win_id)
        end,
      })

      local function split_win(direction)
        local cur_target = files.get_explorer_state().target_window
        local new_target = vim.api.nvim_win_call(cur_target, function()
          vim.cmd(direction .. 'split')
          ---@diagnostic disable-next-line: redundant-return-value
          return vim.api.nvim_get_current_win()
        end)
        files.set_target_window(new_target)
        files.go_in()
        files.close()
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak left-hand side of mapping to your liking
          vim.keymap.set('n', '<c-w>l', function()
            split_win('v')
          end, { desc = 'Open selected file in a new vertical split window', buffer = buf_id })
          vim.keymap.set('n', '<c-w>j', function()
            split_win('')
          end, { desc = 'Open selected file in a new horizontal split window', buffer = buf_id })
          vim.keymap.set('n', '<esc>', function()
            files.close()
          end, { desc = 'close', buffer = buf_id })
          vim.keymap.set('n', '<leader>ww', files.synchronize, { desc = 'sync', buffer = buf_id })
          -- files.refresh({ filter = filter_hide })
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowUpdate',
        callback = function(args)
          vim.wo[args.data.win_id].relativenumber = true
        end,
      })

      require('mini.animate').setup({
        cursor = {
          enable = false,
        },
        scroll = {
          enable = true,
          timing = function(_, n)
            return 40 / n
          end,
        },
        resize = {
          enable = false,
        },
        open = {
          enable = false,
        },
        close = {
          enable = false,
        },
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
