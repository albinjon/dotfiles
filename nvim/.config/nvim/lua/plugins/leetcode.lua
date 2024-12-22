return {
  'kawre/leetcode.nvim',
  build = ':TSUpdate html', -- if you have `nvim-treesitter` installed
  cmd = 'Leet',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- "ibhagwan/fzf-lua",
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('leetcode').setup({
      lang = 'typescript',
    })
    vim.keymap.set('n', '<leader>L', '<cmd>Leet test<cr>', { desc = 'Leet' })
    vim.keymap.set('n', '<leader>lt', '<cmd>Leet test<cr>', { desc = 'Leet Test' })
    vim.keymap.set('n', '<leader>lf', '<cmd>Leet console<cr>', { desc = 'Leet Console' })
    vim.keymap.set('n', '<leader>li', '<cmd>Leet info<cr>', { desc = 'Leet Info' })
    vim.keymap.set('n', '<leader>ls', '<cmd>Leet submit<cr>', { desc = 'Leet Info' })
  end,
}
