local function get_selected()
  local original_register = vim.fn.getreg('"')
  vim.cmd('normal! "vy')
  local selected_text = vim.fn.getreg('"')
  vim.fn.setreg('"', original_register)
  return selected_text
end

return {
  'ibhagwan/fzf-lua',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
  },
  keys = {
    {
      '<leader>sh',
      function()
        require('fzf-lua').help_tags()
      end,
      desc = '[s]earch [h]elp',
    },
    {
      '<leader>sk',
      function()
        require('fzf-lua').keymaps()
      end,
      desc = '[s]earch [k]eymaps',
    },
    {
      '<leader>cs',
      function()
        require('fzf-lua').lsp_document_symbols()
      end,
      desc = '[s]ymbols',
    },
    {
      '<leader>st',
      function()
        require('fzf-lua').builtin()
      end,
      desc = '[s]earch [s]elect',
    },
    {
      '<leader>sw',
      function()
        require('fzf-lua').grep_cword()
      end,
      desc = '[s]earch current [w]ord',
    },
    {
      '<leader>sc',
      function()
        require('fzf-lua').live_grep({ cwd = vim.fn.stdpath('config') })
      end,
      desc = '[s]earch live [g]rep',
    },
    {
      '<leader>sc',
      function()
        require('fzf-lua').live_grep({ cwd = vim.fn.stdpath('config'), query = get_selected() })
      end,
      mode = 'v',
      desc = '[s]earch live [g]rep',
    },
    {
      '<leader>sg',
      function()
        require('fzf-lua').live_grep()
      end,
      desc = '[s]earch live [g]rep',
    },
    {
      '<leader>s.',
      function()
        require('fzf-lua').resume()
      end,
      desc = '[s]earch resume (.)',
    },
    {
      '<leader>fr',
      function()
        require('fzf-lua').oldfiles()
      end,
      desc = '[f]ind [r]ecent Files',
    },
    {
      '<leader>ff',
      function()
        require('fzf-lua').files()
      end,
      desc = '[f]ind [f]iles',
    },
    {
      '<leader>ff',
      function()
        require('fzf-lua').files({ query = get_selected() })
      end,
      mode = 'v',
      desc = '[f]ind [f]iles matching selection',
    },
    {
      '<leader><leader>',
      function()
        require('fzf-lua').buffers()
      end,
      desc = '[ ] Find existing buffers',
    },
    {
      '<leader>/',
      function()
        require('fzf-lua').blines()
      end,
      desc = '[/] Fuzzily search in current buffer',
    },
    {
      '<leader>sf',
      function()
        require('fzf-lua').live_grep({ query = vim.fn.expand('%:t') })
      end,
      desc = '[s]earch for current file',
    },
    {
      '<leader>s/',
      function()
        require('fzf-lua').grep_project()
      end,
      desc = '[s]earch [/] in Open Files',
    },
    {
      '<leader>fc',
      function()
        require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })
      end,
      desc = '[f]ind [c]onfig files',
    },
    {
      '<leader>fc',
      function()
        require('fzf-lua').files({
          cwd = vim.fn.stdpath('config'),
          query = get_selected(),
        })
      end,
      mode = 'v',
      desc = '[f]ind [c]onfig files matching selection',
    },
    {
      '<leader>fd',
      function()
        require('fzf-lua').files({ cwd = '~/dotfiles' })
      end,
      desc = '[f]ind [d]otfiles',
    },
    {
      '<leader>fd',
      function()
        require('fzf-lua').files({
          cwd = '~/dotfiles',
          query = get_selected(),
        })
      end,
      mode = 'v',
      desc = '[f]ind [d]otfiles matching selection',
    },
    {
      '<leader>fp',
      function()
        require('fzf-lua').files({ cwd = require('lazy.core.config').options.root })
      end,
      desc = '[f]ind [p]lugin files',
    },
    {
      '<leader>fp',
      function()
        require('fzf-lua').files({
          cwd = require('lazy.core.config').options.root,
          query = get_selected(),
        })
      end,
      mode = 'v',
      desc = '[f]ind [p]lugin files matching selection',
    },
    {
      '<leader>sw',
      function()
        require('fzf-lua').grep_visual()
      end,
      mode = 'v',
      desc = '[s]earch selected [w]ord',
    },
    {
      '<leader>sg',
      function()
        require('fzf-lua').grep_visual()
      end,
      mode = 'v',
      desc = '[s]earch selected text with [g]rep',
    },
    {
      '<leader>sc',
      function()
        require('fzf-lua').grep_visual({ cwd = vim.fn.stdpath('config') })
      end,
      mode = 'v',
      desc = '[s]earch selected text in [c]onfig',
    },
    {
      '<leader>sd',
      function()
        require('fzf-lua').grep_visual({ cwd = '~/dotfiles' })
      end,
      mode = 'v',
      desc = '[s]earch selected text in [d]otfiles',
    },
    {
      '<leader>sp',
      function()
        require('fzf-lua').grep_visual({ cwd = require('lazy.core.config').options.root })
      end,
      mode = 'v',
      desc = '[s]earch selected text in [p]lugins',
    },
    {
      '<leader>sp',
      function()
        require('fzf-lua').live_grep({ cwd = require('lazy.core.config').options.root })
      end,
      desc = '[s]earch selected text in [p]lugins',
    },
  },
  config = function()
    local actions = require('fzf-lua.actions')
    -- Define exclude patterns
    local rg_exclude_patterns = {
      '--glob=!.git',
      '--glob=!.venv',
      '--glob=!venv/',
      '--glob=!.cache',
      '--glob=!**/fish/functions/**',
      '--glob=!.DS_Store',
      '--glob=!Music/',
      '--glob=!Library/',
      '--glob=!Applications/',
      '--glob=!.npm/',
      '--glob=!.docker/',
      '--glob=!.cursor/',
      '--glob=!.local/',
      '--glob=!Movies/',
      '--glob=!.vscode/',
      '--glob=!go/pkg',
      '--glob=!.pyenv/',
      '--glob=!Pictures/',
      '--glob=!.prettierd/',
      '--glob=!.pgadmin/',
      '--glob=!.runelite/',
      '--glob=!.dap/',
    }

    -- Build the find command with exclude patterns
    local find_command = {
      'rg',
      '--files',
      '--hidden',
      '--follow',
      unpack(rg_exclude_patterns),
    }

    -- Build the grep command with exclude patterns
    local vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--follow',
      unpack(rg_exclude_patterns),
    }

    require('fzf-lua').register_ui_select()

    require('fzf-lua').setup({
      'telescope', -- Use telescope-like UI and keybindings
      lsp = {
        code_actions = {
          previewer = 'codeaction_native',
          preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
        },
      },
      winopts = {
        height = 0.90,
        width = 0.90,
      },
      keymap = {
        builtin = {
          false,
          ['<C-d>'] = 'preview-page-down',
          ['<C-u>'] = 'preview-page-up',
          ['<C-j>'] = 'next-history',
          ['<C-k>'] = 'previous-history',
          ['<C-a>'] = 'select-all',
          -- ['<C-q>'] = 'accept',
          ['<C-cr>'] = actions.help,
        },
      },
      actions = {
        files = {
          ['default'] = actions.file_edit,
          ['ctrl-s'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          ['ctrl-t'] = actions.file_tabedit,
          ['ctrl-q'] = { fn = actions.file_sel_to_qf, prefix = 'select-all' },
        },
      },
      files = {
        cmd = table.concat(find_command, ' '),
      },
      grep = {
        cmd = table.concat(vimgrep_arguments, ' '),
      },
    })
  end,
}
