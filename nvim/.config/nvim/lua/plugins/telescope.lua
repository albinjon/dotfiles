-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local fb_actions = require('telescope').extensions.file_browser.actions
      require('telescope').setup({
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          mappings = {
            i = {
              ['<c-enter>'] = 'to_fuzzy_refine',
              ['<c-i>'] = 'which_key',
              ['<c-j>'] = 'move_selection_next',
              ['<c-k>'] = 'move_selection_previous',
              ['<M-BS>'] = { '<C-W>', type = 'command' },
              ['<Tab>'] = 'toggle_selection',
            },
            n = {
              ['<c-i>'] = 'which_key',
              ['<c-j>'] = 'move_selection_next',
              ['<c-k>'] = 'move_selection_previous',
              ['<leader>sj'] = 'file_split',
              ['<leader>sl'] = 'file_vsplit',
              ['<Tab>'] = 'toggle_selection',
              ['<bs>'] = fb_actions.goto_parent_dir,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },

          file_browser = {
            -- hijack_netrw = true,
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local function get_selected()
        local original_register = vim.fn.getreg('"')
        vim.cmd('normal! "vy')
        local selected_text = vim.fn.getreg('"')
        vim.fn.setreg('"', original_register)
        return selected_text
      end

      -- See `:help telescope.builtin`
      local builtin = require('telescope.builtin')
      local telescope = require('telescope')
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
      vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = '[s]earch [s]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
      vim.keymap.set('v', '<leader>sg', function()
        builtin.grep_string({ search = get_selected() })
      end, { desc = '[g]rep visually selected string' })
      vim.keymap.set('n', '<leader>sn', telescope.extensions.notify.notify, { desc = '[s]earch [n]otifications' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[s]earch live [g]rep' })
      vim.keymap.set('n', '<leader>s.', builtin.resume, { desc = '[s]earch resume (.)' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[f]ind [r]ecent Files' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]ind [f]iles' })
      vim.keymap.set('v', '<leader>ff', function()
        builtin.find_files({ search_file = get_selected(), prompt_title = 'Find files (visual selection)' })
      end, { desc = '[f]ind [f]iles' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end, { desc = '[s]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>fc', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[f]ind [c]onfig files' })

      vim.keymap.set('n', '<leader>sc', function()
        builtin.live_grep({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[s]earch [c]onfig files' })

      vim.keymap.set('n', '<leader>fp', function()
        require('telescope.builtin').find_files({ cwd = require('lazy.core.config').options.root })
      end, { desc = '[f]ind [p]lugin files' })

      vim.keymap.set('n', '<leader>sp', function()
        require('telescope.builtin').live_grep({
          cwd = require('lazy.core.config').options.root,
        })
      end, { desc = '[s]earch [p]lugin files' })

      vim.keymap.set('v', '<leader>sp', function()
        require('telescope.builtin').grep_string({
          cwd = require('lazy.core.config').options.root,
          search = get_selected(),
        })
      end, { desc = '[s]earch [p]lugin files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
