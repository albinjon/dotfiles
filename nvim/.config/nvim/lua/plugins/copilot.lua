return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
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
  end,
}
-- i should
-- vim.keymap.set({ 'n' }, '<leader>cpp', '<cmd>Copilot panel<cr>', { desc = 'copilot [p]anel', noremap = true, silent = true }),
