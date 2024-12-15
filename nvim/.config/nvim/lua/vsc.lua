local function load_vscode_config()
  vim.g.mapleader = ' ' -- Set space as leader key
  -- This doesnt work.
  -- vim.keymap.set('n', '<leader>ww', [[<cmd>call VSCodeNotify('workbench.action.files.save')<CR>]])
  -- Load only VSCode-relevant plugins
  require('lazy').setup({
    {
      'nvim-treesitter/nvim-treesitter',
      config = function()
        require('nvim-treesitter.configs').setup({
          highlight = { enable = false },
          incremental_selection = { enable = true },
        })
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      event = 'VeryLazy',
    },
  })
end

return {
  load = load_vscode_config,
}
