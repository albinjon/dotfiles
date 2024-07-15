return {
  'github/copilot.vim',
  vim.keymap.set({ 'n' }, '<leader>cpe', '<cmd>Copilot enable<cr>', { desc = '[e]nable copilot', noremap = true, silent = true }),
  vim.keymap.set({ 'n' }, '<leader>cpd', '<cmd>Copilot disable<cr>', { desc = '[d]isable copilot', noremap = true, silent = true }),
  -- vim.keymap.set({ 'n' }, '<leader>cpp', '<cmd>Copilot panel<cr>', { desc = 'copilot [p]anel', noremap = true, silent = true }),
}
