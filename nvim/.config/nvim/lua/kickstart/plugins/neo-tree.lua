-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    {
      '<leader>fe',
      '<cmd>Neotree toggle float reveal_force_cwd<CR>',
      { silent = true },
    },
  },
  config = function()
    require('neo-tree').setup({
      bind_to_cwd = true,
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        mappings = {},
      },
    })
  end,
}
