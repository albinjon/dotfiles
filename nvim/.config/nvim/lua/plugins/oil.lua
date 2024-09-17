return {
  'stevearc/oil.nvim',
  enabled = false,
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    constrain_cursor = 'name',
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<leader>sl'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
      ['<leader>sj'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
      ['<leader>qF'] = {
        function()
          local oil = require('oil')
          oil.discard_all_changes()
          oil.close()
        end,
      },
      ['<leader>qq'] = {
        function()
          local oil = require('oil')
          oil.save()
          oil.close()
        end,
      },
      ['<C-p>'] = 'actions.preview',
      ['q'] = 'actions.close',
      ['<C-q>'] = function()
        local actions = require('oil.actions')
        actions.send_to_qflist.callback()
        local oil = require('oil')
        oil.close()
        vim.cmd('copen')
      end,
      ['<bs>'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
