local function load_vscode_config()
  -- VSCode-specific keymaps
  vim.g.mapleader = ' ' -- Set space as leader key
  -- vim.keymap.set('n', 'gr', [[<cmd>call VSCodeNotify('editor.action.goToReferences')<CR>]])
  -- vim.keymap.set('n', 'gd', [[<cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>]])
  -- vim.keymap.set('n', '<C>l', [[<cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>]])
  -- vim.keymap.set('n', '<leader>h', '<cmd>lua require('vscode').action("workbench.action.focusLeftGroup")<CR>')
  vim.keymap.set('n', '<C-l>', vim.fn.VSCodeNotify('workbench.action.files.save'), { desc = 'desc' })

  -- This doesnt work.
  -- vim.keymap.set('n', '<leader>ww', [[<cmd>call VSCodeNotify('workbench.action.files.save')<CR>]])
  -- Load only VSCode-relevant plugins
  require('lazy').setup({
    {
      'nvim-treesitter/nvim-treesitter',
      config = function()
        require('nvim-treesitter.configs').setup({
          highlight = { enable = false }, -- Disable highlighting as VSCode handles it
          incremental_selection = { enable = true },
        })
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      event = 'VeryLazy',
    },
    -- Add other VSCode-compatible plugins here
  })
end

return {
  load = load_vscode_config,
}
