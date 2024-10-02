return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'BufReadPost',
    cmd = { 'TelescopeFindFiles', 'TelescopeFindConfigFiles' },
    keys = {
      { '<leader>sh', '<cmd>TelescopeHelpTags<cr>', desc = '[s]earch [h]elp' },
      { '<leader>sk', '<cmd>TelescopeKeymaps<cr>', desc = '[s]earch [k]eymaps' },
      { '<leader>cs', '<cmd>TelescopeDocumentSymbols<cr>', desc = '[s]ymbols' },
      { '<leader>cs', '<cmd>TelescopeDocumentSymbolsSelected<cr>', mode = 'v', desc = '[s]ymbols' },
      { '<leader>st', '<cmd>TelescopeBuiltin<cr>', desc = '[s]earch [s]elect Telescope' },
      { '<leader>sw', '<cmd>TelescopeGrepString<cr>', desc = '[s]earch current [w]ord' },
      { '<leader>sg', '<cmd>TelescopeGrepStringSelected<cr>', mode = 'v', desc = '[g]rep selected string' },
      { '<leader>sn', '<cmd>TelescopeNotifications<cr>', desc = '[s]earch [n]otifications' },
      { '<leader>sg', '<cmd>TelescopeLiveGrep<cr>', desc = '[s]earch live [g]rep' },
      { '<leader>s.', '<cmd>TelescopeResume<cr>', desc = '[s]earch resume (.)' },
      { '<leader>fr', '<cmd>TelescopeOldfiles<cr>', desc = '[f]ind [r]ecent Files' },
      { '<leader>ff', '<cmd>TelescopeFindFiles<cr>', desc = '[f]ind [f]iles' },
      { '<leader>ff', '<cmd>TelescopeFindFilesSelected<cr>', mode = 'v', desc = '[f]ind [f]iles' },
      { '<leader><leader>', '<cmd>TelescopeBuffers<cr>', desc = '[ ] Find existing buffers' },
      { '<leader>/', '<cmd>TelescopeCurrentBufferFuzzyFind<cr>', desc = '[/] Fuzzily search in current buffer' },
      { '<leader>s/', '<cmd>TelescopeLiveGrepOpenFiles<cr>', desc = '[s]earch [/] in Open Files' },
      { '<leader>fc', '<cmd>TelescopeFindConfigFiles<cr>', desc = '[f]ind [c]onfig files' },
      { '<leader>sc', '<cmd>TelescopeSearchConfigFiles<cr>', desc = '[s]earch [c]onfig files' },
      { '<leader>sc', '<cmd>TelescopeSearchConfigFilesSelected<cr>', mode = 'v', desc = '[s]earch [c]onfig files' },
      { '<leader>fp', '<cmd>TelescopeFindPluginFiles<cr>', desc = '[f]ind [p]lugin files' },
      { '<leader>sp', '<cmd>TelescopeSearchPluginFiles<cr>', desc = '[s]earch [p]lugin files' },
      { '<leader>sp', '<cmd>TelescopeSearchPluginFilesSelected<cr>', mode = 'v', desc = '[s]earch [p]lugin files' },
    },
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup({
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          mappings = {
            i = {
              ['<c-enter>'] = 'to_fuzzy_refine',
              ['<c-?>'] = 'which_key',
              ['<c-j>'] = 'move_selection_next',
              ['<c-k>'] = 'move_selection_previous',
              ['<c-w>'] = function()
                vim.api.nvim_input('<c-s-w>')
              end,
              ['<Tab>'] = 'toggle_selection',
            },
            n = {
              ['?'] = 'which_key',
              ['<c-j>'] = 'move_selection_next',
              ['<c-k>'] = 'move_selection_previous',
              ['<c-s>j'] = 'file_split',
              ['<c-s>l'] = 'file_vsplit',
              ['<Tab>'] = 'toggle_selection',
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
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

      vim.api.nvim_create_user_command('TelescopeHelpTags', builtin.help_tags, { desc = 'Search help tags' })
      vim.api.nvim_create_user_command('TelescopeKeymaps', builtin.keymaps, { desc = 'Search keymaps' })
      vim.api.nvim_create_user_command('TelescopeDocumentSymbols', builtin.lsp_document_symbols, { desc = 'Symbols' })
      vim.api.nvim_create_user_command('TelescopeDocumentSymbolsSelected', function()
        builtin.lsp_document_symbols({ query = get_selected() })
      end, { desc = 'Symbols (selected)' })
      vim.api.nvim_create_user_command('TelescopeBuiltin', builtin.builtin, { desc = 'Search select Telescope' })
      vim.api.nvim_create_user_command('TelescopeGrepString', builtin.grep_string, { desc = 'Search current word' })
      vim.api.nvim_create_user_command('TelescopeGrepStringSelected', function()
        builtin.grep_string({ search = get_selected() })
      end, { desc = 'Grep selected string' })
      vim.api.nvim_create_user_command(
        'TelescopeNotifications',
        telescope.extensions.notify.notify,
        { desc = 'Search notifications' }
      )
      vim.api.nvim_create_user_command('TelescopeLiveGrep', builtin.live_grep, { desc = 'Search live grep' })
      vim.api.nvim_create_user_command('TelescopeResume', builtin.resume, { desc = 'Search resume' })
      vim.api.nvim_create_user_command('TelescopeOldfiles', builtin.oldfiles, { desc = 'Find recent Files' })
      vim.api.nvim_create_user_command('TelescopeFindFiles', builtin.find_files, { desc = 'Find files' })
      vim.api.nvim_create_user_command('TelescopeFindFilesSelected', function()
        builtin.find_files({ search_file = get_selected(), prompt_title = 'Find files (visual selection)' })
      end, { desc = 'Find files (selected)' })
      vim.api.nvim_create_user_command('TelescopeBuffers', builtin.buffers, { desc = 'Find existing buffers' })
      vim.api.nvim_create_user_command('TelescopeCurrentBufferFuzzyFind', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = 'Fuzzily search in current buffer' })
      vim.api.nvim_create_user_command('TelescopeLiveGrepOpenFiles', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end, { desc = 'Search in Open Files' })
      vim.api.nvim_create_user_command('TelescopeFindConfigFiles', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = 'Find config files' })
      vim.api.nvim_create_user_command('TelescopeSearchConfigFiles', function()
        builtin.live_grep({ cwd = vim.fn.stdpath('config') })
      end, { desc = 'Search config files' })
      vim.api.nvim_create_user_command('TelescopeSearchConfigFilesSelected', function()
        builtin.grep_string({ cwd = vim.fn.stdpath('config'), search = get_selected() })
      end, { desc = 'Search config files (selected)' })
      vim.api.nvim_create_user_command('TelescopeFindPluginFiles', function()
        require('telescope.builtin').find_files({ cwd = require('lazy.core.config').options.root })
      end, { desc = 'Find plugin files' })
      vim.api.nvim_create_user_command('TelescopeSearchPluginFiles', function()
        require('telescope.builtin').live_grep({
          cwd = require('lazy.core.config').options.root,
        })
      end, { desc = 'Search plugin files' })
      vim.api.nvim_create_user_command('TelescopeSearchPluginFilesSelected', function()
        require('telescope.builtin').grep_string({
          cwd = require('lazy.core.config').options.root,
          search = get_selected(),
        })
      end, { desc = 'Search plugin files (selected)' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
