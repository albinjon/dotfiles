return {
  'zbirenbaum/copilot.lua',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup({
      filetypes = {
        dashboard = false,
      },

      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<Tab>',
        },
      },
    })
    local panel = require('copilot.panel')
    vim.keymap.set(
      { 'n' },
      '<leader>cpe',
      '<cmd>Copilot enable<cr>',
      { desc = '[e]nable copilot', noremap = true, silent = true }
    )
    vim.keymap.set(
      { 'n' },
      '<leader>cpd',
      '<cmd>Copilot disable<cr>',
      { desc = '[d]isable copilot', noremap = true, silent = true }
    )
    vim.keymap.set('n', '<leader>cpp', function()
      panel.open({ ratio = 0.5, position = 'right' })
    end, { desc = '[c]o[p]ilot [p]anel' })
    -- create refresh keymap
    vim.keymap.set('n', '<leader>cpr', function()
      panel.refresh()
    end, { desc = '[c]o[p]ilot [r]efresh' })
  end,
}
-- i should
-- vim.keymap.set({ 'n' }, '<leader>cpp', '<cmd>Copilot panel<cr>', { desc = 'copilot [p]anel', noremap = true, silent = true }),
